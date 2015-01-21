//
//  URLRequestInterface.h
//  FollowMe
//
//  Created by liaoyp on 14-10-15.
//  Copyright (c) 2014年 liaoyp. All rights reserved.
//

//测试地址：http://bt.xueyuchen.com/
//线上地址：http://student.open.17gwx.com/

//#define DataRequestRootURL                  @"http://student.open.17gwx.com/"

/**
 *  测试地址
 */
//#define DataRequestRootURL                    @"http://bt.xueyuchen.com/"

/**
 *  线上地址
 */
#define DataRequestRootURL                    @"http://bantang.open.17gwx.com/"

#define SYMBOL @"#"

#define kConfigURL(url, method)             [NSString stringWithFormat:@"%@%@%@%@", method, SYMBOL, DataRequestRootURL, url]

/////////////////////////////////  START /////////////////////////////////////////////

/**
 *  首页接口
 */
// 专题列表
#define DataRequestTopicListURL             kConfigURL(@"topic/list",           @"GET")
// 专题详情
#define DataRequestTopicInfoURL             kConfigURL(@"topic/info",           @"GET")
// 帖子喜欢
#define DataRequestTopLikeURL               kConfigURL(@"like/add",             @"POST")
// 删除收藏
#define DataRequestTopdeleteURL             kConfigURL(@"like/delete",          @"POST")
// 用户登录授权
#define DataRequestUserOauthURL             kConfigURL(@"user/oauth",          @"POST")

// 所有喜欢的帖子
#define DataRequestLikeListURL              kConfigURL(@"like/list",            @"GET")

// 一件反馈
#define DataRequestFeedbackURL             kConfigURL(@"feedback/add",          @"POST")

// 设备激活接口
#define DataRequestDeviceActivationURL      kConfigURL(@"device/iosActivation", @"POST")

//用户登录注册

#define DataRequestLoginURL             kConfigURL(@"/user/login",          @"POST")
#define DataRequestRegisterURL             kConfigURL(@"/user/register",          @"POST")


/////////////////////////////////  END /////////////////////////////////////////////

