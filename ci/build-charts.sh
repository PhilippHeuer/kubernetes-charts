#!/bin/bash

# Iterate over all directories
echo "Now building all charts in ${REPO_DIR}"
for CHART_DIR in $REPO_DIR/*; do
if [ -d "${CHART_DIR}" ]; then
    # Build Each Chart
    echo "Now building chart ${CHART_DIR#"$CI_PROJECT_DIR/"} ..."
    helm package ${CHART_DIR#"$CI_PROJECT_DIR/"} --destination ./public
fi
done
