//
//  GWXGlobalConfig.h
//  FollowMe
//
//  Created by liaoyp on 14/10/21.
//  Copyright (c) 2014年 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MBProgressHUD;

typedef void(^ImageDownloaderCompletedBlock)(UIImage *image);

@interface GWXGlobalConfig : NSObject

@property(nonatomic, copy)NSString *topicID;

+ (GWXGlobalConfig *)sharedInstance;

+ (void)push2LoginController:(UIViewController *) controller;

/**
 *  基本的Toast
 */
+ (MBProgressHUD*)HUDShowMessage:(NSString*)msg;
+ (MBProgressHUD*)HUDShowMessage:(NSString*)msg addedToView:(UIView*)view;
// 网络连接状态的下
+ (void)showErrorNetToast;

+ (void)setExtraCellLineHidden: (UITableView *)tableView;

/**
 *  TableViewCell 点击选中的状态的背景图
 */
+ (UIView *) getSelectedBackgroundView;

/**
 *  获取课程科目数据列表
 */
+ (NSMutableArray *) getCourseSubjectArray;

/**
 *  获取本地缓存文件。
 */
+ (NSDictionary *) getCacheDataWithFileName:(NSString *)fileName;

/**
 *  存储地图的数据模型
 *
 */
+ (void) saveMapAddress:(id)mapAddressObject;
+ (NSArray *) getMapAddressList;

+ (void)GotoAppStore;
///////////////////////
//发送邮件
+ (void)sendMail:(NSString *)mail;
//打电话
+ (void)makePhoneCall:(NSString *)tel;
//发短信
+ (void)sendSMS:(NSString *)tel;
//打开URL
+ (void)openURLWithSafari:(NSString *)url;
//计算字符个数
+ (int)countWords:(NSString *)s;

// 下载图片
+(void)SDWebImageDownloader:(NSString *)url completed:(ImageDownloaderCompletedBlock)completedBlock;

//屏幕截图，并保存到相册
+ (void)saveImageFromToPhotosAlbum:(UIView *)view;
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

//获取文件夹大小
+ (NSString *)getFolderSize:(long long)size;
+ (long long)folderSizeAtPath:(NSString *)folderPath;
+ (void)deleteAll:(NSString *)cachePath;

//sha256加密
+(NSString *)getSha256String:( NSString *)srcString;

// 获取系统的设备id
+(NSString *)getDeviceID;
+ (void) registerDevice;

+ (NSMutableAttributedString*)lineSpacing:(CGFloat)height withText:(NSString *)text;
// 是否是最新主题
+ (BOOL)isNewTopic:(NSString *)topicTime;

+ (UIColor *)randomColor;
+ (UIImage *)createImageFromColor:(UIColor *)color;


//计算文本的大小
+(CGSize)getContentSize:(NSString*)content font:(UIFont*)font width:(CGFloat)width;
+(CGSize)getContentSize:(NSString*)content font:(UIFont*)font size:(CGSize)size;

+ (void)clearCaches;

/**
 *  根据text字段排序
 *
 *  @param array 数据源
 *  @param text  排序字段
 *  @param desc  是否降序
 *
 *  @return 排列后的数据
 */
+(NSArray*)sequenceArray:(NSArray*)array text:(NSString*)text desc:(BOOL)desc;

/**
 *  根据text字段将fromArray数组的数据添加到toArray中字典的key字段里
 *
 *  @param fromArray 需要添加的数据源
 *  @param text      根据字段
 *  @param toArray   添加到的数据源
 *  @param key       添加到toArray中数据的key字段
 *
 *  @return 添加完成的数据源
 */
+(NSArray*)packageArray:(NSArray*)fromArray text:(NSString*)text forArray:(NSArray*)toArray key:(NSString*)key;

@end
