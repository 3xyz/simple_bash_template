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

progress_print() {
  echo -ne "\r" >&2
  echo -n "$1"
  # This part needed to fix background progress by spaces filling
  # You can comment part below and see what you got
  let progress_length=70-$(echo $1 | wc -c)
  if (( $progress_length > 0 )); then
    spaces=$(head -c $progress_length < /dev/zero | tr '\0' ' ')
    echo -n "$spaces" >&2
    echo
  else
    echo
  fi
}
