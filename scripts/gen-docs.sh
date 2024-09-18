#!/bin/bash

function show_help {
    echo "Usage: $(basename "$0") [-c CHART_NAME]"
    echo ""
    echo "Options:"
    echo "  -c CHART_NAME   Specify the name of the chart to generate docs for."
    echo "  -h              Show this help message."
    echo ""
    echo "If CHART_NAME is not provided, the script will generate docs for all charts in the 'charts' directory."
}

function check_helm_docs_installed {
    if ! command -v helm-docs &> /dev/null; then
        echo "Error: helm-docs is not installed. Please install helm-docs and try again."
        exit 1
    fi
}

CHART_NAME=""

while getopts "c:h" opt; do
    case $opt in
        c)
            CHART_NAME=$OPTARG
            ;;
        h)
            show_help
            exit 0
            ;;
        *)
            show_help
            exit 1
            ;;
    esac
done

check_helm_docs_installed

if [[ -n "$CHART_NAME" ]]; then
    if [[ -d "charts/$CHART_NAME" ]]; then
        echo "Generating helm docs for chart: $CHART_NAME"
        cd "charts/$CHART_NAME" || exit 1
        helm-docs
    else
        echo "Error: Chart '$CHART_NAME' does not exist in the 'charts' directory."
        exit 1
    fi

    exit 0
fi

echo "Generating helm docs for all charts in the 'charts' directory."
for chart in charts/*; do
    if [[ -d "$chart" ]]; then
        echo "Generating helm docs for chart: $(basename "$chart")"
        cd "$chart" || exit 1
        helm-docs
        cd - > /dev/null || exit 1
    fi
done