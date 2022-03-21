# Makefile

# Usage:
# `make` or `make publish`: Publish files using available Emacs configuration.
# `make publish_no_init`: Publish files without using Emacs configuration.
# `make clean`: Delete existing public/ directory and cached file under ~/.org-timestamps/

# Local testing:
# `python -m http.server --directory=public/`          <-- (The '--directory' flag is available from Python 3.7)

.PHONY: all publish publish_local publish_local_user

EMACS =

ifndef EMACS
EMACS = "emacs"
endif

ifndef SERVER_PATH
# for userdir use ~/public_html instead
SERVER_PATH = "/srv/http"
endif

ifndef SERVER_LOCAL_PATH
# for userdir use ~/public_html instead
SERVER_LOCAL_PATH = "${HOME}/public_html"
endif

ifndef SERVER_LOCAL_USER
SERVER_LOCAL_USER = "${USER}"
endif

ifndef SERVER_USER
SERVER_USER = "http"
endif

all: publish

publish: publish.el
	@echo "Publishing..."
	${EMACS} --batch --no-init --load publish.el --eval "(org-publish-all :force)"

publish_local: publish.el
	@echo "Publishing to server"
	${EMACS} --batch --no-init --load publish.el --eval "(org-publish-all :force)"
	sudo rm -rf ${SERVER_PATH}/*
	sudo mv ./public/* ${SERVER_PATH}
	sudo chown -R ${SERVER_USER} ${SERVER_PATH}
publish_local_user: publish.el
	@echo "Publishing to server"
	${EMACS} --batch --no-init --eval "(setq +publish-as-user t)" --load publish.el --eval "(org-publish-all :force)"
	rm -rf ${SERVER_LOCAL_PATH}/*
	mv ./public/* ${SERVER_LOCAL_PATH}
	chown -R ${SERVER_LOCAL_USER} ${SERVER_LOCAL_PATH}
clean:
	@echo "Cleaning up.."
	@rm -rvf *.elc
	@rm -rvf public
	@rm -rvf ~/.org-timestamps/*
