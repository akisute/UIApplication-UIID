This addition to the UIApplication generates Unique Installation Identifier (UIID) as a replacement of the depreciated UDID in iOS 5. The generated UIID can either be persistent (stored in Keychain) or non-persistent (stored in NSUserDefaults). The identifier is unique for each installetions of your applications and is much secure compared to the `[[UIDevice sharedDevice] uniqueIdentifier].`

See http://akisute.com/2011/08/udiduiid.html for more information, written in Japanese.
