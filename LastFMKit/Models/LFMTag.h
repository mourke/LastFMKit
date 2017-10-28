//
//  LFMTag.h
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

#import <Foundation/Foundation.h>

@class LFMWiki;

NS_ASSUME_NONNULL_BEGIN

/**
 This class represents the Last.fm tag object.
 */
NS_SWIFT_NAME(Tag)
@interface LFMTag : NSObject

/** The name of the tag. */
@property(strong, nonatomic, readonly) NSString *name;

/** The Last.fm URL for the tag. Eg. "http://www.last.fm/tag/swedish". */
@property(strong, nonatomic, readonly, nullable) NSURL *URL NS_SWIFT_NAME(url);

/** The reach of the tag this month. */
@property(nonatomic, readonly) unsigned int reach;

/** The total reach of the tag. */
@property(nonatomic, readonly) unsigned int total;

/** A boolean value indicating whether this tag is streamable. */
@property(nonatomic, readonly, getter=isStreamable) BOOL streamable;

/** A small amount of information about the tag. */
@property(strong, nonatomic, readonly, nullable) LFMWiki *wiki;

/**
 Initialises a new `LFMTag` object - used for creating custom tags. The name parameter is the only parameter available because custom tags do not exist natively on Last.fm and therefore do not have any other Last.fm defined properties.
 
 @param tagName The name of the tag.
 
 @returns   An `LFMTag` object.
 */
- (instancetype)initWithName:(NSString *)tagName;

/**
 Initialises a new `LFMTag` object - used for creating custom tags. The name parameter is the only parameter available because custom tags do not exist natively on Last.fm and therefore do not have any other Last.fm defined properties.
 
 @param tagName The name of the tag.
 
 @returns   An `LFMTag` object.
 */
+ (instancetype)tagWithName:(NSString *)tagName NS_SWIFT_UNAVAILABLE("Please use `init(name:)` instead.");

- (instancetype) __unavailable init;
+ (instancetype) __unavailable new;

@end

NS_ASSUME_NONNULL_END
