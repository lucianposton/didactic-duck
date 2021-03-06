# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils autotools git-r3

DESCRIPTION="Prints user's X server idle time in milliseconds"
HOMEPAGE="https://github.com/lucianposton/xprintidle"
EGIT_REPO_URI="https://github.com/lucianposton/xprintidle.git"
EGIT_COMMIT="v2.0"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXScrnSaver
	"
RDEPEND="${DEPEND}"

#pre_src_configure() {
src_prepare() {
	epatch_user
	eautoreconf
}

src_configure() {
	econf \
		--x-libraries=/usr/lib/X11 \
		--x-includes=/usr/include/X11
}

src_install() {
	einstall
}
