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
@property (strong, nonatomic) NSString *tmpDirectory;
@end

static NSString *ftpFilesTableViewCellIdentifier = @"ftpFilesTableViewCellIdentifier";
static NSString *slashString = @"/";
@implementation FTPShowFilesViewController
@synthesize man=_man;
@synthesize server=_server;
@synthesize tmpDirectory=_tmpDirectory;

- (FTPManager *)man {
    if (!_man) _man = [[FTPManager alloc] init];
    return _man;
}

- (FMServer *)server {
    if (!_server) _server = [FMServer serverWithDestination:self.model.serverAddress username:self.model.loginUsername password:self.model.loginPasswd];
    return _server;
}
- (NSString *)tmpDirectory {
    if (!_tmpDirectory) _tmpDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return _tmpDirectory;
}
-(void)initTitleWith:(NSString *)dirString ServerDataWith:(FTPServerModel *)model{
    self.model = model;
    // 获取ftp服务器的IP地址
    NSRange range = [self.model.serverAddress rangeOfString:slashString];
    if (range.location != NSNotFound) {
        self.ip = [self.model.serverAddress substringToIndex:range.location];
        self.dirString = [NSMutableString stringWithString:[self.model.serverAddress substringFromIndex:range.location]];
    }
    else {
        self.ip =self.model.serverAddress;
        self.dirString = [NSMutableString stringWithString:slashString];
    }
    self.title = [self.dirString copy];
    self.url = [NSMutableString stringWithString:self.ip];
    [self.url appendString:self.dirString];
}
-(void)backToLastDirectory{
    // 根目录, 不做任何处理
    if ([self.dirString isEqualToString:slashString]) return;
    // 否则, 进入相应的目录
    NSInteger length = [self.dirString length];
    NSRange range = [self.dirString rangeOfString:slashString options:NSBackwardsSearch range:NSMakeRange(0, length - 1)];
    [self.dirString deleteCharactersInRange:NSMakeRange(range.location ? range.location:1, length - (range.location ? range.location:1))];
    self.title = [self.dirString copy];
    // 更新url
    self.url = [NSMutableString stringWithString:self.ip];
    [self.url appendString:[self.dirString copy]];
    self.server.destination = [self.url copy];
    self.filesList = [self.man contentsOfServer:self.server];
    [self reloadTableView];
}
-(void)enterDirectory: (NSString *)dirName{
    if (![self.dirString isEqualToString:slashString]) {
        [self.dirString appendString:slashString];
        [self.url appendString:slashString];
    }
    
    [self.dirString appendString:dirName];
    self.title = [self.dirString copy];
    
    [self.url appendString:dirName];
    self.server.destination = [self.url copy];
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
    
    // 拉取服务器上的文件目录
    self.filesList = [self.man contentsOfServer:self.server];

    // 加载自定义cell
    [self.tableView registerClass:[FTPFilesTableViewCell class] forCellReuseIdentifier:ftpFilesTableViewCellIdentifier];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.                                  
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.filesList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     模板数据:
     2015-06-28 21:47:28.474 FTPKit[6847:3569114] {
        kCFFTPResourceGroup = 1000;
        kCFFTPResourceLink = "";
        kCFFTPResourceModDate = "2015-06-27 16:51:00 +0000";
        kCFFTPResourceMode = 436;
        kCFFTPResourceName = "tao.plist";
        kCFFTPResourceOwner = 1000;
        kCFFTPResourceSize = 22;
        kCFFTPResourceType = 8;
     }
     */
    
    self.ftpFilesTableViewCell = [tableView dequeueReusableCellWithIdentifier:ftpFilesTableViewCellIdentifier];
    if (!self.ftpFilesTableViewCell) {
        self.ftpFilesTableViewCell = [[FTPFilesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ftpFilesTableViewCellIdentifier];
    }
    NSDictionary *fileItemDict = [self.filesList objectAtIndex:indexPath.row];
    self.ftpFilesTableViewCell.fileNameValue = fileItemDict[@"kCFFTPResourceName"];
    self.ftpFilesTableViewCell.fileSizeValue = [NSString stringWithFormat:@"%@", fileItemDict[@"kCFFTPResourceSize"]];
    self.ftpFilesTableViewCell.fileCreateTimeValue = [NSString stringWithFormat:@"%@", fileItemDict[@"kCFFTPResourceModDate"]];
    self.ftpFilesTableViewCell.fileTypeValue = [NSString stringWithFormat:@"%@", fileItemDict[@"kCFFTPResourceType"]];

    return self.ftpFilesTableViewCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *itemDict = [self.filesList objectAtIndex:indexPath.row];
    // 区分文件和目录
    NSNumber *n = [itemDict objectForKey:(id)kCFFTPResourceType];
    const int fileType = n.intValue;
    // 如果是单个文件
    if (fileType == 8) {
        /*
         这里采取临时下载, 读取文件内容之后. 删除临时文件
         特殊说明: 若文件大小超过1KB, 直接提示文件过大, 无法预览, 用户可以下载后, 自己处理文件
         */
//        NSLog(@"读取文件内容!!!");
        NSLog(@"%d", [self.man downloadFile:itemDict[@"kCFFTPResourceName"] toDirectory:[NSURL URLWithString:self.tmpDirectory] fromServer:self.server]);
        NSString *file = [self.tmpDirectory stringByAppendingPathComponent:itemDict[@"kCFFTPResourceName"]];
//        NSLog(@"打开文件%@", [file copy]);
        NSLog(@"%@", [NSString stringWithContentsOfFile:[file copy] encoding:NSUTF8StringEncoding error:nil]);
        [[NSFileManager defaultManager] removeItemAtPath:[file copy] error:nil];
        
    }
    // 如果是目录
    else if (fileType == 4) {
        [self enterDirectory:itemDict[@"kCFFTPResourceName"]];
    }
}

@end
