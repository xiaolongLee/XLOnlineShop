//
//  AbstractAlertView.m
//  Animations
//
//  Created by 劉光軍 on 16/4/1.//

#import "AbstractAlertView.h"


@interface AbstractAlertView ()

@property (nonatomic, strong) NSMapTable  *mapTable;

@end

@implementation AbstractAlertView

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.delayAutoHidenDuration = 2.f;
        self.autoHiden              = NO;
        self.mapTable               = [NSMapTable strongToWeakObjectsMapTable];
    }
    
    return self;
}

- (void)show {
    
    [NSException raise:@"AlertViewProtocol"
                format:@"Cannot use show method from subclass."];
}

- (void)hide {
    
    [NSException raise:@"AlertViewProtocol"
                format:@"Cannot use hide method from subclass."];
}

- (void)setView:(UIView *)view withKey:(NSString *)key {

    [self.mapTable setObject:view forKey:key];
}

- (UIView *)viewWithKey:(NSString *)key {

    return [self.mapTable objectForKey:key];
}



@end
