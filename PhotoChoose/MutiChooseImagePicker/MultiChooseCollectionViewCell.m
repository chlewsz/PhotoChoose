//
//  MultiChooseCollectionViewCell.m
//  PhotoChoose
//
//  Created by wsz on 16/9/22.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "MultiChooseCollectionViewCell.h"

@interface MultiChooseCollectionViewCell ()
{
    UIImageView *imageView;
    UIButton *selectedBtn;
}

@end

@implementation MultiChooseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        CGFloat imageWidth = CGRectGetWidth(self.contentView.frame);
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
        [self.contentView addSubview:imageView];
        
        selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectedBtn.frame = CGRectMake(imageWidth - 20, 0, 20, 20);
        [selectedBtn setBackgroundImage:[UIImage imageNamed:@"img_normal"] forState:UIControlStateNormal];
        [selectedBtn setBackgroundImage:[UIImage imageNamed:@"img_select"] forState:UIControlStateSelected];
        [selectedBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:selectedBtn];
    }
    return self;
}

- (void)selectedBtnClick:(UIButton *)sender
{
    if (sender.isSelected)
    {
        sender.selected = NO;
        self.cellSelected = NO;
        
        if ([self.delegate respondsToSelector:@selector(cellChangedSelected:withImage:)])
        {
            [self.delegate cellChangedSelected:NO withImage:self.image];
        }
    }
    else if (![self.delegate selectedIsFull])
    {
        sender.selected = YES;
        self.cellSelected = YES;
        
        if ([self.delegate respondsToSelector:@selector(cellChangedSelected:withImage:)])
        {
            [self.delegate cellChangedSelected:YES withImage:self.image];
        }
    }
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    imageView.image = image;
}

- (void)setCellSelected:(BOOL)cellSelected
{
    _cellSelected = cellSelected;
    selectedBtn.selected = cellSelected;
}

@end
