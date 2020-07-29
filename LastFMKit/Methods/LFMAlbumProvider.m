//
//  LFMAlbumProvider.m
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

#import "LFMAlbumProvider.h"
#import "LFMTag.h"
#import "LFMAuth.h"
#import "LFMSession.h"
#import "LFMError.h"
#import "LFMAlbum.h"
#import "LFMKit+Protected.h"
#import "LFMTopTag.h"
#import "LFMSearchQuery.h"

@implementation LFMAlbumProvider

+ (NSURLSessionDataTask *)addTags:(NSArray<LFMTag *> *)tags
                     toAlbumNamed:(NSString *)albumName
                    byArtistNamed:(NSString *)albumArtist
                         callback:(void (^)(NSError * _Nullable))block {
    NSParameterAssert(tags);
    NSParameterAssert(albumName);
    NSParameterAssert(albumArtist);
    NSAssert(tags.count <= 10, @"This method call accepts a maximum of 10 tags.");
    NSAssert([LFMSession sharedSession].sessionKey != nil, @"This method requires user authentication");
    
    NSMutableString *tagString = [NSMutableString string];
    [tags enumerateObjectsUsingBlock:^(LFMTag * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tagString appendFormat:@"%@%@", (idx == 0 ? @"" : @","), obj.name];
    }];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"album.addTags"],
                            [NSURLQueryItem queryItemWithName:@"album" value:albumName],
                            [NSURLQueryItem queryItemWithName:@"artist" value:albumArtist],
                            [NSURLQueryItem queryItemWithName:@"tags" value:tagString],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey],
                            [NSURLQueryItem queryItemWithName:@"sk" value:[LFMSession sharedSession].sessionKey]];
    components.queryItems = [[LFMAuth sharedInstance] appendingSignatureItemToQueryItems:queryItems];
    
    NSData *data = [components.percentEncodedQuery dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (block == nil) return;
        if (error != nil || data == nil) {
            block(error);
            return;
        }
        
        lfm_error_validate(data, &error);
        
        block(error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)removeTag:(LFMTag *)tag
                     fromAlbumNamed:(NSString *)albumName
                      byArtistNamed:(NSString *)albumArtist
                           callback:(void (^)(NSError * _Nullable))block {
    NSParameterAssert(tag);
    NSParameterAssert(albumName);
    NSParameterAssert(albumArtist);
    NSAssert([LFMSession sharedSession].sessionKey != nil, @"This method requires user authentication");
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"album.removeTag"],
                            [NSURLQueryItem queryItemWithName:@"album" value:albumName],
                            [NSURLQueryItem queryItemWithName:@"artist" value:albumArtist],
                            [NSURLQueryItem queryItemWithName:@"tag" value:tag.name],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey],
                            [NSURLQueryItem queryItemWithName:@"sk" value:[LFMSession sharedSession].sessionKey]];
    components.queryItems = [[LFMAuth sharedInstance] appendingSignatureItemToQueryItems:queryItems];

    NSData *data = [components.percentEncodedQuery dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (block == nil) return;
        if (error != nil || data == nil) {
            block(error);
            return;
        }
        
        lfm_error_validate(data, &error);
        
        block(error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getInfoOnAlbumNamed:(NSString *)albumName
                                byArtistNamed:(NSString *)albumArtist
                                    albumMBID:(NSString *)mbid
                                  autoCorrect:(BOOL)autoCorrect
                                  forUsername:(NSString *)username
                                 languageCode:(NSString *)code
                                     callback:(void (^)(NSError * _Nullable, LFMAlbum * _Nullable))block {
    NSParameterAssert(block);
    NSAssert((albumName != nil && albumArtist != nil) || (mbid != nil), @"Either the albumName and the albumArtist or the mbid parameter must be set.");
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSMutableArray *queryItems = [NSMutableArray arrayWithArray:@[[NSURLQueryItem queryItemWithName:@"method" value:@"album.getInfo"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"album" value:albumName],
                            [NSURLQueryItem queryItemWithName:@"artist" value:albumArtist],
                            [NSURLQueryItem queryItemWithName:@"mbid" value:mbid],
                            [NSURLQueryItem queryItemWithName:@"autocorrect" value:[NSString stringWithFormat:@"%d", autoCorrect]],
                            [NSURLQueryItem queryItemWithName:@"lang" value:code],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]]];
    if (username != nil) { // API breaks if we do this like the other ones. This is a workaround until it's fixed on the API side which will probably be never.
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"username" value:username]];
    }
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(error, nil);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:[responseDictionary objectForKey:@"album"]];
        
        block(error, album);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTagsForAlbumNamed:(NSString *)albumName
                                 byArtistNamed:(NSString *)albumArtist
                             withMusicBrainzId:(NSString *)mbid
                                   autoCorrect:(BOOL)autoCorrect
                                   forUsername:(NSString *)username
                                      callback:(void (^)(NSError * _Nullable, NSArray<LFMTag *> * _Nonnull))block {
    NSAssert([LFMSession sharedSession].sessionKey != nil || username != nil, @"The user either: must be authenticated, or the `username` parameter must be set.");
    NSParameterAssert(block);
    NSAssert((albumName != nil && albumArtist != nil) || (mbid != nil), @"Either the albumName and the albumArtist or the mbid parameter must be set.");
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSMutableArray *queryItems = [NSMutableArray arrayWithArray:@[[NSURLQueryItem queryItemWithName:@"method" value:@"album.getTags"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"album" value:albumName],
                            [NSURLQueryItem queryItemWithName:@"artist" value:albumArtist],
                            [NSURLQueryItem queryItemWithName:@"mbid" value:mbid],
                            [NSURLQueryItem queryItemWithName:@"autocorrect" value:[NSString stringWithFormat:@"%d", autoCorrect]],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]]];
    
    if (username) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"user" value:username]];
    } else {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"sk" value:[LFMSession sharedSession].sessionKey]];
        [queryItems addObject:[[LFMAuth sharedInstance] signatureItemForQueryItems:queryItems]];
    }
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(error, @[]);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSMutableArray <LFMTag *> *tags = [NSMutableArray array];
        
        id tagsDictionary = [responseDictionary objectForKey:@"tags"];
        if (tagsDictionary != nil && [tagsDictionary isKindOfClass:NSDictionary.class]) {
            id tagArray = [(NSDictionary *)tagsDictionary objectForKey:@"tag"];
            if (tagArray != nil && [tagArray isKindOfClass:NSArray.class]) {
                for (NSDictionary *tagDictionary in tagArray) {
                    LFMTag *tag = [[LFMTag alloc] initFromDictionary:tagDictionary];
                    if (tag) [tags addObject:tag];
                }
            }
        }
        
        block(error, tags);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTopTagsForAlbumNamed:(NSString *)albumName
                                    byArtistNamed:(NSString *)albumArtist
                                withMusicBrainzId:(NSString *)mbid
                                      autoCorrect:(BOOL)autoCorrect
                                         callback:(void (^)(NSError * _Nullable, NSArray<LFMTopTag *> * _Nonnull))block {
    NSAssert((albumName != nil && albumArtist != nil) || (mbid != nil), @"Either the albumName and the albumArtist or the mbid parameter must be set.");
    NSParameterAssert(block);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"album.getTopTags"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"album" value:albumName],
                            [NSURLQueryItem queryItemWithName:@"artist" value:albumArtist],
                            [NSURLQueryItem queryItemWithName:@"mbid" value:mbid],
                            [NSURLQueryItem queryItemWithName:@"autocorrect" value:[NSString stringWithFormat:@"%d", autoCorrect]],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(error, @[]);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSMutableArray <LFMTopTag *> *tags = [NSMutableArray array];
        
        id topTagsDictionary = [responseDictionary objectForKey:@"toptags"];
        if (topTagsDictionary != nil &&
            [topTagsDictionary isKindOfClass:NSDictionary.class]) {
            id tagArray = [(NSDictionary *)topTagsDictionary objectForKey:@"tag"];
            if (tagArray != nil && [tagArray isKindOfClass:NSArray.class]) {
                for (NSDictionary *tagDictionary in tagArray) {
                    LFMTopTag *tag = [[LFMTopTag alloc] initFromDictionary:tagDictionary];
                    if (tag) [tags addObject:tag];
                }
            }
        }
        
        block(error, tags);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)searchForAlbumNamed:(NSString *)albumName
                                 itemsPerPage:(NSUInteger)limit
                                       onPage:(NSUInteger)page
                                     callback:(void (^)(NSError * _Nullable, NSArray<LFMAlbum *> * _Nonnull, LFMSearchQuery * _Nullable))block {
    NSAssert(page <= 10000 && page > 0, @"Page must be between 1 and 10,000");
    NSAssert(limit <= 10000 && limit > 0, @"Limit must be between 1 and 10,000");
    NSParameterAssert(albumName);
    NSParameterAssert(block);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"album.search"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"album" value:albumName],
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
        
        id resultsDictionary = [responseDictionary objectForKey:@"results"];
        if (resultsDictionary != nil &&
            [resultsDictionary isKindOfClass:NSDictionary.class]) {
            LFMSearchQuery *searchQuery = [[LFMSearchQuery alloc] initFromDictionary:resultsDictionary];
            
            NSMutableArray <LFMAlbum *> *albums = [NSMutableArray array];
            
            id albumMatchDictionary = [(NSDictionary *)resultsDictionary objectForKey:@"albummatches"];
            if (albumMatchDictionary != nil &&
                [albumMatchDictionary isKindOfClass:NSDictionary.class]) {
                id albumArray = [(NSDictionary *)albumMatchDictionary objectForKey:@"album"];
                if (albumArray != nil &&
                    [albumArray isKindOfClass:NSArray.class]) {
                    for (NSDictionary *albumDictionary in albumArray) {
                        LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:albumDictionary];
                        if (album) [albums addObject:album];
                    }
                }
            }
            
            block(error, albums, searchQuery);
        } else {
            block(error, @[], nil);
        }
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)searchForAlbumNamed:(NSString *)albumName
                                     callback:(void (^)(NSError * _Nullable,
                                                        NSArray <LFMAlbum *> *,
                                                        LFMSearchQuery * _Nullable))block {
    return [self searchForAlbumNamed:albumName
                        itemsPerPage:30
                              onPage:1
                            callback:block];
}

+ (NSURLSessionDataTask *)searchForAlbumNamed:(NSString *)albumName
                                       onPage:(NSUInteger)page
                                     callback:(void (^)(NSError * _Nullable,
                                                        NSArray <LFMAlbum *> *,
                                                        LFMSearchQuery * _Nullable))block {
    return [self searchForAlbumNamed:albumName
                        itemsPerPage:30
                              onPage:page
                            callback:block];
}

+ (NSURLSessionDataTask *)searchForAlbumNamed:(NSString *)albumName
                                 itemsPerPage:(NSUInteger)limit
                                     callback:(void (^)(NSError * _Nullable,
                                                        NSArray <LFMAlbum *> *,
                                                        LFMSearchQuery * _Nullable))block {
    return [self searchForAlbumNamed:albumName
                        itemsPerPage:limit
                              onPage:1
                            callback:block];
}

@end
