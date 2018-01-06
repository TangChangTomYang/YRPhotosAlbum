//
//  YRAlbum_difine.h
//  YRAlbumTool
//
//  Created by 　yangrui on 2017/11/22.
//  Copyright © 2017年 　yangrui. All rights reserved.
//

#ifndef YRAlbum_difine_h
#define YRAlbum_difine_h


#endif /* YRAlbum_difine_h */


//#import "PHCategoryDefine.h"

#import "UIView+Extension.h"
#import "YRAlbum_ViewController.h"
#import "YRAlbum_NavigationController.h"
#import "YRAlbum_collectionViewController.h"
#import "YRAlbum_PhotoListViewController.h"

#import "YRAlbumCell.h"

#define GHLog(...)   NSLog(@"%s\n %@\n\n", __func__, [NSString stringWithFormat:__VA_ARGS__])

#define YRScreenHeight          ([UIScreen mainScreen].bounds.size.height)
#define YRScreenWidth           ([UIScreen mainScreen].bounds.size.width)

#define kScreenW                 YRScreenWidth
#define kScreenH                 YRScreenHeight

#define isIPhoneX               (kScreenH==812)
#define kNaviH                    (isIPhoneX ? 88 : 64)
#define kBottomMargin             (isIPhoneX ? 34 : 0)  // iphoneX底部去除34
#define KBottomToolBarH             (kBottomMargin + 40)



//颜色
#define GHColorRGBA(r,g,b,a)            [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define GHColor(r,g,b)                  GHColorRGBA(r,g,b,255.0)
#define GHRandomColor                   GHColor((arc4random_uniform(255)),(arc4random_uniform(255)),(arc4random_uniform(255)))

#define YRAlbumNavBar_BarTintColor        GHColor(34, 34, 34)
#define YRAlbumNavBar_TintColor           GHColor(255, 255, 255)
#define YRAlbumVCView_backGroundColor     GHColor(255, 255, 255)

#define YRAlbum_okGreenColor     GHColor(83, 179, 17)


