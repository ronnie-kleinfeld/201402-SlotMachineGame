#!/bin/sh
/Applications/Adobe\ Flash\ Builder\ 4.7/sdks/4.6.0/bin/adt -package -target ane ContactEditor.ane ./extension.xml -swc ContactEditor.swc -platform iPhone-ARM library.swf libContactEditor.a -platformoptions ios-platformoptions.xml -platform default library.swf -platform Android-ARM library.swf contactEditor.jar -platform iPhone-x86 library.swf libContactEditorSimulator.a -platformoptions ios-platformoptions.xml 