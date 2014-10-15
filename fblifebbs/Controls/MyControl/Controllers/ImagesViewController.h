//
//  ImagesViewController.h
//  FbLife
//
//  Created by soulnear on 13-3-25.
//  Copyright (c) 2013年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "ImagesCell.h"
#import "ATMHud.h"

@interface ImagesViewController : SNViewController<UITableViewDataSource,UITableViewDelegate,MWPhotoBrowserDelegate,ImageCellDelegate>
{
    ATMHud *hud;
    
    UILabel * title_label;
}


@property(nonatomic,strong)UITableView * myTableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray * photos;
@property(nonatomic,strong)NSString * tid;


@end
