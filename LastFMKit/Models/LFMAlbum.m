//
//  LFMAlbum.m
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

#import "LFMAlbum.h"
#import "LFMTrack.h"
#import "LFMTag.h"
#import "LFMWiki.h"
#import "LFMKit+Protected.h"

@implementation LFMAlbum {
    NSString *_name;
    NSString *_artist;
    NSURL *_URL;
    NSDictionary<LFMImageSize, NSURL *> *_images;
    NSString *_mbid;
    NSUInteger _listeners;
    NSUInteger _playCount;
    NSArray <LFMTrack *> *_tracks;
    NSArray <LFMTag *> *_tags;
    LFMWiki *_wiki;
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self &&
        dictionary != nil &&
        [dictionary isKindOfClass:NSDictionary.class]) {
        // Basic variables every album must have.
        id name = [dictionary objectForKey:@"name"];
        id artist = [dictionary objectForKey:@"artist"];
        id URL = [dictionary objectForKey:@"url"];
        id mbid = [dictionary objectForKey:@"mbid"];
        
        if (name != nil && [name isKindOfClass:NSString.class] &&
            artist != nil && [artist isKindOfClass:NSString.class] &&
            URL != nil && [URL isKindOfClass:NSString.class] &&
            mbid != nil && [mbid isKindOfClass:NSString.class])
        {
            _images = imageDictionaryFromArray([dictionary objectForKey:@"image"]);
            
            id listeners = [dictionary objectForKey:@"listeners"];
            if ([listeners isKindOfClass:NSString.class]) {
                _listeners = [listeners unsignedIntegerValue];
            }
            
            id playCount = [dictionary objectForKey:@"playcount"];
            if ([playCount isKindOfClass:NSString.class]) {
                _playCount = [playCount unsignedIntegerValue];
            }
            
            id tracksDictionary = [dictionary objectForKey:@"tracks"];
            if (tracksDictionary != nil &&
                [tracksDictionary isKindOfClass:NSDictionary.class]) {
                NSMutableArray <LFMTrack *> *tracks = [NSMutableArray array];
                
                id tracksArray = [(NSDictionary *)tracksDictionary objectForKey:@"track"];
                if (tracksArray != nil &&
                    [tracksArray isKindOfClass:NSArray.class]) {
                    for (NSDictionary *trackDictionary in tracksArray) {
                        LFMTrack *track = [[LFMTrack alloc] initFromDictionary:trackDictionary];
                        if (track) [tracks addObject: track];
                    }
                }
                
                _tracks = tracks;
            } else {
                _tracks = [NSArray new];
            }
            
            id tagsDictionary = [dictionary objectForKey:@"tags"];
            if (tagsDictionary != nil &&
                [tagsDictionary isKindOfClass:NSDictionary.class]) {
                NSMutableArray <LFMTag *> *tags = [NSMutableArray array];
                
                id tagsArray = [(NSDictionary *)tagsDictionary objectForKey:@"tag"];
                if (tagsArray != nil &&
                    [tagsArray isKindOfClass:NSArray.class]) {
                    for (NSDictionary *tagDictionary in tagsArray) {
                        LFMTag *tag = [[LFMTag alloc] initFromDictionary:tagDictionary];
                        if (tag) [tags addObject: tag];
                    }
                }
                
                _tags = tags;
            } else {
                _tags = [NSArray new];
            }
            
            _wiki = [[LFMWiki alloc] initFromDictionary:[dictionary objectForKey:@"wiki"]];
            _name = name;
            _artist = artist;
            _URL = [NSURL URLWithString:URL];
            _mbid = mbid;
            
            return self;
        }
    }
    
    return nil;
}

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (instancetype)new {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (NSString *)name {
    return _name;
}

- (NSString *)artist {
    return _artist;
}

- (NSURL *)URL {
    return _URL;
}

- (NSDictionary<LFMImageSize,NSURL *> *)images {
    return _images;
}

- (NSString *)mbid {
    return _mbid;
}

- (NSUInteger)listeners {
    return _listeners;
}

- (NSUInteger)playCount {
    return _playCount;
}

- (NSArray<LFMTrack *> *)tracks {
    return _tracks;
}

- (NSArray<LFMTag *> *)tags {
    return _tags;
}

- (LFMWiki *)wiki {
    return _wiki;
}

@end
