# helo I am a makefile

MAKEFLAGS += -j

do-it :
	@echo "Doing nothing, these are the targets available"
	@grep '^[^#[:space:]].*:' Makefile
	@echo " "

all: install deb
install:
	mkdir -p /opt/lebackup/
	cp lebackup-files.sh /opt/lebackup/
	cp lebackup-vm.sh /opt/lebackup/
	cp lebackup-all.sh /opt/lebackup/
	cp config-vars.sample /opt/lebackup/
	cp backup-files.list.sample /opt/lebackup/
	cp lebackup.cron /etc/cron.daily/lebackup
	
deb:
	rm -rf output-debian-8-$(disk_size_gb)-qemu
	mkdir pkg-debian
	cd pkg-debian/
	find . -type f ! -regex '.*.hg.*' ! -regex '.*?debian-binary.*' ! -regex '.*?DEBIAN.*' -printf '%P ' | xargs md5sum > DEBIAN/md5sums
	cd ..
	dpkg -b pkg-debian/ disqovery-scripts_"$VERSION"_i386.deb
	mkdir pkg-debian
	mkdir pkg-debian/DEBIAN
	mkdir -p pkg-debian/etc/profile.d
	cat << EOF > pkg-debian/etc/profile.d/disqovery-scripts.sh
	PATH=\$PATH:/opt/disqovery-scripts
	EOF
	packer build \
	-only=qemu \
	-var 'disk_size_gb=$(disk_size_gb)' \
	-var 'disk_size=$(disk_size)' \
	debian-8.json
	find output-debian-8-$(disk_size_gb)-qemu/debian-8-$(disk_size_gb)* -name debian-8-$(disk_size_gb)* | xargs -I'{}' qemu-img convert -f qcow2 -O qcow2 '{}' '{}.qcow2'
