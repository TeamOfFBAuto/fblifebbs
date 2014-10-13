//
//  MessageViewController.h
//  fblifebbs
//
//  Created by szk on 14-10-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : SNViewController<UIScrollViewDelegate>
{
    
}

///承载视图
@property(nonatomic,strong)UIScrollView * myScrollView;
///选的私信还是通知
@property(nonatomic,assign)int seg_current_page;


@end
