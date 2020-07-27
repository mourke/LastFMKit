//
//  LFMUser.m
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

#import "LFMUser.h"
#import "LFMKit+Protected.h"

@implementation LFMUser {
    NSString *_userName;
    NSString *_realName;
    NSDictionary<LFMImageSize, NSURL *> *_images;
    NSURL *_URL;
    NSString *_country;
    NSUInteger _age;
    LFMUserGender _gender;
    BOOL _subscriber;
    NSUInteger _playCount;
    NSUInteger _playlistCount;
    NSDate *_dateRegistered;
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self &&
        dictionary != nil &&
        [dictionary isKindOfClass:NSDictionary.class]) {
        id username = [dictionary objectForKey:@"name"];
        id realName = [dictionary objectForKey:@"realname"];
        id URL = [dictionary objectForKey:@"url"];
        id country = [dictionary objectForKey:@"country"];
        id age = [dictionary objectForKey:@"age"];
        id gender = [dictionary objectForKey:@"gender"];
        id subscriber = [dictionary objectForKey:@"subscriber"];
        id playCount = [dictionary objectForKey:@"playcount"];
        id playlistCount = [dictionary objectForKey:@"playlists"];
        id registeredDictionary = [dictionary objectForKey:@"registered"];
        id registeredTime;
        
        if (registeredDictionary != nil &&
            [registeredDictionary isKindOfClass:NSDictionary.class]) {
            registeredTime = [(NSDictionary *)registeredDictionary objectForKey:@"unixtime"];
        }
        
        if (username != nil && [username isKindOfClass:NSString.class] &&
            realName != nil && [realName isKindOfClass:NSString.class] &&
            URL != nil && [URL isKindOfClass:NSString.class] &&
            country != nil && [country isKindOfClass:NSString.class] &&
            age != nil && [age isKindOfClass:NSString.class] &&
            gender != nil && [gender isKindOfClass:NSString.class] &&
            subscriber != nil && [subscriber isKindOfClass:NSNumber.class] &&
            playCount != nil && [playCount isKindOfClass:NSString.class] &&
            playlistCount != nil && [playlistCount isKindOfClass:NSString.class] &&
            registeredTime != nil && [username isKindOfClass:NSString.class])
        {
            _userName = username;
            _realName = realName;
            _images = imageDictionaryFromArray([dictionary objectForKey:@"image"]);
            _URL = [NSURL URLWithString:URL];
            _country = country;
            _age = [age unsignedIntegerValue];
            _gender = gender;
            _subscriber = [subscriber boolValue];
            _playCount = [playCount unsignedIntegerValue];
            _playlistCount = [playlistCount unsignedIntegerValue];
            _dateRegistered = [NSDate dateWithTimeIntervalSince1970:[registeredTime unsignedIntegerValue]];
            
            return self;
        }
    }
    
    return nil;
}

- (NSString *)username {
    return _userName;
}

- (NSString *)realName {
    return _realName;
}

- (NSDictionary<LFMImageSize,NSURL *> *)images {
    return _images;
}

- (NSURL *)URL {
    return _URL;
}

- (NSString *)country {
    return _country;
}

- (NSUInteger)age {
    return _age;
}

- (LFMUserGender)gender {
    return _gender;
}

- (BOOL)isSubscriber {
    return _subscriber;
}

- (NSUInteger)playCount {
    return _playCount;
}

-(NSUInteger)playlistCount {
    return _playlistCount;
}

- (NSDate *)dateRegistered {
    return _dateRegistered;
}

@end
