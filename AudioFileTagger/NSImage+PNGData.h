/*
 *  NSImage+PNGData.h
 *  AudioFileTagger
 *
 *  Copyright © 2015-2016 Simon Gaus <simon.cay.gaus@gmail.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 */

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
