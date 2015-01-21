//
//  CCFileManager.h
//  BanTang
//
//  Created by liaoyp on 14/12/24.
//  Copyright (c) 2014年 JiuZhouYunDong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCFileManager : NSObject

+(void)createDocumentPath:(NSString *)strPath;

+(NSString *)getFilePathWithFileName:(NSString *)fileName;

+(BOOL)isExitFileName:(NSString *)fileName;

+(BOOL)deleteFilePath:(NSString *)fileName;

@end;