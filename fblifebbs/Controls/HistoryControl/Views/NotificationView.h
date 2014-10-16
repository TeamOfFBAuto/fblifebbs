//
//  NotificationScrollView.h
//  fblifebbs
//
//  Created by soulnear on 14-10-14.
//  Copyright (c) 2014年 szk. All rights reserved.
//
/*
 **消息通知（fb通知，论坛通知）
 */

#import <UIKit/UIKit.h>

typedef enum
{
    NotificationViewTypeFB=0,
    NotificationViewTypeBBS=1
}NotificationViewType;



@interface NotificationView : UIView<UITableViewDataSource,UITableViewDelegate,RefreshDelegate>
{
    LTools * request_tools;
    ///未读数据容器
    NSMutableArray * uread_array;
    ///已读数据容器
    NSMutableArray * read_array;
    
    ///fb未读页数
    int uread_page;
    ///fb已读页数
    int read_page;
    ///fb未读数据是否已经请求完
    BOOL isUReadOver;
    
    NSMutableArray * bbs_array;
}

@property(nonatomic,strong)RefreshTableView * myTableView;
///类型
@property(nonatomic,assign)NotificationViewType aType;


-(id)initWithFrame:(CGRect)frame withType:(NotificationViewType)theType;


@end










