# reset-prj-opencode.zsh — revoke OpenCode's stored permissions for a project.
#
# "Allow always" in a permission prompt is durable: it is saved as a
# project-scoped `allow` rule that outranks a configured `ask`, so editing
# opencode.json does not get the prompts back. There is no `opencode permission`
# subcommand and no bulk endpoint, so this drives the two real operations
# (permission.saved.list / permission.saved.remove) through `opencode api`.
#
# The directory -> project mapping comes from GET /api/location, whose
# `location` parameter is an OpenAPI deepObject: it must be written as
# `location[directory]=/abs/path` in the URL. `--param location=...` is rejected.
#
# Usage:
#   reset-prj-opencode [dir] [-a ACTION] [-n] [-y] [-h]
#
#   dir          Project directory to reset (default: $PWD). Any path inside a
#                project works; it resolves up to the project root.
#   -a ACTION    Only remove grants with this action (edit, shell, read, glob,
#                grep, subagent, skill, webfetch, websearch, question,
#                execute, external_directory, <server>_<tool>).
#   -n, --dry-run   List what would be removed, remove nothing.
#   -y, --yes       Skip the confirmation prompt.
#
# Configured `deny` rules and `policies` are never touched, and they still win
# over anything re-approved later.

_reset_prj_opencode_usage() {
  local src=${funcsourcetrace[1]%:*}
  if [[ -r $src ]]; then
    awk '/^#/ { sub(/^# ?/, ""); print; next } { exit }' "$src"
  else
    print 'Usage: reset-prj-opencode [dir] [-a ACTION] [-n] [-y] [-h]'
  fi
}

reset-prj-opencode() {
  emulate -L zsh
  setopt localoptions pipefail

  local dir='' action='' dry_run=0 assume_yes=0

  while (( $# )); do
    case "$1" in
      -a|--action)
        (( $# >= 2 )) || { print -u2 "reset-prj-opencode: $1 needs a value"; return 2 }
        action=$2; shift 2 ;;
      --action=*) action=${1#*=}; shift ;;
      -n|--dry-run) dry_run=1; shift ;;
      -y|--yes) assume_yes=1; shift ;;
      -h|--help) _reset_prj_opencode_usage; return 0 ;;
      -*) print -u2 "reset-prj-opencode: unknown option: $1"; return 2 ;;
      *) dir=$1; shift ;;
    esac
  done

  for cmd in opencode jq; do
    command -v $cmd >/dev/null 2>&1 || {
      print -u2 "reset-prj-opencode: requires '$cmd' on PATH"; return 127
    }
  done

  [[ -n $dir ]] || dir=$PWD
  dir=${~dir:A}
  [[ -d $dir ]] || { print -u2 "reset-prj-opencode: not a directory: $dir"; return 2 }

  # Directory -> project. Probing a path OpenCode has never seen makes it create
  # a project row, so bail out on non-directories above rather than here.
  local loc
  if ! loc=$(opencode api get "/api/location?location[directory]=$dir" 2>&1); then
    print -u2 "reset-prj-opencode: could not resolve a project for $dir"
    print -u2 -- "$loc"
    return 1
  fi

  local pid root
  pid=$(print -r -- "$loc" | jq -r '.project.id // empty')
  root=$(print -r -- "$loc" | jq -r '.project.canonical // .project.directory // empty')
  [[ -n $pid ]] || {
    print -u2 "reset-prj-opencode: no project id in the response for $dir"
    print -u2 -- "$loc"
    return 1
  }

  print "location  $dir"
  print "project   $pid"
  print "root      $root"

  local saved
  if ! saved=$(opencode api permission.saved.list --param "projectID=$pid" 2>&1); then
    print -u2 "reset-prj-opencode: permission.saved.list failed"
    print -u2 -- "$saved"
    return 1
  fi

  # An error body can still arrive with exit 0; verify the shape before
  # concluding "nothing stored" from an unparseable response.
  print -r -- "$saved" | jq -e '.data | type == "array"' >/dev/null 2>&1 || {
    print -u2 "reset-prj-opencode: unexpected permission.saved.list response"
    print -u2 -- "$saved"
    return 1
  }

  # "<id>\t<action> <resource>" per grant, optionally filtered by action.
  local -a grants=()
  local line
  while IFS= read -r line; do
    [[ -n $line ]] && grants+=("$line")
  done < <(print -r -- "$saved" | jq -r --arg a "$action" '
      .data[]?
      | select($a == "" or .action == $a)
      | "\(.id)\t\(.action) \(.resource)"')

  if (( ${#grants} == 0 )); then
    print "no stored permissions${action:+ for action '$action'} for this project"
    return 0
  fi

  print "${#grants} stored grant(s) to remove:"
  local g
  for g in $grants; do print "  ${g//$'\t'/  }"; done

  if (( dry_run )); then
    print "(dry run — nothing removed)"
    return 0
  fi

  if (( ! assume_yes )); then
    local answer
    read -r "answer?remove ${#grants} grant(s)? [y/N] " || return 1
    [[ $answer == [yY] || $answer == [yY][eE][sS] ]] || { print 'aborted'; return 1 }
  fi

  local -i removed=0 failed=0
  for g in $grants; do
    local id=${g%%$'\t'*}
    if opencode api permission.saved.remove --param "id=$id" 2>/dev/null; then
      (( removed++ ))
    else
      (( failed++ ))
      print -u2 "  failed to remove: ${g#*$'\t'}"
    fi
  done

  print "removed $removed grant(s), $failed failed"
  (( failed == 0 ))
}
