//
//  MyDate.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/7.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyDate : NSObject
/**
 *    获取现在日期 精确到 年月日
 */
+(NSString *)getDateNow;
/**
 *    根据自定义格式 获取现在日期 精确到 年月日
 */

+(NSString *)getDateNowWithFormat:(NSString *)format;

/**
 *   根据自定义格式 获取 n 小时后的日期
 */
+(NSDate *)getDateWithHourAfter:(NSInteger)hour WithFormat:(NSString *)format;
/**
 *   根据自定义格式 获取 n 小时后的日期字符串
 */
+(NSString *)getDateStringWithHourAfter:(NSInteger)hour WithFormat:(NSString *)format;
/**
 *    获取 day 天后的日期 精确到 年月日
 */
+(NSString *)getDateAfter:(NSInteger)day;
/**
 *   根据自定义格式 获取 day 天后的日期
 */
+(NSString *)getDateAfter:(NSInteger)day WithFormat:(NSString *)format;


/**
 *    获取现在的 时间戳(字符串)
 */
+(NSString *)getTimeNow;

/** 获取现在的时间戳 */
+(NSInteger)GetTimestampOfNow;

/**
 *    根据时间戳获取时间 精确到年月日
 */
+(NSString *)getDateWithTimeStamp:(id)interval;
/**
 *   自定义格式 根据时间戳 获取时间
 */
+(NSString *)getDateWithTimeStamp:(id )interval WithFormat:(NSString *)format;
/**
 *   自定义格式 根据时间戳 获取时间
 */
+(NSString *)getCustomDateWithTimeStamp:(id )interval WithFormat:(NSString *)format;

/** 根据 日期字符串 获取 日期 */
+(NSDate *)getDateWithString:(NSString *)str;

/** 根据 日期字符串 获取时间戳 */
+(NSString *)getTimeStampWithStr:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
