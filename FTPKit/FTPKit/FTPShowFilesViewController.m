//
//  FTPShowFilesViewController.m
//  FTPKit
//
//  Created by 陶正凯 on 15/5/10.
//  Copyright (c) 2015年 陶正凯. All rights reserved.
//

#import "FTPShowFilesViewController.h"
#import "FTPFilesTableViewCell.h"
#import "FTPManager.h"

@interface FTPShowFilesViewController()
@property (strong, nonatomic) NSString *ip;
@property (strong, nonatomic) NSMutableString *dirString;
@property (strong, nonatomic) NSMutableString *url;
@property (strong, nonatomic) FTPFilesTableViewCell *ftpFilesTableViewCell;
@property (strong, nonatomic) FTPServerModel *model;
@property (strong, nonatomic) FTPManager *man;
@property (strong, nonatomic) FMServer * server;
@property (strong, nonatomic) NSArray *filesList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

static NSString *ftpFilesTableViewCellIdentifier = @"ftpFilesTableViewCellIdentifier";
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
    }
}
-(void)backToLastDirectory{
    // 根目录, 不做任何处理
    if ([self.dirString isEqualToString:@"/"]) return;
    // 否则, 进入相应的目录
    NSInteger length = [self.dirString length];
    NSRange range = [self.dirString rangeOfString:@"/" options:NSBackwardsSearch range:NSMakeRange(0, length - 1)];
    [self.dirString deleteCharactersInRange:NSMakeRange(range.location ? range.location:1, length - (range.location ? range.location:1))];
    self.title = [self.dirString copy];
    // 更新url
    self.url = [NSMutableString stringWithString:self.ip];
    [self.url appendString:[self.dirString copy]];
    self.server.destination = self.url;
    self.filesList = [self.man contentsOfServer:self.server];
    [self reloadTableView];
}
-(void)reloadTableView{
    [self.tableView reloadData];
}
- (void) viewDidLoad {
    [super viewDidLoad];
    // 创建自定义返回按钮
    UIBarButtonItem *myBackButtonItem = [[UIBarButtonItem alloc] init];
    myBackButtonItem.title = @"返回上级目录";
    myBackButtonItem.target = self;
    myBackButtonItem.action = @selector(backToLastDirectory);
    self.navigationItem.leftBarButtonItem = myBackButtonItem;

    // 加载自定义cell
    [self.tableView registerClass:[FTPFilesTableViewCell class] forCellReuseIdentifier:ftpFilesTableViewCellIdentifier];
    // 拉取服务器上的文件目录
    self.filesList = [self.man contentsOfServer:self.server];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.filesList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.ftpFilesTableViewCell = [tableView dequeueReusableCellWithIdentifier:ftpFilesTableViewCellIdentifier];
    if (!self.ftpFilesTableViewCell) {
        self.ftpFilesTableViewCell = [[FTPFilesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ftpFilesTableViewCellIdentifier];
    }
    NSDictionary *fileItemDict = [self.filesList objectAtIndex:indexPath.row];
    self.ftpFilesTableViewCell.fileNameValue = fileItemDict[@"kCFFTPResourceName"];
    self.ftpFilesTableViewCell.fileSizeValue = [NSString stringWithFormat:@"%@", fileItemDict[@"kCFFTPResourceSize"]];
    self.ftpFilesTableViewCell.fileCreateTimeValue = [NSString stringWithFormat:@"%@", fileItemDict[@"kCFFTPResourceModDate"]];

    return self.ftpFilesTableViewCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s", "click!!!");
}

@end
