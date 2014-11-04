//
//  MineRowCell.m
//  fblifebbs
//
//  Created by lichaowei on 14-10-13.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "MineRowCell.h"

@implementation MineRowCell

- (void)awakeFromNib {
    // Initialization code
    
    self.arrowImage.left = DEVICE_WIDTH - 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
