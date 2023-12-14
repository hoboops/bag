.PHONY: bag
bag:
	nix-shell --run exit

dev:
	echo 'BAG_HOME_DIR=$$BAG_DIR/home' > .env
	echo 'BAG_CONFIG_DIR=$$BAG_HOME_DIR/.config' >> .env
	echo 'BAG_CONFIG_MODE=overwrite-restore' >> .env
	make
