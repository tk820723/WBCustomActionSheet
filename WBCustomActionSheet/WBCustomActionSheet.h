//
//  WBCustomActionSheet.h
//  通用弹窗控件
//
//  Created by Weibai on 16/4/25.
//  Copyright © 2016年 Weibai Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBCustomActionSheet;
@protocol WBCustomActionSheetDataSourceAngDelegate <NSObject>
@required
//多少个action
- (NSInteger)numberOfActionsInCustomActionSheet: (WBCustomActionSheet *)actionSheet;
//每个button的样式
- (UIButton *)buttonForIndex: (NSInteger)index InCustomActionSheet: (WBCustomActionSheet *)actionSheet;


@optional
//返回title的高度 默认44
- (CGFloat)customActionSheetHeightForTitle: (WBCustomActionSheet *)actionSheet ;
//返回每个button的高度 默认36
- (CGFloat)customActionSheetHeightForButton: (WBCustomActionSheet *)actionSheet;
//Button间隔  默认8
- (CGFloat)customActionSheetMarginForButtons: (WBCustomActionSheet *)actionSheet;
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
@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)UIColor *contentBackgroundColor;
@property (nonatomic,assign)BOOL isNeedShadow;

+ (instancetype)customActionSheetWithTitle: (NSString *)title delegate:(id)delegate;

- (void)reload;

- (void)showAnimated: (BOOL)animated;

- (void)dismissAnimated: (BOOL)animated;

@end
