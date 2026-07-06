# bklink — print a shareable, no-account signed URL for a Buildkite artifact.
#
# Resolves the artifact's temporary buildkiteartifacts.com (S3 pre-signed) URL
# and prints it. The link needs no Buildkite login and carries no API token;
# it expires on its own (~10 min for Buildkite-hosted storage).
#
# Auth: reuses the token stored by `bk configure` (~/.config/bk.yaml).
#       Override with $BK_TOKEN / $BK_ORG / $BK_PIPELINE if needed.
# Deps: curl, jq. Install `yq` for robust config parsing (grep fallback otherwise).
#
# Usage: bklink <build#> <artifact-name-substring> [pipeline-slug]

_bk_cfg="${BK_CONFIG:-$HOME/.config/bk.yaml}"

# REST token: explicit $BK_TOKEN wins, else pull from bk's config.
_bk_token() {
  [[ -n "$BK_TOKEN" ]] && { printf '%s' "$BK_TOKEN"; return; }
  [[ -r "$_bk_cfg" ]] || { echo "run 'bk configure' first (or set BK_TOKEN)" >&2; return 1; }
  if command -v yq >/dev/null 2>&1; then
    yq -r '.. | (.rest_api_token? // .api_token? // .token?) | select(.)' "$_bk_cfg" 2>/dev/null | head -1
  else
    grep -iE '(rest_api_token|api_token|token):' "$_bk_cfg" \
      | grep -vi graphql | head -1 | sed -E 's/.*:[[:space:]]*//; s/["'\'']//g'
  fi
}

# Org slug: explicit $BK_ORG wins, else bk's selected org.
_bk_org() {
  [[ -n "$BK_ORG" ]] && { printf '%s' "$BK_ORG"; return; }
  if command -v yq >/dev/null 2>&1; then
    yq -r '.selected_org // .organization // .org // empty' "$_bk_cfg" 2>/dev/null | head -1
  else
    grep -iE '(selected_org|organization|org):' "$_bk_cfg" | head -1 | sed -E 's/.*:[[:space:]]*//; s/["'\'']//g'
  fi
}

bklink() {
  local build="$1" match="$2" pipeline="${3:-${BK_PIPELINE:-aos}}"
  if [[ -z "$build" || -z "$match" ]]; then
    echo "usage: bklink <build#> <artifact-name> [pipeline]" >&2; return 2
  fi
  local tok org; tok=$(_bk_token) || return 1; org=$(_bk_org)
  [[ -z "$tok" || -z "$org" ]] && { echo "couldn't resolve token/org — set BK_TOKEN / BK_ORG" >&2; return 1; }

  local base="https://api.buildkite.com/v2/organizations/$org/pipelines/$pipeline"
  local hits
  hits=$(curl -sf -H "Authorization: Bearer $tok" "$base/builds/$build/artifacts" \
    | jq -r --arg m "$match" '.[] | select(.path|test($m)) | "\(.path)\t\(.download_url)"')
  [[ -z "$hits" ]] && { echo "no artifact matching '$match' on build $build ($org/$pipeline)" >&2; return 1; }

  local n; n=$(printf '%s\n' "$hits" | grep -c .)
  (( n > 1 )) && printf 'note: %d matches\n' "$n" >&2
  printf '%s\n' "$hits" | while IFS=$'\t' read -r path url; do
    local signed
    signed=$(curl -sfI -H "Authorization: Bearer $tok" "$url" \
      | grep -i '^location:' | sed 's/^[Ll]ocation:[[:space:]]*//I' | tr -d '\r')
    (( n > 1 )) && printf '# %s\n' "$path"
    printf '%s\n' "$signed"
  done
}
