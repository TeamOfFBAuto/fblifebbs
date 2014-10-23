//
//  VerificationViewController.h
//  越野e族
//
//  Created by soulnear on 13-12-26.
//  Copyright (c) 2013年 soulnear. All rights reserved.
//
/*
 **输入验证码
 */

#import <UIKit/UIKit.h>
#import "ZhuCeViewController.h"

@interface VerificationViewController : SNViewController<ASIHTTPRequestDelegate>
{
    UITextField * verification_tf;
    
    ASIHTTPRequest * request_;
    
    ASIHTTPRequest * reSend_request;
    
    int time_number;
    
    NSTimer * timer;
    
    UILabel * time_label;
    
    UIButton * ReSendButton;
}

@property(nonatomic,strong)NSString * MyPhoneNumber;




@end
