//
//  CacheUtil.h
//  QuickWatch
//
//  Created by Frank on 14-6-16.
//  Copyright (c) 2014年 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheUtil : NSObject

+ (NSString *)fileFullPathWithPath:(NSString*)pathName;

+ (void)cacheData:(NSDictionary *)item toFilePath:(NSString *)filePath;

+ (NSDictionary *)getCacheDataFromFilePath:(NSString *)filePath;

+ (NSArray *)getArrayCacheFromFilePath:(NSString *)filePath;

+ (void)cacheArrayData:(NSArray *)item toFilePath:(NSString *)filePath;

@end
