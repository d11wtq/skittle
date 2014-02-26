parameterized_dep() {
  outer_filename=./deps/tests/tmp/parameterized_dep.txt
  outer_contents="one \"two\\ three"

  write_file() {
    filename=$1
    contents=$2

    is_met() {
      [[ `cat $filename` = "$contents" ]]
    }

    meet() {
      echo $contents > $filename
    }
  }

  is_met() {
    [[ `cat $outer_filename` = "$outer_contents" ]]
  }

  require write_file $outer_filename "$outer_contents"
}
