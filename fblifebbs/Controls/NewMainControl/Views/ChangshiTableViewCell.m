//
//  ChangshiTableViewCell.m
//  car361
//
//  Created by szk on 14-10-16.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "ChangshiTableViewCell.h"


@implementation ChangshiTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    ///自动生成注释？
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imagev=[[UIImageView alloc]initWithFrame:CGRectMake( 12, 11, 46, 36)];
        [self addSubview:_imagev];
        
        _title_label=[[UILabel alloc]initWithFrame:CGRectMake(75, 11, 200, 20)];
        [self addSubview:_title_label];
        _date_label=[[UILabel alloc]initWithFrame:CGRectMake(75,30,200, 20)];
        _date_label.textAlignment=NSTextAlignmentRight;
        [self addSubview:_date_label];
        
        self.title_label.font=[UIFont systemFontOfSize:16];
        self.title_label.textColor=RGBCOLOR(49, 49, 49);
        self.title_label.backgroundColor=[UIColor clearColor];
        
        self.date_label.font=[UIFont systemFontOfSize:11];
        
        self.date_label.textColor=RGBCOLOR(173, 173, 173);
        self.date_label.textAlignment=NSTextAlignmentLeft;
        
        self.date_label.numberOfLines=0;
        
        UIView *viewline=[[UIView alloc]initWithFrame:CGRectMake(12, 56.5, 320-24, 0.5)];
        viewline.backgroundColor=RGBCOLOR(223, 223, 223);
        [self addSubview:viewline];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSubviewWithModel:(ChangshiModel *)theChangshimodel{
    


    
    [_imagev setImageWithURL:[NSURL URLWithString:theChangshimodel.icon] placeholderImage:[UIImage imageNamed:@"ios7_implace.png"]];
    
    _title_label.text=theChangshimodel.name;
    
          _date_label.text=[NSString stringWithFormat:@"今日新帖：%@",theChangshimodel.postcount];
  
}

@end
