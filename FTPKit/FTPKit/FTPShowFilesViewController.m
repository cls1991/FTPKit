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
@property (strong, nonatomic) NSString *ip;
@property (strong, nonatomic) NSMutableString *dirString;
@property (strong, nonatomic) NSMutableString *url;
@property (strong, nonatomic) FTPServerModel *model;
@property (strong, nonatomic) FTPManager *man;
@property (strong, nonatomic) FMServer * server;
@end

@implementation FTPShowFilesViewController
@synthesize man=_man;
@synthesize server=_server;

- (FTPManager *)man {
    if (!_man) _man = [[FTPManager alloc] init];
    return _man;
}

- (FMServer *)server {
    if (!_server) _server = [FMServer serverWithDestination:self.model.serverAddress username:self.model.loginUsername password:self.model.loginPasswd];
    return _server;
}
-(void)initTitleWith:(NSString *)dirString ServerDataWith:(FTPServerModel *)model{
    self.dirString = [NSMutableString stringWithString:dirString];
    self.model = model;
    // 获取ftp服务器的IP地址
    NSRange range = [self.model.serverAddress rangeOfString:@"/"];
    if (range.location != NSNotFound) {
        self.ip = [self.model.serverAddress substringToIndex:range.location];
        self.dirString = [NSMutableString stringWithString:[self.model.serverAddress substringFromIndex:range.location]];
        self.title = [dirString copy];
        self.url = [NSMutableString stringWithString:self.ip];
        [self.url appendString:dirString];
        NSLog(@"%@", self.url);
    }
}
-(void)backToLastDirectory{
    // 根目录, 不做任何处理
    if ([self.dirString isEqualToString:@"/"]) return;
    // 否则, 进入相应的目录
    NSInteger length = [self.dirString length];
    NSRange range = [self.dirString rangeOfString:@"/" options:NSBackwardsSearch range:NSMakeRange(0, length - 1)];
    [self.dirString deleteCharactersInRange:NSMakeRange(range.location ? range.location:1, length - (range.location ? range.location:1))];
    // 更新url
    self.url = [NSMutableString stringWithString:self.ip];
    [self.url appendString:[self.dirString copy]];
    self.server.destination = self.url;
    NSLog(@"%@", [self.man contentsOfServer:self.server]);
}
- (void) viewDidLoad {
    [super viewDidLoad];
    // 创建自定义返回按钮
    UIBarButtonItem *myBackButtonItem = [[UIBarButtonItem alloc] init];
    myBackButtonItem.title = @"返回上级目录";
    myBackButtonItem.target = self;
    myBackButtonItem.action = @selector(backToLastDirectory);
    self.navigationItem.leftBarButtonItem = myBackButtonItem;
    
    // 测试列举目录
    NSLog(@"FTP文件目录为: %@", [self.man contentsOfServer:self.server]);
}

@end
