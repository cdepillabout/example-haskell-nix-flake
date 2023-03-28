# example-haskell-nix-flake

This is an example Nix Flake for building and developing a Haskell application.

After cloning this repository, you should be able to build this Haskell package
with the following command:

```console
$ nix build -L
```

You should be able to jump into a development shell with the following command:

```console
$ nix develop -L
```

From this development shell, you should be able to build the package with
`cabal`:

```console
$ cabal build
```

From the development shell, you should also be able to run
`haskell-language-server` to confirm that it can build all your Haskell
modules:

```console
$ haskell-language-server
...
Completed (1 file worked, 0 files failed)
```
