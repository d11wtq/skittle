empty_tmp_dir() {
  require tmp_dir_exists

  is_met() {
    ! (ls $TMP_DIR | grep .)
  }

  meet() {
    rm -r $TMP_DIR/*
  }
}
