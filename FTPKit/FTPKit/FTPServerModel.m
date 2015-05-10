//
//  FTPServerModel.m
//  FTPKit
//
//  Created by 陶正凯 on 15/5/10.
//  Copyright (c) 2015年 陶正凯. All rights reserved.
//


#import "FTPServerModel.h"


@interface FTPServerModel ()

@end

@implementation FTPServerModel

- (void) logObject {
    NSLog(@"ServerName: %@", self.serverName);
    NSLog(@"Server Address: %@", self.serverAddress);
    NSLog(@"Login Username: %@", self.loginUsername);
    NSLog(@"Login Passwd: %@", self.loginPasswd);
}

@end