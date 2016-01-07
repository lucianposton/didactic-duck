# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Ethereum and other technologies to provide a decentralised application framework"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# TODO: Create ebuilds for individual modules
# https://github.com/ethereum/webthree-umbrella/wiki/Linux--Generic-Building#building-modules-separately
DEPEND="
	|| (
		net-p2p/webthree-umbrella
	)
"
RDEPEND="${DEPEND}"
