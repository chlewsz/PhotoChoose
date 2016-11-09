//
//  PhotoBrowserViewController.m
//  PhotoChoose
//
//  Created by wsz on 16/9/22.
//  Copyright © 2016年 wsz. All rights reserved.
//

#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height

#define REUSEIDENTIFIER @"PhotoBrowserCollectionViewCell"

#import "PhotoBrowserViewController.h"
#import "PhotoBrowserCollectionViewCell.h"
#import <Photos/Photos.h>

@interface PhotoBrowserViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, PhotoBrowserCollectionViewCellDelegate>
{
    int imageArrayType;//数组类型，0：图片，1：PHAsset数组
    
    
    PHImageManager *imageManager;
    PHImageRequestOptions *requestOptions;
}

@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, assign)BOOL hiddenContent;

@end

@implementation PhotoBrowserViewController

- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    NSObject *object = _imageArray[0];
    if ([object isKindOfClass:[UIImage class]])
    {
        imageArrayType = 0;
    }
    else if ([object isKindOfClass:[PHAsset class]])
    {
        imageArrayType = 1;
        imageManager = [PHImageManager defaultManager];
        requestOptions = [PHImageRequestOptions new];
        requestOptions.synchronous = YES;//设置同步获取
    }
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[PhotoBrowserCollectionViewCell class] forCellWithReuseIdentifier:REUSEIDENTIFIER];
        flowLayout.itemSize = _collectionView.bounds.size;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
    }
    return _collectionView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.translucent = YES;
    
    [self.view addSubview:self.collectionView];
    
    
    self.title = [NSString stringWithFormat:@"%d/%d", _currentIndex + 1,  (int)_imageArray.count];
    self.collectionView.contentOffset = CGPointMake(_currentIndex * SCREENWIDTH, CGRectGetMinY(self.collectionView.frame));
}

- (BOOL)prefersStatusBarHidden
{
    if (_hiddenContent)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:REUSEIDENTIFIER forIndexPath:indexPath];
    
    if (1.0f != [cell getCurrentScale])
    {
        [cell resetUI];
    }
    
    cell.delegate = self;
    
    if (0 == imageArrayType)
    {
        cell.image = _imageArray[indexPath.item];
    }
    else if (1 == imageArrayType)
    {
        PHAsset *asset = _imageArray[indexPath.item];
        
        CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        
        [imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            cell.image = result;
        }];
    }
    
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentIndex = ceilf(scrollView.contentOffset.x / scrollView.bounds.size.width);
    self.title = [NSString stringWithFormat:@"%d/%d", _currentIndex + 1,  (int)_imageArray.count];
}

#pragma mark -- PhotoBrowserCollectionViewCellDelegate
- (void)singleTapClick
{
    if (_hiddenContent)
    {
        _hiddenContent = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        [self.navigationController.navigationBar setHidden:NO];
    }
    else
    {
        _hiddenContent = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [self.navigationController.navigationBar setHidden:YES];
    }
}


@end
