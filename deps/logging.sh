logging() {
  file=$TMP_DIR/logging.txt

  log "Inside 'logging'"

  is_met() {
    log "Checking if file exists"
    [[ -f $file ]]
  }

  meet() {
    log "Creating file"
    touch $file
  }
}
