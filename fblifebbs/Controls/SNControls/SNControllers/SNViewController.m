//
//  SNViewController.m
//  fblifebbs
//
//  Created by soulnear on 14-10-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "SNViewController.h"


@interface SNViewController ()

@end

@implementation SNViewController
@synthesize my_left_button = _my_left_button;
@synthesize my_right_button = _my_right_button;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (MY_MACRO_NAME) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] )
    {
        //iOS 5 new UINavigationBar custom background
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:MY_MACRO_NAME?IOS7DAOHANGLANBEIJING:IOS6DAOHANGLANBEIJING] forBarMetrics: UIBarMetricsDefault];
    }
    
    UIColor * cc = [UIColor blackColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:cc,[UIFont systemFontOfSize:20],[UIColor clearColor],nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor,UITextAttributeFont,UITextAttributeTextShadowColor,nil]];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton.width = MY_MACRO_NAME?-5:5;
    
    self.navigationController.navigationBarHidden=NO;
}

-(void)setSNViewControllerLeftButtonType:(SNViewControllerLeftbuttonType)theType WithRightButtonType:(SNViewControllerRightbuttonType)rightType
{
    myLeftType = &theType;
    MyRightType = &rightType;
    
    if (theType == SNViewControllerLeftbuttonTypeBack)
    {
        UIBarButtonItem * spaceButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButton1.width = MY_MACRO_NAME?-13:5;
        
        _my_left_button=[[UIButton alloc]initWithFrame:CGRectMake(MY_MACRO_NAME? -5:5,8,40,44)];
        [_my_left_button addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [_my_left_button setImage:[UIImage imageNamed:BACK_DEFAULT_IMAGE] forState:UIControlStateNormal];
        UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:_my_left_button];
        self.navigationItem.leftBarButtonItems=@[spaceButton1,back_item];
    }else if (theType == SNViewControllerLeftbuttonTypelogo)
    {
        UIImageView * leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ios7logo"]];
        leftImageView.center = CGPointMake(MY_MACRO_NAME? 18:30,22);
        UIView *lefttttview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
        [lefttttview addSubview:leftImageView];
        UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:lefttttview];
        self.navigationItem.leftBarButtonItems = @[spaceButton,leftButton];
    }else if(theType == SNViewControllerLeftbuttonTypeOther)
    {
        UIImage * leftImage = [UIImage imageNamed:_leftImageName];
        _my_left_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_my_left_button addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [_my_left_button setImage:[UIImage imageNamed:self.leftImageName] forState:UIControlStateNormal];
        _my_left_button.frame = CGRectMake(0,0,leftImage.size.width,leftImage.size.height);
        UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:_my_left_button];
        self.navigationItem.leftBarButtonItems = @[spaceButton,leftBarButton];;
        
    }else if (theType == SNViewControllerRightbuttonTypeText)
    {
        _my_left_button = [UIButton buttonWithType:UIButtonTypeCustom];
        _my_left_button.frame = CGRectMake(0,0,30,44);
        _my_left_button.titleLabel.textAlignment = NSTextAlignmentRight;
        [_my_left_button setTitle:_leftString forState:UIControlStateNormal];
        _my_left_button.titleLabel.font = [UIFont systemFontOfSize:15];
        [_my_left_button setTitleColor:RGBCOLOR(91,138,59) forState:UIControlStateNormal];
        [_my_left_button addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItems = @[spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_left_button]];
    }else
    {
        
    }
    
    
    
    if (rightType == SNViewControllerRightbuttonTypeRefresh)
    {
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_my_right_button setImage:[UIImage imageNamed:@"ios7_refresh4139.png"] forState:UIControlStateNormal];
        _my_right_button.frame = CGRectMake(0,0,41/2,39/2);
        _my_right_button.center = CGPointMake(300,20);
        [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItems= @[spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
        
    }else if (rightType == SNViewControllerRightbuttonTypeSearch)
    {
        UIButton *rightview=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 37, 37/2)];
        rightview.backgroundColor=[UIColor clearColor];
        [rightview addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_my_right_button setImage:[UIImage imageNamed:@"ios7_newssearch.png"] forState:UIControlStateNormal];
        _my_right_button.frame = CGRectMake(MY_MACRO_NAME? 25:10, 0, 37/2, 37/2);
        //    refreshButton.center = CGPointMake(300,20);
        [rightview addSubview:_my_right_button];
        [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *_rightitem=[[UIBarButtonItem alloc]initWithCustomView:rightview];
        self.navigationItem.rightBarButtonItem=_rightitem;
        
    }else if(rightType == SNViewControllerRightbuttonTypeText)
    {
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        _my_right_button.frame = CGRectMake(0,0,30,44);
        _my_right_button.titleLabel.textAlignment = NSTextAlignmentRight;
        [_my_right_button setTitle:_rightString forState:UIControlStateNormal];
        _my_right_button.titleLabel.font = [UIFont systemFontOfSize:15];
        [_my_right_button setTitleColor:RGBCOLOR(91,138,59) forState:UIControlStateNormal];
        [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItems = @[spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
        
    }else if (rightType == SNViewControllerRightbuttonTypeDelete)
    {
        
    }else if (rightType == SNViewControllerRightbuttonTypePerson)
    {
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        _my_right_button.frame = CGRectMake(0,0,36/2,33/2);
        [_my_right_button setImage:[UIImage imageNamed:@"chat_people.png"] forState:UIControlStateNormal];
        [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * People_button = [[UIBarButtonItem alloc] initWithCustomView:_my_right_button];
        self.navigationItem.rightBarButtonItems = @[spaceButton,People_button];
        
        
    }else if(rightType == SNViewControllerRightbuttonTypeOther)
    {
        UIImage * rightImage = [UIImage imageNamed:_rightImageName];
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [_my_right_button setImage:[UIImage imageNamed:self.rightImageName] forState:UIControlStateNormal];
        _my_right_button.frame = CGRectMake(0,0,rightImage.size.width,rightImage.size.height);
        UIBarButtonItem * rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:_my_right_button];
        self.navigationItem.rightBarButtonItems = @[spaceButton,rightBarButton];;
    }else
    {
        
    }
}

#pragma mark - 点击方法
-(void)rightButtonTap:(UIButton *)sender
{
    
}

-(void)leftButtonTap:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 赋值方法
-(void)setLeftImageName:(NSString *)leftImageName
{
    _leftImageName = leftImageName;
    [self setSNViewControllerLeftButtonType:*(myLeftType) WithRightButtonType:*(MyRightType)];
}
-(void)setLeftString:(NSString *)leftString
{
    _leftString = leftString;
    [self setSNViewControllerLeftButtonType:*(myLeftType) WithRightButtonType:*(MyRightType)];
}

-(void)setRightImageName:(NSString *)rightImageName
{
    _rightImageName = rightImageName;
    [self setSNViewControllerLeftButtonType:*(myLeftType) WithRightButtonType:*(MyRightType)];
}

-(void)setRightString:(NSString *)rightString
{
    _rightString = rightString;
    [self setSNViewControllerLeftButtonType:*(myLeftType) WithRightButtonType:*(MyRightType)];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(void)PushControllerWith:(UIViewController *)vc WithAnimation:(BOOL)animation
{
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:animation];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
