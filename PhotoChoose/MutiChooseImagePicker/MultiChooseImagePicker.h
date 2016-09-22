//
//  MultiChooseImagePicker.h
//  PhotoChoose
//
//  Created by wsz on 16/9/22.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MultiChooseImagePickerDelegate <NSObject>

- (void)selectedFinish:(NSArray *)selectedArray;

@end

@interface MultiChooseImagePicker : UIViewController

@property(nonatomic, weak)id<MultiChooseImagePickerDelegate> delegate;

@end
