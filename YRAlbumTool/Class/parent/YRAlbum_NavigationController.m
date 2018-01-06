//
//  YRAlbumNavigationController.m
//  YRAlbumTool
//
//  Created by 　yangrui on 2017/11/22.
//  Copyright © 2017年 　yangrui. All rights reserved.
//

#import "YRAlbum_NavigationController.h"

@interface YRAlbum_NavigationController ()

@end

@implementation YRAlbum_NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = YRAlbumVCView_backGroundColor;
    
    
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.translucent = YES;
    self.navigationBar.barTintColor =  YRAlbumNavBar_BarTintColor;
    self.navigationBar.tintColor = YRAlbumNavBar_TintColor;

}


// 拦截push事件
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count ) { // 说明时push 出来的
        UIBarButtonItem *leftItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStyleDone target:self action:@selector(leftItemClick)];
        
        viewController.navigationItem.leftBarButtonItem = leftItem;
    }
   
    
    [super pushViewController:viewController animated:animated];
    
}

-(void)leftItemClick{
    
    [self popViewControllerAnimated:YES];
    
}

@end
