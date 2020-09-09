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
    NSString *_username;
    NSString *_realName;
    NSDictionary<LFMImageSize, NSURL *> *_images;
    NSURL *_URL;
    NSString *_country;
    NSInteger _age;
    LFMUserGender _gender;
    BOOL _subscriber;
    NSInteger _playCount;
    NSInteger _playlistCount;
    NSDate *_dateRegistered;
}

static LFMUserGender genderFromString(NSString *gender) {
    if ([gender isEqualToString:LFMUserGenderMale]) {
        return LFMUserGenderMale;
    } else if ([gender isEqualToString:LFMUserGenderFemale]) {
        return LFMUserGenderFemale;
    } else {
        return LFMUserGenderOther;
    }
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
            subscriber != nil && [subscriber isKindOfClass:NSString.class] &&
            playCount != nil && [playCount isKindOfClass:NSString.class] &&
            playlistCount != nil && [playlistCount isKindOfClass:NSString.class] &&
            registeredTime != nil && [username isKindOfClass:NSString.class])
        {
            _username = username;
            _realName = realName;
            _images = imageDictionaryFromArray([dictionary objectForKey:@"image"]);
            _URL = [NSURL URLWithString:URL];
            _country = country;
            _age = [age integerValue];
            _subscriber = [subscriber boolValue];
            _playCount = [playCount integerValue];
            _playlistCount = [playlistCount integerValue];
            _dateRegistered = [NSDate dateWithTimeIntervalSince1970:[registeredTime integerValue]];
            
            _gender = genderFromString(gender);
            
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

- (NSString *)username {
    return _username;
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

- (NSInteger)age {
    return _age;
}

- (LFMUserGender)gender {
    return _gender;
}

- (BOOL)isSubscriber {
    return _subscriber;
}

- (NSInteger)playCount {
    return _playCount;
}

-(NSInteger)playlistCount {
    return _playlistCount;
}

- (NSDate *)dateRegistered {
    return _dateRegistered;
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_username forKey:NSStringFromSelector(@selector(username))];
    [coder encodeObject:_realName forKey:NSStringFromSelector(@selector(realName))];
    [coder encodeObject:_URL forKey:NSStringFromSelector(@selector(URL))];
    [coder encodeObject:_images forKey:NSStringFromSelector(@selector(images))];
    [coder encodeObject:_country forKey:NSStringFromSelector(@selector(country))];
    [coder encodeBool:_subscriber forKey:NSStringFromSelector(@selector(isSubscriber))];
    [coder encodeInteger:_age forKey:NSStringFromSelector(@selector(age))];
    [coder encodeInteger:_playCount forKey:NSStringFromSelector(@selector(playCount))];
    [coder encodeObject:_gender forKey:NSStringFromSelector(@selector(gender))];
    [coder encodeInteger:_playlistCount forKey:NSStringFromSelector(@selector(playlistCount))];
    [coder encodeObject:_dateRegistered forKey:NSStringFromSelector(@selector(dateRegistered))];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
    self = [super init];
    
    if (self) {
        _username = [decoder decodeObjectForKey:NSStringFromSelector(@selector(username))];
        _realName = [decoder decodeObjectForKey:NSStringFromSelector(@selector(realName))];
        _URL = [decoder decodeObjectForKey:NSStringFromSelector(@selector(URL))];
        _images = [decoder decodeObjectForKey:NSStringFromSelector(@selector(images))];
        _country = [decoder decodeObjectForKey:NSStringFromSelector(@selector(country))];
        _subscriber = [decoder decodeBoolForKey:NSStringFromSelector(@selector(isSubscriber))];
        _age = [decoder decodeIntegerForKey:NSStringFromSelector(@selector(age))];
        _playCount = [decoder decodeIntegerForKey:NSStringFromSelector(@selector(playCount))];
        _playlistCount = [decoder decodeIntegerForKey:NSStringFromSelector(@selector(playlistCount))];
        _dateRegistered = [decoder decodeObjectForKey:NSStringFromSelector(@selector(dateRegistered))];
        _gender = genderFromString([decoder decodeObjectForKey:NSStringFromSelector(@selector(gender))]);
    }
    
    return self;
}

@end
