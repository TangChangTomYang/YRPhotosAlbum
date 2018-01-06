//
//  YRPhotoListViewController.m
//  YRAlbumTool
//
//  Created by 　yangrui on 2017/11/22.
//  Copyright © 2017年 　yangrui. All rights reserved.
//

#import "YRAlbum_PhotoListViewController.h"
#import "YRPhotoListCell.h"
#import "YRPreviewToolBar.h"
#import "YRAlbum_PreViewViewController.h"



@interface YRAlbum_PhotoListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,YRPreviewToolBarDelegate,YRPhotoListCellDelegate>

@property(nonatomic, strong)YRPreviewToolBar *toolBar;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray<PHAsset *> *assetArrM;

@end

static CGFloat margin = 5;
@implementation YRAlbum_PhotoListViewController


#pragma mark- set get
-(void)setSelectedAssetArrM:(NSMutableArray<PHAsset *> *)selectedAssetArrM{
    [super setSelectedAssetArrM:selectedAssetArrM];
    self.toolBar.selectedCount = selectedAssetArrM.count ;
    [self updateOriginBtnSize];
    [self.collectionView reloadData];
}

@synthesize assetCollection = _assetCollection;

-(PHAssetCollection *)assetCollection{
    if (!_assetCollection ) {
        _assetCollection = [PHAssetCollection systemCameraRollAlbum];
        self.navigationItem.title = _assetCollection.localizedTitle;
    }
    return _assetCollection;
}

-(void)setAssetCollection:(PHAssetCollection *)assetCollection{
    
    _assetCollection = assetCollection;
    self.navigationItem.title = assetCollection.localizedTitle;
    [self.collectionView reloadData];
    
}


-(NSMutableArray<PHAsset *> *)assetArrM{
    if (!_assetArrM) {
        _assetArrM = [PHAsset allImageAsset_InAssetCollcetion:self.assetCollection];
    }
    return _assetArrM;
}


-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        NSInteger maxCountPerRow = 4;
        
        CGFloat itemSizeW = ([UIScreen mainScreen].bounds.size.width - margin* (maxCountPerRow + 1)) / maxCountPerRow;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.itemSize = CGSizeMake(itemSizeW, itemSizeW);
        layout.minimumLineSpacing = margin;
        layout.minimumInteritemSpacing = margin;
        layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        
        CGRect frame = CGRectMake(0, kNaviH, kScreenW, kScreenH - (kNaviH + KBottomToolBarH));
        _collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
        
        UINib *nib = [UINib nibWithNibName:@"YRPhotoListCell" bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:@"YRPhotoListCell"];
        [self.view addSubview:_collectionView];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
       
    }
    return _collectionView;
}


-(YRPreviewToolBar *)toolBar{
    if (!_toolBar) {
        _toolBar = [YRPreviewToolBar toolBarWithFrame:CGRectMake(0, kScreenH - KBottomToolBarH, kScreenW, KBottomToolBarH)];
        _toolBar.delegate = self;
        [self.view addSubview:_toolBar];
    }
    return _toolBar;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    __weak typeof(self) weakSelf = self;
    [PHPhotosFetchUsrStatusTool fetchPHAuthorizationTypeCallBack:^(PHAuthorizationType authorizationType) {
        
        if (authorizationType == PHAuthorizationType_Authorized) {
            
             [weakSelf collectionView];
             [weakSelf toolBar];
             [weakSelf cancleScrollViewAutoAdjusTopContentInset];
        }
        else  if (authorizationType == PHAuthorizationType_Denied) {
            GHLog(@"---------警告------------");
        }
        else  if (authorizationType == PHAuthorizationType_DeniedNeedShowTip) {
              GHLog(@"---------警告------------");
        }
        else  if (authorizationType == PHAuthorizationType_Restricted) {
//            [weakSelf collectionView];
            
        }
        
    }];
    
}







#pragma mark- UICollectionViewDelegate, UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.assetArrM.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YRPhotoListCell *cell =  (YRPhotoListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"YRPhotoListCell" forIndexPath:indexPath];
  
    PHAsset *asset = self.assetArrM[indexPath.row];
    cell.delegate = self;
    cell.asset = asset;
    cell.indexPath = indexPath;
    cell.isSelected = [self isSelectedAssetArrMContainAsset:asset];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YRAlbum_PreViewViewController *previewVC = [[YRAlbum_PreViewViewController alloc] init];
    previewVC.assetArrM = self.assetArrM;
    previewVC.selectedAssetArrM = self.selectedAssetArrM;
    previewVC.index = indexPath.row;
    previewVC.isOrigin = self.toolBar.originBtn.selected;
    
    [self.navigationController pushViewController:previewVC animated:YES];
    
}






#pragma mark- YRPhotoListCellDelegate
-(void)photoListCell:(YRPhotoListCell *)photoListCell  didClickSelecteBtn:(UIButton *)selecteBtn{
    
    if ([self isSelectedAssetArrMContainAsset:photoListCell.asset]) {
        
        [self  selectedAssetArrMRemoveAsset:photoListCell.asset];
    }
    else{
        [self.selectedAssetArrM addObject:photoListCell.asset];
    }
    
     self.toolBar.selectedCount = self.selectedAssetArrM.count ;
    [self updateOriginBtnSize];
  
    [self.collectionView reloadItemsAtIndexPaths:@[photoListCell.indexPath]];
}



#pragma mark- YRPreviewToolBarDelegate
-(void)toolBar:(YRPreviewToolBar *)toolBar  didClickPreviewBtn:(UIButton *)previewBtn{
  
    YRAlbum_PreViewViewController *previewVC = [[YRAlbum_PreViewViewController alloc] init];
    previewVC.assetArrM = self.assetArrM;
    previewVC.selectedAssetArrM = self.selectedAssetArrM;
    
    
    PHAsset *firstAsset = self.selectedAssetArrM.firstObject;
    if (firstAsset) {
        
        for (int i = 0 ;i < self.assetArrM.count; i++) {
            PHAsset *asset = self.assetArrM[i];
            if ([asset.localIdentifier isEqualToString:firstAsset.localIdentifier]) {
                previewVC.index = i;
                break;
            }
        }
    }
    previewVC.isOrigin = self.toolBar.originBtn.selected;
    [self.navigationController pushViewController:previewVC animated:YES];
}
-(void)toolBar:(YRPreviewToolBar *)toolBar  didClickOrtiginBtn:(UIButton *)ortiginBtn{
    ortiginBtn.selected = !  ortiginBtn.selected;
   
    [self updateOriginBtnSize];
}
-(void)toolBar:(YRPreviewToolBar *)toolBar  didClickCompleteBtn:(UIButton *)completeBtn{
    
    YRAlbum_collectionViewController *rootVC = self.navigationController.childViewControllers.firstObject;
    if (rootVC.completeCallBack != nil) {
        rootVC.completeCallBack(self.selectedAssetArrM);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)leftItemClick{
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    NSInteger childCount = self.navigationController.childViewControllers.count;
    if (childCount > 1) {
        UIViewController *childVc = self.navigationController.childViewControllers[childCount- 2];
        if ([childVc isKindOfClass:[YRAlbum_ViewController class]]) {
            YRAlbum_collectionViewController *albumListViewVC = (YRAlbum_collectionViewController *)childVc;
            albumListViewVC.selectedAssetArrM = self.selectedAssetArrM;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)rightItemClick{ // 取消
    YRAlbum_collectionViewController *rootVC = self.navigationController.childViewControllers.firstObject;
    if (rootVC.completeCallBack != nil) {
        rootVC.completeCallBack(nil);
    }
    [super rightItemClick];
}


#pragma mark- 私有方法

-(void)cancleScrollViewAutoAdjusTopContentInset{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


-(void)updateOriginBtnSize{
    
    if (self.toolBar.originBtn.selected == NO) {
        [self.toolBar setAssetSize:@""];
    }
    else{
        __weak typeof(self) weakSelf = self;
        [PHAsset  getAssetArrSize:self.selectedAssetArrM completion:^(NSString *totalBytes) {
            [weakSelf.toolBar setAssetSize:totalBytes];
        }];
        
    }
}

-(void)selectedAssetArrMRemoveAsset:(PHAsset *)asset{
    
    for (PHAsset *ass in self.selectedAssetArrM) {
        if ([ass.localIdentifier isEqualToString:asset.localIdentifier]) {
            [self.selectedAssetArrM removeObject:ass];
            return;
        }
    }
    
}

-(BOOL)isSelectedAssetArrMContainAsset:(PHAsset *)asset{
    
    if (self.selectedAssetArrM.count == 0) {
        return NO;
    }
    
    for (PHAsset *ass in self.selectedAssetArrM) {
        if ([ass.localIdentifier isEqualToString:asset.localIdentifier]) {
            return  YES;
        }
    }
    
    return NO;
}


@end
