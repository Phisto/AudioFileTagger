//
//  NSImage+PNGData.h
//  CoreAudioConverter
//
//  Created by Simon Gaus on 08.08.16.
//  Copyright © 2016 Simon Gaus. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
/**
 
 */
@interface NSImage (PNGData)
/**
 @return
 */
- (nullable NSData *)pngData;

@end
NS_ASSUME_NONNULL_END
