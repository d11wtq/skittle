name_conflicts() {
  file_one=$TMP_DIR/name_conflicts_one.txt
  file_two=$TMP_DIR/name_conflicts_two.txt

  is_met() {
    [[ -z $foo ]] && [[ -z $bar ]] && ls $file_one && ls $file_two
  }

  one() {
    is_met() {
      [[ -z $foo ]] && ls $file_one
    }

    meet() {
      foo=42
      echo $foo > $file_one
    }
  }

  two() {
    is_met() {
      [[ -z $bar ]] && ls $file_two
    }

    meet() {
      bar=42
      echo $bar > $file_two
    }
  }

  require one
  require two
}
