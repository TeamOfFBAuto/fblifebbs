//
//  MessageTableView.m
//  fblifebbs
// 
//  Created by soulnear on 14-10-13.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "MessageTableView.h"
#import "CustomMessageCell.h"
#import "MyChatViewController.h"

@implementation MessageTableView
@synthesize myTableView = _myTableView;
@synthesize data_array = _data_array;



-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
        
    }
    return self;
}

-(void)setup
{
    NewsMessageNumber = 0;
    
    _data_array = [NSMutableArray array];
    _myTableView = [[RefreshTableView alloc] initWithFrame:self.bounds showLoadMore:NO];
    _myTableView.dataSource = self;
    _myTableView.refreshDelegate = self;
    _myTableView.separatorInset = UIEdgeInsetsZero;
    [self addSubview:_myTableView];
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
    if (isLogin)
    {
        [self initHttpRequest];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccess:) name:NOTIFICATION_LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logoutSuccess:) name:NOTIFICATION_LOGOUT_SUCCESS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HaveNetWork:) name:NOTIFICATION_HAVE_NETWORK object:nil];
    
    
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:20.0f target:self selector:@selector(checkallmynotification) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

#pragma mark - 登陆成功
-(void)loginSuccess:(NSNotification *)notification
{
    _myTableView.pageNum = 1;
    [self initHttpRequest];
}

#pragma mark - 退出登录成功
-(void)logoutSuccess:(NSNotification *)notification
{
    [_data_array removeAllObjects];
    [_myTableView finishReloadigData];
    
}

#pragma mark - 来网啦
-(void)HaveNetWork:(NSNotification * )notification
{
    if (_data_array.count == 0)
    {
        [self initHttpRequest];
    }
}

#pragma mark - 网络请求
#pragma mark-获取私信列表
-(void)initHttpRequest
{
    [request_tools cancelRequest];
    
    NSString * string = [[NSUserDefaults standardUserDefaults] objectForKey:USER_AUTHOD];
    request_tools = [[LTools alloc] initWithUrl:[NSString stringWithFormat:GET_MESSAGE_LIST_URL,string] isPost:NO postData:nil];
    
    NSLog(@"私信首页url --  %@",[NSString stringWithFormat:GET_MESSAGE_LIST_URL,string]);
    
    __weak typeof(self)bself = self;
    [request_tools requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        @try {
            
            [bself.data_array removeAllObjects];
            NSArray * infoArray = [result objectForKey:@"info"];
            
            if (![infoArray isKindOfClass:[NSArray class]]) {
                return ;
            }
            
            NSLog(@"info===%@",infoArray);
            
            for (NSDictionary * dic in infoArray)
            {
                MessageInfo * info = [[MessageInfo alloc] initWithDictionary:dic];
                
                [bself.data_array addObject:info];
                
            }
            NSUserDefaults *stau=[NSUserDefaults standardUserDefaults];
            [stau setObject:infoArray forKey:@"whyhavenodata"];
            NSLog(@"youmuyou==%@",[stau objectForKey:@"whyhavenodata"]);
            [stau synchronize];
            
            if (bself.data_array.count == 0)///此时没有数据了
            {
                
            }else
            {
                
            }
            
            [bself.myTableView finishReloadigData];
            
        }
        @catch (NSException *exception)
        {
            
        }
        @finally {
            
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        
        [bself.myTableView finishReloadigData];
    }];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data_array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = [NSString stringWithFormat:@"%d",indexPath.row];
    
    CustomMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[CustomMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.headImageView.image = nil;
    cell.NameLabel.text = @"";
    cell.timeLabel.text = @"";
    cell.contentLabel1.text = @"";
    cell.contentLabel.text = @"";
    
    
    cell.tixing_label.hidden=YES;
    
    MessageInfo * info = [self.data_array objectAtIndex:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [cell setAllViewWithType:0];
    
    [cell setInfoWithType:0 withMessageInfo:info];
    
    UIColor *color = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2f];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
    cell.selectedBackgroundView.backgroundColor =color;
    return cell;
}

#pragma mark - 停止刷新加载
-(void)stopRefresh
{
    [_myTableView finishReloadigData];
    [zsnApi showAutoHiddenMBProgressWithText:@"您尚未登录" addToView:[UIApplication sharedApplication].keyWindow];
}

///下拉加载
- (void)loadNewData
{
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
    if (isLogin)
    {
        [self initHttpRequest];
    }else
    {
        [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:1.5];
    }
}
///上拉更多
- (void)loadMoreData
{
    
}


- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CustomMessageCell * cell = (CustomMessageCell *)[_myTableView cellForRowAtIndexPath:indexPath];
    cell.tixing_label.hidden = YES;
    
    MessageInfo * info = [self.data_array objectAtIndex:indexPath.row];
    MyChatViewController * chat = [[MyChatViewController alloc] init];
    chat.info = info;
    UIViewController * vc = [self getSuperViewController];
    chat.hidesBottomBarWhenPushed = YES;
    [vc.navigationController pushViewController:chat animated:YES];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}
- (UIView *)viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


-(UIViewController *)getSuperViewController
{
    return (UIViewController *)_delegate;
}


#pragma mark - 每隔20秒去请求是否有新数据
-(void)checkallmynotification
{
    NSString * fullUrl = [NSString stringWithFormat:@"http://fb.fblife.com/openapi/index.php?mod=alert&code=alertnumbytype&fromtype=b5eeec0b&authkey=%@&fbtype=json",[personal getMyAuthkey]];
    check_request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullUrl]];
    typeof(self)wself = self;
    typeof(check_request)wrequest = check_request;
    
    [wrequest setCompletionBlock:^{
        
        @try {
            NSDictionary *dic=[check_request.responseString objectFromJSONString];
                NewsMessageNumber = 0;
                NSDictionary * alertnum_dic = [dic objectForKey:@"alertnum"];
                
//                NSLog(@"未读消息 ------  %@",alertnum_dic);
            
                for (int i = 0;i <= 16;i++)
                {
                    if (i == 6)
                    {
                        if ([[alertnum_dic objectForKey:[NSString stringWithFormat:@"%d",i]] intValue]>0)
                        {
                            [wself initHttpRequest];
                        }
                    }else
                    {
                        NewsMessageNumber += [[alertnum_dic objectForKey:[NSString stringWithFormat:@"%d",i]] intValue];
                    }
                }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }];
    
    [wrequest setFailedBlock:^{
        
    }];
    
    [check_request startAsynchronous];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
























