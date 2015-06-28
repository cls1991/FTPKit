//
//  FTPFilesTableViewCell.m
//  FTPKit
//
//  Created by 陶正凯 on 15/6/28.
//  Copyright (c) 2015年 陶正凯. All rights reserved.
//

#import "FTPFilesTableViewCell.h"

@implementation FTPFilesTableViewCell{
    UILabel *_fileNameLabel;
    UILabel *_fileSizeLabel;
    UILabel *_fileCreateTimeLabel;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        CGRect _fileNameRect = CGRectMake(0, 0, 80, 150);
        _fileNameLabel = [[UILabel alloc] initWithFrame:_fileNameRect];
        [self.contentView addSubview:_fileNameLabel];
        CGRect _fileSizeRect = CGRectMake(90, 0, 40, 150);
        _fileSizeLabel = [[UILabel alloc] initWithFrame:_fileSizeRect];
        [self.contentView addSubview:_fileSizeLabel];
        CGRect _fileCreateTimeRect = CGRectMake(140, 0, 250, 150);
        _fileCreateTimeLabel = [[UILabel alloc] initWithFrame:_fileCreateTimeRect];
        [self.contentView addSubview:_fileCreateTimeLabel];
    }
    
    return self;
}

-(void)setFileNameValue:(NSString *)fileNameValue{
    if (![fileNameValue isEqualToString:_fileNameValue]) {
        _fileNameValue = [fileNameValue copy];
        _fileNameLabel.text = _fileNameValue;
    }
}

-(void)setFileSizeValue:(NSString *)fileSizeValue{
    if (![fileSizeValue isEqualToString:_fileSizeValue]) {
        _fileSizeValue = [fileSizeValue copy];
        _fileSizeLabel.text = _fileSizeValue;
    }
}

-(void)setFileCreateTimeValue:(NSString *)fileCreateTimeValue{
    if (![fileCreateTimeValue isEqualToString:_fileCreateTimeValue]) {
        _fileCreateTimeValue = [fileCreateTimeValue copy];
        _fileCreateTimeLabel.text = _fileCreateTimeValue;
    }
}

@end
