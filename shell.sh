#!/bin/bash

function create_admin_user () {
	echo "- read accept to create admin user"
	echo "- make sure wheel group is sudoless"
	echo "- create user in wheel group"
	echo "- create ssh key for user"
	echo "- add key to allowed users"
	echo "- switch to user"
	echo "- start bag"
	exit
}

function restore_backups () {
	HAS_FILE_LIST=false
	
	if [[ -d "$BAG_CONFIG_DIR" ]] && [[ "$BAG_CONFIG_MODE" == "overwrite-restore" ]]; then
		for SRC_PATH in $(find "$BAG_CONFIG_DIR"); do
			if [[ "$SRC_PATH" == *".bagup"* ]]; then
				DEST_PATH=$(echo "$SRC_PATH" | sed "s/.bagup//g")
				HAS_FILE_LIST=true
				
				rm "$DEST_PATH"
				mv "$SRC_PATH" "$DEST_PATH"

				echo " - $DEST_PATH"
			fi
		done

		if [[ "$HAS_FILE_LIST" == true ]]; then
			echo "Restored the files in the list above because BAG_CONFIG_MODE is '$BAG_CONFIG_MODE'."
		fi
	fi
}

function check_config_modes () {
	VALID_CONFIG_MODES="abort|keep|overwrite|overwrite-restore|overwrite-backup"
	
	if [[ ! "$VALID_CONFIG_MODES" =~ (^|)$BAG_CONFIG_MODE($|) ]]; then
		echo "Unknown value '$BAG_CONFIG_MODE' for BAG_CONFIG_MODE setting."
		echo "Possible values:"
		echo "$VALID_CONFIG_MODES" 
		exit
	fi
}

function copy_config_files() {
	for SRC_PATH in $(find "config"); do
		FILE_PATH=$(echo "$SRC_PATH" | sed "s/^config//g")
		DEST_PATH="$BAG_CONFIG_DIR$FILE_PATH"

		if [[ -d "$SRC_PATH" ]]; then
			mkdir -p "$DEST_PATH"
		else
			if [[ -f "$DEST_PATH" ]]; then
				SRC_MD5=($(md5sum "$SRC_PATH"))
				DEST_MD5=($(md5sum "$DEST_PATH"))

				case "$BAG_CONFIG_MODE" in
					"abort")
						ABORT=true		
						echo " - $DEST_PATH"
					;;

					"keep")
						HAS_FILE_LIST=true
						echo " - $DEST_PATH"
					;;
					
					"overwrite")
						cp "$SRC_PATH" "$DEST_PATH"
					;;

					"overwrite-restore")
						if [[ "$SRC_MD5" != "$DEST_MD5" ]]; then
							mv "$DEST_PATH" "$DEST_PATH.bagup"
							cp "$SRC_PATH" "$DEST_PATH"
						fi
					;;

					"overwrite-backup")
						if [[ "$SRC_MD5" != "$DEST_MD5" ]]; then
							EPOCH=$(date +%s)
							HAS_FILE_LIST=true
							
							echo " - $DEST_PATH"
							mv "$DEST_PATH" "$DEST_PATH.$EPOCH.bagup"
							cp "$SRC_PATH" "$DEST_PATH"
						fi
					;;
				esac
			else
				cp "$SRC_PATH" "$DEST_PATH"
			fi
		fi
	done
}

if [[ -z "$BAG_DIR" ]]; then
	export BAG_DIR=$(realpath .)
	ENV_PATH="$BAG_DIR/.env"
				
	source "$ENV_PATH.default"

	if [[ -f "$ENV_PATH" ]]; then
		source "$ENV_PATH"
	fi

	CURRENT_USER=$(whoami)

	if [[ "$CURRENT_USER" == "root" ]]; then
		create_admin_user
	fi

	check_config_modes
	
	BAG_BAG_CONFIG_DIR="$BAG_CONFIG_DIR/bag"
	VERSION_FILE_PATH="$BAG_BAG_CONFIG_DIR/VERSION"
	FIRST_RUN=true

	if [[ -f "$VERSION_FILE_PATH" ]]; then
		FIRST_RUN=false
	fi

	ABORT=false
	HAS_FILE_LIST=false

	restore_backups # restore backups that may were not restored because unclean termination
	copy_config_files

	if [[ "$ABORT" == true ]]; then
		echo "Aborting because setting BAG_CONFIG_MODE is '$BAG_CONFIG_MODE'."
		echo "Move the files in the list above or set another mode."
		exit
	fi

	if [[ "$HAS_FILE_LIST" == true ]]; then
		if [[ "$BAG_CONFIG_MODE" == "keep" ]]; then
			echo "Not overwriting the files in the list above because setting BAG_CONFIG_MODE is '$BAG_CONFIG_MODE'."
		fi

		if [[ "$BAG_CONFIG_MODE" == "overwrite-backup" ]]; then
			echo "Created a backup of the files in the list above because setting BAG_CONFIG_MODE is '$BAG_CONFIG_MODE'."
		fi
	fi

	if [[ "$FIRST_RUN" == true ]]; then
		mkdir -p "$BAG_BAG_CONFIG_DIR"
		cp "$BAG_DIR/VERSION" "$VERSION_FILE_PATH"
	fi

	export HOME="$BAG_HOME_DIR"
	export XDG_CONFIG_HOME="$BAG_CONFIG_DIR"
	export SHELL="$BAG_SHELL"
	export EDITOR="$BAG_EDITOR"

	zellij attach --create "$BAG_ZELLIJ_SESSION_NAME"
	restore_backups
fi
