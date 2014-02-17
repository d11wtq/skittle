#!/bin/bash

example() {
  is_met() {
    [[ -f ./example.txt ]]
  }

  meet() {
    touch ./example.txt
  }

  other() {
    is_met() {
      [[ -f ./other.txt ]]
    }

    meet() {
      touch ./other.txt
    }
  }

  requires other
}

requires() {
  (
  if [[ `type -t $1` ]]
  then
    $@
  else
    echo "Error: Cannot find dependency $1"
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
      echo "Error: Dependency $1 still not met"
      exit 1
    fi
  fi
  )
}

requires $@
