//
//  NotificationScrollView.m
//  fblifebbs
//zsn
//  Created by soulnear on 14-10-14.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "NotificationView.h"
#import "NotificationFBModel.h"
#import "NotificationBBSModel.h"
#import "personal.h"
#import "NotificationTableViewCell.h"
#import "bbsdetailViewController.h"
#import "NewMineViewController.h"
#import "WenJiViewController.h"
#import "ImagesViewController.h"

#define loading @"正在加载..."
#define load_failed @"加载失败"


@implementation NotificationView
@synthesize myTableView = _myTableView;

-(id)initWithFrame:(CGRect)frame withType:(NotificationViewType)theType
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _aType = theType;
        [self setup];
    }
    return self;
}

-(void)setup
{
    uread_array = [NSMutableArray array];
    read_array = [NSMutableArray array];
    bbs_array = [NSMutableArray array];
    
    uread_page = 1;
    read_page = 1;
    
    _myTableView = [[RefreshTableView alloc] initWithFrame:self.bounds showLoadMore:YES];
    _myTableView.dataSource = self;
    _myTableView.refreshDelegate = self;
    _myTableView.isHaveMoreData = NO;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_myTableView];
    
    [self getNotificationData];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccess:) name:NOTIFICATION_LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logoutSuccess:) name:NOTIFICATION_LOGOUT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HaveNetWork:) name:NOTIFICATION_HAVE_NETWORK object:nil];
}

#pragma mark - 登陆成功
-(void)loginSuccess:(NSNotification *)notification
{
    _myTableView.pageNum = 1;
    uread_page = 1;
    read_page = 1;
    [self getNotificationData];
}

#pragma mark - 退出登录成功
-(void)logoutSuccess:(NSNotification *)notification
{
    if (_aType == NotificationViewTypeBBS)
    {
        [bbs_array removeAllObjects];
        [_myTableView finishReloadigData];
    }else
    {
        [uread_array removeAllObjects];
        [read_array removeAllObjects];
        [_myTableView finishReloadigData];
    }
    
}
#pragma mark - 来网啦
-(void)HaveNetWork:(NSNotification *)notification
{
    if ((uread_array.count == 0 && read_array.count ==0) || bbs_array.count == 0)
    {
        [self getNotificationData];
    }
    
}

#pragma mark - 获取数据
-(void)getNotificationData
{
    if (_aType == NotificationViewTypeFB)//fb通知
    {
        MBProgressHUD * hud = [zsnApi showMBProgressWithText:loading addToView:self];
        
        request_tools = [[LTools alloc] initWithUrl:[NSString stringWithFormat:GET_FB_UREAD_NOTIFICATION_URL,[personal getMyAuthkey],uread_page] isPost:NO postData:nil];
        __weak typeof(self)bself = self;
        [request_tools requestSpecialCompletion:^(NSDictionary *result, NSError *erro){
            
            if ([[result objectForKey:@"errcode"] intValue]==0)
            {
                if (uread_page == 1)
                {
                    [uread_array removeAllObjects];
                }
                
                NSArray * array = [result objectForKey:@"alertlist"];
                
                if ([array isKindOfClass:[NSArray class]])
                {
                    if (array.count)
                    {
                        for (NSDictionary * aDic in array)
                        {
                            NotificationFBModel * model = [[NotificationFBModel alloc] initWithDic:aDic];
                            [uread_array addObject:model];
                        }
                        
                        if (array.count < 20)
                        {
                            isUReadOver = YES;
                            [bself loadFBReadNotificationWithHud:hud];
                        }else
                        {
                            bself.myTableView.isHaveMoreData = YES;
                            [bself.myTableView finishReloadigData];
                            [bself.myTableView reloadData];
                        }
                    }else
                    {
                        isUReadOver = YES;
                        [bself loadFBReadNotificationWithHud:hud];
                    }
                }else
                {
                    isUReadOver = YES;
                    [bself loadFBReadNotificationWithHud:hud];
                }
                
            }else
            {
                [bself loadFBReadNotificationWithHud:hud];
            }
            
        } failBlock:^(NSDictionary *failDic, NSError *erro)
        {
            if (uread_array.count == 0 && read_array.count == 0)
            {
                bself.myTableView.isHaveMoreData = NO;
            }
            
            [bself loadFBReadNotificationWithHud:hud];
        }];
        
    }else if (_aType == NotificationViewTypeBBS)//bbs通知
    {
        MBProgressHUD * hud = [zsnApi showMBProgressWithText:loading addToView:self];
        
        request_tools = [[LTools alloc] initWithUrl:[NSString stringWithFormat:GET_BBS_NOTIFICATION_URL,[personal getMyAuthkey],_myTableView.pageNum] isPost:NO postData:nil];
        __weak typeof(self)bself = self;
        [request_tools requestSpecialCompletion:^(NSDictionary *result, NSError *erro){
            [hud hide:YES];
            [bself.myTableView finishReloadigData];
            @try
            {
                if (_myTableView.pageNum == 1)
                {
                    [bbs_array removeAllObjects];
                }
                NSArray * array = [result objectForKey:@"bbsinfo"];
                
                if ([array isKindOfClass:[NSArray class]])
                {
                    for (NSDictionary * aDic in array)
                    {
                        NotificationBBSModel * model = [[NotificationBBSModel alloc] initWithDic:aDic];
                        [bbs_array addObject:model];
                    }
                    
                    if (array.count < 20)
                    {
                        bself.myTableView.isHaveMoreData = NO;
                    }else
                    {
                        bself.myTableView.isHaveMoreData = YES;
                    }
                }
                
                [bself.myTableView finishReloadigData];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            hud.labelText = load_failed;
            [hud hide:YES afterDelay:1.5];
            [bself.myTableView finishReloadigData];
        }];
    }
}

#pragma mark - 读取fb已读通知
-(void)loadFBReadNotificationWithHud:(MBProgressHUD *)hud
{
    [request_tools cancelRequest];
    request_tools = nil;
    
    request_tools = [[LTools alloc] initWithUrl:[NSString stringWithFormat:GET_FB_READ_NOTIFICATION_URL,[personal getMyAuthkey],read_page] isPost:NO postData:nil];
    __weak typeof(self)bself = self;
    [request_tools requestSpecialCompletion:^(NSDictionary *result, NSError *erro){
        [bself.myTableView finishReloadigData];
        if ([[result objectForKey:@"errcode"] intValue]==0)
        {
            [hud hide:YES];
            
            if (read_page == 1)
            {
                [read_array removeAllObjects];
            }
            
            NSArray * array = [result objectForKey:@"alertlist"];
            
            if (![array isKindOfClass:[NSArray class]])
            {
                [bself.myTableView finishReloadigData];
                return ;
            }
            
            for (NSDictionary * aDic in array)
            {
                NotificationFBModel * model = [[NotificationFBModel alloc] initWithDic:aDic];
                [read_array addObject:model];
            }
            
            if (array.count < 20)
            {
                bself.myTableView.isHaveMoreData = NO;
            }else
            {
                bself.myTableView.isHaveMoreData = YES;
            }
            [bself.myTableView finishReloadigData];
        }else
        {
            hud.labelText = [result objectForKey:@"errinfo"];
            [hud hide:YES afterDelay:1.5];
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        hud.labelText = load_failed;
        [hud hide:YES afterDelay:1.5];
        [bself.myTableView finishReloadigData];
    }];
    
    
}


#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_aType == NotificationViewTypeBBS) {
        return 1;
    }else
    {
        if (uread_array.count > 0)
        {
            if (isUReadOver)
            {
                return 2;
            }else
            {
                return 1;
            }
        }else
        {
            return 1;
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_aType==NotificationViewTypeFB) {
        if (section == 0)
        {
            if (uread_array.count > 0)
            {
                return uread_array.count;
            }else
            {
                return read_array.count;
            }
        }else
        {
            return read_array.count;
        }
        
    }else{
        return bbs_array.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    NotificationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NotificationTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    if (_aType == NotificationViewTypeFB)
    {
        NotificationFBModel * model;
        
        if (indexPath.section == 0)
        {
            if (uread_array.count > 0)
            {
                model = [uread_array objectAtIndex:indexPath.row];
            }else
            {
                model = [read_array objectAtIndex:indexPath.row];
            }
        }else
        {
            model = [read_array objectAtIndex:indexPath.row];
        }
        
        [cell setInfoWith:model];
        
    }else
    {
        NotificationBBSModel * model = [bbs_array objectAtIndex:indexPath.row];
        
        [cell setInfoWith:model];
        
    }
    
    cell.backgroundColor = RGBCOLOR(248,248,248);
    cell.contentView.backgroundColor = RGBCOLOR(248,248,248);
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (_aType == NotificationViewTypeBBS)
    {
        NotificationBBSModel * model = [bbs_array objectAtIndex:indexPath.row];
        bbsdetailViewController * detail = [[bbsdetailViewController alloc] init];
        detail.bbsdetail_tid = model.tid;
        detail.hidesBottomBarWhenPushed = YES;
        [((UIViewController*)_delegate).navigationController pushViewController:detail animated:YES];
    }else
    {
        NotificationFBModel * model;
        
        if (indexPath.section == 0)
        {
            if (uread_array.count>0)
            {
                model=[uread_array objectAtIndex:indexPath.row];
            }else
            {
                model=[read_array objectAtIndex:indexPath.row];
            }
        }else
        {
            model=[read_array objectAtIndex:indexPath.row];
        }
        
        int type=[model.fb_oatype intValue];
        NSString *string_tid=model.fb_actid;
        
        if (type==2 || type==7)
        {//文集
            
            WenJiViewController * wenji = [[WenJiViewController alloc] init];
            wenji.bId = string_tid;
            wenji.hidesBottomBarWhenPushed = YES;
            [((UIViewController*)_delegate).navigationController pushViewController:wenji animated:YES];
            
        }else if (type==3)
        {//画廊
            
            ImagesViewController * images = [[ImagesViewController alloc] init];
            images.tid = string_tid;
            images.hidesBottomBarWhenPushed = YES;
            [((UIViewController*)_delegate).navigationController pushViewController:images animated:YES];
        }else if (type==9)
        {//加好友
            NewMineViewController * people = [[NewMineViewController alloc] init];
            people.uid = string_tid;
            [((UIViewController*)_delegate).navigationController pushViewController:people animated:YES];
        }else if (type==4||type==5)
        {//微博
            
            /*
            
            NewWeiBoDetailViewController *detail=[[NewWeiBoDetailViewController alloc]init];
            
            FbFeed * obj = [[FbFeed alloc]init];
            
            obj.tid = string_tid;
            
            NSString *authkey=[[NSUserDefaults standardUserDefaults] objectForKey:USER_AUTHOD];
            NSString * fullURL= [NSString stringWithFormat:@"http://fb.fblife.com/openapi/index.php?mod=getweibo&code=weibocomment&tid=%@&fromtype=b5eeec0b&authkey=%@&page=1&fbtype=json",string_tid,authkey];
            
            NSLog(@"1请求的url = %@",fullURL);
            ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullURL]];
            
            __block ASIHTTPRequest * _requset = request;
            
            _requset.delegate = self;
            
            [_requset setCompletionBlock:^{
                
                @try {
                    NSDictionary * dic = [request.responseData objectFromJSONData];
                    NSLog(@"个人信息 -=-=  %@",dic);
                    
                    
                    if ([[dic objectForKey:@"weibomain"] isEqual:[NSNull null]] || [[dic objectForKey:@"weibomain"] isEqual:@"<null>"])
                    {
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该篇微博不存在" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
                        [alert show];
                        
                        return;
                    }
                    
                    
                    NSDictionary * value = [dic objectForKey:@"weibomain"];
                    
                    
                    if ([[dic objectForKey:@"errcode"] intValue] ==0)
                    {
                        //解析微博内容
                        [obj setTid:[value objectForKey:FB_TID]];
                        [obj setUid:[value objectForKey:FB_UID]];
                        [obj setUserName:[value objectForKey:FB_USERNAME]];
                        [obj setContent: [zsnApi imgreplace:[value objectForKey:FB_CONTENT]]];
                        
                        if ([[value objectForKey:FB_IMAGEID] isEqualToString:@"0"])
                        {
                            [obj setNsImageFlg:@"0"];
                        }else
                        {
                            [obj setNsImageFlg:@"1"];
                        }
                        
                        
                        obj.image_original_url_m = [value objectForKey:@"image_original_m"];
                        
                        obj.image_small_url_m = [value objectForKey:@"image_small_m"];
                        
                        //是否有图片
                        if ([obj imageFlg])
                        {
                            [obj setImage_original_url:[value objectForKey:FB_IMAGE_ORIGINAL]];
                            [obj setImage_small_url:[value objectForKey:FB_IMAGE_SMALL]];
                        }
                        
                        [obj setFrom:[zsnApi exchangeFrom:[value objectForKey:FB_FROM]]];
                        [obj setNsType:[value objectForKey:FB_TYPE]];
                        obj.sort = [value objectForKey:FB_SORT];
                        obj.sortId = [value objectForKey:FB_SORTID];
                        [obj setJing_lng:[value objectForKey:FB_JING_LNG]];
                        [obj setWei_lat:[value objectForKey:FB_WEI_LAT]];
                        [obj setLocality:[value objectForKey:FB_LOCALITY]];
                        [obj setFace_original_url:[value objectForKey:FB_FACE_ORIGINAL]];
                        [obj setFace_small_url:[value objectForKey:FB_FACE_SMALL]];
                        [obj setNsRootFlg:[value objectForKey:FB_ROOTTID]];
                        [obj setDateline:[value objectForKey:FB_DATELINE]];//[personal timestamp:[value objectForKey:FB_DATELINE]]];
                        [obj setReplys:[value objectForKey:FB_REPLYS]];
                        [obj setForwards:[value objectForKey:FB_FORWARDS]];
                        [obj setRootFlg:NO];
                        
                        //解析其他类型
                        
                        if (([obj.sort isEqualToString:@"6"] || [obj.sort isEqualToString:@"7"])&&[obj.type isEqualToString:@"first"])
                        {
                            //解析新闻评论
                            NSDictionary *exjson= [[value objectForKey:FB_EXTENSION] objectFromJSONString];
                            
                            Extension * ex=[[Extension alloc]initWithJson:exjson];
                            
                            [obj setExten:ex];
                            
                            [obj setContent:[NSString stringWithFormat:@"我对新闻<a href=\"fb.news://PhotoDetail/id=%@/sort=%@\">%@</a>发表了评论:%@",obj.sortId,obj.sort,ex.title,obj.content]];
                            
                            
                        }else if([obj.sort isEqualToString:@"3"]&&[obj.type isEqualToString:@"first"])
                        {
                            //解析图集
                            NSDictionary *photojson= [[value objectForKey:FB_CONTENT] objectFromJSONString];
                            
                            PhotoFeed * photo=[[PhotoFeed alloc]initWithJson:photojson];
                            
                            [obj setPhoto:photo];
                            
                            [obj setContent:[NSString stringWithFormat:@"我在图集<a href=\"fb://PhotoDetail/%@\">%@</a>上传了新图片",photo.aid,photo.title]];
                            
                            [obj setImageFlg:YES];
                            
                            [obj setImage_small_url_m: photo.image_string];
                            
                            [obj setImage_original_url_m:photo.image_string];
                            
                        }else if([obj.sort isEqualToString:@"2"]&&[obj.type isEqualToString:@"first"])
                        {
                            //解析文集
                            NSDictionary *blogjson= [[value objectForKey:FB_CONTENT] objectFromJSONString];
                            
                            BlogFeed * blog=[[BlogFeed alloc]initWithJson:blogjson];
                            
                            [obj setBlog:blog];
                            
                            //   href=\"fb://BlogDetail/%@\"
                            [obj setContent:[NSString stringWithFormat:@"我发表文集<a href=\"fb://BlogDetail/%@\">%@</a>:%@",blog.blogid,blog.title,blog.content]];
                            
                            [obj setImageFlg:blog.photoFlg];
                            
                            if (blog.photoFlg)
                            {
                                [obj setImage_small_url_m:blog.photo];
                                [obj setImage_original_url_m:blog.photo];
                            }
                            
                            
                        }else if([obj.sort isEqualToString:@"4"]&&[obj.type isEqualToString:@"first"])
                        {
                            //论坛帖子转发为微博
                            NSDictionary * newsForwoadjson= [[value objectForKey:FB_CONTENT] objectFromJSONString];
                            
                            FbNewsFeed * fbnews= [[FbNewsFeed alloc] initWithJson:newsForwoadjson];
                            
                            [obj setFbNews:fbnews];
                            
                            [obj setContent:[NSString stringWithFormat:@"转发论坛帖子<a href=\"fb://tieziDetail/%@/%@/%@/%@\">%@</a>:%@",fbnews.bbsid,fbnews.bbsid,@"999",@"999",fbnews.title,fbnews.content]];
                            
                            
                            NSLog(@"tid --  %@  --  content ---  %@",obj.tid,obj.content);
                            
                            
                            [obj setImageFlg:fbnews.photoFlg];
                            
                            if (fbnews.photoFlg)
                            {
                                [obj setImage_small_url_m:fbnews.photo];// [NSString stringWithFormat:@"http://bbs.fblife.com/attachments/%@",fbnews.photo]];
                                [obj setImage_original_url_m:fbnews.photo];// [NSString stringWithFormat:@"http://bbs.fblife.com/attachments/%@",fbnews.photo]];
                            }
                        }else if([obj.sort isEqualToString:@"5"]&&[obj.type isEqualToString:@"first"])
                        {
                            //论坛分享
                            NSDictionary *newsSendjson= [[value objectForKey:FB_EXTENSION] objectFromJSONString];
                            Extension * ex=[[Extension alloc] initWithJson:newsSendjson];
                            [obj setExten:ex];
                            [obj setRootFlg:YES];
                            NSLog(@"论坛分享的内容 -----  %@",ex.forum_content);
                            [obj setRcontent:  [NSString stringWithFormat:@"%@:<a href=\"fb://BlogDetail/%@\">%@</a>:%@",ex.author,ex.authorid,ex.title,ex.forum_content]];
                            [obj setRsort:@"5"];
                            [obj setRsortId:ex.authorid];
                            [obj setRimageFlg:ex.photoFlg];
                            [obj setRimage_small_url_m:ex.photo];
                            [obj setRimage_original_url_m:ex.photo];
                        }else if ([obj.sort isEqualToString:@"8"]&&[obj.type isEqualToString:@"first"])
                        {
                            NSDictionary *exjson= [[value objectForKey:FB_EXTENSION] objectFromJSONString];
                            Extension * ex=[[Extension alloc]initWithJson:exjson];
                            [obj setExten:ex];
                            [obj setContent:[NSString stringWithFormat:@"分享新闻<a href=\"fb://PhotoDetail/%@\">%@</a>:%@",ex.authorid,ex.title,obj.content]];
                        }else if([obj.sort isEqualToString:@"10"]&&[obj.type isEqualToString:@"first"])
                        {
                            //资源分享
                            NSDictionary *newsSendjson= [[value objectForKey:FB_EXTENSION] objectFromJSONString];
                            Extension * ex=[[Extension alloc] initWithJson:newsSendjson];
                            [obj setExten:ex];
                            [obj setRootFlg:YES];
                            NSLog(@"论坛分享的内容 -----  %@",ex.forum_content);
                            [obj setRcontent:[zsnApi ShareResourceContent:ex.forum_content]];
                            [obj setRsort:@"10"];
                            [obj setRsortId:ex.authorid];
                            [obj setRimageFlg:ex.photoFlg];
                            [obj setRimage_small_url_m:ex.photo];
                            [obj setRimage_original_url_m:ex.photo];
                        }
                        
                        
                        
                        while ([obj.content rangeOfString:@"&nbsp;"].length)
                        {
                            obj.content = [obj.content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
                        }
                        
                        
                        
                        NSMutableString * tempString = [NSMutableString stringWithFormat:@"%@",obj.content];
                        
                        if ([tempString rangeOfString:@"<a>#"].length)
                        {
                            NSString * insertString = [NSString stringWithFormat:@" href=\"fb://BlogDetail/%@\"",obj.tid];
                            [tempString insertString:insertString atIndex:[obj.content rangeOfString:@"<a>#"].location+2];
                            obj.content = [NSString stringWithString:tempString];
                        }
                        
                        while ([obj.content rangeOfString:@"<a id="].length)
                        {
                            obj.content = [zsnApi exchangeString:obj.content];
                        }
                        
                        //解析转发内容
                        if (![[value objectForKey:@"roottid"] isEqualToString:@"0"] )
                        {
                            [obj setRootFlg:YES];
                            
                            NSDictionary * followinfo= [value objectForKey:@"followinfo"];
                            
                            if (followinfo==nil)
                            {
                                //原微博已删除
                                [obj setRcontent:NS_WEIBO_DEL];
                            }else
                            {
                                //解析转发的微博内容
                                [obj setRtid:[followinfo objectForKey:FB_TID]];
                                [obj setRuid:[followinfo objectForKey:FB_UID]];
                                [obj setRuserName:[followinfo objectForKey:FB_USERNAME]];
                                
                                [obj setRcontent:[ NSString stringWithFormat:@"<a href=\"fb://atSomeone@/\">@%@</a>:%@",obj.ruserName,[zsnApi imgreplace:[followinfo objectForKey:FB_CONTENT]]]];
                                
                                if ([[followinfo objectForKey:FB_IMAGEID] isEqualToString:@"0"])
                                {
                                    [obj setRNsImageFlg:@"0"];
                                }else
                                {
                                    [obj setRNsImageFlg:@"1"];
                                }
                                
                                
                                obj.rimage_original_url_m = [followinfo objectForKey:@"image_original_m"];
                                
                                obj.rimage_small_url_m = [followinfo objectForKey:@"image_small_m"];
                                
                                
                                if ([obj rimageFlg])
                                {
                                    [obj setRimage_original_url:[followinfo objectForKey:FB_IMAGE_ORIGINAL]];
                                    [obj setRimage_small_url:[followinfo objectForKey:FB_IMAGE_SMALL]];
                                }
                                [obj setRfrom:[followinfo objectForKey:FB_FROM]];
                                [obj setRNsType:[followinfo objectForKey:FB_TYPE]];
                                obj.rsort = [followinfo objectForKey:FB_SORT];
                                obj.rsortId = [followinfo objectForKey:FB_SORTID];
                                [obj setRjing_lng:[followinfo objectForKey:FB_JING_LNG]];
                                [obj setRwei_lat:[followinfo objectForKey:FB_WEI_LAT]];
                                [obj setRlocality:[followinfo objectForKey:FB_LOCALITY]];
                                [obj setRface_original_url:[followinfo objectForKey:FB_FACE_ORIGINAL]];
                                [obj setRface_small_url:[followinfo objectForKey:FB_FACE_SMALL]];
                                [obj setRNsRootFlg:[followinfo objectForKey:FB_ROOTTID]];
                                [obj setRdateline:[followinfo objectForKey:FB_DATELINE]];
                                [obj setRreplys:[followinfo objectForKey:FB_REPLYS]];
                                [obj setRforwards:[followinfo objectForKey:FB_FORWARDS]];
                                //解析其他类型
                                if ([obj.rsort isEqualToString:@"6"]&&[obj.rtype isEqualToString:@"first"])
                                {
                                    //解析新闻评论
                                    NSDictionary *exjson= [[followinfo objectForKey:FB_EXTENSION] objectFromJSONString];
                                    Extension * ex=[[Extension alloc]initWithJson:exjson];
                                    [obj setRexten:ex];
                                    [obj setRcontent:[NSString stringWithFormat:@"<a href=\"fb://atSomeone@/\">@%@</a>:我对新闻<a href=\"fb://PhotoDetail/%@\">%@</a>发表了评论:%@",obj.ruserName,obj.ruserName,ex.title,obj.rcontent]];
                                }else if([obj.rsort isEqualToString:@"3"]&&[obj.rtype isEqualToString:@"first"])
                                {
                                    //解析图集
                                    NSDictionary *photojson= [[followinfo objectForKey:FB_CONTENT] objectFromJSONString];
                                    PhotoFeed * photo=[[PhotoFeed alloc]initWithJson:photojson];
                                    [obj setRphoto:photo];
                                    [obj setRcontent:[NSString stringWithFormat:@"<a href=\"fb://atSomeone@/\">@%@</a>:我在图集<a href=\"fb://PhotoDetail/%@\">%@</a>上传了新图片",obj.ruserName,photo.aid,photo.title]];
                                    [obj setRimageFlg:YES];
                                    [obj setRimage_small_url_m: [photo.image objectAtIndex:0]];
                                    [obj setRimage_original_url_m:[photo.image objectAtIndex:0]];
                                }else if([obj.rsort isEqualToString:@"2"]&&[obj.rtype isEqualToString:@"first"])
                                {
                                    //解析文集
                                    NSDictionary *blogjson= [[followinfo objectForKey:FB_CONTENT] objectFromJSONString];
                                    BlogFeed * blog=[[BlogFeed alloc]initWithJson:blogjson];
                                    [obj setRblog:blog];
                                    [obj setRcontent:[NSString stringWithFormat:@"<a href=\"fb://atSomeone@/\">@%@</a>:我发表文集<a href=\"fb://BlogDetail/%@\">%@</a>:%@",obj.ruserName,blog.blogid,blog.title,blog.content]];
                                    [obj setRimageFlg:blog.photoFlg];
                                    if (blog.photoFlg) {
                                        [obj setRimage_small_url_m:blog.photo];
                                        [obj setRimage_original_url_m:blog.photo];
                                    }
                                }else if([obj.rsort isEqualToString:@"4"]&&[obj.rtype isEqualToString:@"first"])
                                {
                                    //论坛帖子转发为微博
                                    NSDictionary *newsForwoadjson= [[followinfo objectForKey:FB_CONTENT] objectFromJSONString];
                                    FbNewsFeed * fbnews=[[FbNewsFeed alloc]initWithJson:newsForwoadjson];
                                    [obj setRfbNews:fbnews];
                                    [obj setRcontent:[NSString stringWithFormat:@"<a href=\"fb://atSomeone@/\">@%@</a>:转发论坛帖子<a href=\"fb://tieziDetail/%@/%@/%@/%@/%@\">%@</a>:%@",obj.ruserName,fbnews.bbsid,   [fbnews.title stringByAddingPercentEscapesUsingEncoding:  NSUTF8StringEncoding],fbnews.bbsid,@"999",@"999",fbnews.title,fbnews.content]];
                                    
                                    [obj setRimageFlg:fbnews.photoFlg];
                                    if (fbnews.photoFlg) {
                                        
                                        [obj setRimage_small_url_m:fbnews.photo];//[NSString stringWithFormat:@"http://bbs.fblife.com/attachments/%@",fbnews.photo]];
                                        
                                        [obj setRimage_original_url_m:fbnews.photo];//[NSString stringWithFormat:@"http://bbs.fblife.com/attachments/%@",fbnews.photo]];
                                    }
                                }else if([obj.rsort isEqualToString:@"5"]&&[obj.rtype isEqualToString:@"first"])
                                {
                                    //论坛分享
                                    
                                    NSDictionary *newsSendjson= [[followinfo objectForKey:FB_EXTENSION] objectFromJSONString];
                                    Extension * ex=[[Extension alloc]initWithJson:newsSendjson];
                                    [obj setRexten:ex];
                                    [obj setRcontent:  [NSString stringWithFormat:@"%@ %@:<a>%@</a>:%@",obj.rcontent,ex.author, ex.title,ex.forum_content]];
                                    [obj setRimageFlg:ex.photoFlg];
                                    [obj setRimage_small_url_m:ex.photo];
                                    [obj setRimage_original_url_m:ex.photo];
                                }else if ([obj.rsort isEqualToString:@"8"]&&[obj.rtype isEqualToString:@"first"])
                                {
                                    NSDictionary *exjson= [[followinfo objectForKey:FB_EXTENSION] objectFromJSONString];
                                    Extension * ex=[[Extension alloc]initWithJson:exjson];
                                    [obj setExten:ex];
                                    [obj setContent:[NSString stringWithFormat:@"分享新闻<a href=\"fb://PhotoDetail/%@\">%@</a>:%@",ex.authorid,ex.title,obj.content]];
                                }else if([obj.rsort isEqualToString:@"10"]&&[obj.rtype isEqualToString:@"first"])
                                {
                                    //资源分享
                                    NSDictionary *newsSendjson= [[followinfo objectForKey:FB_EXTENSION] objectFromJSONString];
                                    Extension * ex=[[Extension alloc] initWithJson:newsSendjson];
                                    [obj setExten:ex];
                                    [obj setRootFlg:YES];
                                    NSLog(@"论坛分享的内容 -----  %@",ex.forum_content);
                                    [obj setRcontent:[zsnApi ShareResourceContent:ex.forum_content]];
                                    [obj setRsort:@"10"];
                                    [obj setRsortId:ex.authorid];
                                    [obj setRimageFlg:ex.photoFlg];
                                    [obj setRimage_small_url_m:ex.photo];
                                    [obj setRimage_original_url_m:ex.photo];
                                }
                            }
                        }
                        
                        while ([obj.rcontent rangeOfString:@"&nbsp;"].length)
                        {
                            obj.rcontent = [obj.rcontent stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
                        }
                        
                        NSMutableString * RtempString = [NSMutableString stringWithFormat:@"%@",obj.rcontent];
                        
                        if ([RtempString rangeOfString:@"<a>#"].length)
                        {
                            NSString * insertString = [NSString stringWithFormat:@" href=\"fb://BlogDetail/%@\"",obj.rtid];
                            [RtempString insertString:insertString atIndex:[obj.rcontent rangeOfString:@"<a>#"].location+2];
                            obj.rcontent = [NSString stringWithString:RtempString];
                        }
                        
                        
                        NSLog(@"rrrrrrrrrr -----  %@",obj.rcontent);
                        
                        while ([obj.rcontent rangeOfString:@"<a id="].length)
                        {
                            obj.rcontent = [zsnApi exchangeString:obj.rcontent];
                        }
                        
                        detail.info=obj;
                        
                        NSLog(@"fbno==detail.info.tid=%@",detail.info.tid);
                        [self.navigationController pushViewController:detail animated:YES];
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
             
             
             */
            
            
            NewWeiBoDetailViewController * detail = [[NewWeiBoDetailViewController alloc] init];
            detail.tid = string_tid;
            detail.hidesBottomBarWhenPushed = YES;
            [((UIViewController*)_delegate).navigationController pushViewController:detail animated:YES];
        }
    }
}



#pragma mark - 下拉上拉代理方法
-(void)loadMoreData
{
    if (isUReadOver)
    {
        read_page++;
        [self loadFBReadNotificationWithHud:nil];
    }else
    {
        uread_page++;
        [self getNotificationData];
    }
}

-(void)loadNewData
{
    read_page = 1;
    uread_page = 1;
    [self getNotificationData];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (_aType == NotificationViewTypeBBS)
    {
        NotificationBBSModel * model = [bbs_array objectAtIndex:indexPath.row];
        bbsdetailViewController * detail = [[bbsdetailViewController alloc] init];
        detail.bbsdetail_tid = model.tid;
        detail.hidesBottomBarWhenPushed = YES;
        [((UIViewController*)_delegate).navigationController pushViewController:detail animated:YES];
    }else
    {
        NotificationFBModel * model;
        
        if (indexPath.section == 0)
        {
            if (uread_array.count>0)
            {
                model=[uread_array objectAtIndex:indexPath.row];
            }else
            {
                model=[read_array objectAtIndex:indexPath.row];
            }
        }else
        {
            model=[read_array objectAtIndex:indexPath.row];
        }
        
        int type=[model.fb_oatype intValue];
        NSString *string_tid=model.fb_actid;
        
        if (type==2 || type==7)
        {//文集
            
            WenJiViewController * wenji = [[WenJiViewController alloc] init];
            wenji.bId = string_tid;
            wenji.hidesBottomBarWhenPushed = YES;
            [((UIViewController*)_delegate).navigationController pushViewController:wenji animated:YES];
            
        }else if (type==3)
        {//画廊
            
            ImagesViewController * images = [[ImagesViewController alloc] init];
            images.tid = string_tid;
            images.hidesBottomBarWhenPushed = YES;
            [((UIViewController*)_delegate).navigationController pushViewController:images animated:YES];
        }else if (type==9)
        {//加好友
            NewMineViewController * people = [[NewMineViewController alloc] init];
            people.uid = string_tid;
            [((UIViewController*)_delegate).navigationController pushViewController:people animated:YES];
        }else if (type==4||type==5)
        {//微博
            NewWeiBoDetailViewController * detail = [[NewWeiBoDetailViewController alloc] init];
            detail.tid = string_tid;
            detail.hidesBottomBarWhenPushed = YES;
            [((UIViewController*)_delegate).navigationController pushViewController:detail animated:YES];
        }
    }
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    if (_aType==NotificationViewTypeFB)
    {
        NotificationFBModel * model;
        
        if (indexPath.section==0)
        {
            if (uread_array.count>0)
            {
                model=[uread_array objectAtIndex:indexPath.row];
            }else
            {
                model=[read_array objectAtIndex:indexPath.row];
            }
        }
        if (indexPath.section==1)
        {
            model=[read_array objectAtIndex:indexPath.row];
            
        }
        CGSize constraintSize = CGSizeMake(220, MAXFLOAT);
        CGSize labelSize = [model.fb_content sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        
        if (read_array.count > 0 && uread_array.count > 0)
        {
            
            if (indexPath.section == 0)
            {
                return labelSize.height+60;
            }else
            {
                return labelSize.height+50;
            }
        }else
        {
            return labelSize.height+50;
        }
    }else{
        
        NotificationBBSModel * model =[bbs_array objectAtIndex:indexPath.row];
        CGSize constraintSize = CGSizeMake(220, MAXFLOAT);
        CGSize labelSize = [model.message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        
        return labelSize.height+60;
    }
    
    
    
}
- (UIView *)viewForHeaderInSection:(NSInteger)section
{
    if (_aType==NotificationViewTypeBBS) {
        return nil;
    }else
    {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 24)];
        label.backgroundColor=RGBCOLOR(240, 240, 240);
        [label setFont:[UIFont systemFontOfSize:15]];
        
        label.textColor=[UIColor blackColor];
        
        if (section == 0)
        {
            if (uread_array.count > 0)
            {
                label.text= @"  未读通知";
            }else
            {
                label.text= @"  已读通知";
            }
        }else
        {
            label.text= @"  已读通知";
        }
        
        return label;
    }
}
- (CGFloat)heightForHeaderInSection:(NSInteger)section
{
    if (_aType==NotificationViewTypeBBS) {
        return 0;
    }else{
        return 24;
    }
}




-(void)dealloc
{
    [bbs_array removeAllObjects];
    bbs_array = nil;
    [uread_array removeAllObjects];
    uread_array = nil;
    [read_array removeAllObjects];
    read_array = nil;
    
    [request_tools cancelRequest];
    request_tools = nil;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
