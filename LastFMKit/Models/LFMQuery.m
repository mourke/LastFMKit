//
//  LFMQuery.m
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

#import "LFMQuery.h"
#import "LFMKit+Protected.h"

@implementation LFMQuery {
    NSInteger _currentPage;
    NSInteger _totalResults;
    NSInteger _itemsPerPage;
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    if (dictionary != nil &&
        [dictionary isKindOfClass:NSDictionary.class]) {
        id currentPage = [dictionary objectForKey:@"page"];
        id totalResults = [dictionary objectForKey:@"total"];
        id itemsPerPage = [dictionary objectForKey:@"perPage"];
        
        if (currentPage != nil && [currentPage isKindOfClass:NSString.class] &&
            totalResults != nil && [totalResults isKindOfClass:NSString.class] &&
            itemsPerPage != nil && [itemsPerPage isKindOfClass:NSString.class]) {
            return [self initWithPage:[currentPage integerValue]
                         totalResults:[totalResults integerValue]
                         itemsPerPage:[itemsPerPage integerValue]];
        }
    }
    
    return nil;
}

- (instancetype)initWithPage:(NSInteger)currentPage
                totalResults:(NSInteger)totalResults
                itemsPerPage:(NSInteger)itemsPerPage {
    self = [super init];
    
    if (self) {
        _currentPage = currentPage;
        _totalResults = totalResults;
        _itemsPerPage = itemsPerPage;
        
        return self;
    }
    
    return nil;
}

- (NSInteger)currentPage {
    return _currentPage;
}

- (NSInteger)totalResults {
    return _totalResults;
}

- (NSInteger)itemsPerPage {
    return _itemsPerPage;
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeInteger:_currentPage forKey:NSStringFromSelector(@selector(currentPage))];
    [coder encodeInteger:_totalResults forKey:NSStringFromSelector(@selector(totalResults))];
    [coder encodeInteger:_itemsPerPage forKey:NSStringFromSelector(@selector(itemsPerPage))];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
    self = [super init];
    
    if (self) {
        _currentPage = [decoder decodeIntegerForKey:NSStringFromSelector(@selector(currentPage))];
        _totalResults = [decoder decodeIntegerForKey:NSStringFromSelector(@selector(totalResults))];
        _itemsPerPage = [decoder decodeIntegerForKey:NSStringFromSelector(@selector(itemsPerPage))];
    }
    
    return self;
}

@end
