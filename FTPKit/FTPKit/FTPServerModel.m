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

- (BOOL)checkValues {
    if (self.serverName != nil && self.serverAddress != nil && self.loginUsername != nil && self.loginPasswd != nil) return YES;
    return NO;
}

- (void) logObject {
    NSLog(@"ServerName: %@", self.serverName);
    NSLog(@"Server Address: %@", self.serverAddress);
    NSLog(@"Login Username: %@", self.loginUsername);
    NSLog(@"Login Passwd: %@", self.loginPasswd);
}

- (void) setValue:(NSString *)value matchWithKey:(NSString *)key {
    if ([key isEqualToString: @"Display Name"]) {
        self.serverName = value;
    }
    else if ([key isEqualToString: @"IP Address"]) {
        self.serverAddress = value;
    }
    else if ([key isEqualToString: @"UserName"]) {
        self.loginUsername = value;
    }
    else if ([key isEqualToString: @"Password"]) {
        self.loginPasswd = value;
    }
    
}

@end