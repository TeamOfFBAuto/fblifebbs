//
//  FindViewController.h
//  fblifebbs
//
//  Created by szk on 14-10-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//


//发现页面

#import <UIKit/UIKit.h>
#import "GFoundSearchViewController3.h"//搜索   用户 帖子 论坛
#import "GwebViewController.h"//商城
#import "fbWebViewController.h"

@interface FindViewController : SNViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UITableView *_tabelview;
}


-(void)erweimapushWithString:(NSString *)str;

-(void)pushMyerweimaVcWithUid:(NSString *)str;

-(void)pushWebViewWithStr:(NSString *)stringValue;

@end

