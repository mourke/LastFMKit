//
//  LFMTrackProvider.m
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

#import "LFMTrackProvider.h"
#import "LFMKit+Protected.h"
#import "LFMError.h"
#import "LFMAuth.h"
#import "LFMTrack.h"
#import "LFMSearchQuery.h"
#import "LFMScrobbleTrack.h"
#import "LFMTopTag.h"
#import "LFMTag.h"

@implementation LFMTrackProvider

+ (NSURLSessionDataTask *)updateNowPlayingWithTrackNamed:(NSString *)trackName
                                           byArtistNamed:(NSString *)artistName
                                            onAlbumNamed:(NSString *)albumName
                                         positionInAlbum:(NSNumber *)trackNumber
                                    withAlbumArtistNamed:(NSString *)albumArtist
                                           trackDuration:(NSNumber *)duration
                                           musicBrainzId:(NSString *)mbid
                                                callback:(nullable LFMErrorCallback)block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"track.updateNowPlaying"],
                            [NSURLQueryItem queryItemWithName:@"album" value:albumName],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"track" value:trackName],
                            [NSURLQueryItem queryItemWithName:@"trackNumber" value:trackNumber.stringValue],
                            [NSURLQueryItem queryItemWithName:@"duration" value:duration.stringValue],
                            [NSURLQueryItem queryItemWithName:@"albumArtist" value:albumArtist],
                            [NSURLQueryItem queryItemWithName:@"mbid" value:mbid],
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

+ (NSURLSessionDataTask *)loveTrackNamed:(NSString *)trackName
                           byArtistNamed:(NSString *)artistName
                                callback:(nullable LFMErrorCallback)block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"track.love"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"track" value:trackName],
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

+ (NSURLSessionDataTask *)unloveTrackNamed:(NSString *)trackName
                             byArtistNamed:(NSString *)artistName
                                  callback:(nullable LFMErrorCallback)block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"track.unlove"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"track" value:trackName],
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

+ (NSURLSessionDataTask *)searchForTrackNamed:(NSString *)trackName
                                byArtistNamed:(NSString *)artistName
                                 itemsPerPage:(nullable NSNumber *)limit
                                       onPage:(nullable NSNumber *)page
                                     callback:(LFMTrackSearchCallback)block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"track.search"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"track" value:trackName],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%u", limit.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%u", page.unsignedIntValue]],
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
            responseDictionary = [responseDictionary objectForKey:@"results"];
        }
        
        LFMSearchQuery *searchQuery = [[LFMSearchQuery alloc] initFromDictionary:responseDictionary];
        
        NSMutableArray <LFMTrack *> *tracks = [NSMutableArray array];
        
        NSDictionary *trackMatchesDictionary = [responseDictionary objectForKey:@"trackmatches"];
        
        for (NSDictionary *trackDictionary in [trackMatchesDictionary objectForKey:@"track"]) {
            LFMTrack *track = [[LFMTrack alloc] initFromDictionary:trackDictionary];
            if (track) [tracks addObject:track];
        }
        
        block(tracks, searchQuery, error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)scrobbleTracks:(NSArray<LFMScrobbleTrack *> *)tracks callback:(nullable LFMErrorCallback)block {
    NSAssert(tracks.count <= 50, @"There is a a maximum of 50 scrobbles per batch.");
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSMutableArray *queryItems = [NSMutableArray arrayWithArray:@[
                            [NSURLQueryItem queryItemWithName:@"method" value:@"track.scrobble"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey],
                            [NSURLQueryItem queryItemWithName:@"sk" value:[LFMSession sharedSession].sessionKey]]];
    
    [tracks enumerateObjectsUsingBlock:^(LFMScrobbleTrack * _Nonnull track, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURLQueryItem *artistItem = [NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"artist[%tu]", idx] value:track.artist.name];
        NSURLQueryItem *trackItem = [NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"track[%tu]", idx] value:track.name];
        NSURLQueryItem *timestampItem = [NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"timestamp[%tu]", idx] value: [NSString stringWithFormat:@"%f", track.timestamp.timeIntervalSinceReferenceDate]];
        NSURLQueryItem *albumItem = [NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"album[%tu]", idx] value:track.album.name];
        NSURLQueryItem *chosenByUserItem = [NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"chosenByUser[%tu]", idx] value:[NSString stringWithFormat:@"%d", track.wasChosenByUser]];
        NSURLQueryItem *positionInAlbumItem = [NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"trackNumber[%tu]", idx] value:[NSString stringWithFormat:@"%tu", track.positionInAlbum]];
        NSURLQueryItem *mbidItem = [NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"mbid[%tu]", idx] value:track.mbid];
        NSURLQueryItem *durationItem = [NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"duration[%tu]", idx] value:[NSString stringWithFormat:@"%tu", track.duration]];
        
        [queryItems addObjectsFromArray:@[artistItem, trackItem, timestampItem, albumItem, chosenByUserItem, positionInAlbumItem, mbidItem, durationItem]];
    }];
    
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

+ (NSURLSessionDataTask *)getTracksSimilarToTrackNamed:(NSString *)trackName
                                         byArtistNamed:(NSString *)artistName
                                     withMusicBrainzId:(NSString *)mbid
                                           autoCorrect:(BOOL)autoCorrect
                                                 limit:(nullable NSNumber *)limit
                                              callback:(LFMTracksCallback)block {
    NSAssert((trackName != nil && artistName != nil) || mbid != nil, @"Either the trackName and artistName or the mbid parameter must be set.");
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"track.getSimilar"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"track" value:trackName],
                            [NSURLQueryItem queryItemWithName:@"mbid" value:mbid],
                            [NSURLQueryItem queryItemWithName:@"autocorrect" value:[NSString stringWithFormat:@"%d", autoCorrect]],
                            [NSURLQueryItem queryItemWithName:@"limit" value:[NSString stringWithFormat:@"%u", limit.unsignedIntValue]],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(@[], error);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSMutableArray<LFMTrack *> *tracks = [NSMutableArray array];
        
        if ((responseDictionary = [responseDictionary objectForKey:@"similartracks"])) {
            responseDictionary = [responseDictionary objectForKey:@"track"];
        }
        
        for (NSDictionary *trackDictionary in responseDictionary) {
            LFMTrack *track = [[LFMTrack alloc] initFromDictionary:trackDictionary];
            if (track) [tracks addObject:track];
        }
        
        block(tracks, error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getInfoOnTrackNamed:(NSString *)trackName
                                byArtistNamed:(NSString *)artistName
                            withMusicBrainzId:(NSString *)mbid
                                  autoCorrect:(BOOL)autoCorrect
                                      forUser:(NSString *)username
                                     callback:(LFMTrackCallback)block {
    NSAssert((trackName != nil && artistName != nil) || mbid != nil, @"Either the trackName and artistName or the mbid parameter must be set.");
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"track.getInfo"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"track" value:trackName],
                            [NSURLQueryItem queryItemWithName:@"mbid" value:mbid],
                            [NSURLQueryItem queryItemWithName:@"autocorrect" value:[NSString stringWithFormat:@"%d", autoCorrect]],
                            [NSURLQueryItem queryItemWithName:@"username" value:username],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(nil, error);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        LFMTrack *track = [[LFMTrack alloc] initFromDictionary:[responseDictionary objectForKey:@"track"]];
        
        block(track, error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getCorrectionForMisspelledTrackNamed:(NSString *)trackName
                                     withMisspelledArtistNamed:(NSString *)artistName
                                                      callback:(LFMTrackCallback)block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"track.getCorrection"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"track" value:trackName],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(nil, error);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if ((responseDictionary = [responseDictionary objectForKey:@"corrections"])) {
            responseDictionary = [responseDictionary objectForKey:@"correction"];
        }
        
        LFMTrack *track = [[LFMTrack alloc] initFromDictionary:[responseDictionary objectForKey:@"track"]];
        
        block(track, error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)addTags:(NSArray<LFMTag *> *)tags
                     toTrackNamed:(NSString *)trackName
                    byArtistNamed:(NSString *)artistName
                         callback:(nullable LFMErrorCallback)block {
    NSAssert(tags.count <= 10, @"This method call accepts a maximum of 10 tags.");
    
    NSMutableString *tagString = [NSMutableString string];
    [tags enumerateObjectsUsingBlock:^(LFMTag * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tagString appendFormat:@"%@%@", (idx == 0 ? @"" : @","), obj.name];
    }];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"track.addTags"],
                            [NSURLQueryItem queryItemWithName:@"track" value:trackName],
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
                     fromTrackNamed:(NSString *)trackName
                      byArtistNamed:(NSString *)artistName
                           callback:(nullable LFMErrorCallback)block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"track.removeTag"],
                            [NSURLQueryItem queryItemWithName:@"track" value:trackName],
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

+ (NSURLSessionDataTask *)getTagsForTrackNamed:(NSString *)trackName
                                 byArtistNamed:(NSString *)artistName
                             withMusicBrainzId:(NSString *)mbid
                                   autoCorrect:(BOOL)autoCorrect
                                       forUser:(NSString *)username
                                      callback:(LFMTagsCallback)block {
    NSAssert([LFMSession sharedSession].sessionKey != nil || username != nil, @"The user either: must be authenticated, or the `username` parameter must be set.");
    
    NSAssert((trackName != nil && artistName != nil) || (mbid != nil), @"Either the trackName and the artistName or the mbid parameter must be set.");
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"track.getTags"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"track" value:trackName],
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
            block(@[], error);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSMutableArray <LFMTag *> *tags = [NSMutableArray array];
        
        for (NSDictionary *tagDictionary in [responseDictionary objectForKey:@"tags"]) {
            LFMTag *tag = [[LFMTag alloc] initFromDictionary:tagDictionary];
            if (tag) [tags addObject:tag];
        }
        
        block(tags, error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)getTopTagsForTrackNamed:(NSString *)trackName
                                    byArtistNamed:(NSString *)artistName
                                withMusicBrainzId:(NSString *)mbid
                                      autoCorrect:(BOOL)autoCorrect
                                         callback:(LFMTopTagsCallback)block {
    NSAssert((trackName != nil && artistName != nil) || (mbid != nil), @"Either the trackName and the artistName or the mbid parameter must be set.");
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:APIEndpoint];
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"track.getTopTags"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"track" value:trackName],
                            [NSURLQueryItem queryItemWithName:@"artist" value:artistName],
                            [NSURLQueryItem queryItemWithName:@"mbid" value:mbid],
                            [NSURLQueryItem queryItemWithName:@"autocorrect" value:[NSString stringWithFormat:@"%d", autoCorrect]],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:[LFMAuth sharedInstance].apiKey]];
    
    components.queryItems = queryItems;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || !lfm_error_validate(data, &error) || !http_error_validate(response, &error)) {
            block(@[], error);
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSMutableArray <LFMTopTag *> *tags = [NSMutableArray array];
        
        NSDictionary *topTagsDictionary = [responseDictionary objectForKey:@"toptags"];
        
        for (NSDictionary *tagDictionary in [topTagsDictionary objectForKey:@"tag"]) {
            LFMTopTag *tag = [[LFMTopTag alloc] initFromDictionary:tagDictionary];
            if (tag) [tags addObject:tag];
        }
        
        block(tags, error);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

@end
