--TEST--
XML Parser: parse from file resource
--SKIPIF--
<?php if (!extension_loaded("xml")) echo 'skip'; ?>
--FILE--
<?php // -*- C++ -*-
//
// Test for: XML/Parser.php
// Parts tested: - parser creation
//               - some handlers
//               - parse from file resource
//
chdir (dirname(__FILE__));

require_once "XML/Parser.php";

class __TestParser3 extends XML_Parser {
    function __TestParser3() {
        $this->XML_Parser();
    }
    function startHandler($xp, $element, $attribs) {
        print "<$element";
        reset($attribs);
        while (list($key, $val) = each($attribs)) {
            $enc = htmlentities($val);
            print " $key=\"$enc\"";
        }
        print ">";
    }
    function endHandler($xp, $element) {
        print "</$element>\n";
    }
    function cdataHandler($xp, $cdata) {
        print "<![CDATA[$cdata]]>";
    }
    function defaultHandler($xp, $cdata) {

    }
}
print "new __TestParser3 ";
var_dump(get_class($o = new __TestParser3()));
print "fopen ";
var_dump($fp = fopen("test.xml", "r"));
print "setInput ";
var_dump($o->setInput($fp));
print "parse ";
var_dump($o->parse());

?>
--EXPECT--
new __TestParser3 string(13) "__testparser3"
fopen resource(4) of type (stream)
setInput bool(true)
parse <ROOT><![CDATA[foo]]></ROOT>
bool(true)
