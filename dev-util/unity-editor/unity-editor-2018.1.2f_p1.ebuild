# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils unpacker xdg

DESCRIPTION="Editor for the Unity game engine"
HOMEPAGE="https://unity3d.com/"
# https://forum.unity.com/threads/unity-on-linux-release-notes-and-known-issues.350256/

HASH="3709a3f954c1"

#REL="$(get_version_component_range 4)"
#REL="${REL/rc/f}"
#REL="${REL/beta/b}"
#VER="$(get_version_component_range 1-3)${REL}"

VER="${PV/_p/}"

SRC_URI="
	https://beta.unity3d.com/download/${HASH}/LinuxEditorInstaller/Unity.tar.xz -> ${P}-Unity.tar.xz
	https://beta.unity3d.com/download/${HASH}/MacStandardAssetsInstaller/StandardAssets.pkg -> ${P}-StandardAssets.pkg
	doc? ( https://beta.unity3d.com/download/${HASH}/MacDocumentationInstaller/Documentation.pkg -> ${P}-Documentation.pkg )
	examples? ( https://beta.unity3d.com/download/${HASH}/MacExampleProjectInstaller/Examples.pkg -> ${P}-Examples.pkg )

	android? ( https://beta.unity3d.com/download/${HASH}/MacEditorTargetInstaller/UnitySetup-Android-Support-for-Editor-${VER}.pkg -> ${P}-UnitySetup-Android-Support-for-Editor-${VER}.pkg )
	ios? ( https://beta.unity3d.com/download/${HASH}/LinuxEditorTargetInstaller/UnitySetup-iOS-Support-for-Editor-${VER}.tar.xz -> ${P}-UnitySetup-iOS-Support-for-Editor-${VER}.tar.xz )
	mac? ( https://beta.unity3d.com/download/${HASH}/MacEditorTargetInstaller/UnitySetup-Mac-Mono-Support-for-Editor-${VER}.pkg -> ${P}-UnitySetup-Mac-Mono-Support-for-Editor-${VER}.pkg )
	webgl? ( https://beta.unity3d.com/download/${HASH}/LinuxEditorTargetInstaller/UnitySetup-WebGL-Support-for-Editor-${VER}.tar.xz -> ${P}-UnitySetup-WebGL-Support-for-Editor-${VER}.tar.xz )
	windows? ( https://beta.unity3d.com/download/${HASH}/MacEditorTargetInstaller/UnitySetup-Windows-Mono-Support-for-Editor-${VER}.pkg -> ${P}-UnitySetup-Windows-Mono-Support-for-Editor-${VER}.pkg )
	facebook? ( https://beta.unity3d.com/download/${HASH}/MacEditorTargetInstaller/UnitySetup-Facebook-Games-Support-for-Editor-${VER}.pkg -> ${P}-UnitySetup-Facebook-Games-Support-for-Editor-${VER}.pkg )
"

LICENSE="Unity-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="android darkskin doc examples facebook ios +mac webgl +windows"

REQUIRE_USE="facebook? ( webgl windows )"

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
#	dev-dotnet/gnome-sharp

S="${WORKDIR}"

RESTRICT="bindist mirror preserve-libs strip"
QA_PREBUILT="*"

src_unpack() {
	unpkg() {
		echo ">>> Unpacking $1 to $(pwd)"
		mkdir .pkg || die
		xar -C .pkg -xf "${DISTDIR}/$1" || die
		mv .pkg/*.pkg.tmp/Payload .pkg/Payload.cpio.gz || die
		gunzip .pkg/Payload.cpio.gz || die
		cpio --quiet -i <.pkg/Payload.cpio || die
		rm -rf .pkg || die
	}

	for src in $A; do
		name="$(basename "$src")"
		name="${name%.xz}"
		name="${name%.tar}"
		name="${name%.pkg}"

		mkdir "$name" || die

		pushd "$name" >/dev/null
		[[ "$src" == *.pkg ]] && unpkg "$src" || unpack "$src"
		popd >/dev/null
	done
}

src_prepare() {
	if use darkskin; then
		cat <<-EOF > "${T}/darkskin.rapatch" || die
			:s method.EditorResources.GetSkinIdx
			:s/x 74
			:wao nop
		EOF
		r2 -w -q -P "${T}"/darkskin.rapatch "${P}"-Unity/Editor/Unity
	fi
	default
}

src_install() {
	mkdir -p "${D}"/opt || die
	cp -a "${P}"-Unity "${D}"/opt/Unity || die
	cp -a "${P}"-StandardAssets "${D}"/opt/Unity/Editor/Standard\ Assets || die

	if use doc; then
		cp -a "${P}"-Documentation/Documentation "${D}"/opt/Unity/Editor/Data/Documentation || die
		cp -a "${P}"-Documentation/Documentation.html "${D}"/opt/Unity/Editor/Data/Documentation.html || die
	fi
	if use examples; then
		cp -a "${P}"-Examples/Standard\ Assets\ Example\ Project "${D}"/opt/Unity/Standard\ Assets\ Example\ Project || die
	fi

	if use android; then
		cp -a "${P}"-UnitySetup-Android-Support-for-Editor-"${VER}" "${D}"/opt/Unity/Editor/Data/PlaybackEngines/AndroidPlayer || die
	fi
	if use ios; then
		cp -a "${P}"-UnitySetup-iOS-Support-for-Editor-"${VER}" "${D}"/opt/Unity/Editor/Data/PlaybackEngines/iOSSupport || die
	fi
	if use mac; then
		cp -a "${P}"-UnitySetup-Mac-Mono-Support-for-Editor-"${VER}" "${D}"/opt/Unity/Editor/Data/PlaybackEngines/MacStandaloneSupport || die
	fi
	if use webgl; then
		cp -a "${P}"-UnitySetup-WebGL-Support-for-Editor-"${VER}" "${D}"/opt/Unity/Editor/Data/PlaybackEngines/WebGLSupport || die
	fi
	if use windows; then
		cp -a "${P}"-UnitySetup-Windows-Mono-Support-for-Editor-"${VER}" "${D}"/opt/Unity/Editor/Data/PlaybackEngines/WindowsStandaloneSupport || die
	fi
	if use facebook; then
		cp -a "${P}"-UnitySetup-Facebook-Games-Support-for-Editor-"${VER}" "${D}"/opt/Unity/Editor/Data/PlaybackEngines/Facebook || die
	fi

	doicon "${FILESDIR}"/unity-editor-icon.png
	domenu "${FILESDIR}"/unity-editor.desktop

	make_wrapper unity-editor /opt/Unity/Editor/Unity
}

pkg_postinst() {
	xdg_desktop_database_update
}
