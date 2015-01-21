//
//  BaseViewController.m
//  FollowMe
//
//  Created by Frank on 14-8-22.
//  Copyright (c) 2014年 Frank. All rights reserved.
//
#import "UIImage+MJ.h"
#import "BaseViewController.h"
@interface BaseViewController ()
{
    
}
@end

@implementation BaseViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isNeedNavigationBar = YES;
        _isNeedTitleLabel = YES;
        _isNeedBackButton = NO;
        
        _extraDic = [NSMutableDictionary dictionaryWithCapacity:2];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _request = [[DataRequest alloc] initWithDelegate:self];
    
    
    self.view.backgroundColor = RGB(245, 245, 245);
    
    if (_isNeedNavigationBar) {
        [self configNavigationBar];
    }
    
    if (_isNeedTitleLabel) {
        [self configTitleLabel];
    }
    
    if (_isNeedBackButton) {
        [self configBackButton];
    }
   
}

- (void)addExtraData:(id)object forKey:(NSString *)key;
{
    if (object && key) {
        [_extraDic setObject:object forKey:key];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configNavigationBar
{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIWidth, HeadViewHeight)];
    _headerView.backgroundColor = PublicNavigationBgColor;
    [self.view addSubview:_headerView];
}

- (void)configTitleLabel
{
    CGFloat width = UIWidth-60;
    CGFloat height = 44;
    CGFloat x = 30;
    CGFloat y = (_headerView.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height - height) / 2;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _titleLabel.text = self.mTitle;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = FONT(18);
    _titleLabel.textColor = [UIColor whiteColor];
    [_headerView addSubview:_titleLabel];
}

- (void)configBackButton
{ //
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"public_back_btn"] forState:UIControlStateNormal];
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    backButton.frame = CGRectMake(0, 20, 44, 44);
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:backButton];
}

- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (UIButton *)createCompletebuttonwithAction:(SEL)action withIcon:(NSString *)iconName;
{
   
    CGFloat y = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat height = 44;
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeButton.frame = CGRectMake(UIWidth - 44-10, y, height, height);
    [completeButton setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    [completeButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:completeButton];
    
    return completeButton;
    
}

- (UIButton *)createCompletebuttonwithAction:(SEL)action withTitle:(NSString *)title
{
    UIButton *completeButton =[self createCompletebuttonwithAction:action];
    
    [completeButton setTitle:title forState:UIControlStateNormal];
    
    return completeButton;
    
}

- (UIButton *)createCompletebuttonwithAction:(SEL)action
{
    
    CGFloat y = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat height = 44;
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];

    completeButton.frame = CGRectMake(UIWidth - 44-10, y+25/2, height, 25);
    
    completeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [completeButton setBackgroundImage:[UIImage resizedImage:@"nar_r_btn_bg"] forState:UIControlStateNormal];
    [completeButton setBackgroundImage:[UIImage resizedImage:@"nar_r_btn_bg_pressed"] forState:UIControlStateHighlighted];
    [completeButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:completeButton];

    return completeButton;
    
}

- (void)showEmptyViewWithName:(NSString *)imageName withData:(NSArray *)array
{
    
    if ([array count] == 0 ) {
        
        if (_emptyImageView) {
            return;
        }
        UIImageView *imaegeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imaegeView.center =kP5;
        imaegeView.tag = 1095;
        [self.view addSubview:imaegeView];
        _emptyImageView = imaegeView;
    }else
    {
        [_emptyImageView removeFromSuperview];
        _emptyImageView = nil;
    }
}

- (void)showTableViewFootLogo:(UITableView *)_tableView
{
    
//    UIView *tableFooterView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIWidth, 10)];
//    tableFooterView.backgroundColor =[UIColor orangeColor];
//    [_tableView.tableFooterView removeFromSuperview];
     _tableView.tableFooterView =[UIView new];
    
    UIView *footView =[_tableView viewWithTag:1992];
    
    if (footView) {
        [footView removeFromSuperview];
    }
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIWidth, 44)];
    UIImageView *footlogoview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"footlogo"]];
    [footView addSubview:footlogoview];
    footlogoview.center = footView.center;
    footlogoview.tag = 1992;
    footView.frame = CGRectMake(0, _tableView.contentSize.height, UIWidth, 44);
    [_tableView addSubview:footView];
}


#pragma mark - DataRequest Delegate

- (UIView*)progressView
{
    return self.view;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
