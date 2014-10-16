//
//  MessageTableView.m
//  fblifebbs
// 
//  Created by soulnear on 14-10-13.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "MessageTableView.h"
#import "CustomMessageCell.h"
#import "MyChatViewController.h"

@implementation MessageTableView
@synthesize myTableView = _myTableView;
@synthesize data_array = _data_array;



-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
        
    }
    return self;
}

-(void)setup
{
    _data_array = [NSMutableArray array];
    _myTableView = [[RefreshTableView alloc] initWithFrame:self.bounds showLoadMore:NO];
    _myTableView.dataSource = self;
    _myTableView.refreshDelegate = self;
    _myTableView.separatorInset = UIEdgeInsetsZero;
    [self addSubview:_myTableView];
    
    [self initHttpRequest];
}

#pragma mark - 网络请求
#pragma mark-获取私信列表
-(void)initHttpRequest
{
    [request_tools cancelRequest];
    
    NSString * string = [[NSUserDefaults standardUserDefaults] objectForKey:USER_AUTHOD];
    request_tools = [[LTools alloc] initWithUrl:[NSString stringWithFormat:GET_MESSAGE_LIST_URL,string] isPost:NO postData:nil];
    
    NSLog(@"私信首页url --  %@",[NSString stringWithFormat:GET_MESSAGE_LIST_URL,string]);
    
    __weak typeof(self)bself = self;
    [request_tools requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        @try {
            
            [bself.data_array removeAllObjects];
            NSArray * infoArray = [result objectForKey:@"info"];
            
            if (![infoArray isKindOfClass:[NSArray class]]) {
                return ;
            }
            
            NSLog(@"info===%@",infoArray);
            
            for (NSDictionary * dic in infoArray)
            {
                MessageInfo * info = [[MessageInfo alloc] initWithDictionary:dic];
                
                [bself.data_array addObject:info];
                
            }
            NSUserDefaults *stau=[NSUserDefaults standardUserDefaults];
            [stau setObject:infoArray forKey:@"whyhavenodata"];
            NSLog(@"youmuyou==%@",[stau objectForKey:@"whyhavenodata"]);
            [stau synchronize];
            
            if (bself.data_array.count == 0)///此时没有数据了
            {
                
            }else
            {
                
            }
            
            [bself.myTableView finishReloadigData];
            
        }
        @catch (NSException *exception)
        {
            
        }
        @finally {
            
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        [bself.myTableView finishReloadigData];
    }];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data_array.count;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 76;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = [NSString stringWithFormat:@"%d",indexPath.row];
    
    CustomMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[CustomMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.headImageView.image = nil;
    cell.NameLabel.text = @"";
    cell.timeLabel.text = @"";
    cell.contentLabel1.text = @"";
    cell.contentLabel.text = @"";
    
    
    cell.tixing_label.hidden=YES;
    
    MessageInfo * info = [self.data_array objectAtIndex:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [cell setAllViewWithType:0];
    
    [cell setInfoWithType:0 withMessageInfo:info];
    
    UIColor *color = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2f];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
    cell.selectedBackgroundView.backgroundColor =color;
    return cell;
}

///下拉加载
- (void)loadNewData
{
    [self initHttpRequest];
}
///上拉更多
- (void)loadMoreData
{
    
}


- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageInfo * info = [self.data_array objectAtIndex:indexPath.row];
    MyChatViewController * chat = [[MyChatViewController alloc] init];
    chat.info = info;
    UIViewController * vc = [self getSuperViewController];
    vc.hidesBottomBarWhenPushed = YES;
    [vc.navigationController pushViewController:chat animated:YES];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}
- (UIView *)viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


-(UIViewController *)getSuperViewController
{
    return (UIViewController *)_delegate;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
























