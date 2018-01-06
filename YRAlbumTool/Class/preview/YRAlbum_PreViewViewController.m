//
//  YRPreViewViewController.m
//  YRAlbumTool
//
//  Created by yangrui on 2018/1/4.
//  Copyright © 2018年 　yangrui. All rights reserved.
//

#import "YRAlbum_PreViewViewController.h"
#import "YRPreviewToolBar.h"
#import "YRPreviewCell.h"



@interface YRAlbum_PreViewViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,YRPreviewToolBarDelegate>


@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)YRPreviewToolBar *toolBar;
@property(nonatomic, strong)UIButton *rightItemBtn;

@end

@implementation YRAlbum_PreViewViewController


-(YRPreviewToolBar *)toolBar{
    if (!_toolBar) {
        
        _toolBar = [YRPreviewToolBar toolBarWithFrame:CGRectMake(0, kScreenH - KBottomToolBarH, kScreenW, KBottomToolBarH)];
        _toolBar.delegate = self;
        _toolBar.backgroundColor  = YRAlbumNavBar_BarTintColor;
        
        [_toolBar.originBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_toolBar.originBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_toolBar hidePreviewBtn];
        
        [self.view addSubview:_toolBar];
    }
    return _toolBar;
    
}

-(UICollectionView *)collectionView{
    
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [self collectionLayout];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentOffset = CGPointMake(0, 0);
        
        [self.view addSubview:_collectionView];
        
        [_collectionView registerClass:[YRPreviewCell class] forCellWithReuseIdentifier:@"YRPreviewCell"];
        
    }
    
    return _collectionView;
}

-(UICollectionViewFlowLayout *)collectionLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = self.view.bounds.size;
    layout.sectionInset = UIEdgeInsetsZero;;
    
    return layout;
}








- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupRightItem];
    [self collectionView];
    
    [self toolBar];
    [self cancleScrollViewAutoAdjusTopContentInset];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.index) [self.collectionView setContentOffset:CGPointMake((self.view.width) * self.index, 0) animated:NO];
    [self.collectionView reloadData];
    
    [self refreshNaviBarAndBottomBarState];
    
}



-(void)cancleScrollViewAutoAdjusTopContentInset{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) {
        
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetWidth = scrollView.contentOffset.x;
    offSetWidth = offSetWidth +  ((self.view.width ) * 0.5);
    
    NSInteger currentIndex = offSetWidth / (self.view.width );
    
    if (currentIndex < self.assetArrM.count && self.index != currentIndex) {
        self.index = currentIndex;
        [self refreshNaviBarAndBottomBarState];
    }
    
}

#pragma mark - UICollectionViewDataSource && Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger count = self.assetArrM.count;
    
    return count;
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    PHAsset *asset = self.assetArrM[indexPath.row];
    
    YRPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YRPreviewCell" forIndexPath:indexPath];
    cell.asset = asset;
    
    self.rightItemBtn.selected = [self isSelectedAssetArrMContainAsset:asset];
    
//    _index = indexPath.row;
//    [self refreshNaviBarAndBottomBarState];
    
    __weak typeof(self) weakSelf = self;
    cell.singleTapGestureBlock = ^{
         [weakSelf didTapPreviewCell];
    };
    return cell;
}



#pragma mark - CellDelegate
- (void)didTapPreviewCell {
    
    self.toolBar.hidden = !self.toolBar.hidden;
    
    self.navigationController.navigationBarHidden = ! self.navigationController.navigationBarHidden;
}







#pragma mark- YRPreviewToolBarDelegate
-(void)toolBar:(YRPreviewToolBar *)toolBar  didClickPreviewBtn:(UIButton *)previewBtn{
    
    [self.navigationController pushViewController:[[YRAlbum_PreViewViewController alloc]init] animated:YES];
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


#pragma mark- 私有方法

-(void)setupRightItem{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [btn setImage:[UIImage imageNamed:@"YRphoto_def_previewVc"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"YRphoto_sel_photoPickerVc"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(rightItemBtnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    self.rightItemBtn = btn;
}



-(void)rightItemBtnClick{
    
    self.rightItemBtn.selected = ! self.rightItemBtn.selected ;
    PHAsset *currentAsset = self.assetArrM[self.index];
    if (self.rightItemBtn.selected == YES) {
        
        [self.selectedAssetArrM addObject:currentAsset];
    }
    else{
        
        [self selectedAssetArrMRemoveAsset:currentAsset];
    }
    
    [self updateOriginBtnSize];
    
    self.toolBar.selectedCount = self.selectedAssetArrM.count;
}

-(void)leftItemClick{
    NSInteger childCount = self.navigationController.childViewControllers.count;
    if (childCount > 1) {
        UIViewController *childVc = self.navigationController.childViewControllers[childCount- 2];
        if ([childVc isKindOfClass:[YRAlbum_ViewController class]]) {
            YRAlbum_PhotoListViewController *photoListViewVC = (YRAlbum_PhotoListViewController *)childVc;
            photoListViewVC.selectedAssetArrM = self.selectedAssetArrM;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)refreshNaviBarAndBottomBarState {
    PHAsset *asset = self.assetArrM[self.index];
    self.rightItemBtn.selected = [self isSelectedAssetArrMContainAsset:asset];
    
    [self updateOriginBtnSize];
    
    self.toolBar.selectedCount = self.selectedAssetArrM.count;
    
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

-(void)selectedAssetArrMRemoveAsset:(PHAsset *)asset{
    
    for (PHAsset *ass in self.selectedAssetArrM) {
        if ([ass.localIdentifier isEqualToString:asset.localIdentifier]) {
            [self.selectedAssetArrM removeObject:ass];
            return;
        }
    }
}


-(void)setIsOrigin:(BOOL)isOrigin{
    
    _isOrigin = isOrigin;
    self.toolBar.originBtn.selected = isOrigin;
    [self updateOriginBtnSize];
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

@end
