//
//  XLViewController.m
//  XLImagePicker
//
//  Created by 街路口等你 on 16/6/26.
//  Copyright © 2016年 街路口等你. All rights reserved.
//

#import "XLViewController.h"
#import "XLImageFlowViewController.h"

@interface XLViewController ()

@property (nonatomic, strong) NSURL *propertyURL;

@end

@implementation XLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    
    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // 类型名字
        NSString *propertyName = [group valueForProperty:ALAssetsGroupPropertyName];
        if ([propertyName isEqualToString:@"Camera Roll"] || [propertyName isEqualToString:@"相机胶卷"]) {
            
            // 类型URL
            NSURL *propertyURL = [group valueForProperty:ALAssetsGroupPropertyURL];
            _propertyURL = propertyURL;
            self.title = [group valueForProperty:ALAssetsGroupPropertyName];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"进入" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 100, self.view.bounds.size.width - 200, 30);
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)buttonAction:(UIButton *)sender {
    XLImageFlowViewController *imgFlowViewController = [[XLImageFlowViewController alloc] initWithGroupURL:_propertyURL];
    [self.navigationController pushViewController:imgFlowViewController animated:YES];
}

@end
