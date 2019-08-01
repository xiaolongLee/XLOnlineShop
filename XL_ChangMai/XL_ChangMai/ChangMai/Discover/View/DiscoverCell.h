//
//  DiscoverCell.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/1.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DiscoverCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imagView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
/**  数据源 */
@property (nonatomic,strong) NSDictionary *dataDict;
@end

NS_ASSUME_NONNULL_END
