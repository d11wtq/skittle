example() {
  is_met() {
    [[ -f ./example.txt ]]
  }

  meet() {
    touch ./example.txt
  }

  needs broken
  needs other
}
