# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Wurm Online is the sandbox MMORPG where the players are in charge!"
HOMEPAGE="http://www.wurmonline.com/"
SRC_URI=""

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+oracle"

DEPEND="
	>=virtual/jre-1.8
	>=virtual/jdk-1.8
	oracle? (
		|| (
			>=dev-java/oracle-jre-bin-1.8
			>=dev-java/oracle-jdk-bin-1.8
		)
	)
"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_compile() {
	:
}

src_install() {
	dobin "${FILESDIR}/${PN}"
}
