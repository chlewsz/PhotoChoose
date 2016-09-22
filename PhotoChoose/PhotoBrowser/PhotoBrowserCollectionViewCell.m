//
//  PhotoBrowserCollectionViewCell.m
//  PhotoChoose
//
//  Created by wsz on 16/9/22.
//  Copyright © 2016年 wsz. All rights reserved.
//

#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height

#import "PhotoBrowserCollectionViewCell.h"

@interface PhotoBrowserCollectionViewCell ()<UIScrollViewDelegate>
{
    UIScrollView *contentScrollView;
    UIImageView *imageView;
}

@end

@implementation PhotoBrowserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        contentScrollView = [[UIScrollView alloc]initWithFrame:self.contentView.frame];
        contentScrollView.delegate = self;
        contentScrollView.userInteractionEnabled = YES;
        contentScrollView.showsHorizontalScrollIndicator = YES;
        contentScrollView.showsVerticalScrollIndicator = YES;
        contentScrollView.bounces = YES;
        
        contentScrollView.minimumZoomScale = 1.0f;
        contentScrollView.maximumZoomScale = 2.0f;
        contentScrollView.zoomScale = 1.0f;
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTapGesture setNumberOfTapsRequired:2];
        [contentScrollView addGestureRecognizer:doubleTapGesture];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
        [contentScrollView addGestureRecognizer:tapGesture];
        
        [self.contentView addSubview:contentScrollView];
        
        imageView = [UIImageView new];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [contentScrollView addSubview:imageView];
    }
    return self;
}
- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(singleTapClick)])
    {
        [self.delegate singleTapClick];
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)gesture
{
    if (contentScrollView.zoomScale == contentScrollView.maximumZoomScale)
    {
        [contentScrollView setZoomScale:contentScrollView.minimumZoomScale animated:YES];
    }
    else
    {
        [contentScrollView setZoomScale:contentScrollView.maximumZoomScale animated:YES];
    }
}

#pragma mark -- UIScrollViewDelegate
//设置被缩放的View
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    
    [imageView setCenter:CGPointMake(xcenter, ycenter)];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if(scrollView.zoomScale <= 1)
    {
        scrollView.zoomScale = 1.0f;
    }
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    imageView.image = image;
    [self calculateImageViewFrame];//该步计算必须要，防止scrollViewContentSize计算不准
}

- (void)calculateImageViewFrame
{
    CGSize imageSize = imageView.image.size;
    CGFloat imgWidth = imageSize.width;
    CGFloat imgHeight = imageSize.height;
    
    CGFloat showWidth, showHeight;
    
    if (imgWidth >= imgHeight)
    {
        //宽图
        if (imgWidth > SCREENWIDTH)
        {
            //比屏幕宽
            CGFloat scale = SCREENWIDTH / imgWidth;
            
            //确定显示的宽高
            showWidth = imgWidth * scale;
            showHeight = imgHeight * scale;
        }
        else
        {
            //比屏幕窄，直接居中显示
            showWidth = imgWidth;
            showHeight = imgHeight;
        }
    }
    else
    {
        //高图
        CGFloat widthScale = SCREENWIDTH / imgWidth;
        CGFloat heightScale = SCREENHEIGHT / imgHeight;
        
        BOOL isFat = imgWidth * heightScale > SCREENWIDTH;//胖的？
        
        CGFloat scale = isFat ? widthScale : heightScale;
        if (imgHeight > SCREENHEIGHT)
        {
            //比屏幕高
            //确定宽高
            showWidth = imgWidth * scale;
            showHeight = imgHeight * scale;
        }
        else
        {
            if (imgWidth > SCREENWIDTH)
            {
                //确定宽高
                showWidth = imgWidth * scale;
                showHeight = imgHeight * scale;
            }
            else
            {
                showWidth = imgWidth;
                showHeight = imgHeight;
            }
        }
    }
    
    CGPoint center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 2);
    
    CGFloat x = center.x - showWidth *.5f;
    CGFloat y = center.y - showHeight * .5f;
    CGRect frame = (CGRect){CGPointMake(x, y),CGSizeMake(showWidth, showHeight)};
    
    imageView.frame = frame;
}

- (CGFloat)getCurrentScale
{
    return contentScrollView.zoomScale;
}

- (void)resetUI
{
    contentScrollView.frame = self.contentView.frame;
    contentScrollView.zoomScale = 1.0f;
}
@end
