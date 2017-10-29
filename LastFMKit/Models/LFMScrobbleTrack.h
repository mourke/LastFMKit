//
//  LFMScrobbleTrack.h
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
#import "LFMTrack.h"

NS_ASSUME_NONNULL_BEGIN

/**
 This class represents the Last.fm track object that is to be sent to the scrobbling api.
 */
NS_SWIFT_NAME(ScrobbleTrack)
@interface LFMScrobbleTrack : LFMTrack

/** The date at which the track started playing. */
@property(strong, nonatomic) NSDate *timestamp;

/** Will be `YES` if the user chose this song, or `NO` if the song was chosen by someone else (such as a radio station or recommendation service). */
@property(nonatomic, readonly, getter=wasChosenByUser) BOOL chosenByUser;

/**
 Initialises a new `LFMScrobbleTrack` object - used for scrobbling tracks to the Last.fm API.
 
 @param track           The `LFMTrack` object to be transformed.
 @param timestamp       The date at which the track started playing.
 @param chosenByUser    This parameter is used to indicate when a scrobble comes from a source that the user doesn't have "direct" control over. If the user is listening to music that is effectively chosen by someone other than themselves (e.g. from a Last.fm radio stream; from some other recommendation service; or radio show put together by a DJ or host) then this value should be set to `NO`, otherwise set it to `YES`.
 
 @return   An `LFMScrobbleTrack` object.
 */
- (instancetype)initFromTrack:(LFMTrack *)track withTimestamp:(NSDate *)timestamp chosenByUser:(BOOL)chosenByUser;

@end

NS_ASSUME_NONNULL_END
