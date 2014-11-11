//
//  FindViewController.m
//  fblifebbs
//
//  Created by szk on 14-10-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FindViewController.h"
#import "FriendCircleViewController.h"
#import "BBSRecommendViewController.h"



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
    
    CGRect r = self.view.bounds;
    
    
    r.size.height  = DEVICE_HEIGHT-64-44;
    
    
    _tabelview = [[UITableView alloc]initWithFrame:r style:UITableViewStyleGrouped];
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
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 0;
    
    if (section == 0) {
        num = 1;
    }else if (section ==1 || section == 2){
        num = 2;
    }else if (section == 3){
        num = 3;
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
        titleImv.image = [UIImage imageNamed:@"fb.png"];
        titleLabel.text = @"好友动态";
    }else if (indexPath.row == 0 && indexPath.section == 1){
        titleImv.image = [UIImage imageNamed:@"jingxuan.png"];
        titleLabel.text = @"论坛精选";
    }else if (indexPath.row == 1 && indexPath.section == 1){
        titleImv.image = [UIImage imageNamed:@"huodong.png"];
        titleLabel.text = @"论坛活动";
    }else if (indexPath.row == 0 && indexPath.section == 2){
        titleImv.image = [UIImage imageNamed:@"fujin.png"];
        titleLabel.text = @"附近的人";
    }else if (indexPath.row == 1 && indexPath.section == 2){
        titleImv.image = [UIImage imageNamed:@"tuijian.png"];
        titleLabel.text = @"推荐用户";
    }else if (indexPath.row == 0 && indexPath.section == 3){
        titleImv.image = [UIImage imageNamed:@"news.png"];
        titleLabel.text = @"e族新闻";
    }else if (indexPath.row == 1 && indexPath.section == 3){
        titleImv.image = [UIImage imageNamed:@"shangcheng.png"];
        titleLabel.text = @"e族商城";
    }else if (indexPath.row == 2 && indexPath.section == 3){
        titleImv.image = [UIImage imageNamed:@"saoyisao.png"];
        titleLabel.text = @"扫一扫";
    }
    
    
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 70-17;
    }else{
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
    UIView *search_bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 44)];
    //    search_bgview.backgroundColor = [UIColor colorWithHexString:@"cac9ce"];
    
    //    search_bgview.backgroundColor = [UIColor redColor];
    [self.view addSubview:search_bgview];
    
    UISearchBar *bar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
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
    
    
    GFoundSearchViewController3 *gfoundSearchVC3 = [[GFoundSearchViewController3 alloc]init];
    [self presentViewController:gfoundSearchVC3 animated:YES completion:^{
        
    }];
//    [self PushControllerWith:gfoundSearchVC3 WithAnimation:YES];
    
    
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
        UIView *search_bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 52)];
        [view addSubview:search_bgview];
        
        UISearchBar *bar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 52)];
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
    
    if (indexPath.row == 1 && indexPath.section == 1) {//论坛活动
        
        
    }else if (indexPath.section == 0 && indexPath.row == 0){//好友动态
        
        BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
        if (!isLogIn) {
            LogInViewController * logIn = [LogInViewController sharedManager];
            [self presentViewController:logIn animated:YES completion:nil];
            return;
        }
        
        FriendCircleViewController * circle = [[FriendCircleViewController alloc] init];
        [self PushControllerWith:circle WithAnimation:YES];
        
    }else if (indexPath.row == 0 && indexPath.section == 1){//论坛精选
        BBSRecommendViewController * bbs = [[BBSRecommendViewController alloc] init];
        [self PushControllerWith:bbs WithAnimation:YES];
        
    }else if (indexPath.row == 0 && indexPath.section == 2){//附近的人
        
    }else if (indexPath.row == 1 && indexPath.section == 2){//推荐用户
        
    }else if (indexPath.row == 0 && indexPath.section == 3){//e族新闻
        GwebViewController * cc = [[GwebViewController alloc]init];
        cc.urlstring = @"http://m.fblife.com/news";
        [self PushControllerWith:cc WithAnimation:YES];
    }else if (indexPath.row == 1 && indexPath.section == 3){//e族商城
        GwebViewController * vv = [[GwebViewController alloc]init];
        vv.urlstring = @"http://m.fblife.com/mall/";
        [self PushControllerWith:vv WithAnimation:YES];
    }else if (indexPath.row == 2 && indexPath.section == 3){//扫一扫
        
    }
    
    
}



@end
