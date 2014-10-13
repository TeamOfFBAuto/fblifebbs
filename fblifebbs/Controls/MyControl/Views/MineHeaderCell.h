//
//  MineHeaderCell.h
//  fblifebbs
//
//  Created by lichaowei on 14-10-13.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineHeaderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *tiezi_num_label;
@property (strong, nonatomic) IBOutlet UILabel *guanzhu_num_label;
@property (strong, nonatomic) IBOutlet UILabel *fans_num_label;

@end
