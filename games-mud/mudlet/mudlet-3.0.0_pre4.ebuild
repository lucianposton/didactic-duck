# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils qmake-utils git-r3

DESCRIPTION="A modern open source MUD client with a graphical user inteface and full built in Lua scripting support for all major platforms."
HOMEPAGE="http://www.mudlet.org"
EGIT_REPO_URI="https://github.com/Mudlet/Mudlet.git"

if [[ ${PV} == 9999* ]]; then
	KEYWORDS=""
else
	KEYWORDS="amd64 ~x86"
	MY_P=${P^}
	MY_P=${MY_P/_alpha/-alpha}
	MY_P=${MY_P/_beta/-beta}
	MY_P=${MY_P/_pre3/-gamma}
	MY_P=${MY_P/_pre4/-delta}
	MY_P=${MY_P/_pre5/-epsilon}
	MY_P=${MY_P/_pre6/-zeta}
	EGIT_COMMIT="${MY_P}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	dev-lang/lua
	dev-qt/qtcore:5
	dev-qt/qtopengl:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtmultimedia:5
	dev-qt/qtwidgets:5
	dev-qt/designer:5
	media-libs/glu
	app-text/hunspell
	sys-libs/zlib
	dev-libs/libzip
	dev-libs/yajl
	>=dev-libs/libpcre-7.8
	>=dev-libs/boost-1.55
"
RDEPEND="${DEPEND}
	dev-lua/lrexlib[pcre]
	dev-lua/luazip
	dev-lua/luafilesystem
	dev-lua/luasql[sqlite3]
"

# Build time dependencies
DEPEND+="
"

src_prepare() {
	sed -i \
		-e 's|-llua5.1|-llua|g' \
		src/src.pro
	epatch "${FILESDIR}/mudlet-lua.patch"
	epatch_user
}

src_configure() {
	eqmake5 "src/src.pro" PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake INSTALL_ROOT="${ED}" install
	einstalldocs

	domenu mudlet.desktop
	doicon mudlet.svg mudlet.png
}
