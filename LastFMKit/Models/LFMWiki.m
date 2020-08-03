//
//  LFMWiki.m
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

#import "LFMWiki.h"

@implementation LFMWiki {
    NSDate *_publishedDate;
    NSString *_summary;
    NSString *_content;
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self &&
        dictionary != nil &&
        [dictionary isKindOfClass:NSDictionary.class]) {
        id dateString = [dictionary objectForKey:@"published"];
        id summary = [dictionary objectForKey:@"summary"];
        id content = [dictionary objectForKey:@"content"];
        
        if (dateString != nil && [dateString isKindOfClass:NSString.class] &&
            summary != nil && [summary isKindOfClass:NSString.class] &&
            content != nil && [content isKindOfClass:NSString.class]) {
            NSDateFormatter *formatter = [NSDateFormatter new];
            [formatter setDateFormat:@"dd MMM yyyy, HH:mm"];
            
            NSDate *date = [formatter dateFromString:dateString];
            
            _publishedDate = date == nil ? [NSDate distantPast] : date;
            _summary = summary;
            _content = content;
            
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

- (NSDate *)publishedDate {
    return _publishedDate;
}

- (NSString *)summary {
    return _summary;
}

- (NSString *)content {
    return _content;
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_publishedDate forKey:NSStringFromSelector(@selector(publishedDate))];
    [coder encodeObject:_summary forKey:NSStringFromSelector(@selector(summary))];
    [coder encodeObject:_content forKey:NSStringFromSelector(@selector(content))];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
    self = [super init];
    
    if (self) {
        _publishedDate = [decoder decodeObjectForKey:NSStringFromSelector(@selector(publishedDate))];
        _summary = [decoder decodeObjectForKey:NSStringFromSelector(@selector(summary))];
        _content = [decoder decodeObjectForKey:NSStringFromSelector(@selector(content))];
    }
    
    return self;
}

@end
