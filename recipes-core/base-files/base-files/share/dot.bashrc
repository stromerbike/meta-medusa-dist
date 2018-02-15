PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# enable color support of ls and also add handy aliases
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias systemctl='systemctl --no-pager'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# some systemd aliases
alias jgrep='journalctl | grep'
alias sstat='systemctl status -l -n25'

# stromer specific aliases
alias version='/bin/cat /etc/medusa-version'
alias ui='/usr/bin/medusa/DiagnosticUi/DiagnosticUi /usr/bin/medusa/TargetIpcConfiguration.json /usr/bin/medusa/DiagnosticUi/config.json'
