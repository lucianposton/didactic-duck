# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils cmake-utils git-r3

KEYWORDS=""
if [[ ${PV} != 9999* ]]; then
	EGIT_COMMIT=${PV}
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Ethereum and other technologies to provide a decentralised application framework"
HOMEPAGE="https://www.ethereum.org"
EGIT_REPO_URI="https://github.com/ethereum/webthree-umbrella.git"

LICENSE="MIT ISC GPL-3+ LGPL-3+ BSD-2 public-domain"
SLOT="0"
IUSE=""

# Dependency notes:
#
# =dev-lang/v8-3.16.14.9 API compatible, but not 3.17.16.2
#
# ~net-libs/libmicrohttpd-0.9.42 set due to deprecated APIs used in slot 0/11.
# net-libs/libmicrohttpd:0/12 and net-libs/libmicrohttpd:0/11 compile if
# -Wno-error=deprecated-declarations flag set
DEPEND="
	<dev-lang/v8-3.17:=
	>=dev-libs/gmp-6:=
	>=sys-devel/clang-3.7
	>=sys-devel/llvm-3.7
	~net-libs/libmicrohttpd-0.9.42

	dev-cpp/libjson-rpc-cpp[stubgen,http-client,http-server]
	dev-libs/boost
	dev-libs/crypto++
	dev-libs/jsoncpp
	dev-libs/leveldb[snappy]
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtquick1:5
	dev-qt/qtwebengine:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-util/scons
	net-libs/miniupnpc
	net-misc/curl
	sys-libs/libcpuid
	sys-libs/ncurses:0[tinfo]
	sys-libs/readline:0
	virtual/opencl
"
RDEPEND="${DEPEND}"
# Build time dependencies
DEPEND+="
"

CMAKE_MIN_VERSION="3.2"

src_prepare() {
	cmake-utils_src_prepare

	sed -i \
		-e "s:llvm_map_components_to_libnames:explicit_map_components_to_libraries:" \
		libethereum/evmjit/CMakeLists.txt || die "sed failed"

	epatch_user
}
