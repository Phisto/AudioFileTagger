//
//  AudioFileTaggerTests.m
//  AudioFileTaggerTests
//
//  Created by Simon Gaus on 12.08.16.
//  Copyright © 2016 Simon Gaus. All rights reserved.
//

#import <XCTest/XCTest.h>

@import AudioFileTagger;

@interface AudioFileTaggerTests : XCTestCase

@end

@implementation AudioFileTaggerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    NSBundle *bundle = [NSBundle bundleForClass:[AudioFileTaggerTests class]];

    NSString * kfile1Path = [bundle pathForResource:@"Black Barrels Waste -final" ofType:@"m4a"];

    for (NSString *path in @[kfile1Path]) {//, kfile2Path]) {
     
        Metadata *meta = [[Metadata alloc] initWithMetadataFromFile:[NSURL fileURLWithPath:path]];

        NSLog(@"\n");
        NSLog(@"\n");
        NSLog(@"title: %@", meta.title);
        NSLog(@"artist: %@", meta.artist);
        NSLog(@"albumName: %@", meta.albumName);
        NSLog(@"composer: %@", meta.composer);
        NSLog(@"genre: %@", meta.genre);
        NSLog(@"artwork: %@", meta.artwork);
        NSLog(@"trackNumber: %@", meta.trackNumber);
        NSLog(@"year: %@", meta.year);
        NSLog(@"comment: %@", meta.comment);
        NSLog(@"lyrics: %@", meta.lyrics);
        NSLog(@"\n");
        NSLog(@"\n");
    }
}

@end
