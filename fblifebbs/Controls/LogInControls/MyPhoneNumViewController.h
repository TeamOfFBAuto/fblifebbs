//
//  MyPhoneNumViewController.h
//  越野e族
//
//  Created by soulnear on 13-12-26.
//  Copyright (c) 2013年 soulnear. All rights reserved.
//
/*
 **验证手机号
 */

#import <UIKit/UIKit.h>
#import "VerificationViewController.h"

@interface MyPhoneNumViewController : SNViewController<UITextFieldDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate>
{
    UITextField * phone_textField;
    
    ASIHTTPRequest * myRequest;
    
}

@end
