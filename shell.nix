{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
	nativeBuildInputs = with pkgs.buildPackages; [
		busybox
		zellij
		fish
		broot
		micro
		xclip
		lynx
		curl
		nb
	];

	shellHook = "source shell.sh";
}
