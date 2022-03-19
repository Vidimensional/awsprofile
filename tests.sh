#!/bin/bash

# Copyright (C) 2022 Daniel Vidal de la Rubia WTFPL
#
# This library is free software; you can redistribute it and/or modify it
# under any version of the Do What The Fuck You Want To Public License;
# see the file LICENSE if the license name isn't clear enough.

set -euo pipefail

source "./awsprofile.sh"

tmp_dir="$(mktemp -d)"
trap "rm -r ${tmp_dir}" INT TERM EXIT

mocked_aws_output="default\nprod_env\npreprod_env"

test_awsprofile_without_arguments_lists_profiles() {
    echo -n ":: ${FUNCNAME[0]}"

    # Mocked awscli
    aws() {
        echo "${mocked_aws_output}"
    }
    
    set +e
    awsprofile > "${tmp_dir}/output.txt" 2>&1
    local return_code=$?
    local output="$(cat "${tmp_dir}/output.txt")"
    set -e

    local expected_return_code=0
    if [[ "${expected_return_code}" -ne "${return_code}" ]]; then
        echo " ❌"
        echo -e ":::: Expected return code: ${expected_return_code}\n:::: Actual return code: ${return_code}"
        return 1
    fi

    local expected_output="default\nprod_env\npreprod_env"
    if [[ "${expected_output}" != "${output}" ]]; then 
        echo " ❌"
        echo -e ":::: Expected output: ${expected_output}\n:::: Actual output: ${output}"
        return 1
    fi

    echo " ✅"
}

test_awsprofile_with_nonexisting_profile_argument_returns_error() {
    echo -n ":: ${FUNCNAME[0]}"
    
    # Mocked awscli
    aws() {
        echo -e "${mocked_aws_output}"
    }

    local profile_name="nonexisting_profile"
    set +e
    awsprofile ${profile_name} > "${tmp_dir}/output.txt" 2>&1
    local return_code=$?
    local output="$(cat "${tmp_dir}/output.txt")"
    set -e

    local expected_output="Profile ${profile_name} doesn't exist."
    if [[ "${expected_output}" != "${output}" ]]; then
        echo " ❌"
        echo -e ":::: Expected output:\n${expected_output}\n:::: Actual output:\n${output}"
        return 1
    fi
    
    local expected_return_code=1
    if [[ "${expected_return_code}" -ne "${return_code}" ]]; then
        echo " ❌"
        echo -e ":::: Expected return code: ${expected_return_code}\n:::: Actual return code: ${return_code}"
        return 1
    fi

    echo " ✅"
}

test_awsprofile_with_existing_profile_argument_changes_env_variable() {
    echo -n ":: ${FUNCNAME[0]}"
    
    # Mocked awscli
    aws() {
        echo -e "${mocked_aws_output}"
    }

    local profile_name="prod_env"
    set +e
    awsprofile ${profile_name} > "${tmp_dir}/output.txt" 2>&1
    local return_code=$?
    local output="$(cat "${tmp_dir}/output.txt")"
    set -e

    local expected_return_code=0
    if [[ "${expected_return_code}" -ne "${return_code}" ]]; then
        echo " ❌"
        echo -e ":::: Expected return code: ${expected_return_code}\n:::: Actual return code: ${return_code}"
        return 1
    fi

    local expected_output="AWS profile changed to ${profile_name}."
    if [[ "${expected_output}" != "${output}" ]]; then
        echo " ❌"
        echo -e ":::: Expected output:\n${expected_output}\n:::: Actual output:\n${output}"
        return 1
    fi

    if [[ "${AWS_PROFILE}" != "${profile_name}" ]]; then
        echo " ❌"
        echo -e ":::: Expected AWS_PROFILE: ${AWS_PROFILE}\n:::: Actual AWS_PROFILE: ${profile_name}"
        return 1
    fi

    echo " ✅"
}

test_awsprompt_prints_profile_name() {
    echo -n ":: ${FUNCNAME[0]}"

    local AWS_PROFILE='test_profile'

    output="$(_awsprompt)"

    local expected_output="[AWS->${AWS_PROFILE}]"
    if [[ "${expected_output}" != "${output}" ]]; then
        echo " ❌"
        echo -e ":::: Expected output: ${expected_output}\n:::: Actual output: ${output}"
        return 1
    fi

    echo " ✅"
}

test_awsprompt_prints_defaults_when_env_var_not_defined() {
    echo -n ":: ${FUNCNAME[0]}"

    local AWS_PROFILE=''

    output="$(_awsprompt)"

    local expected_output="[AWS->default]"
    if [[ "${expected_output}" != "${output}" ]]; then
        echo " ❌"
        echo -e ":::: Expected output: ${expected_output}\n:::: Actual output: ${output}"
        return 1
    fi

    echo " ✅"
}

for test in $(declare -F | awk '{$0=$3} /^test_/{print}')
do
    ${test}
done
