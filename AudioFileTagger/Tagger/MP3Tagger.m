//
//  MP3Tagger.m
//  AudioFileTagger
//
//  Created by Simon Gaus on 01.10.15.
//  Copyright © 2015 Simon Gaus. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MP3Tagger.h"

#include <taglib/mpegfile.h>				// TagLib::MPEG::File
#include <taglib/tag.h>						// TagLib::Tag
#include <taglib/tstring.h>					// TagLib::String
#include <taglib/tbytevector.h>				// TagLib::ByteVector
#include <taglib/textidentificationframe.h>	// TagLib::ID3V2::TextIdentificationFrame
#include <taglib/uniquefileidentifierframe.h> // TagLib::ID3V2::UniqueFileIdentifierFrame
#include <taglib/attachedpictureframe.h>	// TagLib::ID3V2::AttachedPictureFrame
#include <taglib/id3v2tag.h>				// TagLib::ID3V2::Tag
#include <taglib/commentsframe.h>			// TagLib::ID3V2::CommentsFrame
#include <taglib/unsynchronizedlyricsframe.h>// TagLib::ID3v2::UnsynchronizedLyricsFrame

@interface MP3Tagger (/* Private */)

@property (nonatomic, strong) NSURL *file;

@end

@implementation MP3Tagger

+ (instancetype)taggerForFile:(NSURL *)file {
    
    return [[[self class] alloc] initWithFile:file];
}

- (instancetype)initWithFile:(NSURL *)file {
    
    self = [super init];
    
    if (self != nil & file != nil) {
        
        _file = file;
        
    } else {
        
        return nil;
    }
    
    return self;
}

- (BOOL)tag {
    
    if (self.metadata) {
        
        TagLib::MPEG::File f([[self.file path] fileSystemRepresentation]);
        (TagLib::ID3v2::FrameFactory::instance())->setDefaultTextEncoding(TagLib::String::UTF8);
        
        NSData  *imgData;
        TagLib::ID3v2::TextIdentificationFrame *frame = NULL;
        
        if (self.metadata.title != nil) {
            
            f.tag()->setTitle(TagLib::String([self.metadata.title UTF8String], TagLib::String::UTF8));
        }
        
        if (self.metadata.artist != nil) {
            
            f.tag()->setArtist(TagLib::String([self.metadata.artist UTF8String], TagLib::String::UTF8));
        }
        
        if (self.metadata.albumName != nil) {
            
            f.tag()->setAlbum(TagLib::String([self.metadata.albumName UTF8String], TagLib::String::UTF8));
        }
        
        if(self.metadata.composer != nil) {
            
            frame = new TagLib::ID3v2::TextIdentificationFrame("TCOM", TagLib::String::Latin1);
            frame->setText(TagLib::String([self.metadata.composer UTF8String], TagLib::String::UTF8));
            f.ID3v2Tag()->addFrame(frame);
        }
        
        if (self.metadata.comment != nil) {
            
            TagLib::ID3v2::CommentsFrame *commentFrame = new TagLib::ID3v2::CommentsFrame(TagLib::String::UTF8);
            commentFrame->setLanguage("eng");
            commentFrame->setText(TagLib::String([self.metadata.comment UTF8String], TagLib::String::UTF8));
            f.ID3v2Tag()->addFrame(commentFrame);
        }
        
        if (self.metadata.year != nil) {
            
            f.tag()->setYear([self.metadata.year intValue]);
        }
        
        if (self.metadata.genre != nil) {
            
            f.tag()->setGenre(TagLib::String([self.metadata.genre UTF8String], TagLib::String::UTF8));
        }
        
        if (self.metadata.trackNumber != nil) {
            
            f.tag()->setTrack([self.metadata.trackNumber intValue]);
        }
        
        if (self.metadata.length != nil) {
            
            frame = new TagLib::ID3v2::TextIdentificationFrame("TLEN", TagLib::String::Latin1);
            frame->setText(TagLib::String([[NSString stringWithFormat:@"%u", 1000 * [self.metadata.length intValue]] UTF8String], TagLib::String::UTF8));
            f.ID3v2Tag()->addFrame(frame);
        }
        
        if (self.metadata.lyrics != nil) {
        
            TagLib::ID3v2::UnsynchronizedLyricsFrame *lyrframe = new TagLib::ID3v2::UnsynchronizedLyricsFrame(TagLib::String::UTF8);
            lyrframe-> setLanguage("eng");
            lyrframe-> setText(TagLib::String([self.metadata.lyrics UTF8String], TagLib::String::UTF8));
            f.ID3v2Tag()->addFrame(lyrframe);
        }
        
        if (self.metadata.artwork != nil) {
            
            imgData			= getPNGDataForImage(self.metadata.artwork);
            TagLib::ID3v2::AttachedPictureFrame *pictureFrame = new TagLib::ID3v2::AttachedPictureFrame();
            pictureFrame->setMimeType(TagLib::String("image/png", TagLib::String::Latin1));
            pictureFrame->setPicture(TagLib::ByteVector((const char *)[imgData bytes], (uint)[imgData length]));
            f.ID3v2Tag()->addFrame(pictureFrame);
        }
        
        return f.save();
        
    } else {
        
        return NO;
    }
}

NSData *
getPNGDataForImage(NSImage *image)
{
    return getBitmapDataForImage(image, NSPNGFileType);
}

NSData *
getBitmapDataForImage(NSImage					*image,
                      NSBitmapImageFileType		type)
{
    NSCParameterAssert(nil != image);
    
    NSEnumerator		*enumerator					= nil;
    NSImageRep			*currentRepresentation		= nil;
    NSBitmapImageRep	*bitmapRep					= nil;
    NSSize				size;
    
    enumerator = [[image representations] objectEnumerator];
    while((currentRepresentation = [enumerator nextObject])) {
        if([currentRepresentation isKindOfClass:[NSBitmapImageRep class]]) {
            bitmapRep = (NSBitmapImageRep *)currentRepresentation;
        }
    }
    
    // Create a bitmap representation if one doesn't exist
    if(nil == bitmapRep) {
        size = [image size];
        [image lockFocus];
        bitmapRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, size.width, size.height)];
        [image unlockFocus];
    }
    
    return [bitmapRep representationUsingType:type properties:@{}];
}

@end
