all:
	dub --force; \
	cd tests; \
	dub --force;

gdc:
	dub --compiler=gdc; \
	cd tests; \
	dub --compiler=gdc;
