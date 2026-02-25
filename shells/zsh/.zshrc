# ~/.zshrc

### --------------------------------------------------
###  Core shell options
### --------------------------------------------------

# History
HISTFILE=${HOME}/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

setopt \
  APPEND_HISTORY \
  INC_APPEND_HISTORY \
  SHARE_HISTORY \
  HIST_IGNORE_DUPS \
  HIST_IGNORE_SPACE \
  HIST_FIND_NO_DUPS \
  HIST_SAVE_NO_DUPS \
  HIST_REDUCE_BLANKS

# Better cd navigation
setopt \
  AUTO_CD \
  AUTO_PUSHD \
  PUSHD_IGNORE_DUPS

### --------------------------------------------------
###  Init system
### --------------------------------------------------

autoload -Uz compinit promptinit add-zle-hook-widget
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit -i
else
  compinit -C
fi

promptinit

# Prompt
prompt suse

### --------------------------------------------------
###  Completion
### --------------------------------------------------

zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

### --------------------------------------------------
###  Keymap setup
### --------------------------------------------------

# Use emacs-style keys unless you enjoy suffering
bindkey -e

typeset -gA key

# Base keys
key=(
  Home        "${terminfo[khome]}"
  End         "${terminfo[kend]}"
  Insert      "${terminfo[kich1]}"
  Backspace   "${terminfo[kbs]}"
  Delete      "${terminfo[kdch1]}"
  Up          "${terminfo[kcuu1]}"
  Down        "${terminfo[kcud1]}"
  Left        "${terminfo[kcub1]}"
  Right       "${terminfo[kcuf1]}"
  PageUp      "${terminfo[kpp]}"
  PageDown    "${terminfo[knp]}"
  Shift-Tab   "${terminfo[kcbt]}"
  Ctrl-Left   "${terminfo[kLFT5]}"
  Ctrl-Right  "${terminfo[kRIT5]}"
)

# Helper: bind if key exists
bind_if() {
  local k="$1" fn="$2"
  [[ -n "$k" ]] && bindkey -- "$k" "$fn"
}

# Navigation
bind_if "$key[Home]"  beginning-of-line
bind_if "$key[End]"   end-of-line
bind_if "$key[Left]"  backward-char
bind_if "$key[Right]" forward-char

# Editing
bind_if "$key[Backspace]" backward-delete-char
bind_if "$key[Delete]"    delete-char
bind_if "$key[Insert]"    overwrite-mode

# History movement (predictable search)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bind_if "$key[Up]"   up-line-or-beginning-search
bind_if "$key[Down]" down-line-or-beginning-search

# Buffer
bind_if "$key[PageUp]"   beginning-of-buffer-or-history
bind_if "$key[PageDown]" end-of-buffer-or-history

# Completion
bind_if "$key[Shift-Tab]" reverse-menu-complete

# Word jumps
bind_if "$key[Ctrl-Left]"  backward-word
bind_if "$key[Ctrl-Right]" forward-word

### --------------------------------------------------
###  ZLE terminal mode fix
### --------------------------------------------------

if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
  zle-line-init()  { echoti smkx }
  zle-line-finish(){ echoti rmkx }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

### --------------------------------------------------
### Alias
### --------------------------------------------------

# ---- Smart aliases with fallback ----

# ls → eza if available, otherwise ls
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first --icons --git'
else
  if ls --color=auto >/dev/null 2>&1; then
    alias ls='ls --color=auto'
  else
    alias ls='ls -G'
  fi
fi

# cat → bat if available, otherwise cat
if command -v bat >/dev/null 2>&1; then
  alias cat='bat'
elif command -v batcat >/dev/null 2>&1; then
  # Debian/Ubuntu like to rename it because reasons
  alias cat='batcat'
fi

alias grep='grep --color=auto'

# Kitty clear fix
[[ $TERM == xterm-kitty ]] && alias clear='printf "\e[H\e[3J"'

### --------------------------------------------------
###  Plugins
### --------------------------------------------------

# Syntax highlighting (must be last)
for f in \
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
do
  [[ -f $f ]] && source $f && break
done
