tests() {
  TMP_DIR="$(cd deps/tests && pwd)/tmp"

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
  require logging_output
  require require_before_def
  require dep_in_subfolder
  require bin_recursion_prevention
  require pwd_behaviour
  require relative_paths
  require noops
}
