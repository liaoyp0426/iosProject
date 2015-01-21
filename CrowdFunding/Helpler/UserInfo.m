//
//  UserInfo.m
//  CloudStudy
//
//  Created by zhiminglantai on 14-4-10.
//  Copyright (c) 2014年 ZXY. All rights reserved.
//

#import "UserInfo.h"
#import "CCFileManager.h"

@implementation UserInfo

+ (UserInfo *)currUserInfo
{
    static UserInfo *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        NSString *fileName = [CCFileManager getFilePathWithFileName:@"account"];
        sharedAccountManagerInstance =[NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
        if (sharedAccountManagerInstance) {
            if (!sharedAccountManagerInstance.topicNewFlag) {
                sharedAccountManagerInstance.topicNewFlag =[NSMutableSet setWithCapacity:10];
            }
        }else
        {
            sharedAccountManagerInstance = [[self alloc] init];
            sharedAccountManagerInstance.topicNewFlag =[NSMutableSet setWithCapacity:10];
        }
        
    });
    return sharedAccountManagerInstance;
}

- (void)saveUserInfo
{
    NSString *fileName = [self getAccoutFilePath];
    [NSKeyedArchiver archiveRootObject:self toFile:fileName];
}

- (NSString *) getAccoutFilePath
{
    return [CCFileManager getFilePathWithFileName:@"account"];
}

- (void)clear
{
    NSDictionary *user =[self toDictionary];
    [user enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![key isEqualToString:@"topicNewFlag"]) {
            [self setValue:nil forKey:key];
        }
    }];
//    NSString *fileName = @"account";
//    [CCFileManager deleteFilePath:fileName];
    
}

- (BOOL)isLogin
{
    return !IsEmpty(self.user_id);
}

#pragma mark 添加点赞

@end
