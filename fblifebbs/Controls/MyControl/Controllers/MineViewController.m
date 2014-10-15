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
//#define k_User_Name @"k_User_Name"
//#define <#macro#>(<#args#>)


@interface MineViewController ()<FriendListViewControllerDelegate>
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
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:USER_IN]) {
        
        LogInViewController *login = [LogInViewController sharedManager];
        
        [self presentViewController:login animated:YES completion:nil];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    
//    UIBarButtonItem * spaceButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    spaceButton1.width = MY_MACRO_NAME?-13:5;
    
    UIButton *settings=[[UIButton alloc]initWithFrame:CGRectMake(MY_MACRO_NAME? -5:5,8,40,44)];
    [settings addTarget:self action:@selector(clickToSettings:) forControlEvents:UIControlEventTouchUpInside];
    [settings setImage:[UIImage imageNamed:BACK_DEFAULT_IMAGE] forState:UIControlStateNormal];
    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:settings];
    self.navigationItem.rightBarButtonItem = back_item;
    
    images_arr = @[@"",@"",@"",@"shoucang@2x.png",@"tiezi@2x.png",@"friend@2x.png",@"",@"mingpian@2x.png",@"youxiang@2x.png",@"lishijilu@2x.png"];
    names_arr = @[@"",@"",@"",@"我的收藏",@"我的帖子",@"我的好友",@"",@"我的名片",@"草稿箱",@"历史浏览"];
    
    self.navigationItem.title = @"我";
    
    [self getUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            
            UserModel *user = [[UserModel alloc]initWithDictionary:dic];
            
            [headerCell.headImage setImageWithURL:[NSURL URLWithString:user.face_small] placeholderImage:nil];
            headerCell.nameLabel.text = user.username;
            
            [LTools cache:user.username ForKey:@""];
            
            headerCell.nameLabel.width = [LTools widthForText:user.username font:16];
            
            if ([user.gender integerValue] == 0) {
                NSLog(@"man");
                
            }else
            {
                NSLog(@"women");
                
                headerCell.genderImage.selected = YES;
                
            }
            headerCell.genderImage.hidden = NO;
            headerCell.genderImage.left = headerCell.nameLabel.right + 10;
            
            NSString *des = [NSString stringWithFormat:@"简介:%@",user.aboutme.length ? user.aboutme : @"无"];
            headerCell.descriptionLabel.text = des;
            headerCell.tiezi_num_label.text = user.topic_count;
            headerCell.fans_num_label.text = user.fans_count;
            headerCell.guanzhu_num_label.text =  user.follow_count;
            
            userId = user.uid;
            
            [headerCell.userInfo_buttom addTarget:self action:@selector(clickToUserCenter:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        ;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 6) {
        
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

        return headerCell;
    }
    
    MineRowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineRowCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MineRowCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.iconImage.image = [UIImage imageNamed:[images_arr objectAtIndex:indexPath.row]];
    cell.aTitleLabel.text = [names_arr objectAtIndex:indexPath.row];
    
    return cell;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate
 
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 6) {
        
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
        
    }else if (indexPath.row == 8)
    {
        //历史浏览
        
        
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
