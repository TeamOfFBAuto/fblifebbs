//
//  SNMineBBSCell.m
//  fblifebbs
//
//  Created by soulnear on 15-1-21.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "SNMineBBSCell.h"

@implementation SNMineBBSCell

- (void)awakeFromNib {
    _title_label.width = DEVICE_WIDTH - 24;
    _date_label.right = DEVICE_WIDTH-12;
    
    _title_label.numberOfLines = 0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
