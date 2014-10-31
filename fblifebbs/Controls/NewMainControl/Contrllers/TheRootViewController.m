//
//  NewMainViewController.m
//  fblifebbs
//
//  Created by szk on 14-10-28.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "TheRootViewController.h"

#import "AppDelegate.h"

#import "ChangshiModel.h"

#import "ChangshiTableViewCell.h"

#import "BBSfenduiViewController.h"
#import "testbase.h"
#import "BBSRankingView.h"
#import "bbsdetailViewController.h"
#import "BBSfenduiViewController.h"


@interface TheRootViewController (){
    
    NSArray *dataArray;
    
}

@end

@implementation TheRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepairNavigationBar];
    [self setTabView];
    dataArray=[NSArray array];
    currentpage=1;
    allArr=[NSMutableArray array];
    preTag=100;
    
    [self loadRecentlyLookData];
    
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 读取所有最近浏览的数据

-(void)loadRecentlyLookData
{
    
    dataArray = [testbase findall];
    
    UIScrollView *   firstscro=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, iPhone5?568-20-40-40-49+3+49:480-19-40-40-49+3+49)];
    firstscro.contentSize=CGSizeMake(0,40* dataArray.count/2);
    firstscro.pagingEnabled=YES;
    firstscro.showsHorizontalScrollIndicator=NO;
    firstscro.showsVerticalScrollIndicator=NO;
    firstscro.backgroundColor=[UIColor whiteColor];
    [newsScrow addSubview:firstscro];
    
    
    for (int i=0; i<dataArray.count; i++) {
        
        UIButton *ytestButton=[LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(15+150*(i%2), 18+45*(i/2), 281/2, 73/2) normalTitle:nil image:nil backgroudImage:nil superView:firstscro target:self action:@selector(dofenduibutton:)];
        
        [ytestButton setBackgroundImage:[UIImage imageNamed:@"daduikuang.png"] forState:UIControlStateNormal];
        ytestButton.titleLabel.font=[UIFont systemFontOfSize:14];
        [ytestButton setTitleColor:RGBCOLOR(113, 113, 113) forState:UIControlStateNormal];
        
        testbase *test = [dataArray objectAtIndex:i];
        
        [ytestButton setTitle:test.name forState:UIControlStateNormal];
        
        ytestButton.tag=200+i;
        
        
    }
    
    
    
    
}

#pragma mark---点击最近浏览的大队

-(void)dofenduibutton:(UIButton *)sender{
    
    NSLog(@"跳转分队");
    
    testbase *test = [dataArray objectAtIndex:sender.tag-200];
    
    [self setHidesBottomBarWhenPushed:YES];
    
    [self pushToFenDuiDetailWithId:test.id_ofbbs WithName:test.name];
    
}

#pragma mark - 跳到分队详情界面

-(void)pushToFenDuiDetailWithId:(NSString *)theId WithName:(NSString *)theName
{
    
    
    BBSfenduiViewController * _fendui=[[BBSfenduiViewController alloc]init];
    
    //    _fendui.collection_array = self.forum_section_collection_array;
    
    _fendui.string_name=theName;
    
    _fendui.string_id=theId;
    
    [self.navigationController pushViewController:_fendui animated:YES];//跳入下一个View
    
}

#pragma mark-准备uinavigationbar

-(void)prepairNavigationBar{
    
    
    
    
    UIImageView *imgLogo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logonewz113_46.png"]];
    
    self.navigationItem.titleView=imgLogo;
    
    
    
}
//tableview
-(void)setTabView{
    
    newsScrow=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 107, 320, iPhone5?568-20-40-40-49+3+49:480-19-40-40-49+3+49)];
    newsScrow.contentSize=CGSizeMake(320*13, 0);
    newsScrow.pagingEnabled=YES;
    newsScrow.delegate=self;
    newsScrow.showsHorizontalScrollIndicator=NO;
    newsScrow.showsVerticalScrollIndicator=NO;
    newsScrow.backgroundColor=[UIColor whiteColor];
    newsScrow.scrollEnabled=NO;
    [self.view addSubview:newsScrow];
    
    //第一屏，最近浏览的
    
    
    
    //第二屏，我收藏的版块
    _mainTabV=[[UITableView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH, 0, DEVICE_WIDTH, DEVICE_HEIGHT-49-107-64)];
    _mainTabV.delegate=self;
    _mainTabV.dataSource=self;
    _mainTabV.backgroundColor=RGBCOLOR(234, 234, 234);
    [newsScrow addSubview:_mainTabV];
    [self settabviewHederView];
    
    //第三屏，soulnear的排行榜
    CGRect ranking_frame = _mainTabV.frame;
    ranking_frame.origin.x = DEVICE_WIDTH*2;
    BBSRankingView * rangkingView = [[BBSRankingView alloc] initWithFrame:ranking_frame];
    [newsScrow addSubview:rangkingView];
    __weak typeof(self)bself = self;
    [rangkingView setRangkingBlock:^(int index, id object){
        NSLog(@"index--------%d",index);
        switch (index) {
            case 0:///bbsdetail
            {
                RankingListModel * model = (RankingListModel*)object;
                bbsdetailViewController * detail = [[bbsdetailViewController alloc] init];
                detail.bbsdetail_tid = model.ranking_id;
                detail.hidesBottomBarWhenPushed = YES;
                [bself.navigationController pushViewController:detail animated:YES];
            }
                break;
            case 1:///bbsfendui
            {
                RankingListModel * model = (RankingListModel*)object;
                
                BBSfenduiViewController * fendui = [[BBSfenduiViewController alloc] init];
                fendui.string_id = model.ranking_id;
//                fendui.collection_array = bself.forum_section_collection_array;
                fendui.hidesBottomBarWhenPushed = YES;
                [bself.navigationController pushViewController:fendui animated:YES];
            }
                break;
            case 2:///login
            {
                LogInViewController * logIn = [LogInViewController sharedManager];
                [bself presentViewController:logIn animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
    }];
}
#pragma mark--上面三个按钮的切换
-(void)settabviewHederView{
    
    UIView *HeaderV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 107)];
    HeaderV.backgroundColor=RGBCOLOR(234, 234, 234);
    
    NSArray *titleArr=@[@"最近浏览",@"收藏版块",@"排行榜"];
    NSArray *unSelectimgArr=@[@"shouyeliulan.png",@"shouyeshoucang.png",@"shouyepaihang.png"];
    NSArray *selectedArr=@[@"shouyeliulan1.png",@"shouyeshoucan1g.png",@"shouyepaihang1.png"];
    
    for (int i=0; i<3; i++) {
        UIButton *ytestButton=[LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(i*DEVICE_WIDTH/3, 0, DEVICE_WIDTH/3, 203/2) normalTitle:nil image:nil backgroudImage:nil superView:HeaderV target:self action:@selector(doActionButton:)];
        
        [ytestButton setBackgroundImage:[UIImage imageNamed:unSelectimgArr[i]] forState:UIControlStateNormal];
        [ytestButton setBackgroundImage:[UIImage imageNamed:selectedArr[i]] forState:UIControlStateSelected];
        [ytestButton setBackgroundImage:[UIImage imageNamed:selectedArr[i]] forState:UIControlStateHighlighted];
        
        ytestButton.tag=100+i;
        if (i==0) {
            ytestButton.selected=YES;
            ytestButton.frame=CGRectMake(0, 0, 107, 203/2);
        }else if(i==1){
            ytestButton.selected=NO;
            ytestButton.frame=CGRectMake(107, 0, 106, 203/2);
            
        }else if(i==2)
        {
            ytestButton.selected=NO;
            ytestButton.frame=CGRectMake(107+106, 0, 107, 203/2);
        }
        UILabel *titleLabel=[LTools createLabelFrame:CGRectMake(0, 0,  DEVICE_WIDTH/3,20) title:titleArr[i] font:14 align:NSTextAlignmentCenter textColor:RGBCOLOR(132, 132, 132)];
        titleLabel.center=CGPointMake(DEVICE_WIDTH/6, 75);
        [ytestButton addSubview:titleLabel];
    }
    [self.view addSubview:HeaderV];
    
}

#pragma mark--获取网络数据

-(void)loadChangshiData{
    
    if (currentpage==1) {
        [allArr removeAllObjects];
    }
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
    if (![defaults boolForKey:USER_IN]) {
        
        LogInViewController *login = [[LogInViewController alloc] init];
        
        login.delegate = self;
        
        UITabBarController *root = (UITabBarController *)((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
        
        [root presentViewController:login animated:YES completion:^{
            
            //            int index = [[defaults objectForKey:@"lastVC"]integerValue];
            
            //            root.selectedIndex = index;
            
        }];
        
    }else
    {
        hudView=[LTools MBProgressWithText:LOADING_TITLE addToView:self.view];
        
        
        [hudView show:YES];
        
        __weak typeof(hudView)weakview=hudView;
        
        
        SzkLoadData *loadda=[[SzkLoadData alloc]init];
        
        __weak typeof(_mainTabV)weakmainTabV=_mainTabV;
        
        NSString *string_url=[NSString stringWithFormat:GET_SHOUYE_SHOUCANG_URL,AUTHKEY];
        
        [loadda SeturlStr:string_url mytest:^(NSDictionary *dicinfo, int errcode) {
            
            [weakview hide:YES afterDelay:0.4];
            
            NSArray *array=[dicinfo objectForKey:@"bbsinfo"];
            
            for (NSDictionary *dic in array) {
                NSLog(@"dic===%@==end=\n",dic);
                
                ChangshiModel *model=[[ChangshiModel alloc]initWithDictionary:dic];
                [allArr addObject:model];
            }
            
            [weakmainTabV reloadData];
            
            
        }];
    }
    
    
    
}

#pragma mark--获取最近浏览



#pragma mark--点击切换button的方法

-(void)doActionButton:(UIButton *)sender{
    UIButton *preButton=(UIButton *)[self.view viewWithTag:preTag];
    preButton.selected=NO;
    sender.selected=YES;
    preTag=sender.tag;
    
    [newsScrow setContentOffset:CGPointMake(320*(sender.tag-100), 0)];

    switch (sender.tag) {
        case 100:
        {
            NSLog(@"跳转到最近浏览");
        }
            break;
        case 101:
        {
            if (allArr.count==0) {
                [self loadChangshiData];
            }
            NSLog(@"跳转到最搜藏板块");
        }
            break;
        case 102:
        {
            NSLog(@"跳转到排行榜");
        }
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark--tableviewMethods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return allArr.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier=@"cell";
    
    ChangshiTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    if (!cell) {
        cell=[[ChangshiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    if (allArr.count>0) {
        ChangshiModel *model=[allArr objectAtIndex:indexPath.row];
        
        
        
        [cell setSubviewWithModel:model];
        
    }
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ChangshiModel *model=[allArr objectAtIndex:indexPath.row];
    
    [self setHidesBottomBarWhenPushed:YES];
    
    [self pushToFenDuiDetailWithId:model.fid WithName:model.name];
    
    
    
}


#pragma mark---scrowview的代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (scrollView==newsScrow) {
        
        
        
        
    }


}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:NO];
    [self setHidesBottomBarWhenPushed:NO];
    
    
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self setHidesBottomBarWhenPushed:NO];
    [super viewDidDisappear:animated];
}

#pragma mark - LogInDelegate
-(void)successToLogIn
{
    [self loadChangshiData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
