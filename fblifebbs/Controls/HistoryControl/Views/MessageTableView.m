//
//  MessageTableView.m
//  fblifebbs
//
//  Created by soulnear on 14-10-13.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "MessageTableView.h"
#import "CustomMessageCell.h"

@implementation MessageTableView
@synthesize myTableView = _myTableView;
@synthesize data_array = _data_array;



-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _myTableView = [[RefreshTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.refreshDelegate = self;
        [self addSubview:_myTableView];
        
    }
    return self;
}

-(void)setData_array:(NSMutableArray *)data_array
{
    _data_array = data_array;
    [_myTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data_array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = [NSString stringWithFormat:@"%d",indexPath.row];
    
    CustomMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[CustomMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.headImageView.image = nil;
    cell.NameLabel.text = @"";
    cell.timeLabel.text = @"";
    cell.contentLabel1.text = @"";
    cell.contentLabel.text = @"";
    
    
    cell.tixing_label.hidden=YES;
    
    MessageInfo * info = [self.data_array objectAtIndex:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [cell setAllViewWithType:0];
    
    [cell setInfoWithType:0 withMessageInfo:info];
    
    UIColor *color = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2f];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
    cell.selectedBackgroundView.backgroundColor =color;
    return cell;
}









/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
























