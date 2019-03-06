################################################################################
##
## Flight Runway
## Copyright (c) 2019 Alces Flight Ltd
##
################################################################################
if (! $?flight_ROOT) then
  setenv flight_ROOT=/opt/flight
endif
if ( -d $flight_ROOT/etc/profile.d ) then
  set nonomatch
  foreach i ( $flight_ROOT/etc/profile.d/*.csh )
    if ( -r "$i" ) then
      if ($?prompt) then
        source "$i"
      else
        source "$i" >& /dev/null
      endif
    endif
  end
  unset i nonomatch
endif
