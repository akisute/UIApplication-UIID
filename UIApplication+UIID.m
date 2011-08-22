//
//  UIApplication+UIID.m
//  UIID
//
//  Created by akisute on 11/08/22.
//

#import "UIApplication+UIID.h"


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
    // TODO:
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
        // TODO:
#else
        // UIID may not be persistent
        // Use NSUserDefalt as a storage
        // WARNING: this could be much more vulnerable since the NSUserDefaults stores values as a plist file. Any jailbroken user can extract values from it.
        [[NSUserDefaults standardUserDefaults] setObject:uuidString forKey:UIApplication_UIID_Key];
#endif
    }
    
    return uuidString;
}

@end
