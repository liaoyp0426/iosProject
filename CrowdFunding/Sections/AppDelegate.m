//
//  AppDelegate.m
//  CrowdFunding
//
//  Created by liaoyp on 15/1/21.
//  Copyright (c) 2015年 CF. All rights reserved.
//

#import "AppDelegate.h"
#import "CFNavigationController.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = RGB(255, 245, 245);
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    CFNavigationController *rootVC = [[CFNavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = rootVC;
    _rootViewController = rootVC;
    
    [self.window makeKeyAndVisible];
    [self configUMeng];

    return YES;
}


#pragma
#pragma mark 友盟统计
#pragma
#pragma mark  友盟的统计和分享

NSString    *isUpdate;
NSString    *appNewVersion;
NSString    *appNewInfo;
BOOL        updateFlag;
NSString    *path;
-(void)appUpdate:(NSDictionary *)appUpdateInfo
{
    //[currentVC.view hideToast];
    
    appNewInfo = [appUpdateInfo valueForKey:@"update_log"];
    appNewVersion = [appUpdateInfo valueForKey:@"version"];
    path = [appUpdateInfo objectForKey:@"path"];
    if(![isUpdate isEqualToString:[appUpdateInfo valueForKey:@"update"]])
    {
        isUpdate = [appUpdateInfo valueForKey:@"update"];
    }
    updateFlag = 0;
    if([isUpdate isEqualToString:@"YES"])
    {
        updateFlag = 1;
        [self performSelectorOnMainThread:@selector(showUpdateAlert) withObject:nil waitUntilDone:YES];
    }
    
}
-(void)showUpdateAlert
{
    BlockAlertView *block = [[BlockAlertView alloc] initWithTitle:@"发现最新版本" message:appNewInfo cancelButtonTitle:@"忽略本次提醒" otherButtonTitles:@"立即更新" YESblock:^{
        
        [GWXGlobalConfig GotoAppStore];
        
    } NOblock:^{
        
    }];
    [block show];
}


- (void)configUMeng
{
    // 友盟统计
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    [MobClick startWithAppkey:kUMengAppKey];
    [MobClick setAppVersion:version];
    [MobClick checkUpdateWithDelegate:self selector:@selector(appUpdate:)];
    [MobClick updateOnlineConfig];  //在线参数配置
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}


- (void)onlineConfigCallBack:(NSNotification *)note
{
    NSLog(@"[UMeng] online config note = %@", note.userInfo);
}



- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

//返回 AppDelegate
+ (AppDelegate *)getAppDelegate
{
    return (AppDelegate *) [[UIApplication sharedApplication] delegate];
}

@end
