_bashmarks() {
  COMPREPLY=()
  local word="${COMP_WORDS[COMP_CWORD]}"

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=( $(compgen -W "$(bashmarks commands)" -- "$word") )
  else
    local command="${COMP_WORDS[1]}"
    local completions="$(bashmarks completions "$command")"
    COMPREPLY=( $(compgen -W "$completions" -- "$word") )
  fi
}

complete -F _bashmarks bashmarks
