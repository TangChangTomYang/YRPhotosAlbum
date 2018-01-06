//
//  PHPhotosFetchUsrStatusTool.m
//  YRAlbumTool
//
//  Created by yangrui on 2017/12/3.
//  Copyright © 2017年 　yangrui. All rights reserved.
//

#import "PHPhotosFetchUsrStatusTool.h"

@implementation PHPhotosFetchUsrStatusTool



/** 获取用户 相册访问的权限, */
+(void)fetchPHAuthorizationTypeCallBack:(void(^)(PHAuthorizationType authorizationType))authorizationTypeCallBack;{
    // 1. 获取当前的授权状态
    PHAuthorizationStatus  oldStatus = [PHPhotoLibrary authorizationStatus];
    
    /** 请求\ 查询访问权限
     1.如果用户之前还没做出选择(第一次使用),会自动弹框.弹框后用户做出选择,才会调用block
     2.如果用户之前做过选择了会直接回调block,并且不会弹框.
     3.也就是说 block 只有在用户 做过选择后才会调用,也就是说不会出现 用户不确定的情况(PHAuthorizationStatusNotDetermined)
     
     */
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        // block 子线程调用
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (status == PHAuthorizationStatusRestricted) {
                // 用户被限制,不能使用
                authorizationTypeCallBack(PHAuthorizationType_Restricted);
            }
            else if (status == PHAuthorizationStatusDenied) {
                
                if(oldStatus == PHAuthorizationStatusNotDetermined){
                    //弹框后用户选择 拒绝
                    authorizationTypeCallBack(PHAuthorizationType_Denied);
                    
                }else{
                    // 需要弹框告诉用户打开
                    authorizationTypeCallBack(PHAuthorizationType_DeniedNeedShowTip);
                }
            }
            else if (status == PHAuthorizationStatusAuthorized) {//用户未决定
                // 用户可以使用
                authorizationTypeCallBack(PHAuthorizationType_Authorized);
            }
            
        });
        NSLog(@"status : %ld",status);
        
    }];
    
}
@end
