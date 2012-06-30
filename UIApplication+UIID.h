//
//  UIApplication+UIID.h
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
 @brief Returns the unique identifier for this installation of the application.
 @return The unique installation identifier generated for this installation of the application. If already generated before, returns that value.
 @discussion Note that the format of the returned value is UUID, which is completely different from that of UIDevice.uniqueIdnetifier.
 
 When the uniqueInstallationIdentifier is generated, its value will be as follows:
 * If UIDevice.identifierForVendor is available to use,
 ** UIDevice.dentifierForVendor.UUIDString if UIID_PERSISTENT=1.
 * Otherwise, CFUUIDCreateString is used to generate the value.
 
 The value of uniqueInstallationIdentifier will be reset when:
 * If UIDevice.identifierForVendor is available to use,
 ** The application is installed on the completely new device if UIID_PERSISTENT=1.
 ** The application is removed from the current device if UIID_PERSISTENT=0.
 ** You can't reset the value by using resetUniqueInstallationIdentifier anymore when UIID_PERSISTENT=1.
 * Otherwise,
 ** The application is installed on the completely new device without using any backups if UIID_PERSISTENT=1.
 ** The application is removed from the current device if UIID_PERSISTENT=0.
 
 This value is not aimed for sharing the same identifier among all applications installed on the same device (a.k.a. UDID). If you want to use UDID,
 * Use UIDevice.identifierForAdvertising instead if possible.
 * Otherwise, use any other UDID libraries available (I strongly discourage to do so!)
 */
- (NSString *)uniqueInstallationIdentifier;

/*! 
 @brief Resets the persisted unique identifier for this installation.
 @discussion Note that you can't reset the value of uniqueInstallationIdentifier when UIID_PERSISTENT=1 and UIDevice.identifierForVendor is available.
 */
- (void)resetUniqueInstallationIdentifier;

@end
