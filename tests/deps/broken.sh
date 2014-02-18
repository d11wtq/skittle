broken() {
  echo "In broken"
  is_met() {
    [[ -f ./broken.txt ]]
  }

  meet() {
    touch ./broken.txt
  }
}
