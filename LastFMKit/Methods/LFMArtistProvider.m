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
    NSAssert(tags.count <= 10, @"This method call accepts a maximum of 10 tags.");
    
    NSMutableString *tagString = [NSMutableString string];
    [tags enumerateObjectsUsingBlock:^(LFMTag * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tagString appendFormat:@"%@%@", (idx == 0 ? @"" : @","), obj.name];
    }];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
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
                    fromArtistNamed:(NSString *)artistName
                           callback:(void (^)(NSError * _Nullable))block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
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

+ (NSURLSessionDataTask *)getCorrectionForMisspeltArtistName:(NSString *)artistName
                                                    callback:(void (^)(NSError * _Nullable, LFMArtist * _Nullable))block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"artist.getCorrection"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (block == nil) return;
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(error, nil);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if ((responseDictionary = [responseDictionary objectForKey:@"corrections"])) {
            responseDictionary = [responseDictionary objectForKey:@"correction"];
        }
        
        LFMArtist *artist = [[LFMArtist alloc] initFromDictionary:[responseDictionary objectForKey:@"artist"]];
        
        block(error, artist);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getInfoOnArtistNamed:(NSString *)artistName
                             withMusicBrainzId:(NSString *)mbid
                                   autoCorrect:(BOOL)autoCorrect
                                       forUser:(NSString *)username
                                  languageCode:(NSString *)code
                                      callback:(void (^)(NSError * _Nullable, LFMArtist * _Nullable))block {
    NSAssert(artistName != nil || mbid != nil, @"Either the artistName or the mbid parameter must be set.");
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
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
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
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
                                        forUser:(NSString *)username
                                       callback:(void (^)(NSError * _Nullable, NSArray<LFMTag *> * _Nonnull))block {
    NSAssert([LFMSession sharedSession].sessionKey != nil || username != nil, @"The user either: must be authenticated, or the `username` parameter must be set.");
    
    NSAssert(artistName != nil || mbid != nil, @"Either the artistName or the mbid parameter must be set.");
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"artist.getTags"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"mbid" value:mbid],
                            [NSURLQueryItem queryItemWithName:@"autocorrect" value:[NSString stringWithFormat:@"%d", autoCorrect]],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey],
                            [NSURLQueryItem queryItemWithName:@"sk" value:[LFMSession sharedSession].sessionKey]];
    
    components.queryItems = [LFMSession sharedSession].sessionKey == nil ? queryItems : [[LFMAuth sharedInstance] appendingSignatureItemToQueryItems:queryItems];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(error, @[]);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (responseDictionary) {
            responseDictionary = [responseDictionary objectForKey:@"tags"];
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

+ (NSURLSessionDataTask *)getTopAlbumsForArtistNamed:(NSString *)artistName
                                   withMusicBrainzId:(NSString *)mbid
                                         autoCorrect:(BOOL)autoCorrect
                                        itemsPerPage:(NSUInteger)limit
                                              onPage:(NSUInteger)page
                                            callback:(void (^)(NSError * _Nullable, NSArray<LFMAlbum *> * _Nonnull, LFMQuery * _Nullable))block {
    NSAssert(artistName != nil || mbid != nil, @"Either the artistName or the mbid parameter must be set.");
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
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
        
        if (responseDictionary) {
            responseDictionary = [responseDictionary objectForKey:@"topalbums"];
        }
        
        NSMutableArray<LFMAlbum *> *albums = [NSMutableArray array];
        
        for (NSDictionary *albumDictionary in [responseDictionary objectForKey:@"album"]) {
            LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:albumDictionary];
            if (album) [albums addObject:album];
        }
        
        LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[responseDictionary objectForKey:@"@attr"]];
        
        block(error, albums, query);
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
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
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
        
        if (responseDictionary) {
            responseDictionary = [responseDictionary objectForKey:@"toptracks"];
        }
        
        NSMutableArray<LFMTrack *> *tracks = [NSMutableArray array];
        
        for (NSDictionary *trackDictionary in [responseDictionary objectForKey:@"track"]) {
            LFMTrack *track = [[LFMTrack alloc] initFromDictionary:trackDictionary];
            if (track) [tracks addObject:track];
        }
        
        LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[responseDictionary objectForKey:@"@attr"]];
        
        block(error, tracks, query);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTopTagsForArtistNamed:(NSString *)artistName
                                 withMusicBrainzId:(NSString *)mbid
                                       autoCorrect:(BOOL)autoCorrect
                                          callback:(void (^)(NSError * _Nullable, NSArray <LFMTopTag *> * _Nonnull))block {
    NSAssert(artistName != nil || mbid != nil, @"Either the artistName or the mbid parameter must be set.");
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
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
        
        if (responseDictionary) {
            responseDictionary = [responseDictionary objectForKey:@"toptags"];
        }
        
        NSMutableArray <LFMTopTag *> *tags = [NSMutableArray array];
        
        for (NSDictionary *tagDictionary in [responseDictionary objectForKey:@"tag"]) {
            LFMTopTag *tag = [[LFMTopTag alloc] initFromDictionary:tagDictionary];
            if (tag) [tags addObject:tag];
        }
        
        block(error, tags);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)searchForArtistNamed:(NSString *)artistName
                                  itemsPerPage:(NSUInteger)limit
                                        onPage:(NSUInteger)page
                                      callback:(void (^)(NSError * _Nullable, NSArray <LFMArtist *> * _Nonnull, LFMSearchQuery * _Nullable))block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
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
        
        if (responseDictionary) {
            responseDictionary = [responseDictionary objectForKey:@"results"];
        }
        
        LFMSearchQuery *searchQuery = [[LFMSearchQuery alloc] initFromDictionary:responseDictionary];
        
        NSMutableArray <LFMArtist *> *artists = [NSMutableArray array];
        
        NSDictionary *artistMatchesDictionary = [responseDictionary objectForKey:@"artistmatches"];
        
        for (NSDictionary *artistDictionary in [artistMatchesDictionary objectForKey:@"artist"]) {
            LFMArtist *artist = [[LFMArtist alloc] initFromDictionary:artistDictionary];
            if (artist) [artists addObject:artist];
        }
        
        block(error, artists, searchQuery);
    }];
    
    [dataTask resume];
    
    return dataTask;
}


@end
