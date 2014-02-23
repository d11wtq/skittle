file_creation() {
  is_met() {
    ls $TMP_DIR/file_creation.txt
  }

  meet() {
    touch $TMP_DIR/file_creation.txt
  }
}
