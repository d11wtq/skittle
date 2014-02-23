require_before_def() {
  require inner_1
  require inner_2

  filename_1=./deps/tests/tmp/require_before_def_1.txt
  filename_2=./deps/tests/tmp/require_before_def_2.txt

  inner_1() {
    is_met() {
      ls $filename_1
    }

    meet() {
      touch $filename_1
    }
  }

  inner_2() {
    is_met() {
      ls $filename_2
    }

    meet() {
      touch $filename_2
    }
  }

  is_met() {
    ls $filename_1 && ls $filename_2
  }
}
