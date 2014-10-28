//
//  BBSViewController.m
//  fblifebbs
//
//  Created by szk on 14-10-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "BBSViewController.h"
#import "SliderBBSTitleView.h"
#import "SliderForumCollectionModel.h"
#import "SliderBBSForumSegmentView.h"
#import "ASINetworkQueue.h"
#import "BBSRankingView.h"
#import "BBSfenduiViewController.h"
#import "bbsdetailViewController.h"
#import "RankingListModel.h"
#import "GFoundSearchViewController3.h"


@interface SliderBBSForumModel ()
{
    
}

@end


@implementation SliderBBSForumModel
@synthesize forum_fid = _forum_fid;
@synthesize forum_name = _forum_name;
@synthesize forum_sub = _forum_sub;
@synthesize forum_isHave_sub = _forum_isHave_sub;
@synthesize forum_isOpen = _forum_isOpen;


-(SliderBBSForumModel *)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    
    if (self)
    {
        self.forum_sub = [NSMutableArray array];
        
        self.forum_isOpen = NO;
        
        NSString * string = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"gid"]];
        
        
        self.forum_fid = string;
        
        if (string.length == 0)
        {
            self.forum_fid = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"fid"]];
        }
        
        self.forum_name = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"name"]];
        
        NSArray * arrary1 = [dic objectForKey:@"sub"];
        
        if (arrary1.count> 0)
        {
            _forum_isHave_sub = YES;
            
            for (NSDictionary * dic1 in arrary1)
            {
                SliderBBSForumModel * model1 = [[SliderBBSForumModel alloc] initWithDictionary:dic1];
                
                [self.forum_sub addObject:model1];
            }
        }else
        {
            _forum_isHave_sub = NO;
        }
    }
    
    return self;
}




@end



@interface BBSViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshDelegate,UISearchBarDelegate>
{
    ///顶部选择器
    SliderBBSTitleView * _seg_view;
    ///存放论坛版块标题
    NSArray * forum_title_array;
    /// 当前论坛版块
    ForumType theType;
    ///当前论坛板块
    int current_forum;
    ///是否点开第三层
    int history_second_cell;
    //所有收藏的论坛版块数据
    SliderForumCollectionModel * collection_model;
    ///请求数据队列
    ASINetworkQueue * networkQueue;
    ///排行榜
    BBSRankingView * rangkingView;
}

@end

@implementation BBSViewController
@synthesize seg_current_page = _seg_current_page;
@synthesize myScrollView = _myScrollView;
@synthesize myTableView1 = _myTableView1;
@synthesize forum_chexing_array = _forum_chexing_array;
@synthesize forum_jiaoyi_array = _forum_jiaoyi_array;
@synthesize forum_diqu_array = _forum_diqu_array;
@synthesize forum_section_collection_array = _forum_section_collection_array;
@synthesize forum_temp_array = _forum_temp_array;
@synthesize forum_zhuti_array = _forum_zhuti_array;


-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置状态栏(如果整个app是统一的状态栏，其他地方不用再设置)
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    forum_title_array = [NSArray arrayWithObjects:@"diqu",@"chexing",@"zhuti",@"jiaoyi",nil];
    _forum_diqu_array = [NSMutableArray array];
    _forum_chexing_array = [NSMutableArray array];
    _forum_zhuti_array = [NSMutableArray array];
    _forum_jiaoyi_array = [NSMutableArray array];
    _forum_temp_array = [NSMutableArray arrayWithObjects:_forum_diqu_array,_forum_chexing_array,_forum_zhuti_array,_forum_jiaoyi_array,nil];
    theType = ForumDiQuType;
    
    current_forum = 0;

    ///加载顶部选择
    __weak typeof(self)bself = self;
    _seg_view = [[SliderBBSTitleView alloc] initWithFrame:CGRectMake(0,70,240,44)];
    [_seg_view setAllViewsWith:[NSArray arrayWithObjects:@"地区",@"车型",@"主题",@"交易",nil] withBlock:^(int index) {
//        bself.seg_current_page = index;
        
        if (current_forum == index) {
            return ;
        }
        current_forum = index;
        [bself isHaveCacheDataWith:index];
    }];
    
    self.navigationItem.titleView = _seg_view;
    
    
    /*
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH+20,DEVICE_HEIGHT-64-49)];
    _myScrollView.delegate = self;
    _myScrollView.bounces = NO;
    _myScrollView.showsHorizontalScrollIndicator = NO;
    _myScrollView.showsVerticalScrollIndicator = NO;
    _myScrollView.pagingEnabled = YES;
    _myScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_myScrollView];
    _myScrollView.contentSize = CGSizeMake((DEVICE_WIDTH+20)*2,0);
     */
    
    ///论坛部分
    _myTableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT-64-49)];
    _myTableView1.delegate = self;
    _myTableView1.dataSource = self;
    _myTableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView1];
    
    UIView *table_sectionV = [[UIView alloc]initWithFrame:CGRectZero];
    table_sectionV.backgroundColor = [UIColor clearColor];
    table_sectionV.backgroundColor = [UIColor whiteColor];
    table_sectionV.frame = CGRectMake(0, 0,DEVICE_WIDTH,52);
    UIView *search_bgview = [[UIView alloc]initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,52)];
    [table_sectionV addSubview:search_bgview];
    UISearchBar *bar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,52)];
    bar.placeholder = @"搜索帖子/版块/用户";
    bar.delegate = self;
    bar.layer.borderWidth = 2.f;
    bar.layer.borderColor = COLOR_SEARCHBAR.CGColor;
    bar.barTintColor = COLOR_SEARCHBAR;
    [search_bgview addSubview:bar];
    
    _myTableView1.tableHeaderView = table_sectionV;
    
  /*老版选择版块界面
    SliderBBSForumSegmentView * forumSegmentView = [[SliderBBSForumSegmentView alloc] initWithFrame:CGRectMake(0,52,DEVICE_WIDTH,63)];
    [forumSegmentView setAllViewsWithTextArray:[NSArray arrayWithObjects:@"地区",@"车型",@"主题",@"交易",nil] WithImageArray:[NSArray arrayWithObjects:@"bbs_forum_earth",@"bbs_forum_car",@"bbs_forum_zhuti",@"bbs_forum_jiaoyi",@"bbs_forum_earth-1",@"bbs_forum_car-1",@"bbs_forum_zhuti-1",@"bbs_forum_jiaoyi-1",nil] WithBlock:^(int index) {
        
        if (current_forum == index) {
            return ;
        }
        
        current_forum = index;
        
        [bself isHaveCacheDataWith:index];
    }];
    
    [table_sectionV addSubview:forumSegmentView];
   */
    
    
    
/*
    ///排行榜部分
    rangkingView = [[BBSRankingView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH+20,0,DEVICE_WIDTH,_myScrollView.frame.size.height)];
    [_myScrollView addSubview:rangkingView];
    
    
    [rangkingView setRangkingBlock:^(int index, id object){
         NSLog(@"index--------%d",index);
        
        switch (index) {
            case 0:///bbsdetail
            {
                RankingListModel * model = (RankingListModel*)object;
                bbsdetailViewController * detail = [[bbsdetailViewController alloc] init];
                detail.bbsdetail_tid = model.ranking_id;
                detail.hidesBottomBarWhenPushed = YES;
                [bself.navigationController pushViewController:detail animated:YES];
            }
                break;
            case 1:///bbsfendui
            {
                RankingListModel * model = (RankingListModel*)object;
                
                BBSfenduiViewController * fendui = [[BBSfenduiViewController alloc] init];
                fendui.string_id = model.ranking_id;
                fendui.collection_array = bself.forum_section_collection_array;
                fendui.hidesBottomBarWhenPushed = YES;
                [bself.navigationController pushViewController:fendui animated:YES];
            }
                break;
            case 2:///login
            {
                LogInViewController * logIn = [LogInViewController sharedManager];
                [bself presentViewController:logIn animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
    }];
 */
    
    ///数据请求
    [self loadAllForums];
   
    
    [self loadCollectionForumSectionData];

    //论坛版块收藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forumSectionChange:) name:@"forumSectionChange" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HaveNetWork:) name:NOTIFICATION_HAVE_NETWORK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoNetWork:) name:NOTIFICATION_NO_NETWORK object:nil];
    
}

#pragma mark - 获取论坛版块收藏更改通知

-(void)forumSectionChange:(NSNotification *)notification
{
//    NSDictionary * dictionary = notification.userInfo;
//    
//    NSString * theId = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"forumSectionId"]];
//    
//    if ([self.forum_section_collection_array containsObject:theId])
//    {
//        [self.forum_section_collection_array removeObject:theId];
//    }else
//    {
//        [self.forum_section_collection_array addObject:theId];
//    }
//    
//    [rangkingView.bbs_forum_collection_array removeAllObjects];
//    [rangkingView.bbs_forum_collection_array addObjectsFromArray:self.forum_section_collection_array];
//    
//    [self.myTableView1 reloadData];
    
    [self loadCollectionForumSectionData];
}

#pragma mark - 读取所有收藏版块数据信息
-(void)loadCollectionForumSectionData
{
    collection_model = [[SliderForumCollectionModel alloc] init];
    
    __weak typeof(self) bself = self;
    
    if (!_forum_section_collection_array)
    {
        _forum_section_collection_array = [NSMutableArray array];
    }else
    {
        [_forum_section_collection_array removeAllObjects];
    }
    
    //第一个参数第一页  第二个参数一页显示多少个，这里要全部的数据所以给1000
    [collection_model loadCollectionDataWith:1 WithPageSize:100 WithFinishedBlock:^(NSMutableArray *array) {
        
        [bself.forum_section_collection_array addObjectsFromArray:collection_model.collect_id_array];
        [bself.myTableView1 reloadData];
        
        rangkingView.bbs_forum_collection_array = [NSMutableArray arrayWithArray:collection_model.collect_id_array];
        [rangkingView.myTableView reloadData];
        [[NSUserDefaults standardUserDefaults] setObject:bself.forum_section_collection_array forKey:@"forumSectionCollectionArray"];
        
    } WithFailedBlock:^(NSString *string) {
        
        bself.forum_section_collection_array = [[NSUserDefaults standardUserDefaults] objectForKey:@"forumSectionCollectionArray"];
        [bself.myTableView1 reloadData];
        rangkingView.bbs_forum_collection_array = [NSMutableArray arrayWithArray:bself.forum_section_collection_array];
        [rangkingView.myTableView reloadData];
    }];
    
}


#pragma mark - 网络请求部分
#pragma mark - 判断论坛有没有缓存数据
-(void)isHaveCacheDataWith:(int)index
{
    //获取版块数据
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * dictionary = [userDefaults objectForKey:[NSString stringWithFormat:@"forum%@",[forum_title_array objectAtIndex:index]]];
    
    [[_forum_temp_array objectAtIndex:index] removeAllObjects];
    
    if (!dictionary)
    {
        [self loadAllForums];
    }else
    {
        for (NSDictionary * dic in dictionary)
        {
            SliderBBSForumModel * model = [[SliderBBSForumModel alloc] initWithDictionary:dic];
            
            if (dictionary.count == 1 && model.forum_isHave_sub)
            {
                model.forum_isOpen = YES;
            }
            
            [[_forum_temp_array objectAtIndex:current_forum] addObject:model];
        }
        
        [_myTableView1 reloadData];
    }
}

///请求全部版块数据
-(void)loadAllForums
{
    
    if (!networkQueue) {
        networkQueue = [[ASINetworkQueue alloc] init];
    }
    
    for (int i = 0;i < 4;i++)
    {
        NSString * fullUrl = [NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumsbycategory.php?categorytype=%@&formattype=json&authocode=%@",[forum_title_array objectAtIndex:i],AUTHKEY];
        
       // NSLog(@"请求版块接口-----%@",fullUrl);
        
        ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fullUrl]];
        request.tag = 417 + i;
        [networkQueue addOperation:request];
    }
    
    networkQueue.delegate = self;
    [networkQueue setRequestDidFinishSelector:@selector(requestFinished:)];
    [networkQueue setRequestDidFailSelector:@selector(requestFailed:)];
    [networkQueue setQueueDidFinishSelector:@selector(queueFinished:)];
    [networkQueue go];
}


#pragma mark - ASI队列回调方法，处理返回数据

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary * allDic = [request.responseString objectFromJSONString];
    
    NSLog(@"版块请求结果----%@",allDic);
    
    if ([[allDic objectForKey:@"errcode"] intValue] == 0)
    {
        NSArray * array = [allDic objectForKey:@"bbsinfo"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            
            for (NSDictionary * dic in array)
            {
                SliderBBSForumModel * model = [[SliderBBSForumModel alloc] initWithDictionary:dic];
                
                if (array.count == 1 && model.forum_isHave_sub)
                {
                    model.forum_isOpen = YES;
                }
                
                [[_forum_temp_array objectAtIndex:request.tag-417] addObject:model];
            }
            
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            
            [userDefaults setObject:array forKey:[NSString stringWithFormat:@"forum%@",[forum_title_array objectAtIndex:request.tag-417]]];
            
            [userDefaults synchronize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (request.tag - 417 == current_forum)
                {
                    [_myTableView1 reloadData];
                }
            });
        });
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{

}


- (void)queueFinished:(ASIHTTPRequest *)request
{
    if ([networkQueue requestsCount] == 0) {
        
        networkQueue = nil;
        
    }
    NSLog(@"队列完成");
    
}

#pragma mark - 如果没有获取到某一版块信息，那么当有网的时候再请求一次
///有网情况
-(void)HaveNetWork:(NSNotification *)notification
{
    for (int i = 0;i < _forum_temp_array.count;i++) {
        NSMutableArray * array = [_forum_temp_array objectAtIndex:i];
        if (array.count == 0)
        {
            [self isHaveCacheDataWith:i];
        }
    }
    
    if (_forum_section_collection_array.count==0) {
        [self loadCollectionForumSectionData];
    }
}
///网络断开
-(void)NoNetWork:(NSNotification *)notification
{
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _myTableView1) {
        
        return [[_forum_temp_array objectAtIndex:current_forum] count];
    }else
    {
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _myTableView1)
    {
        SliderBBSForumModel * model = [[_forum_temp_array objectAtIndex:current_forum] objectAtIndex:section];
        return model.forum_isOpen?model.forum_sub.count:0;
        
    }else
    {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _myTableView1) {
        static NSString * identifier = @"cell";
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        for (UIView * view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        SliderBBSForumModel * model = [[_forum_temp_array objectAtIndex:current_forum] objectAtIndex:indexPath.section];
        
        if (model.forum_isOpen)
        {
            SliderBBSForumModel * second_model = [model.forum_sub objectAtIndex:indexPath.row];
            UILabel * second_name_label = [[UILabel alloc] initWithFrame:CGRectMake(17,0,200,44)];
            second_name_label.text = second_model.forum_name;
            second_name_label.font = [UIFont systemFontOfSize:15];
            second_name_label.textColor = RGBCOLOR(124,124,124);
            second_name_label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:second_name_label];
            
            UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-50,5,0.5,34)];
            line_view.backgroundColor = RGBCOLOR(228,228,228);
            [cell.contentView addSubview:line_view];
            
            
            //收藏按钮
            ZSNButton * collection_button = [ZSNButton buttonWithType:UIButtonTypeCustom];
            collection_button.frame = CGRectMake(DEVICE_WIDTH-49,0,49,44);
            collection_button.myDictionary = [NSDictionary dictionaryWithObject:second_model.forum_fid forKey:@"tid"];
            [collection_button setImage:[UIImage imageNamed:@"bbs_forum_collect1"] forState:UIControlStateNormal];
            [collection_button setImage:[UIImage imageNamed:@"bbs_forum_collect2"] forState:UIControlStateSelected];
            collection_button.selected = [_forum_section_collection_array containsObject:second_model.forum_fid];
            [collection_button addTarget:self action:@selector(CollectForumSectionTap:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:collection_button];
            
            if (!second_model.forum_isHave_sub)
            {
                
            }else
            {
                ZSNButton * accessory_button = [ZSNButton buttonWithType:UIButtonTypeCustom];
                accessory_button.frame = CGRectMake(DEVICE_WIDTH-95,0,40,44);
                [accessory_button setImage:[UIImage imageNamed:@"bbs_forum_jiantou"] forState:UIControlStateNormal];
                [accessory_button setImage:[UIImage imageNamed:@"bbs_forum_jiantou-1"] forState:UIControlStateSelected];
                accessory_button.selected = second_model.forum_isOpen;
                accessory_button.myDictionary = [NSDictionary dictionaryWithObject:indexPath forKey:@"indexPath"];
                [accessory_button addTarget:self action:@selector(ShowAndHiddenThirdView:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:accessory_button];
            }
            
            
            UIView * single_line_view = [[UIView alloc] initWithFrame:CGRectMake(16,43.5,DEVICE_WIDTH,0.5)];
            single_line_view.backgroundColor = RGBCOLOR(225,225,225);
            [cell.contentView addSubview:single_line_view];
            
            
            if (indexPath.row == model.forum_sub.count - 1)
            {
                single_line_view.frame = CGRectMake(0,43.5,DEVICE_WIDTH,0.5);
            }
            
            
            if (second_model.forum_isOpen)
            {
                single_line_view.hidden = YES;
                
                UIView * third_view = [self loadthirdViewWithIndexPath:indexPath];
                
                [cell.contentView addSubview:third_view];
            }
        }
        
        return cell;
    }else
    {
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _myTableView1)
    {
        SliderBBSForumModel * first_model = [[_forum_temp_array objectAtIndex:current_forum] objectAtIndex:indexPath.section];
        
        SliderBBSForumModel * second_model = [first_model.forum_sub objectAtIndex:indexPath.row];
        
        if (second_model.forum_isOpen)
        {
            int count = (int)second_model.forum_sub.count;
            int row = count/2 + (count%2?1:0);
            float height = 22 + row*36 + (row-1)*7;
            return height + 44;
        }else
        {
            return 44;
        }
    }else
    {
        return 0;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _myTableView1)
    {
        return 44;
    }else
    {
        return 0;
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _myTableView1)
    {
        SliderBBSForumModel * model = [[_forum_temp_array objectAtIndex:current_forum] objectAtIndex:section];
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,44)];
        view.tag = 10000 + section;
        view.backgroundColor = [UIColor whiteColor];
        
        
        UILabel * name_label = [[UILabel alloc] initWithFrame:CGRectMake(16,0,200,44)];
        name_label.text = model.forum_name;
        name_label.font = [UIFont systemFontOfSize:17];
        name_label.textAlignment = NSTextAlignmentLeft;
        name_label.textColor = RGBCOLOR(49,49,49);
        name_label.backgroundColor = [UIColor clearColor];
        [view addSubview:name_label];
        
        UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-50,5,0.5,34)];
        line_view.backgroundColor = RGBCOLOR(228,228,228);
        [view addSubview:line_view];
        
        UIView * bottom_line_view = [[UIView alloc] initWithFrame:CGRectMake(0,43.5,DEVICE_WIDTH,0.5)];
        bottom_line_view.backgroundColor = RGBCOLOR(228,228,228);
        [view addSubview:bottom_line_view];
        
        
        
        if (section == 0)
        {
            UIView * top_line_view = [[UIView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,0.5)];
            top_line_view.backgroundColor = RGBCOLOR(228,228,228);
            [view addSubview:top_line_view];
        }
        
        
        
        if (model.forum_isHave_sub)
        {
            UIButton * fenlei_button = [UIButton buttonWithType:UIButtonTypeCustom];
            fenlei_button.userInteractionEnabled = NO;
            fenlei_button.frame = CGRectMake(DEVICE_WIDTH-49,0,49,44);
            [fenlei_button setImage:[UIImage imageNamed:@"bbs_forum_fenlei"] forState:UIControlStateNormal];
            fenlei_button.backgroundColor = [UIColor clearColor];
            //            [fenlei_button addTarget:self action:@selector(ShowSecondView:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:fenlei_button];
        }
        
        
        //跳转到对应的版块页
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowSecondView:)];
        
        [view addGestureRecognizer:tap];
        
        return view;
    }else
    {
        return nil;
    }
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _myTableView1)
    {
        SliderBBSForumModel * first_model = [[_forum_temp_array objectAtIndex:current_forum] objectAtIndex:indexPath.section];
        
        SliderBBSForumModel * second_model = [first_model.forum_sub objectAtIndex:indexPath.row];
        
        [self pushToBBSForumDetailWithId:second_model.forum_fid];
        
    }
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}


//滚动视图释放滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //判断选择 精选推荐 还是 全部版块
    if (scrollView == _myScrollView)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        // 根据当前的x坐标和页宽度计算出当前页数
        int current_page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        [_seg_view MyButtonStateWithIndex:current_page];
    }else if (scrollView == _myTableView1)
    {
        
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}



#pragma mark - 跳转到对应的版块页

-(void)ShowForumSectionDetailTap:(UITapGestureRecognizer *)sender
{
    [self pushToBBSForumDetailWithId:[NSString stringWithFormat:@"%d",sender.view.tag - 1000000]];
}

-(void)pushToBBSForumDetailWithId:(NSString *)theId
{
    BBSfenduiViewController * fendui = [[BBSfenduiViewController alloc] init];
    fendui.string_id = theId;
    fendui.collection_array = self.forum_section_collection_array;
    [self PushControllerWith:fendui WithAnimation:YES];
}



#pragma mark ------------------
#pragma mark - 收藏取消收藏版块


-(void)CollectForumSectionTap:(ZSNButton *)sender
{
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
    
    if (!isLogin)
    {
        LogInViewController * logIn = [LogInViewController sharedManager];
        [self presentViewController:logIn animated:YES completion:NULL];
        return;
    }
    
    
    
    NSString * tid = [sender.myDictionary objectForKey:@"tid"];
    
    BOOL isCollected = [self.forum_section_collection_array containsObject:tid];
    
    NSString * fullUrl = @"";
    
    if (isCollected)
    {
        fullUrl = [NSString stringWithFormat:COLLECTION_CANCEL_FORUM_SECTION_URL_OLD,tid,AUTHKEY];
    }else
    {
        fullUrl = [NSString stringWithFormat:COLLECTION_FORUM_SECTION_URL_OLD,tid,AUTHKEY];
    }
    
    
    NSLog(@"收藏取消收藏接口 ----   %@",fullUrl);
    
    NSURL * url = [NSURL URLWithString:fullUrl];
    
    
    ASIHTTPRequest * collect_request = [[ASIHTTPRequest alloc] initWithURL:url];
    
    __block typeof(collect_request) request = collect_request;
    
    __weak typeof(self) bself = self;
    
    [request setCompletionBlock:^{
        
        NSDictionary * dictionary = [collect_request.responseString objectFromJSONString];
        
        NSLog(@"收藏取消收藏 ----  %@",dictionary);
        
        
        if ([[dictionary objectForKey:@"errcode"] intValue] == 0)
        {
            if (isCollected)
            {
                [bself.forum_section_collection_array removeObject:tid];
            }else
            {
                [bself.forum_section_collection_array addObject:tid];
            }
            
            [bself.myTableView1 reloadData];
        }else
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:[dictionary objectForKey:@"bbsinfo"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            
            [alertView show];
        }
    }];
    
    [request setFailedBlock:^{
        
    }];
    
    [collect_request startAsynchronous];
}

#pragma mark - 显示第三层数据

-(UIView *)loadthirdViewWithIndexPath:(NSIndexPath *)indexPath
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0,44,DEVICE_WIDTH,0)];
    
    view.clipsToBounds = YES;
    
    view.backgroundColor = RGBCOLOR(238,238,238);
    
    SliderBBSForumModel * first_model = [[_forum_temp_array objectAtIndex:current_forum] objectAtIndex:indexPath.section];
    
    SliderBBSForumModel * second_model = [first_model.forum_sub objectAtIndex:indexPath.row];
    
    int count = (int)second_model.forum_sub.count;
    
    int row = count/2 + (count%2?1:0);
    
    for (int i = 0;i < row;i++) {
        for (int j = 0;j < 2;j++)
        {
            if (i*2 + j < count)
            {
                SliderBBSForumModel * model = [second_model.forum_sub objectAtIndex:i*2+j];
                UIView * back_view = [[UIView alloc] initWithFrame:CGRectMake(17 + 146*j,11+43*i,139,36)];
                back_view.tag = [model.forum_fid intValue] + 1000000;
                back_view.backgroundColor = [UIColor whiteColor];
                back_view.layer.masksToBounds = NO;
                back_view.layer.borderColor = RGBCOLOR(197,197,197).CGColor;
                back_view.layer.borderWidth = 0.5;
                [view addSubview:back_view];
                
                UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(100,3,0.5,30)];
                line_view.backgroundColor = RGBCOLOR(209,209,209);
                [back_view addSubview:line_view];
                
                UILabel * name_label = [[UILabel alloc] initWithFrame:CGRectMake(10,0,80,36)];
                name_label.text = model.forum_name;
                name_label.textAlignment = NSTextAlignmentLeft;
                name_label.textColor = RGBCOLOR(134,134,134);
                name_label.backgroundColor = [UIColor clearColor];
                name_label.font = [UIFont systemFontOfSize:15];
                [back_view addSubview:name_label];
                
                
                ZSNButton * collect_button = [ZSNButton buttonWithType:UIButtonTypeCustom];//收藏按钮
                collect_button.frame = CGRectMake(105,3,30,30);
                [collect_button setImage:[UIImage imageNamed:@"bbs_forum_collect1"] forState:UIControlStateNormal];
                [collect_button setImage:[UIImage imageNamed:@"bbs_forum_collect2"] forState:UIControlStateSelected];
                collect_button.myDictionary = [NSDictionary dictionaryWithObject:model.forum_fid forKey:@"tid"];
                collect_button.selected = [_forum_section_collection_array containsObject:model.forum_fid];
                [collect_button addTarget:self action:@selector(CollectForumSectionTap:) forControlEvents:UIControlEventTouchUpInside];
                collect_button.backgroundColor = [UIColor clearColor];
                [back_view addSubview:collect_button];
                
                //跳转到对应的版块页
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowForumSectionDetailTap:)];
                
                [back_view addGestureRecognizer:tap];
            }
        }
    }
    
    view.frame = CGRectMake(0,44,DEVICE_WIDTH,22 + row*36 + (row-1)*7);
    
    return view;
}


#pragma mark - 弹出收回二级分类按钮

-(void)ShowSecondView:(UITapGestureRecognizer *)sender
{
    SliderBBSForumModel * model = [[_forum_temp_array objectAtIndex:current_forum] objectAtIndex:sender.view.tag-10000];
    model.forum_isOpen = !model.forum_isOpen;
    [_myTableView1 reloadSections:[NSIndexSet indexSetWithIndex:sender.view.tag-10000] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - 弹出收回三级分类

-(void)ShowAndHiddenThirdView:(ZSNButton *)sender
{
    NSIndexPath * indexPath = [sender.myDictionary objectForKey:@"indexPath"];
    SliderBBSForumModel * first_model = [[_forum_temp_array objectAtIndex:current_forum] objectAtIndex:indexPath.section];
    SliderBBSForumModel * second_model = [first_model.forum_sub objectAtIndex:indexPath.row];
    
    second_model.forum_isOpen = !second_model.forum_isOpen;
    
    NSIndexPath * indexP;
    
    for (int i = 0;i < first_model.forum_sub.count;i++)
    {
        SliderBBSForumModel * model = [first_model.forum_sub objectAtIndex:i];
        
        if (model.forum_isOpen && i!=indexPath.row)
        {
            model.forum_isOpen = !model.forum_isOpen;
            
            indexP = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
        }
    }
    
    
    [_myTableView1 reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,indexP,nil] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - 上拉加载下拉刷新代理
- (void)loadNewData
{
    
}
- (void)loadMoreData
{
    
}

#pragma mark - UISearchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    GFoundSearchViewController3 * search = [[GFoundSearchViewController3 alloc] init];
    [self PushControllerWith:search WithAnimation:YES];
    
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end




















