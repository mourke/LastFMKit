//
//  LFMTag.m
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

#import "LFMTag.h"
#import "LFMWiki.h"
#import "LFMKit+Protected.h"

@implementation LFMTag {
    NSString *_name;
    NSURL *_URL;
    NSNumber *_reach;
    NSNumber *_total;
    BOOL _streamable;
    LFMWiki *_wiki;
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self &&
        dictionary != nil &&
        [dictionary isKindOfClass:NSDictionary.class]) {
        // Required variable
        id name = [dictionary objectForKey:@"name"];
        
        if (name != nil &&
            [name isKindOfClass:NSString.class]) {
            _name = name;
            
            // Extra variables that are only obtained from certain api calls.
            id URL = [dictionary objectForKey:@"url"];
            if (URL != nil &&
                [URL isKindOfClass:NSString.class]) {
                _URL = [NSURL URLWithString:URL];
            }
            
            id reach = [dictionary objectForKey:@"reach"];
            if (reach != nil &&
                [reach isKindOfClass:NSString.class]) {
                _reach = [NSNumber numberWithInt:[reach intValue]];
            }
                        
            id total = [dictionary objectForKey:@"total"];
            if (total != nil &&
                [total isKindOfClass:NSString.class]) {
                _total = [NSNumber numberWithInt:[total intValue]];
            }
                        
            id streamable = [dictionary objectForKey:@"streamable"];
            if (streamable != nil &&
                [streamable isKindOfClass:NSNumber.class]) {
                _streamable = [streamable boolValue];
            }
            
            _wiki = [[LFMWiki alloc] initFromDictionary:[dictionary objectForKey:@"wiki"]];
            
            return self;
        }
    }
    
    return nil;
}

- (instancetype)initWithName:(NSString *)tagName {
    self = [super init];
    
    if (self) {
        _name = tagName;
        _URL = nil;
        _reach = 0;
        _total = 0;
        _streamable = NO;
        _wiki = nil;
    }
    
    return self;
}

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (instancetype)new {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (instancetype)tagWithName:(NSString *)tagName {
    return [[LFMTag alloc] initWithName:tagName];
}

- (NSString *)name {
    return _name;
}

- (NSURL *)URL {
    return _URL;
}

- (NSNumber *)reach {
    return _reach;
}

- (NSNumber *)total {
    return _total;
}

- (BOOL)isStreamable {
    return _streamable;
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
    [coder encodeObject:_URL forKey:NSStringFromSelector(@selector(URL))];
    [coder encodeBool:_streamable forKey:NSStringFromSelector(@selector(isStreamable))];
    [coder encodeObject:_reach forKey:NSStringFromSelector(@selector(reach))];
    [coder encodeObject:_total forKey:NSStringFromSelector(@selector(tags))];
    [coder encodeObject:_wiki forKey:NSStringFromSelector(@selector(wiki))];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
    self = [super init];
    
    if (self) {
        _name = [decoder decodeObjectForKey:NSStringFromSelector(@selector(name))];
        _URL = [decoder decodeObjectForKey:NSStringFromSelector(@selector(URL))];
        _streamable = [decoder decodeBoolForKey:NSStringFromSelector(@selector(isStreamable))];
        _reach = [decoder decodeObjectForKey:NSStringFromSelector(@selector(reach))];
        _total = [decoder decodeObjectForKey:NSStringFromSelector(@selector(total))];
        _wiki = [decoder decodeObjectForKey:NSStringFromSelector(@selector(wiki))];
    }
    
    return self;
}

@end
