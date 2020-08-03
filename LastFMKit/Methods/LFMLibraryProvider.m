//
//  LFMLibraryProvider.m
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

#import "LFMLibraryProvider.h"
#import "LFMArtist.h"
#import "LFMError.h"
#import "LFMQuery.h"
#import "LFMKit+Protected.h"
#import "LFMAuth.h"

@implementation LFMLibraryProvider

+ (NSURLSessionDataTask *)getArtistsForUsername:(NSString *)username
                                    itemsPerPage:(nullable NSNumber *)limit
                                          onPage:(nullable NSNumber *)page
                                        callback:(LFMArtistPaginatedCallback)block {
    NSParameterAssert(block);
    if (page) {
        NSAssert(page.unsignedIntValue <= 10000 && page.unsignedIntValue > 0, @"Page must be between 1 and 10,000");
    } else {
        page = @1;
    }
    
    if (limit) {
        NSAssert(limit.unsignedIntValue <= 10000 && limit.unsignedIntValue > 0, @"Limit must be between 1 and 10,000");
    } else {
        limit = @30;
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"library.getArtists"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%u", limit.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%u", page.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(@[], nil, error);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (responseDictionary) {
            responseDictionary = [responseDictionary objectForKey:@"artists"];
        }
        
        LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[responseDictionary objectForKey:@"@attr"]];
        
        NSMutableArray <LFMArtist *> *artists = [NSMutableArray array];
        
        for (NSDictionary *artistDictionary in [responseDictionary objectForKey:@"artist"]) {
            LFMArtist *artist = [[LFMArtist alloc] initFromDictionary:artistDictionary];
            if (artist) [artists addObject:artist];
        }
        
        block(artists, query, error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

@end
