broken() {
  foo() {
    bar() {
      sleep 2
      true
    }

    needs bar
  }

  zip() {
    button() {
      sleep 2
      true
    }

    is_met() {
      false
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
