# Skittle

A tiny tool for simplifying system provisioning with simple bash scripts.

[![Build Status](https://secure.travis-ci.org/d11wtq/skittle.png?branch=master)]
(http://travis-ci.org/d11wtq/skittle)

## Overview

Skittle makes it really easy to script install procedures, configure computers
or do just about anything that takes multiple steps using bash.

It is inspired by [Babushka](http://babushka.me) and encouraged by its
play-on-words cousin, [_Babashka_](https://github.com/richo/babashka), though
it does a few things differently.

## Installation

Because Skittle aims for zero dependencies, it is not intended that you install
it in your system, instead prefering that you just add it to your project
directly. It is less than 200 lines long (including whitespace and function
definitions) and lives in a single file.

``` bash
curl -O https://raw.github.com/d11wtq/skittle/master/bin/skittle
chmod +x skittle
```

If you do want to add it to your system, go ahead place it on your `$PATH`.

## Usage

There are very few concepts to learn when it comes to using Skittle. The first,
concept is knowing that the `skittle` executable takes a single argument, which
is the name of a dependency it should resolve.

The second concept, is that a dependency is just a function that defines two
other functions to indicate if it needs to run, and also how to run it.

Finally, dependencies may specify other depdencies that they require to run
(i.e. they are recursive).

Let's look at a simple example of creating a log directory for a fictonal
service called "wibble" (I don't know, it was just a name that came to mind!)

We'll run this fictional dependency like so.

```
bash-3.2$ ./skittle log_dir
+ log_dir
|
\ [fail] log_dir
Error: Cannot find dependency 'log_dir'
```

As you might expect, this produces an error, because we haven't actually
specified what the `log_dir` dependency should do. We need to create a file
named "./deps/log_dir.sh" and add a small amount of code.

``` bash
# ./deps/log_dir.sh

log_dir() {
  dir_path=/var/log/wibble

  is_met() {
    ls $dir_path
  }

  meet() {
    sudo mkdir $dir_path
  }
}
```

Save the file and go ahead and run `skittle log_dir` again, you should see
everything go green and an `[ok]` indicator.

```
bash-3.2$ skittle log_dir
+ log_dir
|
\ [ok] log_dir
bash-3.2$
```

> **Note** `sudo` may prompt for your password when you run this dep.

If you take a look , /var/log/wibble should have been created.

Quite simply, Skittle looks for your depedency under ./deps, using the
convention that it has a file name matching the dependency, but ending in
".sh".

Next, it evaluates the function—in a subshell—knowing that it produces `is_met`
and `meet` functions.

If the `is_met` function returns a zero exit status, nothing happens. If,
however it returns non-zero, it runs the `meet` function which should cause
subsequent calls to `is_met` to return zero. Following this patterns makes
Skittle dependencies idempotent. Go ahead and run it again. It still returns
ok.

Ok, so this example was a bit basic. Creating the directory alone is probably
not enough. Let's ensure that directory is writable only to a user named
`wibble`. We now have to do four things to satisfy `log_dir`:

  1. Ensure the directory exists.
  2. Ensure the wibble user exists.
  3. Ensure the directory is owned by wibble.
  4. Ensure the directory has 755 permissions.

We'll use Skittle's `require` function for this.

``` bash
# ./deps/log_dir.sh

log_dir() {
  dir_path=/var/log/wibble

  dir_exists() {
    is_met() {
      ls $dir_path
    }

    meet() {
      sudo mkdir $dir_path
    }
  }

  dir_ownership() {
    wibble_user_exists() {
      is_met() {
        id wibble
      }

      meet() {
        sudo useradd wibble
      }
    }

    is_met() {
      [[ `ls -ld $dir_path | awk '{print $3}'` = "wibble" ]]
    }

    meet() {
      sudo chown -R wibble: $dir_path
    }

    require wibble_user_exists
  }

  dir_permissions() {
    is_met() {
      [[ `ls -ld $dir_path | awk '{print $1}'` = "drwxr-xr-x" ]]
    }

    meet() {
      sudo chmod -R 0755 $dir_path
    }
  }

  require dir_exists
  require dir_ownership
  require dir_permissions
}
```

Now when we run `skittle log_dir`, we see it executes a tree. Again, this is
idempotent—you can run it over and over just fine.

```
bash-3.2$ skittle log_dir
+ log_dir
|
+-+ dir_exists
| |
| \ [ok] dir_exists
|
+-+ dir_ownership
| |
| +-+ wibble_user_exists
| | |
| | \ [ok] wibble_user_exists
| |
| \ [ok] dir_ownership
|
+-+ dir_permissions
| |
| \ [ok] dir_permissions
|
\ [ok] log_dir
bash-3.2$
```

Notice that the original `log_dir` code moved into an inner depedency called
`dir_created`, since it was only checking if the log directory existed. The
other requirements have then been stated using `require`.

Notice also that `dir_ownership` has a nested dependency `wibble_user_exists`.
This is allowed with Skittle so that you can group related dependencies
together. In this case however, `wibble_user_exists` probably doesn't belong
here, as it is not directly related to the log directory. It is very simple to
just move the function definition to ./deps/wibble_user_exists.sh. Try it,
everything should work the same.

### Parameterized dependencies

Sometimes it is useful for dependencies to accept arguments, so that they
become more general and re-usable. A great example of this is
`wibble_user_exists`. The code here could work for any user, so we can
generalize it and accept a username as an argument. Because dependencies are
just bash functions, arguments are numbered `$1`, `$2` etc.

``` bash
# ./deps/user_exists.sh

user_exists() {
  username=$1

  is_met() {
    id $username
  }

  meet() {
    sudo useradd $username
  }
}
```

Now we can change `log_dir` to use this generalized dep instead.

``` bash
# ./deps/log_dir.sh

log_dir() {
  dir_path=/var/log/wibble

  # ... snip ...

  dir_ownership() {
    require user_exists wibble

    is_met() {
      [[ `ls -ld $dir_path | awk '{print $3}'` = "wibble" ]]
    }

    meet() {
      sudo chown -R wibble: $dir_path
    }
  }

  # ... snip ...
}
```

> **Note** It is important to store the function arguments to variables so they
>          can be used inside `is_met` and `meet`.

That's pretty much all there is to it!

## Behavioural Tests

Skittle uses itself to test itself. To run the tests, run the 'tests' dep.

```
./bin/skittle tests
```

Reading through the test code (in the deps directory) is good way to see an
example of Skittle code too.

## Design Objectives

Like Babushka, Skittle aims to make it really easy to think about large
problems—like how do you provision an entire server or virtual machine with
Apache, PostgreSQL, Memcached and elasticsearch in a way that is easily
reproducible?—in small units. And like _Babashka_, Skittle aims to do that with
no dependencies. So we use bash, because you almost certainly have it available
on your \*nix system and most of the things you do when provisioning machines
call system commands. Shell scripting just makes sense.

Unlike _Babashka_, Skittle takes a slightly different approach to dependency
resolution. It makes use of subshells, in order to avoid in-memory state
leakage between your dependencies. You can do things like nesting related
dependencies inside each other and not have to worry about clobbering previous
definitions. It is also smaller and provides a more readable output format.

## Copyright &amp; Licensing

Copyright &copy; 2014 Chris Corbyn. See the LICENSE file for details.
