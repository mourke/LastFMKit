//
//  LFMUser.h
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

#import <Foundation/Foundation.h>
#import "LFMImageSize.h"
#import "LFMUserGender.h"

NS_ASSUME_NONNULL_BEGIN

/**
 This class represents the Last.fm user object.
 */
NS_SWIFT_NAME(User)
@interface LFMUser : NSObject <NSSecureCoding>

/** The alias the user chose upon signing up. */
@property(strong, nonatomic, readonly) NSString *username;

/** The user's real-life name. */
@property(strong, nonatomic, readonly) NSString *realName;

/** A dictionary of images of the user. All the images are the exact same only different sizes. */
@property(strong, nonatomic, readonly) NSDictionary<LFMImageSize, NSURL *> *images;

/** The Last.fm URL for the user. Eg. "http://www.last.fm/user/RJ" */
@property(strong, nonatomic, readonly) NSURL *URL NS_SWIFT_NAME(url);

/** The country in which the user currently resides. */
@property(strong, nonatomic, readonly) NSString *country;

/** The age of the user. */
@property(nonatomic, readonly) NSInteger age;

/** The user's gender. */
@property(nonatomic, readonly) LFMUserGender gender;

/** A boolean value indicating whether the user is a Last.fm paid subscriber or not.*/
@property(nonatomic, readonly, getter=isSubscriber) BOOL subscriber;

/** The amount of "scrobbles" (songs played) the user has. */
@property(nonatomic, readonly) NSInteger playCount;

/** The amount of playlists the user has currently in their library. */
@property(nonatomic, readonly) NSInteger playlistCount;

/** The date on which the user signed up for Last.fm */
@property(strong, nonatomic, readonly) NSDate *dateRegistered;

- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
