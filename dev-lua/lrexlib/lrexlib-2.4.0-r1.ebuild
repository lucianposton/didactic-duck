# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Binding of three regular expression libraries (POSIX, PCRE and Oniguruma) to Lua"
HOMEPAGE="http://luaforge.net/projects/lrexlib/"
SRC_URI="https://github.com/downloads/rrthomas/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="doc oniguruma pcre"

DEPEND="
	>=dev-lang/lua-5.1
	oniguruma? ( dev-libs/oniguruma )
	pcre? ( dev-libs/libpcre )
"
RDEPEND="
	${DEPEND}
	app-arch/unzip
"


inherit multilib

lua_version() {
	local luaver=
	luaver="$(lua -v 2>&1| cut -d' ' -f2)"
	export LUAVER="${luaver%.*}"
}

lua_get_sharedir() {
	lua_version
	echo -n /usr/share/lua/${LUAVER}/
}

lua_get_libdir() {
	lua_version
	echo -n /usr/$(get_libdir)/lua/${LUAVER}
}

lua_install_module() {
	lua_version
	insinto /usr/share/lua/${LUAVER}
	doins $@ || die "doins failed"
}

lua_install_cmodule() {
	lua_version
	insinto /usr/$(get_libdir)/lua/${LUAVER}/${2}
	doins ${1} || die "doins failed"
}


src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e "s:\(MYCFLAGS =\):\1 -fPIC ${CFLAGS}:" \
		src/defaults.mak || die "sed failed"

	sed -i \
		-e "s:^#\(LIB = -lc\):\1:" \
		src/posix/rex_posix.mak || die "sed failed"

	sed -i \
		-e "s:\(LIB = -lpcre\):\1 -lc:" \
		src/pcre/rex_pcre.mak || die "sed failed"

	sed -i \
		-e "s:\(LIB = -lonig\):\1 -lc:" \
		src/oniguruma/rex_onig.mak || die "sed failed"

	sed -i \
		-e "s/\(all:.*\)test/\1/" \
		Makefile || die "sed failed"

	if ! use pcre; then
		sed -i \
			-e "s/build_pcre//g" \
			-e "s/test_pcre//g" \
			Makefile || die "sed failed"
	fi

	if ! use oniguruma; then
		sed -i \
			-e "s/build_onig//g" \
			-e "s/test_onig//g" \
			Makefile || die "sed failed"
	fi
}

src_compile() {
	emake -j1
}

src_install() {
	if use doc; then
		dohtml -r doc/* || die "dodoc failed"
	fi

	lua_install_cmodule src/posix/rex_posix.so.${PV%.*}
	dosym rex_posix.so.${PV%.*} $(lua_get_libdir)/rex_posix.so || die "dosym failed"
	if use pcre; then
		lua_install_cmodule src/pcre/rex_pcre.so.${PV%.*}
		dosym rex_pcre.so.${PV%.*} $(lua_get_libdir)/rex_pcre.so || die "dosym failed"
	fi
	if use oniguruma; then
		lua_install_cmodule src/oniguruma/rex_onig.so.${PV%.*}
		dosym rex_onig.so.${PV%.*} $(lua_get_libdir)/rex_onig.so || die "dosym failed"
	fi
}
