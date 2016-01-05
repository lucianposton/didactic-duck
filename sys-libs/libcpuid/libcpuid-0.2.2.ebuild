# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

SCM=""
KEYWORDS=""
if [[ ${PV} == 9999* ]]; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/anrieff/${PN}.git"
else
	SRC_URI="https://github.com/anrieff/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit autotools ${SCM}

DESCRIPTION="small C library for x86 CPU detection and feature extraction"
HOMEPAGE="https://github.com/anrieff/libcpuid"

LICENSE="BSD-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
# Build time dependencies
DEPEND+="
	sys-devel/libtool
	sys-devel/autoconf
"

src_prepare() {
	_elibtoolize
	eautoreconf
}
