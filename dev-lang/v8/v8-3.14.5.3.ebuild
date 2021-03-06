# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_{6,7} )

inherit eutils multilib pax-utils python-any-r1 toolchain-funcs versionator

DESCRIPTION="Google's open source JavaScript engine"
HOMEPAGE="http://code.google.com/p/v8"
SRC_URI="http://commondatastorage.googleapis.com/chromium-browser-official/${P}.tar.bz2"
LICENSE="BSD"

soname_version="$(get_version_component_range 1-3)"
SLOT="0/${soname_version}"
KEYWORDS="amd64 ~arm x86 ~x86-fbsd ~x64-macos ~x86-macos"
IUSE=""

DEPEND="${PYTHON_DEPS}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-vfp2-r0.patch
}

src_compile() {
	tc-export AR CC CXX RANLIB
	export LINK=${CXX}

	local hardfp=off

	# Use target arch detection logic from bug #354601.
	case ${CHOST} in
		i?86-*) myarch=ia32 ;;
		x86_64-*)
			if [[ $ABI = x86 ]] ; then
				myarch=ia32
			else
				myarch=x64
			fi ;;
		arm*-hardfloat-*)
			hardfp=on
			myarch=arm ;;
		arm*-*) myarch=arm ;;
		*) die "Unrecognized CHOST: ${CHOST}"
	esac
	mytarget=${myarch}.release

	local snapshot=on
	host-is-pax && snapshot=off

	# TODO: Add console=readline option once implemented upstream
	# http://code.google.com/p/v8/issues/detail?id=1781

	emake V=1 \
		library=shared \
		werror=no \
		soname_version=${soname_version} \
		snapshot=${snapshot} \
		hardfp=${hardfp} \
		${mytarget} || die

	pax-mark m out/${mytarget}/{cctest,d8,shell} || die
}

src_test() {
	local arg testjobs
	for arg in ${MAKEOPTS}; do
		case ${arg} in
			-j*) testjobs=${arg#-j} ;;
			--jobs=*) testjobs=${arg#--jobs=} ;;
		esac
	done

	tools/test-wrapper-gypbuild.py \
		-j${testjobs:-1} \
		--arch-and-mode=${mytarget} \
		--no-presubmit \
		--progress=dots || die
}

src_install() {
	insinto /usr
	doins -r include || die

	if [[ ${CHOST} == *-darwin* ]] ; then
		# buildsystem is too horrific to get this built correctly
		mkdir -p out/${mytarget}/lib.target
		mv out/${mytarget}/libv8.so.${soname_version} \
			out/${mytarget}/lib.target/libv8$(get_libname ${soname_version}) || die
		install_name_tool \
			-id "${EPREFIX}"/usr/$(get_libdir)/libv8$(get_libname) \
			out/${mytarget}/lib.target/libv8$(get_libname ${soname_version}) \
			|| die
		install_name_tool \
			-change \
			/usr/local/lib/libv8.so.${soname_version} \
			"${EPREFIX}"/usr/$(get_libdir)/libv8$(get_libname) \
			out/${mytarget}/d8 || die
	fi

	dobin out/${mytarget}/d8 || die

	dolib out/${mytarget}/lib.target/libv8$(get_libname ${soname_version}) || die
	dosym libv8$(get_libname ${soname_version}) /usr/$(get_libdir)/libv8$(get_libname) || die

	dodoc AUTHORS ChangeLog || die
}
