//
//  LFMChart.m
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

#import "LFMChart.h"
#import "LFMKit+Protected.h"

@implementation LFMChart {
    NSDate *_startDate;
    NSDate *_endDate;
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self &&
        dictionary != nil &&
        [dictionary isKindOfClass:NSDictionary.class]) {
        id startDateInterval = [dictionary objectForKey:@"from"];
        id endDateInterval = [dictionary objectForKey:@"to"];
        
        if (startDateInterval != nil && [startDateInterval isKindOfClass:NSNumber.class] &&
            endDateInterval != nil && [endDateInterval isKindOfClass:NSNumber.class]) {
            _startDate = [NSDate dateWithTimeIntervalSince1970:[startDateInterval doubleValue]];
            _endDate = [NSDate dateWithTimeIntervalSince1970:[endDateInterval doubleValue]];
            
            return self;
        }
    }
    
    return nil;
}

- (NSDate *)startDate {
    return _startDate;
}

- (NSDate *)endDate {
    return _endDate;
}

@end
