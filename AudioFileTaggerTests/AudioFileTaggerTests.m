/*
*  AudioFileTaggerTests.m
*  AudioFileTaggerTests
*
*  Copyright © 2015-2020 Simon Gaus <simon.cay.gaus@gmail.com>
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
*
*  You should have received a copy of the GNU Lesser General Public License
*  along with this library.  If not, see <http://www.gnu.org/licenses/>.
*
*/


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
