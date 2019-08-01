//
//  UUID.m
//  ALLSTAR
//
//  Created by 贾俊南 on 15/11/7.
//  Copyright (c) 2015年 LG. All rights reserved.
//

#import "UUID.h"
#import "SSKeychain.h"
@implementation UUID

+(NSString*)getUUID
{
   NSString *UUID = [SSKeychain passwordForService:__kUUID account:__kUUID];
    if (UUID.length == 0) {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        NSString *uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidRef));
        [SSKeychain setPassword:uuid forService:__kUUID account:__kUUID];
        return uuid;
    }
    return UUID;
}

@end
