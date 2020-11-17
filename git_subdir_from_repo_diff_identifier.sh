#!/bin/bash
#https://unix.stackexchange.com/questions/236365/bash-scripting-echo-locally-in-a-function

function get_cloned_project_git_modified_status(){
    module_name=$1
    ci_token=$2
    local ret1
    local sha_id_fetched_or_status

    if [ "$module_name" == "hps-data-pipeline" ]; then
        sha_id_fetched_or_status=$(git log -n 1 --pretty=format:%H -- $module_name)
        echo "--------------------------------------------------------------------------------" >&2
        echo "SHA ID Fetched for $module_name directory is $sha_id_fetched_or_status" >&2
        echo "--------------------------------------------------------------------------------" >&2

    elif [ "$module_name" == "xyz-pylib" ]; then
        local framed_url="https://gitlab-ci-token:$ci_token@gitlab.com/xyz-92618-group/cloud-engineering/$module_name.git"

        local remote_sha=$(git ls-remote -q "$framed_url" "master" | xargs | cut -d" " -f1)
        local local_sha=$(cd $module_name;git log -n 1 --pretty=format:%H;cd ..)

        if [[ "$remote_sha" != "$local_sha" ]]; then
            sha_id_fetched_or_status="true"
            echo "--------------------------------------------------------------------------------" >&2
            echo "REMOTE SHA ID for $module_name is $remote_sha and LOCAL SHA ID for $module_name is $local_sha and SH IDs are different" >&2
            echo "SHA ID Fetched/Remote and Local SHA ID matcing status for $module_name directory is $sha_id_fetched_or_status" >&2
            echo "--------------------------------------------------------------------------------" >&2

        elif [[ "$remote_sha" == "$local_sha" ]]; then
            sha_id_fetched_or_status="false"
            echo "--------------------------------------------------------------------------------" >&2
            echo "REMOTE SHA ID for $module_name is $remote_sha and LOCAL SHA ID for $module_name is $local_sha and SH IDs are same" >&2
            echo "SHA ID Fetched/Remote and Local SHA ID matcing status for $module_name directory is $sha_id_fetched_or_status" >&2
            echo "--------------------------------------------------------------------------------" >&2

        else
            echo "Issue in Nested IF" >&2
            sha_id_fetched_or_status=""
        fi
    else
        echo "$module_name is irrelevant" >&2
    fi

    ret1="$sha_id_fetched_or_status"
    echo "$ret1"
}

get_cloned_project_git_modified_status $1 $2
