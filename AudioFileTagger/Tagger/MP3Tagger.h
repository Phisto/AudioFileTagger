//
//  MP3Tagger.h
//  AudioFileTagger
//
//  Created by Simon Gaus on 01.10.15.
//  Copyright © 2015 Simon Gaus. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Metadata.h"

NS_ASSUME_NONNULL_BEGIN
/**
 
 */
@interface MP3Tagger : NSObject
/**
 @param file
 */
+ (nullable instancetype)taggerForFile:(NSURL *)file;
/**
 @param file
 @return
 */
- (BOOL)tagFile:(NSURL *)file;

@end
NS_ASSUME_NONNULL_END
