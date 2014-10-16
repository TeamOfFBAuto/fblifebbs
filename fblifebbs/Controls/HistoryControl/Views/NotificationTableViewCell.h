//
//  NotificationTableViewCell.h
//  fblifebbs
//
//  Created by soulnear on 14-10-14.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NotificationTableViewCell : UITableViewCell
{
    
}
///显示时间
@property (strong, nonatomic) IBOutlet UILabel *date_label;

///头像
@property (strong, nonatomic) IBOutlet AsyncImageView *header_imageView;
///内容
@property (strong, nonatomic) IBOutlet UILabel *content_label;
///背景图片
@property (strong, nonatomic) IBOutlet UIImageView *background_imageView;


-(void)setInfoWith:(id)object;


@end
