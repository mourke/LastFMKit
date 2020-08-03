//
//  LFMTopTag.m
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

#import "LFMTopTag.h"
#import "LFMKit+Protected.h"

@implementation LFMTopTag {
    NSInteger _count;
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super initFromDictionary:dictionary];
    
    if (self) {
        id count = [dictionary objectForKey:@"count"];
        if (count != nil && [count isKindOfClass:NSNumber.class]) {
            _count = [count integerValue];
            
            return self;
        }
    }
    
    return nil;
}

- (NSInteger)count {
    return _count;
}

#pragma mark - Unavailable

- (instancetype)initWithName:(NSString *)tagName {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (instancetype)tagWithName:(NSString *)tagName {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeInteger:_count forKey:NSStringFromSelector(@selector(count))];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if (self) {
        _count = [decoder decodeIntegerForKey:NSStringFromSelector(@selector(count))];
    }
    
    return self;
}

@end
