//
//  LFMKit+Protected.h
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
#import "LFMAlbum.h"
#import "LFMArtist.h"
#import "LFMUser.h"
#import "LFMTrack.h"
#import "LFMWiki.h"
#import "LFMTag.h"
#import "LFMSession.h"
#import "LFMQuery.h"
#import "LFMChart.h"

NS_ASSUME_NONNULL_BEGIN

@interface LFMAlbum()

- (instancetype)initWithName:(NSString *)name
                      artist:(NSString *)artist
                         URL:(NSURL *)URL
                      images:(NSDictionary<LFMImageSize, NSURL *> *)images
               musicBrainzID:(NSString *)mbid
                   listeners:(nullable NSNumber *)listeners
                   playCount:(nullable NSNumber *)playCount
                      tracks:(NSArray<LFMTrack *> *)tracks
                        tags:(NSArray<LFMTag *> *)tags
                        wiki:(nullable LFMWiki *)wiki;

- (nullable instancetype)initFromDictionary:(NSDictionary *)dictionary;

@end

@interface LFMArtist()

- (instancetype)initWithName:(NSString *)name
               musicBrainzID:(NSString *)mbid
                         URL:(NSURL *)URL
                      images:(NSDictionary<LFMImageSize, NSURL *> *)images
                  streamable:(BOOL)streamable
                      onTour:(BOOL)onTour
                   listeners:(nullable NSNumber *)listeners
                   playCount:(nullable NSNumber *)playCount
              similarArtists:(NSArray<LFMArtist *> *)similarArtists
                        tags:(NSArray<LFMTag *> *)tags
                        wiki:(nullable LFMWiki *)wiki;

- (nullable instancetype)initFromDictionary:(NSDictionary *)dictionary;

@end

@interface LFMUser()

- (nullable instancetype)initFromDictionary:(NSDictionary *)dictionary;

@end

@interface LFMTrack()

- (nullable instancetype)initFromDictionary:(NSDictionary *)dictionary;

@end

@interface LFMWiki()

- (nullable instancetype)initFromDictionary:(NSDictionary *)dictionary;

@end

@interface LFMTag()

- (nullable instancetype)initFromDictionary:(NSDictionary *)dictionary;

@end

@interface LFMSession()

- (nullable instancetype)initFromDictionary:(NSDictionary *)dictionary;

+ (nullable LFMSession *)loadFromKeychain;

- (BOOL)saveInKeychain;

- (BOOL)removeFromKeychain;

@end

@interface LFMQuery()

- (nullable instancetype)initFromDictionary:(NSDictionary *)dictionary;

- (nullable instancetype)initWithPage:(NSInteger)currentPage
                         totalResults:(NSInteger)totalResults
                         itemsPerPage:(NSInteger)itemsPerPage;

@end

@interface LFMChart()

- (nullable instancetype)initFromDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
