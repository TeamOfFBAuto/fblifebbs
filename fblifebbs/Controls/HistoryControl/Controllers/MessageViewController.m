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
#import "NewMessageViewController.h"
#import "MyChatViewController.h"
#import "AppDelegate.h"

@interface MessageViewController ()<MessageTableViewDelegate,NewMessageViewControllerDelegate,NotificationViewDelegate,LogInViewControllerDelegate>
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
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:USER_IN]) {
        
        LogInViewController *login = [[LogInViewController alloc] init];
        
        login.delegate = self;
        
        UITabBarController *root = (UITabBarController *)((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
        
        [root presentViewController:login animated:YES completion:^{
            
            int index = [[defaults objectForKey:@"lastVC"]integerValue];
            
            root.selectedIndex = 0;
        }];
        
    }else
    {
        self.tabBarController.tabBar.hidden = NO;
    }
}

-(BOOL)isLogIn
{
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
    if (!isLogin)
    {
        LogInViewController * logIn = [LogInViewController sharedManager];
        [self presentViewController:logIn animated:YES completion:nil];
    }
    
    return isLogin;
}
#pragma mark - 登陆成功代理
-(void)successToLogIn
{
    UITabBarController *root = (UITabBarController *)((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    root.selectedIndex = 3;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self isLogIn];
    
    [self setSNViewControllerLeftButtonType:SNViewControllerLeftbuttonTypeNull WithRightButtonType:SNViewControllerRightbuttonTypeOther];
    self.rightImageName = WRITE_DEFAULT_IMAGE;
    
    ///加载顶部选择
    __weak typeof(self)bself = self;
    _seg_view = [[SliderBBSTitleView alloc] initWithFrame:CGRectMake(0,0,220,45)];
    [_seg_view setAllViewsWith:[NSArray arrayWithObjects:@"私信",@"FB",@"论坛",nil] withBlock:^(int index)
    {
        if (index == 0)
        {
            bself.my_right_button.hidden = NO;
        }else
        {
            bself.my_right_button.hidden = YES;
        }
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
    fbView.delegate = self;
    [_myScrollView addSubview:fbView];
    
    NotificationView * bbsView = [[NotificationView alloc] initWithFrame:CGRectMake((DEVICE_WIDTH+20)*2,0,DEVICE_WIDTH,_myScrollView.frame.size.height) withType:NotificationViewTypeBBS];
    bbsView.delegate = self;
    [_myScrollView addSubview:bbsView];
    
}

-(void)rightButtonTap:(UIButton *)sender
{
    BOOL isLog = [self isLogIn];
    if (isLog)
    {
        NewMessageViewController * newMessage = [[NewMessageViewController alloc] init];
        newMessage.delegate = self;
        [self presentViewController:newMessage animated:YES completion:NULL];
    }
}


#pragma mark-newMessageViewControllerDelegate

-(void)sucessToSendWithName:(NSString *)userName Uid:(NSString *)theUid
{
    MessageInfo * info = [[MessageInfo alloc] init];
    info.to_username = userName;
    info.othername = userName;
    info.to_uid = theUid;
    info.from_username = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME];
    info.from_uid = [[NSUserDefaults standardUserDefaults] objectForKey:USER_UID];
    MyChatViewController * chat = [[MyChatViewController alloc] init];
    chat.info = info;
    [self PushControllerWith:chat WithAnimation:YES];
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
