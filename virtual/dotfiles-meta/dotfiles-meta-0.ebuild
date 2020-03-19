# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Dependencies for my dotfiles"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+de +mail +gpg"

RDEPEND="
	app-admin/eclean-kernel
	app-editors/vim
	app-misc/tmux
	app-misc/imgurbash2
	app-portage/smart-live-rebuild
	app-shells/gentoo-zsh-completions
	app-shells/zsh
	app-shells/zsh-completions
	app-text/par
	app-vim/vim-spell-en
	dev-lang/ruby
	dev-vcs/git
	sys-apps/netns
	sys-apps/nse
	sys-apps/ripgrep
	mail? (
		app-text/extract_url
		mail-client/neomutt[gpgme,pgp-classic,smime-classic]
		mail-mta/protonmail-bridge-bin
		net-mail/metamail
		virtual/w3m
	)
	de? (
		app-misc/workrave
		www-client/w3m[imlib]
		x11-base/xorg-x11
		x11-misc/compton
		x11-misc/dunst
		x11-misc/redshift
		x11-misc/trayer-srg
		x11-misc/urxvt-perls
		x11-misc/xclip
		x11-misc/xdg-utils
		x11-misc/xmobar
		x11-misc/xscreensaver
		x11-misc/xwinwrap
		x11-terms/rxvt-unicode
		x11-wm/xmonad
		x11-wm/xmonad-contrib
	)
	gpg? (
		app-crypt/gnupg
		app-admin/pass
		app-admin/pass-otp
		app-crypt/pgpdump
		www-plugins/passff-host
	)
"
	#net-mail/isync
