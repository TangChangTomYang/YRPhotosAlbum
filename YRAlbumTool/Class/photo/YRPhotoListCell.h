//
//  YRPhotoListCell.h
//  YRAlbumTool
//
//  Created by 　yangrui on 2017/11/23.
//  Copyright © 2017年 　yangrui. All rights reserved.
//

#import <UIKit/UIKit.h>


@class YRPhotoListCell;

@protocol YRPhotoListCellDelegate<NSObject>

-(void)photoListCell:(YRPhotoListCell *)photoListCell  didClickSelecteBtn:(UIButton *)selecteBtn;
@end


@interface YRPhotoListCell : UICollectionViewCell

@property(nonatomic, strong)PHAsset *asset;

@property(nonatomic, strong)NSIndexPath *indexPath;


@property(nonatomic, assign)BOOL isSelected;

@property(nonatomic, weak)id<YRPhotoListCellDelegate>  delegate;
@end
