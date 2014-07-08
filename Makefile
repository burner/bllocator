all:
	dub ; \
	cd tests; \
	dub ;

gdc:
	dub --compiler=gdc; \
	cd tests; \
	dub --compiler=gdc;
