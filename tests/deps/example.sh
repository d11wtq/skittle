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

  needs other
}
