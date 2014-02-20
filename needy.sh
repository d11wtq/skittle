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

    echo "+ $1"
  }

  pass() {
    true
  }

  fail() {
    true
  }

  (
  branch $1
  load_dep $1

  if [[ `type -t $1` ]]
  then
    exit_on_error $@
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

  unset $1
  unset is_met
  unset meet
  )
}

needs $@
