# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit git-r3 distutils-r1

DESCRIPTION="tatt is an arch testing tool"
HOMEPAGE="https://github.com/lucianposton/tatt"
EGIT_REPO_URI="https://github.com/lucianposton/tatt.git"
#EGIT_COMMIT="${PV}"
EGIT_BRANCH="comment-unmasks"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+templates"

RDEPEND="
	app-portage/eix
	app-portage/gentoolkit
	www-client/pybugz
	dev-python/configobj[${PYTHON_USEDEP}]"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_install_all() {
	distutils-r1_python_install_all
	if use templates; then
		insinto "/usr/share/${PN}"
		doins -r templates
	fi
	doman tatt.1
	doman tatt.5
}
