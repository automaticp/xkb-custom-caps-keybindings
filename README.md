# xkb-ijkl-to-arrows-keybind
Instructions on how to bind `CapsLock+Key` to various wiedly used actions like arrow keys, home, end, etc. For xkb on Linux/X11.

Bindings used here are:

`CapsLock + ...`
- `i` = Up
- `j` = Left
- `k` = Down
- `l` = Right
- `u` = Home
- `o` = End
- `,` = Backspace
- `.` = Delete
- `p` = Menu
- `[` = PageDown
- `]` = PageUp

But they can rebound in `symbols/custom_caps`.

WARNING: Setting something incorrectly in the xkb config files can make X fail at startup, locking you out of the ability to log in. Make sure you know how to recover in that case.

# Instructions TLDR:

```
git clone https://github.com/automaticp/xkb-ijkl-to-arrows-keybind

cd xkb-ijkl-to-arrows-keybind

./make_backup.sh

sudo ./copy_files.sh
```


Replace all lines mentioning CapsLock in `/usr/share/X11/xkb/compat/complete` with

```
augment "custom_caps"
```


Open `/usr/share/X11/xkb/types/complete` and add to the end of the list:

```
include "custom_caps"
```


Choose a file in `/usr/share/X11/xkb/symbols/` that corresponds to your keyboard layout and add to the end of the base layout the following:
```
include "custom_caps"
```


Add in your X/Window Manager startup file the following:

```
xset r 30 # u
xset r 31 # i
xset r 32 # o
xset r 33 # p
xset r 34 # [
xset r 35 # ]
xset r 44 # j
xset r 45 # k
xset r 46 # l
xset r 59 # ,
xset r 60 # .
```

Log out, log back in. Done.

Full instructions below.

# Step 1: Copy custom files

From project root:

## Make backup of default xkb config files

```
./make_backup.sh [optional_path_to_place_backup]
```
This will create backups of the contents of `compat/`, `types/` and `symbols/` from `/usr/share/X11/xkb/` in the currend directory, or one specified as an argument.

## Copy/symlink custom config files to xkb

```
./copy_files.sh
```

or

```
./symlink_files.sh
```

# Step 2: Edit original config files

## Edit `compat/complete`

Open `/usr/share/X11/xkb/compat/complete` in any text editor.

Replace all lines mentioning CapsLock with

```
augment "custom_caps"
```

For example, if the original `complete` looks like

```
default xkb_compatibility "complete" {
    include "basic"
    augment "iso9995"
    ...
    augment "level5"
    augment "caps(caps_lock)"
};
```

After replacement it should look like this

```
default xkb_compatibility "complete" {
    include "basic"
    augment "iso9995"
    ...
    augment "level5"
    augment "custom_caps"
};
```

## Edit `types/complete`

Open `/usr/share/X11/xkb/types/complete` and add

```
include "custom_caps"
```

to the end of the list. The result should look like this

```
default xkb_types "complete" {
    include "basic"
    include "mousekeys"
    ...
    include "numpad"
    include "custom_caps"
};
```

## Edit `symbols/[your-symbols-table]`

Choose a file in `/usr/share/X11/xkb/symbols/` that corresponds to your keyboard layout. For example, `symbols/us` is a symbol table defining variants of the `English (US)` layout. You can find the list of all layout variants in `/usr/share/X11/xkb/rules/evdev.lst`

We'll be extending the `us` layout with our custom keybinds. Opening `symbols/us` we first see a "basic" `us` layout. Every layout following the "basic" is its _variant_ and "inherits" from it by `include`'ing it's contents.

```
default partial alphanumeric_keys modifier_keys
xkb_symbols "basic" {

    name[Group1]= "English (US)";

    key <TLDE> {	[     grave,	asciitilde	]	};
    key <AE01> {	[	  1,	exclam 		]	};
    key <AE02> {	[	  2,	at		]	};
    ...
    key <AD01> {	[	  q,	Q 		]	};
    key <AD02> {	[	  w,	W		]	};
    key <AD03> {	[	  e,	E		]	};
    key <AD04> {	[	  r,	R		]	};
    key <AD05> {	[	  t,	T		]	};
    key <AD06> {	[	  y,	Y		]	};
    ...
    key <BKSL> {	[ backslash,         bar	]	};
};
```

What we'll do is is we'll `include` our custom layout at the end of "basic"; this will automatically affect all the variants of the `English (US)` layout.

The result should look like this:

```
default partial alphanumeric_keys modifier_keys
xkb_symbols "basic" {

    name[Group1]= "English (US)";

    key <TLDE> {	[     grave,	asciitilde	]	};
    ...
    key <BKSL> {	[ backslash,         bar	]	};

    include "custom_caps"

};
```


# Step 3: Edit X startup files

If you'll try to restart X right now, you might notice that the keybinds work, but when held they don't produce repeat keystrokes. This is an issue with using `RedirectKey()` in our `symbols/custom_caps`, it's either bugged, or does not respond to the `repeat` option. In my travels across very few of the resources on xkb, I've seen some people hint that it should work, and 've heard others say that it doesn't. On my Ubuntu 22.04, it doesn't.

We specifically want to use `RedirectKey()`, because it produces an actual _keycode_ and not some _virtual key_. Lots of software have difficulty understanding virtual keycodes, so it's best to avoid simple rebinding.

There's a workaround, of course. You can reenable repeat presses by adding in your X/Window Manager startup file the following:

```
# set repeat for keys that were overriden in xkb
# neccesary due to 'repeat = true' not working
# in xkb_symbols (bug?)
xset r 30 # u
xset r 31 # i
xset r 32 # o
xset r 33 # p
xset r 34 # [
xset r 35 # ]
xset r 44 # j
xset r 45 # k
xset r 46 # l
xset r 59 # ,
xset r 60 # .
```

I'm running Gnome, so I've just added this to `~/.gnomerc`.


# Step 4: Enjoy life until the next system update

The real reason I'am writing these instructions is that a recent system update wiped all of my custom keybindings, that I, about half a year ago, had haphazardly put together out of scraps of information that I could find on xkb. It cost me a week of pain to actually get a somewhat stable version done. And then it was gone...
And of course by that time I barely remembered anything.

This time I did it better, and tried to almost not touch default config files. The gist is that some system updates are likely to reset these files, like `types/complete` and `symbols/us`. So upon an update, if everything breaks, redo step 2.
