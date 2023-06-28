#!/bin/bash

RC="~/.bashrc"

QUOTE="'"

config='''

alias "c"="clear"
alias "py"="python3"
alias "down"="docker compose down"
alias "up"="docker compose up -d --build"
alias "patch"="down && up"

BLUE="\[\033[1;34m\]"
GREEN="\[\033[1;32m\]"
RED="\[\033[31m\]"
END="\[\033[00m\]"

EXITSTATUS="\`if [ \$? = 0 ]; then echo '${GREEN}'; else echo '${RED}'; fi\`"

BLUE="\[\033[1;34m\]"
GREEN="\[\033[1;32m\]"
RED="\[\033[31m\]"
END="\[\033[00m\]"

EXITSTATUS="\`if [ \$? = 0 ]; then echo '${QUOTE}'${GREEN}'${QUOTE}'; else echo '${QUOTE}'${RED}'${QUOTE}'; fi\`"

export PS1="${EXITSTATUS}\u${END}:${BLUE}\w${END}$ "
'''

echo "${config}" >> $RC
