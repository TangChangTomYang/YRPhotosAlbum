//
//  GHAlbumListViewController.h
//  YRAlbumTool
//
//  Created by 　yangrui on 2017/11/22.
//  Copyright © 2017年 　yangrui. All rights reserved.
//

#import "YRAlbum_ViewController.h"


@class YRAlbum_collectionViewController;

@protocol YRAlbumListViewControllerDelegate<NSObject>

-(void)albumListVC:(YRAlbum_collectionViewController *)albumListVC didSelecteIamges:(NSArray *)images;

-(void)albumListVCDidCancle:(YRAlbum_collectionViewController *)albumListVC;
@end




@interface YRAlbum_collectionViewController : YRAlbum_ViewController

@end
