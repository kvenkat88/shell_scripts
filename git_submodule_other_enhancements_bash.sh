#!/bin/bash
# https://git-scm.com/docs/pretty-formats
# https://stackoverflow.com/questions/22497597/get-the-last-modification-data-of-a-file-in-git-repo
# https://serverfault.com/questions/401437/how-to-retrieve-the-last-modification-date-of-all-files-in-a-git-repository
# git ls-files | xargs -I{} git log -1 --date=format:%Y%m%d%H%M.%S --format='touch -t %ad "{}"' "{}" | $SHELL
# https://www.unix.com/unix-for-dummies-questions-and-answers/22053-timestamp-directory-listing.html

# docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedAt}}\t{{.Size}}"
# docker inspect 173461566831.dkr.ecr.us-east-2.amazonaws.com/hps-innovations/rasa/nlu:dev-11192020-09-22 | grep -i created

 #stat -c %y drug-safety
#2020-11-19 09:25:42.325835646 +0000
#stat -c %Y drug-safety
#1605777942

#submodule_timestamp_fetched["$module_name"]="$(git log -1 --format="%ci" -- $module_name)" #parent git repo committed time infp
#submodule_timestamp_fetched["$module_name"]="$(stat -c %Y $module_name)" -- file or folder modified timestamp


# git log -1 --format="%ci %cr" -- p360
#2020-09-01 10:01:44 +0000 3 months ago
# https://stackoverflow.com/questions/15107545/get-commit-date-of-a-given-sha1-submodules-commit #important

# https://www.edureka.co/blog/git-format-commit-history/
# https://git-scm.com/docs/pretty-formats

# docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedAt}}\t{{.Size}}"

# epoch date timestamp difference identification
# image_name=$(docker images | grep "hps-innovations/p360" | head -1 | awk '{print $1 ":" $2}')
# docker_inspect_image_created_time=$(docker inspect -f '{{.Created}}' "$image_name")
# docker_inspect_image_created_time_epoch=$(date -d "$docker_inspect_image_created_time" +"%s")
# project_commit_epoch_time="$(git --git-dir=./p360/.git log -1 --format="%ct")"
# date_diff=$(( ("$docker_inspect_image_created_time_epoch" - "$project_commit_epoch_time") / (60*60*24) ))
# if [ "$currentDate" -gt "$deploymentDate" ] or if [[ "$currentDate" > "$deploymentDate" ]] # ksh/bash/zsh

# date -d '2020-11-19T11:01:31.544307981Z' +"%s" #unix/epoch timestamp
# date -d '2020-10-19 10:16:43 -0500' +"%Y-%m-%d" ==>> 2020-10-19
# date -d @1605846304 +"%Y-%m-%d" ==> epoch timestamp to human readable time format and output is 2020-11-20

#1605846304 - submodule commit time (fetched for nlg as example)
#1605846808 - docker image created epoch timestamp
# git show -s --format=%ci 4cae21fbc8989bf24aa0f5662688f67861071f25 ##date from commit sha id
# git show -s --format=%cd --date=short 4cae21fbc8989bf24aa0f5662688f67861071f25 ==> output as 2020-09-09
# git --git-dir=./nlg/.git log -1 --format="%cd" --date=short edbcde6e9e2150a1dbf1af12b6356e751a0aa970 and this one is used in project


# https://stackoverflow.com/questions/45603232/python-difference-between-two-unix-timestamps


# Bash array/list inside dict -- [{}]
# https://fabianlee.org/2020/02/15/bash-associative-array-initialization-and-usage/
# https://stackoverflow.com/questions/40088652/bash-associative-array-with-list-as-value
# https://lzone.de/cheat-sheet/Bash%20Associative%20Array
# https://www.artificialworlds.net/blog/2012/10/17/bash-associative-array-examples/

#declare -A submodule_timestamp_fetched

#declare -A committed_module_names
#declare -a committed_module_name_diff_list

# Split string by _
# str="nlg_2020-12-09"
#  IFS="_" arr=($str)
# echo ${arr[0]}
#  echo ${arr[@]}
# https://unix.stackexchange.com/questions/377812/create-new-array-with-unique-values-from-existing-array
# https://stackoverflow.com/questions/13648410/how-can-i-get-unique-values-from-an-array-in-bash

# https://www.unix.com/shell-programming-and-scripting/220621-returning-capturing-multiple-return-values-function.html

# https://bash.cyberciti.biz/guide/Calling_functions
# https://www.xspdf.com/help/50053325.html

# Array Compare
# https://stackoverflow.com/questions/10586153/split-string-into-an-array-in-bash/10586169
# https://www.xspdf.com/help/50053325.html

# Git submodule updated latest with submodule commit message
# https://stackoverflow.com/questions/10741801/include-submodule-commit-messages-with-git-log
# https://stackoverflow.com/questions/8843724/git-history-including-interleave-submodule-commits
# https://stackoverflow.com/questions/7124914/how-to-search-a-git-repository-by-commit-message
# https://mijingo.com/blog/search-git-commits-with-grep

# https://www.lukeshu.com/blog/bash-arrays.html
# https://stackoverflow.com/questions/12985178/bash-quoted-array-expansion

# https://stackoverflow.com/questions/56456794/how-to-return-array-from-bash-function
# http://www.cs.umsl.edu/~sanjiv/classes/cs2750/lectures/kshfns.pdf
# https://fabianlee.org/2020/09/06/bash-difference-between-two-arrays/
# https://unix.stackexchange.com/questions/104837/intersection-of-two-arrays-in-bash
# https://stackoverflow.com/questions/53069514/replace-newline-with-space-in-array-element-in-a-for-loop-in-bash
# https://unix.stackexchange.com/questions/163352/what-does-dev-null-21-mean-in-this-article-of-crontab-basics
# https://unix.stackexchange.com/questions/259690/bash-split-multi-line-input-into-array
# https://stackoverflow.com/questions/42060636/when-do-i-set-ifs-to-a-newline-in-bash

# New line separated file into array
#IFS=$'\n' read -a finalized_submodules_array -d '' < $HOME/builds/data/hps-api-builder/final_module_names_fetched_for_cicd.txt
#echo "finalized_submodules_array values are ${finalized_submodules_array[@]}" >&2


declare -a committed_modules_info

#submodules_list=(drug-safety geo-services healthconcepts hps-dashboard-api infectious-disease kb-content nlg notifications p360 quality-measures risk-scores symptom-graph visualization)
submodules_list=(drug-safety nlg)
for module_name in ${submodules_list[@]}; do
    #echo "$module_name"
    #submodule_timestamp_fetched["$module_name"]="$(git --git-dir=./$module_name/.git log -1 --format="%ct")"

    image_name=$(docker images | grep "hps-innovations/$module_name" | head -1 | awk '{print $1 ":" $2}')
    docker_inspect_image_created_time=$(docker inspect -f '{{.Created}}' "$image_name")
    #docker_inspect_image_created_time_epoch=$(date -d "$docker_inspect_image_created_time" +"%s")
    project_commit_epoch_time="$(git --git-dir=./$module_name/.git log -1 --format="%ct")"
    human_date_format=$(date -d @${project_commit_epoch_time} +"%Y-%m-%d")

    #echo "docker_inspect_image_created_time_epoch time for $module_name is $docker_inspect_image_created_time_epoch" >&2
    echo "project_commit_epoch_time time for $module_name is $project_commit_epoch_time" >&2
    echo "project_commit_epoch_time formatted date for $module_name is $human_date_format" >&2

    if [[ "$human_date_format" == "$(date +'%Y-%m-%d')" ]]; then
        #committed_module_name_diff_list+=("$module_name")
        #committed_module_names["${module_name}_commit_date"]="$human_date_format"
        committed_modules_info+=("${module_name}_${human_date_format}")
    fi

done

echo "value is ${committed_modules_info[@]}" >&2

#echo "dict keys are ${!committed_modules_info[*]}" >&2
#echo "dict values are ${committed_modules_info[*]}" >&2

#echo "dict keys is ${!committed_module_names[@]}" >&2
#echo "dict values is ${committed_module_names[@]}" >&2
#echo "value is ${committed_module_name_diff_list[@]}" >&2

#echo "${!submodule_timestamp_fetched[@]}"
#echo "${submodule_timestamp_fetched[@]}"

#for module_name in "${!submodule_timestamp_fetched[@]}"; do echo "$module_name - ${submodule_timestamp_fetched[$module_name]}"; done



#git ls-tree -r --name-only HEAD | while read filename; do
#  echo "$(git log -1 --format="%ad" -- $filename) $filename"
#done
