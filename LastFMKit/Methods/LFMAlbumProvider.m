//
//  LFMAlbumProvider.m
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
                         byArtist:(NSString *)albumArtist
                         callback:(void (^)(NSError * _Nullable))block {
    NSAssert(tags.count <= 10, @"This method call accepts a maximum of 10 tags.");
    
    NSMutableString *tagString = [NSMutableString string];
    [tags enumerateObjectsUsingBlock:^(LFMTag * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tagString appendFormat:@"%@%@", (idx == 0 ? @"" : @","), obj.name];
    }];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"album.addTags"],
                            [NSURLQueryItem queryItemWithName:@"album" value:albumName],
                            [NSURLQueryItem queryItemWithName:@"artist" value:albumArtist],
                            [NSURLQueryItem queryItemWithName:@"tags" value:tagString],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey],
                            [NSURLQueryItem queryItemWithName:@"sk" value:[LFMSession sharedSession].sessionKey]];
    components.queryItems = [[LFMAuth sharedInstance] appendingSignatureItemToQueryItems:queryItems];
    
    NSData *data = [components.query dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (block == nil) return;
        if (error != nil || data == nil) return block(error);
        
        lfm_error_validate(data, &error);
        
        block(error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)removeTag:(LFMTag *)tag
                     fromAlbumNamed:(NSString *)albumName
                           byArtist:(NSString *)albumArtist
                           callback:(void (^)(NSError * _Nullable))block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"album.removeTag"],
                            [NSURLQueryItem queryItemWithName:@"album" value:albumName],
                            [NSURLQueryItem queryItemWithName:@"artist" value:albumArtist],
                            [NSURLQueryItem queryItemWithName:@"tag" value:tag.name],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey],
                            [NSURLQueryItem queryItemWithName:@"sk" value:[LFMSession sharedSession].sessionKey]];
    components.queryItems = [[LFMAuth sharedInstance] appendingSignatureItemToQueryItems:queryItems];

    NSData *data = [components.query dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (block == nil) return;
        if (error != nil || data == nil) return block(error);
        
        lfm_error_validate(data, &error);
        
        block(error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getInfoOnAlbumNamed:(NSString *)albumName
                                     byArtist:(NSString *)albumArtist
                            withMusicBrainzId:(NSString *)mbid
                                  autoCorrect:(BOOL)autoCorrect
                                      forUser:(NSString *)userName
                                 languageCode:(NSString *)code
                                     callback:(void (^)(NSError * _Nullable, LFMAlbum * _Nullable))block {
    NSAssert((albumName != nil && albumArtist != nil) || (mbid != nil), @"Either the albumName and the albumArtist or the mbid parameter must be set.");
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"album.getInfo"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"album" value:albumName],
                            [NSURLQueryItem queryItemWithName:@"artist" value:albumArtist],
                            [NSURLQueryItem queryItemWithName:@"mbid" value:mbid],
                            [NSURLQueryItem queryItemWithName:@"autocorrect" value:[NSString stringWithFormat:@"%d", autoCorrect]],
                            [NSURLQueryItem queryItemWithName:@"username" value:userName],
                            [NSURLQueryItem queryItemWithName:@"lang" value:code],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || data == nil || !lfm_error_validate(data, &error)) return block(error, nil);
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:[responseDictionary objectForKey:@"album"]];
        
        block(error, album);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTagsForAlbumNamed:(NSString *)albumName
                                      byArtist:(NSString *)albumArtist
                             withMusicBrainzId:(NSString *)mbid
                                   autoCorrect:(BOOL)autoCorrect
                                       forUser:(NSString *)userName
                                      callback:(void (^)(NSError * _Nullable, NSArray<LFMTag *> * _Nonnull))block {
    NSAssert([LFMSession sharedSession].sessionKey != nil || userName != nil, @"The user either: must be authenticated, or the `userName` parameter must be set.");
    
    NSAssert((albumName != nil && albumArtist != nil) || (mbid != nil), @"Either the albumName and the albumArtist or the mbid parameter must be set.");
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"album.getTags"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"album" value:albumName],
                            [NSURLQueryItem queryItemWithName:@"artist" value:albumArtist],
                            [NSURLQueryItem queryItemWithName:@"mbid" value:mbid],
                            [NSURLQueryItem queryItemWithName:@"autocorrect" value:[NSString stringWithFormat:@"%d", autoCorrect]],
                            [NSURLQueryItem queryItemWithName:@"user" value:userName],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey],
                            [NSURLQueryItem queryItemWithName:@"sk" value:[LFMSession sharedSession].sessionKey]];
    
    components.queryItems = [LFMSession sharedSession].sessionKey == nil ? queryItems : [[LFMAuth sharedInstance] appendingSignatureItemToQueryItems:queryItems];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || data == nil || !lfm_error_validate(data, &error)) return block(error, @[]);
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSMutableArray <LFMTag *> *tags = [NSMutableArray array];
        
        for (NSDictionary *tagDictionary in [responseDictionary objectForKey:@"tags"]) {
            LFMTag *tag = [[LFMTag alloc] initFromDictionary:tagDictionary];
            tag == nil ?: [tags addObject:tag];
        }
        
        block(error, tags);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTopTagsForAlbumNamed:(NSString *)albumName
                                         byArtist:(NSString *)albumArtist
                                withMusicBrainzId:(NSString *)mbid
                                      autoCorrect:(BOOL)autoCorrect
                                         callback:(void (^)(NSError * _Nullable, NSArray<LFMTopTag *> * _Nonnull))block {
    NSAssert((albumName != nil && albumArtist != nil) || (mbid != nil), @"Either the albumName and the albumArtist or the mbid parameter must be set.");
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
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
        if (error != nil || data == nil || !lfm_error_validate(data, &error)) return block(error, @[]);
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSMutableArray <LFMTopTag *> *tags = [NSMutableArray array];
        
        for (NSDictionary *tagDictionary in [[responseDictionary objectForKey:@"toptags"] objectForKey:@"tag"]) {
            LFMTopTag *tag = [[LFMTopTag alloc] initFromDictionary:tagDictionary];
            tag == nil ?: [tags addObject:tag];
        }
        
        block(error, tags);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)searchForAlbumNamed:(NSString *)albumName
                                 itemsPerPage:(unsigned int)limit
                                       onPage:(unsigned int)page
                                     callback:(void (^)(NSError * _Nullable, NSArray<LFMAlbum *> * _Nonnull, LFMSearchQuery * _Nullable))block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"album.search"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"album" value:albumName],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%d", limit]],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%d", page]],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || data == nil || !lfm_error_validate(data, &error)) return block(error, @[], nil);
        
        NSDictionary *responseDictionary = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error] objectForKey:@"results"];
        
        LFMSearchQuery *searchQuery = [[LFMSearchQuery alloc] initFromDictionary:responseDictionary];
        
        NSMutableArray <LFMAlbum *> *albums = [NSMutableArray array];
        
        for (NSDictionary *albumDictionary in [[responseDictionary objectForKey:@"albummatches"] objectForKey:@"album"]) {
            LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:albumDictionary];
            album == nil ?: [albums addObject:album];
        }
        
        block(error, albums, searchQuery);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

@end
