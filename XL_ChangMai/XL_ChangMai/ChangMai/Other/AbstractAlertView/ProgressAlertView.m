//
//  ProgressAlertView.m
//  ALLSTAR
//
//  Created by Bcc on 8/25/16.
//  Copyright © 2016 JJN. All rights reserved.
//

#import "ProgressAlertView.h"
#import "POP.h"

#define topY 60
@interface ProgressAlertView()

@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *messageView;

@end

@implementation ProgressAlertView
+ (void)showWithMessage:(NSString *)message
{
    AbstractAlertView *alertView = [[ProgressAlertView alloc] init];
    alertView.message = message;
    alertView.contentView = [[UIApplication sharedApplication] keyWindow];
    alertView.autoHiden = NO;
    alertView.delayAutoHidenDuration = 1.5f;
    [alertView show];
}

+ (void)hideHUD
{
    UIView *keyView = [[UIApplication sharedApplication] keyWindow];
    AbstractAlertView *alertView = [self HUDForView:keyView];
    [alertView hide];
}


+ (instancetype)HUDForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (ProgressAlertView *)subview;
        }
    }
    return nil;
}



- (void)setContentView:(UIView *)contentView {
    
    CGRect contentViewFrame = contentView.frame;
    contentViewFrame = CGRectMake(0, topY, contentView.frame.size.width, contentView.frame.size.height - topY);
    
    self.frame = contentViewFrame;
    [super setContentView:contentView];
}

- (void)show {
    
    if (self.contentView) {
        [self.contentView addSubview:self];
        
        [self createBlackView];
        [self createMessageView];
        
        if (self.autoHiden) {
            [self performSelector:@selector(hide) withObject:nil afterDelay:self.delayAutoHidenDuration];
        }
    }
}

- (void)hide {
    
    if (self.contentView) {
        [self removeViews];
    }
}

- (void)createBlackView {
    
    //    self.blackView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    //    self.blackView.backgroundColor = [UIColor blackColor];
    //    self.blackView.alpha = 0;
    //    [self addSubview:self.blackView];
    //
    //    [UIView animateWithDuration:0.3f animations:^{
    //        self.blackView.alpha = 0.25f;
    //    }];
}

- (void)createMessageView {
    
    //创建信息label
    /*宽 根据6的屏宽比*/
    CGFloat textLabelWidth = [UIScreen mainScreen].bounds.size.width / 375.0 * (260);
    NSString *text = self.message;
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = text;
    textLabel.font =  [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.numberOfLines = 0;
    //    [textLabel sizeToFit];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = textLabel.font;
    CGSize maxSize = CGSizeMake(textLabelWidth, MAXFLOAT);
    CGSize textLabelSize = [textLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    textLabel.frame = CGRectMake(0, 0, textLabelSize.width, textLabelSize.height);
    
    
    
    
    //创建菊花
    
    CGFloat indicatorH = 40;
    CGFloat indicatorMargin = 20;
    CGFloat indicatorViewH = indicatorH + indicatorMargin;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.frame = CGRectMake(0, indicatorMargin, indicatorH, indicatorH);
    [indicator startAnimating];
    
    
    //创建信息窗体view
    CGFloat messageViewWidth = 0.0f;
    if (textLabel.frame.size.width < 90) {
        messageViewWidth = 90;
    }else{
        messageViewWidth = textLabel.frame.size.width;
    }
    self.messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, messageViewWidth + 30, textLabel.height + 30 + indicatorViewH)];
    self.messageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
    self.messageView.layer.cornerRadius = 5;
    self.messageView.layer.masksToBounds = YES;
    //    self.messageView.center = CGPointMake(self.contentView.frame.size.width/2, self.contentView.frame.size.height - self.messageView.frame.size.height/2 - 100);
    self.messageView.center = CGPointMake(self.contentView.frame.size.width/ 2.f, self.contentView.frame.size.height/ 2.f - topY);
    
    indicator.frame = CGRectMake(self.messageView.frame.size.width/2 - indicatorH/2, indicatorMargin, indicatorH, indicatorH);
    
    textLabel.center = CGPointMake(self.messageView.frame.size.width/2, self.messageView.frame.size.height/2 + indicatorViewH/2);
    
    self.messageView.alpha = 0.f;
    [self.messageView addSubview:indicator];
    [self.messageView addSubview:textLabel];
    [self addSubview:self.messageView];
    
    //执行动画
    POPBasicAnimation *alpha = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alpha.toValue = @(1.f);
    alpha.duration = 0.3f;
    [self.messageView pop_addAnimation:alpha forKey:nil];
    
//    POPSpringAnimation *scale = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    scale.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.75f, 1.75f)];
//    scale.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
//    scale.dynamicsTension = 1000;
//    scale.dynamicsMass = 1.3;
//    scale.dynamicsFriction = 10.3;
//    scale.springSpeed = 40;
//    scale.springBounciness = 15.64;
//    [self.messageView.layer pop_addAnimation:scale forKey:nil];
}

- (void)removeViews {
    
    [UIView animateWithDuration:0.2f animations:^{
        
        self.blackView.alpha = 0.f;
        self.messageView.alpha = 0.f;
        self.messageView.transform = CGAffineTransformMakeScale(0.75f, 0.75f);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}


@end
