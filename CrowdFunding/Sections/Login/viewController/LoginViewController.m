//
//  LoginViewController.m
//  CrowdFunding
//
//  Created by liaoyp on 15/1/22.
//  Copyright (c) 2015年 CF. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titleLabel.text  = @"登录";
    [self createCompletebuttonwithAction:@selector(goBack) withTitle:@"设置"];
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
