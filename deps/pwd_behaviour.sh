pwd_behaviour() {
  non_leaky() {
    is_met() {
      [[ ! $PWD = $TMP_DIR ]] && ls $TMP_DIR/pwd_non_leaky.txt
    }

    meet() {
      cd $TMP_DIR
      touch pwd_non_leaky.txt
    }
  }

  scoped() {
    cd $TMP_DIR

    is_met() {
      [[ $PWD = $TMP_DIR ]]
    }

    meet() {
      touch pwd_scoped.txt
    }
  }

  require non_leaky
  require scoped
}
