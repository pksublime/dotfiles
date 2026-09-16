# Vendored from `gauntlet completion zsh` — anodize-inc/gauntlet @ 113bc5e plus
# the unmerged `completion` subcommand (DSW-481). Regenerate or delete this file
# once upstream ships completion of its own.
#
# What it fixes: zsh does not split words on ':', so without a completion for gl
# the transport prefix in a target reference (dir:, docker-archive:, docker://,
# oci://, file://) makes the whole token read as one filename and tab produces
# nothing. compset -P in _gauntlet_target moves the prefix into IPREFIX so only
# the path part is completed.
#
# Note: bare `gl` is oh-my-zsh's git alias (git pull), so it completes as git --
# gauntlet is invoked by path (aos-integration/bin/gl), and zsh falls back to the
# basename for path-qualified commands, which is why `gl` stays in the compdef.

_gauntlet_transports() {
  compadd -S '' -- dir: docker-archive: docker:// oci:// file://
}

_gauntlet_target() {
  # A transport prefix is part of the same zsh word as the path that follows it.
  # compset -P moves the matched prefix into IPREFIX so only the remainder is
  # completed; without this the whole 'dir:path' token is treated as a filename.
  if compset -P 'dir:' || compset -P 'oci://'; then
    _files -/
    return
  fi
  if compset -P 'docker-archive:' || compset -P 'file://'; then
    _files
    return
  fi
  if compset -P 'docker://'; then
    _message -e references 'image reference'
    return
  fi
  _alternative \
    'transports:transport prefix:_gauntlet_transports' \
    'targets:target path or image reference:_files'
}

_gauntlet() {
  local -a _subcommands
  _subcommands=(
    'run:Run test suites against a target system'
    'list-tests:Discover and evaluate test parameter sweep for execution'
    'list-suites:Discover and inspect test suites across directories or OCI images'
    'tag:Create server-side tag aliases for an OCI container image'
    'install-cli:Emit a host wrapper script (bin/gl) pinned to this Gauntlet container image'
    'completion:Emit a shell completion script for the gl CLI'
    'check-suite:Statically validate and lint test suite definitions (*.gauntlet.json)'
    'check-target:Inspect and statically validate target image artifacts and labels'
    'runs:Manage, synchronize, and query Gauntlet test runs and benchmark metrics'
  )
  local curcontext="$curcontext" state line
  _arguments -s -C \
    '--temp-dir[Directory for temporary extractions and overlay disks (default: system temp / TMPDIR)]:temp_dir:_files -/' \
    '1:command:->command' \
    '*::arg:->args'
  case $state in
    command)
      _describe -t commands 'gauntlet command' _subcommands
      ;;
    args)
      case $words[1] in
        run) _gauntlet_run ;;
        list-tests) _gauntlet_list_tests ;;
        list-suites) _gauntlet_list_suites ;;
        tag) _gauntlet_tag ;;
        install-cli) _gauntlet_install_cli ;;
        completion) _gauntlet_completion ;;
        check-suite) _gauntlet_check_suite ;;
        check-target) _gauntlet_check_target ;;
        runs) _gauntlet_runs ;;
      esac
      ;;
  esac
}

_gauntlet_run() {
  _arguments -s \
    '--system[Execution system to use (default: qemu)]:system:(qemu remote local)' \
    '--log-dir[Directory to store test logs (default: logs)]:log_dir:_files -/' \
    '--temp-dir[Directory for temporary extractions and overlay disks (default: system temp / TMPDIR)]:temp_dir:_files -/' \
    '*--var[Bind test variable or pin sweep parameter (KEY=VALUE)]:variables: ' \
    '*-v[Bind test variable or pin sweep parameter (KEY=VALUE)]:variables: ' \
    '*--exclude[Exclude directory patterns during search (default: '\''.*,node_modules'\'')]:exclude: ' \
    '--quiet[Suppress output]' \
    '-f[Stop execution on first failure]' \
    '--failfast[Stop execution on first failure]' \
    '--assert-no-skips[Fail the test run if any tests were skipped]' \
    '--run-prefix[Custom prefix category/handle for the execution run ID (e.g. '\''ci_gha'\'' or '\''dev_user'\'')]:run_prefix: ' \
    ':target:_gauntlet_target' \
    '*:suites:_files'
}

_gauntlet_list_tests() {
  _arguments -s \
    '*--target[Target OCI image reference or local tarball containing target assets (can be specified multiple times)]:targets:_gauntlet_target' \
    '--system[Execution system to use (default: qemu)]:system:(qemu remote local)' \
    '--log-dir[Directory to store test logs (default: logs)]:log_dir:_files -/' \
    '--temp-dir[Directory for temporary extractions (default: system temp / TMPDIR)]:temp_dir:_files -/' \
    '*--var[Bind test variable or pin sweep parameter (KEY=VALUE)]:variables: ' \
    '*-v[Bind test variable or pin sweep parameter (KEY=VALUE)]:variables: ' \
    '*--exclude[Exclude directory patterns during search (default: '\''.*,node_modules'\'')]:exclude: ' \
    '--format[Output format for discovered test matrix (default: json)]:format:(json text)' \
    '*:suites:_files'
}

_gauntlet_list_suites() {
  _arguments -s \
    '--ready[Filter for only ready-to-execute suites]' \
    '--not-ready[Filter for only unbuilt source suites requiring build]' \
    '--kind[Filter by suite storage kind]:kind:(directory oci-context oci-archive oci-layout oci-image)' \
    '--image-prefix[Registry repository prefix for generated image references (e.g. ghcr.io/org/suites)]:image_prefix: ' \
    '--image-tag[OCI image tag to append to image references (default: latest)]:image_tag: ' \
    '--temp-dir[Directory for temporary extractions (default: system temp / TMPDIR)]:temp_dir:_files -/' \
    '*--exclude[Exclude directory patterns during search (default: '\''.*,node_modules'\'')]:exclude: ' \
    '--format[Output format (default: text)]:format:(text json)' \
    '*:paths:_files'
}

_gauntlet_tag() {
  _arguments -s \
    ':image:_gauntlet_target' \
    '*:tags: '
}

_gauntlet_install_cli() {
  _arguments -s \
    '--image[Override the container image reference in the generated script]:image:_gauntlet_target'
}

_gauntlet_completion() {
  _arguments -s \
    ':shell:(zsh)'
}

_gauntlet_check_suite() {
  _arguments -s \
    '--temp-dir[Directory for temporary extractions (default: system temp / TMPDIR)]:temp_dir:_files -/' \
    '*--exclude[Exclude directory patterns during search (default: '\''.*,node_modules'\'')]:exclude: ' \
    '--format[Output reporting format (default: text)]:format:(text json)' \
    '--quiet[Suppress output on success]' \
    '*:suite_dirs:_files'
}

_gauntlet_check_target() {
  _arguments -s \
    '--system[Target backend system to validate against (optional)]:system:(qemu remote local)' \
    '--temp-dir[Directory for temporary extractions (default: system temp / TMPDIR)]:temp_dir:_files -/' \
    '--format[Output reporting format (default: text)]:format:(text json)' \
    '--quiet[Suppress output on success]' \
    ':target:_gauntlet_target'
}

_gauntlet_runs() {
  local -a _subcommands
  _subcommands=(
    'list:List test execution runs'
    'push:Publish a specific run to remote logs repository'
    'pull:Pull latest logs from remote repository'
    'sql:Query DuckDB virtual log views'
  )
  local curcontext="$curcontext" state line
  _arguments -s -C \
    '1:command:->command' \
    '*::arg:->args'
  case $state in
    command)
      _describe -t commands 'gauntlet command' _subcommands
      ;;
    args)
      case $words[1] in
        list) _gauntlet_runs_list ;;
        push) _gauntlet_runs_push ;;
        pull) _gauntlet_runs_pull ;;
        sql) _gauntlet_runs_sql ;;
      esac
      ;;
  esac
}

_gauntlet_runs_list() {
  _arguments -s \
    '--dir[Override log directory location]:dir:_files -/' \
    '-n[Maximum number of runs to display]:limit: ' \
    '--limit[Maximum number of runs to display]:limit: ' \
    '--format[Output format (default: table)]:format:(table plain json jsonl)' \
    '--latest[Output only the single latest run ID]' \
    '--local[Local runs only (default for --latest)]' \
    '--ci[CI runner runs only]' \
    '--all[All runs overall (default for list)]'
}

_gauntlet_runs_push() {
  _arguments -s \
    '--latest[Push latest local run]' \
    '--dir[Override log directory location]:dir:_files -/' \
    '--repo[Target git repository URL (enables zero-copy in-place publishing)]:repo: ' \
    ':run_id: '
}

_gauntlet_runs_pull() {
  _arguments -s \
    '--dir[Override log directory location]:dir:_files -/'
}

_gauntlet_runs_sql() {
  _arguments -s \
    '*-p[Bind named parameter ($key) in SQL query (KEY=VALUE)]:params: ' \
    '*--param[Bind named parameter ($key) in SQL query (KEY=VALUE)]:params: ' \
    '--dir[Override log directory location]:dir:_files -/' \
    '--format[Output format (default: table)]:format:(table json jsonl csv tsv)' \
    '--schema[Display virtual view schemas and recipe examples]' \
    ':query: '
}

compdef _gauntlet gl gauntlet
