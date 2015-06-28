//
//  FTPFilesTableViewCell.h
//  FTPKit
//
//  Created by 陶正凯 on 15/6/28.
//  Copyright (c) 2015年 陶正凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTPFilesTableViewCell : UITableViewCell
@property (copy, nonatomic) NSString *fileNameValue;
@property (copy, nonatomic) NSString *fileSizeValue;
@property (copy, nonatomic) NSString *fileCreateTimeValue;
@property (copy, nonatomic) NSString *fileTypeValue;
@end
