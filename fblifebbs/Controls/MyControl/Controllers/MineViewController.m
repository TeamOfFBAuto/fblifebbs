//
//  MineViewController.m
//  fblifebbs
//
//  Created by lichaowei on 14-10-13.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "MineViewController.h"
#import "MineHeaderCell.h"
#import "MineRowCell.h"

#import "personal.h"

#import "UserModel.h"

#import "AppDelegate.h"

#import "ShoucangViewController.h"
#import "MyWriteAndCommentViewController.h"

#import "FriendListViewController.h"
#import "DraftBoxViewController.h"
#import "QrcodeViewController.h"

#import "NewMineViewController.h"

#import "SliderRightSettingViewController.h"

#import "ScanHistoyViewController.h"

#import "AppDelegate.h"

#define CURRENT_USER_HEADIMAGE @"HEADIMAGE"//头像

@interface MineViewController ()<FriendListViewControllerDelegate,LogInViewControllerDelegate>
{
    NSArray *images_arr;
    NSArray *names_arr;
    
    MineHeaderCell *headerCell;
    
    NSString *userId;
}

@end

@implementation MineViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    
        
    if (![defaults boolForKey:USER_IN]) {
            
            LogInViewController *login = [[LogInViewController alloc] init];
            
            login.delegate = self;
            
            UITabBarController *root = (UITabBarController *)((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
            
            [root presentViewController:login animated:YES completion:^{
                
                int index = [[defaults objectForKey:@"lastVC"]integerValue];
                
                root.selectedIndex = index;
                
            }];

    }else
    {
        
        NSDictionary *dic = [LTools cacheForKey:@"userInfo"];
        
        UserModel *user = [[UserModel alloc]initWithDictionary:dic];
        
        [self getDataWithUserModel:user];
    }
    
}

-(void)successToLogIn
{
    UITabBarController *root = (UITabBarController *)((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    root.selectedIndex = 4;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7DAOHANGLANBEIJING_PUSH] forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton.width = MY_MACRO_NAME?-5:5;
    
    UIButton *settings=[[UIButton alloc]initWithFrame:CGRectMake(20,8,40+10,44)];
    [settings addTarget:self action:@selector(clickToSettings:) forControlEvents:UIControlEventTouchUpInside];
    [settings setImage:[UIImage imageNamed:@"shezhi"] forState:UIControlStateNormal];
    [settings setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:settings];
    self.navigationItem.rightBarButtonItems = @[spaceButton,back_item];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccess:) name:NOTIFICATION_LOGIN_SUCCESS object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginOut:) name:@"logoutToChangeHeader" object:nil];
    
    images_arr = @[@"",@"",@"",@"shoucang@2x.png",@"tiezi@2x.png",@"friend_my@2x.png",@"",@"mingpian@2x.png",@"youxiang@2x.png",@"lishijilu@2x.png"];
    names_arr = @[@"",@"",@"",@"我的收藏",@"我的帖子",@"我的好友",@"",@"我的名片",@"草稿箱",@"最近浏览"];
    
    self.navigationItem.title = @"我";
    
    [self getUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  退出登录通知
 */
- (void)loginOut:(NSNotification *)notify
{
    [LTools cache:nil ForKey:@"userInfo"];
    
    NSDictionary *dic = [LTools cacheForKey:@"userInfo"];
    
    UserModel *user = [[UserModel alloc]initWithDictionary:dic];
    
    [self getDataWithUserModel:user];
}

- (void)loginSuccess:(NSNotification *)notify
{
    NSLog(@"loginSuccess");
    
    [self getUserInfo];
}

#pragma mark - 网络请求

- (void)getUserInfo
{
    NSString *url = [NSString stringWithFormat:URL_USERMESSAGE,[personal getMyUid],[personal getMyAuthkey]];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool requestSpecialCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSDictionary *data = [result objectForKey:@"data"];
        NSDictionary *dic = [data objectForKey:[personal getMyUid]];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
            [LTools cache:dic ForKey:@"userInfo"];
            
            UserModel *user = [[UserModel alloc]initWithDictionary:dic];
            
            [self getDataWithUserModel:user];
            
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        
    }];
}

#pragma mark - 点击事件

- (void)clickToUserCenter:(UIButton *)sender
{
    [self returnUserName:nil Uid:userId];
}

- (void)clickToSettings:(UIButton *)sender
{
    SliderRightSettingViewController * settingVC = [[SliderRightSettingViewController alloc] init];
    
    settingVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - 数据处理

- (void)getDataWithUserModel:(UserModel *)user
{
 
    [headerCell.headImage setImageWithURL:[NSURL URLWithString:user.face_small] placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
    
    headerCell.nameLabel.text = user.username;
    
    [LTools cache:user.username ForKey:@""];
    
    headerCell.nameLabel.width = [LTools widthForText:user.username font:16];
    
    
    headerCell.genderImage.hidden = NO;
    
    if ([user.gender integerValue] == 1) {
        NSLog(@"man");
        
//        headerCell.genderImage.hidden = NO;
        
        headerCell.genderImage.selected = NO;
        
    }else if([user.gender integerValue] == 0)
    {
        NSLog(@"women");
        
        headerCell.genderImage.selected = YES;
        
    }else
    {
        headerCell.genderImage.hidden = YES;
        NSLog(@"未知 sex");
    }
    
    
    headerCell.genderImage.left = headerCell.nameLabel.right + 10;
    
    NSString *des = [NSString stringWithFormat:@"简介:%@",user.aboutme.length ? user.aboutme : @"无"];
    headerCell.descriptionLabel.text = des;
    headerCell.tiezi_num_label.text = user.topic_count;
    headerCell.fans_num_label.text = user.fans_count;
    headerCell.guanzhu_num_label.text =  user.follow_count;
    
    userId = user.uid;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 10 + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 6 || indexPath.row == 10) {
        
        static NSString *identify = @"onecell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.row == 1) {
        headerCell = [tableView dequeueReusableCellWithIdentifier:@"MineHeaderCell"];
        if (!headerCell) {
            headerCell = [[[NSBundle mainBundle]loadNibNamed:@"MineHeaderCell" owner:self options:nil]objectAtIndex:0];
        }
        headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [headerCell.userInfo_buttom addTarget:self action:@selector(clickToUserCenter:) forControlEvents:UIControlEventTouchUpInside];

        if ([[NSUserDefaults standardUserDefaults]boolForKey:USER_IN]) {
            
            NSDictionary *dic = [LTools cacheForKey:@"userInfo"];
            
            UserModel *user = [[UserModel alloc]initWithDictionary:dic];
            
            [self getDataWithUserModel:user];
        }
        headerCell.lineView.height = 0.5f;
        
        return headerCell;
    }
    
    MineRowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineRowCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MineRowCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.iconImage.image = [UIImage imageNamed:[images_arr objectAtIndex:indexPath.row]];
    cell.aTitleLabel.text = [names_arr objectAtIndex:indexPath.row];
    cell.bottomLine.height = 0.5f;
    
    if (indexPath.row == images_arr.count - 1 || indexPath.row == 5) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    
    return cell;
    
}


#pragma mark - Table view delegate
 
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 6 || indexPath.row == 10) {
        
        return 12;
    }
    
    if (indexPath.row == 1) {
        return 132;
    }
    
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath %@",indexPath);
    
    if (indexPath.row == 3) {
        
        //我的收藏
        ShoucangViewController *shoucang = [[ShoucangViewController alloc]init];
        
        shoucang.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:shoucang animated:YES];
        
    }else if (indexPath.row == 4)
    {
        //我的帖子
        
        MyWriteAndCommentViewController *write = [[MyWriteAndCommentViewController alloc]init];
        
        write.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:write animated:YES];
        
    }else if (indexPath.row == 5)
    {
        //我的好友
        
        FriendListViewController * friend = [[FriendListViewController alloc] init];
        
        friend.title_name_string = @"联系人";
        
        friend.delegate = self;
        
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:friend];
        
        [self presentViewController:nav animated:YES completion:NULL];
        
    }else if (indexPath.row == 7)
    {
        //我的名片
        
        QrcodeViewController *vc = [[QrcodeViewController alloc]init];
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (indexPath.row == 8)
    {
        //草稿箱
        
        DraftBoxViewController *vc = [[DraftBoxViewController alloc]init];
        
        vc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 9)
    {
        //历史浏览
        
        ScanHistoyViewController *vc = [[ScanHistoyViewController alloc]init];
        
        vc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(AppDelegate *)getAppDelegate
{
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return appdelegate;
}



#pragma mark - 联系人代理，跳转到个人界面

-(void)returnUserName:(NSString *)username Uid:(NSString *)uid
{
    NewMineViewController * mine = [[NewMineViewController alloc] init];
    
    mine.uid = uid;
    
    
    mine.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:mine animated:YES];
}

@end
