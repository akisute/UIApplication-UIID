README
------

This addition to the UIApplication generates Unique Installation Identifier (UIID) as a replacement of the depreciated UDID in iOS 5. The generated UIID can either be persistent (stored in Keychain) or non-persistent (stored in NSUserDefaults). The identifier is unique for each installetions of your applications and is much more secure compared to the `[[UIDevice sharedDevice] uniqueIdentifier].`

Original gist is here: https://gist.github.com/1161447

See http://akisute.com/2011/08/udiduiid.html for more information, written in Japanese.

Usage
-----

1. Download `UIApplication+UIID.h` and `UIApplication+UIID.m` and add them to your projects.
2. If you want the UIID to be persistent, define `UIID_PERSISTENT=1` and add `Security.framework` to your projects.
3. `#import "UIApplication+UIID.h"`
4. `[[UIApplication sharedApplication] uniqueInstallationIdentifier];`
