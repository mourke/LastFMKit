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

+ (NSURLSessionDataTask *)getInfoOnUserNamed:(NSString *)username
                                    callback:(LFMUserCallback)block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getInfo"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(nil, error);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        LFMUser *user = [[LFMUser alloc] initFromDictionary:[responseDictionary objectForKey:@"user"]];
        
        block(user, error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getFriendsOfUserNamed:(NSString *)username
                         includeRecentScrobbles:(BOOL)includeRecents
                                   itemsPerPage:(nullable NSNumber *)limit
                                         onPage:(nullable NSNumber *)page
                                       callback:(LFMUserPaginatedCallback)block {
    NSURLSession *session = [NSURLSession sharedSession];
    
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
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(@[], nil, error);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (responseDictionary) {
            responseDictionary = [responseDictionary objectForKey:@"friends"];
        }
        
        LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[responseDictionary objectForKey:@"@attr"]];
        
        NSMutableArray <LFMUser *> *users = [NSMutableArray array];
        
        for (NSDictionary *userDictionary in [responseDictionary objectForKey:@"user"]) {
            LFMUser *user = [[LFMUser alloc] initFromDictionary:userDictionary];
            if (user) [users addObject:user];
        }
        
        block(users, query, error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTracksScrobbledByUserNamed:(NSString *)username
                                          byArtistNamed:(NSString *)artistName
                                                 onPage:(nullable NSNumber *)page
                                          fromStartDate:(NSDate *)startDate
                                              toEndDate:(NSDate *)endDate
                                               callback:(LFMTrackPaginatedCallback)block {
    NSURLSession *session = [NSURLSession sharedSession];
    
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
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(@[], nil, error);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (responseDictionary) {
            responseDictionary = [responseDictionary objectForKey:@"artisttracks"];
        }
        
        LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[responseDictionary objectForKey:@"@attr"]];
        
        NSMutableArray <LFMTrack *> *tracks = [NSMutableArray array];
        
        for (NSDictionary *trackDictionary in [responseDictionary objectForKey:@"track"]) {
            LFMTrack *track = [[LFMTrack alloc] initFromDictionary:trackDictionary];
            if (track) [tracks addObject:track];
        }
        
        block(tracks, query, error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTracksLovedByUserNamed:(NSString *)username
                                       itemsPerPage:(nullable NSNumber *)limit
                                             onPage:(nullable NSNumber *)page
                                           callback:(LFMTrackPaginatedCallback)block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getLovedTracks"],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%u", limit.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%u", page.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
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
            responseDictionary = [responseDictionary objectForKey:@"lovedtracks"];
        }
        
        LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[responseDictionary objectForKey:@"@attr"]];
        
        NSMutableArray <LFMTrack *> *tracks = [NSMutableArray array];
        
        for (NSDictionary *trackDictionary in [responseDictionary objectForKey:@"track"]) {
            LFMTrack *track = [[LFMTrack alloc] initFromDictionary:trackDictionary];
            if (track) [tracks addObject:track];
        }
        
        block(tracks, query, error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getItemsTaggedByUserNamed:(NSString *)username
                                        forTagNamed:(NSString *)tagName
                                           itemType:(LFMTaggingType)type
                                       itemsPerPage:(nullable NSNumber *)limit
                                             onPage:(nullable NSNumber *)page
                                           callback:(LFMGenericPaginatedCallback)block {
    NSURLSession *session = [NSURLSession sharedSession];
    
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
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(@[], nil, error);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (responseDictionary) {
            responseDictionary = [responseDictionary objectForKey:@"taggings"];
        }
        
        LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[responseDictionary objectForKey:@"@attr"]];
        
        NSMutableArray *items = [NSMutableArray array];
        
        NSDictionary *itemsDictionary = [responseDictionary objectForKey:[NSString stringWithFormat:@"%@s", type]];
        
        for (NSDictionary *itemDictionary in [itemsDictionary objectForKey:type]) {
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
        
        block(items, query, error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getRecentTracksForUsername:(NSString *)username
                                         itemsPerPage:(nullable NSNumber *)limit
                                               onPage:(nullable NSNumber *)page
                                        fromStartDate:(NSDate *)startDate
                                            toEndDate:(NSDate *)endDate
                                             callback:(LFMTrackPaginatedCallback)block {
    NSURLSession *session = [NSURLSession sharedSession];
    
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
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(@[], nil, error);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (responseDictionary) {
            responseDictionary = [responseDictionary objectForKey:@"recenttracks"];
        }
        
        LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[responseDictionary objectForKey:@"@attr"]];
        
        NSMutableArray <LFMTrack *> *tracks = [NSMutableArray array];
        
        for (NSDictionary *trackDictionary in [responseDictionary objectForKey:@"track"]) {
            LFMTrack *track = [[LFMTrack alloc] initFromDictionary:trackDictionary];
            if (track) [tracks addObject:track];
        }
        
        block(tracks, query, error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTopAlbumsForUsername:(NSString *)username
                                      itemsPerPage:(nullable NSNumber *)limit
                                            onPage:(nullable NSNumber *)page
                                        overPeriod:(LFMTimePeriod)period
                                          callback:(LFMAlbumPaginatedCallback)block {
    NSURLSession *session = [NSURLSession sharedSession];
    
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
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(@[], nil, error);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (responseDictionary) {
            responseDictionary = [responseDictionary objectForKey:@"topalbums"];
        }
        
        LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[responseDictionary objectForKey:@"@attr"]];
        
        NSMutableArray <LFMAlbum *> *albums = [NSMutableArray array];
        
        for (NSDictionary *albumDictionary in [responseDictionary objectForKey:@"album"]) {
            LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:albumDictionary];
            if (album) [albums addObject:album];
        }
        
        block(albums, query, error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTopArtistsForUsername:(NSString *)username
                                       itemsPerPage:(nullable NSNumber *)limit
                                             onPage:(nullable NSNumber *)page
                                         overPeriod:(LFMTimePeriod)period
                                           callback:(LFMArtistPaginatedCallback)block {
    NSURLSession *session = [NSURLSession sharedSession];
    
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
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(@[], nil, error);
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
        
        block(artists, query, error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTopTracksForUsername:(NSString *)username
                                      itemsPerPage:(nullable NSNumber *)limit
                                            onPage:(nullable NSNumber *)page
                                        overPeriod:(LFMTimePeriod)period
                                          callback:(LFMTrackPaginatedCallback)block {
    NSURLSession *session = [NSURLSession sharedSession];
    
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
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(@[], nil, error);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (responseDictionary) {
            responseDictionary = [responseDictionary objectForKey:@"toptracks"];
        }
        
        LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[responseDictionary objectForKey:@"@attr"]];
        
        NSMutableArray <LFMTrack *> *tracks = [NSMutableArray array];
        
        for (NSDictionary *trackDictionary in [responseDictionary objectForKey:@"track"]) {
            LFMTrack *track = [[LFMTrack alloc] initFromDictionary:trackDictionary];
            if (track) [tracks addObject:track];
        }
        
        block(tracks, query, error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTopTagsForUsername:(NSString *)username
                                           limit:(nullable NSNumber *)limit
                                        callback:(LFMTopTagsCallback)block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getTopTags"],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%u", limit.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(@[], error);
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
        
        block(tags, error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getWeeklyAlbumChartForUsername:(NSString *)username
                                            fromStartDate:(NSDate *)startDate
                                                toEndDate:(NSDate *)endDate
                                                 callback:(LFMAlbumsCallback)block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getWeeklyAlbumChart"],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"from" value:[NSString stringWithFormat:@"%f", startDate.timeIntervalSince1970]],
                            [NSURLQueryItem queryItemWithName:@"to" value:[NSString stringWithFormat:@"%f", endDate.timeIntervalSince1970]],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(@[], error);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (responseDictionary) {
            responseDictionary = [responseDictionary objectForKey:@"weeklyalbumchart"];
        }
        
        NSMutableArray <LFMAlbum *> *albums = [NSMutableArray array];
        
        for (NSDictionary *albumDictionary in [responseDictionary objectForKey:@"album"]) {
            LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:albumDictionary];
            if (album) [albums addObject:album];
        }
        
        block(albums, error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getWeeklyArtistChartForUsername:(NSString *)username
                                             fromStartDate:(NSDate *)startDate
                                                 toEndDate:(NSDate *)endDate
                                                  callback:(LFMArtistsCallback)block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getWeeklyArtistChart"],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"from" value:[NSString stringWithFormat:@"%f", startDate.timeIntervalSince1970]],
                            [NSURLQueryItem queryItemWithName:@"to" value:[NSString stringWithFormat:@"%f", endDate.timeIntervalSince1970]],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(@[], error);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (responseDictionary) {
            responseDictionary = [responseDictionary objectForKey:@"weeklyartistchart"];
        }
        
        NSMutableArray <LFMArtist *> *artists = [NSMutableArray array];
        
        for (NSDictionary *artistDictionary in [responseDictionary objectForKey:@"artist"]) {
            LFMArtist *artist = [[LFMArtist alloc] initFromDictionary:artistDictionary];
            if (artist) [artists addObject:artist];
        }
        
        block(artists, error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getWeeklyTrackChartForUsername:(NSString *)username
                                            fromStartDate:(NSDate *)startDate
                                                toEndDate:(NSDate *)endDate
                                                 callback:(LFMTracksCallback)block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getWeeklyTrackChart"],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"from" value:[NSString stringWithFormat:@"%f", startDate.timeIntervalSince1970]],
                            [NSURLQueryItem queryItemWithName:@"to" value:[NSString stringWithFormat:@"%f", endDate.timeIntervalSince1970]],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(@[], error);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (responseDictionary) {
            responseDictionary = [responseDictionary objectForKey:@"weeklytrackchart"];
        }
        
        NSMutableArray <LFMTrack *> *tracks = [NSMutableArray array];
        
        for (NSDictionary *trackDictionary in [responseDictionary objectForKey:@"track"]) {
            LFMTrack *track = [[LFMTrack alloc] initFromDictionary:trackDictionary];
            if (track) [tracks addObject:track];
        }
        
        block(tracks, error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getWeeklyChartListForUsername:(NSString *)username
                                                callback:(LFMChartsCallback)block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getWeeklyChartList"],
                            [NSURLQueryItem queryItemWithName:@"user" value:username],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(@[], error);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (responseDictionary) {
            responseDictionary = [responseDictionary objectForKey:@"weeklychartlist"];
        }
        
        NSMutableArray <LFMChart *> *charts = [NSMutableArray array];
        
        for (NSDictionary *chartDictionary in [responseDictionary objectForKey:@"chart"]) {
            LFMChart *chart = [[LFMChart alloc] initFromDictionary:chartDictionary];
            if (chart) [charts addObject:chart];
        }
        
        block(charts, error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

@end
