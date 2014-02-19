broken() {
  foo() {
    true
  }

  is_met() {
    [[ -f ./broken.txt ]]
  }

  meet() {
    touch ./broken.txt
  }

  needs foo
}
