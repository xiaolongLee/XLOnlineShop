//
//  ButtonsAlertView.h
//  AlertViewTestDemo
//
//  Created by 劉光軍 on 16/4/1.//

#import "AbstractAlertView.h"


@interface ButtonsAlertView : AbstractAlertView
+ (void)showWithMessage:(NSString *)message delegate:(id)delegate buttonTitles:(NSArray *)buttons;
+ (AbstractAlertView *)buttonsAlertViewWithMessage:(NSString *)message delegate:(id)delegate buttonTitles:(NSArray *)buttons;
+(void)showWithMessage:(NSString *)message otherButtonItems:(NSArray<RIButtonItem *>*)inButtonItems;
@end
