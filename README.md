Just some ebuilds that may or may not work.

# How to add this overlay with layman

[![Join the chat at https://gitter.im/lucianposton/didactic-duck](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/lucianposton/didactic-duck?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Use layman to add and manage this overlay. Following the instructions from the [Gentoo Wiki](http://wiki.gentoo.org/wiki/Layman#Adding_custom_overlays):

	layman -o https://raw.github.com/lucianposton/didactic-duck/master/repositories.xml -f -a didactic-duck

The overlay's ebuilds are now available to emerge.

# How to add this overlay manually

Alternatively, add this as a [Local Overlay](https://wiki.gentoo.org/wiki/Overlay/Local_overlay) to `/etc/portage/repos.conf/`.

Create a `/etc/portage/repos.conf/didactic-duck.conf` file containing:

```
[didactic-duck]
location = /usr/local/portage/didactic-duck
sync-type = git
sync-uri = https://github.com/lucianposton/didactic-duck.git
priority=9999
```

Afterwards, run `emerge --sync` to sync the overlay. The overlay's ebuilds are now available to emerge.
