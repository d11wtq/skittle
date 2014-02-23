failing() {
  outer_1() {
    inner_1() {
      true
    }

    require inner_1
  }

  outer_2() {
    is_met() {
      false
    }
  }

  require outer_1
  require outer_2
}

