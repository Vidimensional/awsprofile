# Copyright (C) 2022 Daniel Vidal de la Rubia WTFPL
#
# This library is free software; you can redistribute it and/or modify it
# under any version of the Do What The Fuck You Want To Public License;
# see the file LICENSE if the license name isn't clear enough.


# This needs to be a function inside the shell since we want to update the env var.
# If we run it as script, it won't be able to change the env var of the parent shell.
awsprofile() {
    local profiles="$(aws configuration list-profiles)"
    
    # If we don't specify a profile name, it will show the available profiles.
    if [[ $# -eq 0 ]]; then
        echo $profiles | tr ' ' '\n'
        return 0
    fi

    for profile in $profiles; do
        if [[ "$1" == "$profile" ]]; then
            export AWS_PROFILE=$1
            echo "AWS profile changed to $1."
            return 0
        fi
    done

    echo "Profile $1 doesn't exist."
    return 1
}

_awsprompt() {
  echo "[AWS->${AWS_PROFILE:-default}]"
}

_awsprofile_completion() {
  COMPREPLY=($(compgen -W "$(aws configuration list-profiles)" -- "${COMP_WORDS[1]}"))
}
complete -F _awsprofile_completion awsprofile
