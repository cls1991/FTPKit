//
//  FTPFileChooserViewController.m
//  FTPKit
//
//  Created by 陶正凯 on 15/7/6.
//  Copyright (c) 2015年 陶正凯. All rights reserved.
//

#import "FTPFileChooserViewController.h"
#import "FTPFilesTableViewCell.h"

@interface FTPFileChooserViewController ()
@property (strong, nonatomic) NSMutableString *dirString;
@property (copy, nonatomic)NSArray *fileLists;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (copy, nonatomic)NSString *tmpDirectory;
@end

static NSString *slashString = @"/";
static NSString *cellIdentifier = @"fileChooserTableViewCell";
@implementation FTPFileChooserViewController
@synthesize tmpDirectory = _tmpDirectory;
- (NSString *)tmpDirectory {
    if (!_tmpDirectory) _tmpDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return _tmpDirectory;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.fileLists count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FTPFilesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) cell = [[FTPFilesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    NSDictionary *itemDict = [self.fileLists objectAtIndex:indexPath.row];
    cell.fileNameValue = itemDict[@"NSFileName"];
    cell.fileSizeValue = [NSString stringWithFormat:@"%@", itemDict[@"NSFileSize"]];
    cell.fileCreateTimeValue = [NSString stringWithFormat:@"%@", itemDict[@"NSFileCreationDate"]];
    cell.fileTypeValue = [NSString stringWithFormat:@"%@", itemDict[@"NSFileType"]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *itemDict = [self.fileLists objectAtIndex:indexPath.row];
    // 区分文件和目录
    // 若为文件
    if ([NSFileTypeRegular isEqualToString:itemDict[@"NSFileType"]]) {
        NSMutableString *filePath = [NSMutableString stringWithString:self.tmpDirectory];
        [filePath appendString:self.dirString];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadFile" object:[filePath stringByAppendingPathComponent:itemDict[@"NSFileName"]]];
        [self.navigationController popViewControllerAnimated:true];
    }
    // 处理目录
    else if ([NSFileTypeDirectory isEqualToString:itemDict[@"NSFileType"]]) {
        [self enterDirectory:itemDict[@"NSFileName"]];
    }
}
-(void)reloadTableView{
    [self.tableview reloadData];
}
-(void)backToLastDirectory{
    // 根目录, 不做任何处理
    if ([self.dirString isEqualToString:slashString]) return;
    // 否则, 进入相应的目录
    NSInteger length = [self.dirString length];
    NSRange range = [self.dirString rangeOfString:slashString options:NSBackwardsSearch range:NSMakeRange(0, length - 1)];
    [self.dirString deleteCharactersInRange:NSMakeRange(range.location ? range.location:1, length - (range.location ? range.location:1))];
    self.title = [self.dirString copy];
    // 更新数据
    [self fetchFiles];
    [self reloadTableView];
}
-(void)enterDirectory: (NSString *)dirName{
    if (![self.dirString isEqualToString:slashString]) {
        [self.dirString appendString:slashString];
    }
    
    [self.dirString appendString:dirName];
    self.title = [self.dirString copy];
    
    [self fetchFiles];
    [self reloadTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建自定义返回按钮
    UIBarButtonItem *myBackButtonItem = [[UIBarButtonItem alloc] init];
    myBackButtonItem.title = @"返回上级目录";
    myBackButtonItem.target = self;
    myBackButtonItem.action = @selector(backToLastDirectory);
    self.navigationItem.leftBarButtonItem = myBackButtonItem;
    
    /*
     说明: 以NSDocumentDirectory作为根目录, 方便文件的路径显示
     */
    self.dirString = [NSMutableString stringWithString:slashString];
    self.title = [self.dirString copy];
    [self fetchFiles];
//    NSLog(@"%@", self.fileLists);
    
    // 加载自定义cellcell
    [self.tableview registerClass:[FTPFilesTableViewCell class] forCellReuseIdentifier:cellIdentifier];
}
// 返回目录的文件信息
- (void)fetchFiles {
    /*
     a. 文件
     2015-07-07 22:12:08.477 FTPKit[791:508538] {
     NSFileCreationDate = "2015-06-29 14:00:58 +0000";
     NSFileExtensionHidden = 0;
     NSFileGroupOwnerAccountID = 501;
     NSFileGroupOwnerAccountName = mobile;
     NSFileModificationDate = "2015-06-29 14:00:58 +0000";
     NSFileOwnerAccountID = 501;
     NSFileOwnerAccountName = mobile;
     NSFilePosixPermissions = 420;
     NSFileProtectionKey = NSFileProtectionCompleteUntilFirstUserAuthentication;
     NSFileReferenceCount = 1;
     NSFileSize = 1299;
     NSFileSystemFileNumber = 3287445;
     NSFileSystemNumber = 16777220;
     NSFileType = NSFileTypeRegular;
     }
     b. 目录
     2015-07-07 22:16:50.681 FTPKit[798:509408] {
     NSFileCreationDate = "2015-06-28 11:24:19 +0000";
     NSFileExtensionHidden = 0;
     NSFileGroupOwnerAccountID = 501;
     NSFileGroupOwnerAccountName = mobile;
     NSFileModificationDate = "2015-07-07 14:02:15 +0000";
     NSFileOwnerAccountID = 501;
     NSFileOwnerAccountName = mobile;
     NSFilePosixPermissions = 493;
     NSFileReferenceCount = 2;
     NSFileSize = 170;
     NSFileSystemFileNumber = 3274122;
     NSFileSystemNumber = 16777220;
     NSFileType = NSFileTypeDirectory;
     }
     */
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableString *finalPath = [NSMutableString stringWithString:self.tmpDirectory];
    if (![self.dirString isEqualToString:slashString]) {
        [finalPath appendString:self.dirString];
    }
    // 测试数据, 建立一个目录
    [fileManager createDirectoryAtPath:[self.tmpDirectory stringByAppendingPathComponent:@"TestDiretory"] withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:finalPath error:&error];
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:fileArray.count];
    for (NSString *fileName in fileArray) {
        NSString *file = [finalPath stringByAppendingPathComponent:fileName];
        NSDictionary *fileAttributesDict = [fileManager attributesOfItemAtPath:file error:&error];
        NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithDictionary:fileAttributesDict];
        [tmpDict setValue:fileName forKey:@"NSFileName"];
        [tmp addObject:[tmpDict copy]];
    }
    self.fileLists = [tmp copy];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
