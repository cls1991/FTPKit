//
//  FTPShowFilesViewController.m
//  FTPKit
//
//  Created by 陶正凯 on 15/5/10.
//  Copyright (c) 2015年 陶正凯. All rights reserved.
//

#import "FTPShowFilesViewController.h"
#import "FTPManager.h"

@interface FTPShowFilesViewController()
@property (strong, nonatomic) IBOutlet UILabel *outputString;
@property (strong, nonatomic) NSString *textString;
@property (strong, nonatomic) FTPManager *man;
@property (strong, nonatomic) FMServer * server;
@end

@implementation FTPShowFilesViewController
@synthesize textString;
@synthesize man=_man;
@synthesize server=_server;

- (FTPManager *)man {
    if (!_man) _man = [[FTPManager alloc] init];
    return _man;
}

- (FMServer *)server {
    if (!_server) _server = [FMServer serverWithDestination:@"192.168.1.106" username:@"uftp" password:@"asd123"];
    return _server;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    NSURL *baseURL = [NSURL URLWithString:@"file:///Users/"];
    NSURL *url = [NSURL URLWithString:@"taozhengkai/test.txt" relativeToURL:baseURL];
    NSURL *absURL = [url absoluteURL];
    NSLog(@"%@", absURL);
    [self.man downloadFile:@"test.txt" toDirectory:absURL fromServer:self.server];
    
    [self.outputString setText:self.textString];
}

- (void) initWithString : (NSString *)testString {
    self.textString = testString;
}

@end
