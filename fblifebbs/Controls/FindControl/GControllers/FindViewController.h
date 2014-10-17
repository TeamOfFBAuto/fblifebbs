//
//  FindViewController.h
//  fblifebbs
//
//  Created by szk on 14-10-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//


//发现页面

#import <UIKit/UIKit.h>
#import "GFoundSearchViewController.h"
#import "GshoppingWebViewController.h"

@interface FindViewController : SNViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UITableView *_tabelview;
}
@end
