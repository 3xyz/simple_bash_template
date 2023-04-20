# Simple bash template

Simple bash template for simple tool developing.


## main.sh

```bash
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
```

## our_main_funcs.sh

```bash
#!/usr/bin/env bash

echo_domain() {
  echo $1
}

chack_domains_from_file() { 
  domains_count=$(wc -l "$1")
  processed=0
  while read line; do 
    progress_bar $processed $domains_count
    if is_alive "$line"; then
      progress_print "$line"
    fi
    let processed++
  done < "$1"

  info "Good bye!"
}

check_single_domain() {
  if is_alive "$1"; then
    echo_domain "$1"
  else
    error "domain ($1) not alive"
  fi
}

# Check for DNS records
is_alive() {
  if host "$1" > /dev/null; then
    return 0
  else 
    return 1
  fi
}
```

## progress_bar.sh

```bash
#!/usr/bin/env bash

progress_bar() {
  let _progress=(${1}*100/${2}*100)/100
  let _done=(${_progress}*4)/10
  let _left=40-$_done
  _fill=$(printf "%${_done}s")
  _empty=$(printf "%${_left}s")
  echo -ne "\r ${blue}${_fill// /━}${gray}${_empty// /━} ${normal}${1}/${2}" >&2
  if [[ $1 == $2 ]]; then
    echo "{bold} Finished" >&2
  fi
}

# This func needed to fill background progress by spaces
progress_print() {
  echo -ne "\r" >&2
  echo -n "$1"
  let progress_length=70-$(echo $1 | wc -c)
  if (( $progress_length > 0 )); then
    spaces=$(head -c $progress_length < /dev/zero | tr '\0' ' ')
    echo -n "$spaces" >&2
    echo
  else
    echo
  fi
}
```

## error.sh 

```bash 
#!/usr/bin/env bash

random_emoji() {
  emoji="👺 😫 😅 🤌"
  index=$(shuf -i 1-5 -n 1)
  echo "$(echo $emoji | cut -d ' ' -f $index)"
}

info() {
  echo -e " ${bold}${blue}Info:${normal} $1" >&2
}

warning() {
  echo -e " ${bold}${orange}Warning:${normal} $1" >&2
}

error() {
  echo -e " $(random_emoji) ${red}${bold}Error:${normal} $1" >&2
  exit 1
}

help_message() {
  echo -e "${bold}Description:${normal}"
  echo "  This tool checks the domain for DNS records."
  echo
  echo -e "${bold}Flags:${normal}"
  echo "  -d, --domain    domain"
  echo "  -f, --file      file"
  echo "  -h, --help      Show this help"
}
```
