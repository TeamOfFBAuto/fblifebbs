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
//    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.refreshDelegate = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.isHaveMoreData = YES;
    [self addSubview:_myTableView];
    
    [self getNotificationData];
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
                if (uread_page == 1) {
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
            
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [bself loadFBReadNotificationWithHud:hud];
            [bself.myTableView finishReloadigData];
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
                
                for (NSDictionary * aDic in array)
                {
                    NotificationBBSModel * model = [[NotificationBBSModel alloc] initWithDic:aDic];
                    [bbs_array addObject:model];
                }
                
                if (array.count < 20) {
                    bself.myTableView.isHaveMoreData = NO;
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
            
            for (NSDictionary * aDic in array)
            {
                NotificationFBModel * model = [[NotificationFBModel alloc] initWithDic:aDic];
                [read_array addObject:model];
            }
            
            if (array.count < 20)
            {
                bself.myTableView.isHaveMoreData = NO;
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

/*
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_aType==NotificationViewTypeBBS) {
        return 0;
    }else{
        return 24;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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


*/

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    NotificationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
//        cell = [[NotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
