//
//  MP3Tagger.m
//  AudioFileTagger
//
//  Created by Simon Gaus on 01.10.15.
//  Copyright © 2015 Simon Gaus. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

#import "MP3Tagger.h"
#import "Metadata.h"
#import "NSImage+PNGData.h"

#import "fileref.h"
#import "fileref.h"
#import "mpegfile.h"				// TagLib::MPEG::File
#import "tag.h"						// TagLib::Tag
#import "tstring.h"					// TagLib::String
#import "tbytevector.h"				// TagLib::ByteVector
#import "attachedpictureframe.h"	// TagLib::ID3V2::AttachedPictureFrame
#import "id3v2tag.h"				// TagLib::ID3V2::Tag

@interface MP3Tagger (/* Private */)
/**
 
 */
@property (nonatomic, strong) NSURL *file;
/**
 
 The metadata for a audio file.
 
 */
@property (nonatomic, strong) Metadata *metadata;

@end

@implementation MP3Tagger

+ (nullable instancetype)taggerFromFile:(NSURL *)fileURL readAudioProperties:(BOOL)readAudioProperties {
    
    return [[[self class] alloc] initWithFile:fileURL];
}

- (nullable instancetype)initWithFile:(NSURL *)fileURL {
    
    if (!fileURL) return nil;
    
    self = [super init];
    if (self) {
        
        _file = fileURL;
        Metadata *meta = [self readMetadata];
        if (!meta) {
            return nil;
        }
        _metadata = meta;
    }
    
    return self;
}

- (BOOL)tagFile:(NSURL *)file {
    
    @try {
        
        TagLib::MPEG::File f(file.path.fileSystemRepresentation);
        
        if (f.tag() != NULL && self.metadata) {
         
            if (self.metadata.title) {
                
                f.tag()->setTitle(TagLib::String((self.metadata.title).UTF8String, TagLib::String::UTF8));
            }
            
            if (self.metadata.artist) {
                
                f.tag()->setArtist(TagLib::String((self.metadata.artist).UTF8String, TagLib::String::UTF8));
            }
            
            if (self.metadata.albumName) {
                
                f.tag()->setAlbum(TagLib::String((self.metadata.albumName).UTF8String, TagLib::String::UTF8));
            }
            
            if (self.metadata.year) {
                
                f.tag()->setYear((self.metadata.year).intValue);
            }
            
            if (self.metadata.genre) {
                
                f.tag()->setGenre(TagLib::String((self.metadata.genre).UTF8String, TagLib::String::UTF8));
            }
            
            if (self.metadata.trackNumber) {
                
                f.tag()->setTrack((self.metadata.trackNumber).intValue);
            }
            
            if (self.metadata.artwork) {
                
                NSData *imgData	= [self.metadata.artwork pngData];
                if (imgData) {
                    
                    TagLib::ID3v2::AttachedPictureFrame *pictureFrame = new TagLib::ID3v2::AttachedPictureFrame();
                    
                    if (pictureFrame != NULL) {
                     
                        pictureFrame->setMimeType(TagLib::String("image/png", TagLib::String::UTF8));
                        pictureFrame->setPicture(TagLib::ByteVector((const char *)imgData.bytes, (uint)imgData.length));
                        if (f.ID3v2Tag() != NULL) f.ID3v2Tag()->addFrame(pictureFrame);
                    }
                }
            }
            
            BOOL successSave = f.save();
            return successSave;
        }
        else {
            // there are no tags, so we can say we wrote them sucessfully :)
            return YES;
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Writing tags failed with exception: %@", exception);
    }
    
    @catch (...) {
        
        NSLog(@"Writing tags failed with unknown exception.");
    }
    
    return NO;
}

- (Metadata *)readMetadata {
    
    Metadata *theMetadata = [[Metadata alloc] init];
    
    AVAsset *asset = [AVURLAsset URLAssetWithURL:self.file options:nil];
    
    BOOL someMetadate = NO;
    
    /************************************* title ******************************************/
    
    NSArray *titles = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata
                                                     withKey:AVMetadataCommonKeyTitle
                                                    keySpace:AVMetadataKeySpaceCommon];
    AVMetadataItem *title;
    if (titles.count > 0) {
        title = [titles objectAtIndex:0];
        theMetadata.title = (NSString *)title.value;
        someMetadate = YES;
    }
    
    /************************************* artist ******************************************/
    
    NSArray *artists = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata
                                                      withKey:AVMetadataCommonKeyArtist
                                                     keySpace:AVMetadataKeySpaceCommon];
    AVMetadataItem *artist;
    if (artists.count > 0) {
        artist = [artists objectAtIndex:0];
        theMetadata.artist = (NSString *)artist.value;
        someMetadate = YES;
    }
    
    /************************************* albumNames ******************************************/
    
    NSArray *albumNames = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata
                                                         withKey:AVMetadataCommonKeyAlbumName
                                                        keySpace:AVMetadataKeySpaceCommon];
    AVMetadataItem *albumName;
    if (albumNames.count > 0) {
        albumName = [albumNames objectAtIndex:0];
        theMetadata.albumName = (NSString *)albumName.value;
        someMetadate = YES;
    }
    
    /*********************** track number, Genre, Composer, Comment ****************************/
    
    for (AVMetadataItem *obj in asset.metadata) {
        
        //Track Number
        if ([obj.key isEqual:@"com.apple.iTunes.iTunes_CDDB_TrackNumber"]) {
            
            NSInteger trkN = [(NSString *)obj.value integerValue];
            theMetadata.trackNumber = [NSNumber numberWithInteger:trkN];
            someMetadate = YES;
        }
        
        // (User set)Genre
        if ([obj.identifier isEqualToString:@"itsk/%A9gen"]) {
            
            theMetadata.genre = (NSString *)obj.value;
            someMetadate = YES;
        }
        
        // Composer
        if ([obj.identifier isEqualToString:@"itsk/%A9wrt"]) {
            
            theMetadata.composer = (NSString *)obj.value;
            someMetadate = YES;
        }
    }
    
    /******************************************** year ********************************************/
    
    NSArray *years = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata
                                                    withKey:AVMetadataiTunesMetadataKeyReleaseDate
                                                   keySpace:AVMetadataKeySpaceiTunes];
    AVMetadataItem *year;
    if (years.count > 0) {
        year = [years objectAtIndex:0];
        theMetadata.year = [NSNumber numberWithInteger:[(NSString *)year.value integerValue]];
        someMetadate = YES;
    }
    
    /********************************************** genre ********************************************/
    
    NSArray *genres = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata
                                                     withKey:AVMetadataiTunesMetadataKeyUserGenre
                                                    keySpace:AVMetadataKeySpaceiTunes];
    AVMetadataItem *genre;
    if (genres.count > 0) {
        genre = [genres objectAtIndex:0];
        theMetadata.genre = (NSString *)genre.value;
        someMetadate = YES;
    }
    
    /******************************************** artwork ********************************************/
    
    [asset loadValuesAsynchronouslyForKeys:@[@"commonMetadata"] completionHandler:^{
        NSArray *artworks = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata
                                                           withKey:AVMetadataCommonKeyArtwork
                                                          keySpace:AVMetadataKeySpaceCommon];
        
        NSImage *img;
        for (AVMetadataItem *item in artworks) {
            if ([item.keySpace isEqualToString:AVMetadataKeySpaceID3]) {
                NSDictionary *d = [item.value copyWithZone:nil];
                img = [[NSImage alloc] initWithData:[d objectForKey:@"data"]];
            } else if ([item.keySpace isEqualToString:AVMetadataKeySpaceiTunes]) {
                img = [[NSImage alloc] initWithData:[item.value copyWithZone:nil]];
            }
        }
        if (img) {
            
            theMetadata.artwork = img;
        }
    }];
    
    /************************************************************************************************/
    
    // only return methadata if there is at least one field set...
    return (someMetadate) ? theMetadata : nil;
}

#pragma mark -
@end
