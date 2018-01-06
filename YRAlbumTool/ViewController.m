//
//  ViewController.m
//  YRAlbumTool
//
//  Created by 　yangrui on 2017/11/22.
//  Copyright © 2017年 　yangrui. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
#import "YRAlbum_ViewController.h"
#import "TZLocationManager.h"
@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property(nonatomic, strong)UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   // [self.navigationController pushViewController: [TestViewController new] animated:YES];;
    
//    [self.navigationController pushViewController:[[YRPhotoListViewController alloc]init] animated:YES];
//    return;
    [self albumn];
}

-(void)albumn{
    
    YRAlbum_collectionViewController *albumListVC = [[YRAlbum_collectionViewController alloc] init];
    albumListVC.completeCallBack = ^(NSArray<PHAsset *> *selectedAssetArr) {
        
        NSLog(@"selectedAssetArr: %@",selectedAssetArr);
    } ;
    
    YRAlbum_NavigationController *nav = [[YRAlbum_NavigationController alloc]initWithRootViewController:albumListVC];
    
    
   YRAlbum_PhotoListViewController *photoListVc = [[YRAlbum_PhotoListViewController alloc]init];
    [nav pushViewController:photoListVc animated:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:nav animated:YES completion:nil];
    });
    
}


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
- (IBAction)btnClick:(id)sender {
    [self pushImagePickerController];
    
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
