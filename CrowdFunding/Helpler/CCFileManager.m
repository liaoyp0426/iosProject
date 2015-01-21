//
//  CCFileManager.m
//  BanTang
//
//  Created by liaoyp on 14/12/24.
//  Copyright (c) 2014年 JiuZhouYunDong. All rights reserved.
//

#import "CCFileManager.h"

@implementation CCFileManager

+(void)createDocumentPath:(NSString *)strPath
{
    NSString *strPath2 = [self getFilePathWithFileName:strPath];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error;
    if (![self isExitFileName:strPath2]) {
        [manager createDirectoryAtPath:strPath2 withIntermediateDirectories:YES attributes:nil error:&error];
    }
}


+(NSString *)getFilePathWithFileName:(NSString *)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:fileName];
    
}

+(BOOL)isExitFileName:(NSString *)fileName{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL exist = [manager fileExistsAtPath:fileName];
    return exist;
}
+(BOOL)deleteFilePath:(NSString *)fileName{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *strPath = [self getFilePathWithFileName:fileName];
    NSLog(@"strPath is %@",strPath);
    
    BOOL flag = NO;
    if ([self isExitFileName:strPath]) {
        
        flag = [manager removeItemAtPath:strPath error:nil];
        
    }
    return flag;
}

@end
