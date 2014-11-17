//
//  NotificationTableViewCell.m
//  fblifebbs
//
//  Created by soulnear on 14-10-14.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "NotificationFBModel.h"
#import "NotificationBBSModel.h"

@implementation NotificationTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _content_label.numberOfLines = 0;
    _content_label.font = [UIFont systemFontOfSize:15];
    _content_label.adjustsFontSizeToFitWidth = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)setInfoWith:(id)object
{
    NSString * date_string;
    NSString * content_string;
    NSString * image_url;
    
    if ([object isKindOfClass:[NotificationBBSModel class]])///bbs通知
    {
        NotificationBBSModel * model = (NotificationBBSModel *)object;
        date_string = model.dateline;
        content_string = model.message;
        image_url = model.authorimg;
        
    }else///fb通知
    {
       NotificationFBModel * model = (NotificationFBModel*)object;
        date_string = model.fb_time;
        content_string = model.fb_content;
        image_url = model.fb_face_small;
    }
    
    
    _date_label.center = CGPointMake(DEVICE_WIDTH/2.0,_date_label.center.y);
    _date_label.text = date_string;
    [_header_imageView loadImageFromURL:image_url withPlaceholdImage:[UIImage imageNamed:@"touxiang"]];
    
    CGSize constraintSize = CGSizeMake(DEVICE_WIDTH-100, MAXFLOAT);
    CGSize labelSize = [content_string sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    _content_label.frame=CGRectMake(72, 38,DEVICE_WIDTH-100, labelSize.height+1);
    _content_label.text = content_string;
    UIImage *image=[UIImage imageNamed:@"talk2.png"];
    _background_imageView.image = [image stretchableImageWithLeftCapWidth:22.f topCapHeight:22.f];
    _background_imageView.frame=CGRectMake(57, 33, DEVICE_WIDTH-80,labelSize.height+10);
}








@end
