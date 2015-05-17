//
//  FTPServersListViewCell.h
//  FTPKit
//
//  Created by 陶正凯 on 15/5/17.
//  Copyright (c) 2015年 陶正凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTPServersListViewCell : UITableViewCell
@property (copy, nonatomic) NSString *labelValue1;
@property (copy, nonatomic) NSString *labelValue2;
@property (copy, nonatomic) NSString *imageName1;
@property (copy, nonatomic) NSString *imageName2;

- (void) addTapGuestureRecongnizer: (UITapGestureRecognizer *)tapGuesture;
- (void) addTag: (NSInteger) tag;
@end
