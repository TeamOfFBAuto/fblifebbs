//
//  GmFoundScanViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-8-5.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GmFoundScanViewController.h"

#import "FindViewController.h"



#define ScanKuangFrame CGRectMake(50, 90, 220, 223)


@interface GmFoundScanViewController ()
{
    UIImageView * _fourJiaoImageView;
}
@end

@implementation GmFoundScanViewController


- (void)dealloc
{
    
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
//    //上面的view
//    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
//    topView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:topView];
//    //返回view
//    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 74, 64)];
//    backView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *ttt = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tttback)];
//    [backView addGestureRecognizer:ttt];
//    [topView addSubview:backView];
//    //返回箭头
//    UIImageView *backImv = [[UIImageView alloc]initWithFrame:CGRectMake(8, 12+20, 12, 20)];
//    [backImv setImage:[UIImage imageNamed:@"fanhui-daohanglan-20_38.png"]];
//    backImv.userInteractionEnabled = YES;
//    [backView addSubview:backImv];
//    //返回文字
//    UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(backImv.frame)+8, backImv.frame.origin.y, 34, 20)];
//    backLabel.textColor = [UIColor whiteColor];
//    backLabel.userInteractionEnabled = YES;
//    backLabel.text = @"取消";
//    [backView addSubview:backLabel];
//    
//    //title
//    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(backLabel.frame)+65, backLabel.frame.origin.y+2, 52, 18)];
//    
//    titleLable.textColor = [UIColor whiteColor];
//    titleLable.text = @"二维码";
//    titleLable.font = [UIFont boldSystemFontOfSize:17];
//    [topView addSubview:titleLable];
    
    
//    self.navigationItem.title = @"二维码";
    
    
    [self setSNViewControllerLeftButtonType:SNViewControllerLeftbuttonTypeBack WithRightButtonType:SNViewControllerRightbuttonTypeNull];
    self.title = @"二维码";
    
    
    
    //半透明的浮层
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
    backImageView.image = [UIImage imageNamed:@"saoyisao_bg_640_996.png"];
    [self.view addSubview:backImageView];
    
    
    //四个角
    _fourJiaoImageView =[[UIImageView alloc]init];
    
    if (iPhone6){
        [_fourJiaoImageView setFrame:CGRectMake(58, 108, 258, 266)];
    }else{
        [_fourJiaoImageView setFrame:ScanKuangFrame];
    }
    
    NSLog(@"%f",DEVICE_WIDTH);
    
    if (DEVICE_WIDTH == 414) {
        [_fourJiaoImageView setFrame:CGRectMake(65, 120, 285, 298)]; //150 270
        
    }
    
    _fourJiaoImageView.image = [UIImage imageNamed:@"fkuang.png"];
    [self.view addSubview:_fourJiaoImageView];
    
    
    //文字提示label
    
    UILabel *tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(_fourJiaoImageView.frame.origin.x, CGRectGetMaxY(_fourJiaoImageView.frame)+28, _fourJiaoImageView.frame.size.width, 12)];
    tishiLabel.font = [UIFont systemFontOfSize:12];
    tishiLabel.textColor = [UIColor whiteColor];
    tishiLabel.backgroundColor = [UIColor clearColor];
    tishiLabel.text = @"将二维码显示在扫描框内，即可自动扫描";
    [self.view addSubview:tishiLabel];
    
    
    //我的二维码
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(124, CGRectGetMaxY(tishiLabel.frame)+37, 70, 15);
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [btn setTitle:@"我的二维码" forState:UIControlStateNormal];
    [btn setTitleColor:RGBCOLOR(87, 151, 226) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(myErweima) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
    upOrdown = NO;
    num =0;
    
    //上下滚动的条
    _line = [[UIImageView alloc]initWithFrame:CGRectMake(40, 6+89-18-6, 240, 18)];
    [_line setImage:[UIImage imageNamed:@"fshan.png"]];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    
    
    
    [timer fire];
    
    
}

//左边按钮点击方法
-(void)leftButtonTap:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        [timer invalidate];
    }];
}


-(void)animation1
{
    //一个条
    if (upOrdown == NO) {
        num ++;
        
        
        
        if (iPhone6){
            [_line setFrame:CGRectMake(48, 6+107-9-6+2*num, 278, 18)];
        }else{
            
            _line.frame = CGRectMake(40, 6+89-9-6+2*num, 240, 18);
            //CGRectMake(50, 90, 220, 223)
        }
        
        NSLog(@"%f",DEVICE_WIDTH);
        
        if (DEVICE_WIDTH == 414) {
            [_line setFrame:CGRectMake(55, 6+119-9-6+2*num, 305, 18)]; //150 270
            
        }
        
        
        int hh = _fourJiaoImageView.frame.size.height;
        
        if (hh == 223) {
            hh =220;
        }
        
        if (2*num == hh) {
            
            upOrdown = YES;
        }
        
    }
    else {
        num --;
        
        if (iPhone6){
            [_line setFrame:CGRectMake(48, 6+107-9-6+2*num, 278, 18)];
        }else{
            _line.frame = CGRectMake(40, 6+89-9-6+2*num, 240, 18);
        }
        
        NSLog(@"%f",DEVICE_WIDTH);
        
        if (DEVICE_WIDTH == 414) {
            [_line setFrame:CGRectMake(55, 6+119-9-6+2*num, 305, 18)];
            
        }
        
        
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
    
}




-(void)viewWillAppear:(BOOL)animated
{
    
    [MBProgressHUD showHUDAddedTo:_fourJiaoImageView animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!TARGET_IPHONE_SIMULATOR) {
            [self checkAVAuthorizationStatus];
            [MBProgressHUD hideHUDForView:_fourJiaoImageView animated:YES];
        }
    });

    
}

- (void)checkAVAuthorizationStatus
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    NSString *tips = NSLocalizedString(@"AVAuthorization", @"您没有权限访问相机");
    if(status == AVAuthorizationStatusAuthorized) {
        // authorized
        [self setupCamera];
    } else {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您没有权限访问相机,请到设置界面打开相机设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alertView show];
    }
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //_preview.frame =CGRectMake(20,110,280,280);
    _preview.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    
    
    
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];

    [timer invalidate];
    NSLog(@"123");
    
    NSLog(@"%@",stringValue);
    
    NSString* string_uid=[personal getuidwithstring:stringValue];
    
    
    if ([string_uid isEqualToString:@"0"] || string_uid.length == 0 || [string_uid isEqual:[NSNull null]])
    {
        if (([stringValue rangeOfString:@"http://"].length && [stringValue rangeOfString:@"."].length)||([stringValue rangeOfString:@"https://"].length && [stringValue rangeOfString:@"."].length))
        {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否打开此链接" message:stringValue delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            alert.tag = 100000;
            
            _urlStr = stringValue;
            
            [alert show];
            
        }else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"未识别的二维码" message:stringValue delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil,nil];
            alert.tag = 30;
            [alert show];
        }
    }else{
        
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"_____stringuid===%@_____",string_uid);
            [self pushtonewmineWithUid:string_uid];
        }];
        
        
    }
    
    
}


-(void)pushtonewmineWithUid:(NSString *)theuserid{
    [self.delegate erweimapushWithString:theuserid];
    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (alertView.tag == 100000) {
        if (buttonIndex == 1) {//确定
            if (_urlStr) {
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.delegate pushWebViewWithStr:_urlStr];
                }];
                
            }
        }else{
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }else if (alertView.tag == 30){
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}






#pragma mark - 点击我的二维码跳转
-(void)myErweima{
    NSLog(@"%s",__FUNCTION__);
    [self dismissViewControllerAnimated:YES completion:^{
        
        
        if (self.delegate) {
            [self.delegate pushMyerweimaVcWithUid:[[NSUserDefaults standardUserDefaults] objectForKey:USER_UID]];
        }
        
        
    }];
    
    
}





@end
