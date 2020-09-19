//
//  LFMScrobbleResult.h
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

NS_ASSUME_NONNULL_BEGIN

/**
 This class represents the result obtained from scrobbling a track.
 */
NS_SWIFT_NAME(ScrobbleResult)
@interface LFMScrobbleResult : NSObject <NSSecureCoding>

/** The date and time at which the scrobble was @b sent to the API.  */
@property(strong, nonatomic, readonly) NSDate *scrobbledDate;

/** The name that the track was scrobbled as. */
@property(strong, nonatomic, readonly) NSString *trackName;

/** The name that the artist was scrobbled as. */
@property(strong, nonatomic, readonly) NSString *artistName;

/** The name that the album was scrobbled as. */
@property(strong, nonatomic, readonly, nullable) NSString *albumName;

/** The name that the album artist was scrobbled as. */
@property(strong, nonatomic, readonly, nullable) NSString *albumArtistName;

/** Will be `YES` if the API matched the original track name to the closest corresponding one in the last.fm database, `NO` otherwise. */
@property(nonatomic, readonly, getter=wasTrackCorrected) BOOL trackCorrected;

/** Will be `YES` if the API matched the original artist name to the closest corresponding one in the last.fm database, `NO` otherwise. */
@property(nonatomic, readonly, getter=wasArtistCorrected) BOOL artistCorrected;

/** Will be `YES` if the API matched the original album name to the closest corresponding one in the last.fm database, `NO` otherwise. */
@property(nonatomic, readonly, getter=wasAlbumCorrected) BOOL albumCorrected;

/** Will be `YES` if the API matched the original album artist name to the closest corresponding one in the last.fm database, `NO` otherwise. */
@property(nonatomic, readonly, getter=wasAlbumArtistCorrected) BOOL albumArtistCorrected;

/** The reason why the scrobble was rejected from the API, if there was one. */
@property(strong, nonatomic, readonly, nullable) NSError *ignoredError;

/** Will be `YES` if the API rejected the scrobble, or `NO` otherwise. More detailed information about the error can be found by querying the `ignoredError` parameter. */
@property(nonatomic, readonly, getter=wasIgnored) BOOL ignored;

@end

NS_ASSUME_NONNULL_END
