#!/usr/bin/env bash

echo_domain() {
  echo $1
}

chack_domains_from_file() { 
  domains_count=$(wc -l "$1")
  processed=0
  while read line; do 
    progress_bar $processed $domains_count
    if host "$line" > /dev/null; then
      progress_print "$line"
    fi
    let processed++
  done < "$1"

  info "Good bye!"
}
