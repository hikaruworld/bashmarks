if [[ ! -o interactive ]]; then
    return
fi

compctl -K _bashmarks bashmarks

_bashmarks() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(bashmarks commands)"
  else
    completions="$(bashmarks completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
