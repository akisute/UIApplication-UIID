//
//  UIApplication+UIID.h
//  UIID
//
//  Created by akisute on 11/08/22.
//

#import <UIKit/UIKit.h>


/*!
 Define UIID_PERSISTENT=1 to enable persistent UIID via Keychain.
 This feature requires Security.framework to be included to your projects.
 */
#ifndef UIID_PERSISTENT
#define UIID_PERSISTENT 0
#endif


@interface UIApplication (UIApplication_UIID)

/*! 
 Returns the unique identifier for this installation of the application.
 This value will change when:
 - If UIID_PERSISTENT=1, -resetUniqueInstallationIdentifier is called or the application is installed to the completely new device without using any backups.
 - If UIID_PERSISTENT=0, -resetUniqueInstallationIdentifier is called or the application is removed from the current device.
 */
- (NSString *)uniqueInstallationIdentifier;

/*! Resets the persisted unique identifier for this installation. */
- (void)resetUniqueInstallationIdentifier;

@end
