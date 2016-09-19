//
//  Metadata.h
//  AudioFileTagger
//
//  Created by Simon Gaus on 02.10.15.
//  Copyright © 2015 Simon Gaus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 
 */
@interface Metadata : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *albumName;
@property (nonatomic, strong) NSString *composer;
@property (nonatomic, strong) NSString *genre;
@property (nonatomic, strong) NSImage *artwork;
@property (nonatomic, strong) NSNumber *trackNumber;
@property (nonatomic, strong) NSNumber *year;

@end
NS_ASSUME_NONNULL_END
