broken() {
  foo() {
    bar() {
      sleep 2
      true
    }

    require bar
  }

  zip() {
    button() {
      sleep 2
      true
    }

    is_met() {
      false
    }

    require button
  }

  is_met() {
    [[ -f ./broken.txt ]]
  }

  meet() {
    touch ./broken.txt
  }

  require foo
  require zip
}
