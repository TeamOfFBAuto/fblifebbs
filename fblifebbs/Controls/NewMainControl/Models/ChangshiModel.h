//
//  ChangshiModel.h
//  car361
//
//  Created by szk on 14-10-16.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangshiModel : NSObject

/*
 
 fid: "12",
 name: "京",
 issub: "yes",
 postcount: "74",
 icon: "http://bbs.fblife.com/http://bbs.fblife.com/images/fblife/board/bj.gif"
 */

@property(nonatomic,strong)NSString *fid;

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *issub;
@property(nonatomic,strong)NSString *postcount;
@property(nonatomic,strong)NSString *icon;



-(ChangshiModel *)initWithDictionary:(NSDictionary *)dic;


@end
