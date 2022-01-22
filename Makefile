# Makefile for web content and apps.
TARGETS=index.html blog.html about.html research.html webapp-container.png 

# The file below defines variables:
#   location_arrow_logo:
#     location of the arrow logo build from.
#   location_deploy:
#     location of the burakemir.github.io repository
include Makefile.parameters

resources=homepage.css hilbert.js

all : $(TARGETS) arrowlogo

arrowlogo :
	make -C $(location_arrow_logo)
	rsync -av $(location_arrow_logo)/build/ arrowlogo

deploy : $(location_deploy)
	cd $(location_deploy); git pull
	cp -f $(TARGETS) $(location_deploy)/
	cp -f $(resources) $(location_deploy)/
	cp -f static/* $(location_deploy)/
	rsync -av $(location_arrow_logo)/build/ $(location_deploy)/arrowlogo

$(location_deploy):
	cd $(location_deploy_prefix); git clone git@github.com:$(repo)

%.html : %.html.pm template.html
	if [ -f $@ ]; then chmod +w $@; fi
	raco pollen render $@
	chmod -w $@

webapp-container.png: webapp-container.dot
	dot -o $@ -T png $<

clean :
	rm -f $(TARGETS)
	rm -Rf arrowlogo
