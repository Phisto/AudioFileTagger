/*
 *  Metadata.m
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

#import "Metadata.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface Metadata (/* Private */)

@property (nonatomic, strong) AVURLAsset *avAsset;
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, readwrite) AudioFileID songID;

@end

@implementation Metadata

- (nullable instancetype)initWithMetadataFromFile:(NSURL *)fileURL {
    
    if (!fileURL) return nil;
    self = [super init];
    if (self) {
        
        _avAsset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
        if (!_avAsset) {
            return nil;
        }
        
        _fileURL = fileURL;
        if (!_fileURL) {
            return nil;
        }
        
        _title = [self trackTitleFromAsset];
        _artist = [self artistNameFromAsset];
        _albumName = [self albumNameFromAsset];
        _composer = [self composerNameFromAsset];
        _genre = [self genreFromAsset];
        _artwork = [self artworkFromAsset];
        _trackNumber = [self trackNumberFromAsset];
        _year = [self creationYearFromAsset];
        _comment = [self commentFromAsset];
        _lyrics = [self lyricsFromAsset];
        
        // release if used
        if (_songID) {
            
            AudioFileClose(_songID);
            _songID = nil;
        }
        _avAsset = nil;
        _fileURL = nil;
        
    }
    
    return (self.validMetadata) ? self : nil;
}

#pragma mark - Asset Methodes

-(NSString*)trackTitleFromAsset {
    
    id value = [self getMetadataValueForCommonKey:AVMetadataCommonKeyTitle
                                  withID3Fallback:AVMetadataID3MetadataKeyTitleDescription
                               withiTunesFallback:AVMetadataiTunesMetadataKeySongName];
    
    NSString *title;
    
    if ([value isKindOfClass:[NSString class]]) {
        title = (NSString *)value;
    }
    if (!title) {
        title = [self getAudioPropertyForKey:kAFInfoDictionary_Title];
    }
    if (!title) {
        title = [self trackTitleFromFile];
    }
    
    return title;
}

-(NSString*)artistNameFromAsset {
    
    id value = [self getMetadataValueForCommonKey:AVMetadataCommonKeyArtist
                                  withID3Fallback:AVMetadataID3MetadataKeyOriginalArtist
                               withiTunesFallback:AVMetadataiTunesMetadataKeyArtist];
    
    NSString *artist;
    
    if ([value isKindOfClass:[NSString class]]) {
        artist = (NSString *)value;
    }
    
    if (!artist) {
        
        artist = [self getAudioPropertyForKey:kAFInfoDictionary_Artist];
    }
    
    return artist;
}

-(NSString*)albumNameFromAsset {
    
    id value = [self getMetadataValueForCommonKey:AVMetadataCommonKeyAlbumName
                                  withID3Fallback:AVMetadataID3MetadataKeyAlbumTitle
                               withiTunesFallback:AVMetadataiTunesMetadataKeyAlbum];
    
    NSString *albumName;
    
    if ([value isKindOfClass:[NSString class]]) {
        albumName = (NSString *)value;
    }
    
    if (!albumName) {
        
        albumName = [self getAudioPropertyForKey:kAFInfoDictionary_Album];
    }
    
    return albumName;
}

-(NSString*)composerNameFromAsset {
    
    id value = [self getMetadataValueForCommonKey:nil
                                  withID3Fallback:AVMetadataID3MetadataKeyComposer
                               withiTunesFallback:AVMetadataiTunesMetadataKeyComposer];
    
    NSString *composer;
    
    if ([value isKindOfClass:[NSString class]]) {
        composer = (NSString *)value;
    }
    
    if (!composer) {
        
        composer = [self getAudioPropertyForKey:kAFInfoDictionary_Composer];
    }
    
    return composer;
}

-(NSString*)genreFromAsset {
    
    id value = [self getMetadataValueForCommonKey:nil // no available key in common keys
                                  withID3Fallback:nil // no available key in id3
                               withiTunesFallback:AVMetadataiTunesMetadataKeyUserGenre];
    
    NSString *genre;
    
    if ([value isKindOfClass:[NSString class]]) {
        genre = (NSString *)value;
    }
    
    if (!genre) {
        
        genre = [self getAudioPropertyForKey:kAFInfoDictionary_Genre];
    }
    
    
    return genre;
}

-(NSImage *)artworkFromAsset {
    
    id value = [self getMetadataValueForCommonKey:AVMetadataCommonKeyArtwork
                                  withID3Fallback:AVMetadataID3MetadataKeyAttachedPicture
                               withiTunesFallback:AVMetadataiTunesMetadataKeyTrackNumber];
    
    NSImage *img;
    
    // AVMetadataCommonKeyArtwork will return data
    if ([value isKindOfClass:[NSData class]]) {
        
        img = [[NSImage alloc] initWithData:[value copyWithZone:nil]];
    }
    // AVMetadataID3MetadataKeyAttachedPicture will return dictionary
    if ([value isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *d = [value copyWithZone:nil];
        NSData *imgData = [d objectForKey:@"data"];
        if (imgData) img = [[NSImage alloc] initWithData:imgData];
    }
    
    return img;
}

-(NSNumber*)trackNumberFromAsset {
    
    id value = [self getMetadataValueForCommonKey:nil
                                  withID3Fallback:AVMetadataID3MetadataKeyTrackNumber
                               withiTunesFallback:AVMetadataiTunesMetadataKeyTrackNumber];
    
    // get a string from the
    NSString *valueString;
    
    // AVMetadataID3MetadataKeyTrackNumber will return string
    if ([value isKindOfClass:[NSString class]]) {
        
        valueString = (NSString *)value;
        
    }
    // AVMetadataiTunesMetadataKeyTrackNumber will return data
    if ([value isKindOfClass:[NSData class]]) {
        
        NSArray *parts = [[NSString stringWithFormat:@"%@", (NSData *)value] componentsSeparatedByString:@" "];
        
        NSString *firstPartOfData = [parts firstObject];
        if (firstPartOfData && firstPartOfData.length > 8) valueString = [firstPartOfData substringWithRange:NSMakeRange(1, 8)];
    }
    
    NSNumber *trackNumberObject;
    
    if (valueString) {
        
        
        int trackNumberSigned = 0;
        unsigned int trackNumberUnsigned = 0;
        NSScanner *scanner = [NSScanner scannerWithString:valueString];
        
        if ([scanner scanHexInt:&trackNumberUnsigned]) {
            
            if (trackNumberUnsigned != UINT_MAX) trackNumberObject = [NSNumber numberWithUnsignedInt:trackNumberUnsigned];
        }
        else if ([scanner scanInt:&trackNumberSigned]) {
            
            trackNumberObject = [NSNumber numberWithInt:trackNumberSigned];
            if (trackNumberUnsigned != INT_MAX) trackNumberObject = [NSNumber numberWithUnsignedInt:trackNumberUnsigned];
        }
    }
    
    return trackNumberObject;
}

-(NSNumber *)creationYearFromAsset {
    
    id value = [self getMetadataValueForCommonKey:AVMetadataCommonKeyCreationDate
                                  withID3Fallback:AVMetadataID3MetadataKeyRecordingTime
                               withiTunesFallback:AVMetadataiTunesMetadataKeyReleaseDate];
    
    
    if (!value) {
        
        value = [self getMetadataValueForCommonKey:nil
                                   withID3Fallback:AVMetadataID3MetadataKeyDate
                                withiTunesFallback:nil];
    }
    
    NSNumber *year;
    
    if ([value isKindOfClass:[NSNumber class]]) {
        year = (NSNumber *)value;
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        NSInteger intYear = [(NSString *)value integerValue];
        if (intYear > 0) year = [NSNumber numberWithInteger:intYear];
    }
    
    if (!year) {
        
        NSInteger intYear = [self getAudioPropertyForKey:kAFInfoDictionary_Year].integerValue;
        if (intYear > 0) year = [NSNumber numberWithInteger:intYear];
    }
    
    return year;
}

-(NSString*)commentFromAsset {
    
    id value = [self getMetadataValueForCommonKey:nil
                                  withID3Fallback:AVMetadataID3MetadataKeyComments
                               withiTunesFallback:AVMetadataiTunesMetadataKeyUserComment];
    
    NSString *comment;
    
    if ([value isKindOfClass:[NSString class]]) {
        comment = (NSString *)value;
        comment = [NSString stringWithCString:[comment fileSystemRepresentation] encoding:NSUTF8StringEncoding];
    }
    
    if (!comment) {
        
        comment = [self getAudioPropertyForKey:kAFInfoDictionary_Comments];
    }
    
    if ([self isiTunNORMComment:comment]) {
        
        comment = nil;
    }
    
    return comment;
}

-(NSString*)lyricsFromAsset {
    
    id value = [self getMetadataValueForCommonKey:nil
                                  withID3Fallback:AVMetadataID3MetadataKeyUnsynchronizedLyric
                               withiTunesFallback:AVMetadataiTunesMetadataKeyLyrics];
    
    NSString *lyrics;
    
    if ([value isKindOfClass:[NSString class]]) {
        lyrics = (NSString *)value;
    }
    
    return lyrics;
}

#pragma mark - Asset Methodes

- (id)getMetadataValueForCommonKey:(NSString*)commonKey
                   withID3Fallback:(NSString*)ID3FallbackKey
                withiTunesFallback:(NSString*)iTunesFallbackKey {
    
    id value = nil;
    
    if (commonKey) {
        
        NSArray<AVMetadataItem *> *resultKeys = [AVMetadataItem metadataItemsFromArray:_avAsset.metadata
                                                                               withKey:commonKey
                                                                              keySpace:AVMetadataKeySpaceCommon];
        value = [[resultKeys firstObject] value];
    }
    
    if (ID3FallbackKey && !value) {
        NSArray<AVMetadataItem *> *resultKeys = [AVMetadataItem metadataItemsFromArray:_avAsset.metadata
                                                                               withKey:ID3FallbackKey
                                                                              keySpace:AVMetadataKeySpaceID3];
        value = [[resultKeys firstObject] value];
    }
    
    if (iTunesFallbackKey && !value) {
        NSArray<AVMetadataItem *> *resultKeys = [AVMetadataItem metadataItemsFromArray:_avAsset.metadata
                                                                               withKey:iTunesFallbackKey
                                                                              keySpace:AVMetadataKeySpaceiTunes];
        value = [[resultKeys firstObject] value];
    }
    
    return value;
}



- (NSString *)getAudioPropertyForKey:(const char *)key {
    
    OSStatus err = noErr;
    NSDictionary * id3Sets = nil;
    UInt32 piDataSize = sizeof(id3Sets);
    err = AudioFileGetProperty(self.songID, kAudioFilePropertyInfoDictionary, &piDataSize, &id3Sets);
    if( err != noErr ) return nil;
    
    NSString *value;
    
    if ([id3Sets respondsToSelector:@selector(objectForKey:)]) {
        
        value = [(NSDictionary*)id3Sets objectForKey:[NSString stringWithUTF8String:key]];
    }
    
    return value;
}

#pragma mark - File Methodes

- (NSString *)trackTitleFromFile {
    
    return [[_fileURL lastPathComponent] stringByDeletingPathExtension];
}

#pragma mark - Helper Methodes

- (BOOL)isiTunNORMComment:(NSString *)commentString {
    
    // iTunNORM is 90 characters long
    if (commentString.length == 90) {
        
        NSArray<NSString *> *parts = [commentString componentsSeparatedByString:@" "];
        
        BOOL isEightCharsLong = YES;
        
        for (NSString *part in parts) {
            
            if (part.length != 8 && ![part isEqualToString:@""]) {
                
                isEightCharsLong = NO;
                break;
            }
        }
        
        return isEightCharsLong;
        
    }
    
    return NO;
}

#pragma mark - Custom Getter

- (BOOL)validMetadata {
    
    if (
        self.title ||
        self.artist ||
        self.albumName ||
        self.composer ||
        self.genre ||
        self.artworkAvailable ||
        self.comment ||
        self.lyrics
        ) {
        
        return YES;
    }
    return NO;
}

- (BOOL)artworkAvailable {
    
    return [self hasArtworkAvailable];
}

- (BOOL)hasArtworkAvailable {
    
    return (self.artwork) ? YES : NO;
}

#pragma mark - Lazy Getter

- (AudioFileID)songID {
    
    if (!_songID) {
        
        AudioFileID songID;
        OSStatus err = noErr;
        err = AudioFileOpenURL((__bridge CFURLRef)_fileURL, kAudioFileReadPermission, 0, &songID);
        if( err != noErr ) {
            NSLog( @"AudioFileOpenURL failed" );
            return nil;
        }
        
        _songID = songID;
    }
    
    return _songID;
}

#pragma mark -
@end
