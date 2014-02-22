example() {
  is_met() {
    [[ -f ./example.txt ]]
  }

  meet() {
    touch ./example.txt
  }

  require broken
  require other
}
