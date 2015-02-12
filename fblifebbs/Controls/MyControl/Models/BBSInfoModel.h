//
//  BBSInfoModel.h
//  fblifebbs
//
//  Created by soulnear on 15-2-9.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface BBSInfoModel : BaseModel



///用户id
@property(nonatomic,strong)NSString * uid;
///用户名
@property(nonatomic,strong)NSString * username;
///性别
@property(nonatomic,strong)NSString * gender;
///用户组
@property(nonatomic,strong)NSString * groupid;
///用户组
@property(nonatomic,strong)NSString * grouptitle;
///积分
@property(nonatomic,strong)NSString * credits;
///浏览页数
@property(nonatomic,strong)NSString * pageviews;
///在线时间
@property(nonatomic,strong)NSString * oltime;
///帖子数
@property(nonatomic,strong)NSString * posts;
///加精的帖子数
@property(nonatomic,strong)NSString * digestposts;
///金钱
@property(nonatomic,strong)NSString * extcredits3;
///背景图原图
@property(nonatomic,strong)NSString * backImg_o;
///切分后的背景图(540X360)
@property(nonatomic,strong)NSString * backImg_small;
///切分后的背景图(750,500)
@property(nonatomic,strong)NSString * backImg_big;
///注册日期
@property(nonatomic,strong)NSString * regdate;
///上次访问
@property(nonatomic,strong)NSString * lastvisit;
///经验
@property(nonatomic,strong)NSString * extcredits1;
///威望
@property(nonatomic,strong)NSString * extcredits2;
///魅力
@property(nonatomic,strong)NSString * extcredits4;
///最后发表
@property(nonatomic,strong)NSString * lastpost;
///生日
@property(nonatomic,strong)NSString * bday;
///来自
@property(nonatomic,strong)NSString * location;
///电话
@property(nonatomic,strong)NSString * field_5;
///职业(1、学生2、职员3、经理4、专业人士5、公务员6、私营主7、待业8、退休9、其他)
@property(nonatomic,strong)NSString * field_3;
///婚姻(1代表已婚，2代表未婚)
@property(nonatomic,strong)NSString * field_4;
///性格
@property(nonatomic,strong)NSString * field_9;
///爱好
@property(nonatomic,strong)NSString * field_10;
///关注数
@property(nonatomic,strong)NSString * follow_count;
///粉丝数
@property(nonatomic,strong)NSString * fans_count;
///帖子数
@property(nonatomic,strong)NSString * topic_count;
///文集数
@property(nonatomic,strong)NSString * blog_count;
///邮箱
@property(nonatomic,strong)NSString * email;
///介绍
@property(nonatomic,strong)NSString * bio;
///发帖级别
@property(nonatomic,strong)NSString * ranktitle;
///阅读权限
@property(nonatomic,strong)NSString * readaccess;


-(void)setLastpost:(NSString *)lastpost;
-(void)setLastvisit:(NSString *)lastvisit;
-(void)setRegdate:(NSString *)regdate;

-(void)setGender:(NSString *)gender;
-(void)setField_3:(NSString *)field_3;



@end











