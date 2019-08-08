//
//  CMCommentCell.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/8.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMCommentCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (CGFloat)cellHeightWith:(NSDictionary *)dataDict;
/**  数据源 */
@property (nonatomic,strong) NSDictionary *dataDict;
@end

NS_ASSUME_NONNULL_END
