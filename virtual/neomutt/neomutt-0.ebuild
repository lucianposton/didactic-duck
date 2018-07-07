# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Neomutt and dependencies for my setup"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-crypt/gnupg
	app-editors/vim
	app-text/extract_url
	mail-client/neomutt
	mail-mta/protonmail-bridge-bin
	virtual/w3m
"
	#net-mail/isync
