chained_dep() {
  enclosed_dep() {
    is_met() {
      true
    }
  }

  require enclosed_dep
}
