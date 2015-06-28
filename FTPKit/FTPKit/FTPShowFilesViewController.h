//
//  FTPShowFilesViewController.h
//  FTPKit
//
//  Created by 陶正凯 on 15/5/10.
//  Copyright (c) 2015年 陶正凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTPServerModel.h"

@interface FTPShowFilesViewController : UIViewController
- (void) initTitleWith : (NSString *)dirString ServerDataWith : (FTPServerModel *)model;
@end
