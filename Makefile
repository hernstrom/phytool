.PHONY: all clean install dist

# Top directory for building complete system, fall back to this directory
ROOTDIR    ?= $(shell pwd)

VERSION = 2
NAME    = phytool
PKG     = $(NAME)-$(VERSION)
ARCHIVE = $(PKG).tar.xz
APPLETS = mv6tool
LIBNAME = simplemdio
LIB     = lib$(LIBNAME)
ABIVERSION = 0
LIB_HEADERS = $(LIBNAME).h
LIB_LDFLAGS = -shared -Wl,-soname,$(LIB).so.$(ABIVERSION)

PREFIX ?= /usr/local/
CFLAGS ?= -Wall -Wextra -Werror -fPIC
LDLIBS  = 

objs = $(patsubst %.c, %.o, $(wildcard *.c))
hdrs = $(wildcard *.h)

%.o: %.c $(hdrs) Makefile
	@printf "  CC      $(subst $(ROOTDIR)/,,$(shell pwd)/$@)\n"
	@$(CC) $(CFLAGS) -c $< -o $@

phytool: $(objs)
	@printf "  CC      $(subst $(ROOTDIR)/,,$(shell pwd)/$@)\n"
	@$(CC) $(LDFLAGS) $(LDLIBS) -o $@ $^

$(LIB).a: $(objs)
	$(AR) rcs $@ $(objs)

$(LIB).so: $(objs)
	$(CXX) $(LDFLAGS) $(LIB_LDFLAGS) -o $@ $(objs) $(LDLIBS)

all: phytool $(LIB).a $(LIB).so

clean:
	@rm -f *.o
	@rm -f *.so *.so.* *.a
	@rm -f $(TARGET)

dist:
	@echo "Creating $(ARCHIVE), with $(ARCHIVE).md5 in parent dir ..."
	@git archive --format=tar --prefix=$(PKG)/ v$(VERSION) | xz >../$(ARCHIVE)
	@(cd .. && md5sum $(ARCHIVE) > $(ARCHIVE).md5)

install: phytool $(LIB).a $(LIB).so
	@cp phytool $(DESTDIR)/$(PREFIX)/bin/
	@for app in $(APPLETS); do \
		ln -sf phytool $(DESTDIR)/$(PREFIX)/bin/$$app; \
	done

	# Install libraries
	install -d -o root -g root -m 0755 $(DESTDIR)/usr/lib
	install -o root -g root -m 0644 $(LIB).a $(DESTDIR)/usr/lib
	install -o root -g root -m 0755 $(LIB).so $(DESTDIR)/usr/lib/$(LIB).so.$(VERSION)
	ln -sf $(LIB).so.$(VERSION) $(DESTDIR)/usr/lib/$(LIB).so.$(ABIVERSION)
	ln -sf $(LIB).so.$(VERSION) $(DESTDIR)/usr/lib/$(LIB).so
	# Install headers
	install -d -o root -g root -m 0755 $(DESTDIR)/usr/include
	for h in $(LIB_HEADERS); do \
		install -o root -g root -m 0644 $$h $(DESTDIR)/usr/include; \
	done