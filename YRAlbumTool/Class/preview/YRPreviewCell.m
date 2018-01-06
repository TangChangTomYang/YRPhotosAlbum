//
//  YRPreviewCell.m
//  YRAlbumTool
//
//  Created by yangrui on 2018/1/5.
//  Copyright © 2018年 　yangrui. All rights reserved.
//

#import "YRPreviewCell.h"


@implementation YRPreviewCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
       
        
        [self previewView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoPreviewCollectionViewDidScroll) name:@"photoPreviewCollectionViewDidScroll" object:nil];
        
        
        self.layer.masksToBounds = YES;
    }
    return self;
}

-(YRPreviewView *)previewView{
    if (!_previewView) {
        _previewView = [[YRPreviewView alloc] initWithFrame:self.bounds];
        [self addSubview:_previewView];
    }
    return _previewView;
    
}

-(void)setSingleTapGestureBlock:(void (^)())singleTapGestureBlock{
    
    self.previewView.singleTapGestureBlock =  singleTapGestureBlock;
}

-(void)setAsset:(PHAsset *)asset{
    _asset = asset;
    
    self.previewView.asset = asset;
    
}
#pragma mark - Notification


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
