//
//  YRPreviewToolBar.h
//  YRAlbumTool
//
//  Created by yangrui on 2018/1/4.
//  Copyright © 2018年 　yangrui. All rights reserved.
//

#import <Foundation/Foundation.h>


@class YRPreviewToolBar;

@protocol YRPreviewToolBarDelegate<NSObject>

-(void)toolBar:(YRPreviewToolBar *)toolBar  didClickPreviewBtn:(UIButton *)previewBtn;
-(void)toolBar:(YRPreviewToolBar *)toolBar  didClickOrtiginBtn:(UIButton *)ortiginBtn;
-(void)toolBar:(YRPreviewToolBar *)toolBar  didClickCompleteBtn:(UIButton *)completeBtn;
@end

@interface YRPreviewToolBar : UIView
@property (weak, nonatomic) IBOutlet UIButton *originBtn;
@property (assign, nonatomic)NSInteger selectedCount;
@property(nonatomic, weak)id<YRPreviewToolBarDelegate> delegate;


-(void)setAssetSize:(NSString *)assetSizeStr;

+(instancetype)toolBarWithFrame:(CGRect)frame;


-(void)hidePreviewBtn;

-(void)hideTopLine;

@end
