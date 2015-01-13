//
//  BBSfenduiViewController.m
//  FbLifes
//
//  Created by 史忠坤 on 13-3-12.
//  Copyright (c) 2013年 szk. All rights reserved.

#import "BBSfenduiViewController.h"
#import "JSONKit.h"
//#import "detailbbsview.h"
#import "bbsdetailViewController.h"
#import "testbase.h"
#import "collectdatabase.h"
#import "commrntbbdViewController.h"
#import "LogInViewController.h"
#import "fbWebViewController.h"


#define LINESPACEINGS 4

//101更新   102加载   202收藏  203查看收藏
@interface BBSfenduiViewController (){
    UIButton *button_collect;
    UIImageView *xialaView;
    AlertRePlaceView *_replaceAlertView;
    
    UIButton *button_more;
    
    downloadtool *Collect_Tool;
    
    downloadtool *Collect_Tool11;
}
@end
@implementation BBSfenduiViewController
@synthesize string_id,string_name,array_info=_array_info,collection_array;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    // self.navigationController.navigationBarHidden=NO;
    // [self PromptingisLoading];
    if (self.string_name.length==0) {
        self.string_name=[NSString stringWithFormat:@" "];
    }
    NSLog(@"name===%@",self.string_name);
    // [tab_ reloadData];
    self.navigationController.navigationBarHidden=NO;
    
    [MobClick beginEvent:@"BBSfenduiViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _isloadingIv.hidden=YES;
    
    [MobClick endEvent:@"BBSfenduiViewController"];
    
    
    if (!isHidden)
    {
        [self showPopoverView:nil];
    }
}

- (void)dealloc
{
//    downloadtool *Collect_Tool;
//    
//    downloadtool *Collect_Tool11;
    
    Collect_Tool.delegate=nil;
    [Collect_Tool stop];
    
    Collect_Tool11.delegate=nil;
    
    [Collect_Tool11 stop];
    
    tool_101.delegate=nil;
    
    [tool_101 stop];
    
    [xialaView removeFromSuperview];
    xialaView = nil;
    
    NSLog(@"--dealloc-- %@",NSStringFromClass([self class]));
}

-(void)leftButtonTap:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    if (MY_MACRO_NAME) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _isloadingIv=[[loadingimview alloc]initWithFrame:CGRectMake(100, 200, 150, 100) labelString:@"正在加载"];
    [[UIApplication sharedApplication].keyWindow
     addSubview:_isloadingIv];
    
    
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(sendrequest) name:@"refreshmydata" object:nil];
    //
    isadvertisingImghiden=YES;
    numberofareaid=0;
    numberoftypeid=0;
    NSLog(@"%s",__FUNCTION__);
    UIView *aview=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view=aview;
    _array_info=[[NSMutableArray alloc]init];
    
    array_salestate=[[NSArray alloc]initWithObjects:@"全部",@"出售",@"求购", nil];
    array_location=[[NSArray alloc]initWithObjects:@"全国",@"安徽", @"北京", @"重庆", @"福建", @"甘肃", @"广东", @"广西", @"贵州", @"海南", @"河北", @"河南", @"黑龙江", @"湖北", @"湖南", @"吉林", @"江苏", @"江西", @"辽宁", @"内蒙古", @"宁夏", @"青海", @"山东", @"山西", @"陕西", @"上海", @"四川", @"天津", @"西藏", @"新疆", @"云南", @"浙江", nil];
    
    currentpage=1;
    isLoadsuccess=NO;
    
    // UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:button_back];
    //  self.navigationItem.leftBarButtonItem=back_item;
    
    
 
    
    
    [self setSNViewControllerLeftButtonType:SNViewControllerLeftbuttonTypeBack WithRightButtonType:SNViewControllerRightbuttonTypeNull];
    
    button_collect=[[UIButton alloc]initWithFrame:CGRectMake(MY_MACRO_NAME?15:10, (44-21)/2, 22, 21)];
    button_collect.tag=999;
    [button_collect addTarget:self action:@selector(collect) forControlEvents:UIControlEventTouchUpInside];
    [button_collect setBackgroundImage:[UIImage imageNamed:@"ios7_collect44_42.png"] forState:UIControlStateNormal];
    
    
    UIButton *viewcollect=[[UIButton alloc]initWithFrame:CGRectMake(20, 0,50, 44)];
    
    [viewcollect addTarget:self action:@selector(collect) forControlEvents:UIControlEventTouchUpInside];
    viewcollect.backgroundColor=[UIColor clearColor];
    [viewcollect addSubview:button_collect];
    
    
    
    //UIBarButtonItem *buttonitem_collect=[[UIBarButtonItem alloc]initWithCustomView:button_collect];
    // self.navigationItem.rightBarButtonItem=buttonitem_collect;
    
    UIButton *button_send=[[UIButton alloc]initWithFrame:CGRectMake(MY_MACRO_NAME?5:2, 0,40, 44)];
    
    [button_send addTarget:self action:@selector(fatieyemian) forControlEvents:UIControlEventTouchUpInside];
    //    [button_send setBackgroundImage:[UIImage imageNamed:@"ios7_commit3839.png"] forState:UIControlStateNormal];
    
    [button_send setImage:[UIImage imageNamed:WRITE_DEFAULT_IMAGE] forState:UIControlStateNormal];
    
    UIButton *viewsend=[[UIButton alloc]initWithFrame:CGRectMake(65, 0, 50, 44)];
    
    viewsend.backgroundColor=[UIColor clearColor];
    
    [viewsend addTarget:self action:@selector(fatieyemian) forControlEvents:UIControlEventTouchUpInside];
    //   viewsend.backgroundColor=[UIColor redColor];
    [viewsend addSubview:button_send];
    
    //UIBarButtonItem *buttonitem_send=[[UIBarButtonItem alloc]initWithCustomView:button_send];
    
    
    UIView *view_right=[[UIView alloc]initWithFrame:CGRectMake(130, 0,110, 44)];
    
    view_right.backgroundColor = [UIColor clearColor];
    [view_right addSubview:viewcollect];
    [view_right addSubview:viewsend];
    
    
    array_chose=[NSArray arrayWithObjects:@"最后回复",@"最新发帖", @"精华帖",nil];
    isHidden=YES;
    selecttionofxialaview=1;
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(97,0,100,44)];
    topView.backgroundColor = [UIColor clearColor];
    //跳蚤之家有出售状态
    
    
    //导航栏上的label
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    _titleLabel.text = @"最后回复";
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:20];
    _titleLabel.textColor = [UIColor blackColor];
    [topView addSubview:_titleLabel];
    //导航栏上的小箭头
    UIImageView * tipView = [[UIImageView alloc] initWithImage:[personal getImageWithName:@"arrow"]];
    tipView.center = CGPointMake(100,22);
    tipView.tag = 102;
    tipView.highlightedImage = [personal getImageWithName:@""];
    [topView addSubview:tipView];
    self.navigationItem.titleView = topView;
    
    //覆盖在label
    UIButton * topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    topButton.frame = topView.bounds;
    topButton.backgroundColor = [UIColor clearColor];
    [topButton addTarget:self action:@selector(showPopoverView:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [topView addSubview:topButton];
    
    //    UIBarButtonItem * spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    spaceButton.width = MY_MACRO_NAME?-5:5;
    
    //self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:buttonitem_collect,buttonitem_send, nil];
    UIBarButtonItem * right_spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    right_spaceButton.width = MY_MACRO_NAME?-15:5;
    self.navigationItem.rightBarButtonItems=@[right_spaceButton,[[UIBarButtonItem alloc]initWithCustomView:view_right]];
    
//    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
//        //iOS 5 new UINavigationBar custom background
//        
//        [self.navigationController.navigationBar setBackgroundImage:MY_MACRO_NAME?[UIImage imageNamed:IOS7DAOHANGLANBEIJING]:[UIImage imageNamed:@"ios7eva320_44.png"] forBarMetrics: UIBarMetricsDefault];
//    }
    
    
    
    
    //    UIImageView * imageView = [[UIImageView alloc] initWithImage:[personal getImageWithName:@"jiantou"]];
    //    imageView.center = CGPointMake(50,22);
    //    imageView.hidden = isHidden;
    //    imageView.tag = 100;
    //    [self.navigationItem.titleView addSubview:imageView];
    
    
    UIImage * image =[personal getImageWithName:@"xiala_new_fendui@2x"];
    xialaView = [[UIImageView alloc] initWithImage:image];
    xialaView.userInteractionEnabled = YES;
    
    
#pragma mark-----这里还要考虑打电话的情况
    
    xialaView.center = CGPointMake(DEVICE_WIDTH/2,MY_MACRO_NAME? image.size.height/2+54:image.size.height/2+34);
    
    
    
    xialaView.tag = 111;
    xialaView.alpha = 0;
    
    
    
    for (int i = 0;i < array_chose.count;i++)
    {
        UIImageView * imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0,10+(260/6)*i,195,260/6)];
        imageView1.userInteractionEnabled = YES;
        imageView1.tag = 1+i;
        imageView1.backgroundColor = [UIColor clearColor];
        
        
        
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,195,260/6)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [array_chose objectAtIndex:i];
        label.tag = 888888888;
        
        
        if (i==0)
        {
            imageView1.image = [personal getImageWithName:@"bg_sel"];
            label.textColor = [UIColor blackColor];
        }
        
        label.font=[UIFont systemFontOfSize:20];
        
        [xialaView addSubview:imageView1];
        
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
        [imageView1 addGestureRecognizer:tap];
        
        [imageView1 addSubview:label];
    }
    
    
    
    //下拉刷新view
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - tab_.bounds.size.height, self.view.frame.size.width, tab_.bounds.size.height)];
		view.delegate = self;
        // view.backgroundColor=[UIColor redColor];
		//[tab_pinglunliebiao addSubview:view];
		_refreshHeaderView = view;
	}
    //上拉加载view
    loadview=[[LoadingIndicatorView alloc]initWithFrame:CGRectMake(0, 900, DEVICE_WIDTH, 40)];
    loadview.backgroundColor=[UIColor clearColor];
    
	[_refreshHeaderView refreshLastUpdatedDate];
    
    
    //568-20-40-40
    
    tab_=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 20 - 40 - 40 +37)];
    tab_.delegate=self;
    //    tab_.separatorColor=[UIColor clearColor];
    // tab_.backgroundColor=[UIColor redColor];
    tab_.dataSource=self;
    [self.view addSubview:tab_];
    
    ShortView=[[UIView alloc]initWithFrame:CGRectMake(130, 150, 70, 30)];
    [self.view addSubview:ShortView];
    ShortView.userInteractionEnabled=NO;
    
    //hud为收藏成功的提示框
    if (!hud)
    {
        hud = [[ATMHud alloc] initWithDelegate:self];
        [self.navigationController.view addSubview:hud.view];
    }
    
    tab_.tableHeaderView = _refreshHeaderView;
    [self.navigationController.view addSubview:xialaView];
//    [[UIApplication sharedApplication].keyWindow addSubview:xialaView];
    _replaceAlertView=[[AlertRePlaceView alloc]initWithFrame:CGRectMake(100, 200, 150, 100) labelString:@"您的网络不给力哦，请检查网络"];
    _replaceAlertView.delegate=self;
    _replaceAlertView.hidden=YES;
    [[UIApplication sharedApplication].keyWindow
     addSubview:_replaceAlertView];
    
    //显示广告
    
    if (!advImgV) {
        advImgV=[[AdvertisingimageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 50) ];
        
    }
    advImgV.delegate=self;
    
//    [self testguanggao];
    [self sendrequest];
    
    
    
}

#pragma mark-下拉的view
-(void)showPopoverView:(UIButton *)button
{
    isHidden = !isHidden;
    
    UIImageView * xiala = (UIImageView *)[self.navigationController.view viewWithTag:111];
    
    UIImageView * tipView = (UIImageView *)[self.navigationItem.titleView viewWithTag:102];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        tipView.image = [personal getImageWithName:isHidden?@"arrow":@"arrow_up"];
        
        xiala.alpha = isHidden?0:1;
        
    }completion:^(BOOL finished)
     {
         
     }];
}

-(void)doTap:(UITapGestureRecognizer *)sender
{
    [self showPopoverView:nil];
    
    UIImageView * xiala = (UIImageView *)[self.navigationController.view viewWithTag:111];
    
    
    _titleLabel.text = [array_chose objectAtIndex:sender.view.tag - 1];
    
    UIImageView * imageView = (UIImageView *)sender.view;
    UILabel * label = (UILabel *)[imageView viewWithTag:888888888];
    label.textColor = [UIColor blackColor];
    
    UIImageView * imageView111111 = (UIImageView *)[xiala viewWithTag:selecttionofxialaview];
    UILabel * label1 = (UILabel *)[imageView111111 viewWithTag:888888888];
    label1.textColor = [UIColor blackColor];
    
    
    
    
    
    if (imageView.tag==1)
    {
        imageView.image=[personal getImageWithName:@"bg_sel"];
        UIImageView * imageView1 = (UIImageView *)[xiala viewWithTag:2];
        imageView1.image=nil;
        UIImageView * imageView2 = (UIImageView *)[xiala viewWithTag:3];
        imageView2.image=nil;
        selecttionofxialaview=1;
        
        
    }
    else if (imageView.tag==2){
        imageView.image=[personal getImageWithName:@"bg_sel"];
        UIImageView * imageView1 = (UIImageView *)[xiala viewWithTag:1];
        imageView1.image=nil;
        UIImageView * imageView2 = (UIImageView *)[xiala viewWithTag:3];
        imageView2.image=nil;
        selecttionofxialaview=2;
    }
    else  if (imageView.tag==3){
        
        
        
        imageView.image=[personal getImageWithName:@"bg_sel"];
        UIImageView * imageView1 = (UIImageView *)[xiala viewWithTag:2];
        imageView1.image=nil;
        UIImageView * imageView2 = (UIImageView *)[xiala viewWithTag:1];
        imageView2.image=nil;
        selecttionofxialaview=3;
        
        
        
        
    }
    [self sendrequest];
    
}
#pragma mark-出售状态的实现
-(void)salestate{
    NSLog(@"zounihaha");
    _salestate=[[SelectsalestateView alloc]initWithFrame:CGRectMake(0,iPhone5? 260+40:171+40, 320, 200+20) receiveSalestateArray:array_salestate locationarray:array_location];
    _salestate.delegate=self;
    [_salestate ShowPick];
    [self.view addSubview:_salestate];
}
-(void)salenumber:(int)numbersale locationnumber:(int)numberlocation{
    NSLog(@"点击了%d\n%d",numbersale,numberlocation);
    
    currentpage=1;
    numberoftypeid = numbersale;
    numberofareaid = numberlocation;
    switch (numbersale) {
        case 0:
            
            [tool_101 setUrl_string:[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumthread.php?fid=%@&page=%d&orderby=2&areaid=%d&typeid=0&formattype=json&authcode=%@",self.string_id,currentpage,numberlocation,[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]]];
            
            NSLog(@"xxxx===%@",[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumthread.php?fid=%@&page=%d&orderby=2&areaid=%d&typeid=0&formattype=json&authcode=%@",self.string_id,currentpage,numberlocation,[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]]);
            
            
            break;
        case 1:
            
            
            [tool_101 setUrl_string:[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumthread.php?fid=%@&page=%d&orderby=2&areaid=%d&typeid=%d&formattype=json&authcode=%@",self.string_id,currentpage,numberlocation,saleID,[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]]];
            
            NSLog(@"xxxx1===%@",[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumthread.php?fid=%@&page=%d&orderby=2&areaid=%d&typeid=%d&formattype=json&authcode=%@",self.string_id,currentpage,numberlocation,saleID,[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]]);
            
            
            break;
        case 2:
            
            
            [tool_101 setUrl_string:[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumthread.php?fid=%@&page=%d&orderby=2&areaid=%d&typeid=%d&formattype=json&authcode=%@",self.string_id,currentpage,numberlocation,buyID,[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]]];
            NSLog(@"xxxx2===%@",[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumthread.php?fid=%@&page=%d&orderby=2&areaid=%d&typeid=%d&formattype=json&authcode=%@",self.string_id,currentpage,numberlocation,buyID,[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]]);
            
            
            break;
            
            
        default:
            break;
    }
    
    if (tool_101==nil) {
        tool_101=[[downloadtool alloc]init];
    }
    
    
    tool_101.tag=101;
    tool_101.delegate=self;
    [tool_101 start];
    
    
}

-(void)moresalenumber:(int)numbersale locationnumber:(int)numberlocation{
    [self showloadingview];
    if (isLoadsuccess==YES) {
        isLoadsuccess=NO;
        
        if (tool_101==nil) {
            tool_101=[[downloadtool alloc]init];
        }
        
        currentpage++;
        switch (numbersale) {
            case 0:
                [tool_101 setUrl_string:[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumthread.php?fid=%@&page=%d&orderby=2&areaid=%d&typeid=0&formattype=json&authcode=%@",self.string_id,currentpage,numberlocation,[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]]];
                break;
            case 1:
                [tool_101 setUrl_string:[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumthread.php?fid=%@&page=%d&orderby=2&areaid=%d&typeid=%d&formattype=json&authcode=%@",self.string_id,currentpage,numberlocation,saleID,[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]]];
                break;
            case 2:
                [tool_101 setUrl_string:[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumthread.php?fid=%@&page=%d&orderby=2&areaid=%d&typeid=%d&formattype=json&authcode=%@",self.string_id,currentpage,numberlocation,buyID,[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]]];
                break;
            default:
                break;
        }
        
        tool_101.tag=102;
        tool_101.delegate=self;
        [tool_101 start];
        NSString *UrlString=[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumthread.php?fid=%@&page=%d&orderby=1&formattype=json",self.string_id,currentpage];
        NSLog(@"请求的url为%@",UrlString);
    }
}
//收藏的实现
-(void)collect{
    //    NSMutableArray * array = [[NSMutableArray alloc] init];
    //    NSMutableArray *array_=[collectdatabase findall];
    //    if ([array_ count]==0) {
    //        if (self.string_name.length>0) {
    //            int mm=   [collectdatabase addbbsname:self.string_name id:[NSString stringWithFormat:@"%@", self.string_id ] ];
    //            NSLog(@"第一次mm=%d",mm);
    //            [self Tishibaocunchenggong];
    //        }
    //    }else{
    //        for (collectdatabase *base in array_) {
    //            [array addObject:base.id_ofbbs];
    //        }
    //
    //        if (![array containsObject:[  NSString stringWithFormat:@"%@", self.string_id ]])
    //        {
    //            if ([array_ count]>5)
    //            {
    //                collectdatabase *delebase=[array_ objectAtIndex:0];
    //                NSString *string_bbsid=[NSString stringWithFormat:@"%@",delebase.id_ofbbs];
    //                int dele=   [collectdatabase deleteStudentByID:string_bbsid];
    //                NSLog(@"sreingid==%@,dele==%d",string_bbsid,dele);
    //            }
    //
    //            if (self.string_name.length>0) {
    //                int hah=   [collectdatabase addbbsname:self.string_name id:[NSString stringWithFormat:@"%@", [  NSString stringWithFormat:@"%@", self.string_id ]]];
    //                NSLog(@"haha=%d",hah);
    //                [self Tishibaocunchenggong];
    //            }
    //        }
    //        else{
    //
    //            [self Tishiyijingshoucang];
    //        }
    //
    //    }
    //
    
    
    
    if (!isHidden)
    {
        [self showPopoverView:nil];
    }
    
    
    //在线收藏
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_IN])
    {  NSLog(@"string_fid=%@",str_fid);
        NSString *url=[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/favoritesforums.php?fid=%@&action=add&formattype=json&authcode=%@",str_fid,[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]];
        NSLog(@"url====%@",url);
        Collect_Tool=[[downloadtool alloc]init];
        [Collect_Tool setUrl_string:[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/favoritesforums.php?fid=%@&action=add&formattype=json&authcode=%@",str_fid,[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]]];
        Collect_Tool.tag=202;
        Collect_Tool.delegate=self;
        [Collect_Tool start];
        
        //已经激活过FB 加载个人信息
    }
    else{
        //没有激活fb，弹出激活提示
        
        LogInViewController *login=[LogInViewController sharedManager];
        [self presentViewController:login animated:YES completion:nil];
    }
    
    
    
}

-(void)Deletebankuai{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_IN])
    {  NSLog(@"string_fid=%@",str_fid);
        NSString *url=[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/favoritesforums.php?fid=%@&action=add&formattype=json&authcode=%@",str_fid,[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]];
        NSLog(@"url====%@",url);
        Collect_Tool11=[[downloadtool alloc]init];
        [Collect_Tool11 setUrl_string:[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/delfavorites.php?delid=%@&formattype=json&authcode=%@",str_fid,[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]]];
        Collect_Tool11.tag=203;
        Collect_Tool11.delegate=self;
        [Collect_Tool11 start];
        
        //已经激活过FB 加载个人信息
    }
    else{
        //没有激活fb，弹出激活提示
        
        LogInViewController *login=[LogInViewController sharedManager];
        [self presentViewController:login animated:YES completion:nil];
    }
    
}
-(void)Tishiyijingshoucang{
    [hud setBlockTouches:NO];
    [hud setAccessoryPosition:ATMHudAccessoryPositionLeft];
    [hud setShowSound:[[NSBundle mainBundle] pathForResource:@"pop0" ofType:@"wav"]];
    [hud setCaption:@"删除成功"];
    [hud setActivity:NO];
    //[hud setImage:[UIImage imageNamed:@"19-check"]];
    [hud show];
    [hud hideAfter:1.5];
    
}
-(void)Tishibaocunchenggong{
    [hud setBlockTouches:NO];
    [hud setAccessoryPosition:ATMHudAccessoryPositionLeft];
    [hud setShowSound:[[NSBundle mainBundle] pathForResource:@"pop" ofType:@"wav"]];
    [hud setCaption:@"收藏成功"];
    [hud setActivity:NO];
    //    [hud setImage:[UIImage imageNamed:@"19-check"]];
    [hud show];
    [hud hideAfter:1.5];
}
-(void)PromptingisLoading{
    
    
    [hud setBlockTouches:NO];
    [hud setAccessoryPosition:ATMHudAccessoryPositionLeft];
    //[hud setShowSound:[[NSBundle mainBundle] pathForResource:@"pop" ofType:@"wav"]];
    [hud setCaption:@"正在加载"];
    [hud setActivity:YES];
    //    [hud setImage:[UIImage imageNamed:@"19-check"]];
    [hud show];
    
    
}
#pragma mark-请求数据
-(void)showloadingview{
    
    
    
    _isloadingIv.hidden=NO;
    
}

-(void)sendrequest{
    
    
    
    [self showloadingview];
    
    
  //  NSLog(@"zouni....");
    currentpage=1;
    // [_array_info removeAllObjects];
    if (tool_101==nil) {
        tool_101=[[downloadtool alloc]init];
        
    }
    switch (selecttionofxialaview) {
        case 1:
            
            //最后回复
            [tool_101 setUrl_string:[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumthread.php?fid=%@&page=%d&orderby=2&formattype=json&authcode=%@",self.string_id,currentpage,[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]]];
            
            NSLog(@"最后回复的接口为====%@",[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumthread.php?fid=%@&page=%d&orderby=2&formattype=json&authcode=%@",self.string_id,currentpage,[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]]);
            
            
            
            
            
            break;
        case 2:
            
            
            NSLog(@"最新发帖的接口===%@",[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumthread.php?fid=%@&page=%d&orderby=1&formattype=json&authcode=%@",self.string_id,currentpage,[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]]);
            
            //最新发帖
            
            
            
            [tool_101 setUrl_string:[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumthread.php?fid=%@&page=%d&orderby=1&formattype=json&authcode=%@",self.string_id,currentpage,[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]]];
            break;
        case 3:
            
            
            NSLog(@"精华帖的接口==%@",[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumdigest.php?fid=%@&page=%d&formattype=json&authcode=%@",self.string_id,currentpage,[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]]);
            //精华帖
            
           
            
            [tool_101 setUrl_string:[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumdigest.php?fid=%@&page=%d&formattype=json&authcode=%@",self.string_id,currentpage,[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]]];
            
            
            
            
            break;
            
            
        default:
            break;
    }
    
    
    tool_101.tag=101;
    tool_101.delegate=self;
    [tool_101 start];
    
    // NSLog(@"url[[[[====%@",[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumdigest.php?fid=%@&page=%d&formattype=json&authcode=%@",self.string_id,currentpage,[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]]);
    
    
}
-(void)sendmore{
    [self showloadingview];
    if (isLoadsuccess==YES) {
        isLoadsuccess=NO;
        
        if (tool_101==nil) {
            tool_101=[[downloadtool alloc]init];
        }
        
        currentpage++;
        switch (selecttionofxialaview) {
            case 1:
                [tool_101 setUrl_string:[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumthread.php?fid=%@&page=%d&orderby=2&formattype=json",self.string_id,currentpage]];
                break;
            case 2:
                [tool_101 setUrl_string:[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumthread.php?fid=%@&page=%d&orderby=1&formattype=json&",self.string_id,currentpage]];
                break;
            case 3:
                [tool_101 setUrl_string:[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumdigest.php?fid=%@&page=%d&formattype=json",self.string_id,currentpage]];
                
                break;
                
            default:
                break;
        }
        
        
        tool_101.tag=102;
        tool_101.delegate=self;
        [tool_101 start];
        NSString *UrlString=[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumthread.php?fid=%@&page=%d&orderby=1&formattype=json",self.string_id,currentpage];
        NSLog(@"请求的url为%@",UrlString);
    }
}

-(void)downloadtool:(downloadtool *)tool didfinishdownloadwithdata:(NSData *)data
{
    
    
    
    @try {
        _isloadingIv.hidden=YES;
        
        NSDictionary *dic=[data objectFromJSONData];
        if (tool==tool_guanggao) {
            NSLog(@"再不行就晕了");
            NSDictionary *dic;
            NSArray *array=[data objectFromJSONData];
            if (array.count>0) {
                dic=[array objectAtIndex:0];
                
                
                str_guanggaourl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"imgsrc"]];
                str_guanggaolink=[NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]];
                NSLog(@"str_guanggaourl==%@",str_guanggaourl);
                [advImgV setString_urlimg:str_guanggaourl];
            }
        }
        
        
        
        if (dic!=NULL) {
            switch (tool.tag) {
                case 101://更新
                {
                    NSLog(@"加载的dic==%@",dic);
                    tab_.tableFooterView=loadview;
                    
                    if ([[dic objectForKey:@"errcode"] integerValue]==0) {
                        str_fid=[NSString stringWithFormat:@"%@",[[[dic objectForKey:@"bbsinfo"] objectForKey:@"foruminfo"] objectForKey:@"fid"]];
                        
                        self.string_name=[NSString stringWithFormat:@"%@",[[[dic objectForKey:@"bbsinfo"] objectForKey:@"foruminfo"] objectForKey:@"name"]];
                        if (self.string_name.length==0) {
                            self.string_name=[NSString stringWithFormat:@" "];
                        }
                        
                        
                        NSString *string_havefavorite=[NSString stringWithFormat:@"%@",[[[dic objectForKey:@"bbsinfo"] objectForKey:@"foruminfo"] objectForKey:@"havefavorite"]];
                        
                        saleID=[[[[dic objectForKey:@"bbsinfo"] objectForKey:@"foruminfo"] objectForKey:@"sale"]integerValue];
                        buyID=[[[[dic objectForKey:@"bbsinfo"] objectForKey:@"foruminfo"] objectForKey:@"buy"]integerValue];
                        
                        if ([string_havefavorite isEqualToString:@"yes"]) {
                            [button_collect setBackgroundImage:[UIImage imageNamed:@"ios7_collectselect.png"] forState:UIControlStateNormal];
                            
                        }else{
                            
                            [button_collect setBackgroundImage:[UIImage imageNamed:@"ios7_collect44_42.png"] forState:UIControlStateNormal];
                        }
                        
                        
                        NSMutableArray * array = [[NSMutableArray alloc] init];
                        
                        NSMutableArray *array_=[testbase findall];
                        if ([array_ count]==0) {
                            int mm=   [testbase addbbsname:self.string_name id:[NSString stringWithFormat:@"%@", self.string_id ] ];
                            NSLog(@"第一次mm=%d",mm);
                            
                        }else{
                            for (testbase *base in array_) {
                                [array addObject:base.id_ofbbs];
                            }
                            
                            if (![array containsObject:[  NSString stringWithFormat:@"%@", self.string_id ]])
                            {
                                if ([array_ count]>10) {
                                    testbase *delebase=[array_ objectAtIndex:0];
                                    NSString *string_bbsid=[NSString stringWithFormat:@"%@",delebase.id_ofbbs];
                                    int dele=   [testbase deleteStudentByID:string_bbsid];
                                    NSLog(@"sreingid==%@,dele==%d",string_bbsid,dele);
                                }
                                int mm=   [testbase addbbsname:self.string_name id:[NSString stringWithFormat:@"%@", [  NSString stringWithFormat:@"%@", self.string_id ]]];
                                NSLog(@"mm=%d",mm);
                            }
                            
                        }
                        
                        if ([[[dic objectForKey:@"bbsinfo"]objectForKey:@"forumthread"]count]!=0)
                        {
                            [_array_info removeAllObjects];
                            
                            NSArray *array_danci=[[NSArray alloc]init];
                            array_danci=[[[dic objectForKey:@"bbsinfo"]objectForKey:@"forumthread"] objectForKey:@"item"];
                            for (int i=0; i<array_danci.count; i++) {
                                NSDictionary *dicinfo=[array_danci objectAtIndex:i];
                                [_array_info addObject:dicinfo];
                                
                            }
                            
                            NSLog(@"%s_array_info==%@",__FUNCTION__,_array_info);
                            isLoadsuccess=YES;
                            
                        }
                        
                        [hud hideAfter:0.1];
                        [tab_ reloadData];
                    }else{
                        
                        
                        
                        NSString *string_errcode=[NSString stringWithFormat:@"%@",[dic objectForKey:@"bbsinfo"]];
                        //                    UIAlertView *alert_=[[UIAlertView alloc]initWithTitle:@"提示" message:string_errcode delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                        //                    [alert_ show];
                        
                        
                        _replaceAlertView=[[AlertRePlaceView alloc]initWithFrame:CGRectMake(100, 200, 150, 100) labelString:string_errcode];
                        _replaceAlertView.delegate=self;
                        _replaceAlertView.hidden=NO;
                        [_replaceAlertView hide];
                        [[UIApplication sharedApplication].keyWindow
                         addSubview:_replaceAlertView];
                        
                        
                    }
                    
                    
                }
                    break;
                case 102://加载
                {
                    NSLog(@"加载的dic==%@",dic);
                    
                    if ([[dic objectForKey:@"errcode"] integerValue]==0&&[[[dic objectForKey:@"bbsinfo"]objectForKey:@"forumthread"]count]!=0) {
                        NSLog(@"走了这个方法");
                        isLoadsuccess=YES;
                        
                        NSArray *array_danci=[[NSArray alloc]init];
                        array_danci=[[[dic objectForKey:@"bbsinfo"]objectForKey:@"forumthread"] objectForKey:@"item"];
                        for (int i=0; i<array_danci.count; i++) {
                            NSDictionary *dicinfo=[array_danci objectAtIndex:i];
                            [_array_info addObject:dicinfo];
                            
                        }
                        [loadview stopLoading:1];
                        [tab_ reloadData];
                        
                        
                    }else{
                        //                    NSString *string_errcode=[NSString stringWithFormat:@"%@",[dic objectForKey:@"bbsinfo"]];
                        //                    UIAlertView *alert_=[[UIAlertView alloc]initWithTitle:@"提示" message:string_errcode delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                        //                    [alert_ show];
                    }
                    
                }
                    break;
                case 202://收藏
                {
                    
                    NSString * tishi=[NSString stringWithFormat:@"%@",[dic objectForKey:@"errcode"]] ;
                    
                    if ([tishi integerValue]==11) {
                        
                        [self Deletebankuai];
                    }else if([tishi integerValue] == 0){
                        
                        [button_collect setBackgroundImage:[UIImage imageNamed:@"ios7_collectselect.png"] forState:UIControlStateNormal];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"forumSectionChange" object:nil];
                        [self.collection_array addObject:self.string_id];
                        
                        [self Tishibaocunchenggong];
                        
                    }else
                    {
                        if ([self.collection_array containsObject:self.string_id])
                        {
                            [self Deletebankuai];
                        }else
                        {
                            [zsnApi showautoHiddenMBProgressWithTitle:@"" WithContent:[dic objectForKey:@"bbsinfo"] addToView:self.view];
                        }
                    }
                }
                    break;
                case 203://查看收藏
                {
                    NSLog(@"%sdasfkalklic203==%@",__FUNCTION__,dic);
                    
                    [button_collect setBackgroundImage:[UIImage imageNamed:@"ios7_collect44_42.png"] forState:UIControlStateNormal];
                    
                    if ([self.collection_array containsObject:self.string_id])
                    {
                        [self.collection_array removeObject:self.string_id];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"forumSectionChange" object:nil];
                    }
                    
                    
                    //            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"haha" message:[NSString stringWithFormat:@"%@",[dic objectForKey:@"bbsinfo"]] delegate:nil cancelButtonTitle:@"yes" otherButtonTitles:nil, nil];
                    //            [alert show];
                    [self Tishiyijingshoucang];
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}
-(void)downloadtoolError{
    
    
    
    //    UIAlertView *alert_=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络连接超时，请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //    [alert_ show];
    _replaceAlertView.hidden=NO;
    [_replaceAlertView hide];
}
#pragma mark-显示框
-(void)hidefromview{
    
    
    [self performSelector:@selector(hidealert) withObject:nil afterDelay:2];
    NSLog(@"?????");
}
-(void)hidealert{
    _replaceAlertView.hidden=YES;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isadvertisingImghiden) {
        return [_array_info count];
    }else{
        if (section==0) {
            return 0;
        }
        else{
            return [_array_info count];
            
        }
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idetifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:idetifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idetifier];
    }
    for (UIView *aview in cell.contentView.subviews) {
        [aview removeFromSuperview];
    }
    // UIView *imageviewcell=[[UIView alloc]init];
    UIImageView *imageviewcell=[[UIImageView alloc]init];
    NSDictionary *dic=[_array_info objectAtIndex:indexPath.row];
    UILabel *titleLabel;
    UILabel *authorLabel;
    UILabel *createTimeLabel;
    UILabel *repliesLabel;
    UIImageView *Essence_imageV;
    UILabel *trasactionstatelabel;
    UILabel *locationlabel;
    
    //改吧：
    
    AsyncImageView *imageHead=[[AsyncImageView alloc]initWithFrame:CGRectMake(12, 15, 40, 40)];
    
    CALayer *l = [imageHead layer];   //获取ImageView的层
    [l setMasksToBounds:YES];
    [l setCornerRadius:20.f];
    
    NSString *str_headurl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"authorid"]];
    
   str_headurl= [zsnApi returnUrl:str_headurl];
    
    [imageHead loadImageFromURL:str_headurl withPlaceholdImage:nil];
    
    imageHead.backgroundColor=[UIColor grayColor];
    
    [cell.contentView addSubview:imageHead];
    
       //gaiwan
    
    titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, 12, DEVICE_WIDTH - 80, 400)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor=RGBCOLOR(49, 49, 49);
    titleLabel.numberOfLines=0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    titleLabel.backgroundColor = [UIColor clearColor];
    [imageviewcell addSubview:titleLabel];
    
    authorLabel=[[UILabel alloc]init];
    authorLabel.font = [UIFont fontWithName:@"Helvetica" size:11.0];
    authorLabel.textColor=RGBCOLOR(103, 103, 103);
    authorLabel.backgroundColor = [UIColor clearColor];
    [imageviewcell addSubview:authorLabel];
    
    createTimeLabel=[[UILabel alloc]init];
    createTimeLabel.font = [UIFont systemFontOfSize:11];
    createTimeLabel.textColor= [UIColor lightGrayColor];
    createTimeLabel.backgroundColor = [UIColor clearColor];
    createTimeLabel.textAlignment=NSTextAlignmentLeft;
    [imageviewcell addSubview:createTimeLabel];
    
    repliesLabel=[[UILabel alloc]init];
    repliesLabel.font = [UIFont systemFontOfSize:11];
    repliesLabel.textColor=[UIColor grayColor];
    repliesLabel.backgroundColor = [UIColor clearColor];
    repliesLabel.textAlignment=NSTextAlignmentLeft;
    [imageviewcell addSubview:repliesLabel];
    
    trasactionstatelabel=[[UILabel alloc]init];
    trasactionstatelabel.font = [UIFont systemFontOfSize:15];
    trasactionstatelabel.backgroundColor = [UIColor clearColor];
    trasactionstatelabel.textAlignment=NSTextAlignmentLeft;
    
    locationlabel=[[UILabel alloc]init];
    locationlabel.font = [UIFont systemFontOfSize:15];
    locationlabel.textColor=[UIColor lightGrayColor];
    locationlabel.backgroundColor = [UIColor clearColor];
    locationlabel.textAlignment=NSTextAlignmentLeft;
    
    
    
    
    int jinghua=[[dic objectForKey:@"digest"] integerValue];
    int displayorder=[[dic objectForKey:@"displayorder"] integerValue];
    
    NSString *string_chushouqiugou=[NSString stringWithFormat:@"%@",[dic objectForKey:@"areaidinfo"]];
    
    if ([string_chushouqiugou isEqualToString:@"none"]) {
        switch (displayorder) {
            case 0:
                if (jinghua>0) {
                    Essence_imageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinghua_31x31.png"]];
                    Essence_imageV.frame=CGRectMake(8, 14, 16, 16);
                    [imageviewcell addSubview:Essence_imageV];
                    titleLabel.text=[NSString stringWithFormat:@"      %@",[zsnApi ddecodeSpecialCharactersStringWith:[dic objectForKey:@"title"]]];
                    
                }else{
                    titleLabel.text=[zsnApi ddecodeSpecialCharactersStringWith:[dic objectForKey:@"title"]];
                }
                break;
            case 1:{
                Essence_imageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1_31x31.png"]];
                Essence_imageV.frame=CGRectMake(8, 14, 16, 16);
                [imageviewcell addSubview:Essence_imageV];
                titleLabel.text=[NSString stringWithFormat:@"      %@",[zsnApi ddecodeSpecialCharactersStringWith:[dic objectForKey:@"title"]]];
            }
                break;
            case 2:{
                Essence_imageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"2_31x31.png"]];
                Essence_imageV.frame=CGRectMake(8, 14, 16, 16);
                [imageviewcell addSubview:Essence_imageV];
                titleLabel.text=[NSString stringWithFormat:@"      %@",[zsnApi ddecodeSpecialCharactersStringWith:[dic objectForKey:@"title"]]];
                
            }
                break;
            case 3:{
                Essence_imageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3_31x31.png"]];
                Essence_imageV.frame=CGRectMake(8, 14, 16, 16);
                [imageviewcell addSubview:Essence_imageV];
                titleLabel.text=[NSString stringWithFormat:@"      %@",[zsnApi ddecodeSpecialCharactersStringWith:[dic objectForKey:@"title"]]];
                
            }
                break;
            default:
                break;
        }
    }else{
        button_more.hidden=NO;
        
        titleLabel.text=[NSString stringWithFormat:@"                      %@",[zsnApi ddecodeSpecialCharactersStringWith:[dic objectForKey:@"title"]]];
        
        
        trasactionstatelabel.frame=CGRectMake(1, 12, 65,20);
        locationlabel.frame=CGRectMake(58, 11, 50, 20);
        trasactionstatelabel.text=[NSString stringWithFormat:@"【%@】",[dic objectForKey:@"typestate"]];
        NSString *string_location=[NSString stringWithFormat:@"%@",[dic objectForKey:@"areaidinfo"]];
        NSString *string_trasaction=[NSString stringWithFormat:@"%@",[dic objectForKey:@"typestate"]];
        if ([string_trasaction isEqualToString:@"出售"]) {
            trasactionstatelabel.textColor=[UIColor orangeColor];
            
        }else if([string_trasaction isEqualToString:@"求购"]||[string_trasaction isEqualToString:@"已售"])
        {
            trasactionstatelabel.textColor=[UIColor colorWithRed:0 green:128/255.f blue:0 alpha:1];
            
        }else{
            trasactionstatelabel.textColor=[UIColor clearColor];
            
            locationlabel.frame = CGRectMake(8, 3, 50, 20);
            titleLabel.frame = CGRectMake(titleLabel.frame.origin.x-56,titleLabel.frame.origin.y, titleLabel.frame.size.width,titleLabel.frame.size.height);
            
            titleLabel.text=[NSString stringWithFormat:@"           %@",[zsnApi ddecodeSpecialCharactersStringWith:[dic objectForKey:@"title"]]];
            
            
        }
        string_location=[string_location substringToIndex:2];
        locationlabel.text=[NSString stringWithFormat:@"[%@]",string_location];
        [imageviewcell addSubview:trasactionstatelabel];
        [imageviewcell addSubview:locationlabel];
        
    }
    
    
//    CGSize constraintSize = CGSizeMake(DEVICE_WIDTH - 50, MAXFLOAT);
//    CGSize labelSize = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
//    titleLabel.frame=CGRectMake(8, 12, DEVICE_WIDTH - 56, labelSize.height);
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:titleLabel.text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:LINESPACEINGS];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [titleLabel.text length])];
    
    [titleLabel setAttributedText:attributedString1];
    [titleLabel sizeToFit];
    
    
    NSLog(@"titleheight===%f",titleLabel.frame.size.height);
    
    if (titleLabel.frame.size.height<24.f) {
        
        authorLabel.text=[dic objectForKey:@"author"];
        
        authorLabel.frame=CGRectMake(28, titleLabel.frame.size.height+14, 80, 20);
        
        createTimeLabel.frame=CGRectMake(100, titleLabel.frame.size.height+14, 120, 20);
        
        createTimeLabel.center = CGPointMake(DEVICE_WIDTH / 2.f+20, createTimeLabel.center.y);
        
        createTimeLabel.backgroundColor=[UIColor whiteColor];
        
        
        repliesLabel.frame=CGRectMake(DEVICE_WIDTH - 140, titleLabel.frame.size.height+14, 80, 20);
        
        
    }else{
        authorLabel.text=[dic objectForKey:@"author"];
        authorLabel.frame=CGRectMake(28, titleLabel.frame.size.height+20, 80, 20);
        createTimeLabel.frame=CGRectMake(100, titleLabel.frame.size.height+20, 120, 20);
        
        createTimeLabel.center = CGPointMake(DEVICE_WIDTH / 2.f +20 , createTimeLabel.center.y);
        createTimeLabel.backgroundColor=[UIColor whiteColor];
        
        
        repliesLabel.frame=CGRectMake(DEVICE_WIDTH - 140, titleLabel.frame.size.height+20, 80, 20);
    
    
    }
    
    
  
    
    
    NSString *string_time=[personal timchange:[dic objectForKey:@"time"]];
    createTimeLabel.text=string_time;
    repliesLabel.text=[NSString stringWithFormat:@"%@ / %@",[dic objectForKey:@"replies" ],[dic objectForKey:@"views"]];
    
    imageviewcell.frame=CGRectMake(60, 0, DEVICE_WIDTH-60,titleLabel.frame.size.height+25 );
    [cell.contentView addSubview:imageviewcell];
    
    
    
    //三个小图标
    
    UIImageView *personlittleiConImageV=[[UIImageView alloc] initWithFrame:CGRectMake(titleLabel.left, authorLabel.top+4, 19/2, 21/2)];
    personlittleiConImageV.image=[UIImage imageNamed:@"bbsfenduipeople.png"];
    [imageviewcell addSubview:personlittleiConImageV];
    
    UIImageView *timelittleiConImageV=[[UIImageView alloc] initWithFrame:CGRectMake(createTimeLabel.left-15, createTimeLabel.top+5, 20/2, 20/2)];
    timelittleiConImageV.image=[UIImage imageNamed:@"bbsfenduisendtime.png"];
    [imageviewcell addSubview:timelittleiConImageV];
    
    UIImageView *replaylittleiConImageV=[[UIImageView alloc] initWithFrame:CGRectMake(repliesLabel.left-15, repliesLabel.top+6, 20/2, 18/2)];
    replaylittleiConImageV.image=[UIImage imageNamed:@"bbsfenduireplayss.png"];
    [imageviewcell addSubview:replaylittleiConImageV];
    

    
    
    
    imageviewcell.backgroundColor=[UIColor whiteColor];
    cell.contentView.backgroundColor=[UIColor whiteColor];
    cell.backgroundColor=[UIColor whiteColor];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return (isadvertisingImghiden?1:2);
}
//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return self.string_name;
//}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 68/2)];
    //    label_title.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"beijingtitle640x68.png"]];
    label_title.backgroundColor=RGBCOLOR(245, 245, 245);
    if (self.string_name.length==0) {
        self.string_name=[NSString stringWithFormat:@" "];
    }
    label_title.text=[NSString stringWithFormat:@"   %@",self.string_name];
    label_title.alpha=0.8;
    
    if (label_title.text.length==0) {
        label_title.text=[NSString stringWithFormat:@" "];
    }
    
    
    if (isadvertisingImghiden) {
        return  label_title;
    }else{
        if (section==0) {
            return advImgV;
        }else
        {
            return  label_title;
            
        }
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (isadvertisingImghiden) {
        return 68/2;
    }else{
        if (section==0) {
            return 50;
        }else{
            return 68/2;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic=[_array_info objectAtIndex:indexPath.row];
    int jinghua=[[dic objectForKey:@"digest"] integerValue];
    int displayorder=[[dic objectForKey:@"displayorder"] integerValue];
    NSString *string_chushouqiugou=[NSString stringWithFormat:@"%@",[dic objectForKey:@"typestate"]];
    
    
    UILabel * cLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 12, DEVICE_WIDTH - 80, 400)];
    cLabel.numberOfLines = 0;
    cLabel.font = [UIFont systemFontOfSize :16];
    
    if (string_chushouqiugou.length==0) {
        if (jinghua>0||displayorder>0) {
            
   
            
            NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"      %@",[dic objectForKey:@"title"]]];
            NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle1 setLineSpacing:LINESPACEINGS];
            [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [[NSString stringWithFormat:@"      %@",[dic objectForKey:@"title"]] length])];
            
            [cLabel setAttributedText:attributedString1];
            [cLabel sizeToFit];
            
            
            
            return cLabel.frame.size.height+40+7;
            
        }else{
            
            NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]]];
            NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle1 setLineSpacing:LINESPACEINGS];
            [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]] length])];
            
            [cLabel setAttributedText:attributedString1];
            [cLabel sizeToFit];
            
            
            
            return cLabel.frame.size.height+40+7;

            
            
        }
        
    }else{
        
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"                      %@",[dic objectForKey:@"title"]]];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:LINESPACEINGS];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [[NSString stringWithFormat:@"                      %@",[dic objectForKey:@"title"]] length])];
        
        [cLabel setAttributedText:attributedString1];
        [cLabel sizeToFit];
        
        
        
        return cLabel.frame.size.height+40+7;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (!isHidden)
    {
        [self showPopoverView:nil];
    }
    
    //    if (detail) {
    //        detail=nil;
    //    }
    selecttionofxialaview=1;
    bbsdetailViewController *   tempdetail=[[bbsdetailViewController alloc]init];
    
       [self setHidesBottomBarWhenPushed:YES];
    NSDictionary *dic=[_array_info objectAtIndex:indexPath.row];
    
    tempdetail.bbsdetail_tid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"tid"]];
    
    //    [self.leveyTabBarController hidesTabBar:YES animated:YES];
    [self.navigationController pushViewController:tempdetail animated:YES];
    
    //    [self.navigationController pushViewController:tempdetail animated:YES];
    
    
    
    NSLog(@"self.navigati===%@",self.navigationController);
    //
    
}
-(void)backto{
    
//    if (!isHidden)
//    {
//        [self showPopoverView:nil];
//    }
    
    [Collect_Tool stop];
    Collect_Tool.delegate = nil;
    
    [Collect_Tool11 stop];
    Collect_Tool11.delegate = nil;
    
    [tool_101 stop];
    tool_101.delegate=nil;
    [xialaView removeFromSuperview];
    xialaView = nil;
    [hud hide];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark-推到发帖页面
-(void)fatieyemian{
    
    
    if (!isHidden)
    {
        [self showPopoverView:nil];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_IN])
    {
        commrntbbdViewController *_fatie=[[commrntbbdViewController alloc]init];
        _fatie.title_string=@"发帖";
        _fatie.string_distinguish=@"发帖";
        _fatie.string_fid=str_fid;
        [self presentViewController:_fatie animated:YES completion:nil];
    }
    else{
        //没有激活fb，弹出激活提示
        LogInViewController *login=[LogInViewController sharedManager];
        [self presentViewController:login animated:YES completion:nil];
    }
    
}

#pragma mark-下拉刷新的代理
- (void)reloadTableViewDataSource
{
    _reloading = YES;
    
}
- (void)doneLoadingTableViewData
{
    _reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tab_];
    
}
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
    if (!isHidden)
    {
        [self showPopoverView:nil];
    }
    
    
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    if(scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height+40) && scrollView.contentOffset.y > 0)
    {
        if (numberoftypeid==0&numberofareaid==0) {
            [self sendmore];
        }else{
            [self moresalenumber:numberoftypeid locationnumber:numberofareaid];
        }
        [loadview startLoading];
    }
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    if (numberoftypeid==0&numberofareaid==0) {
        [self sendrequest];
    }else{
        [self salenumber:numberofareaid locationnumber:numberofareaid];
    }
	
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return ccif data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark-guanggao
-(void)handleImageLayout:(AsyncImageView *)tag{
    
}
-(void)testguanggao{
//    tool_guanggao=[[downloadtool alloc]init];
//    [tool_guanggao setUrl_string:[NSString stringWithFormat:@"http://cast.aim.yoyi.com.cn/afp/door/;ap=u20af583df9a9dcf0001;ct=js;pu=n1428243fc09e7230001;/?"]];
//    [tool_guanggao start];
//    tool_guanggao.delegate=self;
    
    
}
-(void )showmyadvertising{
    NSLog(@"这一次应该成了");
    isadvertisingImghiden=NO;
    [tab_ reloadData];
}
#pragma mark-广告view的delegate
-(void)TurntoFbWebview{
    fbWebViewController *fbweb=[[fbWebViewController alloc]init];
    fbweb.urlstring=str_guanggaolink;
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:fbweb animated:YES];
    NSLog(@"zounifb");
    
}
-(void)advimgdismiss{
    //    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    //    NSTimeInterval a=[dat timeIntervalSince1970];
    //    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    //    [[NSUserDefaults standardUserDefaults] setObject:timeString forKey:[NSString stringWithFormat:@"dismisstimechange"]];
    isadvertisingImghiden=YES;
    [tab_ reloadData];
    NSLog(@"在这完成广告位消失以及改变tabv的frame的动画");
    // [self performSelector:@selector(advreback) withObject:nil afterDelay:3.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
