//
//  RecommendView.m
//  fblifebbs
//
//  Created by soulnear on 14-12-30.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "RecommendView.h"
#import "AFHTTPRequestOperation.h"
#import "SGFocusImageItem.h"
#import "NewMainViewModel.h"
#import "CompreTableViewCell.h"
#import "BBSfenduiViewController.h"
#import "bbsdetailViewController.h"
#import "newsdetailViewController.h"
#import "fbWebViewController.h"

@implementation RecommendView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        [self setup];
        
    }
    
    return self;
}

-(void)setup
{
    
    _data_array = [NSMutableArray array];
    
    _mainTabView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,self.height) showLoadMore:YES];
    _mainTabView.dataSource = self;
    _mainTabView.refreshDelegate = self;
    [self addSubview:_mainTabView];
    
    [self loadHuandeng];
    
    [self loadLuntanJingXuanData];
    
    hud = [zsnApi showMBProgressWithText:@"正在加载..." addToView:self];
}


#pragma mark - 获取论坛精选数据

#pragma mark - 获取精选推荐幻灯数据
-(void)loadHuandeng{
    
    __weak typeof(self) wself =self;
    
    AFHTTPRequestOperation * request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:GET_BBS_SLIDESHOW_URL]]];
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try
        {
            NSDictionary * dicinfo = [operation.responseString objectFromJSONString];
        
            NSLog(@"新版幻灯的数据dicinfo===%@",dicinfo);
            
            int errcode = [[dicinfo objectForKey:@"errno"] intValue];
            if (errcode==0) {
                
                [wself refreshHuandengWithDic:dicinfo];
                
            }else{
                //网络有问题
                
                if (isHaveNetWork) {
                    sleep(0.3);
                    
                    [wself loadHuandeng];
                }
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [request start];
}

#pragma mark - 创建幻灯视图
-(void)refreshHuandengWithDic:(NSDictionary *)dic{
    
    huandengDic=[NSDictionary dictionary];
    huandengDic=dic;

    _mainTabView.tableHeaderView= [self getHeaderViewWithDic:huandengDic] ;
 
}
-(UIView *)getHeaderViewWithDic:(NSDictionary*)headerDic {
    
    
    
    NSLog(@"最新的幻灯的数据===%@",huandengDic);
    
    
    /**
     *   id = 119049;
     link = "http://drive.fblife.com/html/20140722/119049.html";
     photo = "http://cmsweb.fblife.com/attachments/20140722/14060219878454.gif";
     stitle = "2015\U6b3e\U798f\U7279\U5f81\U670d\U8005\U524d\U77bb";
     title = "\U7f8e\U5f0f\U5168\U5c3a\U5bf8SUV 2015\U6b3e\U798f\U7279\U5f81\U670d\U8005\U524d\U77bb";
     type = 1;
     
     */
    
    
    com_id_array=[NSMutableArray array];
    com_link_array=[NSMutableArray array];
    com_type_array=[NSMutableArray array];
    com_title_array=[NSMutableArray array];
    
    
    
    self.commentarray=[NSMutableArray arrayWithArray:[headerDic objectForKey:@"news"]];
    
    if (self.commentarray.count>0) {
        NSMutableArray *imgarray=[NSMutableArray array];
        
        for ( int i=0; i<[self.commentarray count]; i++) {
            
            NSDictionary *dic_ofcomment=[self.commentarray objectAtIndex:i];
            NSString *strimg=[dic_ofcomment objectForKey:@"photo"];
            [imgarray addObject:strimg];
            
            
            NSString *str_rec_title=[dic_ofcomment objectForKey:@"title"];
            [com_title_array addObject:str_rec_title];
            /*           id = 82920;
             link = "http://drive.fblife.com/html/20131226/82920.html";
             photo = "http://cmsweb.fblife.com/attachments/20131226/1388027183.jpg";
             title = "\U57ce\U5e02\U8de8\U754c\U5148\U950b \U6807\U81f42008\U8bd5\U9a7e\U4f53\U9a8c";
             type = 1;*/
            
            NSString *str_link=[dic_ofcomment objectForKey:@"link"];
            [com_link_array addObject:str_link];
            NSString *str_type=[dic_ofcomment objectForKey:@"type"];
            [com_type_array addObject:str_type];
            NSString *str__id=[dic_ofcomment objectForKey:@"id"];
            [com_id_array addObject:str__id];
            
            
        }
        int length = self.commentarray.count;
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 0 ; i < length; i++)
        {
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSString stringWithFormat:@"%@",[com_title_array objectAtIndex:i]],@"title" ,
                                  [NSString stringWithFormat:@"%@",[imgarray objectAtIndex:i]],@"image",[NSString stringWithFormat:@"%@",[com_link_array objectAtIndex:i]],@"link",
                                  [NSString stringWithFormat:@"%@",[com_type_array objectAtIndex:i]],@"type",[NSString stringWithFormat:@"%@",[com_id_array objectAtIndex:i]],@"idoftype",nil];
            [tempArray addObject:dict];
        }
        
        NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
        if (length > 1)
        {
            NSDictionary *dict = [tempArray objectAtIndex:length-1];
            SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:-1] ;
            [itemArray addObject:item];
        }
        for (int i = 0; i < length; i++)
        {
            NSDictionary *dict = [tempArray objectAtIndex:i];
            SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:i] ;
            [itemArray addObject:item];
            
        }
        //添加第一张图 用于循环
        if (length >1)
        {
            NSDictionary *dict = [tempArray objectAtIndex:0];
            SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:length];
            [itemArray addObject:item];
        }
        bannerView = [[NewHuandengView alloc] initWithFrame:CGRectMake(0, 64, DEVICE_WIDTH, (191+13)*DEVICE_WIDTH/320) delegate:self imageItems:itemArray isAuto:YES];
        [bannerView scrollToIndex:0];
        
        
        
    }
    
    UIView *HeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,DEVICE_WIDTH, (191+13)*DEVICE_WIDTH/320+64)];
    HeaderView.backgroundColor=[UIColor whiteColor];
    [HeaderView addSubview:bannerView];
    
    return bannerView;
    
}

- (void)testfoucusImageFrame:(NewHuandengView *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    NSLog(@"%s \n click===>%@",__FUNCTION__,item.title);
    if (com_id_array.count>0) {
        
        int type;
        NSString *string_link_;
        @try {
            type=[item.type intValue];
            NSLog(@"item.type====%d",type);
            string_link_=item.link;
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
            return;
            
        }@finally {
            switch (type) {
                                        
                case 1:
                {
                    NSLog(@"到新闻的");
                    
                    newsdetailViewController *_newsdetailVC=[[newsdetailViewController alloc]initWithID:item.idoftype];
                    [self PushToVCWith:_newsdetailVC];
                }
                    break;
                    
                case 2:{
                    NSLog(@"到论坛的");
                    bbsdetailViewController *_detaibbslVC=[[bbsdetailViewController alloc]init];
                    _detaibbslVC.bbsdetail_tid=item.idoftype;
                    [self PushToVCWith:_detaibbslVC];
                }
                    break;
                case 3:{
                    
                    fbWebViewController *_fbVc=[[fbWebViewController alloc]init];
                    _fbVc.urlstring=item.link;
                    [self PushToVCWith:_fbVc];
                    NSLog(@"外链的");
                }
                    
                default:
                    break;
            }
        } 
    }
}
- (void)testfoucusImageFrame:(NewHuandengView *)imageFrame currentItem:(int)index
{
    
}


#pragma mark - 获取数据
#pragma mark - 请求论坛精选数据

-(void)loadLuntanJingXuanData
{
    
    NSString * fullUrl = [NSString stringWithFormat:BBS_JINGXUAN_URL,_mainTabView.pageNum];
    NSLog(@"论坛精选接口 -----   %@",fullUrl);
    ASIHTTPRequest * jingxuan_request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullUrl]];
    
    __block typeof(jingxuan_request) request = jingxuan_request;
    
    __weak typeof(self) bself = self;
    
    [request setCompletionBlock:^{
        [hud hide:YES];
        @try
        {
            NSDictionary * allDic = [jingxuan_request.responseString objectFromJSONString];
            
            if ([[allDic objectForKey:@"errno"] intValue] == 0)
            {
                if (bself.mainTabView.pageNum == 1) {
                    [bself.data_array removeAllObjects];
                }
                
                if (bself.data_array.count >= [[allDic objectForKey:@"pages"] intValue])
                {
                    bself.mainTabView.isHaveMoreData = NO;
                    [bself.mainTabView finishReloadigData];
                    return;
                }else
                {
                    bself.mainTabView.isHaveMoreData = YES;
                }
                
                
                NSArray * array = [allDic objectForKey:@"app"];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    
                    for (NSDictionary * dic in array)
                    {
                        [bself.data_array addObject:dic];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [bself.mainTabView finishReloadigData];
                    });
                    
                });
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }];
    
    [request setFailedBlock:^{
        [hud hide:YES];
        [zsnApi showAutoHiddenMBProgressWithText:@"加载失败，请重试" addToView:self];
        if (bself.mainTabView.isLoadMoreData) {
            bself.mainTabView.pageNum--;
        }
    }];
    
    
    [jingxuan_request startAsynchronous];
    
}

#pragma mark - UItableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data_array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    
    CompreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell=[[CompreTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier type:CompreTableViewCellStyleText];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dictemp = [self.data_array objectAtIndex:indexPath.row];
    
    __weak typeof(self) wself=self;
    
    [cell normalsetDic:dictemp cellStyle:CompreTableViewCellStyleText thecellbloc:^(NSString *thebuttontype,NSDictionary *dic,NSString * theWhateverid) {
        
        
        //        NSLog(@"sh===%@===dic===%@===thewhateverid===%@",thebuttontype,dic,theWhateverid);
        
        [wself turntoOtherVCwithtype:thebuttontype thedic:dic theid:theWhateverid];
    }];
    
    
    UIView *selectback=[[UIView alloc]initWithFrame:cell.frame];
    selectback.backgroundColor=RGBCOLOR(242, 242, 242);
    cell.selectedBackgroundView=selectback;
    
    return cell;
}

#pragma mark--处理各种跳转
//
-(void)turntoOtherVCwithtype:(NSString *)thebuttontype thedic:(NSDictionary *)mydic theid:(NSString *)theWhateverid{
    //    //（1新闻，2图集，3论坛，4商城
    //
    NewMainViewModel *_newmodel=[[NewMainViewModel alloc]init];
    [_newmodel NewMainViewModelSetdic:mydic];
    BBSfenduiViewController *_bbsVC=[[BBSfenduiViewController alloc]init];
    _bbsVC.string_id=_newmodel.bbsfid;
//    [self.navigationController pushViewController:_bbsVC animated:YES];
    
    [self PushToVCWith:_bbsVC];
   
}



#pragma mark - RefreshView Delegate
- (void)loadNewData
{
    [self loadHuandeng];
    [self loadLuntanJingXuanData];
}
- (void)loadMoreData
{
    [self loadLuntanJingXuanData];
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dictemp = [self.data_array objectAtIndex:indexPath.row];
    
    NewMainViewModel *_newmodel=[[NewMainViewModel alloc]init];
    [_newmodel NewMainViewModelSetdic:dictemp];
    bbsdetailViewController * bbsdetail = [[bbsdetailViewController alloc] init];
    bbsdetail.bbsdetail_tid = _newmodel.tid;
    [self PushToVCWith:bbsdetail];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return [CompreTableViewCell getHeightwithtype:CompreTableViewCellStyleText];
}

-(void)PushToVCWith:(UIViewController *)aVC
{
    if (_delegate) {
        UIViewController * vc = (UIViewController *)self.delegate;
        aVC.hidesBottomBarWhenPushed = YES;
        [vc.navigationController pushViewController:aVC animated:YES];
    }
}



@end
