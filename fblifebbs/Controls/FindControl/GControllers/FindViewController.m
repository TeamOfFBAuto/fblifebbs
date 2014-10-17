//
//  FindViewController.m
//  fblifebbs
//
//  Created by szk on 14-10-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FindViewController.h"
#import "FriendCircleViewController.h"

#define COLOR_VIEW_BACKGROUND [UIColor colorWithRed:246/255.F green:247/255.F blue:249/255.F alpha:1.0]//视图背景颜色

#define COLOR_TABLE_LINE [UIColor colorWithRed:229/255.F green:231/255.F blue:230/255.F alpha:1.0]//teleview分割线颜色

#define COLOR_SEARCHBAR [UIColor colorWithRed:217/255.F green:217/255.F blue:217/255.F alpha:1.0]//teleview分割线颜色


@interface FindViewController ()

@end

@implementation FindViewController



- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}






- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"发现";
    
    _tabelview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568) style:UITableViewStyleGrouped];
    _tabelview.delegate = self;
    _tabelview.dataSource = self;
    [self.view addSubview:_tabelview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - UITableViewDateSource & UITableViewDelegate


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 0;
    
    if (section == 0) {
        num = 1;
    }else if (section ==1){
        num = 2;
    }
    return num;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    //图标
    UIImageView *titleImv = [[UIImageView alloc]initWithFrame:CGRectMake(12, 17, 20, 20)];
    [cell.contentView addSubview:titleImv];
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleImv.frame)+15, 19, 130, 17)];
    [cell.contentView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = RGBCOLOR(49, 49, 49);
    
    //箭头
    UIImageView *jiantouImv = [[UIImageView alloc]initWithFrame:CGRectMake(298, 17, 7, 15)];
    jiantouImv.image = [UIImage imageNamed:@"jiantou@.png"];
    [cell.contentView addSubview:jiantouImv];
    
    
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        titleImv.image = [UIImage imageNamed:@"friend.png"];
        titleLabel.text = @"好友动态";
    }else if (indexPath.row == 0 && indexPath.section == 1){
        titleImv.image = [UIImage imageNamed:@"news.png"];
        titleLabel.text = @"e族新闻";
    }else if (indexPath.row == 1 && indexPath.section == 1){
        titleImv.image = [UIImage imageNamed:@"shangcheng.png"];
        titleLabel.text = @"e族商城";
    }
    
    
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 70;
    }else if (section == 1){
        return 17;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


/**
 *  搜索view
 */
- (UIView *)createSearchView
{
    UIView *search_bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 320, 44)];
    //    search_bgview.backgroundColor = [UIColor colorWithHexString:@"cac9ce"];
    
    //    search_bgview.backgroundColor = [UIColor redColor];
    [self.view addSubview:search_bgview];
    
    UISearchBar *bar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    bar.placeholder = @"搜索";
    bar.delegate = self;
    bar.layer.borderWidth = 2.f;
    bar.layer.borderColor = COLOR_SEARCHBAR.CGColor;
    bar.barTintColor = COLOR_SEARCHBAR;
    [search_bgview addSubview:bar];
    return search_bgview;
}



/**
 *  搜索页
 */
- (void)clickToSearch:(UIButton *)sender
{
    NSLog(@"searchPage  跳转到搜索页面");
    
    [self.navigationController pushViewController:[[GFoundSearchViewController3 alloc]init] animated:YES];
    
    
}




#pragma - mark UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self clickToSearch:nil];
    return NO;
}




-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    if (section == 0) {//搜索条
        view.backgroundColor = RGBCOLOR(238, 238, 238);
        view.frame = CGRectMake(0, 0, 320, 70);
        UIView *search_bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 52)];
        //    search_bgview.backgroundColor = [UIColor colorWithHexString:@"cac9ce"];
        
        //    search_bgview.backgroundColor = [UIColor redColor];
        [view addSubview:search_bgview];
        
        UISearchBar *bar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 52)];
        bar.placeholder = @"搜索帖子/版块/用户";
        bar.delegate = self;
        bar.layer.borderWidth = 2.f;
        bar.layer.borderColor = COLOR_SEARCHBAR.CGColor;
        bar.barTintColor = COLOR_SEARCHBAR;
        [search_bgview addSubview:bar];
        
    }else if (section == 1){
        view.frame = CGRectMake(0, 0, 320, 17);
    }
    return view;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1 && indexPath.section == 1) {
        GshoppingWebViewController * vv = [[GshoppingWebViewController alloc]init];        
        [self PushControllerWith:vv WithAnimation:YES];
        
    }else if (indexPath.section == 0 && indexPath.row == 0)///好友动态
    {
        FriendCircleViewController * circle = [[FriendCircleViewController alloc] init];
        [self PushControllerWith:circle WithAnimation:YES];
    }
    
    
}



@end
