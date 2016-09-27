//
//  NSImage+PNGData.h
//  CoreAudioConverter
//
//  Created by Simon Gaus on 08.08.16.
//  Copyright © 2016 Simon Gaus. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 
 The PNGData categorie adds the capability to get PNG data from an image to the NSImage class.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface NSImage (PNGData)
/**
 
 
 
 @return The png data representation of the receiver, or nil.
 
 */
- (nullable NSData *)pngData;


@end
NS_ASSUME_NONNULL_END
