# bklink — print a shareable, no-account signed URL for a Buildkite artifact.
#
# Resolves the artifact's temporary buildkiteartifacts.com (S3 pre-signed) URL
# and prints it. The link needs no Buildkite login and carries no API token;
# it expires on its own (~10 min for Buildkite-hosted storage).
#
# Intended to run on build01 (where `bk` is configured), but only needs curl+jq.
#
# Auth:
#   - Org  : auto-read from bk's ~/.config/bk.yaml (selected_org). Override: $BK_ORG.
#   - Token: bk 3.x keeps the token in the OS keyring, not the config file, so it
#            can't be reused here. Create a Buildkite API access token with
#            read_builds + read_artifacts and put it in ~/.bklink.env (private):
#              export BK_TOKEN=bkua_xxxxxxxx
# Deps: curl, jq. (`yq` used for config parsing if present.)
#
# Usage: bklink <pipeline-slug> <build#> <artifact-name-substring>

# Load private credentials if present (keep ~/.bklink.env out of any repo).
[[ -f ~/.bklink.env ]] && source ~/.bklink.env

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
  local pipeline="$1" build="$2" match="$3"
  if [[ -z "$pipeline" || -z "$build" || -z "$match" ]]; then
    echo "usage: bklink <pipeline-slug> <build#> <artifact-name>" >&2; return 2
  fi
  local tok org; tok=$(_bk_token 2>/dev/null); org=$(_bk_org)
  [[ -z "$org" ]] && { echo "no org — set BK_ORG or run 'bk configure'" >&2; return 1; }
  [[ -z "$tok" ]] && { echo "no token — create a Buildkite API token (read_builds, read_artifacts) and set BK_TOKEN in ~/.bklink.env" >&2; return 1; }

  local base="https://api.buildkite.com/v2/organizations/$org/pipelines/$pipeline"
  local hits
  hits=$(curl -sf -H "Authorization: Bearer $tok" "$base/builds/$build/artifacts" \
    | jq -r --arg m "$match" '.[] | select(.path|test($m)) | "\(.path)\t\(.download_url)"')
  [[ -z "$hits" ]] && { echo "no artifact matching '$match' on build $build ($org/$pipeline)" >&2; return 1; }

  local n; n=$(printf '%s\n' "$hits" | grep -c .)
  (( n > 1 )) && printf 'note: %d matches\n' "$n" >&2
  # NB: do NOT name a variable `path` here — in zsh it's tied to $PATH and would
  # clobber it. Use `apath`.
  printf '%s\n' "$hits" | while IFS=$'\t' read -r apath url; do
    local signed
    signed=$(curl -sfI -H "Authorization: Bearer $tok" "$url" \
      | grep -i '^location:' | sed 's/^[Ll]ocation:[[:space:]]*//I' | tr -d '\r')
    (( n > 1 )) && printf '# %s\n' "$apath"
    printf '%s\n' "$signed"
  done
}
