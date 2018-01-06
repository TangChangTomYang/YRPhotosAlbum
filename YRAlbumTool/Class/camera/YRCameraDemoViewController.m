//
//  YRCameraDemoViewController.m
//  YRAlbumTool
//
//  Created by yangrui on 2018/1/6.
//  Copyright © 2018年 　yangrui. All rights reserved.
//

#import "YRCameraDemoViewController.h"
#import "TZLocationManager.h"
@interface YRCameraDemoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic, strong)UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;

@end

@implementation YRCameraDemoViewController

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        
        //让某一类控件在另一种控件中同时变现某种属性
        tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[YRAlbum_ViewController class]]];
        BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
        weakSelf.location = location;
    } failureBlock:^(NSError *error) {
        weakSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        
        _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}



#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (photo) {
        
        PHAsset *asset = [PHAsset saveImage2SystemCameraRollAlbum:photo] ;
        PHAssetCollection *appAlbum = [PHAssetCollection customAlbumForApp];
        BOOL rst =  [PHAssetCollection  saveAsset:asset toAssetCollction:appAlbum];
        NSLog(@"保存照片结果------: %d-------",rst);
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
