TEXT_PAGINATION := true
LIBDIR := lib
include $(LIBDIR)/main.mk

$(LIBDIR)/main.mk:
ifneq (,$(shell grep "path *= *$(LIBDIR)" .gitmodules 2>/dev/null))
	git submodule sync
	git submodule update --init
else
ifneq (,$(wildcard $(ID_TEMPLATE_HOME)))
	ln -s "$(ID_TEMPLATE_HOME)" $(LIBDIR)
else
	git clone -q --depth 10 -b main \
	    https://github.com/martinthomson/i-d-template $(LIBDIR)
endif
endif

prep: lists.md

lists.md: draft-ietf-cbor-edn-literals.xml
	kramdown-rfc-extract-figures-tables -trfc $< >$@.new
	mv $@.new $@

# gem install edn-abnf cbor-cri
check-cdn: sou
	for i in sou/cbor-diag/*.cbor-diag; do echo; echo $$i:; edn-abnf -Tw30 -acri $$i; done

# install bap from https://github.com/ietf-tools/bap
check-abnf: sou
	for i in sou/abnf/*.abnf; do echo; echo $$i:; bap -oRFC7405 $$i; done

sou: draft-ietf-cbor-edn-literals.xml
	kramdown-rfc-extract-sourcecode -dsou $<
