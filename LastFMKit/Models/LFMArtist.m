//
//  LFMArtist.m
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
    NSInteger _listeners;
    NSInteger _playCount;
    NSArray<LFMArtist *> *_similarArtists;
    NSArray<LFMTag *> *_tags;
    LFMWiki *_wiki;
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self &&
        dictionary != nil &&
        [dictionary isKindOfClass:NSDictionary.class]) {
        // Basic variables every artist must have.
        id name = [dictionary objectForKey:@"name"];
        id mbid = [dictionary objectForKey:@"mbid"];
        id URL = [dictionary objectForKey:@"url"];
        
        if (name != nil && [name isKindOfClass:NSString.class] &&
            mbid != nil && [name isKindOfClass:NSString.class] &&
            URL != nil && [name isKindOfClass:NSString.class])
        {
            // Advanced variables
            id streamable = [dictionary objectForKey:@"streamable"];
            if (streamable != nil &&
                [streamable isKindOfClass:NSNumber.class]) {
                _streamable = [streamable boolValue];
            }
            
            _images = imageDictionaryFromArray([dictionary objectForKey:@"image"]);
            
            id similarDictionary = [dictionary objectForKey:@"similar"];
            if (similarDictionary != nil &&
                [similarDictionary isKindOfClass:NSDictionary.class]) {
                NSMutableArray<LFMArtist *> *similarArtists = [NSMutableArray array];
                
                id similarArtistsArray = [(NSDictionary *)similarDictionary objectForKey:@"artist"];
                if (similarArtistsArray != nil &&
                    [similarArtistsArray isKindOfClass:NSArray.class]) {
                    for (NSDictionary *similarArtistDictionary in similarArtistsArray) {
                        LFMArtist *artist = [[LFMArtist alloc] initFromDictionary:similarArtistDictionary];
                        if (artist) [similarArtists addObject:artist];
                    }
                }
                
                _similarArtists = similarArtists;
            } else {
                _similarArtists = [NSArray new];
            }
            
            id tagsDictionary = [dictionary objectForKey:@"tags"];
            if (tagsDictionary != nil &&
                [tagsDictionary isKindOfClass:NSDictionary.class]) {
                NSMutableArray<LFMTag *> *tags = [NSMutableArray array];
                
                id tagsArray = [(NSDictionary *)tagsDictionary objectForKey:@"tag"];
                if (tagsArray != nil &&
                    [tagsArray isKindOfClass:NSArray.class]) {
                    for (NSDictionary *tagDictionary in tagsArray) {
                        LFMTag *tag = [[LFMTag alloc] initFromDictionary:tagDictionary];
                        if (tag) [tags addObject:tag];
                    }
                }
                
                _tags = tags;
            } else {
                _tags = [NSArray new];
            }
            
            id statsDictionary = [dictionary objectForKey:@"stats"];
            if (statsDictionary != nil &&
                [statsDictionary isKindOfClass:NSDictionary.class]) {
                id listeners = [(NSDictionary *)statsDictionary objectForKey:@"listeners"];
                if (listeners != nil &&
                    [listeners isKindOfClass:NSString.class]) {
                    _listeners = [listeners integerValue];
                }
                
                id playCount = [(NSDictionary *)statsDictionary objectForKey:@"playcount"];
                if (playCount != nil &&
                    [playCount isKindOfClass:NSString.class]) {
                    _playCount = [playCount integerValue];
                }
            }
            
            
            id onTour = [dictionary objectForKey:@"ontour"];
            if (onTour != nil &&
                [onTour isKindOfClass:NSNumber.class]) {
                _onTour = [onTour boolValue];
            }
            
            _wiki = [[LFMWiki alloc] initFromDictionary:[dictionary objectForKey:@"bio"]];
            
            _name = name;
            _mbid = mbid;
            _URL = [NSURL URLWithString:URL];
            
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

- (NSInteger)listeners {
    return _listeners;
}

- (NSInteger)playCount {
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

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_name forKey:NSStringFromSelector(@selector(name))];
    [coder encodeObject:_mbid forKey:NSStringFromSelector(@selector(mbid))];
    [coder encodeObject:_URL forKey:NSStringFromSelector(@selector(URL))];
    [coder encodeObject:_images forKey:NSStringFromSelector(@selector(images))];
    [coder encodeBool:_streamable forKey:NSStringFromSelector(@selector(isStreamable))];
    [coder encodeBool:_onTour forKey:NSStringFromSelector(@selector(isOnTour))];
    [coder encodeInteger:_listeners forKey:NSStringFromSelector(@selector(listeners))];
    [coder encodeInteger:_playCount forKey:NSStringFromSelector(@selector(playCount))];
    [coder encodeObject:_similarArtists forKey:NSStringFromSelector(@selector(similarArtists))];
    [coder encodeObject:_tags forKey:NSStringFromSelector(@selector(tags))];
    [coder encodeObject:_wiki forKey:NSStringFromSelector(@selector(wiki))];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
    self = [super init];
    
    if (self) {
        _name = [decoder decodeObjectForKey:NSStringFromSelector(@selector(name))];
        _mbid = [decoder decodeObjectForKey:NSStringFromSelector(@selector(mbid))];
        _URL = [decoder decodeObjectForKey:NSStringFromSelector(@selector(URL))];
        _images = [decoder decodeObjectForKey:NSStringFromSelector(@selector(images))];
        _streamable = [decoder decodeBoolForKey:NSStringFromSelector(@selector(isStreamable))];
        _onTour = [decoder decodeBoolForKey:NSStringFromSelector(@selector(isOnTour))];
        _listeners = [decoder decodeIntegerForKey:NSStringFromSelector(@selector(listeners))];
        _playCount = [decoder decodeIntegerForKey:NSStringFromSelector(@selector(playCount))];
        _similarArtists = [decoder decodeObjectForKey:NSStringFromSelector(@selector(similarArtists))];
        _tags = [decoder decodeObjectForKey:NSStringFromSelector(@selector(tags))];
        _wiki = [decoder decodeObjectForKey:NSStringFromSelector(@selector(wiki))];
    }
    
    return self;
}

@end
