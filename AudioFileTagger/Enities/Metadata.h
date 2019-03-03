/*
 *  Metadata.h
 *  AudioFileTagger
 *
 *  Copyright © 2015-2019 Simon Gaus <simon.cay.gaus@gmail.com>
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

#import <Cocoa/Cocoa.h>

/**
 
 The Metadata class describes an audio media item such as a song.

 Supported Tags:
 - title
 - artist
 - albumName
 - composer
 - genre
 - artworkAvailable
 - artwork
 - trackNumber
 - year
 - comment
 - lyrics
 
 Supported properties:
 - size
 - totalTime
 - bitrate
 - sampleRate
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface Metadata : NSObject
#pragma mark - Initialize the metadata from a file
///-----------------------------------------------
/// @name Initialize the metadata from a file
///-----------------------------------------------

/**
 
 @brief Initializes an Metadata object with the metadata of the given audio file.
 
 @param fileURL The url to the audio file.
 
 @return An initialized Metadata object, or nil if the file coulden't be read or the file has no tags.
 
 */
- (nullable instancetype)initWithMetadataFromFile:(NSURL *)fileURL;



#pragma mark - Tags
///-----------
/// @name Tags
///-----------

/**
 @brief The title of this media item.
 */
@property (nonatomic, strong) NSString *title;
/**
 @brief The name of the artist associated with this media item.
 */
@property (nullable, nonatomic, strong) NSString *artist;
/**
 @brief The name of the album associated with this media item.
 */
@property (nullable, nonatomic, strong) NSString *albumName;
/**
 @brief The name of the composer associated with this media item.
 */
@property (nullable, nonatomic, strong) NSString *composer;
/**
 @brief The genre associated with this media item.
 */
@property (nullable, nonatomic, strong) NSString *genre;
/**
 @brief Whether this media item has artwork.
 */
@property (nonatomic, readonly, getter=hasArtworkAvailable) BOOL artworkAvailable;
/**
 @brief The artwork of this media item.
 */
@property (nullable, nonatomic, strong) NSImage *artwork;
/**
 @brief The track number of this media item within its album.
 */
@property (nullable, nonatomic, strong) NSNumber *trackNumber;
/**
 @brief The year when this media item was released.
 */
@property (nullable, nonatomic, strong) NSNumber *year;
/**
 @brief The comment associated with this media item.
 */
@property (nullable, nonatomic, strong) NSString *comment;
/**
 @brief The comment associated with this media item.
 */
@property (nullable, nonatomic, strong) NSString *lyrics;



#pragma mark - Audio File Properties
///---------------------------------
/// @name Audio File Properties
///---------------------------------

/**
 @brief The size in bytes of this media item.
 */
@property (nonatomic, readwrite) NSUInteger size;
/**
 @brief The length of this media item in milliseconds.
 */
@property (nonatomic, readwrite) NSUInteger totalTime;
/**
 @brief The bitrate of this media item in kbps (kilobit per second).
 */
@property (nonatomic, readwrite) NSUInteger bitrate;
/**
 @brief The sample rate of this media item (samples per second, eg. 44.1 kHz).
 */
@property (nonatomic, readwrite) NSUInteger sampleRate;



#pragma mark - Validating metadata
///-------------------------------
/// @name Validating metadata
///-------------------------------

/**
 @brief Whether this media item has valid metadata.
 @discussion This property will be YES if there is at least one property set.
 */
@property (nonatomic, readonly) BOOL validMetadata;



@end
NS_ASSUME_NONNULL_END
