//
//  WBCustomActionSheet.m
//  通用弹窗控件
//
//  Created by Weibai on 16/4/25.
//  Copyright © 2016年 Weibai Lu. All rights reserved.
//

#import "WBCustomActionSheet.h"

@interface WBCustomActionSheet ()

@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,strong) UIButton *cancelButton;

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIView *upperPanel;
@property (nonatomic,strong) UIView *lowerPanel;

@property (nonatomic,assign) NSInteger numberOfActions;
@property (nonatomic,strong) WBActionSheetConfig *config;

@property (nonatomic,assign) BOOL isShownByWindow;

@end

@implementation WBCustomActionSheet

+ (instancetype)customActionSheetWithConfig:(WBActionSheetConfig *)config{
    WBCustomActionSheet *actionSheet = [[WBCustomActionSheet alloc] init];
    
    if (config) {
        actionSheet.config = config;
    }else{
        actionSheet.config = [[WBActionSheetConfig alloc] init];
    }
    
    return actionSheet;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    return self;
    
}

- (void)setDelegate:(id<WBCustomActionSheetDataSourceAngDelegate>)delegate{
    if (_delegate != delegate) {
        _delegate = delegate;
    }
    
    if ([self.delegate respondsToSelector:@selector(numberOfActionsInCustomActionSheet:)]) {
        self.numberOfActions = [self.delegate numberOfActionsInCustomActionSheet: self];
    }else{
        self.numberOfActions = 0;
    }
    [self prepareToPresent];
}

- (void)reload{
    self.delegate = _delegate;
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
                if (self.config.isNeedShadow) {
                    self.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.4];
                }
                self.contentView.frame = CGRectMake(0, self.frame.size.height - [self heightForContent], self.frame.size.width, [self heightForContent]);
            } completion:^(BOOL finished) {
                
            }];
        }else{
            if (self.config.isNeedShadow) {
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
    
    [self.upperPanel removeFromSuperview];
    self.upperPanel = nil;
    
    if (self.cancelButton) {
        [self.cancelButton removeFromSuperview];
        self.cancelButton = nil;
    }
    
    [self.lowerPanel removeFromSuperview];
    self.lowerPanel = nil;
    
    if (self.config.isNeedShadow) {
        self.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.4];
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
    
    CGFloat heightForContent = [self heightForContent];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - heightForContent, self.frame.size.width, heightForContent)];
    [self addSubview:self.contentView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.config.titleHeight)];
    [self.titleLabel setTextColor:self.config.titleColor];
    self.titleLabel.font = self.config.titleFont;
    self.titleLabel.text = self.config.titleString;
    self.titleLabel.userInteractionEnabled = NO;
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.titleLabel];
    
    self.frame = [UIScreen mainScreen].bounds;
    self.titleLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.config.titleHeight);
    self.contentView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, [self heightForContent]);
    
    self.upperPanel = [[UIView alloc] initWithFrame:CGRectMake(self.config.buttonMargin, self.config.titleHeight + self.config.buttonMargin, self.frame.size.width - 2 * self.config.buttonMargin, self.config.buttonHeight * self.numberOfActions)];
    self.upperPanel.backgroundColor = self.config.upperPanelBackgroundColor;
    [self.contentView addSubview:self.upperPanel];
    self.upperPanel.layer.cornerRadius = self.config.cornerRadius;
    self.upperPanel.clipsToBounds = YES;
    
    self.lowerPanel = [[UIView alloc] initWithFrame:CGRectMake(self.config.buttonMargin, CGRectGetMaxY(self.upperPanel.frame) + self.config.buttonMargin, self.upperPanel.bounds.size.width, self.config.buttonHeight)];
    self.lowerPanel.backgroundColor = self.config.lowerPanelBackgroundColor;
    self.lowerPanel.layer.cornerRadius = self.config.cornerRadius;
    self.lowerPanel.clipsToBounds = YES;
    [self.contentView addSubview:self.lowerPanel];

    
    for (int i = 0; i < self.numberOfActions; i++) {
        if ([self.delegate respondsToSelector:@selector(buttonForIndex:InCustomActionSheet:)]) {
            UIButton *button = [self.delegate buttonForIndex:i InCustomActionSheet:self];
            [button addTarget:self action:@selector(userDidClickButton:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, i * self.config.buttonHeight, self.upperPanel.frame.size.width, self.config.buttonHeight);
            [self.buttons addObject:button];
            [self.upperPanel addSubview:button];
            
            if (self.config.isNeedSeperator && i != self.numberOfActions -1) {
                UIView *seperator = [[UIView alloc] initWithFrame: CGRectMake(self.config.seperatorMargin, CGRectGetMaxY(button.frame)-1, button.bounds.size.width - 2 * self.config.seperatorMargin, self.config.seperatorHeight)];
                seperator.backgroundColor = self.config.seperatorColor;
                [self.upperPanel addSubview:seperator];
            }
        }else{
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button addTarget:self action:@selector(userDidClickButton:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, i * self.config.buttonHeight, self.upperPanel.frame.size.width, self.config.buttonHeight);
            [self.buttons addObject:button];
            [self.upperPanel addSubview:button];
            
        }

    }
    if ([self.delegate respondsToSelector:@selector(cancelButtonInCustomActionSheet:)]) {
        UIButton *button = [self.delegate cancelButtonInCustomActionSheet: self];
        [button addTarget:self action:@selector(userDidClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, self.lowerPanel.frame.size.width, self.config.buttonHeight);
        [self.lowerPanel addSubview:button];
        self.cancelButton = button;
    }else{
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor blackColor]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(userDidClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, 0, self.lowerPanel.frame.size.width, self.config.buttonHeight);
        [self.contentView addSubview:btn];
        self.cancelButton = btn;
    }
    
}

- (CGFloat)heightForContent{
    CGFloat totalHeight = 0;
    //title高度
    totalHeight += self.config.titleHeight;
    totalHeight += self.config.buttonMargin;
    //按钮高度
    for (int i = 0; i<self.numberOfActions; i++) {
        totalHeight += self.config.buttonHeight;
    }
    totalHeight += self.config.buttonMargin;
    //取消按钮高度
    totalHeight += self.config.buttonHeight + self.config.lowerMargin;
    
    return totalHeight;
}

- (void)dismissAnimated:(BOOL)animated{
    if (self.isPresenting) {
        self.isPresenting = NO;
        if (self.isShownByWindow) { //window显示出来的
            if (animated) {
                [UIView animateWithDuration:0.3 animations:^{
                    if (self.config.isNeedShadow) {
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
    if ([self.delegate respondsToSelector:@selector(customActionSheet:userDidClickButtonAtIndex:)]) {
        if ([self.buttons containsObject:button]) {
            NSInteger index = [self.buttons indexOfObject:button];
            [self.delegate customActionSheet:self userDidClickButtonAtIndex:index];
        }
    }
}

- (void)userDidClickCancelButton: (UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(customActionSheet:userDidClickCancelButton:)]) {
        [self.delegate customActionSheet:self userDidClickCancelButton:button];
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

@implementation WBActionSheetConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleHeight = 44;
        self.buttonHeight = 36;
        self.buttonMargin = 8;
        self.isNeedShadow = YES;
        self.isNeedBlurEffect = YES;
        self.titleColor = [UIColor whiteColor];
        self.titleString = @"标题";
        self.isNeedSeperator = YES;
        self.seperatorColor =  [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
        self.seperatorHeight = 1;
        self.seperatorMargin = 16;
        
        self.upperPanelBackgroundColor = [UIColor whiteColor];
        self.lowerPanelBackgroundColor = [UIColor whiteColor];
        
        self.cornerRadius = 8;
        
        self.lowerMargin = 16;
    }
    return self;
}

@end
