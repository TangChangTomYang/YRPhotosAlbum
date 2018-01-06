//
//  YRPreviewToolBar.m
//  YRAlbumTool
//
//  Created by yangrui on 2018/1/4.
//  Copyright © 2018年 　yangrui. All rights reserved.
//

#import "YRPreviewToolBar.h"

@interface YRPreviewToolBar ()
@property (weak, nonatomic) IBOutlet UIButton *previewBtn;

@property (weak, nonatomic) IBOutlet UILabel *countLb;
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countLbWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *previewBtnWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *topLine;

@end


@implementation YRPreviewToolBar

+(instancetype)toolBarWithFrame:(CGRect)frame{
   YRPreviewToolBar *toolBar = [[[NSBundle mainBundle] loadNibNamed:@"YRPreviewToolBar" owner:nil options:nil] lastObject];
    
    toolBar.frame = frame;
    return toolBar;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = GHColor(253, 263, 253);
    self.countLb.layer.cornerRadius = 10;
    self.countLb.layer.masksToBounds = YES;
    self.countLb.hidden = YES;
    
    
    
}
-(void)hidePreviewBtn{
    self.previewBtnWidthConstraint.constant = 0;
    self.previewBtn.hidden = YES;
}


-(void)hideTopLine{
    self.topLine.hidden = YES;
}

-(void)setAssetSize:(NSString *)assetSizeStr{
    if (assetSizeStr.length == 0) {
        assetSizeStr = @"";
    }
    
    if (self.originBtn.selected == NO) {
         assetSizeStr = @"";
    }
    
    [self.originBtn setTitle:[NSString stringWithFormat:@"原图%@",assetSizeStr] forState:UIControlStateNormal];
    
}
-(void)setSelectedCount:(NSInteger)selectedCount{
    _selectedCount = selectedCount;
    self.countLb.hidden = (selectedCount == 0);
    self.countLb.text = [NSString stringWithFormat:@"%ld",selectedCount];
    CGSize size = [self.countLb.text sizeWithFont:self.countLb.font];
    self.countLbWidthConstraint.constant = size.width < 20 ? 20 : size.width;
}

- (IBAction)previewBtnClick:(UIButton *)btn {
    [self.delegate toolBar:self didClickPreviewBtn:btn];
}
- (IBAction)ortiginBtnClick:(UIButton *)btn{
    [self.delegate toolBar:self didClickOrtiginBtn:btn];
}
- (IBAction)completeBtnClick:(UIButton *)btn{
    [self.delegate toolBar:self didClickCompleteBtn:btn];
}



@end
