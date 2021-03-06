# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Spectre & Meltdown vulnerability/mitigation checker for Linux"
HOMEPAGE="https://github.com/speed47/spectre-meltdown-checker"
EGIT_REPO_URI="https://github.com/speed47/spectre-meltdown-checker.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	newbin spectre-meltdown-checker.sh spectre-meltdown-checker
}
