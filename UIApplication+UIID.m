//
//  UIApplication+UIID.m
//  UIID
//
//  Created by akisute on 11/08/22.
//
/*
 Copyright (c) 2011 Masashi Ono.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 of the Software, and to permit persons to whom the Software is furnished to do
 so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import "UIApplication+UIID.h"


#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif


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
                           (__bridge id)kSecClassGenericPassword,   (__bridge id)kSecClass,
                           UIApplication_UIID_Key,                  (__bridge id)kSecAttrGeneric,
                           UIApplication_UIID_Key,                  (__bridge id)kSecAttrAccount,
                           [[NSBundle mainBundle] bundleIdentifier],(__bridge id)kSecAttrService,
                           (__bridge id)kSecMatchLimitOne,          (__bridge id)kSecMatchLimit,
                           (__bridge id)kCFBooleanTrue,             (__bridge id)kSecReturnAttributes,
                           nil];
    CFTypeRef attributesRef = NULL;
    OSStatus result = SecItemCopyMatching((__bridge CFDictionaryRef)query, &attributesRef);
    if (result == noErr) {
        NSDictionary *attributes = (__bridge_transfer NSDictionary *)attributesRef;
        NSMutableDictionary *valueQuery = [NSMutableDictionary dictionaryWithDictionary:attributes];
        
        [valueQuery setObject:(__bridge id)kSecClassGenericPassword  forKey:(__bridge id)kSecClass];
        [valueQuery setObject:(__bridge id)kCFBooleanTrue            forKey:(__bridge id)kSecReturnData];
        
        CFTypeRef passwordDataRef = NULL;
        OSStatus result = SecItemCopyMatching((__bridge CFDictionaryRef)valueQuery, &passwordDataRef);
        if (result == noErr) {
            NSData *passwordData = (__bridge_transfer NSData *)passwordDataRef;
            // Assume the stored data is a UTF-8 string.
            uuidString = [[NSString alloc] initWithBytes:[passwordData bytes]
                                                   length:[passwordData length]
                                                 encoding:NSUTF8StringEncoding];
        }
    }
#else
    // UIID may not be persistent
    // Use NSUserDefalt as a storage
    // WARNING: this could be much more vulnerable since the NSUserDefaults stores values as a plist file. Any jailbroken user can extract values from it.
    uuidString = [[NSUserDefaults standardUserDefaults] stringForKey:UIApplication_UIID_Key];
#endif
    
    if (uuidString == nil) {
        
        // Generate the new UIID
        if ([UIDevice instancesRespondToSelector:@selector(identifierForVendor)]) {
#if UIID_PERSISTENT
            id identifier = [[UIDevice currentDevice] performSelector:@selector(identifierForVendor)];
            uuidString = [identifier performSelector:@selector(UUIDString)];
#else
            CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
            uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
            CFRelease(uuidRef);
#endif
        } else {
            CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
            uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
            CFRelease(uuidRef);
        }
        
#if UIID_PERSISTENT
        // UIID must be persistent even if the application is removed from devices
        // Use keychain as a storage
        NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      (__bridge id)kSecClassGenericPassword,    (__bridge id)kSecClass,
                                      UIApplication_UIID_Key,                   (__bridge id)kSecAttrGeneric,
                                      UIApplication_UIID_Key,                   (__bridge id)kSecAttrAccount,
                                      [[NSBundle mainBundle] bundleIdentifier], (__bridge id)kSecAttrService,
                                      @"",                                      (__bridge id)kSecAttrLabel,
                                      @"",                                      (__bridge id)kSecAttrDescription,
                                      nil];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4) {
            // kSecAttrAccessible is iOS 4 or later only
            // Current device is running on iOS 3.X, do nothing here
        } else {
            // Set kSecAttrAccessibleAfterFirstUnlock so that background applications are able to access this key.
            // Keys defined as kSecAttrAccessibleAfterFirstUnlock will be migrated to the new devices/installations via encrypted backups.
            // If you want different UIID per device, use kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly instead.
            // Keep in mind that keys defined as kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly will be removed after restoring from a backup.
            [query setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlock forKey:(__bridge id)kSecAttrAccessible];
        }
        [query setObject:[uuidString dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
        
        OSStatus result = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
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
                           (__bridge id)kSecClassGenericPassword,   (__bridge id)kSecClass,
                           UIApplication_UIID_Key,                  (__bridge id)kSecAttrGeneric,
                           UIApplication_UIID_Key,                  (__bridge id)kSecAttrAccount,
                           [[NSBundle mainBundle] bundleIdentifier],(__bridge id)kSecAttrService,
                           nil];
    OSStatus result = SecItemDelete((__bridge CFDictionaryRef)query);
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
