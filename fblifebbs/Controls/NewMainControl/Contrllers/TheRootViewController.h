//
//  TheRootViewController.h
//  fblifebbs
//
//  Created by szk on 14-10-30.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheRootViewController : MyViewController<UITableViewDataSource,UITableViewDelegate,LogInViewControllerDelegate,UIScrollViewDelegate>{
    NSMutableArray *allArr;
    int currentpage;
    MBProgressHUD *hudView;
    
    int preTag;
    
    UIScrollView *newsScrow;

    
    
}

@property(nonatomic,strong)UITableView *mainTabV;

@end
