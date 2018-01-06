//
//  PHAssetCollection+custom.h
//  PhotoDemo
//
//  Created by yangrui on 2017/11/4.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAssetCollection (custom)

#pragma mark- 相册相关
/** 获取一个对应 名字的自定义相册,没有就创建一个新的 */
+(PHAssetCollection *)albumOfNamed:(NSString *)name;


/** 获取一个对应 名字的自定义相册,没有就创建一个新的  */
+(PHAssetCollection *)customAlbumForApp;


/** 获取系统的 相机胶卷相册 */
+(PHAssetCollection *)systemCameraRollAlbum;


/** 根据相册的 子类型 获取对应的相册, 一个子类型可能有多个相册 () */
+ (NSMutableArray<PHAssetCollection *> *)assetCollectionFor_assetCollectionSubtype:(PHAssetCollectionSubtype)subType;

/** 根据一堆 相册的子 类型 或去对应的相册  */
+(NSArray *)assetClloctionArrFor_subTypeArr:(NSArray<NSNumber *> *)subTypeArr;

/** 获取第三方用户的相册,比如:QQ\ 微信\ 美颜等 第三方应用创建的相册都属于这个范畴*/
+(NSMutableArray<PHAssetCollection *>  *)thirdPartyUserImageAssetClloctionArr;



#pragma mark- 相册资源相关
/** 将指定的  assetArr 从对应的相册中移除 */
+(BOOL)removeAssetArr:(NSArray<PHAsset *> *)assetArr fromAssetCollction:(PHAssetCollection *)assetCollection;


/** 将 asset 保存到指定的相册 (将asset 从相机胶卷copy 一份到 assetCollection) */
+(BOOL)saveAsset:(PHAsset *)asset toAssetCollction:(PHAssetCollection *)assetCollection;

/** 将 asset 保存到 指定的相册(自己) (将asset 从相机胶卷copy 一份到 assetCollection)*/
-(BOOL)saveAsset:(PHAsset *)asset;


/** 将 一堆 asset 保存到指定的相册 (将asset 从相机胶卷copy 一份到 assetCollection)  */
+(BOOL)saveAssetArr:(NSArray<PHAsset *> *)assetArr toAssetCollction:(PHAssetCollection *)assetCollection;

/** 将 一堆 asset 保存到 指定的相册(自己) (将asset 从相机胶卷copy 一份到 assetCollection)*/
-(BOOL)saveAssetArr:(NSArray<PHAsset *> *)assetArr;



#pragma mark- 照片相关
/** 将 image 保存到指定的相册 (将asset 从相机胶卷copy 一份到 assetCollection)*/
+(BOOL)saveImage:(UIImage  *)image toAssetCollction:(PHAssetCollection *)assetCollection;

/** 将 image 保存到 指定的相册(自己) (将asset 从相机胶卷copy 一份到 assetCollection)*/
-(BOOL)saveImage:(UIImage  *)image;

/** 将 asset 作为相册的封面*/
-(BOOL)changeAssetAsAlbumCover:(PHAsset *)asset;


//-(void)assetCollectionTypeOfSubAssetCollectionType;

@end
