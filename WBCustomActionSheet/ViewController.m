//
//  ViewController.m
//  WBCustomActionSheet
//
//  Created by Weibai on 16/4/27.
//  Copyright © 2016年 Weibai Lu. All rights reserved.
//

#import "ViewController.h"
#import "WBCustomActionSheet.h"

@interface ViewController ()<WBCustomActionSheetDataSourceAngDelegate>
@property (nonatomic,strong) WBCustomActionSheet * actionSheet;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WBActionSheetConfig *config = [[WBActionSheetConfig alloc] init];
    config.titleString = @"";

//    config.buttonHeight = [UIFont systemFontOfSize:12];
     self.actionSheet = [WBCustomActionSheet customActionSheetWithConfig:config delegate:self];
    
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn setTitle:@"click to view" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)showActionSheet{
    [self.actionSheet showAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WBCustomActionSheetDataSource
- (NSInteger)numberOfActionsInCustomActionSheet:(WBCustomActionSheet *)actionSheet{
    return 5;
}

- (UIButton *)buttonForIndex:(NSInteger)index InCustomActionSheet:(WBCustomActionSheet *)actionSheet{
    NSString *buttonTitle;
    if (0 == index) {
        buttonTitle = @"第1个action";
    }else if (1 == index){
        buttonTitle = @"第2个action";
    }else if (2== index){
        buttonTitle = @"第3个action";
    }else if (3 == index){
        buttonTitle = @"第4个action";
    }else if (4 == index){
        buttonTitle = @"第5个action";
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
//    button.layer.cornerRadius = 8;
//    button.layer.borderColor = [UIColor blackColor].CGColor;
//    button.layer.borderWidth = 1;
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    return button;
}

- (UIButton *)cancelButtonInCustomActionSheet:(WBCustomActionSheet *)actionSheet{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    return button;
}
#pragma mark - CustomActionSheetDelegate
- (void)customActionSheetUserDidClickCancelButton{
    [self.actionSheet dismissAnimated:YES];
}

- (void)customActionSheetUserDidClickButtonAtIndex:(NSInteger)index{
    if (0 == index) {
        NSLog(@"第1个action");
    }else if (1 == index){
        NSLog(@"第2个action");
    }else if (2== index){
        NSLog(@"第3个action");
    }else if (3 == index){
        NSLog(@"第4个action");
    }else if (4 == index){
        NSLog(@"第5个action");
    }
}


@end
