bin_recursion_prevention() {
  cat() {
    file=$TMP_DIR/recursion_prevention.txt

    is_met() {
      [[ `cat $file` = "example" ]]
    }

    meet() {
      echo "example" | cat > $file
    }
  }

  require cat
}
