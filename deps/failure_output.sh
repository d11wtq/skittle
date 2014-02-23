failure_output() {
  is_met() {
    captured=deps/tests/failure_output.txt
    omit_log='s/(Error:.*) See.*/\1/g'
    (./bin/skittle failing | sed -E "$omit_log") | diff $captured -
  }
}
