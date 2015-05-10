//
//  FTPShowFilesViewController.m
//  FTPKit
//
//  Created by 陶正凯 on 15/5/10.
//  Copyright (c) 2015年 陶正凯. All rights reserved.
//

#import "FTPShowFilesViewController.h"

@interface FTPShowFilesViewController()
@property (strong, nonatomic) IBOutlet UILabel *outputString;
@property (strong, nonatomic) NSString *textString;
@end

@implementation FTPShowFilesViewController
@synthesize textString;
- (void) viewDidLoad {
    [super viewDidLoad];
    [self.outputString setText:self.textString];
}

- (void) initWithString : (NSString *)testString {
    self.textString = testString;
}

@end
