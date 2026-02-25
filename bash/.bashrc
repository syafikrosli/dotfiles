# ~/.bashrc

### --------------------------------------------------
###  Interactive guard
### --------------------------------------------------

[[ $- != *i* ]] && return

set -o noclobber
set -o pipefail

### --------------------------------------------------
###  History
### --------------------------------------------------

HISTFILE="${HOME}/.bash_history"
HISTSIZE=5000
HISTFILESIZE=10000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE='ls:cd:pwd:exit:clear'
HISTTIMEFORMAT='%F %T '

shopt -s histappend cmdhist autocd cdspell lithist
PROMPT_COMMAND=(
  "history -a"
  "history -n"
)

### --------------------------------------------------
###  Shell behavior
### --------------------------------------------------

# Fix terminal resize issue
shopt -s checkwinsize

# Better globbing
shopt -s globstar dotglob

# Prevent Ctrl-S terminal freeze
stty -ixon 2>/dev/null

### --------------------------------------------------
###  Environment
### --------------------------------------------------

# PATH: prepend ~/.local/bin once
path_prepend() {
  local p="$1"
  case ":$PATH:" in
    *":$p:"*) ;;
    *) PATH="$p:$PATH" ;;
  esac
}

[[ -d "$HOME/.local/bin" ]] && path_prepend "$HOME/.local/bin"
export PATH

export EDITOR="nvim"
export VISUAL="nvim"
export LESS='-R -F -X'

### --------------------------------------------------
###  Aliases
### --------------------------------------------------

# Enable normal override behaviour
alias overwrite='>|'

# Only alias if command exists
has() { command -v "$1" >/dev/null 2>&1; }

# ls
if has eza; then
  alias ls='eza --group-directories-first --icons --git'
else
  alias ls='ls --color=auto'
fi

# cat
if has bat; then
  alias cat='bat'
elif has batcat; then
  alias cat='batcat'   # Debian/Ubuntu naming circus
fi

# grep
alias grep='grep --color=auto'

# Kitty clear fix
[[ $TERM == xterm-kitty ]] && alias clear='printf "\e[H\e[3J"'

### --------------------------------------------------
###  Prompt
### --------------------------------------------------

# Show exit code if non-zero
__prompt_exit() {
  local s=$1
  [[ $s != 0 ]] && printf " (%s)" "$s"
}

PS1='[\u@\h \W]$(__prompt_exit $?)\$ '

# Source bash completion (if available)
if [[ -r /usr/share/bash-completion/bash_completion ]]; then
  source /usr/share/bash-completion/bash_completion
elif [[ -r /etc/bash_completion ]]; then
  source /etc/bash_completion
fi
