# data-ops-challenge

## The challenge

There's a script in this directory, `transform.bash`, but it's missing
a few things.

1. There's a permission error on the script if you `nix build` it. There's
   two possible fixes for this
    * `chmod` - no need to touch `flake.nix`
    * edit `flake.nix`
2.  Modify the `jq` script for transforming users to also include records
    with users' phones.
3.  Add an `xsv` command for joining the `{users,policies}.csv` files on
    the `user_id` column.


## Getting around

You're welcome to install `nix` but the easiest way to get going
is through `docker`. Install docker, if you haven't already, and
run:

```
./docker-shell.bash
```

This will put you in a shell with the `nix` command available.
You can test things are working by running:

```
nix build
```

**As stated above** this will give an error. Let's try to fix that.
To start developing, run

```
nix develop
```

Now, you'll be in a shell with the dev tools for the challenge, namely
`jq` and `xsv`.

```
bash-5.2$ jq
jq - commandline JSON processor [version 1.7.1]

Usage:  jq [options] <jq filter> [file...]
...
```

The `transform.bash` script uses a `BUILD_DIR` environment variable for
controling where things get built to. Our convetion is a directory named
`build`, set it up like so:

```
mkdir build
export BUILD_DIR=$PWD/build
```

Now you can get up and running on fixing `transform.bash`! But one last
thing, `nix build` runs the test to check if you've got the right output,
but you can run the test manually with:

```
diff tests/output.csv user-policies.csv
```

