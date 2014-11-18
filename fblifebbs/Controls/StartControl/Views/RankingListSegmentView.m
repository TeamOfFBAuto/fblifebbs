//
//  RankingListSegmentView.m
//  越野e族
//
//  Created by soulnear on 14-7-9.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "RankingListSegmentView.h"

@implementation RankingListSegmentView

- (id)initWithFrame:(CGRect)frame WithBlock:(RankingListSegmentViewBlock)theBlock
{
    self = [super initWithFrame:frame];
    if (self)
    {
        rankingListBlock = theBlock;
        [self setup];
    }
    return self;
}

-(void)setup
{
//    NSArray * image_array = [NSArray arrayWithObjects:@"bbs_rankinglist_zhuti1",@"bbs_rankinglist_chexing1",@"bbs_rankinglist_dadui1",@"bbs_rankinglist_zhuti",@"bbs_rankinglist_chexing",@"bbs_rankinglist_dadui",nil];
    NSArray * title_array = [NSArray arrayWithObjects:@"主题",@"车型",@"大队",nil];
    for (int i = 0;i < 3;i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(12 + ((DEVICE_WIDTH-32)/3+4)*i,12,(DEVICE_WIDTH-32)/3,45);
        [button setBackgroundImage:[UIImage imageNamed:@"bbs_rankinglist_unselected"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"bbs_rankinglist_selected"] forState:UIControlStateSelected];
        [button setTitle:[title_array objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:RGBCOLOR(130,130,130) forState:UIControlStateNormal];
        [button setTitleColor:RGBCOLOR(3,3,3) forState:UIControlStateSelected];
        historyPage = 0;
        
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        if (i == 0)
        {
            button.selected = YES;
        }else
        {
            button.selected = NO;
        }
    }
}


-(void)buttonTap:(UIButton *)sender
{
    rankingListBlock(sender.tag - 100);
    
    if (sender.tag -100 == historyPage) {
        
    }else
    {
        UIButton * button = (UIButton *)[self viewWithTag:historyPage+100];
        button.selected = NO;
        sender.selected = YES;
    }
    historyPage = sender.tag -100;
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
