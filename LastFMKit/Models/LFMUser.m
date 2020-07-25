//
//  LFMUser.m
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
    
    if (self) {
        NSString *username = [dictionary objectForKey:@"name"];
        NSString *realName = [dictionary objectForKey:@"realname"];
        NSURL *URL = [NSURL URLWithString:[dictionary objectForKey:@"url"]];
        NSString *country = [dictionary objectForKey:@"country"];
        NSUInteger age = [[dictionary objectForKey:@"age"] unsignedIntegerValue];
        LFMUserGender gender = [dictionary objectForKey:@"gender"];
        NSString *subscriberString = [dictionary objectForKey:@"subscriber"];
        NSUInteger playCount = [[dictionary objectForKey:@"playcount"] unsignedIntegerValue];
        NSUInteger playlistCount = [[dictionary objectForKey:@"playlists"] unsignedIntegerValue];
        double registeredTime = [[[dictionary objectForKey:@"registered"] objectForKey:@"unixtime"] doubleValue];
        NSDictionary *images = imageDictionaryFromArray([dictionary objectForKey:@"image"]);
        
        if (username != nil &&
            realName != nil &&
            URL != nil &&
            country != nil &&
            !isnan(age) &&
            gender != nil &&
            subscriberString != nil &&
            !isnan(playCount) &&
            !isnan(playlistCount) &&
            !isnan(registeredTime))
        {
            _userName = username;
            _realName = realName;
            _images = images;
            _URL = URL;
            _country = country;
            _age = age;
            _gender = gender;
            _subscriber = [subscriberString boolValue];
            _playCount = playCount;
            _playlistCount = playlistCount;
            _dateRegistered = [NSDate dateWithTimeIntervalSince1970:registeredTime];
            
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
