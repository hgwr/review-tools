#!/usr/bin/env bash
#
# Usage: run_review.sh into milestone/abc from feature/cde
#

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

script_dir=$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
source "${script_dir}/common_functions.sh"

trap 'echo "Ctrl-C captured and exit."; exit 1' INT
trap 'echo "some error occured at $(pwd) and exit."; exit 8' SIGHUP

if [ $# -ne 4 ] || [ "$1" != "into" ]  || [ "$3" != "from" ]; then
    echo "Usage: run_review into milestone/abc from feature/cde" 1>&2
    exit 1
fi

dst_branch="$2"
src_branch="$4"

mkdir -p ~/tmp
logifle=~/tmp/run_review_`date +'%Y%m%d-%H%M%S'`.log

(
    "${script_dir}/git_checkout_target_branches.sh" into "$dst_branch" from "$src_branch" ||
        show_notification "run_review.sh" "Failed: git_checkout_target_branches.sh" $error_exit

    "${script_dir}/prepare_rails_and_frontend.sh" || 
        show_notification "run_review.sh" "Failed: prepare_rails_and_frontend.sh" $error_exit

    # TODO: debug look_changes_of_routes.sh
    "${script_dir}/look_changes_of_routes.sh" into "$dst_branch" from "$src_branch" || true
        # show_notification "run_review.sh" "Failed: look_changes_of_routes.sh" $error_exit

    if [ -z ${RUN_REVIEW_WITH_NO_TEST:-} ]; then
      "${script_dir}/check_and_test.sh" || 
          show_notification "run_review.sh" "Failed: check_and_test.sh" $error_exit

      if [ -r 'coverage/index.html' ]; then
        analyze_coverage into "$dst_branch" from "$src_branch"
      fi
    fi

) 2>&1 | tee "$logifle"

show_notification "run_review.sh" "All tasks completed." $success

/usr/bin/less -R $logifle
