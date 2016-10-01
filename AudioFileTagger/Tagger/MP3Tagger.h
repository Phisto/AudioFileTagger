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
 */

#import <Foundation/Foundation.h>

@class Metadata;

/**
 
 An MP3Tagger object can tag audio files with ID3v2 tags.
 
 Supported tags:
 
 - title
 - artist
 - albumName
 - year
 - genre
 - trackNumber
 - artwork
 
 ## Sandboxing Notes
 This is NOT implemented in a sandboxing friendly manor, you need to take care of file access yourself.
 
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
 
 Creates an MP3Tagger object initialized with the metadata of the given file.
 
 Example usage:
    
    NSURL *inputFileURL = ...
 
    MP3Tagger *tagger = [MP3Tagger taggerForFile:inputFileURL];
    if (!tagger) {
        // handle failure...
    }
 
    // do stuff ...
 
 
 @param fileURL The file from which to read the metadata.
 
 @param readAudioProperties Indicates if the tagger should be initialized with the files audio properties (lenght, samplerate, bitrate etc.) or just with the tags.
 
 @return An MP3Tagger object, or nil if the file coulden't be read or the files has no tags.
 
 */
+ (nullable instancetype)taggerFromFile:(NSURL *)fileURL readAudioProperties:(BOOL)readAudioProperties;
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
 
 @param file The file to tag.
 
 @return YES if the file was tagged successfully, otherwise NO.
 
 */
- (BOOL)tagFile:(NSURL *)file;

@end
NS_ASSUME_NONNULL_END
