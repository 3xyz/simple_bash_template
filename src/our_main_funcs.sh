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
