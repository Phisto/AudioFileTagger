/*
 *  NSImage+PNGData.h
 *  AudioFileTagger
 *
 *  Copyright © 2015-2020 Simon Gaus <simon.cay.gaus@gmail.com>
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
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with this library.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

@import Cocoa;

/**
 
 The PNGData categorie adds the capability to get PNG data from an image to the NSImage class.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface NSImage (PNGData)
#pragma mark - Creating PNG data
///----------------------------------------------
/// @name Creating PNG data
///----------------------------------------------

/**
 @brief Returns the bitmap representation of the image as PNG data or if there is no bitmap representation creates one.
 @return The png data representation of the receiver, or nil.
 */
- (nullable NSData *)pngData;


@end

NS_ASSUME_NONNULL_END
