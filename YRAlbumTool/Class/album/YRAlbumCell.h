//
//  YRAlbumListCell.h
//  YRAlbumTool
//
//  Created by 　yangrui on 2017/11/23.
//  Copyright © 2017年 　yangrui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface YRAlbumCell : UITableViewCell
@property(nonatomic, strong)PHAssetCollection *assetCollection;
@property(nonatomic, assign)NSInteger selectedCount;
@end
