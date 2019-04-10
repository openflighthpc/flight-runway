################################################################################
##
## Flight Runway
## Copyright (c) 2019-present Alces Flight Ltd
##
################################################################################
flight() {
  ${flight_ROOT}/bin/flight "$@"
}

fl() {
  flight "$@"
}

flactivate() {
  ${flight_ROOT}/bin/flactivate
}

flexec() {
  if [ -z "$1" ]; then
    echo "flexec: usage: flexec <command> [<arg>...]"
    return 1
  elif [ -x "${flight_ROOT}/bin/$1" ]; then
    "${flight_ROOT}/bin/$1" "${@:2}"
    return $?
  else
    echo "flexec: not found: $1" 1>&2
    return 1
  fi
}

flintegrate() {
  ${flight_ROOT}/bin/flintegrate "$@"
}

export -f flight fl flexec flactivate flintegrate
