broken() {
  foo() {
    bar() {
      true
    }

    needs bar
  }

  zip() {
    button() {
      true
    }

    needs button
  }

  is_met() {
    [[ -f ./broken.txt ]]
  }

  meet() {
    touch ./broken.txt
  }

  needs foo
  needs zip
}
