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

debug:
	pwd
	ls -althr
	ls -althr requirements

pip-list: venv
	$(VENV_BIN)/pip list

# Clean the virtual environment
clean:
	rm -rf $(VENV)

.PHONY: install venv clean
