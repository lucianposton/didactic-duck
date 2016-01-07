# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN=${PN^}

MY_PV=${PV}
MY_PV=${MY_PV/_alpha/-alpha}
MY_PV=${MY_PV/_beta/-beta}
MY_PV=${MY_PV/_pre3/-gamma}
MY_PV=${MY_PV/_pre4/-delta}
MY_PV=${MY_PV/_pre5/-epsilon}
MY_PV=${MY_PV/_pre6/-zeta}

MY_P="${MY_PN}-${MY_PN}-${MY_PV}"

SCM=""
KEYWORDS=""
if [[ ${PV} == 9999* ]]; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/${MY_PN}/${MY_PN}.git"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/${MY_PN}-${MY_PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_P}"
fi

inherit eutils qmake-utils ${SCM}

DESCRIPTION="Modern GUI MUD client with Lua scripting support"
HOMEPAGE="http://www.mudlet.org"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

DEPEND="
	>=dev-libs/boost-1.55
	>=dev-libs/libpcre-7.8

	app-text/hunspell
	dev-lang/lua
	dev-libs/libzip
	dev-libs/yajl
	dev-qt/designer:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	media-libs/glu
	sys-libs/zlib
"
RDEPEND="${DEPEND}
	dev-lua/lrexlib[pcre]
	dev-lua/luafilesystem
	dev-lua/luasql[sqlite3]
	dev-lua/luazip
"
# Build time dependencies
DEPEND+="
"

src_prepare() {
	sed -i \
		-e 's|-llua5.1|-llua|g' \
		src/src.pro || die "sed failed"

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
