//
//  MessageViewController.m
//  fblifebbs
//as 
//  Created by szk on 14-10-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "MessageViewController.h"
#import "SliderBBSTitleView.h"
#import "MessageTableView.h"
#import "MessageInfo.h"
#import "NotificationView.h"

@interface MessageViewController ()<MessageTableViewDelegate>
{
    ///顶部选择视图
    SliderBBSTitleView * _seg_view;
    ///私信界面
    MessageTableView * message_tableView;
    
}

@end

@implementation MessageViewController
@synthesize myScrollView = _myScrollView;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
    if (!isLogin)
    {
        LogInViewController * logIn = [LogInViewController sharedManager];
        [self presentViewController:logIn animated:YES completion:nil];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ///加载顶部选择
    __weak typeof(self)bself = self;
    _seg_view = [[SliderBBSTitleView alloc] initWithFrame:CGRectMake(0,0,260,44)];
    [_seg_view setAllViewsWith:[NSArray arrayWithObjects:@"私信",@"FB",@"论坛",nil] withBlock:^(int index) {
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
    _myScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_myScrollView];
    _myScrollView.contentSize = CGSizeMake((DEVICE_WIDTH+20)*3,0);
    
    message_tableView = [[MessageTableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,_myScrollView.frame.size.height)];
    message_tableView.delegate = self;
    [_myScrollView addSubview:message_tableView];
    

    NotificationView * fbView = [[NotificationView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH+20,0,DEVICE_WIDTH,_myScrollView.frame.size.height) withType:NotificationViewTypeFB];
    [_myScrollView addSubview:fbView];
    
    NotificationView * bbsView = [[NotificationView alloc] initWithFrame:CGRectMake((DEVICE_WIDTH+20)*2,0,DEVICE_WIDTH,_myScrollView.frame.size.height) withType:NotificationViewTypeBBS];
    [_myScrollView addSubview:bbsView];
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
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}


-(void)dealloc
{
    
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
