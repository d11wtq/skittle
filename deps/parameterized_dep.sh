parameterized_dep() {
  outer_filename=./deps/tests/tmp/parameterized_dep.txt

  write_file() {
    filename=$1

    is_met() {
      ls $filename
    }

    meet() {
      touch $filename
    }
  }

  is_met() {
    ls $outer_filename
  }

  require write_file $outer_filename
}
