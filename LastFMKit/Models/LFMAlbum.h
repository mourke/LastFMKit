//
//  LFMAlbum.h
//  LastFMKit
//
//  Copyright © 2017 Mark Bourke.
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
#import "LFMImageSize.h"

@class LFMTrack, LFMTag, LFMWiki;

NS_ASSUME_NONNULL_BEGIN

/**
 This class represents the Last.fm album object.
 */
NS_SWIFT_NAME(Album)
@interface LFMAlbum : NSObject

/** The name of the album. */
@property(strong, nonatomic, readonly) NSString *name;

/** The name of the artist. */
@property(strong, nonatomic, readonly) NSString *artist;

/** The Last.fm URL for the album. Eg. "https://www.last.fm/music/Cher/Believe". */
@property(strong, nonatomic, readonly) NSURL *URL NS_SWIFT_NAME(url);

/** A dictionary album artwork. All the images are the exact same only different sizes. */
@property(strong, nonatomic, readonly) NSDictionary<LFMImageSize, NSURL *> *images;

/** A boolean value indicating whether or not the album is streamable. */
@property(nonatomic, readonly, getter=isStreamable) BOOL streamable;

/** The album's Musicbrainz id. */
@property(strong, nonatomic, readonly) NSString *mbid;

/** The amount of listeners the album has. */
@property(nonatomic, readonly) NSUInteger listeners;

/** The amount of "scrobbles" the track has. */
@property(nonatomic, readonly) NSUInteger playCount;

/** An array of all the album's tracks. */
@property(strong, nonatomic, readonly) NSArray <LFMTrack *> *tracks;

/** An array of tags that most accurately describe the album. */
@property(strong, nonatomic, readonly) NSArray <LFMTag *> *tags;

/** A small amount of information about the album. */
@property(strong, nonatomic, readonly, nullable) LFMWiki *wiki;

- (instancetype) __unavailable init;
+ (instancetype) __unavailable new;

@end

NS_ASSUME_NONNULL_END
