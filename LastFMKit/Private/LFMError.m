//
//  LFMError.m
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

#import "LFMError.h"

BOOL lfm_error_validate(NSData *responseData, NSError * *error) {
    NSError *_error;
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&_error];
    
    id errorMessage = [responseDictionary objectForKey:@"message"];
    id errorCode = [responseDictionary objectForKey:@"error"];
    
    if (errorMessage != nil && [errorMessage isKindOfClass:NSString.class] &&
        errorCode != nil && [errorCode isKindOfClass:NSNumber.class]) {
        _error = [NSError errorWithDomain:@"fm.last.kit.error"
                                     code:[errorCode integerValue]
                                 userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
    }
    
    if (error) { // check if user passed in an error param.
        *error = _error;
    }
    
    return _error == nil ? YES : NO; // must check _error instead of error as error could be nil if the user doesn't want the exact error message back.
}
