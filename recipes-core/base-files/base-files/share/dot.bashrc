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
alias jctl='journalctl -f -o short-monotonic --no-hostname'
alias jgrep='journalctl -b --no-hostname | grep'
alias jgrepall='journalctl --no-hostname | grep'
alias sstat='systemctl status -l -n 25 --no-pager'

# stromer specific aliases
alias version='/bin/cat /etc/medusa-version'
