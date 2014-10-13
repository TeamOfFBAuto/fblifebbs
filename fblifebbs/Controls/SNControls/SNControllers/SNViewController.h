//
//  SNViewController.h
//  fblifebbs
//
//  Created by soulnear on 14-10-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    MyViewControllerLeftbuttonTypeBack=0,
    MyViewControllerLeftbuttonTypelogo=1,
    MyViewControllerLeftbuttonTypeOther=2,
    MyViewControllerLeftbuttonTypeNull=3,
    MyViewControllerLeftbuttonTypeText = 4
}SNViewControllerLeftbuttonType;


typedef enum
{
    MyViewControllerRightbuttonTypeRefresh=0,
    MyViewControllerRightbuttonTypeSearch=1,
    MyViewControllerRightbuttonTypeText=2,
    MyViewControllerRightbuttonTypePerson=3,
    MyViewControllerRightbuttonTypeDelete=4,
    MyViewControllerRightbuttonTypeNull=5,
    MyViewControllerRightbuttonTypeOther
}SNViewControllerRightbuttonType;


@interface SNViewController : UIViewController
{
    UIBarButtonItem * spaceButton;
    
    SNViewControllerLeftbuttonType * myLeftType;
    
    SNViewControllerRightbuttonType * MyRightType;
}

///右侧字符串
@property(nonatomic,strong)NSString * rightString;
///左侧字符串
@property(nonatomic,strong)NSString * leftString;
///左侧图片名字
@property(nonatomic,strong)NSString * leftImageName;
///右侧图片名字
@property(nonatomic,strong)NSString * rightImageName;
///右上角按钮
@property(nonatomic,strong)UIButton * my_right_button;
///左上角按钮
@property(nonatomic,strong)UIButton * my_left_button;


-(void)setSNViewControllerLeftButtonType:(SNViewControllerLeftbuttonType)theType WithRightButtonType:(SNViewControllerRightbuttonType)rightType;



@end
