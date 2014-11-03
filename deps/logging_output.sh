logging_output() {
  is_met() {
    TMP_DIR="$TMP_DIR" ./bin/skittle logging | diff deps/tests/logging_output.txt -
  }
}
