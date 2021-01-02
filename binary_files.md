## what types of files are in the directory?

    find . -type f | xargs file -b | sort | uniq -c | sort -n

## are there binary files?

    find . -type f -exec grep -IL . "{}" \;

as per https://stackoverflow.com/a/47678132/1164295



These binary files are included when all four packages are installed by Composer, but not when the extension is just SMW

non-plain text files:

 * `mediawiki/extensions/SemanticResultFormats/resources/jquery/jplayer/jquery.jplayer.swf` which is in https://github.com/  SemanticMediaWiki/SemanticResultFormats/tree/master/resources/jquery/jplayer
 * `mediawiki/vendor/onoi/tesa/src/StopwordAnalyzer/data/cdb/*.cdb`
 * `mediawiki/vendor/oojs/oojs-ui/src/styles/images/grab.cur`
 * `mediawiki/vendor/oojs/oojs-ui/src/styles/images/grabbing.cur`
 * `vendor/wikimedia/xmp-reader/tests/data/utf*.xmp` which is in https://github.com/wikimedia/xmp-reader/tree/master/tests/  data -- these can probably be discarded since they are tests?


