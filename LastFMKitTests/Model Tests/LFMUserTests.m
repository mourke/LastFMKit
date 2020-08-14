//
//  LFMUserTests.m
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

@interface LFMUserTests : XCTestCase

@end

@implementation LFMUserTests

- (void)testInitValidJSON_ShouldSucceed {
    NSString *json =
    @"{ \
      \"playlists\": \"0\", \
      \"playcount\": \"5820\", \
      \"gender\": \"m\", \
      \"name\": \"markkbourke\", \
      \"subscriber\": \"0\", \
      \"url\": \"https://www.last.fm/user/markkbourke\", \
      \"country\": \"Ireland\", \
      \"image\": [ \
        { \
          \"size\": \"small\", \
          \"#text\": \"https://lastfm.freetls.fastly.net/i/u/34s/2ffed912723fabeb959b1bcef30e702d.png\" \
        }, \
        { \
          \"size\": \"medium\", \
          \"#text\": \"https://lastfm.freetls.fastly.net/i/u/64s/2ffed912723fabeb959b1bcef30e702d.png\" \
        }, \
        { \
          \"size\": \"large\", \
          \"#text\": \"https://lastfm.freetls.fastly.net/i/u/174s/2ffed912723fabeb959b1bcef30e702d.png\" \
        }, \
        { \
          \"size\": \"extralarge\", \
          \"#text\": \"https://lastfm.freetls.fastly.net/i/u/300x300/2ffed912723fabeb959b1bcef30e702d.png\" \
        } \
      ], \
      \"registered\": { \
        \"unixtime\": \"1401905471\", \
        \"#text\": 1401905471 \
      }, \
      \"type\": \"user\", \
      \"age\": \"25\", \
      \"bootstrap\": \"0\", \
      \"realname\": \"Mark Bourke\" \
    }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMUser *user = [[LFMUser alloc] initFromDictionary:dictionary];
    
    XCTAssertNotNil(user);
    
    XCTAssertEqual(user.playlistCount, 0);
    XCTAssertEqual(user.playCount, 5820);
    XCTAssertEqual(user.gender, LFMUserGenderMale);
    XCTAssertTrue([user.username isEqualToString:@"markkbourke"]);
    XCTAssertFalse(user.isSubscriber);
    XCTAssertTrue([user.URL.absoluteString isEqualToString:@"https://www.last.fm/user/markkbourke"]);
    XCTAssertTrue([user.country isEqualToString:@"Ireland"]);
    
    NSDateComponents *dateComponents = [NSDateComponents new];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [dateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateComponents setYear:2014];
    [dateComponents setMonth:6];
    [dateComponents setDay:4];
    [dateComponents setHour:18];
    [dateComponents setMinute:11];
    [dateComponents setSecond:11];
    
    XCTAssertTrue([user.dateRegistered isEqualToDate:[calendar dateFromComponents:dateComponents]]);
    
    XCTAssertEqual(user.age, 25);
    XCTAssertTrue([user.realName isEqualToString:@"Mark Bourke"]);
}

@end
