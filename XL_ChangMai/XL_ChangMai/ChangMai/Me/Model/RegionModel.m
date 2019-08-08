//
//  RegionModel.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/5.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "RegionModel.h"

@implementation RegionModel
+(NSMutableArray *)getArrayWithArray:(NSArray *)array
{
    NSMutableArray *listArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        RegionModel *model = [[RegionModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [listArray addObject:model];
    }
    return listArray;
}

@end
