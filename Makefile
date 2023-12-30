# Update version ONLY here
VERSION := 0.1
SHELL := /bin/bash
# Makefile for project
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

# Create a virtual environment
venv: $(VENV_BIN)/activate

# Virtual environment creation
$(VENV_BIN)/activate:
	$(PYTHON) -m venv $(VENV)

# Build documentation using Sphinx and zip it
build_docs:
	$(VENV_BIN)/sphinx-build -n -a -b html docs builddocs
	cd builddocs && zip -r ../builddocs.zip . -x ".*" && cd ..

rebuild_docs:
	$(VENV_BIN)/sphinx-apidoc . --full -o docs -H 'compile-python-requirements-action' -A 'Artur Barseghyan <artur.barseghyan@gmail.com>' -f -d 20
	cp docs/conf.py.distrib docs/conf.py
	cp docs/index.rst.distrib docs/index.rst

# Format code using Black
black:
	$(VENV_BIN)/black .

# Sort imports using isort
isort:
	$(VENV_BIN)/isort . --overwrite-in-place

doc8:
	$(VENV_BIN)/doc8

# Run ruff on the codebase
ruff:
	$(VENV_BIN)/ruff .

# Serve the built docs on port 5000
serve_docs:
	source $(VENV_BIN)/activate && cd builddocs && python -m http.server 5000

# Install the project
install: venv
	$(VENV_BIN)/pip install -e .[all]

create-secrets:
	$(VENV_BIN)/detect-secrets scan > .secrets.baseline

detect-secrets:
	$(VENV_BIN)/detect-secrets scan --baseline .secrets.baseline

# Clean up generated files
clean:
	find . -type f -name "*.pyc" -exec rm -f {} \;
	find . -type f -name "builddocs.zip" -exec rm -f {} \;
	find . -type f -name "*.py,cover" -exec rm -f {} \;
	find . -type f -name "*.orig" -exec rm -f {} \;
	find . -type d -name "__pycache__" -exec rm -rf {} \; -prune
	rm -rf build/
	rm -rf dist/
	rm -rf .cache/
	rm -rf htmlcov/
	rm -rf builddocs/
	rm -rf testdocs/
	rm -rf .coverage
	rm -rf .pytest_cache/
	rm -rf .mypy_cache/
	rm -rf .ruff_cache/
	rm -rf dist/

compile-requirements:
	$(VENV_BIN)/python -m piptools compile --extra docs -o docs/requirements.txt pyproject.toml

update-version:
	#sed -i 's/"version": "[0-9.]\+"/"version": "$(VERSION)"/' package.json
	sed -i 's/version = "[0-9.]\+"/version = "$(VERSION)"/' pyproject.toml
	sed -i 's/__version__ = "[0-9.]\+"/__version__ = "$(VERSION)"/' docs/conf.py
	sed -i 's/__version__ = "[0-9.]\+"/__version__ = "$(VERSION)"/' docs/conf.py.distrib

%:
	@:
