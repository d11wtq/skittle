name_conflicts() {
  one() {
    is_met() {
      [[ ! -z $foo ]]
    }

    meet() {
      foo=42
    }
  }

  two() {
    is_met() {
      [[ ! -z $bar ]]
    }

    meet() {
      bar=42
    }
  }

  require one
  require two
}
