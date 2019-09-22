#!/usr/bin/env bash
#
# Usage: run_review.sh into milestone/abc from feature/cde
#

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

script_dir=$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
source "${script_dir}/common-functions.sh"

trap 'echo "Ctrl-C captured and exit."; exit 1' INT
trap 'echo "some error occured at $(pwd) and exit."; exit 8' SIGHUP

if [ $# -ne 4 ] || [ "$1" != "into" ]  || [ "$3" != "from" ]; then
    echo "Usage: git-checkout-target-branches.sh into milestone/abc from feature/cde" 1>&2
    exit 1
fi

dst_branch="$2"
src_branch="$4"

mkdir -p ~/tmp
logifle=~/tmp/run_review_`date +'%Y%m%d-%H%M%S'`.log

(
    "${script_dir}/git-checkout-target-branches.sh" into "$dst_branch" from "$src_branch" ||
        show_notification "run_review.sh" "Failed: git-checkout-target-branches.sh" $error_exit

    "${script_dir}/prepare-rails-and-frontend.sh" || 
        show_notification "run_review.sh" "Failed: prepare-rails-and-frontend.sh" $error_exit

    "${script_dir}/check-and-test.sh" || 
        show_notification "run_review.sh" "Failed: check-and-test.sh" $error_exit

    "${script_dir}/analyze_coverage.rb" into "$dst_branch" from "$src_branch" || true

) 2>&1 | tee "$logifle"

show_notification "run_review.sh" "All tasks completed." $success

/usr/bin/less -R $logifle
