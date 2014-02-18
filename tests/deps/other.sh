other() {
  echo "In other"
  is_met() {
    [[ -f ./other.txt ]]
  }

  meet() {
    touch ./other.txt
  }
}
