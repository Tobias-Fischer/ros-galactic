#!/usr/bin/env bash

# PLEASE NOTE: This script has been automatically generated by conda-smithy. Any changes here
# will be lost next time ``conda smithy rerender`` is run. If you would like to make permanent
# changes to this script, consider a proposal to conda-smithy so that other feedstocks can also
# benefit from the improvement.

set -xeuo pipefail
export PYTHONUNBUFFERED=1
export FEEDSTOCK_ROOT="${FEEDSTOCK_ROOT:-/home/conda/feedstock_root}"
export RECIPE_ROOT="${RECIPE_ROOT:-/home/conda/recipe_root}"
# export CI_SUPPORT="${FEEDSTOCK_ROOT}/.ci_support"
# export CONFIG_FILE="${CI_SUPPORT}/${CONFIG}.yaml"

cat >~/.condarc <<CONDARC
conda-build:
    root-dir: /opt/conda/build_artifacts
CONDARC

# This doesn't work, see e.g. https://dev.azure.com/robostack/ros_pipelines/_build/results?buildId=188&view=logs&j=4e20d398-0572-5e54-89c7-6bdb9c00a59a&t=f5885ff8-badf-54b3-1543-35164851bdf3
# if grep -q libgl "recipes/${CURRENT_BUILD_PKG_NAME}.yaml"; then
# 	sudo yum install -y install mesa-libGL-devel
# fi

conda config --set remote_max_retries 5
# conda config --append channels defaults
conda config --add channels conda-forge
conda config --add channels robostack-experimental
conda config --set channel_priority strict

conda update conda -c conda-forge
conda install --yes --quiet pip conda-build anaconda-client mamba

# install boa from master
# baaaad
pip install git+https://github.com/mamba-org/boa.git@master

# setup_conda_rc "${FEEDSTOCK_ROOT}" "${RECIPE_ROOT}" "${CONFIG_FILE}"
# export PATH="$HOME/miniconda/bin:$PATH"
conda config --set anaconda_upload yes
conda config --set show_channel_urls true
conda config --set auto_update_conda false
conda config --set add_pip_as_python_dependency false

export "CONDA_BLD_PATH=/opt/conda/build_artifacts"

conda info
conda config --show-sources
conda list --show-channel-urls

pwd

for recipe in ${CURRENT_RECIPES[@]}; do
	cd ${FEEDSTOCK_ROOT}/recipes/${recipe}
	boa build . -m ${FEEDSTOCK_ROOT}/.ci_support/conda_forge_pinnings.yaml -m ${FEEDSTOCK_ROOT}/conda_build_config.yaml
done

anaconda -t ${ANACONDA_API_TOKEN} upload /opt/conda/build_artifacts/linux-*/*.tar.bz2 --force
# quetz-client "${QUETZ_URL}" /opt/conda/build_artifacts --force

# set up the condarc

# source run_conda_forge_build_setup

# # make the build number clobber
# make_build_number "${FEEDSTOCK_ROOT}" "${RECIPE_ROOT}" "${CONFIG_FILE}"

# conda build "${RECIPE_ROOT}" -m "${CI_SUPPORT}/${CONFIG}.yaml" \
#     --clobber-file "${CI_SUPPORT}/clobber_${CONFIG}.yaml"

# if [[ "${UPLOAD_PACKAGES}" != "False" ]]; then
#     upload_package  "${FEEDSTOCK_ROOT}" "${RECIPE_ROOT}" "${CONFIG_FILE}"
# fi

# touch "${FEEDSTOCK_ROOT}/build_artifacts/conda-forge-build-done-${CONFIG}"
