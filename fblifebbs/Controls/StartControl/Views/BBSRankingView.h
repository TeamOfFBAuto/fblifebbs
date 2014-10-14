//
//  BBSRankingView.h
//  fblifebbs
//
//  Created by soulnear on 14-10-14.
//  Copyright (c) 2014年 szk. All rights reserved.
//
/*
 **排行榜
 */

#import <UIKit/UIKit.h>
#import "RankingListCustomCell.h"
#import "RankingListSegmentView.h"

typedef void(^BBSRankingViewBlock)(int index,id object);

@interface BBSRankingView : UIView<UITableViewDataSource,UITableViewDelegate,RefreshDelegate,RankingListCustomCellDelegate>
{
    RankingListSegmentView * ranking_segment;
    
    RankingListModel * myModel;
    
    BBSRankingViewBlock rangking_block;
}

@property(nonatomic,strong)RefreshTableView * myTableView;
///二维数组，存放所有数据
@property(nonatomic,strong)NSMutableArray * data_array;
///记录当前选中项
@property(nonatomic,assign)int currentPage;
///论坛版块收藏的数据
@property(nonatomic,strong)NSMutableArray * bbs_forum_collection_array;
///论坛帖子收藏的数据
@property(nonatomic,strong)NSMutableArray * bbs_post_collection_array;

@property(nonatomic,assign)BBSRankingViewBlock rangkingBlock;

-(id)initWithFrame:(CGRect)frame;
///点击方法回调(index值决定跳转方向。0：bbsdetail;1:bbsfendui;2:登陆界面)
-(void)setRangkingBlock:(BBSRankingViewBlock)rangkingBlock;

@end



























