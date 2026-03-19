# ── make tab completion: correct expanded targets, cached ──────────────────
_make_cached_targets() {
  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh-make-completion"
  mkdir -p "$cache_dir"
  local key
  key=$(printf '%s' "$PWD" | cksum | awk '{print $1}')
  local cache="$cache_dir/$key"

  local stale=0 f
  if [[ ! -f $cache ]]; then
    stale=1
  else
    for f in Makefile makefile GNUmakefile mk/**/*.mk(N) *.mk(N); do
      [[ -f $f && $f -nt $cache ]] && { stale=1; break }
    done
  fi

  if (( stale )); then
    make -qp 2>/dev/null | awk '
      /^# Not a target:/ { skip=1; next }
      /^[^#\t ][^=]*:/ {
        if ($0 ~ /:=/) { skip=0; next }
        if (!skip) {
          t = $0
          sub(/:.*/, "", t)
          gsub(/^[[:space:]]+|[[:space:]]+$/, "", t)
          if (length(t) > 0 && t !~ /^\./ && t !~ /\$/ && t !~ /[[:space:]]/ && t !~ /%/)
            print t
        }
        skip=0; next
      }
      { skip=0 }
    ' | sort -u > "$cache"
  fi

  cat "$cache"
}

_make() {
  local targets expl
  if [[ -f Makefile || -f makefile || -f GNUmakefile ]]; then
    targets=("${(f)$(_make_cached_targets)}")
    _wanted targets expl 'make target' compadd -a targets
  fi
}
compdef _make make
# ──────────────────────────────────────────────────────────────────────────
