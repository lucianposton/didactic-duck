# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils unpacker xdg

DESCRIPTION="Editor to create games on the Unity engine"
HOMEPAGE="https://unity3d.com/"
# https://forum.unity.com/threads/unity-on-linux-release-notes-and-known-issues.350256/

MY_PV="${PV/_p/}"
HASH="10189b18f56e"
SRC_URI_BASE="https://beta.unity3d.com/download/${HASH}"
SRC_URI="
	${SRC_URI_BASE}/LinuxEditorInstaller/Unity.tar.xz
		-> ${P}.tar.xz
	doc? ( ${SRC_URI_BASE}/MacDocumentationInstaller/Documentation.pkg
		-> ${P}-doc.pkg )
	android? ( ${SRC_URI_BASE}/MacEditorTargetInstaller/UnitySetup-Android-Support-for-Editor-${MY_PV}.pkg
		-> ${P}-android.pkg )
	ios? ( ${SRC_URI_BASE}/LinuxEditorTargetInstaller/UnitySetup-iOS-Support-for-Editor-${MY_PV}.tar.xz
		-> ${P}-ios.tar.xz )
	mac? ( ${SRC_URI_BASE}/MacEditorTargetInstaller/UnitySetup-Mac-Mono-Support-for-Editor-${MY_PV}.pkg
		-> ${P}-mac.pkg )
	webgl? ( ${SRC_URI_BASE}/LinuxEditorTargetInstaller/UnitySetup-WebGL-Support-for-Editor-${MY_PV}.tar.xz
		-> ${P}-webgl.tar.xz )
	windows? ( ${SRC_URI_BASE}/MacEditorTargetInstaller/UnitySetup-Windows-Mono-Support-for-Editor-${MY_PV}.pkg
		-> ${P}-windows.pkg )
	facebook? ( ${SRC_URI_BASE}/MacEditorTargetInstaller/UnitySetup-Facebook-Games-Support-for-Editor-${MY_PV}.pkg
		-> ${P}-facebook.pkg )
"

LICENSE="Unity-EULA"
SLOT="${PV}"
KEYWORDS="-* ~amd64"
IUSE="android darkskin doc examples facebook ios mac webgl windows"

REQUIRED_USE="facebook? ( webgl windows )"

DEPEND="
	app-arch/xar
	app-arch/gzip
	app-arch/cpio
	darkskin? ( dev-util/radare2 )
"
RDEPEND="
	sys-libs/glibc[multilib]
	media-libs/alsa-lib
	x11-libs/cairo
	sys-libs/libcap
	net-print/cups
	sys-apps/dbus
	dev-libs/expat
	media-libs/fontconfig
	media-libs/freetype
	gnome-base/gconf
	x11-libs/gdk-pixbuf
	media-libs/mesa
	dev-libs/glib:2
	virtual/glu
	x11-libs/gtk+:3
	dev-dotnet/gtk-sharp
	dev-lang/mono
	dev-libs/nspr
	dev-libs/nss
	x11-libs/pango
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	sys-libs/zlib
	media-libs/libpng
	dev-db/postgresql
	sys-apps/lsb-release
	x11-misc/xdg-utils
	net-libs/nodejs[npm]
	sys-apps/fakeroot
	app-arch/libarchive
	net-libs/libsoup
	${DEPEND}

	android? (
		virtual/ffmpeg
		app-arch/gzip
		dev-util/android-sdk-update-manager
		virtual/jre
	)

	webgl? (
		virtual/jdk
	)
"

S="${WORKDIR}"

RESTRICT="bindist mirror strip"
QA_PREBUILT="*"

src_unpack() {
	unpkg() {
		mkdir "tmp" || die
		xar -C tmp -xf "${DISTDIR}/${1}" || die
		mv tmp/*.pkg.tmp/Payload Payload.cpio.gz || die
		unpacker Payload.cpio.gz
		rm -r tmp Payload.cpio.gz || die
	}

	local src_file dest_dir
	for src_file in $A; do
		dest_dir="$(basename "${src_file}")"
		dest_dir="${dest_dir%.tar.xz}"
		dest_dir="${dest_dir%.pkg}"
		mkdir "${dest_dir}" || die
		pushd "${dest_dir}" || die
		[[ "${src_file}" == *.pkg ]] && unpkg "${src_file}" || unpack "${src_file}"
		popd || die
	done
}

src_prepare() {
	if use darkskin; then
		cat <<-EOF > "${T}/darkskin.rapatch" || die
			:s method.EditorResources.GetSkinIdx__const
			:s/x 74
			:wao nop
		EOF
		r2 -w -q -P "${T}"/darkskin.rapatch "${P}"/Editor/Unity
	fi
	default
}

src_install() {
	local unity_dir="${D}/opt/${P}"
	local data_dir="${unity_dir}/Editor/Data"
	local engines_dir="${data_dir}/PlaybackEngines"

	mkdir -p "${D}"/opt || die
	cp -a "${P}" "${unity_dir}" || die
	rm -r "${P}" || die
	if use doc; then
		cp -a "${P}"-doc/Documentation "${data_dir}"/Documentation || die
		cp -a "${P}"-doc/Documentation.html "${data_dir}"/Documentation.html || die
		rm -r "${P}"-doc || die
	fi
	if use android; then
		cp -a "${P}"-android "${engines_dir}"/AndroidPlayer || die
		rm -r "${P}"-android || die
	fi
	if use ios; then
		cp -a "${P}"-ios/* "${unity_dir}" || die
		rm -r "${P}"-ios || die
	fi
	if use mac; then
		cp -a "${P}"-mac "${engines_dir}"/MacStandaloneSupport || die
		rm -r "${P}"-mac || die
	fi
	if use webgl; then
		cp -a "${P}"-webgl/* "${unity_dir}" || die
		rm -r "${P}"-webgl || die
	fi
	if use windows; then
		cp -a "${P}"-windows "${engines_dir}"/WindowsStandaloneSupport || die
		rm -r "${P}"-windows || die
	fi
	if use facebook; then
		cp -a "${P}"-facebook "${engines_dir}"/Facebook || die
		rm -r "${P}"-facebook || die
	fi

	doicon "${FILESDIR}"/unity-editor-icon.png
	domenu "${FILESDIR}"/unity-editor.desktop

	make_wrapper "${P}" /opt/"${P}"/Editor/Unity
}

pkg_postinst() {
	xdg_desktop_database_update
}
