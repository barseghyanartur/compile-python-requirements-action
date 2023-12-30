# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

version = "0.1"
project = "compile-python-requirements-action"
copyright = "2023, Artur Barseghyan <artur.barseghyan@gmail.com>"
author = "Artur Barseghyan <artur.barseghyan@gmail.com>"

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    "sphinx.ext.autodoc",
    "sphinx.ext.viewcode",
    "sphinx.ext.todo",
    "sphinx_no_pragma",
]

templates_path = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]

language = "en"

release = version

# The suffix of source filenames.
source_suffix = {
    ".rst": "restructuredtext",
}

pygments_style = "sphinx"

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = "sphinx_rtd_theme"
html_static_path = ["_static"]
# html_extra_path = ["examples"]

prismjs_base = "//cdnjs.cloudflare.com/ajax/libs/prism/1.29.0"

html_css_files = [
    f"{prismjs_base}/themes/prism.min.css",
    f"{prismjs_base}/plugins/toolbar/prism-toolbar.min.css",
    "https://cdn.jsdelivr.net/gh/barseghyanartur/jsphinx@1.3.4/src/css/sphinx_rtd_theme.css",
]

html_js_files = [
    f"{prismjs_base}/prism.min.js",
    f"{prismjs_base}/plugins/autoloader/prism-autoloader.min.js",
    f"{prismjs_base}/plugins/toolbar/prism-toolbar.min.js",
    f"{prismjs_base}/plugins/copy-to-clipboard/prism-copy-to-clipboard.min.js",
    "https://cdn.jsdelivr.net/gh/barseghyanartur/jsphinx@1.3.4/src/js/download_adapter.js",
]


# -- Options for todo extension ----------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/extensions/todo.html#configuration

todo_include_todos = True
