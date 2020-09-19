//
//  LFMKit.h
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

FOUNDATION_EXPORT double LastFMKitVersionNumber;
FOUNDATION_EXPORT const unsigned char LastFMKitVersionString[];

#pragma mark - Models

#import <LastFMKit/LFMURLOperation.h>
#import <LastFMKit/LFMTimePeriod.h>
#import <LastFMKit/LFMTaggingType.h>
#import <LastFMKit/LFMUserGender.h>
#import <LastFMKit/LFMImageSize.h>
#import <LastFMKit/LFMArtist.h>
#import <LastFMKit/LFMUser.h>
#import <LastFMKit/LFMTrack.h>
#import <LastFMKit/LFMScrobbleTrack.h>
#import <LastFMKit/LFMScrobbleResult.h>
#import <LastFMKit/LFMTag.h>
#import <LastFMKit/LFMTopTag.h>
#import <LastFMKit/LFMWiki.h>
#import <LastFMKit/LFMAlbum.h>
#import <LastFMKit/LFMQuery.h>
#import <LastFMKit/LFMSearchQuery.h>
#import <LastFMKit/LFMChart.h>

#pragma mark - Methods

#import <LastFMKit/LFMAlbumProvider.h>
#import <LastFMKit/LFMArtistProvider.h>
#import <LastFMKit/LFMChartProvider.h>
#import <LastFMKit/LFMGeoProvider.h>
#import <LastFMKit/LFMLibraryProvider.h>
#import <LastFMKit/LFMTagProvider.h>
#import <LastFMKit/LFMTrackProvider.h>
#import <LastFMKit/LFMUserProvider.h>

#pragma mark - Authentication

#import <LastFMKit/LFMSession.h>
#import <LastFMKit/LFMAuth.h>
