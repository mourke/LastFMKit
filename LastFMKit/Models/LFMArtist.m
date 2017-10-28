//
//  LFMArtist.m
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

#import "LFMArtist.h"
#import "LFMKit+Protected.h"
#import "LFMTag.h"
#import "LFMWiki.h"

@implementation LFMArtist {
    NSString *_name;
    NSString *_mbid;
    NSURL *_URL;
    NSDictionary<LFMImageSize, NSURL *> *_images;
    BOOL _streamable;
    BOOL _onTour;
    unsigned int _listeners;
    unsigned int _playCount;
    NSArray<LFMArtist *> *_similarArtists;
    NSArray <LFMTag *> *_tags;
    LFMWiki *_wiki;
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        // Basic variables every artist must have.
        NSString *name = [dictionary objectForKey:@"name"];
        NSString *mbid = [dictionary objectForKey:@"mbid"];
        NSURL *URL = [NSURL URLWithString:[dictionary objectForKey:@"url"]];
        NSString *streamableString = [dictionary objectForKey:@"streamable"];
        
        if (name != nil &&
            mbid != nil &&
            URL != nil &&
            streamableString != nil)
        {
            // Advanced variables that are only aquired on a `getInfo` call to Artist.
            NSDictionary *images = imageDictionaryFromArray([dictionary objectForKey:@"image"]);
            
            NSMutableArray<LFMArtist *> *similarArtists = [NSMutableArray array];
            
            for (NSDictionary *similarArtistDictionary in [[dictionary objectForKey:@"similar"] objectForKey:@"artist"]) {
                LFMArtist *artist = [[LFMArtist alloc] initFromDictionary:similarArtistDictionary];
                artist == nil ?: [similarArtists addObject:artist];
            }
            
            NSMutableArray<LFMTag *> *tags = [NSMutableArray array];
            
            for (NSDictionary *tagDictionary in [[dictionary objectForKey:@"tags"] objectForKey:@"tag"]) {
                LFMTag *tag = [[LFMTag alloc] initFromDictionary:tagDictionary];
                tag == nil ?: [tags addObject:tag];
            }
            
            unsigned int listeners = [[[dictionary objectForKey:@"stats"] objectForKey:@"listeners"] unsignedIntValue];
            unsigned int playCount = [[[dictionary objectForKey:@"stats"] objectForKey:@"playcount"] unsignedIntValue];
            BOOL onTour = [[dictionary objectForKey:@"ontour"] boolValue];
            
            LFMWiki *wiki = [[LFMWiki alloc] initFromDictionary:[dictionary objectForKey:@"bio"]];
            
            _name = name;
            _mbid = mbid;
            _URL = URL;
            _streamable = [streamableString boolValue];
            _images = images;
            _similarArtists = similarArtists;
            _tags = tags;
            _listeners = listeners;
            _playCount = playCount;
            _onTour = onTour;
            _wiki = wiki;
            
            return self;
        }
    }
    
    return nil;
}

- (NSString *)name {
    return _name;
}

- (NSString *)mbid {
    return _mbid;
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

- (BOOL)isOnTour {
    return _onTour;
}

- (unsigned int)listeners {
    return _listeners;
}

- (unsigned int)playCount {
    return _playCount;
}

- (NSArray<LFMArtist *> *)similarArtists {
    return _similarArtists;
}

- (NSArray<LFMTag *> *)tags {
    return _tags;
}

- (LFMWiki *)wiki {
    return _wiki;
}

@end
