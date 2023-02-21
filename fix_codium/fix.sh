

CODIUM_HASH='c6a9727b801542499d2b59cb7db4224e060fc578'
VERSION='1.75.1'
RELEASE='23040'
ARCH='arm64'

mkdir ${CODIUM_HASH}
cd ${CODIUM_HASH}
# yarn add spdlog@0.13.7 node-pty@0.11.0-beta27 @parcel/watcher@2.1.0 native-watchdog@1.4.1
npm add spdlog@0.13.7 node-pty@0.11.0-beta27 jiegec/watcher native-watchdog@1.4.1 
# patched @parcel/watcher@2.1.0 is needed
# see https://github.com/parcel-bundler/watcher/pull/128

#  remote/package.json
#    "spdlog": "^0.13.0",
#    "node-pty": "0.11.0-beta27",
#    "@parcel/watcher": "2.1.0",
#    "native-watchdog": "1.4.1",

# mkdir -p x64 && cd x64 && fetch https://github.com/VSCodium/vscodium/releases/download/1.75.1.23040/vscodium-reh-linux-x64-1.75.1.23040.tar.gz -o a.tar.gz && tar -xf a.tar.gz && cd ..
# mkdir -p arm64 && cd arm64 && fetch https://github.com/VSCodium/vscodium/releases/download/1.75.1.23040/vscodium-reh-linux-arm64-1.75.1.23040.tar.gz -o a.tar.gz && tar -xf a.tar.gz && cd ..
# diff -r x64 arm64
# see binary diffs


# rm -rf package.json yarn.lock
rm -rf package.json package-lock.json
mv node_modules node_modules_patch

fetch "https://github.com/VSCodium/vscodium/releases/download/${VERSION}.${RELEASE}/vscodium-reh-linux-${ARCH}-${VERSION}.${RELEASE}.tar.gz" -o reh.tar.gz
tar -xf reh.tar.gz
rm reh.tar.gz
cp -f /usr/local/bin/node .

mv -f node_modules_patch/spdlog/build/Release/* node_modules/spdlog/build/Release/
mv -f node_modules_patch/node-pty/build/Release/* node_modules/node-pty/build/Release/
mv -f node_modules_patch/@parcel/watcher/build/Release/* node_modules/@parcel/watcher/build/Release/
mv -f node_modules_patch/native-watchdog/build/Release/* node_modules/native-watchdog/build/Release/

sed -i '' 's/Application Support");break;case"linux"/Application Support");break;case"freebsd"/' out/vs/platform/terminal/node/ptyHostMain.js
# https://github.com/microsoft/vscode/blob/224472b8b914862214db6faa9385afa40427acf8/src/vs/platform/environment/node/userDataPath.js#L94

sed -i '' 's/C=d.platform==="linux"/C=d.platform==="freebsd"/' out/vs/server/node/server.main.js
# https://github.com/microsoft/vscode/blob/0f9d0328ebe1eccd28e4de11ece14f4b0db3e818/src/vs/base/common/platform.ts#L107
# Set Extension `TargetPlatform` to Linux

# find .vscodium-server -type f -name '*.js' -exec cat {} \; | grep "'linux'"

cd ../
rm -rf ~/.vscodium-server
mkdir -p ~/.vscodium-server/bin/
mv ${CODIUM_HASH} ~/.vscodium-server/bin/
