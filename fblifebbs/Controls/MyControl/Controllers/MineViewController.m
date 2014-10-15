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

@interface MineViewController ()
{
    NSArray *images_arr;
    NSArray *names_arr;
    
    MineHeaderCell *headerCell;
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
    
    images_arr = @[@"",@"",@"",@"shoucang@2x.png",@"tiezi@2x.png",@"friend@2x.png",@"",@"mingpian@2x.png",@"youxiang@2x.png",@"lishijilu@2x.png"];
    names_arr = @[@"",@"",@"",@"我的收藏",@"我的帖子",@"我的好友",@"",@"我的名片",@"草稿箱",@"历史浏览"];
    
    
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
            
            headerCell.nameLabel.width = [LTools widthForText:user.username font:16];
            
            if ([user.gender integerValue] == 0) {
                NSLog(@"man");
                
            }else
            {
                NSLog(@"women");
                
                headerCell.genderImage.selected = YES;
                
            }
            headerCell.genderImage.left = headerCell.nameLabel.right + 10;
            headerCell.descriptionLabel.text = user.aboutme.length ? user.aboutme : @"无";
            headerCell.tiezi_num_label.text = user.topic_count;
            headerCell.fans_num_label.text = user.fans_count;
            headerCell.guanzhu_num_label.text =  user.follow_count;
            
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        ;
    }];
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
        return cell;
    }
    
    if (indexPath.row == 1) {
        headerCell = [tableView dequeueReusableCellWithIdentifier:@"MineHeaderCell"];
        if (!headerCell) {
            headerCell = [[[NSBundle mainBundle]loadNibNamed:@"MineHeaderCell" owner:self options:nil]objectAtIndex:0];
        }

        return headerCell;
    }
    
    MineRowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineRowCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MineRowCell" owner:self options:nil]objectAtIndex:0];
    }
    
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

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
//    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
//    
//    // Pass the selected object to the new view controller.
//    
//    // Push the view controller.
//    [self.navigationController pushViewController:detailViewController animated:YES];
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
