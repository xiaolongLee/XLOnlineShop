//
//  MyDate.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/7.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "MyDate.h"

@implementation MyDate
/**
 *    获取现在的时间 格式 年月日
 */
+(NSString*)getDateNow
{
    return  [self getDateNowWithFormat:@"yyyy-MM-dd"];
}
+(NSString *)getDateNowWithFormat:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}


/**
 *    获取现在的时间戳
 */
+(NSString *)getTimeNow
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f",a];
    return timeString;
}

+(NSInteger)GetTimestampOfNow
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [date timeIntervalSince1970];
    return a;
}

/**
 *    根据 时间戳 获取日期
 */
+(NSString *)getDateWithTimeStamp:(id)interval
{
    return  [self getDateWithTimeStamp:interval WithFormat:@"yyyy-MM-dd"];
}
/**
 *   自定义格式 根据 时间戳 获取时间
 */
+(NSString *)getDateWithTimeStamp:(id )interval WithFormat:(NSString *)format
{
    NSTimeInterval time = [interval doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
}

/**
 *   自定义格式 根据 时间戳 获取时间
 */
+(NSString *)getCustomDateWithTimeStamp:(id )interval WithFormat:(NSString *)format
{
    NSTimeInterval time = [interval doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval interValTime = nowTime - time;
    //    NSLog(@"time:%f \n nowTime:%f \n interval:%f",time,nowTime,nowTime - time);
    if (interValTime < 60) {
        return @"刚刚";
    }else if (interValTime < 60*60){
        return [NSString stringWithFormat:@"%0.0d分钟前",(int)interValTime/60];
    }else if (interValTime < 60*60*24){
        return [NSString stringWithFormat:@"%0.0d小时前",(int)interValTime/(60*60)];
    }else if (interValTime < 60*60*24*2){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
        return [NSString stringWithFormat:@"昨天 %@",currentDateStr];
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:format];
        NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
        return currentDateStr;
    }
    
}

/**
 *    获取 day 天后的日期
 */
+(NSString *)getDateAfter:(NSInteger)day
{
    return [self getDateAfter:day WithFormat:@"yyyy-MM-dd"];
}
/**
 *   根据自定义格式 获取 day 天后的日期
 */
+(NSString *)getDateAfter:(NSInteger)day WithFormat:(NSString *)format
{
    NSString *timeStamp = [NSString stringWithFormat:@"%ld",[[self getTimeNow] integerValue] + day * 3600 * 24];
    return  [self getDateWithTimeStamp:timeStamp WithFormat:format];
}


#warning TODO

/**
 *   根据自定义格式 获取 n 小时后的日期
 */
+(NSDate *)getDateWithHourAfter:(NSInteger)hour WithFormat:(NSString *)format
{
    NSTimeInterval want = [self GetTimestampOfNow] + hour * 3600;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:want];
    return date;
}
/**
 *   根据自定义格式 获取 n 小时后的日期
 */
+(NSString *)getDateStringWithHourAfter:(NSInteger)hour WithFormat:(NSString *)format
{
    NSTimeInterval want = [self GetTimestampOfNow] + hour * 3600;
    return [self getDateWithTimeStamp:@(want) WithFormat:format];
}



/** 根据 日期字符串 获取 日期 */
+(NSDate *)getDateWithString:(NSString *)str
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:str];
    return date;
}

/** 根据 日期字符串 获取时间戳 */
+(NSString *)getTimeStampWithStr:(NSString *)str
{
    NSDate *date = [self getDateWithString:str];
    NSTimeInterval a = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f",a];
    return timeString;
}

@end
