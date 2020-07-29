//
//  LFMChartProvider.m
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

#import "LFMChartProvider.h"
#import "LFMArtist.h"
#import "LFMAuth.h"
#import "LFMQuery.h"
#import "LFMKit+Protected.h"
#import "LFMError.h"

@implementation LFMChartProvider

+ (NSURLSessionDataTask *)getTopArtistsOnPage:(NSUInteger)page
                                 itemsPerPage:(NSUInteger)limit
                                     callback:(void (^)(NSError * _Nullable, NSArray<LFMArtist *> * _Nonnull, LFMQuery * _Nullable))block {
    NSAssert(page <= 10000 && page > 0, @"Page must be between 1 and 10,000");
    NSAssert(limit <= 10000 && limit > 0, @"Limit must be between 1 and 10,000");
    NSParameterAssert(block);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"chart.getTopArtists"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%tu", limit]],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%tu", page]],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(error, @[], nil);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSMutableArray <LFMArtist *> *artists = [NSMutableArray array];
        
        id artistsDictionary = [responseDictionary objectForKey:@"artists"];
        if (artistsDictionary != nil &&
            [artistsDictionary isKindOfClass:NSDictionary.class]) {
            LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[(NSDictionary *)artistsDictionary objectForKey:@"@attr"]];
            
            id artistArray = [(NSDictionary *)artistsDictionary objectForKey:@"artist"];
            if (artistArray != nil && [artistArray isKindOfClass:NSArray.class]) {
                for (NSDictionary *artistDictionary in artistArray) {
                    LFMArtist *artist = [[LFMArtist alloc] initFromDictionary:artistDictionary];
                    if (artist) [artists addObject:artist];
                }
            }
            
            block(error, artists, query);
        } else {
            block(error, artists, nil);
        }
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTopArtistsWithCallback:(void(^)(NSError * _Nullable,
                                                             NSArray<LFMArtist *> *,
                                                             LFMQuery * _Nullable))block {
    return [self getTopArtistsOnPage:1
                        itemsPerPage:30
                            callback:block];
}

+ (NSURLSessionDataTask *)getTopArtistsOnPage:(NSUInteger)page
                                     callback:(void(^)(NSError * _Nullable, NSArray<LFMArtist *> *, LFMQuery * _Nullable))block {
    return [self getTopArtistsOnPage:page
                        itemsPerPage:30
                            callback:block];
}

+ (NSURLSessionDataTask *)getTopArtistsWithLimit:(NSUInteger)limit
                                        callback:(void(^)(NSError * _Nullable, NSArray<LFMArtist *> *, LFMQuery * _Nullable))block {
    return [self getTopArtistsOnPage:1
                        itemsPerPage:limit
                            callback:block];
}

+ (NSURLSessionDataTask *)getTopTagsOnPage:(NSUInteger)page
                              itemsPerPage:(NSUInteger)limit
                                  callback:(void (^)(NSError * _Nullable, NSArray<LFMTag *> * _Nonnull, LFMQuery * _Nullable))block {
    NSAssert(page <= 10000 && page > 0, @"Page must be between 1 and 10,000");
    NSAssert(limit <= 10000 && limit > 0, @"Limit must be between 1 and 10,000");
    NSParameterAssert(block);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"chart.getTopTags"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%tu", limit]],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%tu", page]],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(error, @[], nil);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSMutableArray <LFMTag *> *tags = [NSMutableArray array];
        
        id tagsDictionary = [responseDictionary objectForKey:@"tags"];
        if (tagsDictionary != nil &&
            [tagsDictionary isKindOfClass:NSDictionary.class]) {
            LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[(NSDictionary *)tagsDictionary objectForKey:@"@attr"]];
            
            id tagArray = [(NSDictionary *)tagsDictionary objectForKey:@"tag"];
            if (tagArray != nil && [tagArray isKindOfClass:NSArray.class]) {
                for (NSDictionary *tagDictionary in tagArray) {
                    LFMTag *tag = [[LFMTag alloc] initFromDictionary:tagDictionary];
                    if (tag) [tags addObject:tag];
                }
            }
            
            block(error, tags, query);
        } else {
            block(error, tags, nil);
        }
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTopTagsWithCallback:(void(^)(NSError * _Nullable,
                                                          NSArray<LFMTag *> *,
                                                          LFMQuery * _Nullable))block {
    return [self getTopTagsOnPage:1
                     itemsPerPage:30
                         callback:block];
}

+ (NSURLSessionDataTask *)getTopTagsOnPage:(NSUInteger)page
                                  callback:(void(^)(NSError * _Nullable, NSArray<LFMTag *> *, LFMQuery * _Nullable))block {
    return [self getTopTagsOnPage:page
                     itemsPerPage:30
                         callback:block];
}

+ (NSURLSessionDataTask *)getTopTagWithLimit:(NSUInteger)limit
                                    callback:(void(^)(NSError * _Nullable, NSArray<LFMTag *> *, LFMQuery * _Nullable))block {
    return [self getTopTagsOnPage:1
                     itemsPerPage:limit
                         callback:block];
}

+ (NSURLSessionDataTask *)getTopTracksOnPage:(NSUInteger)page
                                itemsPerPage:(NSUInteger)limit
                                    callback:(void (^)(NSError * _Nullable, NSArray<LFMTrack *> * _Nonnull, LFMQuery * _Nullable))block {
    NSAssert(page <= 10000 && page > 0, @"Page must be between 1 and 10,000");
    NSAssert(limit <= 10000 && limit > 0, @"Limit must be between 1 and 10,000");
    NSParameterAssert(block);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"chart.getTopTracks"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%tu", limit]],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%tu", page]],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(error, @[], nil);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSMutableArray <LFMTrack *> *tracks = [NSMutableArray array];
        
        id tracksDictionary = [responseDictionary objectForKey:@"tracks"];
        if (tracksDictionary != nil &&
            [tracksDictionary isKindOfClass:NSDictionary.class]) {
            LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[(NSDictionary *)tracksDictionary objectForKey:@"@attr"]];
            
            id trackArray = [(NSDictionary *)tracksDictionary objectForKey:@"track"];
            if (trackArray != nil && [trackArray isKindOfClass:NSArray.class]) {
                for (NSDictionary *trackDictionary in trackArray) {
                    LFMTrack *track = [[LFMTrack alloc] initFromDictionary:trackDictionary];
                    if (track) [tracks addObject:track];
                }
            }
            
            block(error, tracks, query);
        } else {
            block(error, tracks, nil);
        }
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTopTracksWithCallback:(void(^)(NSError * _Nullable,
                                                            NSArray<LFMTrack *> *,
                                                            LFMQuery * _Nullable))block {
    return [self getTopTracksOnPage:1
                       itemsPerPage:30
                           callback:block];
}

+ (NSURLSessionDataTask *)getTopTracksOnPage:(NSUInteger)page
                                    callback:(void(^)(NSError * _Nullable,
                                                      NSArray<LFMTrack *> *,
                                                      LFMQuery * _Nullable))block {
    return [self getTopTracksOnPage:page
                       itemsPerPage:30
                           callback:block];
}

+ (NSURLSessionDataTask *)getTopTracksWithLimit:(NSUInteger)limit
                                       callback:(void(^)(NSError * _Nullable, NSArray<LFMTrack *> *, LFMQuery * _Nullable))block {
    return [self getTopTracksOnPage:1
                       itemsPerPage:limit
                           callback:block];
}

@end
