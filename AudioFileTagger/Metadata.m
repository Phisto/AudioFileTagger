//
//  Metadata.m
//  AudioFileTagger
//
//  Created by Simon Gaus on 02.10.15.
//  Copyright © 2015 Simon Gaus. All rights reserved.
//

#import "Metadata.h"

@implementation Metadata

/*
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *albumName;
@property (nonatomic, strong) NSString *composer;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *genre;
@property (nonatomic, strong) NSString *lyrics;
@property (nonatomic, strong) NSImage *artwork;
@property (nonatomic, strong) NSString *trackNumber;
@property (nonatomic, strong) NSNumber *year;
@property (nonatomic, strong) NSNumber *length;
*/

- (BOOL)isValid {
    
    if (self.title != nil || self.artist != nil || self.albumName != nil || self.composer != nil || self.comment != nil || self.genre != nil || self.lyrics != nil || self.artwork != nil || self.trackNumber != nil || self.year != nil || self.length != nil) {
        
        return YES;
    }
    
    return NO;
}

- (NSString *)description; {
    
    return [NSString stringWithFormat:@"Description:\n title %@\n - \n artist %@\n - \n albumName %@\n - \n composer %@\n - \n comment %@\n - \n genre %@\n - \n lyrics %@\n - \n artwork %@\n - \n trackNumber %lu\n - \n year %lu\n - \n length %lu\n", self.title, self.artist, self.albumName, self.composer, self.comment, self.genre, self.lyrics, self.artwork, [self.trackNumber integerValue], [self.year integerValue], [self.length integerValue]];
}

@end
