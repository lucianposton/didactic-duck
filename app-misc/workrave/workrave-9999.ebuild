# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-single-r1 versionator cmake-utils git-r3

DESCRIPTION="Helpful utility to attack Repetitive Strain Injury (RSI)"
HOMEPAGE="http://www.workrave.org/"
unset SRC_URI S # indirectly inherited gnome.org eclass sets these
EGIT_REPO_URI="https://github.com/rcaelers/workrave.git"
EGIT_BRANCH="next"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

# dbus support looks to be used only for trying to use panel applets on gnome3!
IUSE="ayatana debug doc dbus gconf gnome gstreamer introspection mate nls pulseaudio test xfce"
REQUIRED_USE="ayatana? ( introspection )"

RDEPEND="
	>=dev-libs/boost-1.62[context]
	>=dev-libs/glib-2.28.0:2[dbus?]
	>=x11-libs/gtk+-3.0:3[introspection?,X]
	>=dev-cpp/gtkmm-3.0.0:3.0
	>=dev-cpp/glibmm-2.28.0:2
	>=dev-libs/libsigc++-2.2.4.2:2
	ayatana? (
		>=dev-libs/libdbusmenu-0.4[gtk3,introspection]
		>=dev-libs/libindicator-0.4:3 )
	gnome? ( >=gnome-base/gnome-shell-3.6.2 )
	gconf? ( gnome-base/gconf )
	gstreamer? (
		media-libs/gstreamer:1.0[introspection?]
		media-libs/gst-plugins-base:1.0[introspection?]
		media-plugins/gst-plugins-meta:1.0 )
	introspection? ( dev-libs/gobject-introspection:= )
	mate? ( mate-base/mate-applets )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.15 )
	xfce? (
		>=x11-libs/gtk+-2.6.0:2[introspection?]
		>=xfce-base/xfce4-panel-4.4 )
	x11-libs/libXScrnSaver
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXtst
	x11-libs/libXt
	x11-libs/libXmu
	dbus? (
		dev-python/jinja
		sys-apps/dbus
		dev-libs/dbus-glib )
"

DEPEND="${RDEPEND}
	dev-python/cheetah
	>=dev-util/intltool-0.40.0
	sys-devel/autoconf-archive
	x11-proto/xproto
	x11-proto/inputproto
	x11-proto/recordproto
	virtual/pkgconfig
	doc? (
		app-text/docbook-sgml-utils
		app-text/xmlto )
	nls? ( >=sys-devel/gettext-0.17 )
"

CMAKE_MIN_VERSION="3.5"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	sed -i -e "/install(FILES README/d" CMakeLists.txt # README missing in src

	cmake-utils_src_prepare
	gnome2_src_prepare
}

src_configure() {
	# gnome_classic_panel requires dev-util/gdbus-codegen and
	# libpanel-applet-4.so from gnome-base/gnome-panel, which no longer is in
	# the gentoo overlay. -DWITH_GNOME_CLASSIC_PANEL="$(usex gnome)"
	local mycmakeargs=(
		-DWITH_UI="Gtk+3" # TODO: use flags to select gtk2 or qt5
		-DWITH_INDICATOR="$(usex ayatana)"
		-DWITH_GCONF="$(usex gconf)"
		-DWITH_GNOME_CLASSIC_PANEL="$(usex gnome)" # TODO: check this
		-DWITH_PULSE="$(usex pulseaudio)"
		-DWITH_TESTS="$(usex test)"
		-DWITH_GSTREAMER="$(usex gstreamer)"
		-DWITH_MATE="$(usex mate)"
		-DWITH_XFCE4="$(usex xfce)"
		-DWITH_DBUS="$(usex dbus)"
		-DWITH_TRACING="$(usex debug)"
	)

	if usex debug ; then
		CMAKE_BUILD_TYPE=Debug
	fi

	cmake-utils_src_configure
}
