//
//  FTPConfigTableViewCell.m
//  FTPKit
//
//  Created by 陶正凯 on 15/5/10.
//  Copyright (c) 2015年 陶正凯. All rights reserved.
//

#import "FTPConfigTableViewCell.h"

@implementation FTPConfigTableViewCell
{
    UILabel *_labelText;
    UITextField *_fieldText;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect labelRect = CGRectMake(0, 5, 200, 15);
        _labelText = [[UILabel alloc] initWithFrame:labelRect];
        [self.contentView addSubview:_labelText];
        
        CGRect fieldRect = CGRectMake(0, 28, 200, 15);
        _fieldText = [[UITextField alloc] initWithFrame:fieldRect];
        [self.contentView addSubview:_fieldText];
    }
    
    return self;
}

- (void) setLabelValue:(NSString *)text {
    if (![text isEqualToString:_labelValue]) {
        _labelValue = [text copy];
        _labelText.text = _labelValue;
    }
}

- (void) setTextValue:(NSString *)text {
    if (![text isEqualToString:_textValue]) {
        _textValue = [text copy];
        _fieldText.text = _textValue;
    }
}

@end
