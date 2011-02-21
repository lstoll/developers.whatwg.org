HG=hg
SVN=svn
CURL=curl
PYTHON=python
RUBY=ruby
PATCH=patch
SPLITTER=html5-tools/spec-splitter/spec-splitter.py
SPLITTERFLAGS=--html5lib-serialiser
SOURCE_DOC=html5-full.html
HTML5TOOLS_REV=181

postprocess: clean-output download_source process_assets LOG
	rake --trace postprocess:execute

LOG: index.html $(SPLITTER)
	$(PYTHON) $(SPLITTER) $(SPLITTERFLAGS) $< ./public > LOG

# Note - if this filename changes, you will need to edit the download
# and tidy script - it removes it if the main file changes.
index.html: anolis/anolis
	$(PYTHON) anolis/anolis \
	  --parser=lxml.html \
	  --filter=.impl \
	  --output-encoding="ascii" \
	  $(SOURCE_DOC) $@

download_source:
	CURL=$(CURL) \
	RUBY=$(RUBY) \
	SOURCE_DOC=$(SOURCE_DOC) \
	./download_tidy_html5_full.sh

process_assets:
	$(RUBY) assets.rb

clean: clean-output
	$(RM) html5-full.html
#	$(RM) -r html5-tools # Don't do this, our local copy has been modified.
	$(RM) -r anolis

clean-output:
	$(RM) LOG
	$(RM) -r public/**/*.html
	$(RM) -r public/css/*.css
	$(RM) -r public/*.manifest

anolis/anolis:
	$(HG) clone http://hg.hoppipolla.co.uk/anolis/
	$(PATCH) -p1 -d anolis < patch.anolis

$(SPLITTER):
	$(SVN) checkout -r $(HTML5TOOLS_REV) http://html5.googlecode.com/svn/trunk/ html5-tools
