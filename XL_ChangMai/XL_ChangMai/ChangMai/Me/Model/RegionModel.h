//
//  RegionModel.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/5.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegionModel : NSObject
/** agencyId */
@property (nonatomic,strong) NSNumber * agencyId;
/** 父地区Id */
@property (nonatomic,strong) NSNumber * parentId;
/** 地区Id */
@property (nonatomic,strong) NSNumber * regionId;
/** 地区名字 */
@property (nonatomic,copy) NSString * regionName;
/** regionType */
@property (nonatomic,strong) NSNumber * regionType;

+(NSMutableArray *)getArrayWithArray:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
