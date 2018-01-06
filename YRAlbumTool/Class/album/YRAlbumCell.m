//
//  YRAlbumListCell.m
//  YRAlbumTool
//
//  Created by 　yangrui on 2017/11/23.
//  Copyright © 2017年 　yangrui. All rights reserved.
//

#import "YRAlbumCell.h"
//#import "PHAssetCollection+custom.h"
//#import "PHAsset+custom.h"

@interface YRAlbumCell ()

@property(nonatomic, strong)UILabel   *selectedCountLb;
@end


@implementation YRAlbumCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self selectedCountLb];
    }
    return self;
}


-(UILabel *)selectedCountLb{
    if (!_selectedCountLb) {
        _selectedCountLb = [[UILabel alloc] initWithFrame:CGRectZero];
        _selectedCountLb.backgroundColor = [UIColor greenColor];
        _selectedCountLb.font = [UIFont systemFontOfSize:14];
        _selectedCountLb.textAlignment = NSTextAlignmentCenter;
        _selectedCountLb.textColor = [UIColor whiteColor];
        [self addSubview: _selectedCountLb];
    }
    return _selectedCountLb;
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self updateSelectedCountLbFrame];
    
}


-(void)setAssetCollection:(PHAssetCollection *)assetCollection{
    _assetCollection = assetCollection;
    
    if (assetCollection) {
        PHAsset *asset = [PHAsset fengMianImageAssetInAssetCollcetion:assetCollection];
        __weak typeof( self) weakSelf = self;
        [PHAsset requestImageForAsset:asset size:CGSizeMake(60, 60) callBack:^(UIImage *assetImage) {
            weakSelf.imageView.image = assetImage;
            
        }];
        
        
        
        NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:assetCollection.localizedTitle attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
        
        NSAttributedString *countString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  (%zd)",[PHAsset allImageAsset_InAssetCollcetion:assetCollection].count] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        [nameString appendAttributedString:countString];
        
        self.textLabel.attributedText = nameString;
    }
    
    else{
        
        
        self.textLabel.text  = nil;
        self.imageView.image = nil;
    }
  
}


-(void)setSelectedCount:(NSInteger)selectedCount{
    _selectedCount = selectedCount;
    
    self.selectedCountLb.text = selectedCount > 0 ? [NSString stringWithFormat:@"%ld",selectedCount] : @"";
 
    if (self.selectedCountLb.text.length > 0) {
       
        [self updateSelectedCountLbFrame];
    }
    self.selectedCountLb.hidden = (self.selectedCountLb.text.length == 0);
  
}


-(void)updateSelectedCountLbFrame{
    CGSize size =  [self.selectedCountLb.text sizeWithFont:self.selectedCountLb.font];
    if (size.width < size.height) {
        size = CGSizeMake(size.height, size.height);
    }
    
    self.selectedCountLb.frame = CGRectMake(self.width - size.width - 40, (self.height - size.height) * 0.5, size.width, size.height);
    
    
    self.selectedCountLb.layer.cornerRadius =  self.selectedCountLb.height * 0.5;
    self.selectedCountLb.layer.masksToBounds = YES;
}

@end
