//
//  MessageAlertView.m
//  AlertViewTestDemo
//
//  Created by 劉光軍 on 16/4/6.
//

#import "MessageAlertView.h"
#import "POP.h"


@interface MessageAlertView()

@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *messageView;

@end

@implementation MessageAlertView
+ (void)showWithMessage:(NSString *)message
{
    AbstractAlertView *alertView = [[MessageAlertView alloc] init];
    alertView.message = message;
    alertView.contentView = [[UIApplication sharedApplication] keyWindow];
//    alertView.contentView = [[[UIApplication sharedApplication] windows] lastObject];
//    NSLog(@"-------%@",[[UIApplication sharedApplication] windows]);
//    NSLog(@"-------%@",[[[UIApplication sharedApplication] windows] lastObject]);
    alertView.autoHiden = YES;
    alertView.delayAutoHidenDuration = 1.5f;
    [alertView show];
}

- (void)setContentView:(UIView *)contentView {
    
    self.frame = contentView.bounds;
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
    textLabel.font = [UIFont systemFontOfSize:18.f];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.numberOfLines = 0;
//    [textLabel sizeToFit];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = textLabel.font;
    CGSize maxSize = CGSizeMake(textLabelWidth, MAXFLOAT);
    CGSize textLabelSize = [textLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    textLabel.frame = CGRectMake(0, 0, textLabelSize.width, textLabelSize.height);
    
        //创建信息窗体view
    CGFloat messageViewWidth = 0.0f;
    if (textLabel.frame.size.width < 100) {
        messageViewWidth = 100;
    }else{
        messageViewWidth = textLabel.frame.size.width;
    }
    self.messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, messageViewWidth + 30, textLabel.height + 60)];
    self.messageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
    self.messageView.layer.cornerRadius = 5;
    self.messageView.layer.masksToBounds = YES;
//    self.messageView.center = CGPointMake(self.contentView.frame.size.width/2, self.contentView.frame.size.height - self.messageView.frame.size.height/2 - 100);
    self.messageView.center = CGPointMake(self.contentView.frame.size.width/ 2.f, self.contentView.frame.size.height/ 2.f);
    textLabel.center = CGPointMake(self.messageView.frame.size.width/2, self.messageView.frame.size.height/2);
    self.messageView.alpha = 0.f;
    [self.messageView addSubview:textLabel];
    [self addSubview:self.messageView];
    
        //执行动画
    POPBasicAnimation *alpha = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alpha.toValue = @(1.f);
    alpha.duration = 0.3f;
    [self.messageView pop_addAnimation:alpha forKey:nil];
    
    POPSpringAnimation *scale = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scale.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.75f, 1.75f)];
    scale.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scale.dynamicsTension = 1000;
    scale.dynamicsMass = 1.3;
    scale.dynamicsFriction = 10.3;
    scale.springSpeed = 60;
    scale.springBounciness = 15.64;
    [self.messageView.layer pop_addAnimation:scale forKey:nil];
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
