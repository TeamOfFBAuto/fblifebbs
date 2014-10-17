//
//  FriendCircleViewController.m
//  fblifebbs
//
//  Created by soulnear on 14-10-17.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FriendCircleViewController.h"
#import "FbFeed.h"
#import "NewWeiBoCustomCell.h"
#import "WriteBlogViewController.h"
#import "NewWeiBoDetailViewController.h"
#import "ForwardingViewController.h"
#import "NewWeiBoCommentViewController.h"
#import "fbWebViewController.h"
#import "NewMineViewController.h"
#import "MWPhotoBrowser.h"
#import "MWPhoto.h"
#import "ShowImagesViewController.h"

@interface FriendCircleViewController ()<RefreshDelegate,UITableViewDataSource,NewWeiBoCustomCellDelegate,ForwardingViewControllerDelegate,NewWeiBoCommentViewControllerDelegate,MWPhotoBrowserDelegate>
{
    ///视图
    RefreshTableView * myTableView;
    ///数据容器
    NSMutableArray * data_array;
    ///数据请求
    ASIHTTPRequest * weiBo_request;
    ///计算cell高度
    NewWeiBoCustomCell * test_cell;
    
    MBProgressHUD * hud;
}

@end

@implementation FriendCircleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    data_array = [NSMutableArray array];
    _photos = [NSMutableArray array];
    
    self.title = @"好友动态";
    
    self.rightImageName = @"default_write_pen_image.png";
    
    [self setSNViewControllerLeftButtonType:SNViewControllerLeftbuttonTypeBack WithRightButtonType:SNViewControllerRightbuttonTypeOther];
    
    myTableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT-64) showLoadMore:YES];
    myTableView.dataSource = self;
    myTableView.refreshDelegate = self;
    if (MY_MACRO_NAME) {
        myTableView.separatorInset = UIEdgeInsetsZero;
    }
    [self.view addSubview:myTableView];
    
    hud = [zsnApi showMBProgressWithText:@"正在加载..." addToView:self.view];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    [self initHttpRequest];
}

#pragma mark - 右边按钮
-(void)rightButtonTap:(UIButton *)sender
{
    WriteBlogViewController * writeVC = [[WriteBlogViewController alloc] init];
    [self presentViewController:writeVC animated:YES completion:NULL];
}

//请求数据
-(void)initHttpRequest
{
    if (weiBo_request)
    {
        [weiBo_request cancel];
        weiBo_request.delegate = nil;
        weiBo_request = nil;
    }
    NSString* fullURL = [NSString stringWithFormat:FB_WEIBOMYSELF_URL,[personal getMyAuthkey],myTableView.pageNum];

    NSLog(@"请求微博url---%@",fullURL);
    
    weiBo_request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fullURL]];
    [weiBo_request setPersistentConnectionTimeoutSeconds:120];
    [weiBo_request startAsynchronous];
    
    __weak typeof(weiBo_request)wRequest = weiBo_request;
    
    [wRequest setCompletionBlock:^{
        @try
        {
            [hud hide:YES];
            NSDictionary * rootObject = [[NSDictionary alloc] initWithDictionary:[weiBo_request.responseData objectFromJSONData]];
            NSString *errcode =[NSString stringWithFormat:@"%@",[rootObject objectForKey:ERRCODE]];
        
            if ([@"0" isEqualToString:errcode])
            {
                NSDictionary* userinfo = [rootObject objectForKey:@"weiboinfo"];
                if (myTableView.pageNum != 1)
                {
                    if ([userinfo isEqual:[NSNull null]])
                    {
                        myTableView.isHaveMoreData = NO;
                        [myTableView finishReloadigData];
                        return;
                    }
                }else
                {
                    [FbFeed deleteAllByType:0];
                    [data_array removeAllObjects];
                }
                
                if ([userinfo isEqual:[NSNull null]])
                {
                    //如果没有微博的话
                    myTableView.isHaveMoreData = NO;
                    [myTableView finishReloadigData];
                    return;
                }else
                {
                    NSMutableArray * temp_array = [zsnApi conversionFBContent:userinfo isSave:YES WithType:0];
                    [data_array addObjectsFromArray:temp_array];
                    myTableView.isHaveMoreData = YES;
                    [myTableView finishReloadigData];
                }
            }
        }
        @catch (NSException *exception)
        {
            
        }
        @finally
        {
            
        }

    }];
    
    [wRequest setFailedBlock:^{
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"加载失败";
        [hud hide:YES afterDelay:1.5];
    }];
}




#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data_array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    
    NewWeiBoCustomCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[NewWeiBoCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.delegate = self;
    }
    
    
    FbFeed * info = [data_array objectAtIndex:indexPath.row];
    
    [cell setAllViewWithType:0];
    
    [cell setInfo:info withReplysHeight:[tableView rectForRowAtIndexPath:indexPath].size.height WithType:0];
    
    return cell;
}

#pragma mark - 刷新加载代理
-(void)loadMoreData
{
    [self initHttpRequest];
}

- (void)loadNewData
{
    [self initHttpRequest];
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    if (!test_cell)
    {
        test_cell = [[NewWeiBoCustomCell alloc] init];
    }
    
    float cellHeight = 0;
    FbFeed * info = [data_array objectAtIndex:indexPath.row];
    cellHeight = [test_cell returnCellHeightWith:info WithType:0] + 20;
    return cellHeight;
}
- (UIView *)viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


#pragma mark-NewWeiBoCustomCellDelegate

-(void)showOriginalWeiBoContent:(NSString *)theTid
{
    NSString *authkey=[[NSUserDefaults standardUserDefaults] objectForKey:USER_AUTHOD];
    NSString * fullURL= [NSString stringWithFormat:@"http://fb.fblife.com/openapi/index.php?mod=getweibo&code=content&tid=%@&fromtype=b5eeec0b&authkey=%@&page=1&fbtype=json",theTid,authkey];
    
    NSLog(@"1请求的url = %@",fullURL);
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullURL]];
    
    __block ASIHTTPRequest * _requset = request;
    
    _requset.delegate = self;
    
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
    NSIndexPath * theIndexpath = [myTableView indexPathForCell:theCell];
    
    ForwardingViewController * forward = [[ForwardingViewController alloc] init];
    forward.info = info;
    forward.delegate = self;
    forward.theIndexPath = theIndexpath.row;
    forward.theSelectViewIndex = 0;
    [self presentViewController:forward animated:YES completion:NULL];
}

-(void)presentToCommentControllerWithInfo:(FbFeed *)info WithCell:(NewWeiBoCustomCell *)theCell
{
    NSIndexPath * theIndexpath = [myTableView indexPathForCell:theCell];
    
    NewWeiBoCommentViewController * forward = [[NewWeiBoCommentViewController alloc] init];
    forward.info = info;
    forward.delegate = self;
    forward.tid = info.tid;
    forward.theIndexPath = theIndexpath.row;
    forward.theSelectViewIndex = 0;
    [self presentViewController:forward animated:YES completion:NULL];
}


-(void)showVideoWithUrl:(NSString *)theUrl
{
    fbWebViewController * web = [[fbWebViewController alloc] init];
    web.urlstring = theUrl;
    [self PushControllerWith:web WithAnimation:YES];
}


-(void)clickHeadImage:(NSString *)uid
{
    NewMineViewController * mine = [[NewMineViewController alloc] init];
    mine.uid = uid;
    [self PushControllerWith:mine WithAnimation:YES];
}


-(void)clickUrlToShowWeiBoDetailWithInfo:(FbFeed *)info WithUrl:(NSString *)theUrl isRe:(BOOL)isRe
{
    NSString * string = isRe?info.rsort:info.sort;
    
    NSString * sortId = isRe?info.rsortId:info.sortId;
    
    NSLog(@"我艹 ------  %@ ---  %d",sortId,isRe);
    
    
    if ([string intValue] == 7 || [string intValue] == 6 || [string intValue] == 8)//新闻
    {
        newsdetailViewController * news = [[newsdetailViewController alloc] initWithID:sortId];
        [self PushControllerWith:news WithAnimation:YES];
        
    }else if ([string intValue] == 4 || [string intValue] == 5)//帖子
    {
        bbsdetailViewController * bbs = [[bbsdetailViewController alloc] init];
        bbs.bbsdetail_tid = sortId;
        if ([string intValue] == 5)
        {
            bbs.bbsdetail_tid = info.sortId;
        }
        [self PushControllerWith:bbs WithAnimation:YES];
    }else if ([string intValue] == 3)
    {
        ImagesViewController * images = [[ImagesViewController alloc] init];
        images.tid = isRe?info.rphoto.aid:info.photo.aid;
        
        [self PushControllerWith:images WithAnimation:YES];
     
    }else if ([string intValue] == 2)
    {
        WenJiViewController * wenji = [[WenJiViewController alloc] init];
        wenji.bId = sortId;
        [self PushControllerWith:wenji WithAnimation:YES];
    }else if ([string intValue] ==15)
    {//跳到新版图集界面
        ShowImagesViewController * imageV = [[ShowImagesViewController alloc] init];
        imageV.id_atlas = sortId;
        [self PushControllerWith:imageV WithAnimation:YES];
    }else
    {
        NewWeiBoDetailViewController * detail = [[NewWeiBoDetailViewController alloc] init];
        detail.info = info;
        [self PushControllerWith:detail WithAnimation:YES];
    }
}

-(void)showClickUrl:(NSString *)theUrl WithFBFeed:(FbFeed *)info;
{
    fbWebViewController *fbweb=[[fbWebViewController alloc]init];
    fbweb.urlstring = theUrl;
    [self PushControllerWith:fbweb WithAnimation:YES];
}

-(void)showAtSomeBody:(NSString *)theUrl WithFBFeed:(FbFeed *)info
{
    NSLog(@"theUrl ------   %@",theUrl);
    NewMineViewController * people = [[NewMineViewController alloc] init];
    if ([theUrl rangeOfString:@"fb://PhotoDetail/id="].length)
    {
        people.uid = [theUrl stringByReplacingOccurrencesOfString:@"fb://PhotoDetail/id=" withString:@""];
    }else if([theUrl rangeOfString:@"fb://atSomeone@/"].length)
    {
        people.uid = [theUrl stringByReplacingOccurrencesOfString:@"fb://atSomeone@/" withString:@""];
    }else
    {
        people.uid = info.ruid;
    }
    
    [self PushControllerWith:people WithAnimation:YES];
}

-(void)showImage:(FbFeed *)info isReply:(BOOL)isRe WithIndex:(int)index
{
    NSString * sort = isRe?info.rsort:info.sort;
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
    browser.title_string = titleString;
    [browser setInitialPageIndex:index];
    [self presentViewController:browser animated:YES completion:nil];
}

#pragma mark-评论转发成功

-(void)ForwardingSuccessWihtTid:(NSString *)theTid IndexPath:(int)theIndexpath SelectView:(int)theselectview WithComment:(BOOL)isComment
{
    FbFeed * _feed = [data_array objectAtIndex:theIndexpath];
    
    _feed.forwards = [NSString stringWithFormat:@"%d",[_feed.forwards intValue]+1];
    
    if (isComment)
    {
        _feed.replys = [NSString stringWithFormat:@"%d",[_feed.replys intValue]+1];
        
        [FbFeed updateReplys:_feed.replys WithTid:theTid];
    }
    
    [data_array replaceObjectAtIndex:theIndexpath withObject:_feed];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:theIndexpath inSection:0];
    
    NewWeiBoCustomCell * cell = (NewWeiBoCustomCell *)[myTableView cellForRowAtIndexPath:indexPath];
    
    [cell setReplys:_feed.replys ForWards:_feed.forwards];
    
    [FbFeed updateForwards:_feed.forwards WithTid:theTid];
    
}

-(void)commentSuccessWihtTid:(NSString *)theTid IndexPath:(int)theIndexpath SelectView:(int)theselectview withForward:(BOOL)isForward
{
    FbFeed * _feed = [data_array objectAtIndex:theIndexpath];
        
    _feed.replys = [NSString stringWithFormat:@"%d",[_feed.replys intValue]+1];
    
    if (isForward)
    {
        _feed.forwards = [NSString stringWithFormat:@"%d",[_feed.forwards intValue]+1];
        
        [FbFeed updateForwards:_feed.forwards WithTid:theTid];
    }
    
    [data_array replaceObjectAtIndex:theIndexpath withObject:_feed];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:theIndexpath inSection:0];
    NewWeiBoCustomCell * cell = (NewWeiBoCustomCell *)[myTableView cellForRowAtIndexPath:indexPath];
    [cell setReplys:_feed.replys ForWards:_feed.forwards];
    [FbFeed updateReplys:_feed.replys WithTid:theTid];
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




#pragma mark - dealloc
-(void)dealloc
{
    [data_array removeAllObjects];
    data_array = nil;
    
    [weiBo_request cancel];
    weiBo_request = nil;
    
    test_cell = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
