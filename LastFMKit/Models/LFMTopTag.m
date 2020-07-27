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
    NSUInteger _count;
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super initFromDictionary:dictionary];
    
    if (self) {
        NSUInteger count = [[dictionary objectForKey:@"count"] unsignedIntegerValue];
        
        if (!isnan(count)) return self;
    }
    
    return nil;
}

- (NSUInteger)count {
    return _count;
}

#pragma mark - Unavailable

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-parameter"

- (instancetype)initWithName:(NSString *)tagName {
    NSAssert(false, @"Top tags should not be created. Please use the `LFMTag` object instead.");
    return nil;
}

+ (instancetype)tagWithName:(NSString *)tagName {
    NSAssert(false, @"Top tags should not be created. Please use the `LFMTag` object instead.");
    return nil;
}

#pragma clang diagnostic pop

@end
