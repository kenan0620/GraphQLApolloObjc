//
//  ViewController.m
//  GraphQLApolloObjc
//
//  Created by 柯南 on 2019/9/24.
//  Copyright © 2019 柯南. All rights reserved.
//

#import "ViewController.h"

#import "API.h"
#import "ApolloClient.h"

#import <AFNetworking/AFNetworking.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    printf("viewDidLoad");
    
   
    
    
}
/**
 Apollo 方式请求
 
 */
- (void)requestApolloWithApolloLib{
    NSLog(@"requestApolloWithApolloLib Start");
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://192.168.1.164:8080/graphql"];

     NSString *path = [[NSBundle mainBundle] pathForResource:@"Query" ofType:@"graphql"];
     NSError *error;
     NSString *queryString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
     
    NSMutableDictionary *variables = [NSMutableDictionary dictionary];

    [variables setObject:@"1234" forKey:@"uid"];
    ApolloClient *client = [[ApolloClient alloc] initWithUrl:[NSURL URLWithString:requestUrl]];
    
    StarshipQuery *query = [[StarshipQuery alloc] init];
//    query.queryDocument = queryString;
    query.operationDefinition = queryString;
    query.variables = variables;
    
    [client fetch:query resultHandler:^(GraphQLResult *result, NSError *error) {
        NSLog(@"fetch result %@",result.data);
    }];
    
}

/**
 api方式请求
 
 */
- (void)requestApolloWithRestAPI{
    NSLog(@"requestApolloWithRestAPI Start");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Query" ofType:@"graphql"];
    NSError *error;
    NSString *queryString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    NSLog(@"queryString %@",queryString);
    NSString *requestUrl = [NSString stringWithFormat:@"http://192.168.1.164:8080/graphql"];
   
    NSDictionary *paramDic = @{@"operationName":@"user1getinfo",@"query":queryString,@"variables":@{@"uid": @"123452344"}};
    
    [manager POST:requestUrl parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"data"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.userInfo);
    }];
}

- (IBAction)requestApi:(UIButton *)sender {
    [self requestApolloWithRestAPI];
}

- (IBAction)requestApollo:(UIButton *)sender {
    [self requestApolloWithApolloLib];
}

@end
