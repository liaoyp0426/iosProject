//
//  BaseViewController.h
//  FollowMe
//
//  Created by Liaoyp on 14-8-22.
//  Copyright (c) 2014年 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataRequest.h"

@interface BaseViewController : UIViewController<DataRequestDelegate>
{
    UIView *_headerView;
    UILabel *_titleLabel;
    
    BOOL _isNeedNavigationBar;
    BOOL _isNeedTitleLabel;
    BOOL _isNeedBackButton;
    
    DataRequest *_request;
    
    NSMutableDictionary *_extraDic;
    
    UIImageView *_emptyImageView;
}

/**
 *  添加传递参数
 *
 *  @param extra <#extra description#>
 */
- (void)addExtraData:(id)object forKey:(NSString *)key;

- (UIButton *)createCompletebuttonwithAction:(SEL)action;
- (UIButton *)createCompletebuttonwithAction:(SEL)action withTitle:(NSString *)title;
- (UIButton *)createCompletebuttonwithAction:(SEL)action withIcon:(NSString *)iconName;

- (void)showEmptyViewWithName:(NSString *)imageName withData:(NSArray *)array;

- (void)showTableViewFootLogo:(UITableView *)tableview;

@property(nonatomic,strong) NSString *mTitle;

@property (nonatomic, strong) UIViewController *currentViewContrller;
@end
