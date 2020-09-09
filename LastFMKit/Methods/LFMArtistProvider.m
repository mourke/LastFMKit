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
#import "LFMURLOperation.h"
#import "LFMError.h"
#import "LFMTag.h"
#import "LFMArtist.h"
#import "LFMAuth.h"
#import "LFMSession.h"
#import "LFMKit+Protected.h"
#import "LFMTopTag.h"
#import "LFMSearchQuery.h"

@implementation LFMArtistProvider

+ (LFMURLOperation *)addTags:(NSArray *)tags
                    toArtistNamed:(NSString *)artistName
                         callback:(nullable LFMErrorCallback)block {
    NSAssert(tags.count > 0, @"Tags may not be empty");
    NSAssert(tags.count <= 10, @"This method call accepts a maximum of 10 tags.");
    NSParameterAssert(artistName);
    NSAssert([LFMSession sharedSession].sessionKey != nil, @"This method requires user authentication");
    
    NSMutableString *tagString = [NSMutableString string];
    [tags enumerateObjectsUsingBlock:^(LFMTag * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tagString appendFormat:@"%@%@", (idx == 0 ? @"" : @","), obj.name];
    }];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSArray *queryItems = [@[[NSURLQueryItem queryItemWithName:@"method" value:@"artist.addTags"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"tags" value:tagString],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey],
                            [NSURLQueryItem queryItemWithName:@"sk" value:[LFMSession sharedSession].sessionKey]]
                           filteredArrayUsingPredicate:LFMURLComponentsPredicate];
    components.queryItems = [[LFMAuth sharedInstance] appendingSignatureItemToQueryItems:queryItems];
    
    NSData *data = [components.percentEncodedQuery dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
        if (block == nil) return;
        
        block(error);
    }];
}

+ (LFMURLOperation *)removeTag:(LFMTag *)tag
                    fromArtistNamed:(NSString *)artistName
                           callback:(nullable LFMErrorCallback)block {
    NSParameterAssert(tag);
    NSParameterAssert(artistName);
    NSAssert([LFMSession sharedSession].sessionKey != nil, @"This method requires user authentication");
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSArray *queryItems = [@[[NSURLQueryItem queryItemWithName:@"method" value:@"artist.removeTag"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"tag" value:tag.name],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey],
                            [NSURLQueryItem queryItemWithName:@"sk" value:[LFMSession sharedSession].sessionKey]]
                           filteredArrayUsingPredicate:LFMURLComponentsPredicate];
    components.queryItems = [[LFMAuth sharedInstance] appendingSignatureItemToQueryItems:queryItems];
    
    NSData *data = [components.percentEncodedQuery dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
        if (block == nil) return;
        
        block(error);
    }];
}

+ (LFMURLOperation *)getCorrectionForMisspelledArtistName:(NSString *)artistName
                                                 callback:(LFMArtistCallback)block {
    NSParameterAssert(artistName);
    NSParameterAssert(block);
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"artist.getCorrection"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    components.queryItems = [queryItems filteredArrayUsingPredicate:LFMURLComponentsPredicate];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
        id correctionsDictionary = [responseDictionary objectForKey:@"corrections"];
        if (correctionsDictionary != nil &&
            [correctionsDictionary isKindOfClass:NSDictionary.class]) {
            id correctionDictionary = [(NSDictionary *)correctionsDictionary objectForKey:@"correction"];
            if (correctionDictionary != nil &&
                [correctionDictionary isKindOfClass:NSDictionary.class]) {
                LFMArtist *artist = [[LFMArtist alloc] initFromDictionary:[(NSDictionary *)correctionDictionary objectForKey:@"artist"]];
                block(artist, error);
                return;
            }
        }
        
        block(nil, error);
    }];
}

+ (LFMURLOperation *)getInfoOnArtistNamed:(NSString *)artistName
                             withMusicBrainzId:(NSString *)mbid
                                   autoCorrect:(BOOL)autoCorrect
                                   forUsername:(NSString *)username
                                  languageCode:(NSString *)code
                                      callback:(LFMArtistCallback)block {
    NSAssert(artistName != nil || mbid != nil, @"Either the artistName or the mbid parameter must be set.");
    NSParameterAssert(block);
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"artist.getInfo"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"mbid" value:mbid],
                            [NSURLQueryItem queryItemWithName:@"autocorrect" value:[NSString stringWithFormat:@"%d", autoCorrect]],
                            [NSURLQueryItem queryItemWithName:@"username" value:username],
                            [NSURLQueryItem queryItemWithName:@"lang" value:code],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    components.queryItems = [queryItems filteredArrayUsingPredicate:LFMURLComponentsPredicate];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
        LFMArtist *artist = [[LFMArtist alloc] initFromDictionary:[responseDictionary objectForKey:@"artist"]];
        
        block(artist, error);
    }];
}

+ (LFMURLOperation *)getArtistsSimilarToArtistNamed:(NSString *)artistName
                                       withMusicBrainzId:(NSString *)mbid
                                             autoCorrect:(BOOL)autoCorrect
                                                   limit:(nullable NSNumber *)limit
                                                callback:(LFMArtistsCallback)block {
    NSAssert(artistName != nil || mbid != nil, @"Either the artistName or the mbid parameter must be set.");
    NSParameterAssert(block);    
    if (limit) {
        NSAssert(limit.unsignedIntValue <= 10000 && limit.unsignedIntValue > 0, @"Limit must be between 1 and 10,000");
    } else {
        limit = @30;
    }
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"artist.getSimilar"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"mbid" value:mbid],
                            [NSURLQueryItem queryItemWithName:@"autocorrect" value:[NSString stringWithFormat:@"%d", autoCorrect]],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%u", limit.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    components.queryItems = [queryItems filteredArrayUsingPredicate:LFMURLComponentsPredicate];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
        NSMutableArray<LFMArtist *> *artists = [NSMutableArray array];
        
        id similarArtistsDictionary = [responseDictionary objectForKey:@"similarartists"];
        if (similarArtistsDictionary != nil &&
            [similarArtistsDictionary isKindOfClass:NSDictionary.class]) {
            id artistsArray = [(NSDictionary *)similarArtistsDictionary objectForKey:@"artist"];
            if (artistsArray != nil &&
                [artistsArray isKindOfClass:NSArray.class]) {
                for (NSDictionary *artistDictionary in artistsArray) {
                    LFMArtist *artist = [[LFMArtist alloc] initFromDictionary:artistDictionary];
                    if (artist) [artists addObject:artist];
                }
            }
        }
        
        block(artists, error);
    }];
}

+ (LFMURLOperation *)getTagsForArtistNamed:(NSString *)artistName
                              withMusicBrainzId:(NSString *)mbid
                                    autoCorrect:(BOOL)autoCorrect
                                    forUsername:(NSString *)username
                                       callback:(LFMTagsCallback)block {
    NSAssert([LFMSession sharedSession].sessionKey != nil || username != nil, @"The user either: must be authenticated, or the `username` parameter must be set.");
    NSAssert(artistName != nil || mbid != nil, @"Either the artistName or the mbid parameter must be set.");
    NSParameterAssert(block);
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = [@[[NSURLQueryItem queryItemWithName:@"method" value:@"artist.getTags"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"mbid" value:mbid],
                            [NSURLQueryItem queryItemWithName:@"autocorrect" value:[NSString stringWithFormat:@"%d", autoCorrect]],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"sk" value:[LFMSession sharedSession].sessionKey],
                             [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]]
                           filteredArrayUsingPredicate:LFMURLComponentsPredicate];

    components.queryItems = [LFMSession sharedSession].sessionKey == nil ? queryItems : [[LFMAuth sharedInstance] appendingSignatureItemToQueryItems:queryItems];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
        NSMutableArray<LFMTag *> *tags = [NSMutableArray array];
        
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
        
        block(tags, error);
    }];
}

+ (LFMURLOperation *)getTopAlbumsForArtistNamed:(NSString *)artistName
                                   withMusicBrainzId:(NSString *)mbid
                                         autoCorrect:(BOOL)autoCorrect
                                        itemsPerPage:(nullable NSNumber *)limit
                                              onPage:(nullable NSNumber *)page
                                            callback:(LFMAlbumPaginatedCallback)block {
    NSAssert(artistName != nil || mbid != nil, @"Either the artistName or the mbid parameter must be set.");
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
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"artist.getTopAlbums"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"mbid" value:mbid],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%u", page.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%u", limit.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"autocorrect" value:[NSString stringWithFormat:@"%d", autoCorrect]],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    components.queryItems = [queryItems filteredArrayUsingPredicate:LFMURLComponentsPredicate];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
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
            
            block(albums, query, error);
        } else {
            block(albums, nil, error);
        }
    }];
}

+ (LFMURLOperation *)getTopTracksForArtistNamed:(NSString *)artistName
                                   withMusicBrainzId:(NSString *)mbid
                                         autoCorrect:(BOOL)autoCorrect
                                        itemsPerPage:(nullable NSNumber *)limit
                                              onPage:(nullable NSNumber *)page
                                            callback:(LFMTrackPaginatedCallback)block {
    NSAssert(artistName != nil || mbid != nil, @"Either the artistName or the mbid parameter must be set.");
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
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"artist.getTopTracks"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"mbid" value:mbid],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%u", page.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%u", limit.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"autocorrect" value:[NSString stringWithFormat:@"%d", autoCorrect]],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    components.queryItems = [queryItems filteredArrayUsingPredicate:LFMURLComponentsPredicate];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
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
            
            block(tracks, query, error);
        } else {
            block(tracks, nil, error);
        }
    }];
}

+ (LFMURLOperation *)getTopTagsForArtistNamed:(NSString *)artistName
                                 withMusicBrainzId:(NSString *)mbid
                                       autoCorrect:(BOOL)autoCorrect
                                          callback:(LFMTopTagsCallback)block {
    NSAssert(artistName != nil || mbid != nil, @"Either the artistName or the mbid parameter must be set.");
    NSParameterAssert(block);
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"artist.getTopTags"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"mbid" value:mbid],
                            [NSURLQueryItem queryItemWithName:@"autocorrect" value:[NSString stringWithFormat:@"%d", autoCorrect]],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = [queryItems filteredArrayUsingPredicate:LFMURLComponentsPredicate];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
        NSMutableArray<LFMTopTag *> *tags = [NSMutableArray array];
        
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
            
            block(tags, error);
        } else {
            block(tags, error);
        }
    }];
}

+ (LFMURLOperation *)searchForArtistNamed:(NSString *)artistName
                                  itemsPerPage:(nullable NSNumber *)limit
                                        onPage:(nullable NSNumber *)page
                                      callback:(LFMArtistSearchCallback)block {
    NSParameterAssert(artistName);
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
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"artist.search"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%u", limit.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%u", page.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = [queryItems filteredArrayUsingPredicate:LFMURLComponentsPredicate];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
        id resultsDictionary = [responseDictionary objectForKey:@"results"];
        if (resultsDictionary != nil &&
            [resultsDictionary isKindOfClass:NSDictionary.class]) {
            LFMSearchQuery *searchQuery = [[LFMSearchQuery alloc] initFromDictionary:resultsDictionary];
            
            NSMutableArray<LFMArtist *> *artists = [NSMutableArray array];
            
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
            
            block(artists, searchQuery, error);
        } else {
            block(@[], nil, error);
        }
    }];
}


@end
