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

- (NSString *) getValue:(NSString *)key {
    if ([key isEqualToString:@"Display Name"]) {
        return self.serverName;
    }
    else if ([key isEqualToString:@"IP Address"]) {
        return self.serverAddress;
    }
    else if ([key isEqualToString:@"UserName"]) {
        return self.loginUsername;
    }
    else if ([key isEqualToString:@"Password"]) {
        return self.loginPasswd;
    }
    return nil;
}

- (NSMutableArray *) wrapData {
    NSMutableArray *array = nil;
    NSMutableDictionary *dict = nil;
    NSArray *dataTemplate = @[@[@"Display Name", @"IP Address"], @[@"UserName", @"Password"]];
    NSArray *keyTemplate = @[@"name", @"value"];
    NSMutableArray *dataResult = [[NSMutableArray alloc] initWithCapacity:2];
    for (int i=0; i<2; i++) {
        array = [[NSMutableArray alloc] initWithCapacity:2];
        for (int j=0; j<2; j++) {
            dict = [[NSMutableDictionary alloc] initWithCapacity:2];
            [dict setObject:dataTemplate[i][j] forKey:keyTemplate[0]];
            [dict setObject:[self getValue:dataTemplate[i][j]] forKey:keyTemplate[1]];
            [array addObject:dict];
        }
        [dataResult addObject:array];
    }
    
    return dataResult;
}
@end