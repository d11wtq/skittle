passing() {
  outer_1() {
    inner_1() {
      true
    }

    require inner_1
  }

  outer_2() {
    true
  }

  require outer_1
  require outer_2
}
