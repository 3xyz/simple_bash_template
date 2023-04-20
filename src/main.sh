#!/usr/bin/env bash

# Collor tags
gray="\033[1;30m"
blue="\033[34m"
yellow="\033[40m"
red="\033[31m"
bold="\033[1m"
normal="\033[0m"

main() {
  trap terminate INT   # Handle Ctrl-C
  trap terminate QUIT  # Handle Ctrl-\\
  trap terminate TSTP  # Handle Ctrl-Z
  trap terminate EXIT
  # Import files
  source "$(project_path)/our_main_funcs.sh"
  source "$(project_path)/progress_bar.sh"
  source "$(project_path)/error.sh"
  # Parsing options
  parse_args "$@"
}

parse_args() {
  for i in $(seq 1 $#); do
    case ${@:$i:1} in
      -d|--domain)
        DOMAIN="${@:$i+1:1}"
        check_single_domain "$DOMAIN"
        shift
        ;;
      -f|--file)
        DOMAINS_FILE="${@:$i+1:1}"
        check_file "$DOMAINS_FILE"
        chack_domains_from_file "$DOMAINS_FILE"
        shift
        ;;
      -h|--help)
        help_message
        ;;
      -*|--*)
        error "unknown option ${bold}${@:$i:1}"
        ;;
      *)
        ;;
    esac
  done
}

# Check for file exists (just example)
check_file() {
  if ! [[ -f $1 ]]; then
    error "no such file ($1)"
  fi
}

# Relative path to project
project_path() {
  SOURCE=${BASH_SOURCE[0]}
  while [ -L "$SOURCE" ]; do
    DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
    SOURCE=$(readlink "$SOURCE")
    [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE
  done
  DIR=$( cd -P "$( dirname "$SOURCE" )" > /dev/null 2>&1 && pwd )
  echo $DIR
}

# We can handle terminating for remove temp files for example
terminate() {
  printf "\n ${bold}${red}Terminated\n"
  exit 1
}

# Start
main "$@"
