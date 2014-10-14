//
//  fbWebViewController.h
//  FbLife
//
//  Created by 史忠坤 on 13-6-20.
//  Copyright (c) 2013年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "downloadtool.h"
#import "bottombarview.h"
//#import "bbsdetailViewController.h"
#import "AlertRePlaceView.h"
#import "loadingimview.h"
#import "WXApi.h"
#import <MessageUI/MessageUI.h>
#import "WeiboSDK.h"
#import <MessageUI/MFMailComposeViewController.h>
//新版分享

#import "ShareView.h"


@interface fbWebViewController : UIViewController<UIWebViewDelegate,NSURLConnectionDataDelegate,UITextFieldDelegate,UIWebViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,downloaddelegate,AlertRePlaceViewDelegate,BottombarviewDelegate,WXApiDelegate,MFMailComposeViewControllerDelegate,WeiboSDKDelegate>{
    UIWebView *awebview;
    UIButton *button_comment;
    UILabel *titleview;
    //分享的标题和链接

    NSMutableArray *my_array;
    NSString *string_title;
    
    


}
@property(nonatomic,strong) NSString * urlstring;
@end
