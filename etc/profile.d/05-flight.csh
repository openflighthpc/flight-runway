################################################################################
##
## Flight Runway
## Copyright (c) 2019-present Alces Flight Ltd
##
################################################################################
set prefix=""
set postfix=""

if ( $?histchars ) then
  set histchar = `echo $histchars | cut -c1`
  set _histchars = $histchars

  set prefix  = 'unset histchars;'
  set postfix = 'set histchars = $_histchars;'
else
  set histchar = \!
endif

if ($?prompt) then
  set prefix  = "$prefix"'set _prompt="$prompt";set prompt="";'
  set postfix = "$postfix"'set prompt="$_prompt";unset _prompt;'
endif

if ($?noglob) then
  set prefix  = "$prefix""set noglob;"
  set postfix = "$postfix""unset noglob;"
endif
set postfix = "set _exit="'$status'"; $postfix; test 0 = "'$_exit;'

alias flight $prefix'$flight_ROOT/bin/flight \!*; '$postfix
alias fl $prefix'$flight_ROOT/bin/flight \!*; '$postfix
alias flexec $prefix'$flight_ROOT/bin/flexec \!*; '$postfix
alias flactivate $prefix'$flight_ROOT/bin/flactivate \!*; '$postfix
alias flintegrate $prefix'$flight_ROOT/bin/flintegrate \!*; '$postfix

unset prefix
unset postfix
