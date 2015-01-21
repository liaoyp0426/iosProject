//
//  DataRequest.h
//  FollowMe
//
//  Created by liaoyp on 14-10-15.
//  Copyright (c) 2014年 Frank. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "URLRequestInterface.h"

@class AFHTTPRequestOperationManager;
@class AFHTTPRequestOperation;

static NSInteger DataRequestPageSize = 20;

typedef NS_ENUM(NSInteger, DataRequestErrorType) {
    DataRequestErrorTypeNoNet,
    DataRequestErrorTypeTimeout,
    DataRequestErrorTypeServerError
};

typedef void(^DataRequestSuccess)(NSDictionary *item);
typedef void(^DataRequestFail)(NSDictionary *item);

typedef void (^AFHTTPRequestSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^AFHTTPRequestRequestFail)(AFHTTPRequestOperation *operation, NSError *error);

@protocol DataRequestDelegate <NSObject>
- (UIView*)progressView;
@end

/**
 *  数据请求类
 */
@class MBProgressHUD;
@interface DataRequest : NSObject
{
    /**
     *  委托
     */
    id<DataRequestDelegate> _delegate;
    /**
     *  缓存路径
     */
    NSString *_plistPath;
}

/**
 *  菊花类
 */
@property (nonatomic, strong) MBProgressHUD *HUD;
/**
 *  请求request实例
 */
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
/**
 *  通过委托，初始化
 *
 *  @param delegate 委托的类
 *
 *  @return
 */
- (id)initWithDelegate:(id<DataRequestDelegate>)delegate;

/**
 *  根据请求路径 和 请求参数 返回一个缓存的数据.
 *
 *  @param url    <#url description#>
 *  @param parsms <#parsms description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)getUrl2CachePathStr:(NSString *)url withParms:(NSDictionary *)parsms;

/**
 *  发送请求
 *
 *  @param url          请求的URL
 *  @param params       请求参数
 *  @param successBlock 请求成功Block
 *  @param fail         请求失败Block
 */
- (void)sendRequestWithUrl:(NSString *)url params:(NSDictionary *)params success:(DataRequestSuccess)successBlock fail:(DataRequestFail)failBlock;
@end
