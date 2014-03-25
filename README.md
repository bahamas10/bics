bics - Bash Interactive Configuration System
============================================

A modular framework for interactive bash plugin management
without overcomplicating your `.bashrc`

- [Installation](#installation)
- [Getting Started](#getting-started)
  - [Setup](#setup)
  - [Installing Plugins](#installing-plugins)
- [Plugins](#plugins)
  - [Creating a Plugin](#creating-a-plugin)
  - [Managing Plugins](#managing-plugins)
- [Environment](#environment)
- [Updates](#updates)
- [Dependencies](#dependencies)
- [License](#license)

Installation
------------

You can install `bics` locally by running the following one-liner

    bash <(curl -sS https://raw.github.com/bahamas10/bics/master/bics) init

Running this again after `bics` is installed will upgrade `bics` to the
latest version from GitHub.

Getting Started
---------------

<a name="setup" />

### Setup

After installing `bics`, add the following line to your `.bashrc` file

``` bash
. ~/.bics/bics
```

...and then exec bash to load the plugins

    $ exec bash
    $ bics list
    > test-plugin

As you can see, one plugin has been installed automatically, `test-plugin`.  You can
view its source with:

    $ cat ~/.bics/plugins/test-plugin/*.bash
    # add code here

This plugin doesn't do much, but it shows how to add plugins for use by `bics`.

`bics` will search `~/.bics/plugin/*/*.bash` and source every file matching that glob

To get started, you can delete that plugin by running

    bics remove test-plugin

...or achieve the same thing manually by running

    rm -r ~/.bics/plugins/test-plugin

Now, when you list the installed plugins you'll see nothing

    $ bics ls
    $

Notice that `ls` is an alias for `list`

<a name="installing-plugins" />

### Installing Plugins

Plugins are installed to `~/.bics/plugins` as directories that contain 1 or more
`.bash` files.  See [Plugins](#plugins) below to learn more about how plugins
are published online and made available for download.  For now, let's just install
a simple plugin that is on GitHub.

First, we search for it

    $ bics search cdstack
    cdstack          Store the last X directories visited using cd in bash   https://github.com/bahamas10/bash-cdstack   Dave Eddy       MIT

Then, to install this plugin, we run

    $ bics install https://github.com/bahamas10/bash-cdstack
    Cloning into 'bash-cdstack'...
    remote: Counting objects: 8, done.
    remote: Compressing objects: 100% (6/6), done.
    remote: Total 8 (delta 2), reused 8 (delta 2)
    Unpacking objects: 100% (8/8), done.

This is a shorthand way of running

    cd ~/.bics/plugins && git clone https://github.com/bahamas10/bash-cdstack

And that's it! The plugin is installed, you can start using it by running

    exec bash

to reload the bash environment

You can list installed plugins to see that `cdstack` is present

    $ bics ls
    > bash-cdstack

See [Managing Plugins](#managing-plugins) for more information about storing
plugins in a dotfiles repository as submodules

Run the following to get help on the command line

    $ bics help
    usage: bics [command] [args...]
    (v0.0.8)
    ...

You can also run `bics help` on any plugin to view it's documentation in
your `PAGER` (defaults to `less`).

    $ bics help bash-cdstack

This will open `$PAGER` on the `README.md` file in the repository.  `bics`
scans for files that look like documentation and opens the first one it
finds, the order is:

    {*.txt,*.md,readme,ReadMe,README}

So if you create a plugin and would like to include a help text specifically
for the command line, create a `.txt` file

Plugins
-------

The official list of plugins will be kept in the wiki

https://github.com/bahamas10/bics/wiki/Plugins

And you can also view this by running `bics available`

    $ bics available
    Name             Description                                        Repository      Author          License
    ---              ---                                                ---             ---             ---
    test             something long and descriptive goes here           http://test     Dave Eddy       MIT

<a name="creating-a-plugin" />

### Creating a Plugin

Creating a plugin is meant to be simple and easy.  At the core, a plugin needs
to be a directory with 1 or more `.bash` files that will be sourced upon bash's
execution.  Take a look at the `test-plugin` directory that is created when
`bics` is installed to see how a simple plugin looks.

Ideally, plugins will each have their own repository here on GitHub, and
can be stored in a users dotfiles repository as git submodules.

An example real-world plugin can be seen here https://github.com/bahamas10/bash-cdstack

<a name="managing-plugins" />

### Managing Plugins

You can store your plugins as git submodules stored in a dotfiles repo. An
example can be seen here, specifically the `bics-plugins` directory.

https://github.com/bahamas10/dotfiles

This commit shows an example git submodule added, and logic to install `bics`
initially and symlink the plugins directory accordingly.

https://github.com/bahamas10/dotfiles/commit/50cd7a236069cf98eacf170b2d6629e814075fb8

**NOTE:** if you use this method, `bics install` and `bics update` will not
work as expected, you'll need to manage the plugins manually with `git`

Environment
-----------

`bics` tries not to clutter up your namespace, or clobber variables in your
shell. Below is a list of all variables/functions/aliases created by `bics`

### Global Variables

- `BICS_VERSION` - the version of `bics` when it was sourced
- `BICS_SOURCED` - an array of relative filenames that were sourced by `bics`

example

    $ echo "$BICS_VERSION"
    v0.0.5
    $ printf '%s\n' "${BICS_SOURCED[@]}"
    bash-analysis/analysis.bash
    bash-cdstack/cdstack.bash
    bash-dvorak/dvorak.bash


### Exported Variables

None.

### Aliases

- `bics` - aliased to `~/.bics/bics`

### Functions

- `_bics` - used for bash completion
- `_` - anonymous function used (and cleared) by `bics`

A standard convention for plugins is to use `_` as a throwaway function name to
allow for local variables that don't clutter up the default namespace.  A
similar technique is used in JavaScript to create anonymous, self-executing
functions to avoid creating global variables.

example

``` bash
_() {
  local i=0
  local foo=bar
  echo "$foo" > "/tmp/something.$i"
}
_
```

In this example, `i` and `foo` are not made global.  The only thing made global
is the `_` function

`bics` will unset `_` (the function) after it has finished loading plugins

### Bash Completion

Provided for...

- `bics`

Updates
-------

You can update all plugins, or a specific plugin by running

    $ bics update [name]

If `name` is empty, all plugins are updated

You can update `bics` itself at anytime by running

    $ bics upgrade
    > getting source from https://github.com/bahamas10/bics/raw/master/bics... done

Dependencies
------------

`bics` doesn't require any external programs to source plugins
that are already installed, however some of the extra features require
various programs to be installed.

### `curl`

Required for the one-liner installation, as well as `bics upgrade`, `bics search`
and `bics available`

### `grep`

Required for `bics search` and `bics available`.  Note that GNU `grep` is
not required, any version should suffice.

### `awk`

Required for `bics search` and `bics avaliable`.  Note that GNU `awk` is
not required, any version should suffice.

### `git`

Required for `bics install` and `bics update`.  The only operations done are
`git clone` and `git pull` respectively.

License
-------

MIT
