//
//  CMMemberCell.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/19.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMMemberCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (CGFloat)cellHeight;
- (void)reloadCollectionData;
@end

NS_ASSUME_NONNULL_END
