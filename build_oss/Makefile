PORTNAME=		vscode-reh
DISTVERSION=	1.75.1
CATEGORIES=		editors

MAINTAINER=		openingnow@naver.com
COMMENT=		Remote extension host(REH) for vscode
WWW=			https://code.visualstudio.com/

LICENSE=		MIT
LICENSE_FILE=	${WRKSRC}/LICENSE.txt

RUN_DEPENDS=	bash:shells/bash
BUILD_DEPENDS=	npm:www/npm-node${NODE_VER} yarn:www/yarn-node${NODE_VER}

USES=			nodejs:build,${NODE_VER} python:build

USE_GITHUB=		yes
GH_ACCOUNT=		Microsoft
GH_PROJECT=		vscode

NODE_VER=		16 # see https://github.com/microsoft/vscode/blob/441438abd1ac652551dbe4d408dfcec8a499b8bf/build/gulpfile.reh.js#L128
CODE_COMMIT=	441438abd1ac652551dbe4d408dfcec8a499b8bf
CODIUM_COMMIT=	c6a9727b801542499d2b59cb7db4224e060fc578
CLIENT_COMMIT=	${CODIUM_COMMIT}

do-patch:
# part of patches from vscode port(https://github.com/freebsd/freebsd-ports/tree/main/editors/vscode)
	${REINPLACE_CMD} "s/case 'linux':/case'freebsd':/" ${WRKSRC}/src/vs/platform/environment/node/userDataPath.js
	${REINPLACE_CMD} "s/process.platform === 'linux'/process.platform === 'freebsd'/" ${WRKSRC}/src/bootstrap-node.js
	${REINPLACE_CMD} "s|cp.execSync|//|" ${WRKSRC}/build/npm/postinstall.js

# patch @parcel/watcher.
# Log says File Watcher still segfaults after patching but looks like everything is working fine XD
# See https://github.com/parcel-bundler/watcher/pull/128
	${REINPLACE_CMD} 's|"@parcel/watcher": "2.1.0",|"@parcel/watcher": "jiegec/watcher",|' ${WRKSRC}/package.json
	${REINPLACE_CMD} 's|"@parcel/watcher": "2.1.0",|"@parcel/watcher": "jiegec/watcher",|' ${WRKSRC}/remote/package.json

# remove keytar to remove libsecret, pkgconf dependency
	${REINPLACE_CMD} 's|"keytar": "7.9.0",| |' ${WRKSRC}/package.json
	${REINPLACE_CMD} 's|"keytar": "7.9.0",| |' ${WRKSRC}/remote/package.json

# disable native-keymap to remove libx11, libxkbfile dependencies
# I hope there is a better method to prevent building
	fetch https://registry.npmjs.org/native-keymap/-/native-keymap-3.3.2.tgz -o ${WRKSRC}/
	tar -xf ${WRKSRC}/native-keymap-3.3.2.tgz -C ${WRKSRC}
	${RM} ${WRKSRC}/native-keymap-3.3.2.tgz
	${MV} ${WRKSRC}/package ${WRKSRC}/native-keymap
	${RM} ${WRKSRC}/native-keymap/index.js ${WRKSRC}/native-keymap/binding.gyp
	${TOUCH} ${WRKSRC}/native-keymap/index.js
	${REINPLACE_CMD} 's|"native-keymap": "3.3.2",|"native-keymap": "file:./native-keymap",|' ${WRKSRC}/package.json

# remove @vscode/sqlite3 to remove pkgconf dependency
	${REINPLACE_CMD} 's|"@vscode/sqlite3": "5.1.2-vscode",| |' ${WRKSRC}/remote/package.json

do-build:
	cd ${WRKSRC} && ELECTRON_SKIP_BINARY_DOWNLOAD=1 yarn
	cd ${WRKSRC} && yarn gulp vscode-reh-linux-x64 # {arch} only affects node which will be replaced later
# See https://github.com/microsoft/vscode/blob/441438abd1ac652551dbe4d408dfcec8a499b8bf/build/gulpfile.reh.js#L398

# pkg-plist is needed to implement do-install
# temporarily perform installation at build phase
### Install for a vscodium client
	${CP} -R ${WRKDIR}/vscode-reh-linux-x64 ${WRKDIR}/${CLIENT_COMMIT}
	${MV} ${WRKDIR}/${CLIENT_COMMIT}/bin/code-server-oss ${WRKDIR}/${CLIENT_COMMIT}/bin/codium-server
	${RM} ${WRKDIR}/${CLIENT_COMMIT}/node
	${CP} ${LOCALBASE}/bin/node ${WRKDIR}/${CLIENT_COMMIT}/node
	${REINPLACE_CMD} 's/${CODE_COMMIT}/${CLIENT_COMMIT}/'         ${WRKDIR}/${CLIENT_COMMIT}/product.json
	${REINPLACE_CMD} 's/"code-server-oss"/"codium-server"/'       ${WRKDIR}/${CLIENT_COMMIT}/product.json
	${REINPLACE_CMD} 's/".vscode-server-oss"/".vscodium-server"/' ${WRKDIR}/${CLIENT_COMMIT}/product.json

	${MKDIR} ~/.vscodium-server/bin
	${CP} -R ${WRKDIR}/${CODIUM_COMMIT} ~/.vscodium-server/bin/

.include <bsd.port.mk>
