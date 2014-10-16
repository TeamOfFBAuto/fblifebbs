//
//  MessageTableView.h
//  fblifebbs
//
//  Created by soulnear on 14-10-13.
//  Copyright (c) 2014年 szk. All rights reserved.
//
/*
 **私信列表页
 */

#import <UIKit/UIKit.h>

@protocol MessageTableViewDelegate <NSObject>


@end


@interface MessageTableView : UIView<UITableViewDataSource,UITableViewDelegate,RefreshDelegate>
{
    LTools * request_tools;
}

@property(nonatomic,strong)RefreshTableView * myTableView;
///存放数据容器
@property(nonatomic,strong)NSMutableArray * data_array;
///
@property(nonatomic,assign)id<MessageTableViewDelegate>delegate;

-(id)initWithFrame:(CGRect)frame;

@end
