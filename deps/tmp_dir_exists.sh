tmp_dir_exists() {
  is_met() {
    ls -d $TMP_DIR
  }

  meet() {
    mkdir -p $TMP_DIR
  }
}
