#!/bin/bash

needs() {
  (
  if [[ `type -t $1` ]]
  then
    $@
  else
    echo "Error: Cannot find dependency '$1'"
    exit 1
  fi

  if [[ `type -t is_met` ]] && ! is_met
  then
    if [[ `type -t meet` ]]
    then
      meet
    fi

    if ! is_met
    then
      echo "Error: Dependency '$1' not met"
      exit 1
    fi
  fi
  )
}

needs $@
