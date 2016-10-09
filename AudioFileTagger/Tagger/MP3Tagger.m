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

#import <taglib/fileref.h>
#import <taglib/mpegfile.h>
#import <taglib/tag.h>
#import <taglib/tstring.h>
#import <taglib/tbytevector.h>
#import <taglib/attachedpictureframe.h>
#import <taglib/unsynchronizedlyricsframe.h>
#import <taglib/textidentificationframe.h>
#import <taglib/id3v2tag.h>

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


- (BOOL)tagFile:(NSURL *)fileURL {
    
    TagLib::MPEG::File f(fileURL.path.fileSystemRepresentation);

    if (f.tag() && self.metadata && self.metadata.validMetadata) {
        
        if (self.metadata.title) {
            
            f.tag()->setTitle(TagLib::String((self.metadata.title).UTF8String, TagLib::String::UTF8));
        }
        
        if (self.metadata.artist) {
            
            f.tag()->setArtist(TagLib::String((self.metadata.artist).UTF8String, TagLib::String::UTF8));
        }
        
        if (self.metadata.albumName) {
            
            f.tag()->setAlbum(TagLib::String((self.metadata.albumName).UTF8String, TagLib::String::UTF8));
        }
        
        // composer
        if (self.metadata.composer) {

            TagLib::ID3v2::TextIdentificationFrame *composerFrame = new TagLib::ID3v2::TextIdentificationFrame("TCOM", TagLib::String::Latin1);
            if (composerFrame) {
                
                composerFrame->setText(TagLib::String(self.metadata.composer.UTF8String, TagLib::String::UTF8));
                if (f.ID3v2Tag()) f.ID3v2Tag()->addFrame(composerFrame);
            }
        }
        
        if (self.metadata.genre) {
            
            f.tag()->setGenre(TagLib::String((self.metadata.genre).UTF8String, TagLib::String::UTF8));
        }
        
        if (self.metadata.artwork) {
            
            NSData *imgData	= [self.metadata.artwork pngData];
            if (imgData) {
                
                TagLib::ID3v2::AttachedPictureFrame *pictureFrame = new TagLib::ID3v2::AttachedPictureFrame();
                
                if (pictureFrame) {
                    
                    pictureFrame->setMimeType(TagLib::String("image/png", TagLib::String::UTF8));
                    pictureFrame->setPicture(TagLib::ByteVector((const char *)imgData.bytes, (uint)imgData.length));
                    if (f.ID3v2Tag()) f.ID3v2Tag()->addFrame(pictureFrame);
                }
            }
        }
        
        if (self.metadata.trackNumber) {
            
            f.tag()->setTrack((self.metadata.trackNumber).intValue);
        }
        
        if (self.metadata.year) {
            
            f.tag()->setYear((self.metadata.year).intValue);
        }
        
        if (self.metadata.comment) {
            
            f.tag()->setComment(TagLib::String((self.metadata.comment).UTF8String, TagLib::String::UTF8));
        }
        
        if (self.metadata.lyrics) {

            TagLib::ID3v2::UnsynchronizedLyricsFrame *lyricsFrame = new TagLib::ID3v2::UnsynchronizedLyricsFrame();
   
            if (lyricsFrame) {
                
                lyricsFrame->setText(TagLib::String((self.metadata.lyrics).UTF8String, TagLib::String::UTF8));
                if (f.ID3v2Tag()) f.ID3v2Tag()->addFrame(lyricsFrame);
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
