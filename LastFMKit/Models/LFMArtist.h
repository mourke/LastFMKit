//
//  LFMArtist.h
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
#import "LFMImageSize.h"

@class LFMArtist, LFMTag, LFMWiki;

NS_ASSUME_NONNULL_BEGIN

/**
 This class represents a Last.fm artist object.
 */
NS_SWIFT_NAME(Artist)
@interface LFMArtist : NSObject

/** The artist's name. */
@property(strong, nonatomic, readonly) NSString *name;

/** The artist's MusicBrainz id. */
@property(strong, nonatomic, readonly) NSString *mbid;

/** The Last.fm URL for the artist. Eg. "http://www.last.fm/music/Cher" */
@property(strong, nonatomic, readonly) NSURL *URL NS_SWIFT_NAME(url);

/** A dictionary of images of the artist. All the images are the exact same only different sizes. */
@property(strong, nonatomic, readonly) NSDictionary<LFMImageSize, NSURL *> *images;

/** A boolean value indicating whether the artist's tracks can be played or not. */
@property(nonatomic, readonly, getter=isStreamable) BOOL streamable;

/** A boolean value indicating whether the artist is currently touring. */
@property(nonatomic, readonly, getter=isOnTour) BOOL onTour;

/** The amount of listeners the artist has. */
@property(nonatomic, readonly) NSUInteger listeners;

/** The amount of "scrobbles" the artist has. */
@property(nonatomic, readonly) NSUInteger playCount;

/** An array of artists similar to the artist. */
@property(strong, nonatomic, readonly) NSArray<LFMArtist *> *similarArtists NS_SWIFT_NAME(similar);

/** An array of tags that most accurately describe the artist's music. */
@property(strong, nonatomic) NSArray <LFMTag *> *tags;

/** A small amount of information about the artist. */
@property(strong, nonatomic, nullable) LFMWiki *wiki;

- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
