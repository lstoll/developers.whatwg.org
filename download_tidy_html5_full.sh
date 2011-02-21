#!/bin/sh
CURL_CMD="$CURL --compressed --output $SOURCE_DOC -z html5-full.html http://www.whatwg.org/specs/web-apps/current-work/dev-index"
if [ -f $SOURCE_DOC ]; then
  HTML5_LAST_MOD=$(stat -f "%m" $SOURCE_DOC)
  $CURL_CMD
  HTML5_LAST_MOD_AFTER=$(stat -f "%m" $SOURCE_DOC)
  if [ $HTML5_LAST_MOD != $HTML5_LAST_MOD_AFTER ]; then
      $RUBY tidy.rb $SOURCE_DOC
      # trigger rebuild
      rm index.html
  fi
else
  $CURL_CMD
  $RUBY tidy.rb $SOURCE_DOC
  # trigger rebuild
  rm index.html
fi
