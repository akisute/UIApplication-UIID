README
------

This addition to the UIApplication generates Unique Installation Identifier (UIID) as a replacement of the depreciated UDID in iOS 5. The generated UIID can either be persistent (stored in Keychain) or non-persistent (stored in NSUserDefaults). The identifier is unique for each installetions of your applications and is much more secure compared to the `[[UIDevice sharedDevice] uniqueIdentifier].`

Original gist is here: https://gist.github.com/1161447

See http://akisute.com/2011/08/udiduiid.html for more information, written in Japanese.

Features
--------

Version 2 features:

* ARC technology which requires iOS SDK 4.0 or higher to compile. Only runs on iOS 4.0 runtime or above as well.
* Compatible with `UIDevice.identifierForVendor`.
    * UIApplication-UIID uses that identifier when creating the new UIID if possible.
    * UIApplication-UIID uses the saved UIID values if already created for consistent backword compatibility.

Version 1 features:

* Non-ARC code which supports as low as iOS SDK 2.0 and iOS 2.0 runtime.

Usage
-----

1. Download `UIApplication+UIID.h` and `UIApplication+UIID.m` and add them to your projects.
2. If you want the UIID to be persistent, define `UIID_PERSISTENT=1` and add `Security.framework` to your projects.
3. `#import "UIApplication+UIID.h"`
4. `[[UIApplication sharedApplication] uniqueInstallationIdentifier];`

LICENSE
-------

This code is licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php

Copyright (c) 2011 Masashi Ono.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.