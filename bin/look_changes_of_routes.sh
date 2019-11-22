#!/usr/bin/env bash
#
# Usage: look_changes_of_routes.sh into milestone/abc from feature/cde
#

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

trap 'echo "Ctrl-C captured and exit."; exit 1' INT
trap 'echo "some error occured at $(pwd) and exit."; exit 8' SIGHUP

script_dir=$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
source "${script_dir}/common_functions.sh"

if [ $# -ne 4 ] || [ "$1" != "into" ]  || [ "$3" != "from" ]; then
    echo "Usage: look_changes_of_routes into milestone/abc from feature/cde" 1>&2
    exit 1
fi

dst_branch="$2"
src_branch="$4"

check_if_git_dir

if [ -x bin/rake ]; then
    dst_routes="/tmp/dst_routes_$$.txt"
    src_routes="/tmp/src_routes_$$.txt"
    diff_file="/tmp/changes_of_routes_$$.txt"

    git checkout "$dst_branch"
    change_ruby_version
    bundle exec rake routes > ${dst_routes}

    git checkout "$src_branch"
    change_ruby_version
    bundle exec rake routes > ${src_routes}

    diff -u ${dst_routes} ${src_routes} > ${diff_file}
    if [ -s ${diff_file} ]; then
        echo '========= changes of routes ==========='
        cat ${diff_file}
        echo '======================================='
    else
        echo '========= changes of routes: NO ROUTE CHANGES ==========='
    fi

    rm -f ${dst_routes} ${src_routes} ${diff_file}
else
    echo "Warning: no bin/rake command. So skiped looking changes of routes" 1>&2
fi
