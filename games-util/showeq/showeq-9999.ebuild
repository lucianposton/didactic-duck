# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils autotools git-r3 fcaps

EQ_SERVER="live"

if [[ "${EQ_SERVER}" == "live" ]]; then
	SLOT="live"
	PROGRAM_SUFFIX=""
	EGIT_REPO_URI="https://github.com/ShowEQ/ShowEQ.git"

	if [[ ${PV} == 9999* ]]; then
		KEYWORDS=""
	else
		KEYWORDS="amd64 x86"
		EGIT_COMMIT="v${PV//./_}"
	fi
else
	SLOT="${EQ_SERVER}"
	PROGRAM_SUFFIX="-${EQ_SERVER}"
	EGIT_REPO_URI="https://github.com/lucianposton/showeq.git"

	if [[ ${PV} == 9999* ]]; then
		KEYWORDS=""
		EGIT_BRANCH="${EQ_SERVER}"
	else
		KEYWORDS="amd64 x86"
		EGIT_COMMIT="v${PV%.[[:digit:]]*}_${EQ_SERVER}v${PV##[[:digit:]]*.}"
		EGIT_COMMIT="${EGIT_COMMIT//./_}"
	fi
fi

HOMEPAGE="https://github.com/lucianposton/showeq"
DESCRIPTION="Realtime packet analyser for EverQuest"

LICENSE="GPL-2"
IUSE=""

DEPEND="
	dev-qt/qt-meta:3
	net-libs/libpcap
	sys-libs/zlib
	sys-libs/gdbm
"
RDEPEND="${DEPEND}"
# dev-perl/Unicode-String is required by spells_en2spellsh.pl to regenerate
# staticspells.h when spells_us.txt is updated

# Build time dependencies
DEPEND+="
	sys-devel/automake
	sys-devel/autoconf
	sys-devel/autoconf-archive
"

FILECAPS=(
	cap_net_raw+eip usr/bin/showeq${PROGRAM_SUFFIX}
)

#pre_src_configure() {
src_prepare() {
	if [[ -n "${PROGRAM_SUFFIX}" ]]; then
		sed -i -e "s:AC_INIT(showeq,:AC_INIT(showeq${PROGRAM_SUFFIX},:" configure.*
		sed -i -e "s:\"\\.showeq\":\".showeq${PROGRAM_SUFFIX}\":" src/*
		sed -i -e "s:showeq.1:showeq${PROGRAM_SUFFIX}.1:" Makefile.am
		cp showeq.1 "showeq${PROGRAM_SUFFIX}.1"
	fi

	epatch_user
	eautoreconf
}

src_configure() {
	export QT_SELECT=3
	econf \
		--program-suffix="${PROGRAM_SUFFIX}"
}

src_install() {
	einstall
	doman "showeq${PROGRAM_SUFFIX}.1"
}
