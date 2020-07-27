//
//  LFMSearchQuery.m
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

#import "LFMSearchQuery.h"
#import "LFMKit+Protected.h"

@implementation LFMSearchQuery {
    NSString *_searchQuery;
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    if (dictionary == nil || ![dictionary isKindOfClass:NSDictionary.class]) return nil;
    
    id queryDictionary = [dictionary objectForKey:@"opensearch:Query"];
    if (queryDictionary != nil &&
        [queryDictionary isKindOfClass:NSDictionary.class]) {
        id searchQuery = [(NSDictionary *)queryDictionary objectForKey:@"searchTerms"];
        id currentPage = [(NSDictionary *)queryDictionary objectForKey:@"startPage"];
        if (searchQuery != nil && [searchQuery isKindOfClass:NSString.class] &&
            currentPage != nil && [currentPage isKindOfClass:NSString.class]) {
            id totalResults = [dictionary objectForKey:@"opensearch:totalResults"];
            id itemsPerPage = [dictionary objectForKey:@"opensearch:itemsPerPage"];
            
            if (totalResults != nil && [totalResults isKindOfClass:NSString.class] &&
                itemsPerPage != nil && [itemsPerPage isKindOfClass:NSString.class]) {
                self = [super initWithPage:[currentPage unsignedIntegerValue]
                              totalResults:[totalResults unsignedIntegerValue]
                              itemsPerPage:[itemsPerPage unsignedIntegerValue]];
                
                if (self) {
                    _searchQuery = searchQuery;
                    return self;
                }
            }
        }
    }
    
    return nil;
}

- (NSString *)searchQuery {
    return _searchQuery;
}

@end
