################################################################################
##
## Flight Runway
## Copyright (c) 2019-present Alces Flight Ltd
##
################################################################################
flight() {
  flexec flight "$@"
}

fl() {
  flight "$@"
}

flactivate() {
  flexec flactivate
}

flexec() {
  if [ -z "$1" ]; then
    echo "flexec: usage: flexec <command> [<arg>...]"
    return 1
  elif [ -x "${flight_ROOT}/bin/$1" ]; then
    if [ "${-#*i}" != "$-" ]; then
      flight_MODE=interactive
    else
      flight_MODE=batch
    fi
    flight_MODE=${flight_MODE} "${flight_ROOT}/bin/$1" "${@:2}"
    return $?
  else
    echo "flexec: not found: $1" 1>&2
    return 1
  fi
}

flintegrate() {
  flexec flintegrate "$@"
}

export -f flight fl flexec flactivate flintegrate
