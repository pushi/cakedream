//
//  DataStructure.h
//  cakedream
//
//  Created by cui yansong on 14-5-13.
//  Copyright (c) 2014年 pushi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface ResultData : NSObject
@property (strong, atomic) NSDictionary* content; //查询结果
@property int dataType;  //content数据格式
@property int statusCode;  //返回信息的状态码
@property (strong,atomic)NSArray* params;   //服务器拿到的查询参数

- (id)initWithUrlData:(NSData *)data;
-(NSArray*)contentAsArray;
-(NSString*)contentAsString;
@end
/**************json解析方法****************/
@interface JsonRT : NSObject

+(id)diction2Bean:(NSDictionary*)dic bean:(id)abean;

@end
/**************以下为各种数据结构******************/
