//
//  CacheUtil.m
//  QuickWatch
//
//  Created by Frank on 14-6-16.
//  Copyright (c) 2014年 Frank. All rights reserved.
//

#import "CacheUtil.h"

@implementation CacheUtil

+ (NSString *)fileFullPathWithPath:(NSString*)pathName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *pathURL = [fileManager URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", [pathURL path], @"Caches"];
    BOOL ui;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&ui])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *plistPath = [NSString stringWithFormat:@"%@/%@.plist",filePath, pathName];
    
    return plistPath;
}

+ (void)cacheData:(NSDictionary *)item toFilePath:(NSString *)filePath
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:item];
    [data writeToFile:filePath atomically:YES];
}

+ (NSDictionary *)getCacheDataFromFilePath:(NSString *)filePath
{
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return item;
}


+ (NSArray *)getArrayCacheFromFilePath:(NSString *)filePath
{
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return item;
}


+ (void)cacheArrayData:(NSArray *)item toFilePath:(NSString *)filePath
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:item];
    [data writeToFile:filePath atomically:NO];
}

@end
