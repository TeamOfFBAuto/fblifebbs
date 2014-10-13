//
//  BBSViewController.h
//  fblifebbs
//
//  Created by szk on 14-10-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SliderBBSForumModel : NSObject
{
    
}


@property(nonatomic,strong)NSString * forum_fid;

@property(nonatomic,strong)NSString * forum_name;

@property(nonatomic,assign)BOOL forum_isOpen;

@property(nonatomic,assign)BOOL forum_isHave_sub;

@property(nonatomic,strong)NSMutableArray * forum_sub;



-(SliderBBSForumModel *)initWithDictionary:(NSDictionary *)dic;

@end




typedef enum{
    ForumDiQuType = 0,
    ForumCheXingType,
    ForumZhuTiType,
    ForumJiaoYiType
} ForumType;


@interface BBSViewController : SNViewController<UIScrollViewDelegate>
{
    
}

///记录当前是 排行榜还是版块(0为论坛版块  1为排行榜)
@property(nonatomic,assign)int seg_current_page;
///主视图
@property(nonatomic,strong)UIScrollView * myScrollView;
///论坛视图
@property(nonatomic,strong)UITableView * myTableView1;
///排行榜视图
@property(nonatomic,strong)RefreshTableView * myTableView2;
///地区版块数据
@property(nonatomic,strong)NSMutableArray * forum_diqu_array;
///车型版块数据
@property(nonatomic,strong)NSMutableArray * forum_chexing_array;
///主题版块数据
@property(nonatomic,strong)NSMutableArray * forum_zhuti_array;
///交易版块数据
@property(nonatomic,strong)NSMutableArray * forum_jiaoyi_array;
///存放四个板块数组
@property(nonatomic,strong)NSMutableArray * forum_temp_array;
///存放所有收藏的论坛版块的id
@property(nonatomic,strong)NSMutableArray * forum_section_collection_array;

@end























