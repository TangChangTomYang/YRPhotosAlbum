//
//  YRPreview.h
//  YRAlbumTool
//
//  Created by yangrui on 2018/1/5.
//  Copyright © 2018年 　yangrui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface YRPreviewView : UIView

@property(nonatomic, strong)PHAsset *asset;

@property (nonatomic, copy) void (^singleTapGestureBlock)();


@end
