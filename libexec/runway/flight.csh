################################################################################
##
## Flight Runway
## Copyright (c) 2019-present Alces Flight Ltd
##
################################################################################

if ("$1" != "") then
  set cmd=`$flight_ROOT/bin/flight --resolve stop`
  alias | grep ^flight_$cmd >/dev/null
  if ($? == 0) then
    eval "flight_$cmd ${argv[2-]}"
    eval "unset cmd; bash -c 'exit $?'"
  else
    unset cmd
    flexec flight $argv
  endif
else
  flexec flight $argv
endif
