//
//  PHAsset+custom.h
//  PhotoDemo
//
//  Created by yangrui on 2017/11/4.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAsset (custom)

/** 获取指定相册的 照片 视频 资源 */
+(NSMutableArray<PHAsset *> *)allAsset_InAssetCollcetion:(PHAssetCollection *)assetCollection;


/** 获取指定相册的 照片资源 */
+(NSMutableArray<PHAsset *> *)allImageAsset_InAssetCollcetion:(PHAssetCollection *)assetCollection;


/** 获取指定相册的 视频资源 */
+(NSMutableArray<PHAsset *> *)allVideoAsset_InAssetCollcetion:(PHAssetCollection *)assetCollection;

/** 获取相册的封面 照片 */
+(PHAsset *)fengMianImageAssetInAssetCollcetion:(PHAssetCollection *)assetCollection;

//fengMianImageAssetInAssetCollcetion

/** 保存照片到系统 的 相机胶卷相册
 说明: 调用这个方法保存相片后,最后保存的照片会变成相册的封面
 */
+(PHAsset *)saveImage2SystemCameraRollAlbum:(UIImage *)image;


/** 通过 一个  PHAsset 获取图片 异步*/
+(void)requestImageForAsset:(PHAsset *)asset size:(CGSize)size callBack:(void(^)(UIImage *assetImage))callBack;


/** 只获取图片的 获取选项 */
+(PHFetchOptions *)onlyImageOption;

/** 只获取视频的 获取选项 */
+(PHFetchOptions *)onlyVideoOption;

/** 最近一周 时间 */
+(NSDate *)lastWeek;

/** 获取资源的大小 */
+(void)getAssetArrSize:(NSArray<PHAsset *> *)assetArr completion:(void (^)(NSString *totalBytes))completion;

@end
