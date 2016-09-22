//
//  MultiPhotoChooseViewController.m
//  PhotoChoose
//
//  Created by wsz on 16/9/22.
//  Copyright © 2016年 wsz. All rights reserved.
//

#define MAXCOUNT 9
#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height

#define REUSEIDENTIFIER @"MultiPhotoCollectionCell"

#import "MultiPhotoChooseViewController.h"
#import "MultiPhotoCollectionCell.h"
#import "MultiChooseImagePicker.h"

@interface MultiPhotoChooseViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, MultiChooseImagePickerDelegate>

@property(nonatomic, strong)NSArray *selectedImgArray;
@property(nonatomic, strong)UICollectionView *collectionView;

@end

@implementation MultiPhotoChooseViewController

- (NSArray *)selectedImgArray
{
    if (_selectedImgArray == nil)
    {
        _selectedImgArray = [NSArray new];
    }
    return _selectedImgArray;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        CGFloat cellWidth = (SCREENWIDTH - 15) / 4;
        layout.itemSize = CGSizeMake(cellWidth, cellWidth);
        
        [_collectionView registerClass:[MultiPhotoCollectionCell class] forCellWithReuseIdentifier:REUSEIDENTIFIER];
    }
    return _collectionView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"图片多选";
    
    [self.view addSubview:self.collectionView];

}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.selectedImgArray.count < MAXCOUNT)
    {
        return self.selectedImgArray.count + 1;
    }
    else
    {
        return MAXCOUNT;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MultiPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:REUSEIDENTIFIER forIndexPath:indexPath];
    
    if (indexPath.item == self.selectedImgArray.count)
    {
        cell.image = [UIImage imageNamed:@"add"];
    }
    else
    {
        cell.image = self.selectedImgArray[indexPath.item];
    }
    
    return cell;
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"item == %d", (int)indexPath.item);
    
    if (indexPath.item == self.selectedImgArray.count)
    {
        MultiChooseImagePicker *imagePicker = [MultiChooseImagePicker new];
        imagePicker.delegate = self;
        [self.navigationController pushViewController:imagePicker animated:YES];
    }
}

#pragma mark -- MultiChooseImagePickerDelegate
- (void)selectedFinish:(NSArray *)selectedArray
{
    self.selectedImgArray = selectedArray;
    [self.collectionView reloadData];
}


@end
