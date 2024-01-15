# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Ebuild also allows to download .iso file with given host software for Windows.

EAPI=7

MY_PN="LookingGlass"
MY_PV="${PV//1_beta/B}"
MY_PV="${MY_PV//_/-}"

inherit cmake git-r3

DESCRIPTION="An extremely low latency KVMFR (KVM FrameRelay) implementation for guests with VGA PCI Passthrough."
HOMEPAGE="https://looking-glass.io"

EGIT_REPO_URI="https://github.com/gnif/LookingGlass.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="wayland pipewire X"

RDEPEND="dev-libs/libconfig:0=
	dev-libs/nettle:=[gmp]
	media-libs/freetype:2
	media-libs/fontconfig:1.0
	media-libs/libsamplerate
	gui-libs/libdecor
	virtual/glu
	X? (
		x11-libs/libX11
		x11-libs/libXfixes
		x11-libs/libXi
		x11-libs/libXScrnSaver
		x11-libs/libXpresent
	)
	wayland? (
		dev-libs/wayland
	)"
DEPEND="${RDEPEND}
	app-emulation/spice-protocol
	dev-libs/wayland-protocols"
BDEPEND="virtual/pkgconfig"

CMAKE_USE_DIR="${S}"/client

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	default

	cmake_src_prepare
}

src_configure() {
	if ! use X ; then
		local mycmakeargs+=(
			-DENABLE_X11=no
		)
	fi

	if ! use wayland ; then
		local mycmakeargs+=(
			-DENABLE_WAYLAND=no
		)
	fi

	if ! use pipewire ; then
		local mycmakeargs+=(
			-DENABLE_PIPEWIRE=no
		)
	fi

	local mycmakeargs+=(
			-DENABLE_LIBDECOR=yes
	)

	cmake_src_configure
}

src_install() {
	einstalldocs

	dobin "${BUILD_DIR}"/looking-glass-client
}

pkg_postinst() {
	default
}
