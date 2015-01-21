//
//  GWXGlobalConfig.m
//  FollowMe
//
//  Created by liaoyp on 14/10/21.
//  Copyright (c) 2014年 Frank. All rights reserved.
//

#import "GWXGlobalConfig.h"
#include <sys/stat.h>
#include <dirent.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#import "LoginViewController.h"
#import "CFNavigationController.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"
#import <AdSupport/AdSupport.h>

@implementation GWXGlobalConfig

#pragma mark - Global UI

///////////////////////////////////////////////////////////////////////////////////////////////////


+ (MBProgressHUD*)HUDShowMessage:(NSString*)msg
{
    return  [self HUDShowMessage:msg addedToView:g_AppDelegate.window];
}

+ (MBProgressHUD*)HUDShowMessage:(NSString*)msg addedToView:(UIView*)view
{
    static MBProgressHUD* hud = nil;
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.hidden = NO;
    hud.alpha = 1.0f;
    [hud hide:YES afterDelay:1.0f];
    return hud;
}

+ (void)showErrorNetToast
{
    [GWXGlobalConfig HUDShowMessage:@"请检查网络连接"];
}

+ (GWXGlobalConfig *)sharedInstance
{
    static dispatch_once_t pred;
    static GWXGlobalConfig *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}


+ (void)push2LoginController:(UIViewController *) controller
{
    if (ISONLINE) {
        LoginViewController *mLoginVC = [LoginViewController new];
        [controller presentViewController:mLoginVC animated:YES
                               completion:nil];
    }else
    {
        CFNavigationController *btt =[[CFNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        [controller presentViewController:btt animated:YES
                               completion:nil];
    }
}

/**
 *  掩藏tableView间隔线
 *
 *  @param tableView <#tableView description#>
 */
+ (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    
    UIView *tableSelectView = [[UIView alloc] init];
    view.backgroundColor = PublicbgColor;
    tableView.backgroundView =tableSelectView;
    tableView.backgroundColor = PublicbgColor;
    
}

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
+ (UIView *) getSelectedBackgroundView
{
    UIView *selectView = [UIView new];
    selectView.backgroundColor =DefaultTableCellHighColor;
    return selectView;

}

/**
 *  获取本地缓存文件
 *
 *  @param fileName <#fileName description#>
 *
 *  @return <#return value description#>
 */

+ (NSDictionary *) getCacheDataWithFileName:(NSString *)fileName
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *coursePath = [mainBundle pathForResource:fileName ofType:@"json"];
    NSData *courseData = [NSData dataWithContentsOfFile:coursePath];
    
    if (courseData){
        NSError *error;
        NSDictionary *courseDic = [NSJSONSerialization JSONObjectWithData:courseData options:NSJSONReadingMutableLeaves error:&error];
        return courseDic;
    }
    return nil;
}


+ (NSMutableArray *) getCourseSubjectArray
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *coursePath = [mainBundle pathForResource:@"coursetype" ofType:@"txt"];
    NSData *courseData = [NSData dataWithContentsOfFile:coursePath];
    NSMutableArray *allSubject =[NSMutableArray array];
    
    if (courseData){
        NSError *error;
        NSDictionary *courseDic = [NSJSONSerialization JSONObjectWithData:courseData options:NSJSONReadingMutableLeaves error:&error];
        NSArray *allData =courseDic[@"data"];
        [allData enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            
            NSArray *subArray =[obj objectForKey:@"subclass"];
            [subArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                [allSubject addObject:[obj objectForKey:@"name"]];
                
            }];
        }];
    }
    return allSubject;
}

+ (void) saveMapAddress:(id) mapAddressObject
{

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *array  =[userDefault arrayForKey:@"addressList"];
    
    if (!array) {
        array = [NSMutableArray array];
    }
    if ([mapAddressObject isKindOfClass:[NSDictionary class]]) {
        array = [array arrayByAddingObjectsFromArray:@[mapAddressObject]];
    }
    
    // 说明存储的是一个数组
    if ([mapAddressObject isKindOfClass:[NSArray class]]) {
        array = mapAddressObject;
    }
   
    [userDefault setObject:array forKey:@"addressList"];
    [userDefault synchronize];

}


+ (NSArray *) getMapAddressList
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *array  =[userDefault arrayForKey:@"addressList"];
    return array;
}


+ (NSMutableAttributedString*)lineSpacing:(CGFloat)height withText:(NSString *)text
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:height];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    return attributedString;
}

+ (BOOL)isNewTopic:(NSString *)topicTime
{
    double installTime = [[NSUserDefaults standardUserDefaults] doubleForKey:@"installTime"];
    double time = [topicTime doubleValue];
    if (time > installTime) {
        return YES;
    }
    return NO;
}
+ (UIImage *)createImageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *myImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return myImage;
}

+ (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
+ (void) GotoAppStore
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d",APPSTOREAPPLICATIONID]];
    [[UIApplication sharedApplication] openURL:url];
}

+ (void)sendMail:(NSString *)mail {
    
    NSString *url = [NSString stringWithFormat: @"mailto:%@",mail];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mail]];
}

+ (void)makePhoneCall:(NSString *)tel {
    NSString *telUrl = [NSString stringWithFormat:@"telprompt:%@",tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
}

+ (void)sendSMS:(NSString *)tel {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
}

+ (void)openURLWithSafari:(NSString *)url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
+ (int)countWords:(NSString *)s {
    int i, n = (int)[s length], l = 0, a = 0, b = 0;
    unichar c;
    for (i = 0; i < n; i++) {
        c = [s characterAtIndex:i];
        if (isblank(c)) {
            b++;
        }
        else if (isascii(c)) {
            a++;
        }
        else {
            l++;
        }
    }
    if (a == 0 && l == 0) {
        return 0;
    }
    return l + (int)ceilf((float)(a + b) / 2.0);
}

+(void)SDWebImageDownloader:(NSString *)url completed:(ImageDownloaderCompletedBlock)completedBlock
{
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (image) {
            completedBlock(image);
        }else
            completedBlock(nil);
    }];
}

+ (UIImage *)saveImageFromView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, view.layer.contentsScale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)savePhotosAlbum:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

+ (void)saveImageFromToPhotosAlbum:(UIView *)view {
    UIImage *image = [self saveImageFromView:view];
    [self savePhotosAlbum:image];
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message;
    NSString *title;
    if (!error) {
        title = @"成功提示";
        message = @"成功保存到相";
    }
    else {
        title = @"失败提示";
        message = [error description];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"知道了"
                                          otherButtonTitles:nil];
    [alert show];
}


+ (NSString *)getFolderSize:(long long)size {
    if (size < 1000) {
        return [NSString stringWithFormat:@"%lldB", size];
    }
    else if (size < 1000 * 1000) {
        return [NSString stringWithFormat:@"%.2fKB", size * 1.0 / 1000];
    }
    else if (size < 1000 * 1000 * 1000) {
        return [NSString stringWithFormat:@"%.2fMB", size * 1.0 / 1000 / 1000];
    }
    else if (size < 1000.0 * 1000.0 * 1000.0 * 1000.0) {
        return [NSString stringWithFormat:@"%.2fGB", size * 1.0 / 1000 / 1000 / 1000];
    }
    return @"";
}

+ (long long)folderSizeAtPath:(NSString *)folderPath {
    return [self _folderSizeAtPath:[folderPath cStringUsingEncoding:NSUTF8StringEncoding]];
}

+ (long long)_folderSizeAtPath:(const char *)folderPath {
    long long folderSize = 0;
    DIR *dir = opendir(folderPath);
    if (dir == NULL) return 0;
    struct dirent *child;
    while ((child = readdir(dir)) != NULL) {
        if (child->d_type == DT_DIR && (
                                        (child->d_name[0] == '.' && child->d_name[1] == 0) ||                         // 忽略目录 .
                                        (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0)                         // 忽略目录 ..
                                        )) continue;
        
        NSUInteger folderPathLength = strlen(folderPath);
        char childPath[1024]; // 子文件的路径地址
        stpcpy(childPath, folderPath);
        if (folderPath[folderPathLength - 1] != '/') {
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }
        stpcpy(childPath + folderPathLength, child->d_name);
        childPath[folderPathLength + child->d_namlen] = 0;
        if (child->d_type == DT_DIR) { // directory
            folderSize += [self _folderSizeAtPath:childPath]; // 递归调用子目录
            // 把目录本身所占的空间也加上
            struct stat st;
            if (lstat(childPath, &st) == 0) folderSize += st.st_size;
        }
        else if (child->d_type == DT_REG || child->d_type == DT_LNK) { // file or link
            struct stat st;
            if (lstat(childPath, &st) == 0) folderSize += st.st_size;
        }
    }
    return folderSize;
}

+ (void)clearCaches
{
    NSTimeInterval durtime  =2.0;
    float tmpSize =[[SDImageCache sharedImageCache] getSize];
    tmpSize=tmpSize/1024/1024;
    NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize] : [NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize * 1024];
    
    NSString *text = clearCacheName;
    MBProgressHUD *HUD;
    if (!HUD) {
        
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
//        [self myClearCacheAction];
        
        BACK(^{
            NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            
            NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
            NSLog(@"files :%lu",(unsigned long)[files count]);
            for (NSString *p in files) {
                NSError *error;
                NSString *path = [cachPath stringByAppendingPathComponent:p];
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                }
            }
        });
        
        HUD = [[MBProgressHUD alloc] initWithView:g_AppDelegate.window];
        [g_AppDelegate.window addSubview:HUD];
        HUD.labelText = text;
        
        //设置模式为进度框形的
         HUD.mode = MBProgressHUDModeDeterminate;
        [HUD showAnimated:YES whileExecutingBlock:^{
            float progress = 0.0f;
            while (progress < 1.0f) {
                progress += 0.01f;
                HUD.progress = progress;
                usleep(10000*durtime);
            }
            HUD.labelText = @"完成！";
            
        } completionBlock:^{
            
            [HUD removeFromSuperview];
        }];
    }
}

+ (void)deleteAll:(NSString *)cachePath {
    [[NSFileManager defaultManager] removeItemAtPath:cachePath error:NULL];
    [[NSFileManager defaultManager] createDirectoryAtPath:cachePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
}


+(NSString *)getSha256String:(NSString *)srcString {
//    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
//    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
//    
//    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
//    
//    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
//    
//    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
//    
//    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
//        [result appendFormat:@"%02x", digest[i]];
//    }
//    return result;
    return @"";
}

/**
 *   统计我们的应用
 */
+ (void) registerDevice
{

    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString* idfa = [GWXGlobalConfig getDeviceID];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    DataRequest *_request;
    if (!_request) {
        _request =[[DataRequest alloc] initWithDelegate:nil];
    }
    NSDictionary *prams =@
    {
        @"app_id":@"1",
        @"device_id":idfa,
        @"app_versions":version,
        @"device_token":@"",
        @"os_versions":systemVersion,
    };
    [_request sendRequestWithUrl:DataRequestDeviceActivationURL params:prams success:^(NSDictionary *item) {
        NSLog(@"设备注册统计成功！");
        
    } fail:^(NSDictionary *item) {
        NSLog(@"设备注册统计失败！");
        
    }];
    
}


+(NSString *)getDeviceID
{
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return adId;
}

//计算文本的大小
+(CGSize)getContentSize:(NSString*)content font:(UIFont*)font width:(CGFloat)width
{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize cSize = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;

    return cSize;
}
+(CGSize)getContentSize:(NSString*)content font:(UIFont*)font size:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize cSize = [content boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return cSize;
}

/**
 *  根据text字段排序
 *
 *  @param array 数据源
 *  @param text  排序字段
 *  @param desc  是否降序
 *
 *  @return 排列后的数据
 */
+(NSArray*)sequenceArray:(NSArray*)array text:(NSString*)text desc:(BOOL)desc
{
    if (array.count == 0) {
        return array;
    }
    
    //排序
    NSMutableArray *marray1 = [NSMutableArray arrayWithArray:array];
    
    for (int i = 0; i < marray1.count-1; i++) {
        for (int j = 0; j < marray1.count-1-i; j++) {
            NSDictionary *dic1 = [marray1 objectAtIndex:j];
            NSDictionary *dic2 = [marray1 objectAtIndex:(j+1)];
            
            BOOL change = NO;
            if (desc && [[dic2 objectForKey:text] intValue] > [[dic1 objectForKey:text] intValue]) {
                change = YES;
            }else if(!desc && [[dic2 objectForKey:text] intValue] < [[dic1 objectForKey:text] intValue]){
                change = YES;
            }
            if (change) {
                [marray1 replaceObjectAtIndex:j withObject:dic2];
                [marray1 replaceObjectAtIndex:(j+1) withObject:dic1];
            }
        }
    }
    return marray1;
}

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
+(NSArray*)packageArray:(NSArray*)fromArray text:(NSString*)text forArray:(NSArray*)toArray key:(NSString*)key
{
    if (toArray.count == 0) {
        return toArray;
    }
    
    //fromArray数据组装
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    for (NSDictionary *d1 in fromArray) {
        NSString *title = [NSString stringWithFormat:@"%@",[d1 objectForKey:text]];
        if (![dic objectForKey:title]) {
            [dic setObject:[NSMutableArray arrayWithCapacity:1] forKey:title];
        }
        NSMutableArray *array = [dic objectForKey:title];
        [array addObject:d1];
    }
    
    //组装数据
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < toArray.count; i++) {
        NSDictionary *d2 = [toArray objectAtIndex:i];
        NSString *title = [NSString stringWithFormat:@"%@",[d2 objectForKey:text]];
        
        NSMutableDictionary *d3 = [NSMutableDictionary dictionaryWithDictionary:d2];
        [array addObject:d3];
        if ([dic objectForKey:title]) {
            [d3 setObject:[dic objectForKey:title] forKey:key];
        }
    }
    
    return array;
}

@end
