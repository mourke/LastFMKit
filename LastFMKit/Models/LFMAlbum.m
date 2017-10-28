//
//  LFMAlbum.m
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
    BOOL _streamable;
    NSString *_mbid;
    unsigned int _listeners;
    unsigned int _playCount;
    NSArray <LFMTrack *> *_tracks;
    NSArray <LFMTag *> *_tags;
    LFMWiki *_wiki;
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        // Basic variables every album must have.
        NSString *name = [dictionary objectForKey:@"name"];
        NSString *artist = [dictionary objectForKey:@"artist"];
        NSURL *URL = [NSURL URLWithString:[dictionary objectForKey:@"url"]];
        NSString *streamableString = [dictionary objectForKey:@"streamable"];
        NSString *mbid = [dictionary objectForKey:@"mbid"];
        
        if (name != nil &&
            artist != nil &&
            URL != nil &&
            streamableString != nil &&
            mbid != nil)
        {
            NSDictionary *images = imageDictionaryFromArray([dictionary objectForKey:@"image"]);
            
            // Advanced variables that are only aquired on a `getInfo` call to Album.
            unsigned int listeners = [[dictionary objectForKey:@"listeners"] unsignedIntValue];
            unsigned int playCount = [[dictionary objectForKey:@"playcount"] unsignedIntValue];
            NSMutableArray <LFMTrack *> *tracks = [NSMutableArray array];
            
            for (NSDictionary *trackDictionary in [[dictionary objectForKey:@"tracks"] objectForKey:@"track"]) {
                LFMTrack *track = [[LFMTrack alloc] initFromDictionary:trackDictionary];
                track == nil ?: [tracks addObject: track];
            }
            
            NSMutableArray <LFMTag *> *tags = [NSMutableArray array];
            
            for (NSDictionary *tagDictionary in [[dictionary objectForKey:@"tags"] objectForKey:@"tag"]) {
                LFMTag *tag = [[LFMTag alloc] initFromDictionary:tagDictionary];
                tag == nil ?: [tags addObject: tag];
            }
            
            LFMWiki *wiki = [[LFMWiki alloc] initFromDictionary:[dictionary objectForKey:@"wiki"]];
            
            _name = name;
            _artist = artist;
            _URL = URL;
            _images = images;
            _streamable = [streamableString boolValue];
            _mbid = mbid;
            _listeners = listeners;
            _playCount = playCount;
            _tracks = tracks;
            _tags = tags;
            _wiki = wiki;
            
            return self;
        }
    }
    
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

- (BOOL)isStreamable {
    return _streamable;
}

- (NSString *)mbid {
    return _mbid;
}

- (unsigned int)listeners {
    return _listeners;
}

- (unsigned int)playCount {
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
