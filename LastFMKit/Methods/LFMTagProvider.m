//
//  LFMTagProvider.m
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

#import "LFMTagProvider.h"
#import "LFMTag.h"
#import "LFMKit+Protected.h"
#import "LFMError.h"
#import "LFMAuth.h"

@implementation LFMTagProvider

+ (NSURLSessionDataTask *)getInfoOnTagNamed:(NSString *)tagName
                                   language:(NSString *)language
                                   callback:(void (^)(NSError * _Nullable, LFMTag * _Nullable))block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"tag.getInfo"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"tag" value:tagName],
                            [NSURLQueryItem queryItemWithName:@"lang" value:language],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(error, nil);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        LFMTag *tag = [[LFMTag alloc] initFromDictionary:[responseDictionary objectForKey:@"tag"]];
        
        block(error, tag);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTopTagsWithCallback:(void (^)(NSError * _Nullable, NSArray<LFMTag *> * _Nonnull))block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"tag.getTopTags"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(error, @[]);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (responseDictionary) {
            responseDictionary = [responseDictionary objectForKey:@"toptags"];
        }
        
        NSMutableArray <LFMTag *> *tags = [NSMutableArray array];
        
        for (NSDictionary *tagDictionary in [responseDictionary objectForKey:@"tag"]) {
            LFMTag *tag = [[LFMTag alloc] initFromDictionary:tagDictionary];
            if (tag) [tags addObject:tag];
        }
        
        block(error, tags);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTagsSimilarToTagNamed:(NSString *)tagName
                                          callback:(void (^)(NSError * _Nullable, NSArray<LFMTag *> * _Nonnull))block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"tag.getSimilar"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"tag" value:tagName],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(error, @[]);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if ((responseDictionary = [responseDictionary objectForKey:@"similartags"])) {
            responseDictionary = [responseDictionary objectForKey:@"tag"];
        }
        
        NSMutableArray<LFMTag *> *tags = [NSMutableArray array];
        
        for (NSDictionary *tagDictionary in responseDictionary) {
            LFMTag *tag = [[LFMTag alloc] initFromDictionary:tagDictionary];
            if (tag) [tags addObject:tag];
        }
        
        block(error, tags);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTopAlbumsTaggedByTagNamed:(NSString *)tagName
                                          itemsPerPage:(NSUInteger)limit
                                                onPage:(NSUInteger)page
                                              callback:(void (^)(NSError * _Nullable, NSArray<LFMAlbum *> * _Nonnull, LFMQuery * _Nullable))block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"tag.getTopAlbums"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"tag" value:tagName],
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
        
        if (responseDictionary) {
            responseDictionary = [responseDictionary objectForKey:@"albums"];
        }
        
        LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[responseDictionary objectForKey:@"@attr"]];
        
        NSMutableArray <LFMAlbum *> *albums = [NSMutableArray array];
        
        for (NSDictionary *albumDictionary in [responseDictionary objectForKey:@"album"]) {
            LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:albumDictionary];
            if (album) [albums addObject:album];
        }
        
        block(error, albums, query);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTopArtistsTaggedByTagNamed:(NSString *)tagName
                                           itemsPerPage:(NSUInteger)limit
                                                 onPage:(NSUInteger)page
                                               callback:(void (^)(NSError * _Nullable, NSArray<LFMArtist *> * _Nonnull, LFMQuery * _Nullable))block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"tag.getTopArtists"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"tag" value:tagName],
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
        
        if (responseDictionary) {
            responseDictionary = [responseDictionary objectForKey:@"topartists"];
        }
        
        LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[responseDictionary objectForKey:@"@attr"]];
        
        NSMutableArray <LFMArtist *> *artists = [NSMutableArray array];
        
        for (NSDictionary *artistDictionary in [responseDictionary objectForKey:@"artist"]) {
            LFMArtist *artist = [[LFMArtist alloc] initFromDictionary:artistDictionary];
            if (artist) [artists addObject:artist];
        }
        
        block(error, artists, query);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTopTracksTaggedByTagNamed:(NSString *)tagName
                                          itemsPerPage:(NSUInteger)limit
                                                onPage:(NSUInteger)page
                                              callback:(void (^)(NSError * _Nullable, NSArray<LFMTrack *> * _Nonnull, LFMQuery * _Nullable))block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"tag.getTopTracks"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"tag" value:tagName],
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
        
        if (responseDictionary) {
            responseDictionary = [responseDictionary objectForKey:@"tracks"];
        }
        
        LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[responseDictionary objectForKey:@"@attr"]];
        
        NSMutableArray <LFMTrack *> *tracks = [NSMutableArray array];
        
        for (NSDictionary *trackDictionary in [responseDictionary objectForKey:@"track"]) {
            LFMTrack *track = [[LFMTrack alloc] initFromDictionary:trackDictionary];
            if (track) [tracks addObject:track];
        }
        
        block(error, tracks, query);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

@end
