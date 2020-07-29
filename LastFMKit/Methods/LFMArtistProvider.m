//
//  LFMArtistProvider.m
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

#import "LFMArtistProvider.h"
#import "LFMError.h"
#import "LFMTag.h"
#import "LFMArtist.h"
#import "LFMAuth.h"
#import "LFMSession.h"
#import "LFMKit+Protected.h"
#import "LFMTopTag.h"
#import "LFMSearchQuery.h"

@implementation LFMArtistProvider

+ (NSURLSessionDataTask *)addTags:(NSArray *)tags
                    toArtistNamed:(NSString *)artistName
                         callback:(void (^)(NSError * _Nullable))block {
    NSAssert(tags.count > 0, @"Tags may not be empty");
    NSAssert(tags.count <= 10, @"This method call accepts a maximum of 10 tags.");
    NSParameterAssert(artistName);
    NSAssert([LFMSession sharedSession].sessionKey != nil, @"This method requires user authentication");
    
    NSMutableString *tagString = [NSMutableString string];
    [tags enumerateObjectsUsingBlock:^(LFMTag * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tagString appendFormat:@"%@%@", (idx == 0 ? @"" : @","), obj.name];
    }];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"artist.addTags"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
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
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(error);
            return;
        }
        
        block(nil);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)removeTag:(LFMTag *)tag
                    fromArtistNamed:(NSString *)artistName
                           callback:(void (^)(NSError * _Nullable))block {
    NSParameterAssert(tag);
    NSParameterAssert(artistName);
    NSAssert([LFMSession sharedSession].sessionKey != nil, @"This method requires user authentication");
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"artist.removeTag"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
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
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(error);
            return;
        }
        
        block(nil);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getCorrectionForMisspeltArtistName:(NSString *)artistName
                                                    callback:(void (^)(NSError * _Nullable, LFMArtist * _Nullable))block {
    NSParameterAssert(artistName);
    NSParameterAssert(block);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"artist.getCorrection"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(error, nil);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        id correctionsDictionary = [responseDictionary objectForKey:@"corrections"];
        if (correctionsDictionary != nil &&
            [correctionsDictionary isKindOfClass:NSDictionary.class]) {
            id correctionDictionary = [(NSDictionary *)correctionsDictionary objectForKey:@"correction"];
            if (correctionDictionary != nil &&
                [correctionDictionary isKindOfClass:NSDictionary.class]) {
                LFMArtist *artist = [[LFMArtist alloc] initFromDictionary:[(NSDictionary *)correctionDictionary objectForKey:@"artist"]];
                block(error, artist);
                return;
            }
        }
        
        block(error, nil);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getInfoOnArtistNamed:(NSString *)artistName
                             withMusicBrainzId:(NSString *)mbid
                                   autoCorrect:(BOOL)autoCorrect
                                   forUsername:(NSString *)username
                                  languageCode:(NSString *)code
                                      callback:(void (^)(NSError * _Nullable, LFMArtist * _Nullable))block {
    NSAssert(artistName != nil || mbid != nil, @"Either the artistName or the mbid parameter must be set.");
    NSParameterAssert(block);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"artist.getInfo"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"mbid" value:mbid],
                            [NSURLQueryItem queryItemWithName:@"autocorrect" value:[NSString stringWithFormat:@"%d", autoCorrect]],
                            [NSURLQueryItem queryItemWithName:@"username" value:username],
                            [NSURLQueryItem queryItemWithName:@"lang" value:code],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(error, nil);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        LFMArtist *artist = [[LFMArtist alloc] initFromDictionary:[responseDictionary objectForKey:@"artist"]];
        
        block(error, artist);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getArtistsSimilarToArtistNamed:(NSString *)artistName
                                       withMusicBrainzId:(NSString *)mbid
                                             autoCorrect:(BOOL)autoCorrect
                                                   limit:(NSUInteger)limit
                                                callback:(void (^)(NSError * _Nullable, NSArray<LFMArtist *> * _Nonnull))block {
    NSAssert(artistName != nil || mbid != nil, @"Either the artistName or the mbid parameter must be set.");
    NSAssert(limit <= 10000 && limit > 0, @"Limit must be between 1 and 10,000");
    NSParameterAssert(block);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"artist.getSimilar"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"mbid" value:mbid],
                            [NSURLQueryItem queryItemWithName:@"autocorrect" value:[NSString stringWithFormat:@"%d", autoCorrect]],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%tu", limit]],
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
            responseDictionary = [responseDictionary objectForKey:@"similarartists"];
        }
        
        NSMutableArray<LFMArtist *> *artists = [NSMutableArray array];
        
        for (NSDictionary *artistDictionary in [responseDictionary objectForKey:@"artist"]) {
            LFMArtist *artist = [[LFMArtist alloc] initFromDictionary:artistDictionary];
            if (artist) [artists addObject:artist];
        }
        
        block(error, artists);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTagsForArtistNamed:(NSString *)artistName
                              withMusicBrainzId:(NSString *)mbid
                                    autoCorrect:(BOOL)autoCorrect
                                    forUsername:(NSString *)username
                                       callback:(void (^)(NSError * _Nullable, NSArray<LFMTag *> * _Nonnull))block {
    NSAssert([LFMSession sharedSession].sessionKey != nil || username != nil, @"The user either: must be authenticated, or the `username` parameter must be set.");
    NSAssert(artistName != nil || mbid != nil, @"Either the artistName or the mbid parameter must be set.");
    NSParameterAssert(block);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSMutableArray *queryItems = [NSMutableArray arrayWithArray:@[[NSURLQueryItem queryItemWithName:@"method" value:@"artist.getTags"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
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
        if (tagsDictionary != nil &&
            [tagsDictionary isKindOfClass:NSDictionary.class]) {
            id tagArray = [(NSDictionary *)tagsDictionary objectForKey:@"tag"];
            if (tagArray != nil &&
                [tagArray isKindOfClass:NSArray.class]) {
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

+ (NSURLSessionDataTask *)getTopAlbumsForArtistNamed:(NSString *)artistName
                                   withMusicBrainzId:(NSString *)mbid
                                         autoCorrect:(BOOL)autoCorrect
                                        itemsPerPage:(NSUInteger)limit
                                              onPage:(NSUInteger)page
                                            callback:(void (^)(NSError * _Nullable, NSArray<LFMAlbum *> * _Nonnull, LFMQuery * _Nullable))block {
    NSAssert(artistName != nil || mbid != nil, @"Either the artistName or the mbid parameter must be set.");
    NSAssert(page <= 10000 && page > 0, @"Page must be between 1 and 10,000");
    NSAssert(limit <= 10000 && limit > 0, @"Limit must be between 1 and 10,000");
    NSParameterAssert(block);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"artist.getTopAlbums"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"mbid" value:mbid],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%tu", page]],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%tu", limit]],
                            [NSURLQueryItem queryItemWithName:@"autocorrect" value:[NSString stringWithFormat:@"%d", autoCorrect]],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(error, @[], nil);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSMutableArray<LFMAlbum *> *albums = [NSMutableArray array];
        
        id topAlbumsDictionary = [responseDictionary objectForKey:@"topalbums"];
        if (topAlbumsDictionary != nil &&
            [topAlbumsDictionary isKindOfClass:NSDictionary.class]) {
            LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[(NSDictionary *)topAlbumsDictionary objectForKey:@"@attr"]];
            
            id albumArray = [(NSDictionary *)topAlbumsDictionary objectForKey:@"album"];
            if (albumArray != nil && [albumArray isKindOfClass:NSArray.class]) {
                for (NSDictionary *albumDictionary in albumArray) {
                    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:albumDictionary];
                    if (album) [albums addObject:album];
                }
            }
            
            block(error, albums, query);
        } else {
            block(error, albums, nil);
        }
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTopTracksForArtistNamed:(NSString *)artistName
                                   withMusicBrainzId:(NSString *)mbid
                                         autoCorrect:(BOOL)autoCorrect
                                        itemsPerPage:(NSUInteger)limit
                                              onPage:(NSUInteger)page
                                            callback:(void (^)(NSError * _Nullable, NSArray<LFMTrack *> * _Nonnull, LFMQuery * _Nullable))block {
    NSAssert(artistName != nil || mbid != nil, @"Either the artistName or the mbid parameter must be set.");
    NSAssert(page <= 10000 && page > 0, @"Page must be between 1 and 10,000");
    NSAssert(limit <= 10000 && limit > 0, @"Limit must be between 1 and 10,000");
    NSParameterAssert(block);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"artist.getTopTracks"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"mbid" value:mbid],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%tu", page]],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%tu", limit]],
                            [NSURLQueryItem queryItemWithName:@"autocorrect" value:[NSString stringWithFormat:@"%d", autoCorrect]],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(error, @[], nil);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSMutableArray<LFMTrack *> *tracks = [NSMutableArray array];
        
        id topTracksDictionary = [responseDictionary objectForKey:@"toptracks"];
        if (topTracksDictionary != nil &&
            [topTracksDictionary isKindOfClass:NSDictionary.class]) {
            LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[(NSDictionary *)topTracksDictionary objectForKey:@"@attr"]];
            
            id trackArray = [(NSDictionary *)topTracksDictionary objectForKey:@"track"];
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

+ (NSURLSessionDataTask *)getTopTagsForArtistNamed:(NSString *)artistName
                                 withMusicBrainzId:(NSString *)mbid
                                       autoCorrect:(BOOL)autoCorrect
                                          callback:(void (^)(NSError * _Nullable, NSArray <LFMTopTag *> * _Nonnull))block {
    NSAssert(artistName != nil || mbid != nil, @"Either the artistName or the mbid parameter must be set.");
    NSParameterAssert(block);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"artist.getTopTags"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
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
            
            block(error, tags);
        } else {
            block(error, tags);
        }
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)searchForArtistNamed:(NSString *)artistName
                                  itemsPerPage:(NSUInteger)limit
                                        onPage:(NSUInteger)page
                                      callback:(void (^)(NSError * _Nullable, NSArray <LFMArtist *> * _Nonnull, LFMSearchQuery * _Nullable))block {
    NSParameterAssert(artistName);
    NSAssert(page <= 10000 && page > 0, @"Page must be between 1 and 10,000");
    NSAssert(limit <= 10000 && limit > 0, @"Limit must be between 1 and 10,000");
    NSParameterAssert(block);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"artist.search"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
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
            
            NSMutableArray <LFMArtist *> *artists = [NSMutableArray array];
            
            id artistMatchesDictionary = [(NSDictionary *)resultsDictionary objectForKey:@"artistmatches"];
            if (artistMatchesDictionary != nil &&
                [artistMatchesDictionary isKindOfClass:NSDictionary.class]) {
                id artistArray = [(NSDictionary *)artistMatchesDictionary objectForKey:@"artist"];
                if (artistArray != nil &&
                    [artistArray isKindOfClass:NSArray.class]) {
                    for (NSDictionary *artistDictionary in artistArray) {
                        LFMArtist *artist = [[LFMArtist alloc] initFromDictionary:artistDictionary];
                        if (artist) [artists addObject:artist];
                    }
                }
            }
            
            block(error, artists, searchQuery);
        } else {
            block(error, @[], nil);
        }
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)searchForArtistNamed:(NSString *)artistName
                                        onPage:(NSUInteger)page
                                      callback:(void (^)(NSError * _Nullable, NSArray <LFMArtist *> *, LFMSearchQuery * _Nullable))block {
    return [self searchForArtistNamed:artistName
                         itemsPerPage:30
                               onPage:page
                             callback:block];
}

+ (NSURLSessionDataTask *)searchForArtistNamed:(NSString *)artistName
                                  itemsPerPage:(NSUInteger)limit
                                      callback:(void (^)(NSError * _Nullable, NSArray <LFMArtist *> *, LFMSearchQuery * _Nullable))block {
    return [self searchForArtistNamed:artistName
                         itemsPerPage:limit
                               onPage:1
                             callback:block];
}

+ (NSURLSessionDataTask *)searchForArtistNamed:(NSString *)artistName
                                      callback:(void (^)(NSError * _Nullable, NSArray <LFMArtist *> *, LFMSearchQuery * _Nullable))block {
    return [self searchForArtistNamed:artistName
                         itemsPerPage:30
                               onPage:1
                             callback:block];
}


@end
