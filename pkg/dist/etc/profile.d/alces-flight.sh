################################################################################
##
## Flight Runway
## Copyright (c) 2019 Alces Flight Ltd
##
################################################################################
export flight_ROOT=${flight_ROOT:-/opt/flight}
if [ -d ${flight_ROOT}/etc/profile.d ]; then
  # record the value of errexit
  if [ "${-#*e}" != "$-" ]; then
    _errexit_set=true
  fi
  shopt -s nullglob
  for i in ${flight_ROOT}/etc/profile.d/*.sh ; do
    if [ -r "$i" ]; then
      # Ensure flight profile can't cause errexit
      set +e
      if [ "${-#*i}" != "$-" ]; then
        . "$i"
      else
        . "$i" >/dev/null 2>&1
      fi
    fi
  done
  shopt -u nullglob
  if [ "${_errexit_set}" == "true" ]; then
    set -e
  fi
  unset i _set_errexit
fi
