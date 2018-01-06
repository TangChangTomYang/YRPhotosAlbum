//
//  PHPhotosFetchUsrStatusTool.h
//  YRAlbumTool
//
//  Created by yangrui on 2017/12/3.
//  Copyright © 2017年 　yangrui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    PHAuthorizationType_Restricted,//被限制,不能访问相册
    PHAuthorizationType_Denied,    // 用户拒绝
    PHAuthorizationType_DeniedNeedShowTip,//用户拒绝需要提示打开思路
    PHAuthorizationType_Authorized// 用户允许访问

    
}PHAuthorizationType;

@interface PHPhotosFetchUsrStatusTool : NSObject


/** 获取用户 相册访问的权限, */
+(void)fetchPHAuthorizationTypeCallBack:(void(^)(PHAuthorizationType authorizationType))authorizationTypeCallBack;
@end
