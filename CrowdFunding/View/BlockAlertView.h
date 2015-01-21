//
//  BlockAlertView.h
//  FollowMe
//
//  Created by liaoyp on 14/11/16.
//  Copyright (c) 2014年 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>

//自定义block
typedef void(^YesBlock)(void);
typedef void(^NoBlock)(void);

@interface BlockAlertView : UIAlertView {
    
}

@property(nonatomic,copy)YesBlock YESblock;
@property(nonatomic,copy)NoBlock NOblock;

//需要自定义初始化方法，调用Block
- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString*)otherButtonTitles
           YESblock:(YesBlock)block
            NOblock:(NoBlock)NOblock;

//我们还可以自带的消息提示框
+(void) alert:(NSString *) message;


@end