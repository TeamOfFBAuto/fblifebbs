//
//  GFoundSearchViewController3.m
//  fblifebbs
//
//  Created by gaomeng on 14-10-17.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GFoundSearchViewController3.h"

@interface GFoundSearchViewController3 ()

@end

@implementation GFoundSearchViewController3

- (void)dealloc
{
    [request_search clearDelegatesAndCancel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    [self setSNViewControllerLeftButtonType:SNViewControllerLeftbuttonTypeBack WithRightButtonType:SNViewControllerRightbuttonTypeNull];
    
    self.title = @"搜索";
    
    
    if (!array_search_bankuai)
    {
        array_search_bankuai = [[NSMutableArray alloc] init];
    }
    
    if (!array_search_bbs)
    {
        array_search_bbs = [[NSMutableArray alloc] init];
    }
    
    if (!weibo_search_data)
    {
        weibo_search_data = [[NSMutableArray alloc] init];
    }
    
    if (!array_search_user)
    {
        array_search_user = [[NSMutableArray alloc] init];
    }
    
    if (!self.array_searchresault) {
        self.array_searchresault = [NSMutableArray array];
    }
    
    _photos = [NSMutableArray array];
    
    if (!array_cache)
    {
        array_cache = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",nil];
    }
    
    
    
    searchheaderview=[[UIView alloc]initWithFrame:CGRectMake(0,IOS_VERSION>=7?0:0, 320,IOS_VERSION>=7?108: 88)];
    searchheaderview.backgroundColor=RGBCOLOR(247, 247, 247);
    [self.view addSubview:searchheaderview];
    
    
    ImgV_ofsearch=[[UIImageView alloc]initWithFrame:CGRectMake(6, MY_MACRO_NAME?20:0, 320-6, 44)];
    ImgV_ofsearch.backgroundColor=RGBCOLOR(247, 247, 247);
    ImgV_ofsearch.userInteractionEnabled=YES;
    [searchheaderview addSubview:ImgV_ofsearch];
    
    
    
    UIImageView *imgbc=[[UIImageView alloc]initWithFrame:CGRectMake(6, 6, 517/2, 56/2)];
    imgbc.image=[UIImage imageNamed:@"ios7_newssearchbar.png"];
    [ImgV_ofsearch addSubview:imgbc];
    
    _searchbar=[[UITextField alloc]initWithFrame:CGRectMake(30+6,MY_MACRO_NAME? 6:12,206-5,58/2)];
    //[[_searchbar.subviews objectAtIndex:0]removeFromSuperview];
    _searchbar.delegate=self;
    [_searchbar becomeFirstResponder];
    _searchbar.font=[UIFont systemFontOfSize:12.f];
    _searchbar.placeholder=@"输入关键词";
    _searchbar.returnKeyType=UIReturnKeySearch;
    // _searchbar.barStyle = UIBarStyleBlack;
    _searchbar.userInteractionEnabled = TRUE;
    [ImgV_ofsearch addSubview:_searchbar];
    
    
    
    UIView *selectview=[[UIView alloc]initWithFrame:CGRectMake(0,IOS_VERSION>=7?64: 44, 320, 44)];
    selectview.backgroundColor=RGBACOLOR(247, 247, 247, 1);
    [searchheaderview addSubview:selectview];
    mysegment=[[CustomSegmentView alloc]initWithFrame:CGRectMake(12, (44-28.5)/2, 296, 57/2)];
    [mysegment setAllViewWithArray:[NSArray arrayWithObjects:@"ios7_newsunselect.png",@"ios7_bbsunselect.png",@"ios7_userunselect.png", @"ios7_newsselected.png",@"ios7_bbsselected.png",@"userselected.png",nil]];
    [mysegment settitleWitharray:[NSArray arrayWithObjects:@"帖子",@"版块",@"用户", nil]];
    // mysegment.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"segbackground.png"]];
    [selectview addSubview:mysegment];
    mysegment.delegate=self;
    
    UIImageView *imgvline=[[UIImageView alloc]initWithFrame:CGRectMake(0, MY_MACRO_NAME?64:44, 320, 1)];
    imgvline.image=[UIImage imageNamed:@"line-2.png"];
    [searchheaderview addSubview:imgvline];
    
    
    
    cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(517/2, 6, 320-517/2, 61/2)];
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.userInteractionEnabled=YES;
    //  [ cancelButton setBackgroundImage:[UIImage imageNamed:@"searchcancell.png"] forState:UIControlStateNormal];
    [cancelButton setTitle:@"搜索"  forState:UIControlStateNormal];//文字
    
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(searchcancell) forControlEvents:UIControlEventTouchUpInside];
    [ImgV_ofsearch addSubview:cancelButton];
    
    
    
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,IOS_VERSION>=7?108: 88,320,(iPhone5?568:480)-(IOS_VERSION>=7?108:88)) style:UITableViewStylePlain];
    
    _myTableView.delegate = self;
    
    _myTableView.dataSource = self;
    
    [self.view addSubview:_myTableView];
    
    
    searchloadingview =[[LoadingIndicatorView alloc]initWithFrame:CGRectMake(0, 900, 320, 40)];
    searchloadingview.backgroundColor=[UIColor clearColor];
    searchloadingview.normalLabel.text=@"上拉加载更多";
    
    _myTableView.tableFooterView = searchloadingview;
}


#pragma mark - 消失 ------------- 现在是navigation推过来的 所以这里是搜索

-(void)searchcancell
{
    //    [request_search clearDelegatesAndCancel];
    //
    //    [self dismissViewControllerAnimated:YES completion:NULL];
    
    [self searchbythenetework];
    
}


#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array_searchresault.count;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (mysegment.currentPage == 2)//用户
    {
        return 70;
        
    }else{
            
        NSDictionary *dic_ssinfo =[self.array_searchresault objectAtIndex:indexPath.row];
        
        NSString *string__tcon=[NSString stringWithFormat:@"%@",[dic_ssinfo objectForKey:@"content"]];
        CGSize constraintSize = CGSizeMake(310, MAXFLOAT);
        CGSize labelSize = [string__tcon sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        return     30+labelSize.height+5+23;
        
        
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString * identifier = @"cell";
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        
        for (UIView * view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSDictionary *dic_ssinfo =[self.array_searchresault objectAtIndex:indexPath.row];
        switch (mysegment.currentPage){
            case 0://帖子
            {
                SearchNewsView *_search_news=[[SearchNewsView alloc]init];
                [_search_news layoutSubviewsWithDicNewsinfo:dic_ssinfo];
                [cell.contentView addSubview:_search_news];
            }
                break;
            case 1:
            {
#pragma mark - 版块===== tableviewcell自定义cell 已修改
//                SearchNewsView *_search_news=[[SearchNewsView alloc]init];
//                [_search_news layoutSubviewsWithDicNewsinfo:dic_ssinfo];
                
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 40)];
                titleLabel.text = [dic_ssinfo objectForKey:@"name"];
                [cell.contentView addSubview:titleLabel];
                
            }
                break;
                
            case 2:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                //                    cell.contentView.backgroundColor = RGBCOLOR(248,248,248);
                cell.backgroundColor = [UIColor clearColor];
                
                PersonInfo * info = [_array_searchresault objectAtIndex:indexPath.row];
                
                AsyncImageView * imagetouxiang=[[AsyncImageView alloc]initWithFrame:CGRectMake(5, 10,50 , 50)];
                
                imagetouxiang.layer.cornerRadius = 5;
                imagetouxiang.layer.borderColor = (__bridge  CGColorRef)([UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1]);
                imagetouxiang.layer.borderWidth =1.0;
                imagetouxiang.layer.masksToBounds = YES;
                
                [imagetouxiang loadImageFromURL:info.face_original withPlaceholdImage:[personal getImageWithName:@"touxiang"]];
                
                [cell.contentView addSubview:imagetouxiang];
                
                UILabel * label_username=[[UILabel alloc]initWithFrame:CGRectMake(70,10,200, 20)];
                label_username.text = info.username;
                label_username.backgroundColor = [UIColor clearColor];
                label_username.font = [UIFont systemFontOfSize:18];
                [cell.contentView addSubview:label_username];
                
                NSString * location = info.city;
                if (info.city.length == 0||[info.city isEqualToString:@"(null)"]){
                    location = @"未知";
                }
                
                UILabel * label_location=[[UILabel alloc]initWithFrame:CGRectMake(70, 40, 200, 20)];
                label_location.text = [NSString stringWithFormat:@"所在地:%@",location];
                label_location.font = [UIFont systemFontOfSize:13];
                label_location.backgroundColor = [UIColor clearColor];
                label_location.textColor = RGBCOLOR(137,137,137);
                [cell.contentView addSubview:label_location];
                
            }
                
            default:
                break;
        }
    
        return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.array_searchresault.count>0)
    {
        NSDictionary *dicinfoofsearchresault=[self.array_searchresault objectAtIndex:indexPath.row];
        switch (mysegment.currentPage)
        {
            case 0://帖子
            {
                bbsdetailViewController *_bbsdetail=[[bbsdetailViewController alloc]init];
                _bbsdetail.bbsdetail_tid=[NSString stringWithFormat:@"%@",[dicinfoofsearchresault objectForKey:@"tid"]];
                [self.navigationController pushViewController:_bbsdetail animated:YES];
                
            }
                break;
            case 1:
            {
#pragma mark - 版块========== cellDidSelect方法 跳转版块详细页
//                newsdetailViewController *newsDe=[[newsdetailViewController alloc]init];
//                newsDe.string_Id=[NSString stringWithFormat:@"%@",[dicinfoofsearchresault objectForKey:@"tid"]];
//                //                [self.leveyTabBarController hidesTabBar:YES animated:YES];
//                [self.navigationController pushViewController:newsDe animated:YES];//跳入下一个View
                BBSfenduiViewController *bbsDvc = [[BBSfenduiViewController alloc]init];
                bbsDvc.string_id = [dicinfoofsearchresault objectForKey:@"fid"];
                [self.navigationController pushViewController:bbsDvc animated:YES];
                
                
            }
                break;
            case 2:
            {
                PersonInfo * info = [_array_searchresault objectAtIndex:indexPath.row];
                [self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];
                
                //                [self.leveyTabBarController hidesTabBar:YES animated:YES];
                
                NewMineViewController * mine = [[NewMineViewController alloc] init];
                mine.uid = info.uid;
                //                    mine.isPop = YES;
                if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_IN])
                {
                    [self.navigationController pushViewController:mine animated:YES];
                    
                    
                }else{
                    logIn = [LogInViewController sharedManager];
                    
                    [self presentViewController:logIn animated:YES completion:NULL];
                }
                
            }
                break;
            
                
                
            default:
                break;
        }
    }
    
}





#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    
    if(scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height+40) && scrollView.contentOffset.y > 0)
    {
        if (issearchloadsuccess==NO&&_searchbar.text.length>0) {
            
            issearchloadsuccess=!issearchloadsuccess;
            mysearchPage++;
            if (mysegment.currentPage==2)
            {
                if (search_user_page*20>=total_count_users)
                {
                    searchloadingview.normalLabel.text = @"没有更多了";
                    return;
                }
                
                search_user_page++;
            }else{
                
            }
            
            [self searchbythenetework];
            [searchloadingview startLoading];
        }
        
    }
    
    
}


#pragma mark-search取数据

-(void)searchbythenetework
{
    switch (mysegment.currentPage)
    {
        case 0://帖子
        {
            
            NSLog(@"点击的是帖子");
            string_searchurl=[NSString stringWithFormat:@"http://so.fblife.com/api/searchapi.php?query=%@&fromtype=%d&pagesize=10&formattype=json&charset=utf8&page=%d",[_searchbar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],1,mysearchPage];
            
            
            
        }
            break;
        case 1://版块
        {
            
#pragma mark - 版块===已修改
            
//            NSLog(@"点击的是资讯");
//            string_searchurl=[NSString stringWithFormat:@"http://so.fblife.com/api/searchapi.php?query=%@&fromtype=%d&pagesize=10&formattype=json&charset=utf8&page=%d",[_searchbar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],2,mysearchPage];
            
            NSLog(@"点击的是版块");
           string_searchurl = [NSString stringWithFormat: @"http://bbs.fblife.com/bbsapinew/searchforums.php?sk=%@&formattype=json",[_searchbar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
           
        }
            break;
        case 2:
        {
            
            NSLog(@"点击的是用户");
            string_searchurl=[NSString stringWithFormat:URL_SERCH_USER,[_searchbar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],search_user_page];
            
        }
            break;
       
            
        default:
            break;
    }
    
    
    NSLog(@"1请求的url = %@",string_searchurl);

    if (request_search) {
        [request_search cancel];
        request_search.delegate = nil;
        request_search = nil;
    }
    
    
    request_search = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:string_searchurl]];
    __block ASIHTTPRequest * _requset = request_search;
    
    _requset.delegate = self;
    [_requset setTimeOutSeconds:120];
    
    [_requset setCompletionBlock:^{
        
        
        @try {
            [searchloadingview stopLoading:1];
            issearchloadsuccess=NO;
            if (mysearchPage==1)
            {
                [self.array_searchresault removeAllObjects];
            }
            
            NSDictionary * dicofsearch = [request_search.responseData objectFromJSONData];
            
            NSLog(@"搜索的信息 -=-=  %@",dicofsearch);
            
            if (mysegment.currentPage == 2)
            {
                
                NSString * errcode = [NSString stringWithFormat:@"%@",[dicofsearch objectForKey:@"errcode"]];
                
                [searchloadingview stopLoading:1];
                
                int the_count = [[dicofsearch objectForKey:@"count"] intValue];
                
                if (the_count == 0)
                {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未找到该用户,请检查用户名是否正确" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
                    
                    [alert show];
                    
                    return;
                }
                
                if ([errcode intValue]==0)
                {
                    NSDictionary * dic111 = [dicofsearch objectForKey:@"data"];
                    
                    total_count_users = [[dicofsearch objectForKey:@"count"] intValue];
                    
                    NSArray * allkeys = [dic111 allKeys];
                    
                    if (search_user_page ==1)
                    {
                        if (total_count_users/20 == 0)
                        {
                            searchloadingview.normalLabel.text = @"没有更多了";
                        }
                        
                        [array_search_user removeAllObjects];
                        [_array_searchresault removeAllObjects];
                        
                        self.myTableView.contentOffset = CGPointMake(0,0);
                        
                    }else
                    {
                        
                    }
                    
                    
                    for (int i = 0;i < allkeys.count;i++)
                    {
                        NSDictionary * myDic = [dic111 objectForKey:[allkeys objectAtIndex:i]];
                        
                        PersonInfo * info2 = [[PersonInfo alloc] initWithDictionary:myDic];
                        
                        info2.face_original = [dic111 objectForKey:@"small_avatar"];
                        
                        info2.city = [NSString stringWithFormat:@"%@",[dicofsearch objectForKey:@"location"]];
                        
                        if (info2.username.length !=0)
                        {
                            [_array_searchresault addObject:info2];
                            [array_search_user addObject:info2];
                        }
                    }
                    
                    [self.myTableView reloadData];
                    
                    return;
                    
                }else
                {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未找到该用户,请检查用户名是否正确" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
                    
                    [alert show];
                    
                    
                    
                    return;
                }
                
                
            }
            
#pragma mark - #pragma mark - 版块搜索返回的数据装到 self.array_searchresault 数组里====
            if (mysegment.currentPage == 1) {//版块
                
                NSArray *arr = [dicofsearch objectForKey:@"bbsinfo"];
                
                if ([arr isKindOfClass:[NSArray class]]) {
                    
                    if (arr.count >0) {
                        
                        [self.array_searchresault addObjectsFromArray:[dicofsearch objectForKey:@"bbsinfo"]];
                        
                    }
                }
                
                [array_search_bankuai removeAllObjects];
                [array_search_bankuai addObjectsFromArray:self.array_searchresault];
                
                [self.myTableView reloadData];
                return;
            }
            
            
#pragma mark - 除了版块搜索之外的搜索
            if (dicofsearch.count>0) {
                
                if ([[dicofsearch objectForKey:@"allnumbers"] integerValue]>0) {
                    
                    [self.array_searchresault addObjectsFromArray:[dicofsearch objectForKey:@"searchinfo"]];
                    NSLog(@"是有数据的");
                    
                    
                }else{
                    NSLog(@"没有相关数据");
                    
                    if (mysegment.currentPage==0) {//帖子
                        
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未找到相关的帖子信息" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
                        
                        [alert show];
                    }
                    if (mysegment.currentPage==1) {
#pragma mark - 版块==== 已修改
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未找到相关的版块信息" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
                        
                        [alert show];
                    }
                    return;
                }
            }
            
            if (mysegment.currentPage == 0)//帖子
            {
                
                [array_search_bbs removeAllObjects];
                [array_search_bbs addObjectsFromArray:self.array_searchresault];
                
                
            }else if (mysegment.currentPage==1){
#pragma mark - 版块====== 已修改  以为版块接口返回的数据类型和 用户 帖子不同 所以 这里不会走的 上面有判断currentPage == 1 的时候有数据 赋值后 直接return了
                [array_search_bankuai removeAllObjects];
                [array_search_bankuai addObjectsFromArray:self.array_searchresault];
                
            }else if (mysegment.currentPage==2)
            {
                [array_search_user removeAllObjects];
                [array_search_user addObjectsFromArray:self.array_searchresault];
            }
            
            NSLog(@"self.array_searchresault===%@",self.array_searchresault);
            
            
            [self.myTableView reloadData];
            //        }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }];
    
    
    [_requset setFailedBlock:^{
        
        [request_search cancel];
        
        
        //        [self initHttpRequestInfomation];
    }];
    
    [_requset startAsynchronous];
}




-(void)getWeiBoSearchData:(NSDictionary *)dic11111
{
    if ([[dic11111 objectForKey:@"errcode"] intValue]!=0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未找到相关的微博信息" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
        
        [alert show];
        return;
    }
    
    NSDictionary * rootObject = [[NSDictionary alloc] initWithDictionary:dic11111];
    
    NSString *errcode =[NSString stringWithFormat:@"%@",[rootObject objectForKey:ERRCODE]];
    
    if ([@"0" isEqualToString:errcode])
    {
        NSDictionary* userinfo = [rootObject objectForKey:@"weiboinfo"];
        
        if ([userinfo isEqual:[NSNull null]])
        {
            
            if (mysearchPage == 1)
            {
                //如果没有微博的话
                NSLog(@"------------没有微博信息---------------");
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未找到相关的微博信息" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
                
                [alert show];
                
                return;
            }else
            {
                searchloadingview.normalLabel.text = @"没有更多了";
            }
            
        }else
        {
            NSMutableArray * temp_array =  [zsnApi conversionFBContent:userinfo isSave:NO WithType:0];
            
            [self.array_searchresault addObjectsFromArray:temp_array];
            
            [weibo_search_data addObjectsFromArray:temp_array];
            
            [self.myTableView reloadData];
        }
    }
}




#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self WhetherOrNotRequest];
    return YES;
}


-(void)WhetherOrNotRequest
{
    mysearchPage=1;
    issearchloadsuccess=NO;
    
    if (_searchbar.text.length>0)
    {
        [_searchbar resignFirstResponder];
        
        [request_search cancel];
        
        request_search.delegate = nil;
        
        request_search=nil;
        
        if ([_searchbar.text isEqualToString:[array_cache objectAtIndex:mysegment.currentPage]])
        {
            [self.array_searchresault removeAllObjects];
            NSLog(@"------%d",array_search_bankuai.count);
            if (mysegment.currentPage ==1 && array_search_bankuai.count != 0)
            {
#pragma mark - 版块===== 已修改
                [self.array_searchresault addObjectsFromArray:array_search_bankuai];
                [self.myTableView reloadData];
                
            }else if (mysegment.currentPage ==0 && array_search_bbs.count != 0){//帖子
                
                [self.array_searchresault addObjectsFromArray:array_search_bbs];
                
                [self.myTableView reloadData];
                
            }else if (mysegment.currentPage ==2 && array_search_user.count != 0)
            {
                [self.array_searchresault addObjectsFromArray:array_search_user];
                
                [self.myTableView reloadData];
            }else
            {
                
                [self searchbythenetework];
            }
            
        }else
        {
            
            [self searchbythenetework];
        }
        
        [array_cache replaceObjectAtIndex:mysegment.currentPage withObject:_searchbar.text];
    }
    
}




#pragma mark-自定义segment的代理
-(void)buttonClick:(int)buttonSelected
{
    if (buttonSelected != current_select)
    {
        [_array_searchresault removeAllObjects];
        [self.myTableView reloadData];
    }
    
    current_select = buttonSelected;
    
    [searchloadingview startLoading];
    
    [self WhetherOrNotRequest];
}




#pragma mark-NewWeiBoCustomCellDelegate


-(void)LogIn
{
    logIn = [LogInViewController sharedManager];
    
    [self presentViewController:logIn animated:YES completion:NULL];
}



-(void)showOriginalWeiBoContent:(NSString *)theTid
{
    BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
    
    if (!isLogIn)
    {
        [self LogIn];
        return;
    }
    
    NSString *authkey=[[NSUserDefaults standardUserDefaults] objectForKey:USER_AUTHOD];
    NSString * fullURL= [NSString stringWithFormat:@"http://fb.fblife.com/openapi/index.php?mod=getweibo&code=content&tid=%@&fromtype=b5eeec0b&authkey=%@&page=1&fbtype=json",theTid,authkey];
    
    NSLog(@"1请求的url = %@",fullURL);
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullURL]];
    
    __block ASIHTTPRequest * _requset = request;
    
    _requset.delegate = self;
    
    [_requset setCompletionBlock:^{
        
        @try
        {
            NSDictionary * dic111 = [request.responseData objectFromJSONData];
            NSLog(@"个人信息 -=-=  %@",dic111);
            
            NSString *errcode =[NSString stringWithFormat:@"%@",[dic111 objectForKey:ERRCODE]];
            
            if ([@"0" isEqualToString:errcode])
            {
                NSDictionary * userInfo = [dic111 objectForKey:@"weiboinfo"];
                
                if ([userInfo isEqual:[NSNull null]])
                {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该篇微博不存在" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
                    [alert show];
                    
                    return;
                }else
                {
                    FbFeed * obj = [[FbFeed alloc]init];
                    
                    obj.tid = theTid;
                    
                    obj = [[zsnApi conversionFBContent:userInfo isSave:NO WithType:0] objectAtIndex:0];
                    
                    NewWeiBoDetailViewController * detail = [[NewWeiBoDetailViewController alloc] init];
                    
                    detail.info=obj;
                    
                    [self.navigationController pushViewController:detail animated:YES];
                }
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }];
    
    
    [_requset setFailedBlock:^{
        
        [request cancel];
    }];
    
    [_requset startAsynchronous];
    
}

-(void)presentToFarwardingControllerWithInfo:(FbFeed *)info WithCell:(NewWeiBoCustomCell *)theCell
{
    
}

-(void)presentToCommentControllerWithInfo:(FbFeed *)info WithCell:(NewWeiBoCustomCell *)theCell
{
    
}


-(void)showVideoWithUrl:(NSString *)theUrl
{
    fbWebViewController * web = [[fbWebViewController alloc] init];
    
    web.urlstring = theUrl;
    
    [self.navigationController pushViewController:web animated:YES];
}


-(void)clickHeadImage:(NSString *)uid
{
    BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
    
    if (!isLogIn)
    {
        [self LogIn];
    }else
    {
        NewMineViewController * mine = [[NewMineViewController alloc] init];
        
        mine.uid = uid;
        
        [self.navigationController pushViewController:mine animated:YES];
    }
}


-(void)clickUrlToShowWeiBoDetailWithInfo:(FbFeed *)info WithUrl:(NSString *)theUrl isRe:(BOOL)isRe
{
    NSString * string = isRe?info.rsort:info.sort;
    
    NSString * sortId = isRe?info.rsortId:info.sortId;
    
    if ([string intValue] == 7 || [string intValue] == 6 || [string intValue] == 8)//新闻
    {
        newsdetailViewController * news = [[newsdetailViewController alloc] initWithID:sortId];
        [self setHidesBottomBarWhenPushed:YES];
        //        [self.leveyTabBarController hidesTabBar:YES animated:YES];
        [self.navigationController pushViewController:news animated:YES];
        [self setHidesBottomBarWhenPushed: NO];
        
    }else if ([string intValue] == 4 || [string intValue] == 5)//帖子
    {
        bbsdetailViewController * bbs = [[bbsdetailViewController alloc] init];
        bbs.bbsdetail_tid = sortId;
        if ([string intValue] == 5)
        {
            bbs.bbsdetail_tid = info.sortId;
        }
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:bbs animated:YES];
        [self setHidesBottomBarWhenPushed: NO];
        
    }else if ([string intValue] == 3)
    {
        BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
        if (isLogIn)
        {
            ImagesViewController * images = [[ImagesViewController alloc] init];
            images.tid = isRe?info.rphoto.aid:info.photo.aid;
            
            [self setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:images animated:YES];
            [self setHidesBottomBarWhenPushed:NO];
        }else{
            
            [self LogIn];
        }
        
        
    }else if ([string intValue] == 2)
    {
        
        WenJiViewController * wenji111 = [[WenJiViewController alloc] init];
        
        wenji111.bId = sortId;
        
        [self setHidesBottomBarWhenPushed:YES];
        //        [self.leveyTabBarController hidesTabBar:YES animated:YES];
        
        [self.navigationController pushViewController:wenji111 animated:YES];
        
        [self setHidesBottomBarWhenPushed:NO];
    }else
    {
        NewWeiBoDetailViewController * detail = [[NewWeiBoDetailViewController alloc] init];
        
        detail.info = info;
        
        [self setHidesBottomBarWhenPushed:YES];
        
        //        [self.leveyTabBarController hidesTabBar:YES animated:YES];
        
        [self.navigationController pushViewController:detail animated:YES];
        
        [self setHidesBottomBarWhenPushed:NO];
    }
}

-(void)showClickUrl:(NSString *)theUrl WithFBFeed:(FbFeed *)info;
{
    fbWebViewController *fbweb=[[fbWebViewController alloc]init];
    
    fbweb.urlstring = theUrl;
    
    [self.navigationController pushViewController:fbweb animated:YES];
}

-(void)showAtSomeBody:(NSString *)theUrl WithFBFeed:(FbFeed *)info
{
    NSLog(@"theUrl ------   %@",theUrl);
    BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
    
    if (!isLogIn)
    {
        [self LogIn];
    }else
    {
        NewMineViewController * people = [[NewMineViewController alloc] init];
        
        if ([theUrl rangeOfString:@"fb://PhotoDetail/id="].length)
        {
            people.uid = [theUrl stringByReplacingOccurrencesOfString:@"fb://PhotoDetail/id=" withString:@""];
        }else if([theUrl rangeOfString:@"fb://atSomeone@/"].length)
        {
            people.uid = [theUrl stringByReplacingOccurrencesOfString:@"fb://atSomeone@/" withString:@""];
        }else
        {
            people.uid = info.ruid;
        }
        
        [self.navigationController pushViewController:people animated:YES];
    }
}

-(void)showImage:(FbFeed *)info isReply:(BOOL)isRe WithIndex:(int)index
{
    NSString * sort = isRe?info.rsort:info.sort;
    [_photos removeAllObjects];
    
    if ([sort isEqualToString:@"3"])
    {
        BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
        if (!isLogIn)
        {
            [self LogIn];
            return;
        }
    }
    
    
    NSString * image_string = isRe?info.rimage_original_url_m:info.image_original_url_m;
    
    NSArray * array = [image_string componentsSeparatedByString:@"|"];
    
    for (NSString * string in array)
    {
        NSString * url_string = [string stringByReplacingOccurrencesOfString:@"_s." withString:@"_b."];
        [_photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:url_string]]];
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    browser.displayActionButton = YES;
    
    NSString * titleString = info.photo_title;
    
    browser.title_string = titleString;
    
    [browser setInitialPageIndex:index];
    
    //    [self.leveyTabBarController hidesTabBar:YES animated:YES];
    
    [self presentViewController:browser animated:YES completion:NULL];
}



#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return _photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
