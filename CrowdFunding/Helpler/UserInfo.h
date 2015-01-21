//
//  UserInfo.h
//  CloudStudy
//
//  Created by zhiminglantai on 14-4-10.
//  Copyright (c) 2014年 ZXY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface UserInfo : BaseModel

/*
 "access_token" = 3e5dfdf187fcfd57bb3e1b8855213479;
 avatar = "";
 "expires_in" = 3153600000;
 nickname = "";
 "user_id" = 10241;
 username = "";

 */

@property(nonatomic,strong)  NSString    *user_id;          //用户ID
@property(nonatomic,strong)  NSString    *nickname;         //用户名
@property(nonatomic,strong)  NSString    *avatar;           //头像地址
@property(nonatomic,strong)  NSString    *access_token;     //
@property(nonatomic,strong)  NSString    *username;         //用户手机号码
@property(nonatomic,strong)  NSString    *expires_in;         //用户手机号码

/**
 *  是否是最新的
 */
@property(nonatomic,strong) NSMutableSet *topicNewFlag;

+(instancetype)currUserInfo;

- (void)clear;
- (BOOL)isLogin;
- (void)saveUserInfo;

@end
