# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit eutils python-single-r1

DESCRIPTION="Unofficial Linux client for GOG.com"
HOMEPAGE="https://github.com/yancharkin/games_nebula"
SRC_URI="https://github.com/yancharkin/games_nebula/archive/${PV#0_alpha}.tar.gz -> ${P}.tar.gz
	https://github.com/yancharkin/pygogapi/archive/master.zip -> pygogapi-${PVR}.zip
	https://github.com/yancharkin/games_nebula_goglib_scripts/archive/master.zip -> goglib_scripts-${PVR}.zip
	https://github.com/yancharkin/games_nebula_mylib_scripts/archive/master.zip -> mylib_scripts-${PVR}.zip
	https://github.com/yancharkin/games_nebula_goglib_images/archive/master.zip -> goglib_images-${PVR}.zip
	https://github.com/yancharkin/games_nebula_mylib_images/archive/master.zip -> mylib_images-${PVR}.zip
	https://sourceforge.net/projects/innounp/files/latest/download?source=files -> innounp-${PVR}.rar"

LICENSE="GPL-3 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+cab +dosbox +scummvm +mega +ffmpeg +wine"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-arch/innoextract
	app-arch/p7zip
	app-arch/unzip
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	games-util/lgogdownloader
	net-libs/webkit-gtk
	net-misc/curl
	x11-apps/xrandr
	cab? ( app-arch/cabextract app-arch/unshield )
	dosbox? ( games-emulation/dosbox )
	scummvm? ( games-engines/scummvm )
	mega? ( net-misc/megatools )
	ffmpeg? ( virtual/ffmpeg )
	wine? ( virtual/wine app-emulation/winetricks )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/0_alpha/}"

src_prepare() {
	sed -i -e 's/question_y_n/:/' -e 's/curl/:/' setup.sh
	mkdir "${S}/tmp" || die
	cp "${DISTDIR}/pygogapi-${PVR}.zip" "${S}/tmp/pygogapi.zip" || die
	cp "${DISTDIR}/goglib_scripts-${PVR}.zip" "${S}/tmp/goglib_scripts.zip" || die
	cp "${DISTDIR}/mylib_scripts-${PVR}.zip" "${S}/tmp/mylib_scripts.zip" || die
	cp "${DISTDIR}/goglib_images-${PVR}.zip" "${S}/tmp/goglib_images.zip" || die
	cp "${DISTDIR}/mylib_images-${PVR}.zip" "${S}/tmp/mylib_images.zip" || die
	cp "${DISTDIR}/innounp-${PVR}.rar" "${S}/tmp/innounp.rar" || die

	python_fix_shebang "${S}"
	sed -i -e 's/python //' setup.sh

	default
}

src_install() {
	./setup.sh || die

	dodir /opt
	cp -pPR "${S}" "${D}/opt/${PN}" || die
	# Fix perms broken by 7z in setup.sh ignoring umask
	fperms -R a+rx "/opt/${PN}/scripts" "/opt/${PN}/images" "/opt/${PN}/gogapi"

	into /opt
	make_wrapper "${PN}" "./start.sh" "/opt/${PN}"
}
