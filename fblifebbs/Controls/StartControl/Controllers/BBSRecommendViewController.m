//
//  BBSRecommendViewController.m
//  fblifebbs
//
//  Created by soulnear on 14-11-11.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "BBSRecommendViewController.h"
#import "CompreTableViewCell.h"
#import "NewMainViewModel.h"
#import "bbsdetailViewController.h"



@interface BBSRecommendViewController ()<RefreshDelegate,UITableViewDataSource>
{
    MBProgressHUD * hud;
}


@property(nonatomic,strong)RefreshTableView * myTableView;
@property(nonatomic,strong)NSMutableArray * data_array;

@end

@implementation BBSRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"精选推荐";
    [self setSNViewControllerLeftButtonType:SNViewControllerLeftbuttonTypeBack WithRightButtonType:SNViewControllerRightbuttonTypeNull];
    
    _data_array = [NSMutableArray array];
    
    _myTableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT-64) showLoadMore:YES];
    _myTableView.dataSource = self;
    _myTableView.refreshDelegate = self;
    [self.view addSubview:_myTableView];
    
    [self loadLuntanJingXuanData];
    
    hud = [zsnApi showMBProgressWithText:@"正在加载..." addToView:self.view];
}

#pragma mark - 获取数据
#pragma mark - 请求论坛精选数据

-(void)loadLuntanJingXuanData
{
    
    NSString * fullUrl = [NSString stringWithFormat:BBS_JINGXUAN_URL,_myTableView.pageNum];
    
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
                if (bself.data_array.count >= [[allDic objectForKey:@"pages"] intValue])
                {
                    return;
                }
                if (bself.myTableView.pageNum == 1) {
                    [bself.data_array removeAllObjects];
                }
                
                NSArray * array = [allDic objectForKey:@"app"];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    
                    for (NSDictionary * dic in array)
                    {
                        [bself.data_array addObject:dic];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [bself.myTableView reloadData];
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
        [zsnApi showAutoHiddenMBProgressWithText:@"加载失败，请重试" addToView:self.view];
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
        
//        [wself turntoOtherVCwithtype:thebuttontype thedic:dic theid:theWhateverid];
    }];
    
    
    UIView *selectback=[[UIView alloc]initWithFrame:cell.frame];
    selectback.backgroundColor=RGBCOLOR(242, 242, 242);
    cell.selectedBackgroundView=selectback;
    
    return cell;
}

//#pragma mark--处理各种跳转
//
//-(void)turntoOtherVCwithtype:(NSString *)thebuttontype thedic:(NSDictionary *)mydic theid:(NSString *)theWhateverid{
//    //（1新闻，2图集，3论坛，4商城
//    
//    NewMainViewModel *_newmodel=[[NewMainViewModel alloc]init];
//    [_newmodel NewMainViewModelSetdic:mydic];
//    
//    if ([thebuttontype isEqualToString:@"big"]) {
//        //点击的是大的button
//        
//        switch ([_newmodel.type intValue]) {
//            case 1:
//            {
//                
//                RootViewController *rootV=[[RootViewController alloc]init];
//                
//                [self.navigationController pushViewController:rootV animated:YES];
//                
//                
//            }
//                break;
//            case 2:
//            {
//                PicShowViewController *TestVC=[[PicShowViewController alloc]init];
//                
//                
//                [self.navigationController pushViewController:TestVC animated:YES];
//                
//                
//            }
//                break;
//            case 3:
//            {
//                [_seg_view MyButtonStateWithIndex:1];
//            }
//                break;
//            case 4:
//            {
//                
//            }
//                break;
//                
//            default:
//                break;
//        }
//        
//        
//    }else if([thebuttontype isEqualToString:@"small"]) {
//        
//        switch ([_newmodel.type intValue]) {
//            case 1:
//            {
//                
//                RootViewController *rootV=[[RootViewController alloc]init];
//                rootV.str_dijige=_newmodel.shownum;
//                
//                
//                
//                NSLog(@"self.diji===%@",rootV.str_dijige);
//                
//                [self.navigationController pushViewController:rootV animated:YES];
//                
//                
//            }
//                break;
//            case 2:
//            {
//                PicShowViewController *TestVC=[[PicShowViewController alloc]init];
//                
//                
//                [self.navigationController pushViewController:TestVC animated:YES];
//                
//            }
//                break;
//            case 3:
//            {
//                BBSfenduiViewController *_bbsVC=[[BBSfenduiViewController alloc]init];\
//                
//                _bbsVC.string_id=_newmodel.bbsfid;
//                
//                _bbsVC.collection_array = self.forum_section_collection_array;
//                
//                [self.navigationController pushViewController:_bbsVC animated:YES];
//            }
//                break;
//            case 4:
//            {
//                
//                
//            }
//                break;
//                
//            default:
//                break;
//        }
//    }
//    
//    //   NSLog(@"xxxx==%@",mydic);
//    //
//    
//    
//}

#pragma mark - RefreshDelegate
- (void)loadNewData
{
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
    [self PushControllerWith:bbsdetail WithAnimation:YES];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return [CompreTableViewCell getHeightwithtype:CompreTableViewCellStyleText];
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
