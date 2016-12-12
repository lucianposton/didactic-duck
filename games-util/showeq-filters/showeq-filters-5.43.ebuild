# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils autotools git-r3

EQ_SERVER="p99"

if [[ "${EQ_SERVER}" == "live" ]]; then
	SLOT="live"
	PROGRAM_SUFFIX=""
	# Use original source?
	EGIT_REPO_URI="https://github.com/lucianposton/showeq-filters.git"

	if [[ ${PV} == 9999* ]]; then
		KEYWORDS=""
	else
		KEYWORDS="amd64 x86"
		EGIT_COMMIT="${PV}"
	fi
else
	SLOT="${EQ_SERVER}"
	PROGRAM_SUFFIX="-${EQ_SERVER}"
	EGIT_REPO_URI="https://github.com/lucianposton/showeq-filters.git"

	if [[ ${PV} == 9999* ]]; then
		KEYWORDS=""
		EGIT_BRANCH="${EQ_SERVER}"
	else
		KEYWORDS="amd64 x86"
		EGIT_COMMIT="${PV%.[[:digit:]]*}_${EQ_SERVER}v${PV##[[:digit:]]*.}"
	fi
fi

HOMEPAGE="https://github.com/lucianposton/showeq-filters"
DESCRIPTION="Filters for ShowEQ"

LICENSE="GPL-2"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	DESTDIR="/usr/share/showeq${PROGRAM_SUFFIX}/filters/"
	dodir "${DESTDIR}"
	cp -R "${S}"/* "${D}/${DESTDIR}/" || die "Failed to install"
}
