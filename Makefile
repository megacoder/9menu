TARGETS	=all check clean clobber diff distclean import install uninstall
TARGET	=all

SUBDIRS	=

.PHONY:	${TARGETS} ${SUBDIRS}

PREFIX	=/opt
BINDIR	=${PREFIX}/bin

INSTALL	=install

CC	=ccache gcc -march=native --std=gnu99
CFLAGS	=-g -Os -D_FORTIFY_SOURCE=2
LDFLAGS	=-g
LDLIBS	=-lx11

FILES	=9menu

all::	${FILES}

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

define	UNINSTALL_template
.PHONY: uninstall-${1}
uninstall-${1}: ${1}
	${RM} $${BINDIR}/${1}
uninstall:: uninstall-${1}
endef

$(foreach f,${FILES},$(eval $(call UNINSTALL_template,${f})))

# Keep at bottom so we do local stuff first.

# ${TARGETS}::
#	${MAKE} TARGET=$@ ${SUBDIRS}

# ${SUBDIRS}::
#	${MAKE} -C $@ ${TARGET}
