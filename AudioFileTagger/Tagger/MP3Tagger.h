/*
 *  MP3Tagger.h
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
 
 */

NS_ASSUME_NONNULL_BEGIN

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
