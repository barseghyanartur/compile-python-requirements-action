==================================
compile-python-requirements-action
==================================
Compile Python requirement files for MacOs, Linux or Windows.

.. image:: https://readthedocs.org/projects/compile-python-requirements-action/badge/?version=latest
    :target: http://compile-python-requirements-action.readthedocs.io
    :alt: Documentation Status

.. image:: https://img.shields.io/badge/license-MIT-blue.svg
   :target: https://github.com/barseghyanartur/compile-python-requirements-action/#License
   :alt: MIT

.. Internal references

.. _GitHub issues: https://github.com/barseghyanartur/compile-python-requirements-action/issues

.. External references

.. _Docker: https://docker.org/
.. _pip-tools: https://pip-tools.readthedocs.io/
.. _Settings: https://github.com/settings/profile
.. _Developer Settings: https://github.com/settings/apps
.. _Fine-grained tokens: https://github.com/settings/tokens?type=beta

Features
========
- Compile Python requirement files (from requirements.in or pyproject.toml)
  for MacOs, Linux or Windows.
- Create PRs with the changes.
- Create Artifacts with compiled requirements.

Disclaimer
==========
This project will be irrelevant for you if:

- Your **entire team** uses `Docker`_ for development.
- Or you are the **sole developer** of a project.
- Or your entire team uses **the same** operating system (MacOs, Linux or
  Windows).

If none of the statements above qualifies, read further.

Why
===
When a single project is being worked on by multiple developers, it's useful
to streamline the installation process and ensure everyone is using exactly
the same package versions.

It's a good practice to compile your input requirements and build your
production environment from compiled requirements to prevent unpleasant
surprises.

In many cases, `pip-tools`_ is your best friend, however, what `pip-tools`_
doesn't do is compiling requirements for multiple platforms.
It can only compile requirements for the platform it's being executed on.

Software engineering is multi-diverse. Some may find `Docker`_ an essential
tool, some others won't even bother using it and would prefer to work in a
virtual environment.

And then it's your job to make sure everyone is working efficiently and
does not accidentally break the project. If a Linux user makes a change in
input requirements, you want to make sure requirements are properly compiled
for all designated systems so that when a MacOs user pulls the changes and
runs the installation script, he immediately has the project up-and-running
with properly synchronized package versions.

Configuration
=============
inputs
------

`input-file`
~~~~~~~~~~~~
*Required* The path to the input file (example: `requirements.in`).

`os-name`
~~~~~~~~~
*Required* Operating system name (platform slug).

`github-token`
~~~~~~~~~~~~~~
GitHub Token for creating pull requests.

`output-directory`
~~~~~~~~~~~~~~~~~~
The path to directory to place the compiled requirements (default
value: `requirements/`).

`target-branch`
~~~~~~~~~~~~~~~
Branch to make a pull request to.

`prefix`
~~~~~~~~
Prefix for the destination compiled filename.

`create-artifact`
~~~~~~~~~~~~~~~~~
Flag to determine if an artifact should be created (default value: `false`).

Methodology
===========
Selectively pick workflows to run
---------------------------------
Selectively pick which workflow to run based on what has changed.

#. Monitor your input requirement files using ``paths`` directive.
#. Do not trigger your main tests on changes in input requirements.
#. Trigger your main tests if compiled requirements have changed.

Use PAT instead of default GITHUB_TOKEN on private repositories
---------------------------------------------------------------
To create a Personal access token (PAT), go to GitHub `Settings`_ ->
`Developer Settings`_ -> `Fine-grained tokens`_ and create a new token on
your repository with the following permissions:

- ``Actions``: Read and write.
- ``Contents``: Read and write.
- ``Environments``: Read-only.
- ``Pull Requests``: Read and write.
- ``Secrets``: Read-only.

Additionally, it might be useful to allow the following too:

- ``Commit statuses``: Read-only.
- ``Metadata``: Read-only.

Finally, create a ``New repository secret`` from ``Secrets and variables``
section of your repository ``Settings``, specify ``PAT_TOKEN`` as ``Name`` and
paste the content of newly created PAT as ``Secret``.

Write smart Makefile commands to pick the right requirements for local installation
-----------------------------------------------------------------------------------
**Makefile** example

.. code-block:: text

    # Define the name of the virtual environment directory
    VENV := venv

    # Detect the operating system
    ifeq ($(OS),Windows_NT)
        detected_OS := Windows
        PYTHON := python
        VENV_BIN := $(VENV)/Scripts
    else
        detected_OS := $(shell uname)
        PYTHON := python3
        VENV_BIN := $(VENV)/bin
    endif

    # Define the requirement file based on the operating system
    ifeq ($(detected_OS),Windows)
        REQUIREMENTS_FILE := requirements/windows-latest.txt
    else ifeq ($(detected_OS),Darwin)
        REQUIREMENTS_FILE := requirements/macos-latest.txt
    else ifeq ($(detected_OS),Linux)
        REQUIREMENTS_FILE := requirements/ubuntu-latest.txt
    endif

    # Default target
    all: install

    # Create a virtual environment
    venv: $(VENV_BIN)/activate

    # Virtual environment creation
    $(VENV_BIN)/activate:
        $(PYTHON) -m venv $(VENV)

    # Install requirements into the virtual environment
    install: venv
        $(VENV_BIN)/pip install -r $(REQUIREMENTS_FILE)

    # Enter virtual environment shell
    shell: venv
        $(VENV_BIN)/python

    pip-list: venv
        $(VENV_BIN)/pip list

    # Clean the virtual environment
    clean:
        rm -rf $(VENV)

    .PHONY: install venv clean

Example usage
=============

**.github/workflows/test-action.yml**

.. code-block:: yaml

    name: Test Compile Requirements Action

    on:
      push:
        paths:
          - 'examples/requirements.in'
          - 'examples/pyproject.toml'
          - '.github/workflows/test-action.yml'
          - 'action.yml'

    permissions:
      contents: write
      pull-requests: write

    jobs:
      test:
        runs-on: ${{ matrix.os }}
        strategy:
          fail-fast: false
          matrix:
            os: [  # See this as an example
              ubuntu-latest,
              ubuntu-22.04,
              ubuntu-20.04,
              windows-latest,
              windows-2022,
              windows-2019,
              macos-latest,
              macos-13,
              macos-12,
              macos-11,
            ]
        steps:
          - uses: actions/checkout@v3

          - name: Set up Python 3.11
            uses: actions/setup-python@v5
            with:
              python-version: '3.11'

          - name: Set up platform-specific variables
            id: vars
            shell: bash
            run: |
              OS_NAME=$(echo ${{ matrix.os }} | tr '[:upper:]' '[:lower:]' | sed -e 's/[^a-zA-Z0-9]+/-/g')
              echo "PLATFORM_SLUG=${OS_NAME%}" >> $GITHUB_ENV
              echo "TARGET_BRANCH=$(echo ${GITHUB_REF#refs/heads/})" >> $GITHUB_ENV

          - name: Run Compile and PR Requirements Action
            uses: barseghyanartur/compile-python-requirements-action@0.1
            with:
              input-file: 'examples/requirements.in'
              os-name: ${{ env.PLATFORM_SLUG }}
              github-token: ${{ secrets.PAT_SECRET }}
              output-directory: 'examples/requirements'  # Optional
              prefix: ''  # Optional
              # Optional. Pass the target branch to the action
              target-branch: ${{ env.TARGET_BRANCH }}
              create-artifact: 'true'  # Optional

          - name: Upload Artifact
            uses: actions/upload-artifact@v3
            with:
              name: requirements-${{ env.PLATFORM_SLUG }}
              path: examples/requirements/requirements.tar.gz
              if-no-files-found: 'warn'

License
=======
MIT

Support
=======
For security issues contact me at the e-mail given in the `Author`_ section.

For overall issues, go to `GitHub issues`_.

Author
======
Artur Barseghyan
