
# Targets
all:
	$(MAKE) dependencies
	$(MAKE) install_actual
	$(MAKE) start_actual

dependencies:
	sudo dnf install npm
	npm install --global yarn

install_actual:
	cd actual-server; \
	yarn install;

update_actual:
	cd actual-server; \
	git pull; \
    if [[ $$(git status -s) != "Already up to date."  ]]; then \
        echo "There are uncommitted changes in the repository."; \
		cd -; \
        git add .; \
        git commit -m "Actual Update"; \
        git push; \
        echo "Changes committed and pushed."; \
		killall node; \
		yarn install; \
		$(MAKE) start_actual; \
    else \
        echo "No update necessary."; \
    fi

start_actual:
	cd actual-server; \
	yarn start &

uninstall_actual:
	killall node
	yarn remove --all
	npm uninstall yarn
	sudo dnf remove npm

.PHONY: dependencies install_actual clean update_actual start_actual
