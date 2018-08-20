PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# enable color support
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# some systemd aliases
alias jgrep='f(){ unset -f f; if [ -z $2 ]; then UNIT=""; else UNIT="-u $2"; fi; if [ -z $3 ]; then OUTPUT=""; else OUTPUT="-o $3"; fi; journalctl -b --no-hostname --no-pager $OUTPUT $UNIT | grep --line-buffered "$1" | ccze -A; }; f'
alias jgrepf='f(){ unset -f f; if [ -z $2 ]; then UNIT=""; else UNIT="-u $2"; fi; if [ -z $3 ]; then OUTPUT=""; else OUTPUT="-o $3"; fi; journalctl -b -f --no-hostname --no-pager $OUTPUT $UNIT | grep --line-buffered "$1" | ccze -A; }; f'
alias jgrepall='f(){ unset -f f; if [ -z $2 ]; then UNIT=""; else UNIT="-u $2"; fi; if [ -z $3 ]; then OUTPUT=""; else OUTPUT="-o $3"; fi; journalctl --no-hostname --no-pager $OUTPUT $UNIT | grep --line-buffered "$1" | ccze -A; }; f'
alias lnav='f(){ unset -f f; if [ -z $1 ]; then UNIT=""; else UNIT="-u $1"; fi; if [ -z $2 ]; then OUTPUT=""; else OUTPUT="-o $2"; fi; bash -c "lnav <(journalctl -b --no-hostname --no-pager $OUTPUT $UNIT)"; }; f'
alias lnavf='f(){ unset -f f; if [ -z $1 ]; then UNIT=""; else UNIT="-u $1"; fi; if [ -z $2 ]; then OUTPUT=""; else OUTPUT="-o $2"; fi; bash -c "lnav <(journalctl -b -f --no-hostname --no-pager $OUTPUT $UNIT)"; }; f'
alias lnavall='f(){ unset -f f; if [ -z $1 ]; then UNIT=""; else UNIT="-u $1"; fi; if [ -z $2 ]; then OUTPUT=""; else OUTPUT="-o $2"; fi; bash -c "lnav <(journalctl --no-hostname --no-pager $OUTPUT $UNIT)"; }; f'
alias sstat='systemctl status -l -n 25 --no-pager'

# stromer specific aliases
alias version='/bin/cat /etc/medusa-version'
