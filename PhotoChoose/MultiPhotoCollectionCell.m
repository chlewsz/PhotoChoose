//
//  MultiPhotoCollectionCell.m
//  PhotoChoose
//
//  Created by wsz on 16/9/22.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "MultiPhotoCollectionCell.h"

@interface MultiPhotoCollectionCell ()
{
    UIImageView *imageView;
}

@end

@implementation MultiPhotoCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        CGFloat imageWidth = CGRectGetWidth(self.contentView.frame);
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
        [self.contentView addSubview:imageView];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    imageView.image = image;
}

@end
