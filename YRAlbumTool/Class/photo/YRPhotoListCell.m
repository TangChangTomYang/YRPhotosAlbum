//
//  YRPhotoListCell.m
//  YRAlbumTool
//
//  Created by 　yangrui on 2017/11/23.
//  Copyright © 2017年 　yangrui. All rights reserved.
//

#import "YRPhotoListCell.h"

@interface YRPhotoListCell()
@property (weak, nonatomic) IBOutlet UIButton *selecteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@end


@implementation YRPhotoListCell
- (IBAction)selectBtnClick:(UIButton *)selecteBtn {
    
    [self.delegate photoListCell:self didClickSelecteBtn:selecteBtn];
    
}

-(void)setIsSelected:(BOOL)isSelected{
    
    _isSelected = isSelected;
    self.selecteBtn.selected = isSelected;
}


-(void)setAsset:(PHAsset *)asset{
    _asset = asset;
    
    if (asset) {
        __weak typeof( self) weakSelf = self;
        [PHAsset requestImageForAsset:asset size:CGSizeMake(60, 60) callBack:^(UIImage *assetImage) {
            weakSelf.imgV.image = assetImage;
            
        }];
    }
    else{
        
        self.imgV.image = nil;
    }
     
}




@end
