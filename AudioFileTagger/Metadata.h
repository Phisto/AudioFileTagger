/*
 *  Metadata.h
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

/**
 
 The Metadata class describes an audio media item such as a song.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface Metadata : NSObject

#pragma mark - Tags
///-----------
/// @name Tags
///-----------

/**
 The title of this media item.
 */
@property (nonatomic, strong) NSString *title;
/**
 The name of the artist associated with this media item.
 */
@property (nullable, nonatomic, strong) NSString *artist;
/**
 The name of the album associated with this media item.
 */
@property (nullable, nonatomic, strong) NSString *albumName;
/**
 The name of the composer associated with this media item.
 */
@property (nullable, nonatomic, strong) NSString *composer;
/**
 The genre associated with this media item.
 */
@property (nullable, nonatomic, strong) NSString *genre;
/**
 Whether this media item has artwork.
 */
@property (nonatomic, readonly, getter=hasArtworkAvailable) BOOL artworkAvailable;
/**
 The artwork of this media item.
 */
@property (nullable, nonatomic, strong) NSImage *artwork;
/**
 The track number of this media item within its album.
 */
@property (nullable, nonatomic, strong) NSNumber *trackNumber;
/**
 The year when this media item was released.åå
 */
@property (nullable, nonatomic, strong) NSNumber *year;

#pragma mark - Audio Properties
///-----------------------
/// @name Audio Properties
///-----------------------

/**
 The size in bytes of this media item.
 */
@property (nullable, nonatomic, readwrite) NSUInteger size;
/**
 The length of this media item in milliseconds.
 */
@property (nullable, nonatomic, readwrite) NSUInteger totalTime;
/**
 The bitrate of this media item in kbps.
 */
@property (nullable, nonatomic, readwrite) NSUInteger bitrate;
/**
 The sample rate of this media item in samples per second.
 */
@property (nullable, nonatomic, readwrite) NSUInteger sampleRate;

@end
NS_ASSUME_NONNULL_END
