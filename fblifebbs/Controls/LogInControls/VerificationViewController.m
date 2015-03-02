//
//  VerificationViewController.m
//  越野e族
//
//  Created by soulnear on 13-12-26.
//  Copyright (c) 2013年 soulnear. All rights reserved.
//

#import "VerificationViewController.h"

@interface VerificationViewController ()
{
    MBProgressHUD * HUD;
}

@end

@implementation VerificationViewController
@synthesize MyPhoneNumber = _MyPhoneNumber;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}


-(void)backH
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginEvent:@"VerificationViewController"];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [MobClick endEvent:@"VerificationViewController"];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBCOLOR(245,245,245);
    
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] )
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:MY_MACRO_NAME?IOS7DAOHANGLANBEIJING:IOS6DAOHANGLANBEIJING] forBarMetrics: UIBarMetricsDefault];
    }
    
    self.navigationItem.title = @"填写验证码";
    
    [self setSNViewControllerLeftButtonType:SNViewControllerLeftbuttonTypeBack WithRightButtonType:SNViewControllerRightbuttonTypeNull];
    
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(23/2,23/2,200,20)];
    
    label1.text = @"请输入收到的短信验证码:";
    
    label1.textAlignment = NSTextAlignmentLeft;
    
    label1.textColor = RGBCOLOR(101,102,104);
    
    label1.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:label1];
    
    
    
    
    UIView * back_view = [[UIView alloc] initWithFrame:CGRectMake(23/2,38,DEVICE_WIDTH-23,42)];
    
    back_view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:back_view];
    
    
    
    
    verification_tf = [[UITextField alloc] initWithFrame:CGRectMake(10,0,DEVICE_WIDTH-23-20,42)];
    
    verification_tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    verification_tf.placeholder = @"请输入验证码";
    
    verification_tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    verification_tf.keyboardType = UIKeyboardTypeNumberPad;
    
    verification_tf.backgroundColor = [UIColor clearColor];
    
    verification_tf.font = [UIFont systemFontOfSize:15];
    
    [verification_tf becomeFirstResponder];
    
    [back_view addSubview:verification_tf];
    
    
    
    UIButton * next_button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    next_button.frame = CGRectMake(23/2,80+23/2,DEVICE_WIDTH-23,43);
    
    next_button.backgroundColor = RGBCOLOR(101,102,104);
    
    [next_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [next_button setTitle:@"下一步" forState:UIControlStateNormal];
    
    [next_button addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:next_button];
    
    
    
    ReSendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    ReSendButton.frame = CGRectMake((DEVICE_WIDTH-132)/2,200,132,43.5);
    
    ReSendButton.hidden = YES;
    
    [ReSendButton setTitle:@"重新发送验证码" forState:UIControlStateNormal];
    
    [ReSendButton setTitleColor:RGBCOLOR(151,151,151) forState:UIControlStateNormal];
    
    ReSendButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [ReSendButton setBackgroundImage:[UIImage imageNamed:@"zc_resendimage.png"] forState:UIControlStateNormal];
    
    [ReSendButton addTarget:self action:@selector(reSend:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:ReSendButton];
    
    time_number = 60;
    
    time_label = [[UILabel alloc] initWithFrame:CGRectMake((DEVICE_WIDTH-180)/2,200,180,43.5)];
    
    time_label.text = [NSString stringWithFormat:@"接收短信大约需要%d秒钟",time_number];
    
    time_label.textAlignment = NSTextAlignmentCenter;
    
    time_label.textColor = [UIColor grayColor];
    
    time_label.font = [UIFont systemFontOfSize:15];
    
    time_label.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:time_label];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
}

-(void)reSend:(UIButton *)sender
{
    [self initReSendRequest];
}


-(void)timeCount
{
    if (time_number == 1)
    {
        time_label.hidden = YES;
        
        ReSendButton.hidden = NO;
        
        [timer invalidate];
        
        return;
    }
    
    time_number--;
    
    time_label.text = [NSString stringWithFormat:@"接收短信大约需要%d秒钟",time_number];
}



-(void)nextStep:(UIButton *)sender
{
    [self initYanZhengVerification];
}


-(void)initReSendRequest
{
    HUD = [zsnApi showMBProgressWithText:@"发送中..." addToView:self.view];
    
    if (reSend_request)
    {
        [reSend_request cancel];
        reSend_request.delegate = nil;
        reSend_request = nil;
    }
    
    
    NSString * fullUrl = [NSString stringWithFormat:SENDPHONENUMBER,self.MyPhoneNumber];
    
    NSLog(@"发送手机请求的url------%@",fullUrl);
    
    reSend_request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fullUrl]];
    
    reSend_request.delegate = self;
    
    reSend_request.shouldAttemptPersistentConnection = NO;
    
    [reSend_request startAsynchronous];

}


-(void)initYanZhengVerification
{
    HUD = [zsnApi showMBProgressWithText:@"发送中..." addToView:self.view];
    if (request_)
    {
        [request_ cancel];
        request_.delegate = nil;
        request_ = nil;
    }
    
    NSString * fullUrl = [NSString stringWithFormat:SENDERVerification,self.MyPhoneNumber,verification_tf.text];
    
    request_ = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullUrl]];
    
    request_.delegate = self;
    
    request_.shouldAttemptPersistentConnection = NO;
    
    [request_ startAsynchronous];
}


-(void)requestFinished:(ASIHTTPRequest *)request
{
//    HUD.mode= MBProgressHUDModeText;
    HUD.labelText = @"发送成功";
    [HUD hide:YES afterDelay:1.5];
    
    NSDictionary * data_dic = [request.responseData objectFromJSONData];
    
    NSString * errcode = [NSString stringWithFormat:@"%@",[data_dic objectForKey:@"errcode"]]
    ;
    
    NSString * bbsinfo = [NSString stringWithFormat:@"%@",[data_dic objectForKey:@"bbsinfo"]];
    
    
    if (request == request_)
    {
        if ([errcode intValue] == 0)
        {
            ZhuCeViewController * zhuce = [[ZhuCeViewController alloc] init];
            
            zhuce.PhoneNumber = self.MyPhoneNumber;
            
            zhuce.verification = verification_tf.text;
            
            [self.navigationController pushViewController:zhuce animated:YES];
        }else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:bbsinfo delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
            
            [alert show];
        }
    }else
    {
        if ([errcode intValue] == 0)
        {
            time_number = 60;
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCount) userInfo:nil repeats:YES];

            ReSendButton.hidden = YES;
            
            time_label.hidden = NO;

        }else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:bbsinfo delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
            
            [alert show];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [HUD hide:YES];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"发送失败,请检查当前网络" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
    
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end




















