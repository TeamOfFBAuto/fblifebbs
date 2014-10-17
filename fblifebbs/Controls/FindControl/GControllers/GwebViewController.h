//
//  GwebViewController.h
//  fblifebbs
//
//  Created by gaomeng on 14/10/17.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "SNViewController.h"

@interface GwebViewController : SNViewController<UIWebViewDelegate>
{
    UIWebView *awebview;
    UIButton *button_comment;
    UILabel *titleview;
    
    NSMutableArray *my_array;
    NSString *string_title;
}
@property(nonatomic,strong) NSString * urlstring;

@end
