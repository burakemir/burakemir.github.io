# Makefile for web content and apps.
TARGETS=index.html blog.html about.html research.html

# The file below defines variables:
#   location_arrow_logo:
#     location of the arrow logo build from.
#   location_deploy:
#     location of the burakemir.github.io repository
include Makefile.parameters

all: $(TARGETS) arrowlogo

arrowlogo:
	make -C $(location_arrow_logo)
	rsync -av $(location_arrow_logo)/build/ arrowlogo

deploy:
	cp -f $(TARGETS) $(location_deploy)/
	cp -f static/* $(location_deploy)/
	rsync -av $(location_arrow_logo)/build/ $(location_deploy)/arrowlogo

%.html: %.rkt
	if [ -f $@ ]; then chmod +w $@; fi
	racket -t $< > $@
	chmod -w $@

clean:
	rm -f $(TARGETS)
	rm -Rf arrowlogo
