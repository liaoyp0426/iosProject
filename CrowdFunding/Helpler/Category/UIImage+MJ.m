
#import "UIImage+MJ.h"

@implementation UIImage (MJ)
#pragma mark 加载全屏的图片
// new_feature_1.png
+ (UIImage *)fullscrennImage:(NSString *)imgName
{
    // 1.如果是iPhone5，对文件名特殊处理
//    if (iPhone5) {
//        imgName = [imgName fileAppend:@"-568h@2x"];
//    }
    
    // 2.加载图片
    return [self imageNamed:imgName];
}

- (NSString *)fileAppend:(NSString *)append
{
    // 1.1.获得文件拓展名
    NSString *ext = [append pathExtension];
    
    // 1.2.删除最后面的扩展名
    NSString *imgName = [append stringByDeletingPathExtension];
    
    // 1.3.拼接-568h@2x
    imgName = [imgName stringByAppendingString:append];
    
    // 1.4.拼接扩展名
    return [imgName stringByAppendingPathExtension:ext];
}


#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName
{
    UIImage *image = [UIImage imageNamed:imgName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    
    
    // width 30
    // height 60
    
    // LeftCapWidth  10
    // 1 = width - leftCapWidth - right cap
    
    // topCapHeight 10
    // 1 = height - topCapWidth - bottom cap//    [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
//    [image resizableImageWithCapInsets:<#(UIEdgeInsets)#> resizingMode:<#(UIImageResizingMode)#>];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setBackgroundImage:image forState:UIControlStateNormal];
//    btn.frame = CGRectMake(100, 100, 200, 200);
//    [self.view addSubview:btn];
}
@end
