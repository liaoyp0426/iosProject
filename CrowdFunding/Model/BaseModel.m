//
//  BaseModel.m
//  BanTang
//
//  Created by liaoyp on 14/12/19.
//  Copyright (c) 2014年 JiuZhouYunDong. All rights reserved.
//

#import "BaseModel.h"
#import <objc/message.h>
#import <objc/runtime.h>

#define SuperclassField @[@"description", @"hash", @"superclass", @"debugDescription"]

#if NS_BLOCKS_AVAILABLE
typedef void (^ConfigBlock)(NSString *property, NSString *value);
#endif

@implementation BaseModel


#pragma mark
#pragma mark super

- (id)initWithDictionary:(NSDictionary *)item
{
    self = [super init];
    if (self) {
        [self configDataValue:^(NSString *property, NSString *value) {
            if (item[property]) {
                [self setValue:item[property] forKey:property];
            }
        }];
    }
    return self;
}

/**
 *  转换成字典类型
 *
 *  @return 字典
 */
- (NSMutableDictionary*)toDictionary
{
    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
    [self configDataValue:^(NSString *property, NSString *value) {
        if (value) {
            [item setObject:value forKey:property];
        }
    }];
    return item;
}

- (NSString*)descriptions
{
    NSMutableString *str = [[NSMutableString alloc] init];
    
    [str appendFormat:@"\n ========= %@ ========= \n", NSStringFromClass(self.class)];
    
    [self configDataValue:^(NSString *property, NSString *value) {
        [str appendFormat:@" \n %@ : %@ \n", property, value];
    }];
    
    [str appendString:@"\n ========= End ========= \n"];
    
    return str;
}


#pragma mark
#pragma mark private
/**
 *  遍历当前类，获取每个属性和属性的值
 *
 *  @param block
 */
- (void)configDataValue:(ConfigBlock)block
{
    unsigned int outCount, i;
    //得到属性的数量
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        //属性名字
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
        if ([SuperclassField indexOfObject:propName] != NSNotFound) {
            continue;
        }
        //属性值
        NSString *value = [self valueForKey:propName];
        block(propName, value);
    }
    free(properties);
}


#pragma mark
#pragma mark NSCoding delegate

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self configDataValue:^(NSString *property, NSString *value) {
            if ([aDecoder decodeObjectForKey:property]) {
                [self setValue:[aDecoder decodeObjectForKey:property] forKey:property];
            }
        }];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self configDataValue:^(NSString *property, NSString *value) {
        [aCoder encodeObject:value forKey:property];
    }];
}


@end

