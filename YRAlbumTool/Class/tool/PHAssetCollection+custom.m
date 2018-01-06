//
//  PHAssetCollection+custom.m
//  PhotoDemo
//
//  Created by yangrui on 2017/11/4.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import "PHAssetCollection+custom.h"
#import "PHAsset+custom.h"

@implementation PHAssetCollection (custom)


#pragma mark- 相册相关

/** 获取一个对应 名字的自定义相册,没有就创建一个新的 */
+(PHAssetCollection *)albumOfNamed:(NSString *)name{
    
    if (name.length == 0) {
        return nil;
    }
    
    //1.从所有的自定义相册 检查是否已经有 name 对应的自定义相册
    PHFetchResult<PHAssetCollection *> * assetCollectiopnResult =  [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *assetCollection  in assetCollectiopnResult) {
        if ([assetCollection.localizedTitle isEqualToString:name]) {
            return assetCollection;
        }
    }
    
    // 2. 没有找到,就自己创建一个
    NSError *err = nil;
    __block NSString *identifer = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        
        PHAssetCollectionChangeRequest *changeRequest  =  [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:name];
        identifer =  changeRequest.placeholderForCreatedAssetCollection.localIdentifier;
        
    } error:&err];
    
    
    if (err == nil) {
        PHFetchResult<PHAssetCollection *> * newAssetCollectiopnResult  = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[identifer] options:nil];
        
        return newAssetCollectiopnResult.firstObject;
    }
    
    return nil;
    
}

/** 创建一个 和app 名字一样的 自定义相册 */
+(PHAssetCollection *)customAlbumForApp{
    
    //1. 获取应用的名称
  NSDictionary *infoDic = [NSBundle mainBundle].infoDictionary;
  NSString *appName =  infoDic[(NSString *)kCFBundleNameKey];
    
  return  [self albumOfNamed:appName];
  
}

/** 获取系统的 相机胶卷相册 */
+(PHAssetCollection *)systemCameraRollAlbum{
    
    PHFetchResult<PHAssetCollection *> * assetCollectionResult= [self assetCollectionFor_assetCollectionSubtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary];
    
    return assetCollectionResult.firstObject;
    
}





/** 根据相册的 子类型 获取对应的相册, 一个子类型可能有多个相册 () */
+ (PHFetchResult<PHAssetCollection *> *)assetCollectionFor_assetCollectionSubtype:(PHAssetCollectionSubtype)subType{
    

    
    PHFetchOptions *assetCollectionFetchOptions  = [PHFetchOptions new];
    assetCollectionFetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"estimatedAssetCount" ascending:NO]];
//    assetCollectionFetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    PHAssetCollectionType assetCollectionType = [self assetCollectionTypeType_OfAssetCollectionSubType:subType];
    
   return  [PHAssetCollection fetchAssetCollectionsWithType:assetCollectionType subtype:subType options:assetCollectionFetchOptions];
}


/** 根据一堆 相册的子 类型 或去对应的相册  */
+(NSArray *)assetClloctionArrFor_subTypeArr:(NSArray<NSNumber *> *)subTypeArr{
    
    // create options for fetching asset collection (sort by asset count)
    NSMutableArray *assetCollectionArrM = [NSMutableArray array];
    for (NSNumber *subTypeNum in subTypeArr) {
        
        PHAssetCollectionSubtype subType = (PHAssetCollectionSubtype)[subTypeNum intValue];
        
        PHFetchResult<PHAssetCollection *> * assetCollectionResult = [self assetCollectionFor_assetCollectionSubtype:subType];
        
        for (PHAssetCollection * assetCollection in assetCollectionResult) {
            [assetCollectionArrM addObject:assetCollection];
        }
        
    }
    
    return assetCollectionArrM;
}

/** 获取第三方用户的相册,比如:QQ\ 微信\ 美颜等 第三方应用创建的相册都属于这个范畴*/
+(NSMutableArray<PHAssetCollection *>  *)thirdPartyUserImageAssetClloctionArr{
    
    
    NSMutableArray *usrAssetCollectionArrM = [NSMutableArray array];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
//
   /** fetchTopLevelUserCollectionsWithOptions
    <PHAssetCollection: 0x100580900> title:"美颜相机", subtitle:"(null)" assetCollectionType=1/2
    <PHAssetCollection: 0x100597f80> title:"QQ", subtitle:"(null)" assetCollectionType=1/2
    <PHAssetCollection: 0x100564130> title:"WhatsApp", subtitle:"(null)" assetCollectionType=1/2
    <PHAssetCollection: 0x100556950> title:"YRAlbumTool", subtitle:"(null)" assetCollectionType=1/2
*/
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    for(PHAssetCollection *assetCollection in topLevelUserCollections ){
        
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
        if (fetchResult.count == 0) continue;
        
        if ([assetCollection.localizedTitle containsString:@"Hidden"] || [assetCollection.localizedTitle isEqualToString:@"已隐藏"]) continue;
        
        if ([assetCollection.localizedTitle containsString:@"Deleted"] || [assetCollection.localizedTitle isEqualToString:@"最近删除"]) continue;
        
        [usrAssetCollectionArrM addObject:assetCollection];
    }
    
    
    
    /** PHAssetCollectionSubtypeAlbumRegular
     <PHAssetCollection: 0x1004457c0>title:"最近删除", subtitle:"(null)" assetCollectionType=2/1000000201
     <PHAssetCollection: 0x100417620> title:"全景照片", subtitle:"(null)" assetCollectionType=2/201
     <PHAssetCollection: 0x1004a9eb0>title:"最近添加", subtitle:"(null)" assetCollectionType=2/206
     <PHAssetCollection: 0x100405f20> title:"延时摄影", subtitle:"(null)" assetCollectionType=2/204
     <PHAssetCollection: 0x1004a7ff0>title:"连拍快照", subtitle:"(null)" assetCollectionType=2/207
     <PHAssetCollection: 0x1004a4720>title:"视频", subtitle:"(null)" assetCollectionType=2/202
     <PHAssetCollection: 0x100462b50>title:"个人收藏", subtitle:"(null)" assetCollectionType=2/203
     <PHAssetCollection: 0x10044ed40>title:"相机胶卷", subtitle:"(null)" assetCollectionType=2/209
     <PHAssetCollection: 0x10049e1b0>title:"自拍", subtitle:"(null)" assetCollectionType=2/210
     <PHAssetCollection: 0x1004a3c00>title:"已隐藏", subtitle:"(null)" assetCollectionType=2/205
     <PHAssetCollection: 0x10041e610>title:"屏幕快照", subtitle:"(null)" assetCollectionType=2/211
     <PHAssetCollection: 0x1004a2680>title:"慢动作", subtitle:"(null)" assetCollectionType=2/208
     */
     PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for(PHAssetCollection *sysAssetCollection in smartAlbums ){
        
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:sysAssetCollection options:option];
        if (fetchResult.count == 0) continue;
        
        if ([sysAssetCollection.localizedTitle containsString:@"Hidden"] || [sysAssetCollection.localizedTitle isEqualToString:@"已隐藏"]) continue;
        
        if ([sysAssetCollection.localizedTitle containsString:@"Deleted"] || [sysAssetCollection.localizedTitle isEqualToString:@"最近删除"]) continue;
        
        [usrAssetCollectionArrM addObject:sysAssetCollection];
    }
    
    
    return usrAssetCollectionArrM;
    
}

#pragma mark- 相册资源相关
/** 将 asset 保存到指定的相册 (将asset 从相机胶卷copy 一份到 assetCollection)*/
+(BOOL)saveAsset:(PHAsset *)asset toAssetCollction:(PHAssetCollection *)assetCollection{
    
    if (asset != nil  && assetCollection != nil) {
         return  [self saveAssetArr:@[asset] toAssetCollction:assetCollection];
    }
    
    return nil;
}

/** 将 asset 保存到 指定的相册(自己)(将asset 从相机胶卷copy 一份到 assetCollection) */
-(BOOL)saveAsset:(PHAsset *)asset{
    if(asset){
       return [self saveAssetArr:@[asset]];
    }
    return NO;
  
}


/** 将 一堆 asset 保存到指定的相册 (将asset 从相机胶卷copy 一份到 assetCollection)  */
+(BOOL)saveAssetArr:(NSArray<PHAsset *> *)assetArr toAssetCollction:(PHAssetCollection *)assetCollection{
    
    if(assetArr.count == 0 || assetCollection == nil){
        return NO;
    }
    
    NSError *err = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request =  [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        
        
        [request addAssets:assetArr];
        
        //PHObjectPlaceholder *assetPlaceHolder =
        //[request addAssets:@[assetPlaceHolder]]; 这里也可以放图片的站位对象,也是可以的
    } error:&err];
    
    
    return (err == nil);
    
}

/** 将 一堆 asset 保存到 指定的相册(自己) (将asset 从相机胶卷copy 一份到 assetCollection)*/
-(BOOL)saveAssetArr:(NSArray<PHAsset *> *)assetArr{
    if(assetArr.count == 0){
        return NO;
    }
    NSError *err = nil;
    __weak typeof(self) weakSelf = self;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request =  [PHAssetCollectionChangeRequest changeRequestForAssetCollection:weakSelf];
        [request addAssets:assetArr];
    } error:&err];
    
    return (err == nil);
}

#pragma mark- 照片相关
/** 将 image 保存到指定的相册 (将asset 从相机胶卷copy 一份到 assetCollection)*/
+(BOOL)saveImage:(UIImage  *)image toAssetCollction:(PHAssetCollection *)assetCollection{
    if(image == nil || assetCollection == nil){
        return NO;
    }
    PHAsset *asset = [PHAsset saveImage2SystemCameraRollAlbum:image];
    if (asset) {
      return   [self saveAsset:asset toAssetCollction:assetCollection];
    }
    return NO;
}

/** 将 image 保存到 指定的相册(自己)(将asset 从相机胶卷copy 一份到 assetCollection) */
-(BOOL)saveImage:(UIImage  *)image{
    if(image == nil){
        return NO;
    }
    PHAsset *asset = [PHAsset saveImage2SystemCameraRollAlbum:image];
    if (asset) {
        return   [self saveAsset:asset];
    }
    return NO;
}


/** 将 asset 作为相册的封面*/
-(BOOL)changeAssetAsAlbumCover:(PHAsset *)asset{
    
    if(asset == nil){
        return NO;
    }
    NSError *err = nil;
    __weak typeof(self) weakSelf = self;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
      PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:weakSelf];
        
        [request insertAssets:@[asset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
        
    } error:&err];
    
    return err = nil;
}


#pragma mark- <#说明文字#>

/**
 系统相册子类型说明:
 typedef NS_ENUM(NSInteger, PHAssetCollectionSubtype) {
 
 // PHAssetCollectionTypeAlbum regular subtypes
 PHAssetCollectionSubtypeAlbumRegular         = 2,
 PHAssetCollectionSubtypeAlbumSyncedEvent     = 3,
 PHAssetCollectionSubtypeAlbumSyncedFaces     = 4,
 PHAssetCollectionSubtypeAlbumSyncedAlbum     = 5,
 PHAssetCollectionSubtypeAlbumImported        = 6,
 
 // PHAssetCollectionTypeAlbum shared subtypes
 PHAssetCollectionSubtypeAlbumMyPhotoStream   = 100,
 PHAssetCollectionSubtypeAlbumCloudShared     = 101,
 
 // PHAssetCollectionTypeSmartAlbum subtypes
 PHAssetCollectionSubtypeSmartAlbumGeneric    = 200,
 PHAssetCollectionSubtypeSmartAlbumPanoramas  = 201,
 PHAssetCollectionSubtypeSmartAlbumVideos     = 202,
 PHAssetCollectionSubtypeSmartAlbumFavorites  = 203,
 PHAssetCollectionSubtypeSmartAlbumTimelapses = 204,
 PHAssetCollectionSubtypeSmartAlbumAllHidden  = 205,
 PHAssetCollectionSubtypeSmartAlbumRecentlyAdded = 206,
 PHAssetCollectionSubtypeSmartAlbumBursts     = 207,
 PHAssetCollectionSubtypeSmartAlbumSlomoVideos = 208,
 PHAssetCollectionSubtypeSmartAlbumUserLibrary = 209,
 PHAssetCollectionSubtypeSmartAlbumSelfPortraits    PHOTOS_AVAILABLE_IOS_TVOS(9_0, 10_0) = 210,
 PHAssetCollectionSubtypeSmartAlbumScreenshots      PHOTOS_AVAILABLE_IOS_TVOS(9_0, 10_0) = 211,
 PHAssetCollectionSubtypeSmartAlbumDepthEffect      PHOTOS_AVAILABLE_IOS_TVOS(10_2, 10_1) = 212,
 PHAssetCollectionSubtypeSmartAlbumLivePhotos       PHOTOS_AVAILABLE_IOS_TVOS(10_3, 10_2) = 213,
 PHAssetCollectionSubtypeSmartAlbumAnimated         PHOTOS_AVAILABLE_IOS_TVOS(11_0, 11_0) = 214,
 PHAssetCollectionSubtypeSmartAlbumLongExposures    PHOTOS_AVAILABLE_IOS_TVOS(11_0, 11_0) = 215,
 } PHOTOS_ENUM_AVAILABLE_IOS_TVOS(8_0, 10_0);

 */

/** 根据相册的子类型 获取相册的类型 */
+ (PHAssetCollectionType)assetCollectionTypeType_OfAssetCollectionSubType:(PHAssetCollectionSubtype)subtype{
    
    return (subtype >= PHAssetCollectionSubtypeSmartAlbumGeneric) ? PHAssetCollectionTypeSmartAlbum : PHAssetCollectionTypeAlbum;
}




@end
