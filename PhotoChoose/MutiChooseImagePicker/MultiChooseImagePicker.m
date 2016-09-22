//
//  MultiChooseImagePicker.m
//  PhotoChoose
//
//  Created by wsz on 16/9/22.
//  Copyright © 2016年 wsz. All rights reserved.
//

//PHAsset: 代表照片库中的一个资源，跟 ALAsset 类似，通过 PHAsset 可以获取和保存资源
//PHFetchOptions: 获取资源时的参数，可以传 nil，即使用系统默认值
//PHFetchResult: 表示一系列的资源集合，也可以是相册的集合
//PHAssetCollection: 表示一个相册或者一个时刻，或者是一个「智能相册（系统提供的特定的一系列相册，例如：最近删除，视频列表，收藏等等，如下图所示）
//PHImageManager: 用于处理资源的加载，加载图片的过程带有缓存处理，可以通过传入一个 PHImageRequestOptions 控制资源的输出尺寸等规格
//PHImageRequestOptions: 如上面所说，控制加载图片时的一系列参数

#import "MultiChooseImagePicker.h"
#include <Photos/Photos.h>

@interface MultiChooseImagePicker ()

@end

@implementation MultiChooseImagePicker

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *confirmBar = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmBtnClick)];
    self.navigationItem.rightBarButtonItem = confirmBar;
    
    [self loadAllImageSource];
}

#pragma mark -- 确定按钮点击
- (void)confirmBtnClick
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 加载所有的图片
- (void)loadAllImageSource
{
    NSMutableArray *imageArray = [NSMutableArray new];
    
    //列出所有相册智能相册
    //    PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    //列出所有用户创建的相册
    //    PHFetchResult *topLevelUserCollections = [PHAssetCollection fetchTopLevelUserCollectionsWithOptions:nil];
    
    //获取所有资源的集合，并按照资源的创建时间排序
    PHFetchOptions *options = [PHFetchOptions new];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
    
    //在资源的集合中获取第一个集合，并获取其中的图片
    PHImageManager *imageManager = [PHImageManager defaultManager];
    
    PHImageRequestOptions *requestOptions = [PHImageRequestOptions new];
    requestOptions.synchronous = YES;
    
    for (PHAsset *asset in assetsFetchResults)
    {
        CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        
        [imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [imageArray addObject:result];
        }];
    }
}

@end
