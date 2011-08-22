//
//  UIApplication+UIID.m
//  UIID
//
//  Created by akisute on 11/08/22.
//

#import "UIApplication+UIID.h"


#if UIID_PERSISTENT
// Use keychain as a storage
#import <Security/Security.h>    
#endif


static NSString * const UIApplication_UIID_Key = @"uniqueInstallationIdentifier";


@implementation UIApplication (UIApplication_UIID)

- (NSString *)uniqueInstallationIdentifier
{
    // Search for already created UIID
    // If found, return it
    // If not found, create a new UUID as a new UIID of this installation and save it
    NSString *uuidString = nil;
    
#if UIID_PERSISTENT
    // UIID must be persistent even if the application is removed from devices
    // Use keychain as a storage
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           (id)kSecClassGenericPassword,            (id)kSecClass,
                           UIApplication_UIID_Key,                  (id)kSecAttrGeneric,
                           UIApplication_UIID_Key,                  (id)kSecAttrAccount,
                           [[NSBundle mainBundle] bundleIdentifier],(id)kSecAttrService,
                           (id)kSecMatchLimitOne,                   (id)kSecMatchLimit,
                           (id)kCFBooleanTrue,                      (id)kSecReturnAttributes,
                           nil];
    NSDictionary *attributes = nil;
    OSStatus result = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&attributes);
    if (result == noErr) {
        
        NSMutableDictionary *valueQuery = [NSMutableDictionary dictionaryWithDictionary:attributes];
        [attributes release];
        
        [valueQuery setObject:(id)kSecClassGenericPassword  forKey:(id)kSecClass];
        [valueQuery setObject:(id)kCFBooleanTrue            forKey:(id)kSecReturnData];
        
        NSData *passwordData = nil;
        OSStatus result = SecItemCopyMatching((CFDictionaryRef)valueQuery, (CFTypeRef *)&passwordData);
        if (result == noErr) {
            
            // Assume the stored data is a UTF-8 string.
            uuidString = [[[NSString alloc] initWithBytes:[passwordData bytes]
                                                   length:[passwordData length]
                                                 encoding:NSUTF8StringEncoding] autorelease];
            [passwordData release];
            
        }
    }
#else
    // UIID may not be persistent
    // Use NSUserDefalt as a storage
    // WARNING: this could be much more vulnerable since the NSUserDefaults stores values as a plist file. Any jailbroken user can extract values from it.
    uuidString = [[NSUserDefaults standardUserDefaults] stringForKey:UIApplication_UIID_Key];
#endif
    
    if (uuidString == nil) {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        uuidString = (NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
        [uuidString autorelease];
        CFRelease(uuidRef);
        
#if UIID_PERSISTENT
        // UIID must be persistent even if the application is removed from devices
        // Use keychain as a storage
        NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      (id)kSecClassGenericPassword,             (id)kSecClass,
                                      UIApplication_UIID_Key,                   (id)kSecAttrGeneric,
                                      UIApplication_UIID_Key,                   (id)kSecAttrAccount,
                                      [[NSBundle mainBundle] bundleIdentifier], (id)kSecAttrService,
                                      @"",                                      (id)kSecAttrLabel,
                                      @"",                                      (id)kSecAttrDescription,
                                      nil];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4) {
            // kSecAttrAccessible is iOS 4 or later only
            // Current device is running on iOS 3.X, do nothing here
        } else {
            // Set kSecAttrAccessibleAfterFirstUnlock so that background applications are able to access this key.
            // Keys defined as kSecAttrAccessibleAfterFirstUnlock will be migrated to the new devices/installations via encrypted backups.
            // If you want different UIID per device, use kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly instead.
            // Keep in mind that keys defined as kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly will be removed after restoring from a backup.
            [query setObject:(id)kSecAttrAccessibleAfterFirstUnlock forKey:(id)kSecAttrAccessible];
        }
        [query setObject:[uuidString dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
        
        OSStatus result = SecItemAdd((CFDictionaryRef)query, NULL);
        if (result != noErr) {
            NSLog(@"[ERROR] Couldn't add the Keychain Item. result = %ld query = %@", result, query);
            return nil;
        }
#else
        // UIID may not be persistent
        // Use NSUserDefalt as a storage
        // WARNING: this could be much more vulnerable since the NSUserDefaults stores values as a plist file. Any jailbroken user can extract values from it.
        [[NSUserDefaults standardUserDefaults] setObject:uuidString forKey:UIApplication_UIID_Key];
#endif
    }
    
    return uuidString;
}

- (void)resetUniqueInstallationIdentifier
{
#if UIID_PERSISTENT
    // UIID must be persistent even if the application is removed from devices
    // Use keychain as a storage
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           (id)kSecClassGenericPassword,            (id)kSecClass,
                           UIApplication_UIID_Key,                  (id)kSecAttrGeneric,
                           UIApplication_UIID_Key,                  (id)kSecAttrAccount,
                           [[NSBundle mainBundle] bundleIdentifier],(id)kSecAttrService,
                           nil];
    OSStatus result = SecItemDelete((CFDictionaryRef)query);
    if (result == noErr) {
        NSLog(@"[INFO}  Unique Installation Identifier is successfully reset.");
    } else if (result == errSecItemNotFound) {
        NSLog(@"[INFO}  Unique Installation Identifier is successfully reset.");
    } else {
        NSLog(@"[ERROR] Coudn't delete the Keychain Item. result = %ld query = %@", result, query);
    }
#else
    // UIID may not be persistent
    // Use NSUserDefalt as a storage
    // WARNING: this could be much more vulnerable since the NSUserDefaults stores values as a plist file. Any jailbroken user can extract values from it.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UIApplication_UIID_Key];
    NSLog(@"[INFO}  Unique Installation Identifier is successfully reset.");
#endif
    
}

@end
