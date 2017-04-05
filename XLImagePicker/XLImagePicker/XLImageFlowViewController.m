//
//  XLImageFlowViewController.m
//  XLImagePicker
//
//  Created by 街路口等你 on 16/6/26.
//  Copyright © 2016年 街路口等你. All rights reserved.
//

#import "XLImageFlowViewController.h"
#import "XLAssetsViewCell.h"
#import "NSURL+XLImagePickerURLEqual.h"

#define kSizeThumbnailCollectionView ([UIScreen mainScreen].bounds.size.width - 10) / 4

static NSUInteger const kXLImageFlowMaxSeletedNumber = 9;

@interface XLImageFlowViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, XLAssetsViewCellDelegate>

@property (nonatomic, strong) NSURL *assetsGroupURL;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@property (nonatomic, strong) UICollectionView *imgFlowCollectionView;

@property (nonatomic, strong) NSMutableArray *assetsArray;
@property (nonatomic, strong) NSMutableArray *selectedAssetsArray;

@property (nonatomic, assign) BOOL isFullImage;

@end




@implementation XLImageFlowViewController

- (instancetype)initWithGroupURL:(NSURL *)assetsGroupURL {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        _assetsArray = [NSMutableArray new];
        _selectedAssetsArray = [NSMutableArray new];
        _assetsGroupURL = assetsGroupURL;
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
        [self setupData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self imageFlowCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%@", self.selectedAssetsArray);
}

#pragma mark - setup data

- (void)setupData {
    [_assetsLibrary groupForURL:self.assetsGroupURL resultBlock:^(ALAssetsGroup *group) {
        self.assetsGroup = group;
        
        if (self.assetsGroup) {
            self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
            [self loadData];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 照片加载

- (void)loadData {
    [self.assetsGroup setAssetsFilter:[ALAssetsFilter allAssets]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                [self.assetsArray insertObject:result atIndex:0];
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.imgFlowCollectionView reloadData];
        });
    });
}

#pragma mark - collectionView 

- (UICollectionView *)imageFlowCollectionView {
    if (nil == _imgFlowCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 2.0;
        layout.minimumInteritemSpacing = 2.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _imgFlowCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
        
        _imgFlowCollectionView.backgroundColor = [UIColor clearColor];
        [_imgFlowCollectionView registerClass:[XLAssetsViewCell class] forCellWithReuseIdentifier:@"XLAssetsViewCell"];
        
        _imgFlowCollectionView.alwaysBounceVertical = YES;
        _imgFlowCollectionView.delegate = self;
        _imgFlowCollectionView.dataSource = self;
        _imgFlowCollectionView.showsHorizontalScrollIndicator = YES;
        [self.view addSubview:_imgFlowCollectionView];
    }
    return _imgFlowCollectionView;
}

#pragma mark - UICollectionView delegate and Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLAssetsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLAssetsViewCell" forIndexPath:indexPath];
    ALAsset *asset = self.assetsArray[indexPath.row];
    cell.delegate = self;
    
    [cell fillWithAsset:asset isSelected:[self assetIsSelected:asset]];
    
    return cell;
}

- (BOOL)assetIsSelected:(ALAsset *)targetAsset {
    for (ALAsset *asset in self.selectedAssetsArray) {
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        NSURL *targetAssetURL = [targetAsset valueForProperty:ALAssetPropertyAssetURL];
        if ([assetURL isEqualToOther:targetAssetURL]) {
            return YES;
        }
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(kSizeThumbnailCollectionView, kSizeThumbnailCollectionView);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2, 2, 2, 2);
}


#pragma mark - XLAssetsViewCellDelegate

- (void)didSelectItemAssetsViewCell:(XLAssetsViewCell *)assetsCell {
    assetsCell.isSelected = [self seletedAssets:assetsCell.asset];
}

- (void)didDeselectItemAssetsViewCell:(XLAssetsViewCell *)assetsCell {
    assetsCell.isSelected = NO;
    [self deseletedAssets:assetsCell.asset];
}

- (BOOL)seletedAssets:(ALAsset *)asset {
    if ([self assetIsSelected:asset]) {
        
        return NO;
    }
    
    if (self.selectedAssetsArray.count >= kXLImageFlowMaxSeletedNumber) {
        
        return NO;
    } else {
        
        [self addAssetsObject:asset];
        return YES;
    }
}

- (void)addAssetsObject:(ALAsset *)asset {
    [self.selectedAssetsArray addObject:asset];
}

- (void)deseletedAssets:(ALAsset *)asset {
    [self removeAssetsObject:asset];
    if (self.selectedAssetsArray.count < 1) {
        
    }
}

- (void)removeAssetsObject:(ALAsset *)asset {
    if ([self assetIsSelected:asset]) {
        [self.selectedAssetsArray removeObject:asset];
    }
}


@end