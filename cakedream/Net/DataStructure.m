//
//  DataStructure.m
//  cakedream
//
//  Created by cui yansong on 14-5-13.
//  Copyright (c) 2014年 pushi. All rights reserved.
//

#import "DataStructure.h"

@implementation ResultData
@synthesize content;
@synthesize dataType;
@synthesize statusCode;
@synthesize params;

/**
 urlData直接解析
 */
- (id)initWithUrlData:(NSData *)data{
    self = [super init];
    if (self) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if(dic==nil)
        {
            statusCode = -9999;
            return nil;
        }
        else
        {
            content=[dic objectForKey:@"content"];
            params=(NSArray*)[dic objectForKey:@"params"];
            statusCode=[(NSNumber*)[dic objectForKey:@"statusCode"] intValue];
            dataType=[(NSNumber*)[dic objectForKey:@"dataType"] intValue];
        }
    }
    return self;
}

/**
 把content当做一个数组返回
 */
-(NSArray*)contentAsArray
{
    return (NSArray*)content;
}

/**
 把content当做一个字符串返回
 */
-(NSString*)contentAsString
{
    if(content==nil)
    {
        return nil;
    }
    return (NSString*)content;
}

@end

/************json解析*************/
@implementation JsonRT

//把json树解析成实体bean
+(id)diction2Bean:(NSDictionary*)dic bean:(id)abean
{
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([abean class], &outCount);  //属性个数
    for(int i=0;i<outCount;i++)
    {
        objc_property_t property=properties[i];
        
        NSString *key=[NSString stringWithCString:property_getName(property) encoding:NSASCIIStringEncoding];
        
        id value=[dic objectForKey:key];
        if(value==nil)
        {
            //cannot found properties
            continue;
        }
        if([value isKindOfClass:[NSNull class]])
        {
            //null Object found for properties
            continue;
            
        }
        
        
        //根据不同的类型，生成对应的类
        NSString *types=[NSString stringWithCString:property_getAttributes(property)
                                           encoding:NSASCIIStringEncoding];
        NSString *clazz=nil;
        NSString *method=[NSString stringWithFormat:@"set%@%@:",
                          [[key substringToIndex:1] uppercaseString],
                          [key substringFromIndex:1]];
        if([types characterAtIndex:1]=='@')
        {
            clazz=[[types componentsSeparatedByString:@"\"" ]objectAtIndex:1];
        }
        if(clazz==nil)
        {
            [abean performSelector:NSSelectorFromString(method) withObject:value];
        }
        else if([clazz compare:@"NSString"options: NSCaseInsensitiveSearch]==NSOrderedSame)
        {
            [abean performSelector:NSSelectorFromString(method) withObject:value];
        }
        else if([clazz compare:@"NSNumber"options: NSCaseInsensitiveSearch]==NSOrderedSame)
        {
            [abean performSelector:NSSelectorFromString(method) withObject:value];
        }
        else if([clazz compare:@"NSArray"options: NSCaseInsensitiveSearch]==NSOrderedSame)
        {
            [abean performSelector:NSSelectorFromString(method) withObject:value];
        }
        // add by bhs 04.21
        else if ([clazz compare:@"NSMutableArray"options:NSCaseInsensitiveSearch]==NSOrderedSame)
        {
            [abean performSelector:NSSelectorFromString(method) withObject:value];
        }
        else
        {
            //set child prop  递归
            id sub=[[NSClassFromString(clazz) alloc] init];
            
            [JsonRT diction2Bean:value bean:sub];
            
            [abean performSelector:NSSelectorFromString(method) withObject:sub];
            
        }
        
        
    }
    return abean;
}

@end
/************以下为各种数据结构*************/











