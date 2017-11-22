//
//  TBSessionVC.m
//  TBNSUrlSession
//
//  Created by hanchuangkeji on 2017/11/21.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "TBSessionVC.h"
#import "TBHTTPSessionManager.h"
#import "AFNetworking.h"

@interface TBSessionVC ()

@property (nonatomic, strong)TBHTTPSessionManager *manager;

@property (nonatomic, strong)AFHTTPSessionManager *afManager;

@end

@implementation TBSessionVC

- (AFHTTPSessionManager *)afManager {
    if (_afManager == nil) {
        _afManager = [AFHTTPSessionManager manager];
    }
    return _afManager;
}

- (TBHTTPSessionManager *)manager {
    if (_manager == nil) {
        _manager = [TBHTTPSessionManager manager];
    }
    return _manager;
}

// GET请求
- (IBAction)get:(id)sender {
    [self.manager GET:@"http://114.215.80.42/SD/seller_list.action" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"=====%@=====", error.localizedDescription);
    }];
}

// POST请求
- (IBAction)post:(id)sender {
    
    [self.manager POST:@"http://114.215.80.42/SD/seller_list.action" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"=====%@=====", error.localizedDescription);
    }];
    
}

// 上传
- (IBAction)upload:(id)sender {
    [self.manager POST:@"http://114.215.80.42/SD/seller_list.action" parameters:nil constructingBodyWithBlock:^(id  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

// 下载
- (IBAction)download:(id)sender {
    
    
    NSURLRequest *requeset = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://114.215.80.42/SD/image.zip"]];
    
    [self.manager downloadTaskWithRequest:requeset progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@", downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL URLWithString:@"111"];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
    }];
}

// 断点下载
- (IBAction)download2:(id)sender {
    
    NSURLRequest *requeset = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://114.215.80.42/SD/image.zip"]];
    
    [self.manager downloadTaskWithRequest:requeset progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@", downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL URLWithString:@"111"];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest *requeset = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://114.215.80.42/SD/image.zip"]];
    
    [self.manager downloadTaskWithRequest:requeset progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@", downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL URLWithString:@"111"];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
    }];
    
    NSLog(@"%@", self);
    __weak typeof (self) weakSelf = self;
    
    NSLog(@"%@", weakSelf);
    
//    [self.afManager downloadTaskWithResumeData:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//
//
//    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//        return nil;
//
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//
//    }];
    
    
//    NSDictionary *dic = @{@"userName" : @"tangbin", @"password" : @"12465789"};
//
//    [self.manager POST:@"http://114.215.80.42/SD/seller_list.action" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"%@", downloadProgress);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"=====%@=====", error.localizedDescription);
//    }];
//
//    [self.self.afManager POST:@"" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
//
//    [self.self.afManager POST:@"" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
    
//    self.afManager downloadtask
    
//    [self.afManager downloadTaskWithRequest:[NSMutableURLRequest requestWithURL:@""] progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//        return nil;
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//
//    }];
    
//    [self.manager GET:@"http://114.215.80.42/SD/seller_list.action" parameters:@{@"userName" : @"tangbin", @"password" : @"12465789"} progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"%@", downloadProgress);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"=====%@=====", error.localizedDescription);
//    }];
    
//    [self.afManager POST:@"" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
    
//    [self.manager GET:@"http://114.215.80.42/SD/seller_list.action" parameters:@{@"userName" : @"tangbin", @"password" : @"12465789"} progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"%@", downloadProgress);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         NSLog(@"=====%@=====", error.localizedDescription);
//    }];
//
//    [self.afManager POST:@"" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
    
    
//    [self.manager GET:@"" parameters:nil progress:^(NSProgress * _Nonnull) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull, id _Nullable) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable, NSError * _Nonnull) {
//
//    }];
    
    
//    [self.afManager GET:@"" parameters:@"" progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
    
    
}



@end
