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
    
    
    
    _date_label.text = date_string;
    [_header_imageView loadImageFromURL:image_url withPlaceholdImage:[UIImage imageNamed:@"touxiang"]];
    
    _content_label.text = content_string;
    _content_label.numberOfLines=0;
    CGSize constraintSize = CGSizeMake(220, MAXFLOAT);
    CGSize labelSize = [content_string sizeWithFont:_content_label.font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    _content_label.frame=CGRectMake(67, 38, 220, labelSize.height);
    
    UIImage *image=[UIImage imageNamed:@"talk2.png"];
    _background_imageView.image = [image stretchableImageWithLeftCapWidth:22.f topCapHeight:22.f];
    _background_imageView.frame=CGRectMake(52, 33, 240,labelSize.height+10);
    
    
}








@end
