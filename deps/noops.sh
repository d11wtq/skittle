meet() {
  touch $TMP_DIR/noops.txt
}

noops() {
  leaky_meet() {
    is_met() {
      if [[ ! -f $TMP_DIR/leaky.txt ]]
      then
        touch $TMP_DIR/leaky.txt
        # trigger the possibly leaky meet() func
        false
      else
        true
      fi
    }
  }

  is_met() {
    [[ ! -f $TMP_DIR/noops.txt ]]
  }

  require leaky_meet
}
