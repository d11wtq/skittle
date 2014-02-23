name_conflicts() {
  is_met() {
    [[ -z $foo ]] && [[ -z $bar ]]
  }

  one() {
    is_met() {
      [[ -z $bar ]] && [[ ! -z $foo ]]
    }

    meet() {
      foo=42
    }
  }

  two() {
    is_met() {
      [[ -z $foo ]] && [[ ! -z $bar ]]
    }

    meet() {
      bar=42
    }
  }

  require one
  require two
}
