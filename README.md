# Skittle

A tiny tool for simplifying system provisioning with simple bash scripts.

## Overview

Skittle makes it really easy to script install procedures, configure computers
or do just about anything that takes multiple steps using bash.

It is inspired by [Babushka](http://babushka.me) and encouraged by its
play-on-words cousin, [_Babashka_](https://github.com/richo/babashka), though
it does a few things differently.

## Installation

Because Skittle aims for zero dependencies, it is not intended that you install
it in your system, instead favouring you just add it to your project instead.
It is less than 200 lines long (including whitespace and function definitions)
and lives in a single file.

``` bash
curl -O https://raw.github.com/d11wtq/skittle/master/bin/skittle
```

If you do want to add it to your system, go ahead place it on your `$PATH`.

## Usage

The `skittle` executable takes a single argument, which is the name of a
dependency it should resolve. It looks for that dependency under `./deps`
(relative to where `skittle` is called from).

Let's look at a simple example of creating a log directory for some service.

``` bash
skittle log_dir
```

If we call skittle like this, it will output an error that it cannot find
"log_dir.sh" under ./deps. Let's go ahead and create it.

``` bash
# ./deps/log_dir.sh

log_dir() {
  is_met() {
    ls /path/to/log_dir
  }

  meet() {
    sudo mkdir -p /path/to/log_dir
  }
}
```

Now when we run `skittle log_dir`, we should see some nice green output and
find our newly created log directory. Go ahead and run this command again.
Nothing will happen, because the structure of Skittle dependencies makes them
idempotent.

Let's take a look at what is happening here. First, we define a simple bash
function named exactly as our dependency is named (`log_dir`). Inside that
function, we define two new functions, `is_met`, and `meet`.

Skittle runs the `is_met` function and if it returns non-zero (i.e.
failure/error), it runs the `meet` function, which should fix whatever `is_met`
failed for. Skittle then runs the `is_met` and if it returns non-zero again,
the whole world implodes and Skittle exits. If it is successful, a pass is
reported. In a way, you can think of this as test-driven provisioning. In fact,
Skittle uses Skittle to test itself (see the "./tests/" directory).

Ok, so this was a simple example. A single dependency does not show much at
all. Let's say the log directory needs to writable only by `bob`. Now we have
introduced two new pre-conditions:

  1. That 'bob' exists.
  2. That 'bob' can write to the log directory



## Design Objectives

Like Babushka, Skittle aims to make it really easy to think about large
problems—like how do you provision an entire server or virtual machine with
Apache, PostgreSQL, Memcached and elasticsearch in a way that is easily
reproducible?—in small units. And like _Babashka_, Skittle aims to do that with
no dependencies. So we use bash, because you almost certainly have it available
on your \*nix system.

Unlike _Babashka_, Skittle takes a slightly different approach to dependency
resolution. It makes use of subshells, in order to avoid in-memory state
leakage between your dependencies. You can do things like nesting related
dependencies inside each other and not have to worry about clobbering previous
definitions.
