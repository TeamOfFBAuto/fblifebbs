//
//  FindViewController.h
//  fblifebbs
//
//  Created by szk on 14-10-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//




#import <UIKit/UIKit.h>
#import "GFoundSearchViewController.h"
@interface FindViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UITableView *_tabelview;
}
@end
