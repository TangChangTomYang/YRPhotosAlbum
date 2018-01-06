//
//  UIView+Extension
//  GHZY
//
//  Created by 杨 on 16/6/2.
//  Copyright © 2016年 杨. All rights reserved.


#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGPoint origin;

/** 旋转 */
-(void)rotation;
@end
