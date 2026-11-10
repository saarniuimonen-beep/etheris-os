# Etheris OS
alias ls='ls --color=auto'
alias ll='ls -lah'
alias grep='grep --color=auto'
alias eth='etheris'

export EDITOR=micro
export VISUAL=micro

if [[ $- == *i* ]]; then
  fastfetch --logo-type small 2>/dev/null || true
fi
