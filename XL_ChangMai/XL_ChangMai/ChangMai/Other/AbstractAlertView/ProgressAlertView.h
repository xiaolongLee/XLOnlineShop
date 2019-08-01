//
//  ProgressAlertView.h
//  ALLSTAR
//
//  Created by Bcc on 8/25/16.
//  Copyright © 2016 JJN. All rights reserved.
//

#import "AbstractAlertView.h"

@interface ProgressAlertView : AbstractAlertView
+ (void)showWithMessage:(NSString *)message;
+ (void)hideHUD;
@end
