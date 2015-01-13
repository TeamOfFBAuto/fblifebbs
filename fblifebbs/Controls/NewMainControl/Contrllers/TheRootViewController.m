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

//广告

#import "GuanggaoViewController.h"//广告

#import "fbWebViewController.h"//
#import "RecommendView.h"


@interface TheRootViewController ()<RecommendViewDelegate>{
    
    NSArray *dataArray;
    
}

@end

@implementation TheRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //广告的逻辑
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(ssTurntoFbWebview:) name:@"TouchGuanggao" object:nil];//点击了广告
    [self turnToguanggao];
    
    
    
    
    dataArray=[NSArray array];
    currentpage=1;
    allArr=[NSMutableArray array];
    preTag=9000;
    
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark--判断新版本

/**
 *  判断版本号605673005
 */

-(void)panduanIsNewVersion{
    
    SzkLoadData *newload=[[SzkLoadData alloc]init];
    
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",@"605673005"];
    
    [newload SeturlStr:url mytest:^(NSDictionary *dicinfo, int errcode) {
        
        
        @try {
            NSArray *_newarray=[NSArray arrayWithObject:[dicinfo objectForKey:@"results"]];
            
            NSArray *firstdic=[_newarray objectAtIndex:0];
            
            NSDictionary *seconddic=[firstdic objectAtIndex:0];
            
            NSLog(@"dicnew==%@",seconddic);
            
            NSString *stringInfo=[NSString stringWithFormat:@"%@",[seconddic objectForKey:@"releaseNotes"]];
            NSString *nowline=[NSString stringWithFormat:@"%@",[seconddic objectForKey:@"version"]];
            
            NSLog(@"taidanteng==%@",nowline);
            // NSLog(@"线上版本是%@当前版本是%@",xianshangbanben,NOW_VERSION);
            
            if ([nowline isEqualToString:NOW_VERSION]) {
                
                NSLog(@"当前是最新版本");
                
            }else{
                
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"发现新版本" message:stringInfo delegate:self cancelButtonTitle:@"立即升级" otherButtonTitles:@"下次提示",nil];
                
                alert.delegate = self;
                
                alert.tag = 10000;
//                [alert show];
                
                
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        // NSLog(@"dicnew===%@",dicinfo);
        
        // NSString *xianshangbanben=[NSString stringWithFormat:@"%@",[dicinfo objectForKey:@"results"] ];
        
        
    }];
    
}


#pragma mark-跳到fb页面
-(void)ssTurntoFbWebview:(NSNotification*)sender{
    //
    fbWebViewController *fbweb=[[fbWebViewController alloc]init];
    fbweb.urlstring=[NSString stringWithFormat:@"%@",[sender.userInfo objectForKey:@"link"]];
    [fbweb viewWillAppear:YES];
    fbweb.hidesBottomBarWhenPushed = YES;
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:fbweb animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
    NSLog(@"sender.object===%@",sender.userInfo);
    
}


#pragma mark--跳转到广告

-(void)turnToguanggao{
    
    
    GuanggaoViewController *_guanggaoVC=[[GuanggaoViewController alloc]init];
    
    
    GuanggaoViewController *_sguanggaoVC=[[GuanggaoViewController alloc]init];

    __weak typeof(self)wself=self;
    
    _guanggaoVC.view.frame=self.view.frame;
    
    
    [self.view addSubview:_guanggaoVC.view];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO ];
    
    [self presentViewController:_guanggaoVC animated:NO completion:^{
        
        [wself prepairNavigationBar];
        [wself setTabView];
        [wself settabviewHederView];
        [wself loadRecentlyLookData];
        


    
    }];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && alertView.tag == 10000)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/yue-ye-yi-zu/id605673005?mt=8"]];
    }
}


#pragma mark - 读取所有最近浏览的数据

-(void)loadRecentlyLookData
{
    
    dataArray = [testbase findall];
    
    UIScrollView *   firstscro=[[UIScrollView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH, 0,DEVICE_WIDTH,DEVICE_HEIGHT-64-49-107)];
    firstscro.contentSize=CGSizeMake(0,40* dataArray.count);
    firstscro.pagingEnabled=NO;
    firstscro.showsHorizontalScrollIndicator=NO;
    firstscro.showsVerticalScrollIndicator=NO;
    firstscro.backgroundColor=[UIColor whiteColor];
    [newsScrow addSubview:firstscro];
    
    float theWidth = (DEVICE_WIDTH- 30 - 10)/2;
    for (int i=0; i<dataArray.count; i++) {
        
        UIButton *ytestButton=[LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(15+(theWidth+10)*(i%2), 18+45*(i/2),theWidth, 73/2) normalTitle:nil image:nil backgroudImage:nil superView:firstscro target:self action:@selector(dofenduibutton:)];
        
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
    _fendui.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:_fendui animated:YES];//跳入下一个View
    
}

#pragma mark-准备uinavigationbar

-(void)prepairNavigationBar{
    
    
    
    
    UIImageView *imgLogo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logonewz113_46.png"]];
    
    self.navigationItem.titleView=imgLogo;
    
    
    
}
//tableview
-(void)setTabView{
    
    newsScrow=[[UIScrollView alloc]initWithFrame:CGRectMake(0,96,DEVICE_WIDTH,DEVICE_HEIGHT-64-96-49)];
    newsScrow.contentSize=CGSizeMake(DEVICE_WIDTH*13, 0);
    newsScrow.pagingEnabled=YES;
    newsScrow.delegate=self;
    newsScrow.showsHorizontalScrollIndicator=NO;
    newsScrow.showsVerticalScrollIndicator=NO;
    newsScrow.backgroundColor=[UIColor whiteColor];
    newsScrow.scrollEnabled=NO;
    [self.view addSubview:newsScrow];
    
    
    //第一层，精选推荐
    RecommendView * recommendView = [[RecommendView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,newsScrow.height)];
    recommendView.delegate = self;
    [newsScrow addSubview:recommendView];
    
    //第二屏，最近浏览的
    
    
    
    //第三屏，我收藏的版块
    _mainTabV=[[UITableView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH*2, 0, DEVICE_WIDTH, DEVICE_HEIGHT-49-107-64+20)];
    _mainTabV.delegate=self;
    _mainTabV.dataSource=self;
    _mainTabV.separatorColor=[UIColor clearColor];
    _mainTabV.backgroundColor=RGBCOLOR(234, 234, 234);
    [newsScrow addSubview:_mainTabV];
    
    
    //第四屏，soulnear的排行榜
    CGRect ranking_frame = _mainTabV.frame;
    ranking_frame.origin.x = DEVICE_WIDTH*3;
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
    HeaderV.backgroundColor = [UIColor clearColor];
    
    UIView * background_view = [[UIView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,96)];
    background_view.backgroundColor = RGBCOLOR(234, 234, 234);
    [HeaderV addSubview:background_view];
    
    NSArray *titleArr=@[@"精选推荐",@"最近浏览",@"收藏版块",@"排行榜"];
    
    NSArray * imgArr=@[@"root_jingxuan.png",@"root_liulan.png",@"root_shoucang.png",@"root_paihang.png"];
//    NSArray * selectedArr=@[@"liulan5.png",@"shoucan5.png",@"paihang5.png"];
    
    for (int i=0; i<4; i++) {
        UIButton *ytestButton=[LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(i*DEVICE_WIDTH/4, 0, DEVICE_WIDTH/4, 203/2) normalTitle:nil image:nil backgroudImage:nil superView:HeaderV target:self action:@selector(doActionButton:)];
        
//        [ytestButton setBackgroundImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        [ytestButton setBackgroundImage:[UIImage imageNamed:@"root_selected_image.png"] forState:UIControlStateSelected|UIControlStateSelected];
        [ytestButton setBackgroundImage:[UIImage imageNamed:@"root_unselected_image.png"] forState:UIControlStateNormal];
        
        ytestButton.tag=9000+i;
        if (i==0) {
            ytestButton.selected=YES;
            ytestButton.frame=CGRectMake(0, 0,DEVICE_WIDTH/4, 203/2);
        }else if(i==1){
            ytestButton.selected=NO;
            ytestButton.frame=CGRectMake(DEVICE_WIDTH/4, 0,DEVICE_WIDTH/4, 203/2);
            
        }else if(i==2)
        {
            ytestButton.selected=NO;
            ytestButton.frame=CGRectMake(DEVICE_WIDTH/4*2, 0,DEVICE_WIDTH/4, 203/2);
        }else if(i==3)
        {
            ytestButton.selected=NO;
            ytestButton.frame=CGRectMake(DEVICE_WIDTH/4*3, 0,DEVICE_WIDTH/4, 203/2);
        }
        
        UILabel *titleLabel=[LTools createLabelFrame:CGRectMake(0, 0,  DEVICE_WIDTH/4,20) title:titleArr[i] font:14 align:NSTextAlignmentCenter textColor:RGBCOLOR(132, 132, 132)];
        titleLabel.center=CGPointMake(ytestButton.frame.size.width/2, 75);
        [ytestButton addSubview:titleLabel];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,50,50)];
        imageView.image = [UIImage imageNamed:imgArr[i]];
        imageView.center = CGPointMake(ytestButton.frame.size.width/2,36.5);
        [ytestButton addSubview:imageView];
    }
    [self.view addSubview:HeaderV];
    
}

#pragma mark--获取网络数据

-(void)loadChangshiData{
    
    //        [allArr removeAllObjects];
    //        [_mainTabV reloadData];
    //    allArr=[NSMutableArray array];
    
    
    
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
        
        
        //  [hudView show:YES];
        
        //        __weak typeof(hudView)weakview=hudView;
        
        
        SzkLoadData *loadda=[[SzkLoadData alloc]init];
        
        __weak typeof(_mainTabV)weakmainTabV=_mainTabV;
        
        __weak typeof(allArr)weakallarr=allArr;
        
        NSString *string_url=[NSString stringWithFormat:GET_SHOUYE_SHOUCANG_URL,AUTHKEY];
        
        [loadda SeturlStr:string_url mytest:^(NSDictionary *dicinfo, int errcode) {
            
            
            NSArray *array=[dicinfo objectForKey:@"bbsinfo"];
            
            if (array.count>0) {
                [weakallarr removeAllObjects];
                [weakmainTabV reloadData];
            }
            
            for (NSDictionary *dic in array) {
                
                ChangshiModel *model=[[ChangshiModel alloc]initWithDictionary:dic];
                [weakallarr addObject:model];
            }
            
            [weakmainTabV reloadData];
            
            
        }];
    }
    
    
    
}

#pragma mark--获取最近浏览



#pragma mark--点击切换button的方法

-(void)doActionButton:(UIButton *)sender{
    
    NSLog(@"sendertag===%d=====pretag===%d",sender.tag,preTag);
    
    UIButton *preButton=(UIButton *)[self.view viewWithTag:preTag];
    preButton.selected=NO;
    sender.selected=YES;
    preTag=sender.tag;
    
    [newsScrow setContentOffset:CGPointMake(DEVICE_WIDTH*(sender.tag-9000), 0)];
    NSLog(@"xxxxxxxxxx -------   %f",DEVICE_WIDTH*(sender.tag-9000));
    switch (sender.tag) {
        case 9000:
        {
            NSLog(@"精选推荐");
        }
            break;
        case 9001:
        {
            NSLog(@"跳转到最近浏览");
        }
            break;
        case 9002:
        {
            if (allArr.count==0) {
                [self loadChangshiData];
            }
            NSLog(@"跳转到最搜藏板块");
        }
            break;
        case 9003:
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

#pragma mark--删除

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        //网络上得取消
        
        SzkLoadData *loaddata=[[SzkLoadData alloc]init];
        
        
        __weak typeof(allArr)weakAllArr=allArr;
        
        // __weak typeof(self) weself=self;
        ChangshiModel *model=[allArr objectAtIndex:indexPath.row];
        
        [loaddata SeturlStr:[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/delfavorites.php?delid=%@&formattype=json&authcode=%@",model.fid,[personal getMyAuthkey]] mytest:^(NSDictionary *dicinfo, int errcode) {
            
            NSLog(@"取消该收藏的dic==%@",dicinfo);
            
            
            if ([[dicinfo objectForKey:@"errcode"] intValue]==0) {
                [weakAllArr removeObjectAtIndex:[indexPath row]];  //删除数组里的数据
                
                
                [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
                
                
            }
            
            
        }];
        
        
        
    }
}



#pragma mark---scrowview的代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView==newsScrow) {
        
        
        
        
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:NO];
    [self setHidesBottomBarWhenPushed:NO];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
//    UIButton *preButton=(UIButton *)[self.view viewWithTag:9002];
//
//    
//    if (![defaults boolForKey:USER_IN]) {
//    
//        [self doActionButton:preButton];
//    
//        return;
//    
//    
//    }
 
    
    
    [self loadChangshiData];
    
    [self loadRecentlyLookData];
    
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
