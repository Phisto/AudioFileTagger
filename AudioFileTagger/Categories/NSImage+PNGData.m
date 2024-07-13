/*
 *  NSImage+PNGData.m
 *  AudioFileTagger
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

#import "NSImage+PNGData.h"

@implementation NSImage (PNGData)
#pragma mark - Creating PNG data

- (nullable NSData *)pngData {
    
    NSEnumerator		*enumerator					= nil;
    NSImageRep			*currentRepresentation		= nil;
    NSBitmapImageRep	*bitmapRep					= nil;
    
    enumerator = [self.representations objectEnumerator];
    while((currentRepresentation = [enumerator nextObject])) {
        if([currentRepresentation isKindOfClass:[NSBitmapImageRep class]]) {
            bitmapRep = (NSBitmapImageRep *)currentRepresentation;
        }
    }
    // Create a bitmap representation if one doesn't exist
    if(!bitmapRep) {
        CGImageRef ref = [self CGImageForProposedRect:nil context:nil hints:nil];
        bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:ref];
    }
    return [bitmapRep representationUsingType:NSBitmapImageFileTypePNG properties:@{}];
}

#pragma mark -
@end
