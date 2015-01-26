//
//  LoginViewController.m
//  CrowdFunding
//
//  Created by liaoyp on 15/1/22.
//  Copyright (c) 2015年 CF. All rights reserved.
//

#import "LoginViewController.h"
#import "PullToRefreshCoreTextView.h"
#import "UIScrollView+PullToRefreshCoreText.h"

@interface LoginViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@end

@implementation LoginViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isNeedBackButton= YES;
        _isNeedNavigationBar = YES;

    }
    return self;
}

- (UITableView *)TableView
{
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titleLabel.text  = @"登录";
    [self createCompletebuttonwithAction:@selector(goBack) withTitle:@"设置"];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UIWidth, UIHeight-64) style:UITableViewStylePlain];
//    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);
    _tableView.delegate = self;
    _tableView.dataSource  = self;
    [self.view insertSubview:_tableView belowSubview:_headerView];
    
    __weak typeof(self) weakSelf = self;

    [_tableView addPullToRefreshWithPullText:@"C\'est La Vie" pullTextColor:NavigationBarBGColor pullTextFont:FONT(16) refreshingText:@"La vie est belle" refreshingTextColor:NavigationBarBGColor refreshingTextFont:FONT(16) action:^{
    
        AFTER(3, ^{
            [GWXGlobalConfig HUDShowMessage:@"3米纳后执行"];
            [weakSelf.TableView finishLoading];
        });
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    static int temp = 0;

    CGFloat c=  _tableView.contentSize.height - _tableView.frame.size.height+64+20;
    NSLog(@" ----->%f",c)

    if (scrollView.contentOffset.y>0 && scrollView.contentOffset.y - temp > 0) {
         NSLog(@" ----->%f",scrollView.contentOffset.y)
        [UIView animateWithDuration:0.5f animations:^{
            
            _headerView.alpha = 0;
            _headerView.frame = CGRectMake(0, 0, UIWidth, 0);
            _titleLabel.frame = CGRectMake(0, -20, UIWidth, 64);

            CGRect rect =CGRectOffset(_tableView.frame, 0, 0);
            if (rect.origin.y != 20) {
                rect.origin.y = 20;
                _tableView.frame  =rect;
            }
            
        }];
        temp = scrollView.contentOffset.y;
        
    }else if ( scrollView.contentOffset.y - temp < 0 && temp< c ){
          NSLog(@" <-----%f",scrollView.contentOffset.y)
       

        [UIView animateWithDuration:0.5f animations:^{
            
            _headerView.alpha = 1;
            _headerView.frame = CGRectMake(0, 0, UIWidth, 64);
            _titleLabel.frame = CGRectMake(0, 10, UIWidth, 64);


            CGRect rect =CGRectOffset(_tableView.frame, 0, 0);
            if (rect.origin.y != 64) {
                rect.origin.y =  64;
                _tableView.frame  =rect;
            }
        
        }];
        temp = scrollView.contentOffset.y;
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text  =[NSString stringWithFormat:@"%ld---%ld",(long)indexPath.section,(long)indexPath.row];
    
    return cell;
}

- (void)goBack
{
    
    [self.navigationController pushViewController:[BaseViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
