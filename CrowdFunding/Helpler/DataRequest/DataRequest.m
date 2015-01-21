//
//  DataRequest.m
//  QDaily
//
//  Created by Frank on 14-7-20.
//  Copyright (c) 2014年 Frank. All rights reserved.
//

#import "DataRequest.h"
#import "CacheUtil.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "MyTapGestureRecognizer.h"

/**
 *  无网络视图的TAG
 */
static NSInteger kNoNetworkImageViewTag = 9999;

@implementation DataRequest

/**
 *  通过委托，初始化
 *
 *  @param delegate 委托的类
 *
 *  @return
 */
- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        
        UIView *view = [self progressView];
        if (view) {
            _HUD = [[MBProgressHUD alloc] initWithView:view];
            _HUD.labelText = @"正在加载...";
            _HUD.animationType = MBProgressHUDAnimationZoom;
            [view addSubview:_HUD];
        }
    }
    return self;
}

- (NSString *) getParamsKey:(NSDictionary *)params
{
    NSMutableString *mutabStr = [NSMutableString string];
    [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [mutabStr appendFormat:@"%@p%@",key,obj];
//        if ([key isEqualToString:@"page"]) {
//            [mutabStr appendString:[(NSNumber *)obj stringValue]];
//        }
        
    }];
    return mutabStr;
}

- (NSString *)getUrl2CachePathStr:(NSString *)url withParms:(NSDictionary *)parsms
{
    NSArray *array = [url componentsSeparatedByString:@"/"];
    NSString *cacheStr = [NSString stringWithFormat:@"%@_%@",[array objectAtIndex:array.count-2],[array objectAtIndex:array.count-1]];
    
//    
//    NSRange range = [url rangeOfString:@"/" options:NSBackwardsSearch];
//    NSString *cacheStr = [url substringFromIndex:range.location + range.length];
    
    NSString *paramsKey  =[self getParamsKey:parsms];
    if (paramsKey.length > 0) {
        cacheStr = [NSString stringWithFormat:@"%@%@",cacheStr,paramsKey];
    }
    return cacheStr;

}

/**
 *  发送请求
 *
 *  @param url          请求的URL
 *  @param params       请求参数
 *  @param successBlock 请求成功Block
 *  @param fail         请求失败Block
 */
- (void)sendRequestWithUrl:(NSString *)url params:(NSDictionary *)params success:(DataRequestSuccess)successBlock fail:(DataRequestFail)failBlock
{

    /**
     *  特殊处理 专题详情接口
     */
    if ([url containsString:@"topic/info"]) {
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        
    }else
    {
        //显示菊花
        [[self progressView] bringSubviewToFront:_HUD];
        [_HUD show:YES];
    }
    
    
    //这里是有BUG;
    //缓存
    NSString *cacheStr =[self getUrl2CachePathStr:url withParms:params];
    
    //缓存路径:
	_plistPath = [CacheUtil fileFullPathWithPath:cacheStr];
    //检查网络连接
    if (isNotReachable) {
        //没有网，从缓存中读取数据
        NSDictionary *itemCache = [CacheUtil getCacheDataFromFilePath:_plistPath];
        if (itemCache && [itemCache isKindOfClass:[NSDictionary class]]) {
            successBlock(itemCache);
//            if ([_delegate respondsToSelector:@selector(progressView)]) {
//                UIView *view = [_delegate progressView];
//                
//            }
            
            [GWXGlobalConfig HUDShowMessage:@"检查你的网络连接" addedToView:g_AppDelegate.window];

        }else{
            failBlock(@{@"errorType":@(DataRequestErrorTypeNoNet)});
            
            if ([_delegate respondsToSelector:@selector(progressView)]) {
                UIView *view = [_delegate progressView];
                if (view) {
                    UIImageView *noNetImageView = (UIImageView*)[view viewWithTag:kNoNetworkImageViewTag];
                    if (!noNetImageView) {
                        noNetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty_error_net"]];
                        noNetImageView.tag = kNoNetworkImageViewTag;
                        noNetImageView.center = view.center;
                        noNetImageView.contentMode = UIViewContentModeCenter;
                        noNetImageView.userInteractionEnabled = YES;
                        [view addSubview:noNetImageView];
                        
                        MyTapGestureRecognizer *tap = [[MyTapGestureRecognizer alloc] initWithTarget:self action:@selector(touchNoNetImageHandler:)];
                        [tap.userInfo setValue:url forKey:@"url"];
                        [tap.userInfo setValue:params forKey:@"params"];
                        [tap.userInfo setValue:successBlock forKey:@"successBlock"];
                        [tap.userInfo setValue:failBlock forKey:@"failBlock"];
                        
                        [noNetImageView addGestureRecognizer:tap];
                    }
                }
            }
        }
        [_HUD hide:YES];
        return;
    }
    
    UIView *view = [self progressView];
    if (view) {
        UIView *noNetImageView = [view viewWithTag:kNoNetworkImageViewTag];
        if (noNetImageView) {
            [noNetImageView removeFromSuperview];
        }
    }
    
    //数据请求
    NSArray *array = [url componentsSeparatedByString:SYMBOL];
    if (array.count > 1) {
        //请求的URL
        NSString *requestUrl = array[1];
        NSString *method = array[0];
        
        __block MBProgressHUD *hud = _HUD;
        __block NSString *plistPath = _plistPath;
        
        //请求成功的block
        AFHTTPRequestSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject)
        {
            [hud hide:YES];
            NSLog(@"responseObject:%@",responseObject);

            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *item = responseObject;
                NSInteger status =[item[@"status"] integerValue];
                if (status == 1) {
                    [CacheUtil cacheData:responseObject toFilePath:plistPath];
                    if (successBlock) {
                        successBlock(responseObject);
                    }
                }else{
                    if (status == 100001) {
                        [[UserInfo currUserInfo] clear];
                        [GWXGlobalConfig HUDShowMessage:@"请重新登录"];
                    }
                    if (failBlock) {
                        failBlock(@{@"status":item[@"status"],@"errorType":@(DataRequestErrorTypeServerError), @"errorInfo":@{@"msg":item[@"msg"]}});
                    }
                }
            }
        };

        //请求失败的block
        AFHTTPRequestRequestFail fail = ^(AFHTTPRequestOperation *operation, NSError *error)
        {
            [hud hide:YES];
            if (failBlock) {
                failBlock(@{@"errorType":@(DataRequestErrorTypeServerError), @"errorInfo":error.userInfo});
            }
            MYLog(@"Request: %@, Error: %@", requestUrl, error);
        };
        NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithDictionary:params];
        [item setValue:client_id forKey:@"client_id"];
        [item setValue:client_secret forKey:@"client_secret"];
        [item setValue:KApp_Version forKey:@"app_versions"];
        [item setValue:KSYSTEMVERSION forKey:@"os_versions"];

        [item setValue:[NSNumber numberWithInt:1] forKey:@"v"];
        
        NSString *userID = [UserInfo currUserInfo].user_id;
        NSString *access_token = [UserInfo currUserInfo].access_token;
        if (access_token) {
            [item setValue:access_token forKey:@"oauth_token"];
        }
        if (userID) {
            [item setValue:userID forKey:@"track_user_id"];
        }
        NSLog(@"request: %@",[self getURLParams:requestUrl andParams:item]);

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        if ([method isEqualToString:@"GET"]) {
            [manager GET:requestUrl parameters:item success:success failure:fail];
        }else if ([method isEqualToString:@"POST"]){
            [manager POST:requestUrl parameters:item success:success failure:fail];
        }
    }
}

- (NSString *)getURLParams:(NSString *)url andParams:(NSDictionary *)item
{
    //URL
    NSMutableString *URL = [NSMutableString stringWithFormat:@"%@",url];
    //获取字典的所有keys
    NSArray * keys = [item allKeys];
    NSArray * values = [item allValues];

    //拼接字符串
    for (int j = 0; j < keys.count; j ++)
    {
        NSString *string;
        if (j == 0)
        {
            //拼接时加？
            string = [NSString stringWithFormat:@"?%@=%@", keys[j], values[j]];
            
        }
        else
        {
            //拼接时加&
            string = [NSString stringWithFormat:@"&%@=%@", keys[j], values[j]];
        }
        //拼接字符串
        [URL appendString:string];
        
    }
    
    return URL;
}

- (void)touchNoNetImageHandler:(MyTapGestureRecognizer*)gesture
{
    NSDictionary *item = gesture.userInfo;
    
    [self sendRequestWithUrl:item[@"url"] params:item[@"params"] success:item[@"successBlock"] fail:item[@"failBlock"]];
}

- (UIView*)progressView
{
    //如果委托类实现了方法，初始化菊花视图
    if ([_delegate respondsToSelector:@selector(progressView)]) {
        UIView *view = [_delegate progressView];
        return view;
    }
    return nil;
}

@end
