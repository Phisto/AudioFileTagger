//
//  Metadata.h
//  AudioFileTagger
//
//  Created by Simon Gaus on 02.10.15.
//  Copyright © 2015 Simon Gaus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Metadata : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *albumName;
@property (nonatomic, strong) NSString *composer;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *genre;
@property (nonatomic, strong) NSString *lyrics;
@property (nonatomic, strong) NSImage *artwork;
@property (nonatomic, strong) NSNumber *trackNumber;
@property (nonatomic, strong) NSNumber *year;
@property (nonatomic, strong) NSNumber *length;

@property (NS_NONATOMIC_IOSONLY, getter=isValid, readonly) BOOL valid; 

@end
