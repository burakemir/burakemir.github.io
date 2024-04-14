# Makefile for web content and apps.
TARGETS=webapp-container.png relational-query.png

# The file below defines variables:
#   location_arrow_logo:
#     location of the arrow logo build from.
#   location_deploy:
#     location of the burakemir.github.io repository
include Makefile.parameters

resources=article.css homepage.css hilbert.js

all : $(TARGETS) arrowlogo

arrowlogo :
	make -C $(location_arrow_logo)
	rsync -av $(location_arrow_logo)/build/ arrowlogo

book:
	$(MAKE) -C mangle-point-in-time-01
	$(MAKE) -C mangle-point-in-time-02

deploy : $(location_deploy) book
	cd src && zola build
	cd odersky-fest-23 && zola build
	cd $(location_deploy); git pull
	cp -f -r src/deploy/* $(location_deploy)/
	cp -f $(resources) $(location_deploy)/
	cp -f static/* $(location_deploy)/
	mkdir -p $(location_deploy)/odersky-fest-23
	cp -f -r odersky-fest-23/public/* $(location_deploy)/odersky-fest-23
	mkdir -p $(location_deploy)/mangle-point-in-time-01
	cp -R mangle-point-in-time-01/book/* $(location_deploy)/mangle-point-in-time-01
	mkdir -p $(location_deploy)/mangle-point-in-time-02
	cp -R mangle-point-in-time-02/book/* $(location_deploy)/mangle-point-in-time-02
	rsync -av $(location_arrow_logo)/build/ $(location_deploy)/arrowlogo

$(location_deploy):
	cd $(location_deploy_prefix); git clone git@github.com:$(repo)

%.png: %.dot
	dot -o $@ -T png $<

clean :
	rm -f $(TARGETS)
	rm -Rf arrowlogo
