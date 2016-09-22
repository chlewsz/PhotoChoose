//
//  PhotoBrowserCollectionViewCell.h
//  PhotoChoose
//
//  Created by wsz on 16/9/22.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoBrowserCollectionViewCellDelegate <NSObject>

- (void)singleTapClick;

@end

@interface PhotoBrowserCollectionViewCell : UICollectionViewCell

@property(nonatomic, weak)id<PhotoBrowserCollectionViewCellDelegate> delegate;

@property(nonatomic, strong)UIImage *image;

- (CGFloat)getCurrentScale;
- (void)resetUI;

@end
