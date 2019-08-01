//
//  ButtonsAlertView.m
//  AlertViewTestDemo
//
//  Created by 劉光軍 on 16/4/1.//

#import "ButtonsAlertView.h"
#import "POP.h"

@interface ButtonsAlertView()

@property(nonatomic, strong) UIButton *firstButton;
@property (nonatomic, strong) UIButton  *secondButton;
@property (nonatomic, strong) UIView    *blackView;
@property (nonatomic, strong) UIView    *messageView;

@end

@implementation ButtonsAlertView


+ (AbstractAlertView *)buttonsAlertViewWithMessage:(NSString *)message delegate:(id)delegate buttonTitles:(NSArray *)buttons
{
    AbstractAlertView *showView = [[ButtonsAlertView alloc] init];
    showView.delegate = delegate;
    showView.contentView = [[UIApplication sharedApplication] keyWindow] ;
    NSMutableArray *temp = [NSMutableArray array];
    for (NSString *title in buttons) {
        RIButtonItem *item = [RIButtonItem itemWithLabel:title];
        [temp addObject:item];
    }
    showView.buttonsTitle = temp;
    showView.message = message;
    return showView;
    
}

+ (void)showWithMessage:(NSString *)message delegate:(id)delegate buttonTitles:(NSArray *)buttons
{
    AbstractAlertView *showView = [[ButtonsAlertView alloc] init];
    showView.delegate = delegate;
    showView.contentView = [[UIApplication sharedApplication] keyWindow];
    NSMutableArray *temp = [NSMutableArray array];
    for (NSString *title in buttons) {
        RIButtonItem *item = [RIButtonItem itemWithLabel:title];
        [temp addObject:item];
    }
    showView.buttonsTitle = temp;
    showView.message = message;
    [showView show];
}

+(void)showWithMessage:(NSString *)message otherButtonItems:(NSArray<RIButtonItem *>*)inButtonItems
{
    AbstractAlertView *showView = [[ButtonsAlertView alloc] init];
    showView.contentView = [[UIApplication sharedApplication] keyWindow];
    showView.buttonsTitle = inButtonItems;
    showView.message = message;
    [showView show];
}




+ (UIView *)lineViewWithFrame:(CGRect)frame color:(UIColor *)color {
    
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    return line;
}

- (instancetype)init {
    
    if (self) {
        self = [super init];
        
        self.firstButton = [[UIButton alloc] initWithFrame:CGRectZero];
        self.secondButton = [[UIButton alloc] initWithFrame:CGRectZero];
        
        self.firstButton.userInteractionEnabled = NO;
        self.firstButton.tag = 0;
        self.firstButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.firstButton setTitleColor:[UIColor colorWithWhite:0.667 alpha:1.000] forState:UIControlStateNormal];
        [self.firstButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self.firstButton addTarget:self action:@selector(messageButtonsEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        self.secondButton.userInteractionEnabled = NO;
        self.secondButton.tag = 1;
        self.secondButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.secondButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.secondButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//        self.secondButton.backgroundColor = [UIColor colorWithRed:0.294 green:0.294 blue:0.784 alpha:1.000];
        self.secondButton.backgroundColor = __kThemeColor;
        [self.secondButton addTarget:self action:@selector(messageButtonsEvent:) forControlEvents:UIControlEventTouchUpInside];
        
            //Store View
        [self setView:self.firstButton withKey:@"firstButton"];
        [self setView:self.secondButton withKey:@"secondButton"];
            
    }
    return self;
}

- (void)setContentView:(UIView *)contentView {
    
    [super setContentView: contentView];
    self.frame = contentView.bounds;
    
}

- (void)show {
    
    if (self.contentView) {
        
        [self.contentView addSubview:self];
        
        [self createBlackView];
        [self createMessageView];
        
    }
}

- (void)hide {
    
    if (self.contentView) {
        [self removeViews];
    }
}



- (void)createBlackView {
    
    self.blackView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0;
    [self addSubview:self.blackView];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.blackView.alpha = 0.3f;
    }];
}

- (void)createMessageView {
    
    
    /*宽 根据6的屏宽比*/
    CGFloat textLabelWidth = [UIScreen mainScreen].bounds.size.width / 375.0 * (260);

        //创建信息label
    NSString *text = self.message;
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textLabelWidth, 0)];
    textLabel.text = text;
    textLabel.font = [UIFont systemFontOfSize:20];
    textLabel.textColor = [UIColor colorWithWhite:0.078 alpha:1.000];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.numberOfLines = 0;
    [textLabel sizeToFit];
    
        //创建信息窗体view
    self.messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textLabelWidth + 30, textLabel.frame.size.height + 120)];
    self.messageView.backgroundColor = [UIColor whiteColor];
    self.messageView.layer.cornerRadius = 10.f;
    self.messageView.layer.masksToBounds = YES;
    self.messageView.center = CGPointMake(self.contentView.frame.size.width/ 2.f, self.contentView.frame.size.height/ 2.f);
    textLabel.center = CGPointMake(self.messageView.frame.size.width/2, self.messageView.frame.size.height/2);
    textLabel.top = 30;
    self.messageView.alpha = 0.f;
    [self.messageView addSubview:textLabel];
    [self addSubview:self.messageView];
    
        //处理按钮
    NSArray *buttonsInfo = self.buttonsTitle;
    
        //如果有一个按钮
    if (buttonsInfo.count == 1) {
        [self.messageView addSubview:[[self class] lineViewWithFrame:CGRectMake(0, self.messageView.height - 60, self.messageView.width, 0.5f) color:[UIColor colorWithWhite:0.898 alpha:1.000]]];
        self.firstButton.frame = CGRectMake(0, self.messageView.height - 60, self.messageView.width, 60);
        self.firstButton.userInteractionEnabled = NO;
        self.firstButton.tag = 0;
        self.firstButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [self.firstButton setTitle:self.buttonsTitle[0].label forState:UIControlStateNormal];
        [self.firstButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.firstButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        [self.firstButton addTarget:self action:@selector(messageButtonsEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.messageView addSubview:self.firstButton];
    }
    
        //如果有2个按钮
    if (buttonsInfo.count == 2) {
        
        [self.messageView addSubview:[[self class] lineViewWithFrame:CGRectMake(0, self.messageView.height - 60, self.messageView.width, 0.5f) color:[UIColor lightGrayColor]]];
        [self.messageView addSubview:[[self class] lineViewWithFrame:CGRectMake(self.messageView.width / 2.f, self.messageView.height - 60, 0.5f, 60.f) color:[UIColor lightGrayColor]]];
        
        self.firstButton.frame = CGRectMake(0, self.messageView.height - 60, self.messageView.width / 2.f, 60);
        [self.firstButton setTitle:self.buttonsTitle[0].label forState:UIControlStateNormal];
        [self.messageView addSubview:self.firstButton];
        
        self.secondButton.frame = CGRectMake(self.messageView.width / 2.f, self.messageView.height - 60, self.messageView.width / 2.f, 60);
        [self.secondButton setTitle:self.buttonsTitle[1].label forState:UIControlStateNormal];
        [self.messageView addSubview:self.secondButton];
    }
    
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
    scale.delegate = self;
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

- (void)messageButtonsEvent:(UIButton *)button {
    [self hide];
    
    
    if ([[self.buttonsTitle objectAtIndex:button.tag] action]) {
        void (^action)() = [[self.buttonsTitle objectAtIndex:button.tag] action];
        action();
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:data:atIndex:)]) {
        [self.delegate alertView:self data:nil atIndex:button.tag];
    }
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    
    self.firstButton.userInteractionEnabled = YES;
    self.secondButton.userInteractionEnabled = YES;
}


@end
