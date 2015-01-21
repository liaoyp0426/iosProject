//
//  BaseModel.h
//  BanTang
//
//  Created by liaoyp on 14/12/19.
//  Copyright (c) 2014年 JiuZhouYunDong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Model的基类
 */
@interface BaseModel : NSObject<NSCoding>

/**
 *  model的ID
 */
@property (nonatomic, copy) NSString *modelId;


@property (nonatomic, copy) NSString *descriptions;

/**
 *  通过字典初始化本类, item的key要和本类的属性保持一致
 *
 *  @param item
 *
 *  @return
 */
- (id)initWithDictionary:(NSDictionary*)item;

/**
 *  转换成字典类型
 *
 *  @return 字典
 */
- (NSMutableDictionary*)toDictionary;

@end
