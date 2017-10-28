//
//  LFMWiki.m
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

#import "LFMWiki.h"

@implementation LFMWiki {
    NSDate *_publishedDate;
    NSString *_summary;
    NSString *_content;
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        NSString *dateString = [dictionary objectForKey:@"published"];
        NSString *summary = [dictionary objectForKey:@"summary"];
        NSString *content = [dictionary objectForKey:@"content"];
        
        if (dateString != nil && summary != nil && content != nil) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"DD MMM YYYY, HH:mm"];
            
            NSDate *date = [formatter dateFromString:dateString];
            
            _publishedDate = date == nil ? [NSDate distantPast] : date;
            _summary = summary;
            _content = content;
            
            return self;
        }
    }
    
    return nil;
}

- (NSDate *)publishedDate {
    return _publishedDate;
}

- (NSString *)summary {
    return _summary;
}

- (NSString *)content {
    return _content;
}

@end
