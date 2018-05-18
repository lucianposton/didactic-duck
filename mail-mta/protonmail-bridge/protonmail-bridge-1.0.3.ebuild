# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rpm

DESCRIPTION="Serves ProtonMail to IMAP/SMTP clients"
HOMEPAGE="https://protonmail.com/bridge/"
SRC_URI="https://protonmail.com/download/${P}-1.x86_64.rpm"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="
	app-crypt/libsecret
	dev-libs/glib
	media-libs/mesa
	media-sound/pulseaudio
	virtual/opengl
"

S="${WORKDIR}"

src_install() {
	# Using doins -r would strip executable bits from all binaries
	cp -pPR "${S}"/usr "${D}"/ || die "Failed to copy files"

	cat <<EOF > "${T}/50-${PN}"
SEARCH_DIRS_MASK="/usr/lib*/protonmail/bridge"
EOF
	insinto /etc/revdep-rebuild
	doins "${T}/50-${PN}"
}
