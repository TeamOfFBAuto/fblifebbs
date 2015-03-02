//
//  SNMineViewController.m
//  fblifebbs
//
//  Created by soulnear on 15-1-20.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "SNMineViewController.h"
#import "PersonInfo.h"
#import "WeiBoCustomSegmentView.h"
#import "NewWeiBoCustomCell.h"
#import "MWPhotoBrowser.h"
#import "bbsdetailViewController.h"
#import "newsdetailViewController.h"
#import "WenJiViewController.h"
#import "NewWeiBoDetailViewController.h"
#import "fbWebViewController.h"
#import "ImagesViewController.h"
#import "mydetailViewController.h"
#import "ForwardingViewController.h"
#import "NewWeiBoCommentViewController.h"
#import "MessageInfo.h"
#import "MyChatViewController.h"
#import "SNMineBBSCell.h"
#import "SNRefreshTableView.h"
#import "GcustomActionSheet.h"
#import "MLImageCrop.h"
#import "BBSInfoModel.h"
#import "SDImageCache.h"

@interface SNMineViewController ()<UITableViewDataSource,SNRefreshDelegate,WeiBoCustomSegmentViewDelegate,NewWeiBoCustomCellDelegate,ForwardingViewControllerDelegate,NewWeiBoCommentViewControllerDelegate,MWPhotoBrowserDelegate,GcustomActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MLImageCropDelegate,UIAlertViewDelegate>
{
    UIImageView * navigation_view;
    UIView * firstSectionView;
    UIView * secondSectionView;
    ///用户背景图
    UIImageView * banner_imageView;
    ///用户头像
    UIImageView * header_imageView;
    ///用户名
    UILabel * userName_label;
    ///私信按钮
    UIButton * message_button;
    ///关注取消关注按钮
    UIButton * attention_button;
    
    WeiBoCustomSegmentView * _weibo_seg;
    ///选中的第几个（帖子、微博、资料）
    NSInteger selectedView;
    
    
    ///帖子页数
    NSInteger tiezi_page;
    ///微博页数
    NSInteger weibo_page;
    
    NewWeiBoCustomCell * test_cell;
    
    ///简介数据
    NSArray * jianjie_array;
    NSArray * key_array;
    
    ///记录每个的偏移量
    float contentOffSetY[3];
    
    NSDictionary * content_dictionary;
}

@property(nonatomic,strong)PersonInfo * per_info;
@property(nonatomic,strong)SNRefreshTableView * myTableView;
///微博数据
@property(nonatomic,strong)NSMutableArray * array_weibo;
///帖子数据
@property(nonatomic,strong)NSMutableArray * array_tiezi;
///图片
@property(nonatomic,strong)NSMutableArray * photos;
///保存选取到的图片
@property(nonatomic,strong)UIImage * userUpBannerImage;
///个人信息
@property(nonatomic,strong)BBSInfoModel * bbs_info_model;

@end

@implementation SNMineViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//    [_myTableView removeObserver:self forKeyPath:@"contentOffSetY"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _array_tiezi = [NSMutableArray array];
    _array_weibo = [NSMutableArray array];
    content_dictionary = [NSDictionary dictionary];
    weibo_page = 1;
    tiezi_page = 1;
    jianjie_array = [NSArray arrayWithObjects:@"",@"用户名",@"用户组",@"注册日期",@"积分",@"上次访问",@"帖子",@"最后发表",@"精华",@"在线时间",@"经验",@"浏览页数",@"威望",@"日均发帖",@"金钱",@"阅读权限",@"魅力",@"发帖级别",@"介绍",@"",@"性别",@"生日",@"电话",@"来自",@"婚姻",@"职业",@"性格",@"爱好",nil];
    
    key_array = [NSArray arrayWithObjects:@"",@"username",@"grouptitle",@"regdate",@"credits",@"lastvisit",@"posts",@"lastpost",@"digestposts",@"oltime",@"extcredits1",@"pageviews",@"extcredits2",@"日均发帖",@"extcredits3",@"readaccess",@"extcredits4",@"ranktitle",@"bio",@"",@"gender",@"bday",@"field_5",@"location",@"field_4",@"field_3",@"field_9",@"field_10",nil];
    
    
    _myTableView = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT) showLoadMore:YES];
    [_myTableView removeHeaderView];
    [_myTableView addObserver:self forKeyPath:@"contentOffSetY" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    _myTableView.dataSource = self;
    _myTableView.refreshDelegate = self;
    [self.view addSubview:_myTableView];
    
    if ([_myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self networkGetUserInfomation];
    [self networkGetBBSData];
    [self createFirstSectionView];
    [self networkGetUserInfo];
    [self setNavgationView];
}

-(void)setNavgationView
{
    navigation_view = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,64)];
    navigation_view.image = [UIImage imageNamed:@"default_navigation_clear_image"];
    [self.view addSubview:navigation_view];
    navigation_view.userInteractionEnabled = YES;
    [self.view bringSubviewToFront:navigation_view];
    
    UIButton * back_button = [UIButton buttonWithType:UIButtonTypeCustom];
    back_button.frame = CGRectMake(0,20,40,44);
    [back_button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [back_button setImage:[UIImage imageNamed:BACK_DEFAULT_IMAGE] forState:UIControlStateNormal];
    [navigation_view addSubview:back_button];
}
#pragma mark - 返回
-(void)back:(UIButton *)button
{
    [_myTableView removeObserver:self forKeyPath:@"contentOffSetY"];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 网络请求   **********************************
-(void)networkGetUserInfo
{
    NSString * fullUrl = [NSString stringWithFormat:URL_USERMESSAGE,_theUid,AUTHKEY];
    NSLog(@"请求个人信息接口 ---  %@",fullUrl);
    AFHTTPRequestOperation * request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]]];
    __weak typeof(self)bself = self;
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        
        NSDictionary * dictionary = [[[allDic objectForKey:@"data"] allValues] objectAtIndex:0];
        
        NSString * user_uid = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"uid"]];
        
        if ([user_uid isEqualToString:@"(null)"] || user_uid.length == 0 || [user_uid isEqualToString:@"0"] || [user_uid isEqualToString:@""])
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该用户未开通FB" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
            alert.tag = 111111;
            [alert show];
            
            return;
        }
        
        bself.per_info = [[PersonInfo alloc] initWithDictionary:dictionary];

        [bself.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [zsnApi showAutoHiddenMBProgressWithText:@"加载失败，请检查您当前网络" addToView:self.view];
    }];
    
    [request start];
}
#pragma mark - 获取帖子数据
-(void)networkGetBBSData
{
    NSString * fullUrl = [NSString stringWithFormat:BBS_GET_POSTS_URL,_theUid,tiezi_page];
    NSLog(@"请求帖子数据接口 ---   %@",fullUrl);
    AFHTTPRequestOperation * request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]]];
    __weak typeof(self)bself = self;
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        NSString * errcode = [allDic objectForKey:@"errcode"];
        if ([errcode intValue] == 0) {
            
            NSArray * array = [allDic objectForKey:@"bbsinfo"];
            
            if (tiezi_page == 1)
            {
                [bself.array_tiezi removeAllObjects];
                
                if (array.count < 20)
                {
                    bself.myTableView.hiddenLoadMore = YES;
                }else
                {
                    bself.myTableView.hiddenLoadMore = NO;
                    bself.myTableView.isHaveMoreData = YES;
                }
            }else
            {
                if (array.count == 0)
                {
                    bself.myTableView.isHaveMoreData = NO;
                }else
                {
                    bself.myTableView.isHaveMoreData = YES;
                }
            }
            
            
            if (selectedView == 0)
            {
                [bself.array_tiezi addObjectsFromArray:array];
                [bself.myTableView finishReloadigData];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [request start];
}
#pragma mark - 获取微博数据
-(void)networkGetWeiBoData
{
    MBProgressHUD * hud = [zsnApi showMBProgressWithText:@"加载中..." addToView:self.view];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSString * fullURL=[NSString stringWithFormat:FB_WEIBOMYLIST_URL,AUTHKEY,weibo_page,self.theUid];
    NSLog(@"个人微博信息接口---- %@",fullURL);
    AFHTTPRequestOperation * request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullURL]]];
    __weak typeof(self)bself = self;
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try
        {
            
            NSDictionary * dic = [operation.responseString objectFromJSONString];
            
            NSString * errcode = [dic objectForKey:@"errcode"];
            
            if ([errcode intValue] == 0)
            {
                [hud hide:YES];
                NSDictionary * weiboinfo = [dic objectForKey:@"weiboinfo"];
                
                if (weibo_page != 1)
                {
                    if ([weiboinfo isEqual:[NSNull null]])
                    {
                        bself.myTableView.isHaveMoreData = NO;
                        return;
                    }
                }else
                {
                    bself.myTableView.isHaveMoreData = YES;
                    [bself.array_weibo removeAllObjects];
                }
                
                
                if ([weiboinfo isEqual:[NSNull null]])
                {
                    bself.myTableView.isHaveMoreData = NO;
//                    loadview.normalLabel.text = @"没有更多了";
                    //如果没有微博的话
                    NSLog(@"------------没有微博信息---------------");
                }else
                {
                    bself.myTableView.isHaveMoreData = YES;
                    [bself.array_weibo addObjectsFromArray:[zsnApi conversionFBContent:weiboinfo isSave:NO WithType:0]];
                    
                    if (selectedView == 1) {
                        [bself.myTableView finishReloadigData];
                    }
                }
            }else
            {
                
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        [zsnApi showAutoHiddenMBProgressWithText:@"加载失败，请检查您当前网络" addToView:self.view];
    }];
    
    [request start];
}

#pragma mark - 获取个人数据
-(void)networkGetUserInfomation
{
//    ASIFormDataRequest * request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:BBS_GET_USER_INFOMATION_URL]];
//    
//    [request setPostValue:@"json" forKey:@"type"];
//    [request setPostValue:USER_UID forKey:@"uid"];
//    
//    __weak typeof(self)bself = self;
//    __weak typeof(request)brequest = request;
//    
//    [request setCompletionBlock:^{
//        NSDictionary * dic = [brequest.responseString objectFromJSONString];
//        
//        NSLog(@"获取用户信息数据 ----   %@",dic);
//        
//    }];
//    
//    [request setFailedBlock:^{
//        
//    }];
//    
//    [request startAsynchronous];
    
    
    AFHTTPRequestOperation * request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:BBS_GET_USER_INFOMATION_URL,_theUid]]]];
    
    __weak typeof(self)bself = self;
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        
        NSLog(@"allDic -----  %@",allDic);
        
        if ([allDic isKindOfClass:[NSDictionary class]]) {
//            content_dictionary = allDic;
            bself.bbs_info_model = [[BBSInfoModel alloc] initWithDictionary:allDic];
        }
        
        [bself.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [request start];
}


#pragma mark - 加关注取消关注
-(void)attentionTap:(UIButton *)button
{

    NSString* fullURL= [NSString stringWithFormat:button.selected?URL_QUXIAOGUANZHU:URL_GUANZHU,_per_info.uid,AUTHKEY];
    NSLog(@"关注取消关注接口----  %@",fullURL);
    
    AFHTTPRequestOperation * request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullURL]]];
    __weak typeof(self)bself = self;
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        NSString * string = [allDic objectForKey:@"data"];
        
        if (([string isEqualToString:@"取消成功"] && button.selected) || ([string isEqualToString:@"添加成功"] && !button.selected))
        {
            button.selected = !button.selected;
            [zsnApi showAutoHiddenMBProgressWithText:button.selected?@"添加成功":@"取消成功" addToView:bself.view];
            
        }else
        {
            [zsnApi showAutoHiddenMBProgressWithText:[allDic objectForKey:@"data"] addToView:bself.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [zsnApi showAutoHiddenMBProgressWithText:@"请求失败，请检查您当前网络" addToView:bself.view];
    }];
    
    [request start];
    
    
    /*
    NSString *authkey=[[NSUserDefaults standardUserDefaults] objectForKey:USER_AUTHOD];
    NSString* fullURL= [NSString stringWithFormat:attention_flg?URL_GUANZHU:URL_QUXIAOGUANZHU,_per_info.uid,authkey];
    NSLog(@"3请求的url ==  %@",fullURL);
    
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullURL]];
    
    __block ASIHTTPRequest * _requset = request;
    
    [_requset setCompletionBlock:^{
        NSDictionary * dic = [request.responseData objectFromJSONData];
        NSString * string = [dic objectForKey:@"data"];
        
        if (([string isEqualToString:@"取消成功"] && !attention_flg) || ([string isEqualToString:@"添加成功"] && attention_flg))
        {
            [self animationEnd:attention_flg];
            //            [topview setButtonHidden:attention_flg];
        }else
        {
            UIAlertView * alet = [[UIAlertView alloc] initWithTitle:@"提示" message:@"关注失败,请检查您当前网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alet show];
        }
    }];
    
    [_requset setFailedBlock:^{
        UIAlertView * alet = [[UIAlertView alloc] initWithTitle:@"提示" message:@"关注失败,请检查您当前网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alet show];
    }];
    
    [request startAsynchronous];
     */
}

#define TT_CACHE_EXPIRATION_AGE_NEVER     (1.0 / 0.0)
-(void)networkUploadBanner
{
    ASIFormDataRequest * _request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:UPLOAD_USER_BANNAR_URL]];
    
    NSData * imageData = UIImageJPEGRepresentation(self.userUpBannerImage,1.0);// UIImagePNGRepresentation(self.userUpBannerImage);
    
    [_request setPostValue:AUTHKEY forKey:@"authkey"];
    
    [_request addRequestHeader:@"filename" value:[NSString stringWithFormat:@"%d", [imageData length]]];
    //设置http body
    [_request addData:imageData withFileName:[NSString stringWithFormat:@"boris.png"] andContentType:@"image/JPEG" forKey:[NSString stringWithFormat:@"filename"]];
    
    [_request setRequestMethod:@"POST"];
    _request.cachePolicy = TT_CACHE_EXPIRATION_AGE_NEVER;
    _request.cacheStoragePolicy = ASICacheForSessionDurationCacheStoragePolicy;
    [_request startAsynchronous];
    
    
    __weak typeof(_request)brequest = _request;
    __weak typeof(self) bself = self;
    [_request setCompletionBlock:^{
        
        NSDictionary * dic = [brequest.responseString objectFromJSONString];
        
        NSLog(@"上传图片结果 ----  %@",dic);
        
        if ([[dic objectForKey:@"errcode"] intValue] == 0) {
            [zsnApi showAutoHiddenMBProgressWithText:@"图片上传成功" addToView:self.view];
            [[SDImageCache sharedImageCache] removeImageForKey:bself.bbs_info_model.backImg_small];
            banner_imageView.image = bself.userUpBannerImage;
        }else
        {
            bself.userUpBannerImage = nil;
            [zsnApi showAutoHiddenMBProgressWithText:[dic objectForKey:@"errinfo"] addToView:self.view];
        }
    }];
    
    [_request setFailedBlock:^{
        bself.userUpBannerImage = nil;
    }];

}


#pragma mark - 视图加载 ----------------------
-(void)createFirstSectionView
{
    if (!firstSectionView)
    {
        BOOL isMySelf = [_theUid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:USER_UID]];
        firstSectionView = [[UIView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_WIDTH*210/320+(isMySelf?0:72))];
        firstSectionView.backgroundColor = [UIColor whiteColor];
        ///背景图
        banner_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_WIDTH*210/320)];
//        banner_imageView.contentMode = UIViewContentModeScaleAspectFill;
        [firstSectionView addSubview:banner_imageView];
        
        banner_imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userBannerClicked:)];
        [banner_imageView addGestureRecognizer:tap];
        
        
        //头像
        header_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,130/2.0,130/2.0)];
        header_imageView.center = CGPointMake(DEVICE_WIDTH/2.0,banner_imageView.height/2.0);
        header_imageView.layer.masksToBounds = YES;
        header_imageView.layer.cornerRadius = 3;
        header_imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        header_imageView.layer.borderWidth = 2.0f;
        [firstSectionView addSubview:header_imageView];
        ///用户名
        userName_label = [[UILabel alloc] initWithFrame:CGRectMake(50,header_imageView.bottom + 13,DEVICE_WIDTH-100,16)];
        userName_label.textColor = [UIColor whiteColor];
        userName_label.textAlignment = NSTextAlignmentCenter;
        userName_label.font = [UIFont boldSystemFontOfSize:16];
        [firstSectionView addSubview:userName_label];
        
        NSArray * title_array = [NSArray arrayWithObjects:@"帖子",@"关注",@"粉丝",nil];
        
        for (NSInteger i = 0;i < title_array.count;i++)
        {
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake((DEVICE_WIDTH-60*3-22)/2.0 + (60+11)*i,userName_label.bottom + 17,60,12)];
            label.tag = 100 + i;
            label.text = [NSString stringWithFormat:@"0%@",[title_array objectAtIndex:i]];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:14];
            [firstSectionView addSubview:label];
        }
        
        
        if (!isMySelf)
        {
            [banner_imageView removeGestureRecognizer:tap];
            message_button = [UIButton buttonWithType:UIButtonTypeCustom];
            message_button.frame = CGRectMake((DEVICE_WIDTH-200-8)/2.0f,banner_imageView.bottom + 20,100,33);
            [message_button setImage:[UIImage imageNamed:@"sixin"] forState:UIControlStateNormal];
            [message_button addTarget:self action:@selector(messageTap:) forControlEvents:UIControlEventTouchUpInside];
            [firstSectionView addSubview:message_button];
            
            attention_button = [UIButton buttonWithType:UIButtonTypeCustom];
            attention_button.frame = CGRectMake(message_button.right + 8,message_button.top,100,33);
            [attention_button setImage:[UIImage imageNamed:@"guanzhuios7"] forState:UIControlStateNormal];
            [attention_button setImage:[UIImage imageNamed:@"cancelguanzhu"] forState:UIControlStateSelected];
            [attention_button addTarget:self action:@selector(attentionTap:) forControlEvents:UIControlEventTouchUpInside];
            [firstSectionView addSubview:attention_button];
        }
    }
    
    if (self.userUpBannerImage) {
        banner_imageView.image = self.userUpBannerImage;
    }else
    {
        [banner_imageView setImageWithURL:[NSURL URLWithString:_bbs_info_model.backImg_small] placeholderImage:[UIImage imageNamed:@"underPageBackGround.png"]];
    }
    
    [header_imageView setImageWithURL:[NSURL URLWithString:[zsnApi returnUrl:_theUid]] placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
    userName_label.text = _bbs_info_model.username;
    
    if (_bbs_info_model)
    {
        [self setTiezi:_per_info.topic_count Guanzhu:_per_info.follow_count Fensi:_per_info.fans_count];
    }
    
    if ([_per_info.isbuddy intValue] == 1)
    {//已关注
        attention_button.selected = YES;
        
    }else if([_per_info.isbuddy intValue] == 0)
    {//未关注
        attention_button.selected = NO;
    }
    
}

-(void)createSecondSectionView
{
    if (secondSectionView) {
        return;
    }
    
    secondSectionView = [[UIView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,40)];
    secondSectionView.backgroundColor = RGBCOLOR(240,240,240);
    
    _weibo_seg = [[WeiBoCustomSegmentView alloc] initWithFrame:CGRectMake((DEVICE_WIDTH-200)/2.0f,0,200,40)];
    _weibo_seg.backgroundColor = [UIColor clearColor];
    _weibo_seg.delegate = self;
    [_weibo_seg setAllViewsWith:[NSArray arrayWithObjects:@"帖子",@"微博",@"资料",nil] index:selectedView];
    
    [secondSectionView addSubview:_weibo_seg];
}

///复制帖子数、关注数、粉丝数
-(void)setTiezi:(NSString *)tiezi Guanzhu:(NSString *)guanzhu Fensi:(NSString *)fensi
{
    UILabel * tiezi_label = (UILabel *)[firstSectionView viewWithTag:100];
    UILabel * guanzhu_label = (UILabel *)[firstSectionView viewWithTag:101];
    UILabel * fensi_label = (UILabel *)[firstSectionView viewWithTag:102];
    
    tiezi_label.text = [NSString stringWithFormat:@"%@帖子",_bbs_info_model.posts];
    guanzhu_label.text = [NSString stringWithFormat:@"%@关注",_bbs_info_model.follow_count];
    fensi_label.text = [NSString stringWithFormat:@"%@粉丝",_bbs_info_model.fans_count];
}

#pragma mark - 私信
-(void)messageTap:(UIButton *)button
{
    MessageInfo * info = [[MessageInfo alloc] init];
    info.to_username = _per_info.username;
    info.othername = _per_info.username;
    info.to_uid = _per_info.uid;
    info.from_username = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME];
    info.from_uid = [[NSUserDefaults standardUserDefaults] objectForKey:USER_UID];
    MyChatViewController * chat = [[MyChatViewController alloc] init];
    chat.info = info;
    [self.navigationController pushViewController:chat animated:YES];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    CGFloat contentY = [[change objectForKey:@"new"] floatValue];
    
    contentOffSetY[selectedView] = contentY;
    
    if (contentY > 0)
    {
        if (contentY > 100) {
            [self setNavigationBarHidden:YES];
        }else
        {
            [self setNavigationBarHidden:NO];
        }
        return;
    }
    
    BOOL ismySelf = [_theUid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:USER_UID]];
    ///宽高比
    float kuanggaobi = DEVICE_WIDTH/(firstSectionView.height-(ismySelf?0:72));
    
    banner_imageView.top = contentY-10;
    banner_imageView.height = abs(contentY) + 10 + (firstSectionView.height-(ismySelf?0:72));
    banner_imageView.width = banner_imageView.height*kuanggaobi;
    banner_imageView.center = CGPointMake(DEVICE_WIDTH/2,banner_imageView.center.y);
}


#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else
    {
        if (selectedView == 0) {
            return _array_tiezi.count;
        }else if (selectedView == 1)
        {
            return _array_weibo.count;
        }else
        {
            return jianjie_array.count;
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 0;
    }else
    {
        if (selectedView == 0) {
            return 85;
        }else if (selectedView == 1)
        {
            if (!test_cell)
            {
                test_cell = [[NewWeiBoCustomCell alloc] init];
            }
            
            FbFeed * info = [self.array_weibo objectAtIndex:indexPath.row];
            return [test_cell returnCellHeightWith:info WithType:1] + 20;
        }else
        {
            NSString * title = [jianjie_array objectAtIndex:indexPath.row];
            if (title.length == 0) {
                return 15;
            }else
            {
                return 44;
            }
        }
    
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedView == 0)
    {
        static NSString * identifier = @"bbs";

        SNMineBBSCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SNMineBBSCell" owner:self options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSDictionary * dic = [_array_tiezi objectAtIndex:indexPath.row];
        
        cell.title_label.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"subject"]];
        cell.sub_title_label.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"forumname"]];
        cell.date_label.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"dateline"]];
        
        return cell;
    }else if (selectedView == 1)
    {
        static NSString * identifier = @"identifier";
        
        NewWeiBoCustomCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil)
        {
            cell = [[NewWeiBoCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.delegate = self;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        FbFeed * info = [self.array_weibo objectAtIndex:indexPath.row];
        [cell setAllViewWithType:1];
        [cell setInfo:info withReplysHeight:[tableView rectForRowAtIndexPath:indexPath].size.height WithType:1];
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
    }else
    {
        static NSString * identifier = @"jianjie";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        for (UIView * view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        NSString * title = [jianjie_array objectAtIndex:indexPath.row];
        
        if (title.length == 0)
        {
            cell.contentView.backgroundColor = RGBCOLOR(245,245,245);
            cell.backgroundColor = RGBCOLOR(245,245,245);
        }else
        {
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor whiteColor];
            
            UILabel * title_label = [[UILabel alloc] initWithFrame:CGRectMake(30,0,80,44)];
            title_label.text = title;
            title_label.textAlignment = NSTextAlignmentLeft;
            title_label.textColor = RGBCOLOR(113,113,113);
            title_label.font = [UIFont systemFontOfSize:16];
            [cell.contentView addSubview:title_label];
            
            NSString * sub_string;
            NSString * keys = [key_array objectAtIndex:indexPath.row];
            if (keys.length == 0)
            {
                sub_string = @"--";
            }else
            {
                if ([keys isEqualToString:@"日均发帖"])
                {
                    if (_bbs_info_model.regdate.length == 0)
                    {
                        sub_string = @"--";
                    }else
                    {
                        int days = [self returnDaysWithFromDate:[self dateFromString:_bbs_info_model.regdate] ToDate:[self dateFromString:_bbs_info_model.lastpost]];
                        
                        sub_string = [NSString stringWithFormat:@"%.2f",[_bbs_info_model.posts floatValue]/days];
                    }
                }else
                {
                    sub_string = [_bbs_info_model valueForKey:keys];
                    if (sub_string.length == 0) {
                        sub_string = @"--";
                    }
                }
            }
            
            UILabel * sub_label = [[UILabel alloc] initWithFrame:CGRectMake(120,0,DEVICE_WIDTH-150,44)];
            sub_label.text = sub_string;
            sub_label.textAlignment = NSTextAlignmentLeft;
            sub_label.textColor = RGBCOLOR(3,3,3);
            sub_label.font = [UIFont systemFontOfSize:16];
            [cell.contentView addSubview:sub_label];
        }
        
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        [self createFirstSectionView];
        return firstSectionView;
    }else
    {
        [self createSecondSectionView];
        return secondSectionView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return firstSectionView.height;
    }else
    {
        return 40;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)loadDataWithIsNew:(BOOL)isNew
{
    if (selectedView == 0)
    {
        if (isNew) {
            tiezi_page = 1;
        }else
        {
            tiezi_page++;
        }
        [self networkGetBBSData];
    }else if (selectedView == 1)
    {
        if (isNew) {
            weibo_page = 1;
        }else
        {
            weibo_page++;
        }
        [self networkGetWeiBoData];
    }else
    {
        if (!_bbs_info_model)
        {
            [self networkGetUserInfomation];
        }
    }
}
#pragma mark - Refresh tableview delegate
- (void)loadNewData
{
    [self loadDataWithIsNew:YES];
}
- (void)loadMoreData
{
    [self loadDataWithIsNew:NO];
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedView == 0)//帖子
    {
        NSDictionary * dic = [_array_tiezi objectAtIndex:indexPath.row];

        bbsdetailViewController * bbsdetail = [[bbsdetailViewController alloc] init];
        bbsdetail.bbsdetail_tid = [dic objectForKey:@"tid"];
        [self.navigationController pushViewController:bbsdetail animated:YES];
        
    }else if (selectedView == 1)//微博
    {
        FbFeed * info = [self.array_weibo objectAtIndex:indexPath.row];

        NewWeiBoDetailViewController * detail = [[NewWeiBoDetailViewController alloc] init];
        
        detail.info = info;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 0;
    }else
    {
        if (selectedView == 0) {
            return 85;
        }else if (selectedView == 1)
        {
            if (!test_cell)
            {
                test_cell = [[NewWeiBoCustomCell alloc] init];
            }
            
            FbFeed * info = [self.array_weibo objectAtIndex:indexPath.row];
            return [test_cell returnCellHeightWith:info WithType:1] + 20;
        }else
        {
            NSString * title = [jianjie_array objectAtIndex:indexPath.row];
            if (title.length == 0) {
                return 15;
            }else
            {
                return 44;
            }
        }
        
    }
}
- (UIView *)viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        [self createFirstSectionView];
        return firstSectionView;
    }else
    {
        [self createSecondSectionView];
        return secondSectionView;
    }
}
- (CGFloat)heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return firstSectionView.height;
    }else
    {
        return 40;
    }
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    contentOffSetY[selectedView] = scrollView.contentOffset.y;
    
    if (scrollView.contentOffset.y > 0)
    {
        if (scrollView.contentOffset.y > 100) {
            [self setNavigationBarHidden:YES];
        }else
        {
            [self setNavigationBarHidden:NO];
        }
        return;
    }
    
    BOOL ismySelf = [_theUid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:USER_UID]];
    ///宽高比
    float kuanggaobi = DEVICE_WIDTH/(firstSectionView.height-(ismySelf?0:72));
    
    banner_imageView.top = scrollView.contentOffset.y-10;
    banner_imageView.height = abs(scrollView.contentOffset.y) + 10 + (firstSectionView.height-(ismySelf?0:72));
    banner_imageView.width = banner_imageView.height*kuanggaobi;
    banner_imageView.center = CGPointMake(DEVICE_WIDTH/2,banner_imageView.center.y);
}

#pragma mark - ====== 点击更换封面图 =======
-(void)userBannerClicked:(UITapGestureRecognizer *)sender
{
    
    GcustomActionSheet *aaa = [[GcustomActionSheet alloc]initWithTitle:nil
                                                          buttonTitles:@[@"更换相册封面"]
                                                     buttonTitlesColor:[UIColor blackColor]
                                                           buttonColor:[UIColor whiteColor]
                                                           CancelTitle:@"取消"
                                                      cancelTitelColor:[UIColor whiteColor]
                                                           CancelColor:RGBCOLOR(253, 144, 39)
                                                       actionBackColor:RGBCOLOR(236, 236, 236)];
    
    
    aaa.tag = 90;
    aaa.delegate = self;
    [aaa showInView:self.view WithAnimation:YES];

}

-(void)gActionSheet:(GcustomActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"actionsheet.tag = %d, buttonIndex = %d",actionSheet.tag,buttonIndex);
    
    if (buttonIndex == 1) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
}

#pragma mark - UIImagePickerControllerDelegate 拍照选择照片协议方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        
        //压缩图片 不展示原图
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //按比例缩放
        UIImage *scaleImage = [self scaleImage:originImage toScale:0.7];
        
        //将图片传递给截取界面进行截取并设置回调方法（协议）
        MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
        imageCrop.delegate = self;
        
        //按像素缩放
        imageCrop.ratioOfWidthAndHeight = 750.0f/560.0f;//设置缩放比例
        imageCrop.image = scaleImage;
        picker.navigationBar.hidden = YES;
        [picker pushViewController:imageCrop animated:YES];
    }
}
#pragma mark- 缩放图片
//按比例缩放
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//按像素缩放
-(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
#pragma mark - crop delegate
#pragma mark - 图片回传协议方法
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    //用户需要上传的剪裁后的image
    self.userUpBannerImage = cropImage;
    NSLog(@"在此设置用户上传的头像");
    
    //ASI上传
    [self networkUploadBanner];
    
//    [_tableView reloadData];
    
}

#pragma mark - UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 111111) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - WeiBo segment delegate
-(void)ClickWeiBoCustomSegmentWithIndex:(int)index
{
    _myTableView.tableFooterView.hidden = NO;
    contentOffSetY[selectedView] = _myTableView.contentOffset.y;
   
    selectedView = index;
    [self.myTableView finishReloadigData];
    
    _myTableView.contentOffset = CGPointMake(0,contentOffSetY[index]);
    
    switch (index) {
        case 0:
        {            
            if (_array_tiezi.count == 0)
            {
                [self networkGetBBSData];
            }
        }
            break;
        case 1:
        {
            if (_array_weibo.count == 0)
            {
                [self networkGetWeiBoData];
            }
        }
            break;
        case 2:
        {
            _myTableView.tableFooterView.hidden = YES;
        }
            break;
        default:
            break;
    }
}

-(void)WeiBoViewLogIn
{
    
}

#pragma mark-NewWeiBoCustomCellDelegate

-(void)showOriginalWeiBoContent:(NSString *)theTid
{
    
    NSString *authkey=[[NSUserDefaults standardUserDefaults] objectForKey:USER_AUTHOD];
    NSString * fullURL= [NSString stringWithFormat:@"http://fb.fblife.com/openapi/index.php?mod=getweibo&code=content&tid=%@&fromtype=b5eeec0b&authkey=%@&page=1&fbtype=json",theTid,authkey];
    
    NSLog(@"1请求的url = %@",fullURL);
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullURL]];
    
    __block ASIHTTPRequest * _requset = request;
    
    [_requset setCompletionBlock:^{
        
        @try
        {
            NSDictionary * dic = [request.responseData objectFromJSONData];
            NSLog(@"个人信息 -=-=  %@",dic);
            
            NSString *errcode =[NSString stringWithFormat:@"%@",[dic objectForKey:ERRCODE]];
            
            if ([@"0" isEqualToString:errcode])
            {
                NSDictionary * userInfo = [dic objectForKey:@"weiboinfo"];
                
                if ([userInfo isEqual:[NSNull null]])
                {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该篇微博不存在" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
                    [alert show];
                    
                    return;
                }else
                {
                    FbFeed * obj = [[FbFeed alloc]init];
                    
                    obj.tid = theTid;
                    
                    obj = [[zsnApi conversionFBContent:userInfo isSave:NO WithType:0] objectAtIndex:0];
                    
                    NewWeiBoDetailViewController * detail = [[NewWeiBoDetailViewController alloc] init];
                    
                    detail.info=obj;
                    
                    [self.navigationController pushViewController:detail animated:YES];
                }
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }];
    
    
    [_requset setFailedBlock:^{
        
        [request cancel];
    }];
    
    [_requset startAsynchronous];
    
}



-(void)presentToFarwardingControllerWithInfo:(FbFeed *)info WithCell:(NewWeiBoCustomCell *)theCell
{
    NSIndexPath * theIndexpath;
    
    theIndexpath = [_myTableView indexPathForCell:theCell];
    
    ForwardingViewController * forward = [[ForwardingViewController alloc] init];
    forward.info = info;
    forward.delegate = self;
    forward.theIndexPath = theIndexpath.row;
    [self presentViewController:forward animated:YES completion:nil];
}

-(void)presentToCommentControllerWithInfo:(FbFeed *)info WithCell:(NewWeiBoCustomCell *)theCell
{
    NSIndexPath * theIndexpath;
    
    theIndexpath = [_myTableView indexPathForCell:theCell];
    
    NewWeiBoCommentViewController * forward = [[NewWeiBoCommentViewController alloc] init];
    forward.info = info;
    forward.delegate = self;
    forward.tid = info.tid;
    forward.theIndexPath = theIndexpath.row;
    [self presentViewController:forward animated:YES completion:nil];
}





-(void)showVideoWithUrl:(NSString *)theUrl
{
    fbWebViewController * web = [[fbWebViewController alloc] init];
    
    web.urlstring = theUrl;
    
    [self.navigationController pushViewController:web animated:YES];
}

-(void)deleteSomeWeiBoContent:(NewWeiBoCustomCell *)cell
{
    MBProgressHUD * delete_hud = [zsnApi showMBProgressWithText:@"正在删除..." addToView:self.view];
    delete_hud.mode = MBProgressHUDModeIndeterminate;

    
    NSIndexPath * indexPath = [_myTableView indexPathForCell:cell];
    
    FbFeed * fbfeed = [self.array_weibo objectAtIndex:indexPath.row];
    
    NSString * string = [NSString stringWithFormat:FB_DELETEWEIBO_URL,fbfeed.tid,[[NSUserDefaults standardUserDefaults] objectForKey:USER_AUTHOD]];
    
    NSURL * fullUrl = [NSURL URLWithString:string];
    
    NSLog(@"删除微博Url ==   %@",fullUrl);
    
    ASIHTTPRequest * request1 = [ASIHTTPRequest requestWithURL:fullUrl];
    
    request1.shouldAttemptPersistentConnection = NO;
    
    __block ASIHTTPRequest * _request = request1;
    
    __weak typeof(self)bself = self;
    [_request setCompletionBlock:^{
        
        @try {
            [delete_hud hide:YES];
            NSDictionary * dic = [request1.responseData objectFromJSONData];
            
            NSLog(@"删除内容 -----  %@",dic);
            
            if ([[dic objectForKey:@"errcode"] intValue] !=0)
            {
                [zsnApi showAutoHiddenMBProgressWithText:@"删除失败" addToView:self.view];
//                _replaceAlertView.hidden=NO;
//                [_replaceAlertView hide];
            }else
            {
                [zsnApi showAutoHiddenMBProgressWithText:@"删除成功" addToView:self.view];
                [bself.array_weibo removeObjectAtIndex:indexPath.row];
                
                NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:indexPath.row inSection:1];
                
                [_myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath1] withRowAnimation:UITableViewRowAnimationRight];
                
//                [_myTableView reloadData];
            }
        }
        @catch (NSException *exception)
        {
            
        }
        @finally {
            
        }
    }];
    
    
    [_request setFailedBlock:^{
        [zsnApi showAutoHiddenMBProgressWithText:@"删除失败" addToView:self.view];
//        [hud hide];
//        _replaceAlertView.hidden=NO;
//        [_replaceAlertView hide];
    }];
    
    [request1 startAsynchronous];
}


-(void)clickHeadImage:(NSString *)uid
{
    SNMineViewController * mine = [[SNMineViewController alloc] init];
    
    mine.theUid = uid;
    
    [self.navigationController pushViewController:mine animated:YES];
}


-(void)clickUrlToShowWeiBoDetailWithInfo:(FbFeed *)info WithUrl:(NSString *)theUrl isRe:(BOOL)isRe
{
    NSString * string = isRe?info.rsort:info.sort;
    
    NSString * sortId = isRe?info.rsortId:info.sortId;
    
    if ([string intValue] == 7 || [string intValue] == 6 || [string intValue] == 8)//新闻
    {
        newsdetailViewController * news = [[newsdetailViewController alloc] initWithID:sortId];
        [self setHidesBottomBarWhenPushed:YES];
        //        [self.leveyTabBarController hidesTabBar:YES animated:YES];
        [self.navigationController pushViewController:news animated:YES];
        [self setHidesBottomBarWhenPushed: NO];
        
    }else if ([string intValue] == 4 || [string intValue] == 5)//帖子
    {
        bbsdetailViewController * bbs = [[bbsdetailViewController alloc] init];
        bbs.bbsdetail_tid = sortId;
        if ([string intValue] == 5)
        {
            bbs.bbsdetail_tid = info.sortId;
        }
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:bbs animated:YES];
        [self setHidesBottomBarWhenPushed: NO];
        
    }else if ([string intValue] == 3)
    {
        ImagesViewController * images = [[ImagesViewController alloc] init];
        images.tid = isRe?info.rphoto.aid:info.photo.aid;
        
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:images animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
        
    }else if ([string intValue] == 2)
    {
        WenJiViewController * wenji = [[WenJiViewController alloc] init];
        
        wenji.bId = sortId;
        
        [self setHidesBottomBarWhenPushed:YES];
        //        [self.leveyTabBarController hidesTabBar:YES animated:YES];
        
        [self.navigationController pushViewController:wenji animated:YES];
        
        [self setHidesBottomBarWhenPushed:NO];
    }else
    {
        NewWeiBoDetailViewController * detail = [[NewWeiBoDetailViewController alloc] init];
        
        detail.info = info;
        
        [self setHidesBottomBarWhenPushed:YES];
        
        //        [self.leveyTabBarController hidesTabBar:YES animated:YES];
        
        [self.navigationController pushViewController:detail animated:YES];
        
        [self setHidesBottomBarWhenPushed:NO];
    }
}

-(void)showClickUrl:(NSString *)theUrl WithFBFeed:(FbFeed *)info;
{
    fbWebViewController *fbweb=[[fbWebViewController alloc]init];
    
    fbweb.urlstring = theUrl;
    
    [self.navigationController pushViewController:fbweb animated:YES];
}

-(void)showAtSomeBody:(NSString *)theUrl WithFBFeed:(FbFeed *)info
{
    SNMineViewController * people = [[SNMineViewController alloc] init];
    
    if ([theUrl rangeOfString:@"fb://PhotoDetail/id="].length)
    {
        people.theUid = [theUrl stringByReplacingOccurrencesOfString:@"fb://PhotoDetail/id=" withString:@""];
    }else if([theUrl rangeOfString:@"fb://atSomeone@/"].length)
    {
        people.theUid = [theUrl stringByReplacingOccurrencesOfString:@"fb://atSomeone@/" withString:@""];
    }else
    {
        people.theUid = info.ruid;
    }
    
    [self.navigationController pushViewController:people animated:YES];
}

-(void)showImage:(FbFeed *)info isReply:(BOOL)isRe WithIndex:(int)index
{
    [_photos removeAllObjects];
    
    NSString * image_string = isRe?info.rimage_original_url_m:info.image_original_url_m;
    
    NSArray * array = [image_string componentsSeparatedByString:@"|"];
    
    for (NSString * string in array)
    {
        NSString * url_string = [string stringByReplacingOccurrencesOfString:@"_s." withString:@"_b."];
        [_photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:url_string]]];
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    
    NSString * titleString = info.photo_title;
    
    if (titleString.length == 0 || [titleString isEqual:[NSNull null]] || [titleString isEqualToString:@"(null)"])
    {
        titleString = @"";
    }
    
    
    browser.title_string = titleString;
    
    [browser setInitialPageIndex:index];
    
    [self presentViewController:browser animated:YES completion:nil];
}



#pragma mark - MWPhotoBrowserDelegate



- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return _photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}


#pragma mark-评论转发成功

-(void)ForwardingSuccessWihtTid:(NSString *)theTid IndexPath:(int)theIndexpath SelectView:(int)theselectview WithComment:(BOOL)isComment
{
    FbFeed * _feed;
    
    
    _feed = [self.array_weibo objectAtIndex:theIndexpath];
    
    _feed.forwards = [NSString stringWithFormat:@"%d",[_feed.forwards intValue]+1];
    
    if (isComment)
    {
        _feed.replys = [NSString stringWithFormat:@"%d",[_feed.replys intValue]+1];
    }
    
    
    [self.array_weibo replaceObjectAtIndex:theIndexpath withObject:_feed];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:theIndexpath inSection:0];
    
    NewWeiBoCustomCell * cell = (NewWeiBoCustomCell *)[_myTableView cellForRowAtIndexPath:indexPath];
    
    [cell setReplys:_feed.replys ForWards:_feed.forwards];
}


-(void)commentSuccessWihtTid:(NSString *)theTid IndexPath:(int)theIndexpath SelectView:(int)theselectview withForward:(BOOL)isForward
{
    FbFeed * _feed;
    
    _feed = [self.array_weibo objectAtIndex:theIndexpath];
    
    _feed.replys = [NSString stringWithFormat:@"%d",[_feed.replys intValue]+1];
    
    if (isForward)
    {
        _feed.forwards = [NSString stringWithFormat:@"%d",[_feed.forwards intValue]+1];
    }
    
    [self.array_weibo replaceObjectAtIndex:theIndexpath withObject:_feed];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:theIndexpath inSection:0];
    
    NewWeiBoCustomCell * cell = (NewWeiBoCustomCell *)[_myTableView cellForRowAtIndexPath:indexPath];
    
    [cell setReplys:_feed.replys ForWards:_feed.forwards];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



#pragma mark *************************  自定义方法
///根据uid获取用户banner
-(NSString *)returnBannerUrlWithUID:(NSString *)uid
{
    if (uid.length !=0 && uid.length < 6)
    {
        for (int i = 0;i < uid.length -6;i++)
        {
            uid = [NSString stringWithFormat:@"%d%@",0,uid];
        }
    }
    
    NSString * string;
    if (uid.length ==0)
    {
        string = @"";
    }else
    {
        string =  [NSString stringWithFormat:@"http://fb.fblife.com/./images/userface/000/%@/%@/face_%@_0.jpg",[[uid substringToIndex:2] substringFromIndex:0],[[uid substringToIndex:4] substringFromIndex:2],[[uid substringToIndex:6] substringFromIndex:4]];
    }
    
    return string;
}

#pragma mark - 隐藏显示导航栏
-(void)setNavigationBarHidden:(BOOL)isHidden
{
    [[UIApplication sharedApplication]  setStatusBarHidden:isHidden withAnimation:UIStatusBarAnimationSlide];
    [UIView animateWithDuration:0.3 animations:^{
        navigation_view.top = isHidden?-64:0;
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - 计算已知两个日期相差在天数
-(int)returnDaysWithFromDate:(NSDate *)fromDate ToDate:(NSDate *)toDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *startDate = fromDate;
    NSDate *endDate = toDate;
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate toDate:endDate options:0];
    int days = [comps day];
    return days;
}

-(NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    dateFormatter = nil;
    return destDate;
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
