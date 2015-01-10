//
//  ZhuCeViewController.m
//  越野e族
//
//  Created by soulnear on 13-12-23.
//  Copyright (c) 2013年 soulnear. All rights reserved.
//

#import "ZhuCeViewController.h"

@interface ZhuCeViewController ()
{
    MBProgressHUD * hud;
}

@end

@implementation ZhuCeViewController
@synthesize PhoneNumber = _PhoneNumber;
@synthesize verification = _verification;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)backH
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endEvent:@"ZhuCeViewController"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginEvent:@"ZhuCeViewController"];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(245,245,245);
    
    self.navigationItem.title = @"完善个人资料";
    [self setSNViewControllerLeftButtonType:SNViewControllerLeftbuttonTypeBack WithRightButtonType:SNViewControllerRightbuttonTypeNull];
    
    UILabel * yonghuming = [[UILabel alloc] initWithFrame:CGRectMake(23/2,23/2,100,20)];
    yonghuming.text = @"用户名:";
    yonghuming.textAlignment = NSTextAlignmentLeft;
    yonghuming.textColor = RGBCOLOR(101,102,104);
    yonghuming.backgroundColor = [UIColor clearColor];
    [self.view addSubview:yonghuming];
    
    userName_tf = [[UITextField alloc] initWithFrame:CGRectMake(23/2,38,296,42)];
    userName_tf.backgroundColor = [UIColor whiteColor];
    userName_tf.delegate = self;
    userName_tf.returnKeyType = UIReturnKeyDone;
    userName_tf.font = [UIFont systemFontOfSize:15];
    userName_tf.placeholder = @"最多可输入7个中文,注册后用户名不可更改";
    userName_tf.clearsOnBeginEditing = YES;
    [self.view addSubview:userName_tf];
    userName_tf.layer.borderColor = RGBCOLOR(226,226,226).CGColor;
    userName_tf.layer.borderWidth = 0.5;
    UIView *userNameview = [[UIView alloc] initWithFrame:CGRectMake(0, 0,8,8)];
    userNameview.userInteractionEnabled = NO;
    userName_tf.leftView = userNameview;
    userName_tf.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel * mima_label = [[UILabel alloc] initWithFrame:CGRectMake(23/2,90,200,20)];
    mima_label.textColor = RGBCOLOR(101,102,104);
    mima_label.text = @"密码:";
    mima_label.textAlignment = NSTextAlignmentLeft;
    mima_label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mima_label];
    
    mima_tf = [[UITextField alloc] initWithFrame:CGRectMake(23/2,120,296,42)];
    mima_tf.placeholder = @"请输入密码";
    mima_tf.delegate = self;
    mima_tf.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//垂直居中
    mima_tf.secureTextEntry = YES;                              //密码输入时
    mima_tf.backgroundColor = [UIColor whiteColor];
    mima_tf.font = [UIFont systemFontOfSize:15];
    mima_tf.returnKeyType = UIReturnKeyDone;
    mima_tf.clearsOnBeginEditing = YES;
    [self.view addSubview:mima_tf];
    mima_tf.layer.borderColor = RGBCOLOR(226,226,226).CGColor;
    mima_tf.layer.borderWidth = 0.5;
    UIView *mimaview = [[UIView alloc] initWithFrame:CGRectMake(0, 0,8,8)];
    mimaview.userInteractionEnabled = NO;
    mima_tf.leftView = mimaview;
    mima_tf.leftViewMode = UITextFieldViewModeAlways;

    
    UILabel * youxiang_label = [[UILabel alloc] initWithFrame:CGRectMake(23/2,175,200,20)];
    youxiang_label.text = @"邮箱";
    youxiang_label.textColor = RGBCOLOR(101,102,104);
    youxiang_label.backgroundColor = [UIColor clearColor];
    youxiang_label.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:youxiang_label];
    
    youxiang_tf = [[UITextField alloc] initWithFrame:CGRectMake(23/2,200,296,42)];
    youxiang_tf.placeholder = @"用来找回密码,请慎重填写";
    youxiang_tf.backgroundColor = [UIColor whiteColor];
    youxiang_tf.delegate = self;
    youxiang_tf.font = [UIFont systemFontOfSize:15];
    youxiang_tf.clearsOnBeginEditing = YES;
    youxiang_tf.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:youxiang_tf];
    youxiang_tf.layer.borderColor = RGBCOLOR(226,226,226).CGColor;
    youxiang_tf.layer.borderWidth = 0.5;
    UIView *youxiangview = [[UIView alloc] initWithFrame:CGRectMake(0, 0,8,8)];
    youxiangview.userInteractionEnabled = NO;
    youxiang_tf.leftView = youxiangview;
    youxiang_tf.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton * complete_button = [UIButton buttonWithType:UIButtonTypeCustom];
    complete_button.frame = CGRectMake(23/2,257,593/2,43);
    [complete_button setTitle:@"完 成" forState:UIControlStateNormal];
    complete_button.backgroundColor = RGBCOLOR(101,102,104);
    [complete_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [complete_button addTarget:self action:@selector(zhuCe:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:complete_button];
}


-(void)zhuCe:(UIButton *)button
{
    if (userName_tf.text.length == 0)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"用户名不能为空" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
        [alertView show];
        [userName_tf becomeFirstResponder];
        return;
    }
    
    
    if (mima_tf.text.length == 0)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"密码不能为空" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
        [alertView show];
        [mima_tf becomeFirstResponder];
        return;
    }
    
    if (youxiang_tf.text.length == 0)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"邮箱不能为空" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
        [alertView show];
        [youxiang_tf becomeFirstResponder];
        
        return;
    }else
    {
        BOOL isMail = [zsnApi validateEmail:youxiang_tf.text];
        
        if (!isMail)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入正确的邮箱" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
            [alertView show];
            return;
        }
    }
    
    
    if (request_)
    {
        [request_ cancel];
        request_.delegate = nil;
        request_ = nil;
    }
    
    hud = [zsnApi showMBProgressWithText:@"发送中..." addToView:self.view];
    
    
    NSString * fullUrl = [NSString stringWithFormat:SENDUSERINFO,self.PhoneNumber,self.verification,[userName_tf.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],mima_tf.text,youxiang_tf.text];
    
    request_ = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullUrl]];
    request_.delegate = self;
    request_.shouldAttemptPersistentConnection = NO;
    [request_ startAsynchronous];
}


-(void)requestFailed:(ASIHTTPRequest *)request
{
    [hud hide:YES];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"发送失败,请检查当前网络" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
    
    [alert show];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    hud.labelText = @"发送成功";
    [hud hide:YES afterDelay:1.5];
    
    NSDictionary * data_dic = [request.responseData objectFromJSONData];
    
    NSString * errcode = [NSString stringWithFormat:@"%@",[data_dic objectForKey:@"errcode"]]
    ;
    
    NSString * bbsinfo = [NSString stringWithFormat:@"%@",[data_dic objectForKey:@"bbsinfo"]];
    
    if ([errcode intValue] == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"注册成功,马上去登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
        
        alert.delegate = self;
        
        [alert show];
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:bbsinfo delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
        
        [alert show];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark-UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.frame.origin.y+textField.frame.size.height + 280 > DEVICE_HEIGHT-64)
    {
        CGRect frame = self.view.frame;
        frame.origin.y = DEVICE_HEIGHT - (textField.frame.origin.y+textField.frame.size.height + 300);
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }
    
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [UIView animateWithDuration:0.35 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 64;
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    
    return YES;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end













