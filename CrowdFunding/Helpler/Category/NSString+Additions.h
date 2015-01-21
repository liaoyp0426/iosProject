//
//  NSString+Hash.h
//  Orbitink
//
//  Created by mmackh on 5/3/13.
//  Copyright (c) 2013 Professional Consulting & Trading GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

- (NSString *)urlFriendlyFileNameWithExtension:(NSString *)extension prefixID:(int)prefixID;
- (NSString *)urlFriendlyFileName;
- (NSString *)stringByAppendingURLPathComponent:(NSString *)pathComponent;
- (NSString *)stringByDeletingLastURLPathComponent;

- (NSString *)sha512;
- (NSString *)base64Encode;
- (NSString *)base64Decode;

- (NSString*)stringBetweenString:(NSString *)start andString:(NSString *)end;

- (NSString *)stringByStrippingHTML;
- (NSString *)localCachePath;

- (NSString *)trim;
- (BOOL)isNumeric;
- (BOOL)isEmpty;
- (BOOL)containsString:(NSString *)needle;
- (NSString *) formrtJSONFromUTF_8;


///////////////////////////// 正则表达式相关  ///////////////////////////////

/** 邮箱验证 */
- (BOOL)isValidEmail;

/** 手机号码验证 */
- (BOOL)isValidPhoneNum;

/** 车牌号验证 */
- (BOOL)isValidCarNo;

/** 网址验证 */
- (BOOL)isValidUrl;

/**
 @brief     是否符合IP格式，xxx.xxx.xxx.xxx
 */
- (BOOL)isValidIP;

/** 身份证验证 refer to http://blog.csdn.net/afyzgh/article/details/16965107*/
- (BOOL)isValidIdCardNum;


__attribute__((overloadable))
NSString *substr(NSString *str, int start);
__attribute__((overloadable))
NSString *substr(NSString *str, int start, int length);

@end

@interface NSObject (isEmpty)

- (BOOL)mag_isEmpty;

@end
