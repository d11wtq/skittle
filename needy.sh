#!/bin/bash

arr_branches=()
num_branches=0

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

  branch_down() {
    for (( i=0; i<num_branches; i++ ))
    do
      echo -n "| "
    done
    echo -e $1
  }

  branch() {
    num_branches=${#arr_branches[@]}
    arr_branches+=($1)

    if [[ $num_branches -gt 0 ]]
    then
      branch_down ""

      for (( i=0; i<num_branches-1; i++ ))
      do
        echo -n "| "
      done

      echo -n "+-"
    fi

    echo -e "+ \033[1m$1\033[0m"
  }

  pass() {
    branch_down "| "
    branch_down "+ \033[1m[\033[32mok\033[0;1m]\033[0m $1"
  }

  fail() {
    branch_down "| "
    branch_down "+ \033[1m[\033[31mfail\033[0;1m]\033[0m $1"
  }

  fail_unwind() {
    for ((; num_branches>=0; num_branches--))
    do
      fail ${arr_branches[$num_branches]}
    done

    echo "Error: $1"
    exit 1
  }

  (
  branch $1
  load_dep $1

  if [[ `type -t $1` ]]
  then
    exit_on_error $@
  else
    fail_unwind "Cannot find dependency '$1'"
  fi

  if [[ `type -t is_met` ]] && ! is_met
  then
    if [[ `type -t meet` ]]
    then
      meet
    fi

    if ! is_met
    then
      fail_unwind "Error: Dependency '$1' not met"
    fi
  fi

  pass $1

  unset $1
  unset is_met
  unset meet
  )
}

needs $@
