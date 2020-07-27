//
//  LFMTopTag.h
//  LastFMKit
//
//  Copyright © 2020 Mark Bourke.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE
//

#import <Foundation/Foundation.h>
#import "LFMTag.h"

NS_ASSUME_NONNULL_BEGIN

/**
 This class represents the object obtained when top tags for an artist/album/track are requested from Last.fm tag object.
 */
NS_SWIFT_NAME(TopTag)
@interface LFMTopTag : LFMTag

/** The number of times an artist/album/track is featured in a tag's playlist. */
@property(nonatomic) NSUInteger count;

- (instancetype)initWithName:(NSString *)tagName __attribute__((unavailable("Top tags should not be created. Please use the `LFMTag` object instead.")));

+ (instancetype)tagWithName:(NSString *)tagName __attribute__((unavailable("Top tags should not be created. Please use the `LFMTag` object instead.")));

@end

NS_ASSUME_NONNULL_END
