_awsprofile_completion() {
  COMPREPLY=($(compgen -W "$(awsprofile)" -- "${COMP_WORDS[1]}"))

}
complete -F _awsprofile_completion awsprofile
