//
//  RegModel.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/23.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "RegModel.h"
static RegModel *_sharedRegModel;
@implementation RegModel

+(RegModel *)sharedRegModel {
    if (!_sharedRegModel) {
        _sharedRegModel = [[RegModel alloc] init];
    }
    
    return _sharedRegModel;
}

-(void)createEmpty
{
    self.username = @"";
    self.usid = @"";
    self.iconUrl = @"";
    self.sex = @"";
}

@end
