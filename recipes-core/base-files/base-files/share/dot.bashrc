PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# locale setting
export LANG=en_US.UTF-8

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
alias jgrep='f(){ unset -f f; if [ -z $2 ]; then UNIT=""; else UNIT="-u $2"; fi; if [ -z $3 ]; then OUTPUT=""; else OUTPUT="-o $3"; fi; journalctl -a -b --no-hostname --no-pager $OUTPUT $UNIT | grep --line-buffered "$1" | ccze -A -o nolookups; }; f'
alias jgrepf='f(){ unset -f f; if [ -z $2 ]; then UNIT=""; else UNIT="-u $2"; fi; if [ -z $3 ]; then OUTPUT=""; else OUTPUT="-o $3"; fi; journalctl -a -b -f --no-hostname --no-pager $OUTPUT $UNIT | grep --line-buffered "$1" | ccze -A -o nolookups; }; f'
alias jgrepm='f(){ unset -f f; if [ -z $2 ]; then OUTPUT=""; else OUTPUT="-o $2"; fi; journalctl -a -b --no-hostname --no-pager $OUTPUT -u medusa-* | grep --line-buffered "$1" | ccze -A -o nolookups; }; f'
alias jgrepall='f(){ unset -f f; if [ -z $2 ]; then UNIT=""; else UNIT="-u $2"; fi; if [ -z $3 ]; then OUTPUT=""; else OUTPUT="-o $3"; fi; journalctl -a --no-hostname --no-pager $OUTPUT $UNIT | grep --line-buffered "$1" | ccze -A -o nolookups; }; f'
alias lnav='f(){ unset -f f; if [ -z $1 ]; then UNIT=""; else UNIT="-u $1"; fi; bash -c "TERM=xterm-256color lnav <(journalctl -a -b -o json --no-pager --output-fields=MESSAGE,PRIORITY,_PID,SYSLOG_IDENTIFIER,_SYSTEMD_UNIT $UNIT; journalctl -a -b -f -n 0 -o json --no-pager --output-fields=MESSAGE,PRIORITY,_PID,SYSLOG_IDENTIFIER,_SYSTEMD_UNIT $UNIT)"; }; f'
alias lnavf='f(){ unset -f f; if [ -z $1 ]; then UNIT=""; else UNIT="-u $1"; fi; bash -c "TERM=xterm-256color lnav <(journalctl -a -b -f -o json --no-pager --output-fields=MESSAGE,PRIORITY,_PID,SYSLOG_IDENTIFIER,_SYSTEMD_UNIT $UNIT)"; }; f'
alias lnavm='f(){ unset -f f; bash -c "TERM=xterm-256color lnav <(journalctl -a -b -o json --no-pager --output-fields=MESSAGE,PRIORITY,_PID,SYSLOG_IDENTIFIER,_SYSTEMD_UNIT -u medusa-*; journalctl -a -b -f -n 0 -o json --no-pager --output-fields=MESSAGE,PRIORITY,_PID,SYSLOG_IDENTIFIER,_SYSTEMD_UNIT -u medusa-*)"; }; f'
alias lnavall='f(){ unset -f f; if [ -z $1 ]; then UNIT=""; else UNIT="-u $1"; fi; bash -c "TERM=xterm-256color lnav <(journalctl -a -o json --no-pager --output-fields=MESSAGE,PRIORITY,_PID,SYSLOG_IDENTIFIER,_SYSTEMD_UNIT $UNIT; journalctl -a -f -n 0 -o json --no-pager --output-fields=MESSAGE,PRIORITY,_PID,SYSLOG_IDENTIFIER,_SYSTEMD_UNIT $UNIT)"; }; f'
alias sstat='systemctl status -l -n 25 --no-pager'

# some various aliases
alias ccat='f(){ unset -f f; cat "$@" | ccze -A -o nolookups; }; f'
alias cless='f(){ unset -f f; ccze -A -o nolookups < "$@" | less -R; }; f'
alias ctail='f(){ unset -f f; tail -f "$@" | ccze -A -o nolookups; }; f'

# stromer specific aliases
alias version='/bin/cat /etc/medusa-version'
