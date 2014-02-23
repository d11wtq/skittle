require_before_def() {
  require inner

  inner() {
    true
  }
}
