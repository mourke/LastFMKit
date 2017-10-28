//
//  LFMAuth.m
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

#import "LFMAuth.h"
#import <CommonCrypto/CommonDigest.h>
#import "LFMSession.h"
#import "LFMKit+Protected.h"
#import "LFMError.h"

@implementation LFMAuth {
    LFMSession *_session;
}

+ (LFMAuth *)sharedInstance {
    static LFMAuth *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        sharedInstance = [[LFMAuth alloc] performSelector:NSSelectorFromString(@"init")]; // Initialiser is private.
#pragma clang diagnostic pop
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    if (self)  {
        [self setSession:[LFMSession loadFromKeychain]];
    }
    
    return self;
}

- (BOOL)removeSession {
    if ([_session removeFromKeychain]) {
        _session = nil;
        return YES;
    }
    return NO;
}

- (void)setSession:(LFMSession *)session {
    _session = session;
    [session saveInKeychain];
}

- (LFMSession *)session {
    return _session;
}

- (NSURLSessionDataTask *)getSessionWithUsername:(NSString *)username
                                        password:(NSString *)password
                                        callback:(LFMAuthCallback)block {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ws.audioscrobbler.com/2.0"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    
    NSArray *queryItems = @[[NSURLQueryItem queryItemWithName:@"method" value:@"auth.getMobileSession"],
                            [NSURLQueryItem queryItemWithName:@"format" value:@"json"],
                            [NSURLQueryItem queryItemWithName:@"username" value:username],
                            [NSURLQueryItem queryItemWithName:@"password" value:password],
                            [NSURLQueryItem queryItemWithName:@"api_key" value:self.apiKey]];
    components.queryItems = [self appendingSignatureItemToQueryItems:queryItems];
    
    NSData *data = [components.query dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    __weak __typeof__(self) weakSelf = self;
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil || data == nil) return block(error, nil);
        
        if (!lfm_error_validate(data, &error)) return block(error, nil);
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        LFMSession *session = [[LFMSession alloc] initFromDictionary:[responseDictionary objectForKey:@"session"]];
        [weakSelf setSession:session];
        
        block(error, session);
    }];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLQueryItem *)signatureItemForQueryItems:(NSArray<NSURLQueryItem *> *)queryItems {
    NSMutableString *signature = [NSMutableString string];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    for (NSURLQueryItem *item in queryItems) {
        if (item.value == nil) continue;
        if ([item.name isEqualToString:@"format"]) continue; // Format argument causes the api to regect the signature.
        parameters[item.name] = item.value;
    }
    
    NSArray *alphebetisedKeys = [[parameters allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for (NSString *key in alphebetisedKeys) {
        NSString *value = parameters[key];
        
        [signature appendFormat:@"%@%@", key, value];
    }
    
    [signature appendString:self.apiSecret];
    
    return [NSURLQueryItem queryItemWithName:@"api_sig" value:md5(signature)];
}

- (NSArray<NSURLQueryItem *> *)appendingSignatureItemToQueryItems:(NSArray<NSURLQueryItem *> *)queryItems {
    return [queryItems arrayByAddingObject:[self signatureItemForQueryItems:queryItems]];
}

- (NSString *)apiSecret {
    NSAssert(_apiSecret != nil, @"Shared secret must be set before any calls to this class are made.");
    return _apiSecret;
}

- (NSString *)apiKey {
    NSAssert(_apiKey != nil, @"API key must be set before any calls to this class are made.");
    return _apiKey;
}

NSString* md5(NSString *string) {
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
