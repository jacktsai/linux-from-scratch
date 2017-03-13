#!/tools/bin/bash
export SHELL=/bin/bash
export CLICOLOR=true
alias ll="ls -l"
export PS1='\e[42m[ \u@\h: \w ]\e[m\n\$ '
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin
stty cols 125 rows 45

export CFLAGS="-march=native -O2 -pipe"
export CXXFLAGS="$CFLAGS"
export MAKEOPTS="-j8"
export MAKEFLAGS="-j8"
