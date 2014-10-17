//
//  GFoundSearchViewController3.h
//  fblifebbs
//
//  Created by gaomeng on 14-10-17.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "SNViewController.h"
#import "CustomSegmentView.h"
#import "NewWeiBoCustomCell.h"
#import "MWPhotoBrowser.h"
#import "LoadingIndicatorView.h"
#import "SearchNewsView.h"
#import "PersonInfo.h"
#import "newsdetailViewController.h"
#import "NewWeiBoDetailViewController.h"
#import "NewMineViewController.h"
#import "bbsdetailViewController.h"
#import "BBSfenduiViewController.h"

@interface GFoundSearchViewController3 : SNViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CustomSegmentViewDelegate,NewWeiBoCustomCellDelegate,MWPhotoBrowserDelegate>
{
    UIView * searchheaderview;
    
    UIImageView * ImgV_ofsearch;
    
    UITextField * _searchbar;
    
    CustomSegmentView * mysegment;
    
    UIButton * cancelButton;
    
    int mysearchPage;
    
    BOOL issearchloadsuccess;
    
    ASIHTTPRequest * request_search;
    
    NSMutableArray * array_cache;
    
    NSMutableArray * array_search_bankuai;
    
    NSMutableArray * array_search_bbs;
    
    NSMutableArray * array_search_user;
    
    NSMutableArray * weibo_search_data;
    
    int current_select;
    
    NSString *string_searchurl;
    
    int search_user_page;
    
    LoadingIndicatorView *searchloadingview;//search的tab的footview
    
    int total_count_users;
    
    NewWeiBoCustomCell * test_cell;
    
    LogInViewController * logIn;
}


///主视图，显示数据
@property(nonatomic,strong)UITableView * myTableView;


///存放所有数据
@property(nonatomic,strong)NSMutableArray * data_array;

@property(nonatomic,strong)NSMutableArray * array_searchresault;

@property(nonatomic,strong)NSMutableArray * photos;



@end
