//
//  NotificationBBSModel.h
//  fblifebbs
//
//  Created by soulnear on 14-10-14.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationBBSModel : NSObject
{
    
}

///论坛id
@property(nonatomic,strong)NSString * tid;
///论坛页数
@property(nonatomic,strong)NSString * page;
///时间
@property(nonatomic,strong)NSString * dateline;
///类型
@property(nonatomic,strong)NSString * type;
///用户头像地址
@property(nonatomic,strong)NSString * authorimg;
///内容详情
@property(nonatomic,strong)NSString * message;



-(id)initWithDic:(NSDictionary *)dic;


@end
