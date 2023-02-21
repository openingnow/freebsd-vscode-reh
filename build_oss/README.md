This port is incomplet and incorrekt. Contributions are welcome.

Known issues
- Malfunctioning `Source Control`(ctrl shift g) tab
- Excess default extensions
- `install` target is not implemented
- `patch` and `build` targets require internet connection.
    - https://forums.freebsd.org/threads/node-js-based-ports-how-do-you-handle-the-npm-install.56659/
    - https://forums.freebsd.org/threads/porting-applications-that-use-dependency-managers.74147/
- Uses sed instead of files/patch-* for static diffs https://docs.freebsd.org/en/books/porters-handbook/book/#slow-patch-automatic-replacements

Initialize ports tree
```sh
pkg install git
git clone https://github.com/freebsd/freebsd-ports --depth 1 /usr/ports
```

Build and install REH server.
```sh
pkg install python yarn-node16 npm-node16 node16 git
git clone https://github.com/openingnow/freebsd-vscode-reh --depth 1
cd freebsd-vscode-reh/build_oss
make build # server installed at `~/.vscodium-server`
```

