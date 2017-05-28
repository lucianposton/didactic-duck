# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Wrapper to simplify nsenter usage"
HOMEPAGE="https://github.com/lucianposton/nse"
EGIT_REPO_URI="https://github.com/lucianposton/nse.git"
EGIT_COMMIT="v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	app-admin/sudo
"
RDEPEND="${DEPEND}"

src_compile() {
	:
}

src_install() {
	dobin "nse"
}
