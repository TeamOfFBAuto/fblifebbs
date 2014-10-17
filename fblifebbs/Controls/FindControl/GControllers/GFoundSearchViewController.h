//
//  GFoundSearchViewController.h
//  fblifebbs
//
//  Created by gaomeng on 14-10-13.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSegmentView.h"
#import "NewWeiBoCustomCell.h"
#import "MWPhotoBrowser.h"

@interface GFoundSearchViewController : SNViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CustomSegmentViewDelegate,NewWeiBoCustomCellDelegate,MWPhotoBrowserDelegate>


///主视图，显示数据
@property(nonatomic,strong)UITableView * myTableView;


///存放所有数据
@property(nonatomic,strong)NSMutableArray * data_array;

@property(nonatomic,strong)NSMutableArray * array_searchresault;

@property(nonatomic,strong)NSMutableArray * photos;



@end
