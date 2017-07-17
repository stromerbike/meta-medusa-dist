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

# stromer specific aliases
alias rc='/usr/bin/medusa/RecordCommander/RecordCommander /usr/bin/medusa/TargetIpcConfiguration.json'
alias ui='/usr/bin/medusa/EnergyBusControllerUi/EnergyBusControllerUi /usr/bin/medusa/TargetIpcConfiguration.json /usr/bin/medusa/EnergyBusControllerUi/configEnergyBusControllerUi.json'
