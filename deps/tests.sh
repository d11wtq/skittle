tests() {
  TMP_DIR=deps/tests/tmp

  require empty_tmp_dir
  require file_creation
  require chained_dep
  require name_conflicts
  require empty_dep_passes
  require undefined_is_met_passes
  require undefined_meet_fails
  require parameterized_dep
  require success_output
  require failure_output
}
