//
//  LXPhotoBrowser.h
//  XLImagePicker
//
//  Created by 街路口等你 on 16/6/26.
//  Copyright © 2016年 街路口等你. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class XLImageFlowViewController;
@class XLPhotoBrowser;

@protocol XLPhotoBrowserDelegate <NSObject>

@required

- (void)sendImagesFromPhotobrowser:(XLPhotoBrowser *)photoBrowse currentAsset:(ALAsset *)asset;

- (NSUInteger)seletedPhotosNumberInPhotoBrowser:(XLPhotoBrowser *)photoBrowser;

- (BOOL)photoBrowser:(XLPhotoBrowser *)photoBrowser currentPhotoAssetIsSeleted:(ALAsset *)asset;

- (BOOL)photoBrowser:(XLPhotoBrowser *)photoBrowser seletedAsset:(ALAsset *)asset;

- (void)photoBrowser:(XLPhotoBrowser *)photoBrowser deseletedAsset:(ALAsset *)asset;

- (void)photoBrowser:(XLPhotoBrowser *)photoBrowser seleteFullImage:(BOOL)fullImage;

@end


@interface XLPhotoBrowser : UIViewController

@property (nonatomic, weak) id<XLPhotoBrowserDelegate> delegate;

- (instancetype)initWithPhotos:(NSArray *)photosArray
                  currentIndex:(NSInteger)index
                     fullImage:(BOOL)isFullImage;

- (void)hideControls;
- (void)toggleControls;


@end
