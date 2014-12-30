//
//  RecommendView.h
//  fblifebbs
//
//  Created by soulnear on 14-12-30.
//  Copyright (c) 2014年 szk. All rights reserved.
//
/*
 精选推荐
 */
///精选推荐
#import <UIKit/UIKit.h>
#import "RefreshTableView.h"
#import "NewHuandengView.h"


@protocol RecommendViewDelegate <NSObject>

-(void)RecommendViewSuperVC;

@end

@interface RecommendView : UIView<UITableViewDataSource,RefreshDelegate,NewHuandengViewDelegate>
{
    NSMutableArray * com_id_array;
    NSMutableArray * com_link_array;
    NSMutableArray * com_type_array;
    NSMutableArray * com_title_array;
    NSDictionary * huandengDic;
    
    NewHuandengView * bannerView;
    
    MBProgressHUD * hud;

}

@property(nonatomic,strong)RefreshTableView * mainTabView;
@property(nonatomic,strong)NSMutableArray * commentarray;
@property(nonatomic,strong)NSMutableArray * data_array;

@property(nonatomic,assign)id<RecommendViewDelegate>delegate;


@end
