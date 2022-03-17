# Makefile

# Usage:
# `make` or `make publish`: Publish files using available Emacs configuration.
# `make publish_no_init`: Publish files without using Emacs configuration.
# `make clean`: Delete existing public/ directory and cached file under ~/.org-timestamps/

# Local testing:
# `python -m http.server --directory=public/`          <-- (The '--directory' flag is available from Python 3.7)

.PHONY: all publish

EMACS =

ifndef EMACS
EMACS = "emacs"
endif

all: publish

publish: publish.el
	@echo "Publishing... with current Emacs configurations."
	${EMACS} --batch --no-init --load publish.el --eval "(org-publish-all :force)"

clean:
	@echo "Cleaning up.."
	@rm -rvf *.elc
	@rm -rvf public
	@rm -rvf ~/.org-timestamps/*
