//
//  LFMUserProvider.m
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

#import "LFMUserProvider.h"
#import "LFMURLOperation.h"
#import "LFMAuth.h"
#import "LFMSession.h"
#import "LFMUser.h"
#import "LFMError.h"
#import "LFMKit+Protected.h"
#import "LFMTrack.h"
#import "LFMAlbum.h"
#import "LFMArtist.h"
#import "LFMTopTag.h"
#import "LFMChart.h"

@implementation LFMUserProvider

+ (LFMURLOperation *)getInfoOnUserNamed:(NSString *)username
                                    callback:(LFMUserCallback)block {
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getInfo"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
        LFMUser *user = [[LFMUser alloc] initFromDictionary:[responseDictionary objectForKey:@"user"]];
        
        block(user, error);
    }];
}

+ (LFMURLOperation *)getFriendsOfUserNamed:(NSString *)username
                         includeRecentScrobbles:(BOOL)includeRecents
                                   itemsPerPage:(nullable NSNumber *)limit
                                         onPage:(nullable NSNumber *)page
                                       callback:(LFMUserPaginatedCallback)block {
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getFriends"],
                            [NSURLQueryItem queryItemWithName:@"recenttracks" value:[NSString stringWithFormat:@"%d", includeRecents]],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%u", limit.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%u", page.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
        NSMutableArray<LFMUser *> *users = [NSMutableArray array];
        
        id friendsDictionary = [responseDictionary objectForKey:@"friends"];
        if (friendsDictionary != nil &&
            [friendsDictionary isKindOfClass:NSDictionary.class]) {
            LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[(NSDictionary *)friendsDictionary objectForKey:@"@attr"]];
            
            id userArray = [(NSDictionary *)friendsDictionary objectForKey:@"user"];
            if (userArray != nil && [userArray isKindOfClass:NSArray.class]) {
                for (NSDictionary *userDictionary in userArray) {
                    LFMUser *user = [[LFMUser alloc] initFromDictionary:userDictionary];
                    if (user) [users addObject:user];
                }
            }
            
            block(users, query, error);
        } else {
            block(users, nil, error);
        }
    }];
}

+ (LFMURLOperation *)getTracksScrobbledByUserNamed:(NSString *)username
                                          byArtistNamed:(NSString *)artistName
                                                 onPage:(nullable NSNumber *)page
                                          fromStartDate:(NSDate *)startDate
                                              toEndDate:(NSDate *)endDate
                                               callback:(LFMTrackPaginatedCallback)block {
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getArtistTracks"],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%u", page.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"startTimestamp" value:[NSString stringWithFormat:@"%f", startDate.timeIntervalSince1970]],
                            [NSURLQueryItem queryItemWithName:@"endTimestamp" value:[NSString stringWithFormat:@"%f", endDate.timeIntervalSince1970]],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
        NSMutableArray<LFMTrack *> *tracks = [NSMutableArray array];
        
        id tracksDictionary = [responseDictionary objectForKey:@"artisttracks"];
        if (tracksDictionary != nil &&
            [tracksDictionary isKindOfClass:NSDictionary.class]) {
            LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[(NSDictionary *)tracksDictionary objectForKey:@"@attr"]];
            
            id tracksArray = [(NSDictionary *)tracksDictionary objectForKey:@"track"];
            if (tracksArray != nil && [tracksArray isKindOfClass:NSArray.class]) {
                for (NSDictionary *trackDictionary in tracksArray) {
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

+ (LFMURLOperation *)getTracksLovedByUserNamed:(NSString *)username
                                       itemsPerPage:(nullable NSNumber *)limit
                                             onPage:(nullable NSNumber *)page
                                           callback:(LFMTrackPaginatedCallback)block {
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getLovedTracks"],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%u", limit.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%u", page.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
        NSMutableArray<LFMTrack *> *tracks = [NSMutableArray array];
        
        id tracksDictionary = [responseDictionary objectForKey:@"lovedtracks"];
        if (tracksDictionary != nil &&
            [tracksDictionary isKindOfClass:NSDictionary.class]) {
            LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[(NSDictionary *)tracksDictionary objectForKey:@"@attr"]];
            
            id tracksArray = [(NSDictionary *)tracksDictionary objectForKey:@"track"];
            if (tracksArray != nil && [tracksArray isKindOfClass:NSArray.class]) {
                for (NSDictionary *trackDictionary in tracksArray) {
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

+ (LFMURLOperation *)getItemsTaggedByUserNamed:(NSString *)username
                                        forTagNamed:(NSString *)tagName
                                           itemType:(LFMTaggingType)type
                                       itemsPerPage:(nullable NSNumber *)limit
                                             onPage:(nullable NSNumber *)page
                                           callback:(LFMGenericPaginatedCallback)block {
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getPersonalTags"],
                            [NSURLQueryItem queryItemWithName:@"tag" value:tagName],
                            [NSURLQueryItem queryItemWithName:@"taggingtype" value:type],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%u", limit.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%u", page.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
        NSMutableArray *items = [NSMutableArray array];
        
        id taggingsDictionary = [responseDictionary objectForKey:@"taggings"];
        if (taggingsDictionary != nil &&
            [taggingsDictionary isKindOfClass:NSDictionary.class]) {
            LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[(NSDictionary *)taggingsDictionary objectForKey:@"@attr"]];
            
            id itemsDictionary = [(NSDictionary *)taggingsDictionary objectForKey:[NSString stringWithFormat:@"%@s", type]];
            if (itemsDictionary != nil &&
                [itemsDictionary isKindOfClass:NSDictionary.class]) {
                id itemsArray = [(NSDictionary *)itemsDictionary objectForKey:type];
                if (itemsArray != nil &&
                    [itemsArray isKindOfClass:NSArray.class]) {
                    for (NSDictionary *itemDictionary in itemsArray) {
                        NSObject *item = nil;
                        
                        if ([type isEqualToString:LFMTaggingTypeTrack]) {
                            item = [[LFMTrack alloc] initFromDictionary:itemDictionary];
                        } else if ([type isEqualToString:LFMTaggingTypeAlbum]) {
                            item = [[LFMAlbum alloc] initFromDictionary:itemDictionary];
                        } else if ([type isEqualToString:LFMTaggingTypeArtist]) {
                            item = [[LFMArtist alloc] initFromDictionary:itemDictionary];
                        } else {
                            NSAssert(false, @"Unknown `type` parameter. Type must be either: `LFMTaggingTypeTrack`, `LFMTaggingTypeAlbum` or `LFMTaggingTypeArtist`");
                            return;
                        }
                        
                        if (item) [items addObject:item];
                    }
                }
            }
            
            block(items, query, error);
        } else {
            block(items, nil, error);
        }
    }];
}

+ (LFMURLOperation *)getRecentTracksForUsername:(NSString *)username
                                         itemsPerPage:(nullable NSNumber *)limit
                                               onPage:(nullable NSNumber *)page
                                        fromStartDate:(NSDate *)startDate
                                            toEndDate:(NSDate *)endDate
                                             callback:(LFMTrackPaginatedCallback)block {
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getRecentTracks"],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%u", limit.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%u", page.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"extended" value:@"1"],
                            [NSURLQueryItem queryItemWithName:@"startTimestamp" value:[NSString stringWithFormat:@"%f", startDate.timeIntervalSince1970]],
                            [NSURLQueryItem queryItemWithName:@"endTimestamp" value:[NSString stringWithFormat:@"%f", endDate.timeIntervalSince1970]],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
        NSMutableArray<LFMTrack *> *tracks = [NSMutableArray array];
        
        id tracksDictionary = [responseDictionary objectForKey:@"recenttracks"];
        if (tracksDictionary != nil &&
            [tracksDictionary isKindOfClass:NSDictionary.class]) {
            LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[(NSDictionary *)tracksDictionary objectForKey:@"@attr"]];
            
            id tracksArray = [(NSDictionary *)tracksDictionary objectForKey:@"track"];
            if (tracksArray != nil && [tracksArray isKindOfClass:NSArray.class]) {
                for (NSDictionary *trackDictionary in tracksArray) {
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

+ (LFMURLOperation *)getTopAlbumsForUsername:(NSString *)username
                                      itemsPerPage:(nullable NSNumber *)limit
                                            onPage:(nullable NSNumber *)page
                                        overPeriod:(LFMTimePeriod)period
                                          callback:(LFMAlbumPaginatedCallback)block {
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getTopAlbums"],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%u", limit.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%u", page.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"period" value:period],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
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
            
            id albumsArray = [(NSDictionary *)topAlbumsDictionary objectForKey:@"album"];
            if (albumsArray != nil && [albumsArray isKindOfClass:NSArray.class]) {
                for (NSDictionary *albumDictionary in albumsArray) {
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

+ (LFMURLOperation *)getTopArtistsForUsername:(NSString *)username
                                       itemsPerPage:(nullable NSNumber *)limit
                                             onPage:(nullable NSNumber *)page
                                         overPeriod:(LFMTimePeriod)period
                                           callback:(LFMArtistPaginatedCallback)block {
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getTopArtists"],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%u", limit.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%u", page.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"period" value:period],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
        NSMutableArray<LFMArtist *> *artists = [NSMutableArray array];
        
        id artistsDictionary = [responseDictionary objectForKey:@"topartists"];
        if (artistsDictionary != nil &&
            [artistsDictionary isKindOfClass:NSDictionary.class]) {
            LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[(NSDictionary *)artistsDictionary objectForKey:@"@attr"]];
            
            
            id artistsArray = [(NSDictionary *)artistsDictionary objectForKey:@"artist"];
            if (artistsArray != nil && [artistsArray isKindOfClass:NSArray.class]) {
                for (NSDictionary *artistDictionary in artistsArray) {
                    LFMArtist *artist = [[LFMArtist alloc] initFromDictionary:artistDictionary];
                    if (artist) [artists addObject:artist];
                }
            }
            
            block(artists, query, error);
        } else {
            block(artists, nil, error);
        }
    }];
}

+ (LFMURLOperation *)getTopTracksForUsername:(NSString *)username
                                      itemsPerPage:(nullable NSNumber *)limit
                                            onPage:(nullable NSNumber *)page
                                        overPeriod:(LFMTimePeriod)period
                                          callback:(LFMTrackPaginatedCallback)block {
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getTopTracks"],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%u", limit.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%u", page.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"period" value:period],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
        NSMutableArray<LFMTrack *> *tracks = [NSMutableArray array];
        
        id tracksDictionary = [responseDictionary objectForKey:@"toptracks"];
        if (tracksDictionary != nil &&
            [tracksDictionary isKindOfClass:NSDictionary.class]) {
            LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[(NSDictionary *)tracksDictionary objectForKey:@"@attr"]];
            
            id tracksArray = [(NSDictionary *)tracksDictionary objectForKey:@"track"];
            if (tracksArray != nil && [tracksArray isKindOfClass:NSArray.class]) {
                for (NSDictionary *trackDictionary in tracksArray) {
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

+ (LFMURLOperation *)getTopTagsForUsername:(NSString *)username
                                           limit:(nullable NSNumber *)limit
                                        callback:(LFMTopTagsCallback)block {
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getTopTags"],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%u", limit.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
        NSMutableArray<LFMTopTag *> *tags = [NSMutableArray array];
        
        id topTagsDictionary = [responseDictionary objectForKey:@"toptags"];
        if (topTagsDictionary != nil &&
            [topTagsDictionary isKindOfClass:NSDictionary.class]) {
            id tagsArray = [(NSDictionary *)topTagsDictionary objectForKey:@"tag"];
            if (tagsArray != nil && [tagsArray isKindOfClass:NSArray.class]) {
                for (NSDictionary *tagDictionary in tagsArray) {
                    LFMTopTag *tag = [[LFMTopTag alloc] initFromDictionary:tagDictionary];
                    if (tag) [tags addObject:tag];
                }
            }
        }
        
        block(tags, error);
    }];
}

+ (LFMURLOperation *)getWeeklyAlbumChartForUsername:(NSString *)username
                                            fromStartDate:(NSDate *)startDate
                                                toEndDate:(NSDate *)endDate
                                                 callback:(LFMAlbumsCallback)block {
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getWeeklyAlbumChart"],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"from" value:[NSString stringWithFormat:@"%f", startDate.timeIntervalSince1970]],
                            [NSURLQueryItem queryItemWithName:@"to" value:[NSString stringWithFormat:@"%f", endDate.timeIntervalSince1970]],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
        NSMutableArray<LFMAlbum *> *albums = [NSMutableArray array];
        
        id weeklyAlbumsDictionary = [responseDictionary objectForKey:@"weeklyalbumchart"];
        if (weeklyAlbumsDictionary != nil &&
            [weeklyAlbumsDictionary isKindOfClass:NSDictionary.class]) {
            id albumsArray = [(NSDictionary *)weeklyAlbumsDictionary objectForKey:@"album"];
            if (albumsArray != nil && [albumsArray isKindOfClass:NSArray.class]) {
                for (NSDictionary *albumDictionary in albumsArray) {
                    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:albumDictionary];
                    if (album) [albums addObject:album];
                }
            }
        }
        
        block(albums, error);
    }];
}

+ (LFMURLOperation *)getWeeklyArtistChartForUsername:(NSString *)username
                                             fromStartDate:(NSDate *)startDate
                                                 toEndDate:(NSDate *)endDate
                                                  callback:(LFMArtistsCallback)block {
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getWeeklyArtistChart"],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"from" value:[NSString stringWithFormat:@"%f", startDate.timeIntervalSince1970]],
                            [NSURLQueryItem queryItemWithName:@"to" value:[NSString stringWithFormat:@"%f", endDate.timeIntervalSince1970]],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
        NSMutableArray<LFMArtist *> *artists = [NSMutableArray array];
        
        id artistsDictionary = [responseDictionary objectForKey:@"weeklyartistchart"];
        if (artistsDictionary != nil &&
            [artistsDictionary isKindOfClass:NSDictionary.class]) {
            id artistsArray = [(NSDictionary *)artistsDictionary objectForKey:@"artist"];
            if (artistsArray != nil && [artistsArray isKindOfClass:NSArray.class]) {
                for (NSDictionary *artistDictionary in artistsArray) {
                    LFMArtist *artist = [[LFMArtist alloc] initFromDictionary:artistDictionary];
                    if (artist) [artists addObject:artist];
                }
            }
        }
        
        block(artists, error);
    }];
}

+ (LFMURLOperation *)getWeeklyTrackChartForUsername:(NSString *)username
                                            fromStartDate:(NSDate *)startDate
                                                toEndDate:(NSDate *)endDate
                                                 callback:(LFMTracksCallback)block {
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getWeeklyTrackChart"],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"from" value:[NSString stringWithFormat:@"%f", startDate.timeIntervalSince1970]],
                            [NSURLQueryItem queryItemWithName:@"to" value:[NSString stringWithFormat:@"%f", endDate.timeIntervalSince1970]],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
        NSMutableArray<LFMTrack *> *tracks = [NSMutableArray array];
        
        id tracksDictionary = [responseDictionary objectForKey:@"weeklytrackchart"];
        if (tracksDictionary != nil &&
            [tracksDictionary isKindOfClass:NSDictionary.class]) {
            id tracksArray = [(NSDictionary *)tracksDictionary objectForKey:@"track"];
            if (tracksArray != nil && [tracksArray isKindOfClass:NSArray.class]) {
                for (NSDictionary *trackDictionary in tracksArray) {
                    LFMTrack *track = [[LFMTrack alloc] initFromDictionary:trackDictionary];
                    if (track) [tracks addObject:track];
                }
            }
        }
        
        block(tracks, error);
    }];
}

+ (LFMURLOperation *)getWeeklyChartListForUsername:(NSString *)username
                                                callback:(LFMChartsCallback)block {
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getWeeklyChartList"],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    return [LFMURLOperation operationWithSession:[NSURLSession sharedSession]
                                         request:request
                                        callback:^(NSDictionary *responseDictionary,
                                                   NSError *error) {
        NSMutableArray<LFMChart *> *charts = [NSMutableArray array];
        
        id chartsDictionary = [responseDictionary objectForKey:@"weeklychartlist"];
        if (chartsDictionary != nil &&
            [chartsDictionary isKindOfClass:NSDictionary.class]) {
            id chartsArray = [(NSDictionary *)chartsDictionary objectForKey:@"chart"];
            if (chartsArray != nil && [chartsArray isKindOfClass:NSArray.class]) {
                for (NSDictionary *chartDictionary in chartsArray) {
                    LFMChart *chart = [[LFMChart alloc] initFromDictionary:chartDictionary];
                    if (chart) [charts addObject:chart];
                }
            }
        }
        
        block(charts, error);
    }];
}

@end
