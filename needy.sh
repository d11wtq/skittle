#!/bin/bash

needs() {
  load_dep() {
    if [[ ! `type -t $1` ]]
    then
      if [[ -f "$PWD/deps/$1.sh" ]]
      then
        source "$PWD/deps/$1.sh"
      fi
    fi
  }

  exit_on_error() {
    set -e
    $@
    set +e
  }

  branch() {
    [[ -z $depth ]] && depth=0 || (( depth++ ))

    if [[ $depth -gt 0 ]]
    then
      for (( i=0; i<depth; i++ ))
      do
        echo -n "| "
      done
      echo

      for (( i=0; i<depth-1; i++ ))
      do
        echo -n "| "
      done

      echo -n "+-"
    fi

    echo -e "+ \033[1m$1\033[0m"
  }

  pass() {
    for (( i=0; i<depth; i++ ))
    do
      echo -n "| "
    done
    echo "| "
    for (( i=0; i<depth; i++ ))
    do
      echo -n "| "
    done
    echo -e "+ \033[1m[\033[32mok\033[0;1m]\033[0m $1"
  }

  fail() {
    for (( i=0; i<depth; i++ ))
    do
      echo -n "| "
    done
    echo "| "
    for (( i=0; i<depth; i++ ))
    do
      echo -n "| "
    done
    echo -e "+ \033[1m[\033[31mfail\033[0;1m]\033[0m $1"
  }

  (
  branch $1
  load_dep $1

  if [[ `type -t $1` ]]
  then
    exit_on_error $@
  else
    fail $1
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
      fail $1
      echo "Error: Dependency '$1' not met"
      exit 1
    fi
  fi

  pass $1

  unset $1
  unset is_met
  unset meet
  )
}

needs $@
