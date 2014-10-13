//
//  FindViewController.m
//  fblifebbs
//
//  Created by szk on 14-10-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FindViewController.h"

#define COLOR_VIEW_BACKGROUND [UIColor colorWithRed:246/255.F green:247/255.F blue:249/255.F alpha:1.0]//视图背景颜色

#define COLOR_TABLE_LINE [UIColor colorWithRed:229/255.F green:231/255.F blue:230/255.F alpha:1.0]//teleview分割线颜色

#define COLOR_SEARCHBAR [UIColor colorWithRed:217/255.F green:217/255.F blue:217/255.F alpha:1.0]//teleview分割线颜色


@interface FindViewController ()

@end

@implementation FindViewController

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
    return 44;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 0;
    
    if (section == 0) {
        num = 1;
    }else if (section ==1){
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
    
    [self.navigationController pushViewController:[[GFoundSearchViewController alloc]init] animated:YES];
    
    
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



@end
