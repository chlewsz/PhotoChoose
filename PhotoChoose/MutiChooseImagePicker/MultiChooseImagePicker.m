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


#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height

#define REUSEIDENTIFIER @"MultiChooseCollectionViewCell"

#define MAXCOUNT 9


#import "MultiChooseImagePicker.h"
#include <Photos/Photos.h>
#import "MultiChooseCollectionViewCell.h"
#import "PhotoBrowserViewController.h"

@interface MultiChooseImagePicker ()<UICollectionViewDataSource, UICollectionViewDelegate, MultiChooseCollectionViewCellDelagte>
{
    NSMutableArray *selectedArray;
    
    NSTimer *timer;
    
    PHImageManager *imageManager;
    PHImageRequestOptions *requestOptions;
}

@property(nonatomic, strong)NSMutableArray *imageAssetsArray;
@property(nonatomic, strong)UICollectionView *collectionView;

@end

@implementation MultiChooseImagePicker

- (NSMutableArray *)loadImageArray
{
    _imageAssetsArray = [NSMutableArray new];
       
    //列出所有相册智能相册
    //    PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    //列出所有用户创建的相册
    //    PHFetchResult *topLevelUserCollections = [PHAssetCollection fetchTopLevelUserCollectionsWithOptions:nil];
    
    //获取所有资源的集合，并按照资源的创建时间排序
    PHFetchOptions *options = [PHFetchOptions new];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
    
    for (PHAsset *asset in assetsFetchResults)
    {
        [_imageAssetsArray addObject:asset];
    }
    return _imageAssetsArray;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 + 10, SCREENWIDTH, SCREENHEIGHT - 64 - 10) collectionViewLayout:layout];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        CGFloat cellWidth = (SCREENWIDTH - 15) / 4;
        layout.itemSize = CGSizeMake(cellWidth, cellWidth);
        
        [_collectionView registerClass:[MultiChooseCollectionViewCell class] forCellWithReuseIdentifier:REUSEIDENTIFIER];
        
    }
    return _collectionView;
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageAssetsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MultiChooseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:REUSEIDENTIFIER forIndexPath:indexPath];

    cell.delegate = self;
    
    PHAsset *asset = self.imageAssetsArray[indexPath.row];
    
    CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    
    [imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        cell.image = result;
    }];
    
    return cell;
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoBrowserViewController *controller = [PhotoBrowserViewController new];
    controller.imageArray = self.imageAssetsArray;
    controller.currentIndex = (int)indexPath.item;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -- MultiChooseCollectionViewCellDelagte
- (BOOL)selectedIsFull
{
    if (selectedArray.count == MAXCOUNT)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)cellChangedSelected:(BOOL)isSelected withImage:(UIImage *)image
{
    if (isSelected)
    {
        [selectedArray addObject:image];
    }
    else
    {
        [selectedArray removeObject:image];
    }
    
    [self updateTitle];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    imageManager = [PHImageManager defaultManager];
    requestOptions = [PHImageRequestOptions new];
    requestOptions.synchronous = YES;//设置同步获取
    
    
    //提前调用，触发系统授权
    [self loadImageArray];
    
    //授权检查
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置->隐私->照片中为本应用授权" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (status == PHAuthorizationStatusNotDetermined)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 64 + 10, SCREENWIDTH, 200)];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"请允许授权后查看图片";
        [self.view addSubview:label];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(observeAuthorizationStatusChange) userInfo:nil repeats:YES];
    }
    else
    {
        UIBarButtonItem *confirmBar = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmBtnClick)];
        self.navigationItem.rightBarButtonItem = confirmBar;
        
        selectedArray = [NSMutableArray new];
        
        [self.view addSubview:self.collectionView];
    }
}

#pragma mark -- 未选择授权时监控授权变化
- (void)observeAuthorizationStatusChange
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized)
    {
        [timer invalidate];
        [self.view.subviews.lastObject removeFromSuperview];
        UIBarButtonItem *confirmBar = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmBtnClick)];
        self.navigationItem.rightBarButtonItem = confirmBar;
        
        selectedArray = [NSMutableArray new];
        
        [self loadImageArray];
        
        [self.view addSubview:self.collectionView];
    }
}

#pragma mark -- 确定按钮点击
- (void)confirmBtnClick
{
    if ([self.delegate respondsToSelector:@selector(selectedFinish:)])
    {
        [self.delegate selectedFinish:selectedArray];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateTitle
{
    if (0 == selectedArray.count)
    {
        self.title = @"";
    }
    else
    {
        self.title = [NSString stringWithFormat:@"%d/%d", (int)selectedArray.count, MAXCOUNT];
    }
}

@end
