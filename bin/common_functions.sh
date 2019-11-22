error_exit=1
success=0

function check_if_git_dir () {
    if [ ! -d .git ]; then
        echo "Error: no git repository" 1>&2
        exit 1
    fi
}

function change_ruby_version () {
    if [ -f .ruby-version ]; then
        rbenv local `cat .ruby-version`
    fi
    bundle install --path vendor/bundle --jobs=4 --retry=3
}

function run_additional_task () {
    task_name="$1"
    if [ -f "${HOME}/.config/review-tools.yml" ]; then
        additional_task=$(ruby -ryaml -e "conf = YAML.load_file(%Q(#{ENV['HOME']}/.config/review-tools.yml)); puts conf['$task_name']")
        if [ "$additional_task" != "" ]; then
            eval "$additional_task" || true
        fi
    fi
}

function load_environment_variables () {
    run_additional_task "$1"
}

function show_notification () {
    if [ -x /usr/bin/osascript ]; then
        /usr/bin/osascript -e "display notification \"$2\" with title \"$1\""
    else
        echo "Notification: $1: $2" 1>&2
    fi

    if [ "$3" -gt "0" ]; then
        exit $3
    fi
}
