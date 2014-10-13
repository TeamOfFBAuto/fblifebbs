//
//  GFoundSearchViewController.m
//  fblifebbs
//
//  Created by gaomeng on 14-10-13.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GFoundSearchViewController.h"

@interface GFoundSearchViewController ()

@end

@implementation GFoundSearchViewController


-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
    UIView *upTopBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 320, 45)];
    upTopBlackView.backgroundColor = RGBCOLOR(34, 41, 44);
//    [self setSNViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeText];
//    self.rightString = @"取消";
    [self.view addSubview:upTopBlackView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gGoBack) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(275, 5, 40, 40)];
    [upTopBlackView addSubview:btn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gGoBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
