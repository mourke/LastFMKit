//
//  LFMUserProvider.m
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

#import "LFMUserProvider.h"
#import "LFMAuth.h"
#import "LFMSession.h"
#import "LFMUser.h"
#import "LFMError.h"
#import "LFMKit+Protected.h"

@implementation LFMUserProvider

+ (NSURLSessionDataTask *)getInfoOnUserNamed:(NSString *)userName
                                    callback:(void (^)(NSError * _Nullable, LFMUser * _Nullable))block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getInfo"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"user" value:userName],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || data == nil || !lfm_error_validate(data, &error)) return block(error, nil);
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        LFMUser *user = [[LFMUser alloc] initFromDictionary:[responseDictionary objectForKey:@"user"]];
        
        block(error, user);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getFriendsOfUserNamed:(NSString *)userName
                         includeRecentScrobbles:(BOOL)includeRecents
                                   itemsPerPage:(NSUInteger)limit
                                         onPage:(NSUInteger)page
                                       callback:(void (^)(NSError * _Nullable, NSArray<LFMUser *> * _Nonnull, LFMQuery * _Nullable))block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getFriends"],
                            [NSURLQueryItem queryItemWithName:@"recenttracks" value:[NSString stringWithFormat:@"%d", includeRecents]],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%tu", limit]],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%tu", page]],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"user" value:userName],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || data == nil || !lfm_error_validate(data, &error)) return block(error, @[], nil);
        
        NSDictionary *responseDictionary = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error] objectForKey:@"friends"];
        
        LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[responseDictionary objectForKey:@"@attr"]];
        
        NSMutableArray <LFMUser *> *users = [NSMutableArray array];
        
        for (NSDictionary *userDictionary in [responseDictionary objectForKey:@"user"]) {
            LFMUser *user = [[LFMUser alloc] initFromDictionary:userDictionary];
            user == nil ?: [users addObject:user];
        }
        
        block(error, users, query);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTracksScrobbledByUserNamed:(NSString *)userName
                                          byArtistNamed:(NSString *)artistName
                                                 onPage:(NSUInteger)page
                                          fromStartDate:(NSDate *)startDate
                                              toEndDate:(NSDate *)endDate
                                               callback:(void (^)(NSError * _Nullable, NSArray<LFMTrack *> * _Nonnull, LFMQuery * _Nullable))block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getArtistTracks"],
                            [NSURLQueryItem queryItemWithName:@"user" value:userName],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%tu", page]],
                            [NSURLQueryItem queryItemWithName:@"startTimestamp" value:[NSString stringWithFormat:@"%f", startDate.timeIntervalSince1970]],
                            [NSURLQueryItem queryItemWithName:@"endTimestamp" value:[NSString stringWithFormat:@"%f", endDate.timeIntervalSince1970]],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || data == nil || !lfm_error_validate(data, &error)) return block(error, @[], nil);
        
        NSDictionary *responseDictionary = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error] objectForKey:@"artisttracks"];
        
        LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[responseDictionary objectForKey:@"@attr"]];
        
        NSMutableArray <LFMTrack *> *tracks = [NSMutableArray array];
        
        for (NSDictionary *trackDictionary in [responseDictionary objectForKey:@"track"]) {
            LFMTrack *track = [[LFMTrack alloc] initFromDictionary:trackDictionary];
            track == nil ?: [tracks addObject:track];
        }
        
        block(error, tracks, query);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTracksLovedByUserNamed:(NSString *)userName
                                       itemsPerPage:(NSUInteger)limit
                                             onPage:(NSUInteger)page
                                           callback:(void (^)(NSError * _Nullable, NSArray<LFMTrack *> * _Nonnull, LFMQuery * _Nullable))block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"user.getLovedTracks"],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%tu", limit]],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%tu", page]],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"user" value:userName],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || data == nil || !lfm_error_validate(data, &error)) return block(error, @[], nil);
        
        NSDictionary *responseDictionary = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error] objectForKey:@"lovedtracks"];
        
        LFMQuery *query = [[LFMQuery alloc] initFromDictionary:[responseDictionary objectForKey:@"@attr"]];
        
        NSMutableArray <LFMTrack *> *tracks = [NSMutableArray array];
        
        for (NSDictionary *trackDictionary in [responseDictionary objectForKey:@"track"]) {
            LFMTrack *track = [[LFMTrack alloc] initFromDictionary:trackDictionary];
            track == nil ?: [tracks addObject:track];
        }
        
        block(error, tracks, query);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

@end
