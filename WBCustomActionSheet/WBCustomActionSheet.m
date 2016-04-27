//
//  WBCustomActionSheet.m
//  通用弹窗控件
//
//  Created by Weibai on 16/4/25.
//  Copyright © 2016年 Weibai Lu. All rights reserved.
//

#import "WBCustomActionSheet.h"

@interface WBCustomActionSheet ()

@property (nonatomic,strong)NSMutableArray *buttons;
@property (nonatomic,strong)UIButton *cancelButton;

@property (nonatomic,strong)UIView *contentView;

@property (nonatomic,assign)NSInteger numberOfActions;
@property (nonatomic,assign)CGFloat heightForTitle;
@property (nonatomic,assign)CGFloat heightForButton;
@property (nonatomic,assign)CGFloat marginForButton;

@property (nonatomic,assign)BOOL isShownByWindow;

@end

@implementation WBCustomActionSheet

+ (instancetype)customActionSheetWithTitle: (NSString *)title delegate:(id)delegate{
    WBCustomActionSheet *actionSheet = [[WBCustomActionSheet alloc] init];
    actionSheet.title = title;
    actionSheet.delegate = delegate;
    
    return actionSheet;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        //默认值
        self.heightForTitle = 44;
        self.heightForButton = 36;
        self.marginForButton = 8;
        self.isPresenting = NO;
        self.isShownByWindow = NO;
        self.contentBackgroundColor = [UIColor whiteColor];
        self.isNeedShadow = YES;
        
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = self.contentBackgroundColor;
        self.buttons = [NSMutableArray array];
        [self addSubview:self.contentView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.heightForTitle)];
        [self.titleLabel setTextColor:[UIColor grayColor]];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
    
}

- (void)setDelegate:(id<WBCustomActionSheetDataSourceAngDelegate>)delegate{
    if (_delegate != delegate) {
        _delegate = delegate;
    }
    
    if ([self.delegate respondsToSelector:@selector(numberOfActionsInCustomActionSheet:)]) {
        self.numberOfActions = [self.delegate numberOfActionsInCustomActionSheet: self];
    }
    
    if ([self.delegate respondsToSelector:@selector(customActionSheetHeightForTitle:)]) {
        self.heightForTitle = [self.delegate customActionSheetHeightForTitle: self];
    }
    
    if ([self.delegate respondsToSelector:@selector(customActionSheetHeightForButton:)]) {
        self.heightForButton = [self.delegate customActionSheetHeightForButton: self];
    }
    
    if ([self.delegate respondsToSelector:@selector(customActionSheetMarginForButtons:)]) {
        self.marginForButton = [self.delegate customActionSheetMarginForButtons: self];
    }
    
    [self prepareToPresent];
}

- (void)reload{
    self.delegate = _delegate;
}

- (void)setContentBackgroundColor:(UIColor *)contentBackgroundColor{
    if (_contentBackgroundColor != contentBackgroundColor) {
        _contentBackgroundColor = contentBackgroundColor;
        self.contentView.backgroundColor = contentBackgroundColor;
    }
    
}

- (void)showAnimated:(BOOL)animated{
    if (!self.isPresenting) {
        self.isShownByWindow = YES;
        self.isPresenting = YES;
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        //        [_window makeKeyAndVisible];
        if (animated) {

            self.backgroundColor = [UIColor clearColor];
            [UIView animateWithDuration:0.3 animations:^{
                if (self.isNeedShadow) {
                    self.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.4];
                }
                self.contentView.frame = CGRectMake(0, self.frame.size.height - [self heightForContent], self.frame.size.width, [self heightForContent]);
            } completion:^(BOOL finished) {
                
            }];
        }else{
            if (self.isNeedShadow) {
                self.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.4];
            }else{
                self.backgroundColor = [UIColor clearColor];
            }
            self.contentView.frame = CGRectMake(0, self.frame.size.height - [self heightForContent], self.frame.size.width, [self heightForContent]);
        }
    }
    
    
    
}
//初始化所有控件
- (void)prepareToPresent{
    //清空一下
    if (self.buttons.count) {
        for (UIButton *button in self.buttons) {
            [button removeFromSuperview];
        }
        [self.buttons removeAllObjects];
    }
    if (self.cancelButton) {
        [self.cancelButton removeFromSuperview];
        self.cancelButton = nil;
    }
    
    if (self.isNeedShadow) {
        self.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.4];
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
    
    self.frame = [UIScreen mainScreen].bounds;
    self.titleLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.heightForTitle);
    self.contentView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, [self heightForContent]);
    [self.titleLabel setText:self.title];
    
    for (int i = 0; i < self.numberOfActions; i++) {
        if ([self.delegate respondsToSelector:@selector(buttonForIndex:InCustomActionSheet:)]) {
            UIButton *button = [self.delegate buttonForIndex:i InCustomActionSheet:self];
            [button addTarget:self action:@selector(userDidClickButton:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(self.marginForButton, self.heightForTitle + i * (self.heightForButton+self.marginForButton), self.frame.size.width - 2 * self.marginForButton, self.heightForButton);
            [self.buttons addObject:button];
            [self.contentView addSubview:button];
        }else{
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button addTarget:self action:@selector(userDidClickButton:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(self.marginForButton, self.heightForTitle + i * (self.heightForButton+self.marginForButton), self.frame.size.width - 2 * self.marginForButton, self.heightForButton);
            [self.buttons addObject:button];
            [self.contentView addSubview:button];
        }
    }
    if ([self.delegate respondsToSelector:@selector(cancelButtonInCustomActionSheet:)]) {
        UIButton *button = [self.delegate cancelButtonInCustomActionSheet: self];
        [button addTarget:self action:@selector(userDidClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(self.marginForButton, self.heightForTitle + self.buttons.count * (self.heightForButton+self.marginForButton), self.frame.size.width - 2*self.marginForButton, self.heightForButton);
        [self.contentView addSubview:button];
        self.cancelButton = button;
    }else{
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor blackColor]];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(userDidClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(self.marginForButton, self.heightForTitle + self.buttons.count * (self.heightForButton+self.marginForButton), self.frame.size.width - 2*self.marginForButton, self.heightForButton);
        [self.contentView addSubview:btn];
        self.cancelButton = btn;
    }
    
}

- (CGFloat)heightForContent{
    CGFloat totalHeight = 0;
    //title高度
    totalHeight += self.heightForTitle;
    //按钮高度
    for (int i = 0; i<self.numberOfActions; i++) {
        totalHeight += self.heightForButton;
        totalHeight += self.marginForButton;
    }
    //取消按钮高度
    totalHeight += self.heightForButton + self.marginForButton;
    
    return totalHeight;
}

- (void)dismissAnimated:(BOOL)animated{
    if (self.isPresenting) {
        self.isPresenting = NO;
        if (self.isShownByWindow) { //window显示出来的
            if (animated) {
                [UIView animateWithDuration:0.3 animations:^{
                    if (self.isNeedShadow) {
                        self.backgroundColor = [UIColor clearColor];
                    }
                    self.contentView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, [self heightForContent]);
                } completion:^(BOOL finished) {
                    self.isShownByWindow = NO;
                    [self removeFromSuperview];
                }];
            }else{
                self.isShownByWindow = NO;
                [self removeFromSuperview];
            }
            
        }else{
            
        }
        
    }
    
}

- (void)userDidClickButton: (UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(customActionSheetUserDidClickButtonAtIndex:)]) {
        if ([self.buttons containsObject:button]) {
            NSInteger index = [self.buttons indexOfObject:button];
            [self.delegate customActionSheetUserDidClickButtonAtIndex:index];
        }
    }
}

- (void)userDidClickCancelButton: (UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(customActionSheetUserDidClickCancelButton)]) {
        [self.delegate customActionSheetUserDidClickCancelButton];
    }else{
        [self dismissAnimated:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    if (!CGRectContainsPoint(self.contentView.frame, point)) {
        [self userDidClickCancelButton:[self.delegate cancelButtonInCustomActionSheet:self]];
    }
}

@end
