
deps/apt:
	apt install -y \
		build-essential \
		libx11-dev \
		libxinerama-dev \
		libx11-xcb-dev \
		libxcb-res0-dev \
		maim \
		xclip \
		pavucontrol \
		meson \
		cmake \
		sudo \
		nodm \
		fuse \
		vim \
		libharfbuzz-dev \
		libpulse-dev \
		libboost-all-dev \
		libnotify-bin \
		unifont \
		fonts-noto-color-emoji \
		dunst


deps/libxft:
	( cd libxft-bgra && \
		sh autogen.sh --sysconfdir=/etc --prefix=/usr --mandir=/usr/share/man && \
		make install)

deps/pamixer: 
	(cd pamixer && meson setup build && meson compile -C build&& meson install -C build)
deps/fonts:
	(
	
deps/docker:
	curl -fsSL get.docker.com | bash
	bash scripts/nvidia-docker.sh

deps: deps/apt deps/libxft deps/pamixer
	
config:
	usermod -aG sudo $(shell ls /home)
	usermod -aG docker $(shell ls /home)
	grep  fs.inotify.max_user_watches=524288 /etc/sysctl.conf || ( echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf && sysctl -p )
	sed s/NODM_USER=.*/NODM_USER=$(shell ls /home)/g /etc/default/nodm

install: deps config 

clean:
	(cd dwm && make clean)
	(cd dmenu && make clean)
	(cd dwmblocks && make clean)
	(cd pamixer && rm -rf build)
	(cd st && make clean)
