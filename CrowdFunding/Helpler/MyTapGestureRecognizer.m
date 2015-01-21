//
//  MyTapGestureRecognizer.m
//  QDaily
//
//  Created by Frank on 14-8-17.
//  Copyright (c) 2014年 Frank. All rights reserved.
//

#import "MyTapGestureRecognizer.h"

@implementation MyTapGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self) {
        _userInfo = [[NSMutableDictionary alloc] init];
    }
    return self;
}
@end
