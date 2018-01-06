//
//  GHAlbumListViewController.m
//  YRAlbumTool
//
//  Created by 　yangrui on 2017/11/22.
//  Copyright © 2017年 　yangrui. All rights reserved.
//

#import "YRAlbum_collectionViewController.h"
#import <Photos/Photos.h>
#import "YRAlbumCell.h"

@interface YRAlbum_collectionViewController ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong) NSMutableArray<PHAssetCollection *> *smartAlbumCollections;


@property(nonatomic, strong)PHAssetCollection *appAlbum;

@end

@implementation YRAlbum_collectionViewController
-(PHAssetCollection *)appAlbum{
    if (!_appAlbum) {
        _appAlbum =     [PHAssetCollection customAlbumForApp];
    }
    return _appAlbum;
}


-(void)setSelectedAssetArrM:(NSMutableArray<PHAsset *> *)selectedAssetArrM{
    [super setSelectedAssetArrM:selectedAssetArrM];
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tableView];
    [self cancleScrollViewAutoAdjusTopContentInset];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

-(void)cancleScrollViewAutoAdjusTopContentInset{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark- lazy
-(UITableView *)tableView{
    if (!_tableView) {
        
        
        CGRect frame  = CGRectMake(0, kNaviH, kScreenW, kScreenH - (kNaviH + kBottomMargin));
        _tableView =  [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 70;

    }
    return _tableView;
}


-(NSMutableArray<PHAssetCollection *> *)smartAlbumCollections{
    if (!_smartAlbumCollections) {
        _smartAlbumCollections = [PHAssetCollection thirdPartyUserImageAssetClloctionArr];
        
    }
     return _smartAlbumCollections;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.smartAlbumCollections.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"album";
    
    YRAlbumCell *cell = (YRAlbumCell *)[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YRAlbumCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    PHAssetCollection *assetCollection = self.smartAlbumCollections[indexPath.row];
    cell.assetCollection = assetCollection;
    cell.selectedCount = 0;//[self selectedAssetInAssetCollection:assetCollection];
    
    cell.detailTextLabel.text = nil;
    return cell;
}

-(NSInteger )selectedAssetInAssetCollection:(PHAssetCollection *)assetCollection{
    NSInteger containCount = 0;
    
    NSMutableArray *assetArrM = [PHAsset allImageAsset_InAssetCollcetion:assetCollection];
    
    for (PHAsset *asset  in assetArrM) {
        for (PHAsset *sAsset in self.selectedAssetArrM) {
            
            if ([asset.localIdentifier isEqualToString:sAsset.localIdentifier]) {
                containCount ++;
            }
        }
    }
    
   return  containCount;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PHAssetCollection *assetCollection = self.smartAlbumCollections[indexPath.row];

    YRAlbum_PhotoListViewController *photoListVc = [[YRAlbum_PhotoListViewController alloc]init];
    photoListVc.assetCollection = assetCollection;
    photoListVc.selectedAssetArrM = self.selectedAssetArrM;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    [self.navigationController pushViewController:photoListVc animated:YES];
}




-(void)dismissModalViewControllerAnimated:(BOOL)animated{
    [super dismissModalViewControllerAnimated:animated];
    
}








@end
