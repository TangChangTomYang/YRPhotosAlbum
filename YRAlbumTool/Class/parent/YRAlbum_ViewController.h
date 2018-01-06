//
//  YRAlbumVC.h
//  YRAlbumTool
//
//  Created by 　yangrui on 2017/11/22.
//  Copyright © 2017年 　yangrui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>



@interface YRAlbum_ViewController : UIViewController
@property(nonatomic, strong)NSMutableArray<PHAsset *> *selectedAssetArrM;
/** selectedAssetArr.count  > 表示选择了,否则表示取消 */
@property(nonatomic, strong)void(^completeCallBack)(NSArray<PHAsset *> *selectedAssetArr);


-(void)setupRightItem;

-(void)setupLeftItem;


-(void)rightItemClick;

-(void)leftItemClick;
@end
