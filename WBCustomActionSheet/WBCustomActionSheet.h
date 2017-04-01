//
//  WBCustomActionSheet.h
//  通用弹窗控件
//
//  Created by Weibai on 16/4/25.
//  Copyright © 2016年 Weibai Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBCustomActionSheet, WBActionSheetConfig;
@protocol WBCustomActionSheetDataSourceAngDelegate <NSObject>
@required  //-->DataSource
//多少个action
- (NSInteger)numberOfActionsInCustomActionSheet: (WBCustomActionSheet *)actionSheet;
//每个button的样式
- (UIButton *)buttonForIndex: (NSInteger)index InCustomActionSheet: (WBCustomActionSheet *)actionSheet;

@optional   //-->Delegate
//用户点击事件
- (void)customActionSheetUserDidClickButtonAtIndex: (NSInteger)index;
//用户点击取消
- (void)customActionSheetUserDidClickCancelButton;
//取消按钮样式
- (UIButton *)cancelButtonInCustomActionSheet: (WBCustomActionSheet *)actionSheet;
@end

@interface WBCustomActionSheet : UIView
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,assign)id <WBCustomActionSheetDataSourceAngDelegate> delegate;
@property (nonatomic,assign)BOOL isPresenting;

+ (instancetype)customActionSheetWithConfig:(WBActionSheetConfig *)config delegate:(id <WBCustomActionSheetDataSourceAngDelegate>)delegate;

/**
 重载actionsheet
 */
- (void)reload;

/**
 显示actionsheet

 @param animated 是否需要动画效果
 */
- (void)showAnimated: (BOOL)animated;
/**
 actionsheet消失
 
 @param animated 是否需要动画效果
 */
- (void)dismissAnimated: (BOOL)animated;

@end

@interface WBActionSheetConfig : NSObject

@property (nonatomic,strong) NSString *titleString;

@property (nonatomic,assign) CGFloat titleHeight;
@property (nonatomic,strong) UIFont *titleFont;
@property (nonatomic,strong) UIColor *titleColor;

@property (nonatomic,assign) CGFloat cornerRadius;

@property (nonatomic,strong) UIColor *upperPanelBackgroundColor;
@property (nonatomic,strong) UIColor *lowerPanelBackgroundColor;

@property (nonatomic,assign) BOOL isNeedSeperator;
@property (nonatomic,assign) CGFloat seperatorMargin;
@property (nonatomic,strong) UIColor *seperatorColor;
@property (nonatomic,assign) CGFloat seperatorHeight;

@property (nonatomic,assign) CGFloat buttonHeight;
@property (nonatomic,assign) CGFloat buttonMargin;
@property (nonatomic,assign) CGFloat lowerMargin;
@property (nonatomic,assign) BOOL isNeedBlurEffect;
@property (nonatomic,assign) BOOL isNeedShadow;

@end
