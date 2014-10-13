//
//  MessageTableView.h
//  fblifebbs
//
//  Created by soulnear on 14-10-13.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableView : UIView<UITableViewDataSource,UITableViewDelegate,RefreshDelegate>
{
    
}

@property(nonatomic,strong)RefreshTableView * myTableView;
///存放数据容器
@property(nonatomic,strong)NSMutableArray * data_array;


-(id)initWithFrame:(CGRect)frame;

@end
