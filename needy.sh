#!/bin/bash

N_arr_branches=()
N_branch_depth=-1

N_PASS="\033[1m[\033[32mok\033[0;1m]\033[0m"
N_FAIL="\033[1m[\033[31mfail\033[0;1m]\033[0m"

N_exit_on_error() {
  set -e
  $@
  set +e
}

N_include_dep() {
  if ! N_is_defined $1
  then
    paths=("$PWD/deps/$1.sh" "$HOME/needy-deps/$1.sh")
    for path in $paths
    do
      if [[ -f $path ]]
      then
        source $path
        break
      fi
    done
  fi
}

N_push_branch() {
  ((N_branch_depth++))
  N_arr_branches+=($1)
}

N_is_defined() {
  type -t $1 >/dev/null
}

N_draw_branch() {
  if [[ $N_branch_depth -gt 0 ]]
  then
    N_draw_branch_down ""

    for ((i=0; i<N_branch_depth-1; i++))
    do
      echo -n "| "
    done

    echo -n "+-"
  fi

  echo -e "+ \033[1m$1\033[0m"
}

N_draw_branch_down() {
  for ((i=0; i<N_branch_depth; i++))
  do
    echo -n "| "
  done
  echo -e $1
}

N_draw_pass() {
  N_draw_branch_down "| "
  N_draw_branch_down "\\ $N_PASS $1"
}

N_draw_fail() {
  N_draw_branch_down "| "
  N_draw_branch_down "\\ $N_FAIL $1"
}

N_fail_unwind() {
  for ((; N_branch_depth>=0; N_branch_depth--))
  do
    N_draw_fail ${N_arr_branches[$N_branch_depth]}
  done

  echo "Error: $1"
  exit 1
}

needs() {
  (
  N_push_branch $1
  N_draw_branch $1
  N_include_dep $1

  if N_is_defined $1
  then
    N_exit_on_error $@
  else
    N_fail_unwind "Cannot find dependency '$1'"
  fi

  if N_is_defined is_met && ! is_met
  then
    if N_is_defined meet
    then
      meet
    fi

    if ! is_met
    then
      N_fail_unwind "Dependency '$1' not met"
    fi
  fi

  N_draw_pass $1

  unset $1
  unset is_met
  unset meet
  )
}

needs $@
