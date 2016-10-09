/*
 *  MP3Tagger.h
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
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with this library.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#import <Foundation/Foundation.h>

@class Metadata;

/**
 
 An MP3Tagger object can tag audio files with ID3v2 tags.
 
 ## Sandboxing Notes
 MP3Tagger is NOT implemented in a sandboxing friendly manor, you need to take care of file access yourself.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MP3Tagger : NSObject

#pragma mark - Properties
///-----------------
/// @name Properties
///-----------------

/**
 
 The metadata associated with the tagger.
 
*/
@property (nonatomic, readonly) Metadata *metadata;

#pragma mark - Inititalization
///----------------------
/// @name Inititalization
///----------------------

/**
 
 Creates an MP3Tagger object initialized with the given metadata.
 
 Example usage:
 
    Metadata *metatdata = ...
 
    MP3Tagger *tagger = [MP3Tagger taggerWithMetadata:metatdata];
    if (!tagger) {
        // handle failure...
    }
 
    // do stuff ...
 
 
 @param metadata The metadata to use for tagging.
 
 @return An MP3Tagger object, or nil.
 
 */
+ (nullable instancetype)taggerWithMetadata:(Metadata *)metadata;

#pragma mark - Methodes
///---------------
/// @name Methodes
///---------------

/**
 
 Writes the tags to the specified file.
 
 @param fileURL The file to tag.
 
 @return YES if the file was tagged successfully, otherwise NO.
 
 */
- (BOOL)tagFile:(NSURL *)fileURL;

@end
NS_ASSUME_NONNULL_END
