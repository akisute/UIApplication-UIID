//
//  UIApplication+UIID.h
//  UIID
//
//  Created by akisute on 11/08/22.
//
/*
 Copyright (c) 2011 Masashi Ono.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
 Returns the unique identifier for this installation of the application.
 This value will change when:
 - If UIID_PERSISTENT=1, -resetUniqueInstallationIdentifier is called or the application is installed to the completely new device without using any backups.
 - If UIID_PERSISTENT=0, -resetUniqueInstallationIdentifier is called or the application is removed from the current device.
 */
- (NSString *)uniqueInstallationIdentifier;

/*! Resets the persisted unique identifier for this installation. */
- (void)resetUniqueInstallationIdentifier;

@end
