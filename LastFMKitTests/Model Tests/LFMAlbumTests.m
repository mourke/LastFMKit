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
    XCTAssertEqual(album.listeners, 191285);
    XCTAssertEqual(album.playCount, 4990556);
    
    XCTAssertEqual(album.tracks.count, 1);
    
    XCTAssertNotNil(track);
    
    XCTAssertTrue([track.name isEqualToString:@"Intro"]);
    XCTAssertTrue([track.URL.absoluteString isEqualToString:@"https://www.last.fm/music/Ariana+Grande/_/Intro"]);
    XCTAssertEqual(track.duration, 80);
    XCTAssertEqual(track.positionInAlbum, 1);
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

@end
