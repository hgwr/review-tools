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
