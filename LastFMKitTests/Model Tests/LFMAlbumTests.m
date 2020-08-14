//
//  LFMAlbumTests.m
//  LastFMKitTests
//
//  Copyright (c) 2020 Mark Bourke
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
//  THE SOFTWARE.
//

#import <LastFMKit/LastFMKit.h>
#import <LastFMKit/LFMKit+Protected.h>
#import <XCTest/XCTest.h>

@interface LFMAlbumTests : XCTestCase

@end

@implementation LFMAlbumTests


- (void)testInitValidJSON_ShouldSucceed {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    LFMTrack *track = album.tracks.firstObject;
    LFMArtist *artist = track.artist;
    LFMTag *tag = album.tags.firstObject;
    LFMWiki *wiki = album.wiki;
    
    XCTAssertNotNil(album);
    
    XCTAssertTrue([album.name isEqualToString:@"My Everything"]);
    XCTAssertTrue([album.artist isEqualToString:@"Ariana Grande"]);
    XCTAssertTrue([album.URL.absoluteString isEqualToString:@"https://www.last.fm/music/Ariana+Grande/My+Everything"]);
    
    XCTAssertTrue([[album.images objectForKey:LFMImageSizeSmall].absoluteString isEqualToString:@"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png"]);
    XCTAssertTrue([[album.images objectForKey:LFMImageSizeMedium].absoluteString isEqualToString:@"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png"]);
    XCTAssertTrue([[album.images objectForKey:LFMImageSizeLarge].absoluteString isEqualToString:@"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png"]);
    XCTAssertTrue([[album.images objectForKey:LFMImageSizeExtraLarge].absoluteString isEqualToString:@"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png"]);
    XCTAssertTrue([[album.images objectForKey:LFMImageSizeMega].absoluteString isEqualToString:@"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png"]);
    
    XCTAssertTrue([album.mbid isEqualToString:@"92402a00-7be5-4c40-ac27-cf91622e2e5a"]);
    XCTAssertEqual(album.listeners.intValue, 191285);
    XCTAssertEqual(album.playCount.intValue, 4990556);
    
    XCTAssertEqual(album.tracks.count, 1);
    
    XCTAssertNotNil(track);
    
    XCTAssertTrue([track.name isEqualToString:@"Intro"]);
    XCTAssertTrue([track.URL.absoluteString isEqualToString:@"https://www.last.fm/music/Ariana+Grande/_/Intro"]);
    XCTAssertEqual(track.duration.intValue, 80);
    XCTAssertEqual(track.positionInAlbum.intValue, 1);
    XCTAssertEqual(track.streamable, YES);
    
    XCTAssertNotNil(artist);
    
    XCTAssertTrue([artist.name isEqualToString:@"Ariana Grande"]);
    XCTAssertTrue([artist.mbid isEqualToString:@"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387"]);
    XCTAssertTrue([artist.URL.absoluteString isEqualToString:@"https://www.last.fm/music/Ariana+Grande"]);
    
    XCTAssertEqual(album.tags.count, 1);
    
    XCTAssertTrue([tag.name isEqualToString:@"2014"]);
    XCTAssertTrue([tag.URL.absoluteString isEqualToString:@"https://www.last.fm/tag/2014"]);
    
    XCTAssertTrue([wiki.summary isEqualToString:@"Test summary"]);
    XCTAssertTrue([wiki.content isEqualToString:@"Test content"]);
    
    NSDateComponents *dateComponents = [NSDateComponents new];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [dateComponents setYear:2014];
    [dateComponents setMonth:7];
    [dateComponents setDay:10];
    [dateComponents setHour:23];
    [dateComponents setMinute:23];
    
    XCTAssertTrue([wiki.publishedDate isEqualToDate:[calendar dateFromComponents:dateComponents]]);
}

- (void)testInitEmptyDictionary_ShouldFail {
    NSDictionary *dictionary = [NSDictionary new];
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    
    XCTAssertNil(album);
}

- (void)testInitEmptyJSON_ShouldFail {
    NSString *json = @"{ \"albums\": {} }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:[dictionary objectForKey:@"albums"]];
    
    XCTAssertNil(album);
}

- (void)testInitNullJSON_ShouldFail {
    NSString *json = @"{ \"albums\": null }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:[dictionary objectForKey:@"albums"]];
    
    XCTAssertNil(album);
}

- (void)testInitNoName_ShouldFail {
    NSString *json =
    @"{ \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    
    XCTAssertNil(album);
}

- (void)testInitNullName_ShouldFail {
    NSString *json =
    @"{ \
        \"name\": null, \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    
    XCTAssertNil(album);
}

- (void)testInitNoArtist_ShouldFail {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    
    XCTAssertNil(album);
}

- (void)testInitNullArtist_ShouldFail {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": null, \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    
    XCTAssertNil(album);
}

- (void)testInitNoMBID_ShouldFail {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    
    XCTAssertNil(album);
}

- (void)testInitNullMBID_ShouldFail {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": null, \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    
    XCTAssertNil(album);
}

- (void)testInitNoURL_ShouldFail {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    
    XCTAssertNil(album);
}

- (void)testInitNullURL_ShouldFail {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": null, \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    
    XCTAssertNil(album);
}

- (void)testInitNoImages_ShouldSucceed_WithEmptyImages {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    
    XCTAssertNotNil(album);
    XCTAssertNotNil(album.images);
    XCTAssertEqual(album.images.count, 0);
}

- (void)testInitNullImages_ShouldSucceed_WithEmptyImages {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": null, \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    
    XCTAssertNotNil(album);
    XCTAssertNotNil(album.images);
    XCTAssertEqual(album.images.count, 0);
}

- (void)testInitNoListeners_ShouldSucceed_WithZeroListeners {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    
    XCTAssertNotNil(album);
    XCTAssertEqual(album.listeners.intValue, 0);
}

- (void)testInitNullListeners_ShouldSucceed_WithZeroListeners {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": null, \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    
    XCTAssertNotNil(album);
    XCTAssertEqual(album.listeners.intValue, 0);
}

- (void)testInitNoPlayCount_ShouldSucceed_WithZeroPlayCount {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    
    XCTAssertNotNil(album);
    XCTAssertEqual(album.playCount.intValue, 0);
}

- (void)testInitNullPlayCount_ShouldSucceed_WithZeroPlayCount {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": null, \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    
    XCTAssertNotNil(album);
    XCTAssertEqual(album.playCount.intValue, 0);
}

- (void)testInitNoTracks_ShouldSucceed_WithEmptyTracks {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    
    XCTAssertNotNil(album.tracks);
    XCTAssertEqual(album.tracks.count, 0);
}

- (void)testInitNullTracks_ShouldSucceed_WithEmptyTracks {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": null, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    
    XCTAssertNotNil(album.tracks);
    XCTAssertEqual(album.tracks.count, 0);
}

- (void)testInitTracksNoName_ShouldSucceed_WithEmptyTracks {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    
    XCTAssertNotNil(album.tracks);
    XCTAssertEqual(album.tracks.count, 0);
}

- (void)testInitTracksNoURL_ShouldSucceed_WithEmptyTracks {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    
    XCTAssertNotNil(album.tracks);
    XCTAssertEqual(album.tracks.count, 0);
}

- (void)testInitTracksNoArtist_ShouldSucceed_WithTracksWithNullArtist {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": null \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    LFMTrack *track = album.tracks.firstObject;
    LFMArtist *artist = track.artist;
    
    XCTAssertNotNil(track);
    
    XCTAssertTrue([track.name isEqualToString:@"Intro"]);
    XCTAssertTrue([track.URL.absoluteString isEqualToString:@"https://www.last.fm/music/Ariana+Grande/_/Intro"]);
    XCTAssertEqual(track.duration.intValue, 80);
    XCTAssertEqual(track.positionInAlbum.intValue, 1);
    XCTAssertEqual(track.streamable, YES);
    
    XCTAssertNil(artist);
}

- (void)testInitTracksNoStreamable_ShouldSucceed_WithTracksWithFalseStreamable {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": null, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    LFMTrack *track = album.tracks.firstObject;
    LFMArtist *artist = track.artist;
    
    XCTAssertNotNil(track);
    
    XCTAssertTrue([track.name isEqualToString:@"Intro"]);
    XCTAssertTrue([track.URL.absoluteString isEqualToString:@"https://www.last.fm/music/Ariana+Grande/_/Intro"]);
    XCTAssertEqual(track.duration.intValue, 80);
    XCTAssertEqual(track.positionInAlbum.intValue, 1);
    XCTAssertEqual(track.streamable, NO);
    
    XCTAssertNotNil(artist);
    
    XCTAssertTrue([artist.name isEqualToString:@"Ariana Grande"]);
    XCTAssertTrue([artist.mbid isEqualToString:@"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387"]);
    XCTAssertTrue([artist.URL.absoluteString isEqualToString:@"https://www.last.fm/music/Ariana+Grande"]);
}

- (void)testInitTracksNoRank_ShouldSucceed_WithTracksWithZeroPositionInAlbum {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": null, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    LFMTrack *track = album.tracks.firstObject;
    LFMArtist *artist = track.artist;
    
    XCTAssertNotNil(track);
    
    XCTAssertEqual(track.positionInAlbum.intValue, 0);
    XCTAssertTrue([track.name isEqualToString:@"Intro"]);
    XCTAssertTrue([track.URL.absoluteString isEqualToString:@"https://www.last.fm/music/Ariana+Grande/_/Intro"]);
    XCTAssertEqual(track.duration.intValue, 80);
    XCTAssertEqual(track.streamable, YES);
    
    XCTAssertNotNil(artist);
    
    XCTAssertTrue([artist.name isEqualToString:@"Ariana Grande"]);
    XCTAssertTrue([artist.mbid isEqualToString:@"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387"]);
    XCTAssertTrue([artist.URL.absoluteString isEqualToString:@"https://www.last.fm/music/Ariana+Grande"]);
}

- (void)testInitNoTags_ShouldSucceed_WithEmptyTags {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    
    XCTAssertNotNil(album.tags);
    XCTAssertEqual(album.tags.count, 0);
}

- (void)testInitNullTags_ShouldSucceed_WithEmptyTags {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": null, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    
    XCTAssertNotNil(album.tags);
    XCTAssertEqual(album.tags.count, 0);
}

- (void)testInitTagsNoURL_ShouldSucceed_WithNullURL {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    LFMTag *tag = album.tags.firstObject;
    
    XCTAssertNotNil(tag);
    XCTAssertTrue([tag.name isEqualToString:@"2014"]);
}

- (void)testInitTagsNoName_ShouldSucceed_WithEmptyTags {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": { \
          \"published\": \"10 Jul 2014, 23:23\", \
          \"summary\": \"Test summary\", \
          \"content\": \"Test content\" \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    
    XCTAssertNotNil(album.tags);
    XCTAssertEqual(album.tags.count, 0);
}

- (void)testInitNoWiki_ShouldSucceed_WithNullWiki {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        } \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    LFMWiki *wiki = album.wiki;

    XCTAssertNil(wiki);
}

- (void)testInitNullWiki_ShouldSucceed_WithNullWiki {
    NSString *json =
    @"{ \
        \"name\": \"My Everything\", \
        \"artist\": \"Ariana Grande\", \
        \"mbid\": \"92402a00-7be5-4c40-ac27-cf91622e2e5a\", \
        \"url\": \"https://www.last.fm/music/Ariana+Grande/My+Everything\", \
        \"image\": [ \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"small\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"medium\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"large\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"extralarge\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"mega\" \
          }, \
          { \
            \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/ae14e61c8523c955cc3482dac6f56973.png\", \
            \"size\": \"\" \
          } \
        ], \
        \"listeners\": \"191285\", \
        \"playcount\": \"4990556\", \
        \"userplaycount\": \"0\", \
        \"tracks\": { \
          \"track\": [ \
            { \
              \"name\": \"Intro\", \
              \"url\": \"https://www.last.fm/music/Ariana+Grande/_/Intro\", \
              \"duration\": \"80\", \
              \"@attr\": { \
                \"rank\": \"1\" \
              }, \
              \"streamable\": { \
                \"#text\": \"1\", \
                \"fulltrack\": \"1\" \
              }, \
              \"artist\": { \
                \"name\": \"Ariana Grande\", \
                \"mbid\": \"f4fdbb4c-e4b7-47a0-b83b-d91bbfcfa387\", \
                \"url\": \"https://www.last.fm/music/Ariana+Grande\" \
              } \
            } \
          ] \
        }, \
        \"tags\": { \
          \"tag\": [ \
            { \
              \"name\": \"2014\", \
              \"url\": \"https://www.last.fm/tag/2014\" \
            } \
          ] \
        }, \
        \"wiki\": null \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:dictionary];
    LFMWiki *wiki = album.wiki;
    
    XCTAssertNil(wiki);
}

@end
