bin_recursion_prevention() {
  cat() {
    write_file() {
      file=$TMP_DIR/recursion_prevention.txt

      is_met() {
        [[ `cat $file` = "example" ]]
      }

      meet() {
        echo "example" | cat > $file
      }
    }

    require write_file
  }

  require cat
}
