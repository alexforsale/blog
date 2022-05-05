# Makefile

# Usage:
# `make` or `make publish`: Publish files using available Emacs configuration.
# `make publish_no_init`: Publish files without using Emacs configuration.
# `make clean`: Delete existing public/ directory and cached file under ~/.org-timestamps/

# Local testing:
# `python -m http.server --directory=public/`          <-- (The '--directory' flag is available from Python 3.7)

.PHONY: all publish publish-github publish_local

EMACS =

ifndef EMACS
EMACS = "emacs"
endif

ifndef SERVER_PATH
# for userdir use ~/public_html instead
SERVER_PATH = "/srv/http"
endif

ifndef SERVER_USER
SERVER_USER = "http"
endif

all: publish

publish: publish.el
	@echo "Publishing..."
	 ${EMACS} --batch --no-init --load publish.el --eval "(org-publish-all :force)"

publish-github: publish.el
	@echo "Publishing..."
	${EMACS} --batch --no-init --eval "(setenv \"ROOT_URL\" \"https://alexforsale.github.io\")" --load publish.el --eval "(org-publish-all :force)"

publish_local: publish.el
	@echo "Publishing to server"
	${EMACS} --batch --no-init --load publish.el --eval "(org-publish-all :force)"
	sudo rm -rf ${SERVER_PATH}/*
	sudo mv ./public/* ${SERVER_PATH}
	sudo chown -R ${SERVER_USER} ${SERVER_PATH}
clean:
	@echo "Cleaning up.."
	@rm -rvf *.elc
	@rm -rvf public
	@rm -rvf ~/.org-timestamps/*
