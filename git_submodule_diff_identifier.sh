#!/bin/bash
#https://unix.stackexchange.com/questions/236365/bash-scripting-echo-locally-in-a-function

# This function will parse out the gitModules file to extrac the list of sub module names
function getSubModuleNames () {
   git config --file=.gitmodules -l | cut -d '.' -f2 | sort -u | xargs
}
# Get a list of all the sub modules
SUBS=$(getSubModuleNames) #$(git config --file=.gitmodules -l | cut -d '.' -f2 | sort -u | xargs)
echo "Sub Module list fetched is $SUBS" >&2

function getSubModuleName {
    # This takes two paramaters a submodule name and an ci_token variable
    # You call with getSubLog sub_module result_var
    # https://www.linuxjournal.com/content/return-values-bash-functions

    #declare -a module_name_diff_list
    module_name=$1
    ci_token=$2
    local ret

    local sub_branch=$(git config --file=.gitmodules --get submodule.$module_name.branch)
    local sub_url=$(git config --file=.gitmodules --get submodule.$module_name.url)
    local sub_path=$(git config --file=.gitmodules --get submodule.$module_name.path)
    echo "SubModule URL, Branch and Path is $sub_url, $sub_branch, $sub_path" >&2
    echo "--------------------------------------------------------------------------------" >&2

    if [[ $module_name == "quality-measures" ]]; then
        local framed_url="https://gitlab-ci-token:$ci_token@gitlab.com/xyz-92618-group/knowledge-graphs/$module_name.git"
    
    elif [[ $module_name == "drug-safety" ]]; then
        local framed_url="https://gitlab-ci-token:$ci_token@gitlab.com/xyz-92618-group/knowledge-graphs/$module_name.git"
    
    else
        local framed_url="https://gitlab-ci-token:$ci_token@gitlab.com/xyz-92618-group/cloud-engineering/$module_name.git"
    fi

    local remote_sha=$(git ls-remote -q "$framed_url" "$sub_branch" | xargs | cut -d" " -f1)
    local local_sha=$(git submodule status "$sub_path" | tr + " " | tr - " " | xargs | cut -d" " -f1)
    echo "REMOTE SHA ID for $sub_path is $remote_sha and LOCAL SHA ID for $sub_path is $local_sha" >&2

    if [ -n "$remote_sha" -a -n "$local_sha" -a "$remote_sha" != " " -a "$local_sha" != " " ]; then
       #module_name_diff_list+=("$sub_path")
        if [[ "$remote_sha" != "$local_sha" ]]; then
            ret="$sub_path"

        elif [[ "$remote_sha" == "$local_sha" ]]; then
            echo "REMOTE SHA ID for $sub_path - $remote_sha is equal to LOCAL SHA ID for $sub_path - $local_sha" >&2
            echo "If SHA ID is equal Gitlab CI CD Job won't build docker images" >&2
            ret=""
        else
            echo "Issue in Nested IF" >&2
            ret=""
        fi

    else
        echo "In Failure section and reson might be either of the variable is empty or may be other issue" >&2
        echo "Failure Part:::::REMOTE SHA ID for $sub_path is $remote_sha and LOCAL SHA ID for $sub_path is $local_sha" >&2
        ret=""
    fi
    #ret="${module_name_diff_list[@]}"
    echo "$ret"
}

# Add a blank link for kicks
function get_submodule_name_list(){
    declare -a module_name_diff_list
    local out

    for sub in $SUBS; do
        out=$(getSubModuleName $sub "$1")
        if [ -n "$out" ]; then
            module_name_diff_list+=("$out")
        fi
    done
    echo "value is ${module_name_diff_list[@]}" >&2
    echo "${module_name_diff_list[@]}"

}

#func_res="$(get_submodule_name_list $2)"
#echo $func_res
get_submodule_name_list $1
