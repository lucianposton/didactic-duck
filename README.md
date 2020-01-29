Just some ebuilds that may or may not work.

[![Build Status](https://travis-ci.com/lucianposton/didactic-duck.svg?branch=master)](https://travis-ci.com/lucianposton/didactic-duck)
[![Join the chat at https://gitter.im/lucianposton/didactic-duck](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/lucianposton/didactic-duck?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

# How to add this overlay with layman

After installing [layman](http://wiki.gentoo.org/wiki/Layman) with
`emerge layman`, add this overlay:

	layman -fa didactic-duck

The overlay's ebuilds are now available to emerge.

# How to add this overlay manually

Alternatively, add this as a [Local Overlay](https://wiki.gentoo.org/wiki/Overlay/Local_overlay) to `/etc/portage/repos.conf/`.

Create a `/etc/portage/repos.conf/didactic-duck.conf` file containing:

```
[didactic-duck]
location = /usr/local/portage/didactic-duck
sync-type = git
sync-uri = https://github.com/lucianposton/didactic-duck.git
priority = 9999
```

Afterwards, run `emerge --sync` to sync the overlay. The overlay's ebuilds are now available to emerge.
