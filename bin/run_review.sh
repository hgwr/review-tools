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
    "${script_dir}/git-checkout-target-branches.sh" into "$dst_branch" from "$src_branch"
    "${script_dir}/prepare-rails-and-frontend.sh"
    "${script_dir}/check-and-test.sh"
    "${script_dir}/analyze_coverage.rb" into "$dst_branch" from "$src_branch" || true
) 2>&1 | tee "$logifle"

osascript -e 'display notification "review-tools の実行が完了しました。" with title "run_review.sh"'
/usr/bin/less -R $logifle
