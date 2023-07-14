#!/usr/bin/env bash

random_emoji() {
  emoji=(👿 👺 😫 😅 🤌)
  echo ${emoji[$RANDOM % ${#emoji[@]}]}
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
