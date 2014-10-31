//
//  ChangshiTableViewCell.h
//  car361
//
//  Created by szk on 14-10-16.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "ChangshiModel.h"

#import <UIKit/UIKit.h>

@interface ChangshiTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *imagev;

@property (nonatomic,strong)UILabel *title_label;

@property (nonatomic,strong)UILabel *date_label;

-(void)setSubviewWithModel:(ChangshiModel *)theChangshimodel;


@end
