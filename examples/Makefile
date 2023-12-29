# Define the name of the virtual environment directory
VENV := venv

# Detect the operating system
ifeq ($(OS),Windows_NT)
    detected_OS := Windows
    PYTHON := python
else
    detected_OS := $(shell uname)
    PYTHON := python3
endif

# Define the requirement file based on the operating system
ifeq ($(detected_OS),Windows)
    REQUIREMENTS_FILE := requirements\windows-latest.txt
else ifeq ($(detected_OS),Darwin)
    REQUIREMENTS_FILE := requirements/macos-latest.txt
else ifeq ($(detected_OS),Linux)
    REQUIREMENTS_FILE := requirements/ubuntu-latest.txt
endif

# Default target
all: install

# Create a virtual environment
venv: $(VENV)/bin/activate

# Virtual environment creation
$(VENV)/bin/activate:
	$(PYTHON) -m venv $(VENV)

# Install requirements into the virtual environment
install: venv
	$(VENV)/bin/pip install -r $(REQUIREMENTS_FILE)

# Install requirements into the virtual environment
shell: venv
	$(VENV)/bin/python

# Clean the virtual environment
clean:
	rm -rf $(VENV)

.PHONY: install venv clean
