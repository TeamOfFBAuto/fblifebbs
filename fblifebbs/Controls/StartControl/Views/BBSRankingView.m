//
//  BBSRankingView.m
//  fblifebbs
//
//  Created by soulnear on 14-10-14.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "BBSRankingView.h"
#import "RankingListSegmentView.h"
#import "RankingListModel.h"
//#import "bbsdetailViewController.h"
//#import "BBSfenduiViewController.h"
#import "SliderForumCollectionModel.h"

@implementation BBSRankingView
@synthesize myTableView = _myTableView;
@synthesize data_array = _data_array;
@synthesize currentPage = _currentPage;
@synthesize bbs_forum_collection_array = _bbs_forum_collection_array;
@synthesize bbs_post_collection_array = _bbs_post_collection_array;
@synthesize rangkingBlock = _rangkingBlock;


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

///创建视图
-(void)setup
{
    
    _bbs_forum_collection_array = [NSMutableArray array];
    _bbs_post_collection_array = [NSMutableArray array];
    
    _data_array = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],nil];
    _myTableView = [[RefreshTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorColor = RGBCOLOR(223,223,223);
    if (MY_MACRO_NAME) {
        _myTableView.separatorInset = UIEdgeInsetsZero;
    }
    [self addSubview:_myTableView];
    
    __weak typeof(self) bself = self;
    
    _currentPage = 1;
    
    ranking_segment = [[RankingListSegmentView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,56.5) WithBlock:^(int index) {
        
        bself.currentPage = index + 1;
        
        [bself.myTableView reloadData];
        
        if ([[bself.data_array objectAtIndex:index] count] == 0)
        {
            [bself loadRankingListDataWithIndex:index+1];
        }
    }];
    
    [self loadRankingListDataWithIndex:_currentPage];
    [self loadAllBBSPostData];
    [self loadCollectionForumSectionData];
    
    _myTableView.tableHeaderView = ranking_segment;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successLogIn:) name:@"LogIn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bbsDetailCollectChanged:) name:@"bbsDetailCollectChanged" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bbsForumCollectChanged:) name:@"forumSectionChange" object:nil];
}

#pragma mark - 主题收藏变更通知
-(void)bbsDetailCollectChanged:(NSNotification *)notification
{
    [self loadAllBBSPostData];
}
#pragma mark - 版块收藏变更
-(void)bbsForumCollectChanged:(NSNotification *)notification
{
    [self loadCollectionForumSectionData];
}
#pragma mark - 请求排行榜数据

-(void)loadRankingListDataWithIndex:(int)index
{
    if (!myModel)
    {
        myModel = [[RankingListModel alloc] init];
    }
    
    __weak typeof(self) bself = self;
    
    [myModel loadRankingListDataWithType:index WithComplicationBlock:^(NSMutableArray *array)
     {
         [bself.data_array replaceObjectAtIndex:index-1 withObject:array];
         
         [bself.myTableView reloadData];
         
     } WithFailedBlock:^(NSString *errinfo) {
         
     }];
}

#pragma mark - 登陆成功代理方法
-(void)successLogIn:(NSNotification *)notification
{
    [self loadAllBBSPostData];
}

#pragma mark - 请求收藏的所有的帖子
-(void)loadAllBBSPostData
{
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];

    if (!isLogin)
    {
//        rangking_block(2,nil);
        return;
    }
    
    
    if (!_bbs_post_collection_array) {
        _bbs_post_collection_array = [NSMutableArray array];
    }else
    {
        [_bbs_post_collection_array removeAllObjects];
    }
    
    NSString * fullUrl = [NSString stringWithFormat:GET_COLLECTION_BBS_POST_URL,AUTHKEY];
    
    NSLog(@"获取收藏帖子接口 --   %@",fullUrl);
    
    ASIHTTPRequest * bbs_request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fullUrl]];
    
    __block typeof(bbs_request) request = bbs_request;
    
    __weak typeof(self) bself = self;
    
    [request setCompletionBlock:^{
        
        @try
        {
            NSDictionary * allDic = [bbs_request.responseString objectFromJSONString];
            
            if ([[allDic objectForKey:@"errcode"] intValue] == 0)
            {
                NSArray * array = [allDic objectForKey:@"bbsinfo"];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    
                    for (NSDictionary * dic in array)
                    {
                        [bself.bbs_post_collection_array addObject:[dic objectForKey:@"tid"]];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (bself.currentPage == 1)
                        {
                            [bself.myTableView reloadData];
                        }
                    });
                });
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }];
    
    
    [request setFailedBlock:^{
        
    }];
    
    [bbs_request startAsynchronous];
}

#pragma mark - 读取所有收藏版块数据信息
-(void)loadCollectionForumSectionData
{
    SliderForumCollectionModel * collection_model = [[SliderForumCollectionModel alloc] init];
    
    __weak typeof(self) bself = self;
    
    if (!_bbs_forum_collection_array)
    {
        _bbs_forum_collection_array = [NSMutableArray array];
    }else
    {
        [_bbs_forum_collection_array removeAllObjects];
    }
    
    //第一个参数第一页  第二个参数一页显示多少个，这里要全部的数据所以给1000
    [collection_model loadCollectionDataWith:1 WithPageSize:100 WithFinishedBlock:^(NSMutableArray *array) {
        
        [bself.bbs_forum_collection_array addObjectsFromArray:collection_model.collect_id_array];
        [bself.myTableView reloadData];
        
        [[NSUserDefaults standardUserDefaults] setObject:bself.bbs_forum_collection_array forKey:@"forumSectionCollectionArray"];
    } WithFailedBlock:^(NSString *string) {
        
        bself.bbs_forum_collection_array = [[NSUserDefaults standardUserDefaults] objectForKey:@"forumSectionCollectionArray"];
        [bself.myTableView reloadData];
    }];
}


#pragma mark - UITableViewDelegate


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}



#pragma  mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.data_array objectAtIndex:_currentPage-1] count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    
    RankingListCustomCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[RankingListCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    RankingListModel * model = [[_data_array objectAtIndex:_currentPage-1] objectAtIndex:indexPath.row];
    
    [cell setInfoWith:indexPath.row + 1 WithModel:model WithType:self.currentPage];
        
    cell.collection_button.selected = [self.currentPage==1?self.bbs_post_collection_array:self.bbs_forum_collection_array containsObject:model.ranking_id];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentPage-1 == 0)
    {
        RankingListModel * model = [[_data_array objectAtIndex:_currentPage-1] objectAtIndex:indexPath.row];
        
//        bbsdetailViewController * detail = [[bbsdetailViewController alloc] init];
//        detail.bbsdetail_tid = model.ranking_id;
//        detail.collection_array = self.bbs_post_collection_array;
//        [self.navigationController pushViewController:detail animated:YES];
        rangking_block(0,model);
        
    }else
    {
        if ([[_data_array objectAtIndex:_currentPage-1] count] > 0)
        {
            RankingListModel * model = [[_data_array objectAtIndex:_currentPage-1] objectAtIndex:indexPath.row];
            
//            BBSfenduiViewController * detail = [[BBSfenduiViewController alloc] init];
//            detail.string_id = model.ranking_id;
//            detail.string_name = model.ranking_title;
//            detail.collection_array = self.bbs_forum_collection_array;
//            [self.navigationController pushViewController:detail animated:YES];
            rangking_block(1,model);
        }
    }
}



#pragma mark - RankingListCellDelegate

#pragma mark - 收藏或取消收藏

-(void)cancelOrCollectSectionsWith:(RankingListCustomCell *)cell
{
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
    
    if (!isLogin)
    {
        rangking_block(2,nil);
        return;
    }
    
    
    NSIndexPath * indexPath = [_myTableView indexPathForCell:cell];
    
    RankingListModel * model = [[_data_array objectAtIndex:_currentPage-1] objectAtIndex:indexPath.row];
    
    NSString * fullUrl = @"";
    
    BOOL isCollected;
    
    if (self.currentPage == 1)
    {
        isCollected = [self.bbs_post_collection_array containsObject:model.ranking_id];
        
        if (!isCollected)
        {
            fullUrl = [NSString stringWithFormat:COLLECTION_BBS_POST_URL,AUTHKEY,model.ranking_id];
        }else
        {
            fullUrl = [NSString stringWithFormat:DELETE_COLLECTION_BBS_POST_URL,model.ranking_id,AUTHKEY];
        }
        
    }else
    {
        isCollected = [self.bbs_forum_collection_array containsObject:model.ranking_id];
        
        if (!isCollected)
        {
            fullUrl = [NSString stringWithFormat:COLLECTION_FORUM_SECTION_URL_OLD,model.ranking_id,AUTHKEY];
        }else
        {
            fullUrl = [NSString stringWithFormat:COLLECTION_CANCEL_FORUM_SECTION_URL_OLD,model.ranking_id,AUTHKEY];
        }
    }
    
    NSLog(@"收藏取消收藏 ---  %@",fullUrl);
    
    
    NSURL * url = [NSURL URLWithString:fullUrl];
    
    
    ASIHTTPRequest * collect_request = [[ASIHTTPRequest alloc] initWithURL:url];
    
    __block typeof(collect_request) request = collect_request;
    
    __weak typeof(self) bself = self;
    
    [request setCompletionBlock:^{
        
        cell.collection_button.selected = !isCollected;
        
        if (isCollected)//取消收藏
        {
            if (bself.currentPage == 1)
            {
                if ([bself.bbs_post_collection_array containsObject:model.ranking_id])
                {
                    [bself.bbs_post_collection_array removeObject:model.ranking_id];
                }
            }else
            {
                //                if ([bself.bbs_forum_collection_array containsObject:model.ranking_id])
                //                {
                //                    [bself.bbs_forum_collection_array removeObject:model.ranking_id];
                //                }
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"forumSectionChange" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:model.ranking_id,@"forumSectionId",nil]];
            }
            
        }else//收藏
        {
            if (bself.currentPage == 1)
            {
                if (![bself.bbs_post_collection_array containsObject:model.ranking_id])
                {
                    [bself.bbs_post_collection_array addObject:model.ranking_id];
                }
            }else
            {
                //                if (![bself.bbs_forum_collection_array containsObject:model.ranking_id])
                //                {
                //                    [bself.bbs_forum_collection_array addObject:model.ranking_id];
                //                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"forumSectionChange" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:model.ranking_id,@"forumSectionId",nil]];
            }
            
        }
    }];
    
    [request setFailedBlock:^{
        
    }];
    
    [collect_request startAsynchronous];
}


#pragma mark - 点击事件触发方法
-(void)setRangkingBlock:(BBSRankingViewBlock)rangkingBlock
{
    rangking_block = rangkingBlock;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
