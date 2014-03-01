logging() {
  file=$TMP_DIR/logging.txt

  echolog "Inside 'logging'"

  is_met() {
    echolog "Checking if file exists"
    [[ -f $file ]]
  }

  meet() {
    echolog "Creating file"
    touch $file
  }
}
