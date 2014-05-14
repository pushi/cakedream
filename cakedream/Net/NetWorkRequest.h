//
//  NetWorkRequest.h
//  cakedream
//
//  Created by cui yansong on 14-5-13.
//  Copyright (c) 2014年 pushi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStructure.h"
static const NSString * webAddress = @"http://localhost:8080/"; //本机测试


//用户输入参数中的可能有的特殊字符
static NSString * invalidChar = @"~`!@#$%^*()&=?+-[]{}:;|\"\'\\,./<>～！@＃¥％⋯⋯—＊（）——＋－＝；：‘“，。／《》？［］｛｝【】「」€£¥• ";
//网络传输中的特殊字符
static NSString * invalidCharWithoutWebChar = @" ~`!@#$^*()+-[]{}:;|\"\'\\,/<>～！@＃¥⋯⋯";

static const NSString * devType = @"1";//后台需要的设备类型
static const NSString * AppID = @"00000000";//应用在苹果AppStore的ID 行讯通

//自定义的异常类
@interface kybException:NSException
@property int exceptionType;
@property (strong,atomic) NSString* remark;
@end

//后台通信
@interface NetWorkRequest : NSObject<NSURLConnectionDataDelegate>
+(ResultData*)requestwith:(NSString*)strURL;
+(void)getServerKey;

@end
