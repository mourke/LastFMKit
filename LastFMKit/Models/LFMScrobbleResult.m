//
//  LFMScrobbleResult.m
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

#import "LFMScrobbleResult.h"
#import "LFMKit+Protected.h"
#import "LFMError.h"

@implementation LFMScrobbleResult {
    NSDate *_scrobbledDate;
    NSString *_trackName;
    NSString *_artistName;
    NSString *_albumName;
    NSString *_albumArtistName;
    BOOL _trackCorrected;
    BOOL _artistCorrected;
    BOOL _albumCorrected;
    BOOL _albumArtistCorrected;
    NSError *_ignoredError;
    BOOL _ignored;
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self &&
        dictionary != nil &&
        [dictionary isKindOfClass:NSDictionary.class]) {
        id artist;
        id artistCorrected;
        id albumArtist;
        id albumArtistCorrected;
        id album;
        id albumCorrected;
        id track;
        id trackCorrected;
        id timestampString = [dictionary objectForKey:@"timestamp"];
        
        id artistDictionary = [dictionary objectForKey:@"artist"];
        if (artistDictionary != nil &&
            [artistDictionary isKindOfClass:NSDictionary.class]) {
            artist = [(NSDictionary *)artistDictionary objectForKey:@"#text"];
            artistCorrected = [(NSDictionary *)artistDictionary objectForKey:@"corrected"];
        }
        
        id albumArtistDictionary = [dictionary objectForKey:@"albumArtist"];
        if (albumArtistDictionary != nil &&
            [albumArtistDictionary isKindOfClass:NSDictionary.class]) {
            albumArtist = [(NSDictionary *)albumArtistDictionary objectForKey:@"#text"];
            albumArtistCorrected = [(NSDictionary *)albumArtistDictionary objectForKey:@"corrected"];
        }
        
        id trackDictionary = [dictionary objectForKey:@"track"];
        if (trackDictionary != nil &&
            [trackDictionary isKindOfClass:NSDictionary.class]) {
            track = [(NSDictionary *)trackDictionary objectForKey:@"#text"];
            trackCorrected = [(NSDictionary *)trackDictionary objectForKey:@"corrected"];
        }
        
        id albumDictionary = [dictionary objectForKey:@"album"];
        if (albumDictionary != nil &&
            [albumDictionary isKindOfClass:NSDictionary.class]) {
            album = [(NSDictionary *)albumDictionary objectForKey:@"#text"];
            albumCorrected = [(NSDictionary *)albumDictionary objectForKey:@"corrected"];
        }
        
        id ignoredMessageDictionary = [dictionary objectForKey:@"ignoredMessage"];
        if (ignoredMessageDictionary != nil &&
            [ignoredMessageDictionary isKindOfClass:NSDictionary.class]) {
            id codeString = [(NSDictionary *)ignoredMessageDictionary objectForKey:@"code"];
            
            if (codeString != nil && [codeString isKindOfClass:NSString.class]) {
                NSInteger code = [codeString integerValue];
                NSString *message;
                
                switch (code) {
                    case 1:
                        message = @"Artist was ignored";
                        break;
                    case 2:
                        message = @"Track was ignored";
                        break;
                    case 3:
                        message = @"Timestamp was too old";
                        break;
                    case 4:
                        message = @"Timestamp was too new";
                        break;
                    case 5:
                        message = @"Daily scrobble limit exceeded";
                        break;
                    case 0:
                        // [[fallthrough]];
                    default:
                        message = nil;
                        break;
                }
                
                if (message != nil) {
                    _ignoredError = [NSError errorWithDomain:LFMScrobbleErrorDomain
                                                        code:code
                                                    userInfo:@{NSLocalizedDescriptionKey : message}];
                }
            }
            
        }
        
        if (artist != nil && [artist isKindOfClass:NSString.class] &&
            artistCorrected != nil && [artistCorrected isKindOfClass:NSString.class] &&
            track != nil && [track isKindOfClass:NSString.class] &&
            trackCorrected != nil && [trackCorrected isKindOfClass:NSString.class] &&
            albumArtistCorrected != nil && [albumArtistCorrected isKindOfClass:NSString.class] &&
            albumCorrected != nil && [albumCorrected isKindOfClass:NSString.class] &&
            timestampString != nil && [timestampString isKindOfClass:NSString.class]) {
            _artistName = artist;
            _artistCorrected = [artistCorrected boolValue];
            _trackName = track;
            _trackCorrected = [trackCorrected boolValue];
            _albumArtistCorrected = [albumArtistCorrected boolValue];
            _albumCorrected = [albumCorrected boolValue];
            _ignored = _ignoredError != nil;
            _scrobbledDate = [NSDate dateWithTimeIntervalSince1970:[timestampString doubleValue]];
            
            if (albumArtist != nil && [albumArtist isKindOfClass:NSString.class]) {
                _albumArtistName = albumArtist;
            }
            
            if (album != nil && [album isKindOfClass:NSString.class]) {
                _albumName = album;
            }
            
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

- (NSString *)artistName {
    return _artistName;
}

- (NSString *)trackName {
    return _trackName;
}

- (NSString *)albumArtistName {
    return _albumArtistName;
}

- (NSString *)albumName {
    return _albumName;
}

- (NSDate *)scrobbledDate {
    return _scrobbledDate;
}

- (BOOL)wasAlbumCorrected {
    return _albumCorrected;
}

- (BOOL)wasTrackCorrected {
    return _trackCorrected;
}

- (BOOL)wasArtistCorrected {
    return _artistCorrected;
}

- (BOOL)wasAlbumArtistCorrected {
    return _albumArtistCorrected;
}

- (BOOL)wasIgnored {
    return _ignored;
}

- (NSError *)ignoredError {
    return _ignoredError;
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    
    [coder encodeObject:_scrobbledDate forKey:NSStringFromSelector(@selector(scrobbledDate))];
    [coder encodeObject:_trackName forKey:NSStringFromSelector(@selector(trackName))];
    [coder encodeObject:_artistName forKey:NSStringFromSelector(@selector(artistName))];
    [coder encodeObject:_albumName forKey:NSStringFromSelector(@selector(albumName))];
    [coder encodeObject:_albumArtistName forKey:NSStringFromSelector(@selector(albumArtistName))];
    [coder encodeBool:_trackCorrected forKey:NSStringFromSelector(@selector(wasTrackCorrected))];
    [coder encodeBool:_artistCorrected forKey:NSStringFromSelector(@selector(wasArtistCorrected))];
    [coder encodeBool:_albumCorrected forKey:NSStringFromSelector(@selector(wasAlbumCorrected))];
    [coder encodeBool:_albumArtistCorrected forKey:NSStringFromSelector(@selector(wasAlbumArtistCorrected))];
    [coder encodeBool:_ignored forKey:NSStringFromSelector(@selector(wasIgnored))];
    [coder encodeObject:_ignoredError forKey:NSStringFromSelector(@selector(ignoredError))];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
    self = [super init];
    
    if (self) {
        _scrobbledDate = [decoder decodeObjectForKey:NSStringFromSelector(@selector(scrobbledDate))];
        _trackName = [decoder decodeObjectForKey:NSStringFromSelector(@selector(trackName))];
        _artistName = [decoder decodeObjectForKey:NSStringFromSelector(@selector(artistName))];
        _albumName = [decoder decodeObjectForKey:NSStringFromSelector(@selector(albumName))];
        _albumArtistName = [decoder decodeObjectForKey:NSStringFromSelector(@selector(albumArtistName))];
        _trackCorrected = [decoder decodeBoolForKey:NSStringFromSelector(@selector(wasTrackCorrected))];
        _artistCorrected = [decoder decodeBoolForKey:NSStringFromSelector(@selector(wasArtistCorrected))];
        _albumCorrected = [decoder decodeBoolForKey:NSStringFromSelector(@selector(wasAlbumCorrected))];
        _albumArtistCorrected = [decoder decodeBoolForKey:NSStringFromSelector(@selector(wasAlbumArtistCorrected))];
        _ignored = [decoder decodeBoolForKey:NSStringFromSelector(@selector(wasIgnored))];
        _ignoredError = [decoder decodeObjectForKey:NSStringFromSelector(@selector(ignoredError))];
    }
    
    return self;
}

@end
