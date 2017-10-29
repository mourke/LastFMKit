//
//  LFMQuery.m
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

#import "LFMQuery.h"
#import "LFMKit+Protected.h"

@implementation LFMQuery {
    NSUInteger _currentPage;
    NSUInteger _totalResults;
    NSUInteger _itemsPerPage;
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    NSUInteger currentPage = [[dictionary objectForKey:@"page"] unsignedIntegerValue];
    NSUInteger totalResults = [[dictionary objectForKey:@"total"] unsignedIntegerValue];
    NSUInteger itemsPerPage = [[dictionary objectForKey:@"perPage"] unsignedIntegerValue];
    
    return [[LFMQuery alloc] initWithPage:currentPage totalResults:totalResults itemsPerPage:itemsPerPage];
}

- (instancetype)initWithPage:(NSUInteger)currentPage
                totalResults:(NSUInteger)totalResults
                itemsPerPage:(NSUInteger)itemsPerPage {
    self = [super init];
    if (self &&
        !isnan(currentPage) &&
        !isnan(totalResults) &&
        !isnan(itemsPerPage))
    {
        _currentPage = currentPage;
        _totalResults = totalResults;
        _itemsPerPage = itemsPerPage;
        
        return self;
    }
    
    return nil;
}

- (NSUInteger)currentPage {
    return _currentPage;
}

- (NSUInteger)totalResults {
    return _totalResults;
}

- (NSUInteger)itemsPerPage {
    return _itemsPerPage;
}

@end
