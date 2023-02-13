# towm - Tom Oliver's window manager
#
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c towm.c util.c
OBJ = ${SRC:.c=.o}

all: options towm

options:
	@echo towm build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	mkdir -p /etc/xdg/towm
	cp config.def.h /etc/xdg/towm/towm.default.h

towm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f towm ${OBJ} towm-${VERSION}.tar.gz

setup:
	rm -fr ${DESTDIR}${PREFIX}/share/towm
	mkdir -p ${DESTDIR}${PREFIX}/share/towm
	cp -R LICENSE Makefile README config.def.h config.mk\
		towm.1 drw.h util.h ${SRC} transient.c ${DESTDIR}${PREFIX}/share/towm

dist: clean
	mkdir -p towm-${VERSION}
	cp -R LICENSE Makefile README config.def.h config.mk\
		towm.1 drw.h util.h ${SRC} transient.c towm-${VERSION}
	tar -cf towm-${VERSION}.tar towm-${VERSION}
	gzip towm-${VERSION}.tar
	rm -rf towm-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f towm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/towm
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < towm.1 > ${DESTDIR}${MANPREFIX}/man1/towm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/towm.1

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/towm\
		${DESTDIR}${MANPREFIX}/man1/towm.1

.PHONY: all options clean setup dist install uninstall
