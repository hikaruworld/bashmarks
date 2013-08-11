
# _setup
function _l {
  if [ ! -n "$SDIRS" ]; then
      SDIRS=~/.sdirs
  fi
  touch $SDIRS  
  source $SDIRS
  env | grep "^DIR_" | cut -c5- | sort | grep "^.*=" | cut -f1 -d "=" 
}

_bashmarks() {
  COMPREPLY=()
  local word="${COMP_WORDS[COMP_CWORD]}"

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=( $(compgen -W "$(bashmarks commands)" -- "$word") )
  else
    local command="${COMP_WORDS[1]}"
    if [ "$command" = "jump" ]; then
      local curw="${COMP_WORDS[2]}"
      COMPREPLY=($(compgen -W '`_l`' -- $curw))
    else
      local completions="$(bashmarks completions "$command")"
      COMPREPLY=( $(compgen -W "$completions" -- "$word") )
    fi
  fi
}

complete -F _bashmarks bashmarks
