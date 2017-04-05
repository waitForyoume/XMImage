//
//  XLAssetsViewCell.h
//  XLImagePicker
//
//  Created by 街路口等你 on 16/6/26.
//  Copyright © 2016年 街路口等你. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAsset.h>

@class XLAssetsViewCell;

@protocol XLAssetsViewCellDelegate <NSObject>

@optional

- (void)didSelectItemAssetsViewCell:(XLAssetsViewCell *)assetsCell;
- (void)didDeselectItemAssetsViewCell:(XLAssetsViewCell *)assetsCell;

@end

@interface XLAssetsViewCell : UICollectionViewCell

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, weak) id<XLAssetsViewCellDelegate> delegate;

- (void)fillWithAsset:(ALAsset *)asset isSelected:(BOOL)seleted;

@end
