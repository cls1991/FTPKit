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
    if (!_server) _server = [FMServer serverWithDestination:@"192.168.1.106/data" username:@"uftp" password:@"asd123"];
    return _server;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [dir stringByAppendingPathComponent:@"test.plist"];
    NSLog(@"filePath=%@", filePath);
    
    NSLog(@"创建文件是否成功?%d", [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil]);
    NSLog(@"%d", [self.man uploadFile:[NSURL URLWithString:filePath] toServer:self.server]);
    
    [self.man downloadFile:@"test.plist" toDirectory:[NSURL URLWithString:dir] fromServer:self.server];
    
    NSLog(@"文件是否下载成功?%d", [[NSFileManager defaultManager] fileExistsAtPath:dir]);
    
    // 测试列举目录
    NSLog(@"FTP文件目录为: %@", [self.man contentsOfServer:self.server]);
    
    [self.outputString setText:self.textString];
}

- (void) initWithString : (NSString *)testString {
    self.textString = testString;
}

@end
