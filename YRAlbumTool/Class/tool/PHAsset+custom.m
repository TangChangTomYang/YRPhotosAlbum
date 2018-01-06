//
//  PHAsset+custom.m
//  PhotoDemo
//
//  Created by yangrui on 2017/11/4.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import "PHAsset+custom.h"

@implementation PHAsset (custom)
/** 获取指定相册的照片 资源 */
+(NSMutableArray<PHAsset *> *)allAsset_InAssetCollcetion:(PHAssetCollection *)assetCollection{
    
    if (assetCollection == nil) {
        return nil;
    }
    NSMutableArray *arrM = [NSMutableArray array];
    PHFetchResult *results = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    
    for (PHAsset *asset  in results) {
        [arrM addObject:asset];
    }
    return arrM  ;
}
/** 获取指定相册中的所有的 图片 */
+(NSMutableArray<PHAsset *> *)allImageAsset_InAssetCollcetion:(PHAssetCollection *)assetCollection{
    if (assetCollection == nil) {
        return nil;
    }
    NSMutableArray *arrM = [NSMutableArray array];
    PHFetchResult *results = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[self onlyImageOption]];
    
    for (PHAsset *asset  in results) {
        [arrM addObject:asset];
    }
    return arrM  ;
}

/** 获取指定相册的 视频资源 */
+(NSMutableArray<PHAsset *> *)allVideoAsset_InAssetCollcetion:(PHAssetCollection *)assetCollection{
    
    if (assetCollection == nil) {
        return nil;
    }
    NSMutableArray *arrM = [NSMutableArray array];
    PHFetchResult *results = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[self onlyVideoOption]];
    for (PHAsset *asset  in results) {
        [arrM addObject:asset];
    }
    return arrM  ;
}

/** 获取相册的封面 照片 */
+(PHAsset *)fengMianImageAssetInAssetCollcetion:(PHAssetCollection *)assetCollection{
    
 return    [[self allImageAsset_InAssetCollcetion:assetCollection] firstObject];
}

/** 保存照片到系统 的 相机胶卷相册 */
+(PHAsset *)saveImage2SystemCameraRollAlbum:(UIImage *)image{
    
    if (image == nil) {
        return nil;
    }
    NSError *err = nil;
    __block NSString *assetIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
      PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
      assetIdentifier =  request.placeholderForCreatedAsset.localIdentifier;
    } error:&err];
 
    if (err == nil ) {
        
        PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetIdentifier] options:nil];
        return   result.firstObject;
    }

    return nil;
}


/** 通过 一个  PHAsset 获取图片*/
+(void)requestImageForAsset:(PHAsset *)asset size:(CGSize)size callBack:(void(^)(UIImage *assetImage))callBack{
   
    if (asset.mediaType == PHAssetMediaTypeImage) {
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize imgSize = CGSizeMake(size.width * scale, size.height * scale);
        if (size.width == 0 || size.height == 0) {
            imgSize = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        }
        
        // 这个option 保证在返回照片时只调用一次
        PHImageRequestOptions *option = [self imageCallBackOnceOptions];
        
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                   targetSize:imgSize
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:option
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            if (callBack) {
                callBack(result);
            }
        }];
    }
    else {
        if (callBack) {
            callBack(nil);
        }
    }
}










#pragma mark- 私有方法
/** 获取图片 回调 一次的 配置选择 */
+(PHImageRequestOptions *)imageCallBackOnceOptions{
    PHImageRequestOptions *option =  [[PHImageRequestOptions alloc]init];
    // 指定请求是否同步执行, 默认情况下是异步执行
    // option.synchronous = YES;
    
    /**
     PHImageRequestOptionsResizeModeNone, 不缩放
     PHImageRequestOptionsResizeModeFast, 尽快地提供接近或稍微大于要求的尺寸
     PHImageRequestOptionsResizeModeExact,精准提供要求的尺寸
     resizeMode 默认是 None，这也造成了返回图像尺寸与要求尺寸不符。这点需要注意。要返回一个指定尺寸的图像需要避免两层陷阱：一定要指定 options 参数，resizeMode 不能为 None。
     */
    option.resizeMode = PHImageRequestOptionsResizeModeExact;
    /** 图像质量
     PHImageRequestOptionsDeliveryModeOpportunistic  在速度与质量中均衡,异步可能调多次,同步一次
     PHImageRequestOptionsDeliveryModeHighQualityFormat 不管花费多长时间，提供高质量图像      PHImageRequestOptionsDeliveryModeFastFormat 以最快速度提供好的质量。这个属性只有在 synchronous 为 true 时有效,同步无效,异步可能调多次。
     */
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    return option;
}

/** 获取图片 同步 请求选择 */
+(PHImageRequestOptions *)imageSyncOptions{
    PHImageRequestOptions *option =  [self imageCallBackOnceOptions];
    option.synchronous = YES;
    return option;
}


/** 只获取图片的 获取选项 */
+(PHFetchOptions *)onlyImageOption{
    
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
    
    return fetchOptions;
}

/** 只获取视频的 获取选项 */
+(PHFetchOptions *)onlyVideoOption{
    
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeVideo];
    
    return fetchOptions;
}

/** 只获取最近一周的 获取选项 */
+(PHFetchOptions *)lastWeekOption{
    
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"(creationDate >= %@)",[self lastWeek]];
    
    // assign options
   return  fetchOptions;
    
}





/** 最近一周 时间 */
+(NSDate *)lastWeek{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    components.day -= 7;
    NSDate *lastWeek  = [calendar dateFromComponents:components];
    
    return lastWeek;
}

/** 获取资源的大小 */
+(void)getAssetArrSize:(NSArray<PHAsset *> *)assetArr completion:(void (^)(NSString *totalBytes))completion {
    if (assetArr.count == 0) {
        if (completion) completion(@"(0)");
        return;
    }
    __block NSInteger dataLength = 0;
    __block NSInteger assetCount = 0;
    for (NSInteger i = 0; i < assetArr.count; i++) {
        
        PHAsset *asset = assetArr[i];
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                 dataLength += imageData.length;
                 assetCount ++;
                if (assetCount >= assetArr.count) {
                    NSString *bytes = [self getBytesFromDataLength:dataLength];
                    if (completion) completion(bytes);
                }
            }];
        }
        
    }
}

+(NSString *)getBytesFromDataLength:(NSInteger)dataLength {
    NSString *bytes;
    if (dataLength >= 0.1 * (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"(%0.1fM)",dataLength/1024/1024.0];
    } else if (dataLength >= 1024) {
        bytes = [NSString stringWithFormat:@"(%0.0fK)",dataLength/1024.0];
    } else {
        bytes = [NSString stringWithFormat:@"(%zdB)",dataLength];
    }
    return bytes;
}
@end
