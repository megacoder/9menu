TARGETS	=all check clean clobber diff distclean import install uninstall
TARGET	=all

SUBDIRS	=

.PHONY:	${TARGETS} ${SUBDIRS}

PREFIX	=/opt/9menu
BINDIR	=${PREFIX}/bin
MANDIR	=${PREFIX}/share/man/man1

INSTALL	=install

CC	=ccache gcc -march=native --std=gnu99
CFLAGS	=-g -Os -D_FORTIFY_SOURCE=2
LDFLAGS	=-g
LDLIBS	=-lX11

FILES	=9menu
MANFILES=9menu.1

all::	${FILES} ${MANFILES}

${TARGETS}::

clobber distclean:: clean

clean::
	${RM} a.out core.* *.o

clobber distclean::
	${RM} 9menu

define	INSTALL_template
.PHONY: install-${1}
install-${1}: ${1}
	@cmp -s $${BINDIR}/${1} ${1} || $${SHELL} -xc "${INSTALL} -Dc ${1} $${BINDIR}/${1}"
install:: install-${1}
endef

$(foreach f,${FILES},$(eval $(call INSTALL_template,${f})))

define	INSTALL_MAN_template
.PHONY: install-${1}
install-${1}: ${1}
	@cmp -s $${MANDIR}/${1} ${1} || $${SHELL} -xc "${INSTALL} -Dc -m 0644 ${1} $${MANDIR}/${1}"
install:: install-${1}
endef

$(foreach f,${MANFILES},$(eval $(call INSTALL_MAN_template,${f})))

define	UNINSTALL_template
.PHONY: uninstall-${1}
uninstall-${1}: ${1}
	${RM} $${BINDIR}/${1}
uninstall:: uninstall-${1}
endef

$(foreach f,${FILES},$(eval $(call UNINSTALL_template,${f})))

define	UNINSTALL_MAN_template
.PHONY: uninstall-${1}
uninstall-${1}: ${1}
	${RM} $${MANDIR}/${1}
uninstall:: uninstall-${1}
endef

$(foreach f,${MANFILES},$(eval $(call UNINSTALL_template,${f})))

# Keep at bottom so we do local stuff first.

# ${TARGETS}::
#	${MAKE} TARGET=$@ ${SUBDIRS}

# ${SUBDIRS}::
#	${MAKE} -C $@ ${TARGET}
