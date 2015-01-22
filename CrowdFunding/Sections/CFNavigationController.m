//
//  CFNavigationController.m
//  CrowdFunding
//
//  Created by liaoyp on 15/1/22.
//  Copyright (c) 2015年 CF. All rights reserved.
//

#import "CFNavigationController.h"
#import "SloppySwiper.h"

@interface CFNavigationController ()<UIGestureRecognizerDelegate>

@property(nonatomic ,strong)SloppySwiper *swipper;

@end

@implementation CFNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
   id sender =[super initWithRootViewController:rootViewController];
    if (sender) {
        
        
    }
    return sender;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    
    self.swipper = [[SloppySwiper alloc] initWithNavigationController:self];
    self.delegate = self.swipper;
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
