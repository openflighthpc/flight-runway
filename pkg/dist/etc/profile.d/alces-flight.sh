################################################################################
##
## Flight Runway
## Copyright (c) 2019 Alces Flight Ltd
##
################################################################################
export flight_ROOT=${flight_ROOT:-/opt/flight}
if [ -d ${flight_ROOT}/etc/profile.d ]; then
  for i in ${flight_ROOT}/etc/profile.d/*.sh ; do
    if [ -r "$i" ]; then
      if [ "${-#*i}" != "\$-" ]; then
        . "$i"
      else
        . "$i" >/dev/null 2>&1
      fi
      # Ensure no flight profile leave errors on
      set +e
    fi
  done
  unset i
fi
