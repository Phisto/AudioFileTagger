//
//  MP3Tagger.m
//  AudioFileTagger
//
//  Created by Simon Gaus on 01.10.15.
//  Copyright © 2015 Simon Gaus. All rights reserved.
//

#import "MP3Tagger.h"
#import "Metadata.h"
#import "NSImage+PNGData.h"


@import TagLib;

/*
#import <TagLib/TagLib.h>
#import <TagLib/tag_c.h>
#import <TagLib/tag.h>

#import <TagLib/fileref.h>
#import <TagLib/mpegfile.h>
#import <TagLib/tag.h>
#import <TagLib/tstring.h>
#import <TagLib/tbytevector.h>
#import <TagLib/attachedpictureframe.h>
#import <TagLib/id3v2tag.h>
*/

@interface MP3Tagger (/* Private */)

@property (nonatomic, strong) Metadata *metadata;

@end


@implementation MP3Tagger
#pragma mark - Initialisation


+ (nullable instancetype)taggerWithMetadata:(Metadata *)metadata {

    return [[[self class] alloc] initWithMetadata:metadata];
}


- (nullable instancetype)initWithMetadata:(Metadata *)metadata {
    
    if (!metadata) return nil;
    
    self = [super init];
    if (self) {

        _metadata = metadata;
    }
    
    return self;
}


#pragma mark - Tagging


- (BOOL)tagFile:(NSURL *)file {
    
    
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
    
    return NO;
}


#pragma mark -
@end
