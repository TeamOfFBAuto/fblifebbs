//
//  UserModel.h
//  fblifebbs
//
//  Created by lichaowei on 14-10-14.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface UserModel : BaseModel
@property(nonatomic,retain)NSString *uid;//
@property(nonatomic,retain)NSString *username;//
@property(nonatomic,retain)NSString *nickname;//
@property(nonatomic,retain)NSString *face_small;//
@property(nonatomic,retain)NSString *gender;//简介
@property(nonatomic,retain)NSString *email;//
@property(nonatomic,retain)NSString *topic_count;//帖子数
@property(nonatomic,retain)NSString *follow_count;//关注数
@property(nonatomic,retain)NSString *fans_count;//粉丝
@property(nonatomic,retain)NSString *aboutme;//简介

@end
