//
//  YRPreview.m
//  YRAlbumTool
//
//  Created by yangrui on 2018/1/5.
//  Copyright © 2018年 　yangrui. All rights reserved.
//  // 修复获取图片时出现的瞬间内存过高问题
// 下面两行代码，来自hsjcom，他的github是：https://github.com/hsjcom 表示感谢

#import "YRPreviewView.h"


@interface YRPreviewView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end
@implementation YRPreviewView

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 5;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.layer.masksToBounds = NO;
        
        
//        _scrollView.layer.borderColor = GHRandomColor.CGColor;
//        _scrollView.layer.borderWidth = 5.0;
     
    }
    return _scrollView;
    
}



-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        
//        _imageView.layer.borderColor = GHRandomColor.CGColor;
//        _imageView.layer.borderWidth = 8.0;
        
    }
    return _imageView;
    
}



-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self addSubview:self.scrollView];
        
        [self.scrollView addSubview:self.imageView];
        
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureAction:)];
        [self.scrollView addGestureRecognizer:singleTapGesture];
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureAction:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
        [self.scrollView addGestureRecognizer:doubleTapGesture];
        
        
//        self.layer.borderColor = GHRandomColor.CGColor;
//        self.layer.borderWidth = 2.0;
    }
    
    return self;
    
}






-(void)setAsset:(PHAsset *)asset{
    _asset = asset;
    
   
    __weak typeof(self) weakSelf = self ;
    [PHAsset requestImageForAsset:asset size:CGSizeZero callBack:^(UIImage *assetImage) {
        weakSelf.imageView.image = assetImage;

        [weakSelf reseScrollView];
    }];

    
}
- (void)layoutSubviews {
    [super layoutSubviews];
   
    [self reseScrollView];
    
}


-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

  CGRect contentRect =  CGRectMake(0, kNaviH, self.width,self.height - kNaviH- KBottomToolBarH);
 if (CGRectContainsPoint(contentRect, point)) {
         return self.scrollView;
    }
    return [super hitTest:point withEvent:event];
}

-(void)singleTapGestureAction:(UITapGestureRecognizer *)tap{

    
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
   
}


- (void)doubleTapGestureAction:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        _scrollView.contentInset = UIEdgeInsetsZero;
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
   
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {

}

- (void)reseScrollView{
    
    
    CGSize imgSize = self.imageView.image.size;
    
  
    CGFloat scrollWidth  = imgSize.width;
    CGFloat scrollHeight = imgSize.height;
    
    
    CGFloat selfHeight = self.height - (kNaviH + KBottomToolBarH);
    CGFloat selfwidth  = self.width;
    
    CGFloat selfKHRate = selfwidth / selfHeight;
    
    
    
    
    if(!CGSizeEqualToSize(imgSize, CGSizeZero)){
    
        
        CGFloat KHrate = imgSize.width / imgSize.height;
        if (!(selfKHRate > KHrate)) {//太宽
            
            if(imgSize.width > selfwidth){ //
                
               scrollWidth  = selfwidth;
               scrollHeight = (selfwidth  * imgSize.height)/ imgSize.width;
            }
            
        }
        else if (!(selfKHRate > KHrate)) {// 太高
            
            if (imgSize.height > selfHeight) {
                 scrollHeight  = selfHeight;
                 scrollWidth   = selfHeight * imgSize.width / imgSize.height;
            }
        }
        else{// 同比例
            if (imgSize.height > selfHeight) {
                scrollHeight  = selfHeight;
                scrollWidth   = selfHeight * imgSize.width / imgSize.height;
            }
        }
        
    }
    
     CGRect scrollFrame = CGRectMake((selfwidth - scrollWidth)* 0.5, (selfHeight - scrollHeight) * 0.5 + kNaviH, scrollWidth, scrollHeight);
    
    self.scrollView.transform = CGAffineTransformIdentity;
    self.scrollView.frame = scrollFrame;
    self.scrollView.contentSize = CGSizeZero;
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.imageView.frame = self.scrollView.bounds;

    self.scrollView.minimumZoomScale = 1;
    [self.scrollView setZoomScale:1 animated:NO];

}

@end
