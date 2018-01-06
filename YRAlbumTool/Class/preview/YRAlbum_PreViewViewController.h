//
//  YRPreViewViewController.h
//  YRAlbumTool
//
//  Created by yangrui on 2018/1/4.
//  Copyright © 2018年 　yangrui. All rights reserved.
//

#import "YRAlbum_ViewController.h"

@interface YRAlbum_PreViewViewController : YRAlbum_ViewController

@property(nonatomic, strong)NSMutableArray<PHAsset *> *assetArrM;
@property(nonatomic, assign)NSInteger index;
@property(nonatomic, assign)BOOL isOrigin;
//@property(nonatomic, copy)void(^selectCallBack)(BOOL ) *<#name#> ;
@end
