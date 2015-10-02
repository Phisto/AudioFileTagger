//
//  MP3Tagger.h
//  AudioFileTagger
//
//  Created by Simon Gaus on 01.10.15.
//  Copyright © 2015 Simon Gaus. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Metadata.h"

@interface MP3Tagger : NSObject

@property (nonatomic, strong) Metadata *metadata;

+ (instancetype)taggerForFile:(NSURL *)file;

- (BOOL)tag;

@end
