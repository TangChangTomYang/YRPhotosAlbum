//
//  YRPreviewCell.h
//  YRAlbumTool
//
//  Created by yangrui on 2018/1/5.
//  Copyright © 2018年 　yangrui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRPreviewView.h"

@interface YRPreviewCell : UICollectionViewCell

@property(nonatomic, strong)PHAsset *asset;

@property (nonatomic, copy) void (^singleTapGestureBlock)();
@property (nonatomic, strong) YRPreviewView *previewView;

- (void)configSubviews;
- (void)photoPreviewCollectionViewDidScroll;
@end
