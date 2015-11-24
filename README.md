Just some ebuilds that may or may not work.

# How to use this overlay

[Local overlays](https://wiki.gentoo.org/wiki/Overlay/Local_overlay) should be managed via `/etc/portage/repos.conf/`.
To enable this overlay make sure you are using a recent Portage version (at least `2.2.14`), and create an `/etc/portage/repos.conf/didactic-duck.conf` file containing:

```
[didactic-duck]
location = /usr/local/portage/didactic-duck
sync-type = git
sync-uri = https://github.com/lucianposton/didactic-duck.git
priority=9999
```

Afterwards, simply run `emerge --sync`, and Portage should sync this respository.

# With layman

Following the instructions on the [Gentoo Wiki](http://wiki.gentoo.org/wiki/Layman#Adding_custom_overlays), invoke the following:

	layman -o https://raw.github.com/lucianposton/didactic-duck/master/repositories.xml -f -a didactic-duck

Add `https://raw.github.com/lucianposton/didactic-duck/master/repositories.xml` to overlays section in `/etc/layman/layman.cfg`.

After performing those steps, the ebuilds in this overlay should be available to emerge.
