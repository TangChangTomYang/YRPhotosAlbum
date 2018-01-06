//
//  YRAlbumVC.m
//  YRAlbumTool
//
//  Created by 　yangrui on 2017/11/22.
//  Copyright © 2017年 　yangrui. All rights reserved.
//

#import "YRAlbum_ViewController.h"

@interface YRAlbum_ViewController ()



@end

@implementation YRAlbum_ViewController

@synthesize selectedAssetArrM = _selectedAssetArrM;
-(NSMutableArray<PHAsset *> *)selectedAssetArrM{
    if (!_selectedAssetArrM) {
        _selectedAssetArrM  = [NSMutableArray array];
    }
    return _selectedAssetArrM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupRightItem];
    [self setupLeftItem];
}

-(void)setupRightItem{
    
    if (self.navigationController ) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
}

-(void)setupLeftItem{
    if (self.navigationController.childViewControllers.count > 1) {
        UIBarButtonItem *leftItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStyleDone target:self action:@selector(leftItemClick)];
        self.navigationItem.leftBarButtonItem = leftItem;
        
    }
    
}



-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightItemClick{
    
    if(self.navigationController){
           [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } 
}


@end
