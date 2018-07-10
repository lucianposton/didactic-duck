# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Dependencies for my dotfiles"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+de"

RDEPEND="
	app-admin/eclean-kernel
	app-crypt/gnupg
	app-editors/vim
	app-misc/tmux
	app-portage/smart-live-rebuild
	app-shells/gentoo-zsh-completions
	app-shells/zsh
	app-shells/zsh-completions
	app-text/extract_url
	app-vim/vim-spell-en
	dev-lang/ruby
	mail-client/neomutt
	mail-mta/protonmail-bridge-bin
	sys-apps/ack
	sys-apps/netns
	sys-apps/nse
	virtual/w3m
	de? (
		app-misc/workrave
		x11-base/xorg-x11
		x11-misc/compton
		x11-misc/redshift
		x11-misc/trayer-srg
		x11-misc/urxvt-perls
		x11-misc/xmobar
		x11-misc/xscreensaver
		x11-misc/xwinwrap
		x11-terms/rxvt-unicode
		x11-wm/xmonad
		x11-wm/xmonad-contrib
	)
"
	#net-mail/isync
