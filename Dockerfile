# Copyright 2022 MosaicML LLM Foundry authors
# SPDX-License-Identifier: Apache-2.0

ARG BASE_IMAGE
FROM $BASE_IMAGE

ARG BRANCH_NAME
ARG DEP_GROUPS

# Check for changes in setup.py.
# If there are changes, the docker cache is invalidated and a fresh pip installation is triggered.
ADD https://raw.githubusercontent.com/mosaicml/llm-foundry/$BRANCH_NAME/setup.py setup.py
RUN rm setup.py

# Install TransformerEngine
RUN NVTE_FRAMEWORK=pytorch CMAKE_BUILD_PARALLEL_LEVEL=3 MAX_JOBS=3 pip install git+https://github.com/cli99/TransformerEngine.git@6b21f606f2459d49c2113d69236d68d334edeb4c

# Install and uninstall foundry to cache foundry requirements
RUN git clone -b $BRANCH_NAME https://github.com/mosaicml/llm-foundry.git
RUN pip install --no-cache-dir "./llm-foundry${DEP_GROUPS}"
RUN pip uninstall -y llm-foundry
RUN rm -rf llm-foundry
