//
//  MessageViewController.m
//  fblifebbs
//
//  Created by szk on 14-10-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "MessageViewController.h"
#import "SliderBBSTitleView.h"
#import "MessageTableView.h"
#import "MessageInfo.h"

@interface MessageViewController ()
{
    ///顶部选择视图
    SliderBBSTitleView * _seg_view;
    ///私信界面
    MessageTableView * message_tableView;
    ///请求私信
    ASIHTTPRequest * _request_;
    
    ///私信接口数据容器
    NSMutableArray * message_array;
    ///通知数据容器
    NSMutableArray * notification_array;
}

@end

@implementation MessageViewController
@synthesize myScrollView = _myScrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    message_array = [NSMutableArray array];
    notification_array = [NSMutableArray array];
    
    
    ///加载顶部选择
    __weak typeof(self)bself = self;
    _seg_view = [[SliderBBSTitleView alloc] initWithFrame:CGRectMake(0,0,190,44)];
    [_seg_view setAllViewsWith:[NSArray arrayWithObjects:@"私信",@"通知",nil] withBlock:^(int index) {
        [bself.myScrollView setContentOffset:CGPointMake((DEVICE_WIDTH+20)*index,0) animated:YES];
        bself.seg_current_page = index;
    }];
    self.navigationItem.titleView = _seg_view;
    
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH+20,DEVICE_HEIGHT-64-49)];
    _myScrollView.delegate = self;
    _myScrollView.bounces = NO;
    _myScrollView.showsHorizontalScrollIndicator = NO;
    _myScrollView.showsVerticalScrollIndicator = NO;
    _myScrollView.pagingEnabled = YES;
    _myScrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_myScrollView];
    _myScrollView.contentSize = CGSizeMake((DEVICE_WIDTH+20)*2,0);
    
    message_tableView = [[MessageTableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,_myScrollView.frame.size.height)];
    [_myScrollView addSubview:message_tableView];
    
    
    [self initHttpRequest];
    
}

#pragma mark - 网络请求
#pragma mark-获取私信列表
-(void)initHttpRequest
{
    if (_request_)
    {
        [_request_ cancel];
        _request_.delegate  = nil;
        _request_ = nil;
    }
    
    NSString * string = [[NSUserDefaults standardUserDefaults] objectForKey:USER_AUTHOD];
    
    NSURL * fullUrl = [NSURL URLWithString:[NSString stringWithFormat:GET_MESSAGE_LIST_URL,string]];
    
    NSLog(@"私信首页url --  %@",fullUrl);
    
    _request_ = [ASIHTTPRequest requestWithURL:fullUrl];
    
    _request_.delegate = self;
    
    _request_.shouldAttemptPersistentConnection = NO;
    
    
    __block ASIHTTPRequest * request = _request_;
    
    [request setCompletionBlock:^{
        @try {
            
            NSDictionary * allDic = [_request_.responseData objectFromJSONData];
            
            [message_array removeAllObjects];
            NSArray * infoArray = [allDic objectForKey:@"info"];
            
            NSLog(@"info===%@",infoArray);
            
            for (NSDictionary * dic in infoArray)
            {
                MessageInfo * info = [[MessageInfo alloc] initWithDictionary:dic];
                
                [message_array addObject:info];
                
            }
            NSLog(@"这里。。。。。%@",message_array);
            
            NSUserDefaults *stau=[NSUserDefaults standardUserDefaults];
            [stau setObject:infoArray forKey:@"whyhavenodata"];
            NSLog(@"youmuyou==%@",[stau objectForKey:@"whyhavenodata"]);
            [stau synchronize];
            
            if (message_array.count == 0)///此时没有数据了
            {
                
            }else
            {
                
            }
            
            message_tableView.data_array = message_array;
        }
        @catch (NSException *exception)
        {
            
        }
        @finally {
            
        }
    }];
    
    
    [request setFailedBlock:^{
        
    }];
    
    [_request_ startAsynchronous];
}


-(void)dealloc
{
    [_request_ cancel];
    _request_.delegate = nil;
    _request_ = nil;
}


- (void)didReceiveMemoryWarning
{
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
