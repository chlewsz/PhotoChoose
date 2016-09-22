//
//  MultiChooseCollectionViewCell.h
//  PhotoChoose
//
//  Created by wsz on 16/9/22.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MultiChooseCollectionViewCellDelagte <NSObject>

@required
- (BOOL)selectedIsFull;

- (void)cellChangedSelected:(BOOL)isSelected withImage:(UIImage *)image;

@end

@interface MultiChooseCollectionViewCell : UICollectionViewCell


@property(nonatomic, weak)id<MultiChooseCollectionViewCellDelagte> delegate;
@property(nonatomic, strong)UIImage *image;
@property(nonatomic, assign)BOOL cellSelected;


@end
