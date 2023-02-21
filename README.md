# Running vscode remote extension host(REH) in FreeBSD

<img width="571" alt="123" src="https://user-images.githubusercontent.com/13010420/220260388-ad70bbb0-5eb8-4d18-a0ad-f6375ee05f8b.png">



Mainly tested with
```
host(server): FreeBSD 13.1-RELEASE-p5 arm64
client(local): Windows 11 x64, VSCodium 1.75.1
```

Things work
- Open/edit/save files
- Rename files
- Integrated terminal with `codium` or `code-oss` command

Things don't work
- Using vscode client [open-remote-ssh #62](https://github.com/jeanp413/open-remote-ssh/issues/62)

# Steps to connect
At client,

1. Download [VSCodium](https://github.com/VSCodium/vscodium/releases).
1. Install [open-remote-ssh](https://github.com/jeanp413/open-remote-ssh) extension.

At host,

Set default shell to bash or zsh. Bash is [needed](https://github.com/jeanp413/open-remote-ssh/blob/ec66e79d26784e45ccb761f0334505e25e255a61/src/serverSetup.ts#L136) even if default shell is zsh
```sh
pkg install bash zsh
chsh -s /usr/local/bin/zsh
```

To get working REH, 2 methods are available.

1. (Recommended) "Fix" vscodium's linux reh server. `pkg install npm` then follow steps from [fix_codium/fix.sh](https://github.com/openingnow/freebsd-vscode-reh/blob/master/fix_codium/fix.sh)
2. Build reh from scratch. Takes ~30 min at 1 core instance and requires 8GB ram. See [build_oss](https://github.com/openingnow/freebsd-vscode-reh/tree/master/build_oss)
