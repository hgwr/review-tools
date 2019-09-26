#!/usr/bin/env bash
#
# Usage: git_checkout_target_branches.sh into milestone/abc from feature/cde
#

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

trap 'echo "Ctrl-C captured and exit."; exit 1' INT
trap 'echo "some error occured at $(pwd) and exit."; exit 8' SIGHUP

if [ $# -ne 4 ] || [ "$1" != "into" ]  || [ "$3" != "from" ]; then
    echo "Usage: git_checkout_target_branches into milestone/abc from feature/cde" 1>&2
    exit 1
fi

dst_branch="$2"
src_branch="$4"

if [ ! -d .git ]; then
    echo "Error: no git repository" 1>&2
    exit 1
fi

git checkout master
git fetch -a || true
git gc --prune=now || true
git remote prune origin || true
git pull origin master

git checkout "$dst_branch"
git pull origin "$dst_branch"

git checkout "$src_branch"
git pull origin "$src_branch"
