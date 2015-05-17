//
//  FTPServersListViewCell.m
//  FTPKit
//
//  Created by 陶正凯 on 15/5/17.
//  Copyright (c) 2015年 陶正凯. All rights reserved.
//

#import "FTPServersListViewCell.h"

@implementation FTPServersListViewCell {
    UILabel *_label1;
    UILabel *_label2;
    UIImage *_icon1;
    UIImage *_icon2;
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect rect1 = CGRectMake(0, 5, 200, 15);
        _label1 = [[UILabel alloc] initWithFrame:rect1];
        [self.contentView addSubview:_label1];
        CGRect rect2 = CGRectMake(0, 28, 200, 15);
        _label2 = [[UILabel alloc] initWithFrame:rect2];
        [self.contentView addSubview:_label2];
    }
    
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    CGRect rect3 = CGRectMake(300, 10, 40, 40);
    [self.imageView setFrame:rect3];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void) addTapGuestureRecongnizer:(UITapGestureRecognizer *)tapGuesture {
    [self.imageView addGestureRecognizer:tapGuesture];
    self.imageView.userInteractionEnabled = YES;
}

- (void) setLabelValue1:(NSString *)labelValue1 {
    if (![labelValue1 isEqualToString:_labelValue1]) {
        _labelValue1 = [labelValue1 copy];
        _label1.text = _labelValue1;
    }
}

- (void) setLabelValue2:(NSString *)labelValue2 {
    if (![labelValue2 isEqualToString:_labelValue2]) {
        _labelValue2 = [labelValue2 copy];
        _label2.text = _labelValue2;
    }
}

- (void) setImageName1:(NSString *)imageName1 {
    if (![imageName1 isEqualToString:_imageName1]) {
        _imageName1 = [imageName1 copy];
        _icon1 = [UIImage imageNamed:_imageName1];
        self.imageView.image = _icon1;
    }
}

- (void) setImageName2:(NSString *)imageName2 {
    if (![imageName2 isEqualToString:_imageName2]) {
        _imageName2 = [imageName2 copy];
        _icon2 = [UIImage imageNamed:_imageName2];
        self.imageView.image = _icon2;
    }
}

@end
