//
//  NetWorkRequest.m
//  cakedream
//
//  Created by cui yansong on 14-5-13.
//  Copyright (c) 2014年 pushi. All rights reserved.
//

#import "NetWorkRequest.h"
#import "AppDelegate.h"
#import "RSAEncryptAndDecrypt.h"
@implementation NetWorkRequest
+(ResultData*)requestwith:(NSString *)strURL
{
    AppDelegate* delegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString * wholeParameter;
    if ([[strURL substringFromIndex:[strURL length]-1] isEqualToString:@"?"]) {
        wholeParameter = [NSString stringWithFormat:@"%@%@", strURL, delegate.attachString];
    } else {
        wholeParameter = [NSString stringWithFormat:@"%@&%@", strURL, delegate.attachString];
    }
    
    NSString * content;
    NSString * parameter;
    NSString * EncryptParameter;
    if ([strURL rangeOfString:@"?"].length >0) {
        content = [wholeParameter substringToIndex:[wholeParameter rangeOfString:@"?"].location];
        parameter = [wholeParameter substringFromIndex:[wholeParameter rangeOfString:@"?"].location+1];
    }
    
    /*****开始网络请求*****/
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //parameter=@"type=school&oper=fuzzy&schoolName=北京&queryType=0";
    DebugLog(@"OriginParameter=%@",parameter);
    EncryptParameter = [[RSAEncryptAndDecrypt sharedRSAEncryptAndDecrypt] doCipher:parameter context:kCCEncrypt];
    DebugLog(@"EncryptParameter=%@",EncryptParameter);
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@?%@", webAddress,content,EncryptParameter] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //解密 解析
    NSString* encryptJson=[[NSString alloc] initWithData:[self httpRequestWith:url] encoding:NSUTF8StringEncoding];
    //encryptJson=@"KIHkbB+uaNfW3bR3VI7lBb+KXRJS4FDMdkv1vFBq6/zqnwidtl6zLAe0lcHnaK90EVcy1LqaNj+gRWVxKJVwNCwFdRuxHIn9SBhTUe39sl79wyyjSbH1R38816ggpe1GtFFrm8gfMjNAlEi7z6Vrc/Bbp3wkEYURDSYca6M6pLg=";
    NSString* jsonString=[[RSAEncryptAndDecrypt sharedRSAEncryptAndDecrypt] doCipher:encryptJson context:kCCDecrypt];
    DebugLog(@"jsonString=%@",jsonString);
    NSLog(@"jsonString=%@",jsonString);
    ResultData* result=[[ResultData alloc] initWithUrlData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    //不带解密
    //ResultData* result=[[ResultData alloc] initWithUrlData:[self httpRequestWith:url]];
    NSLog(@"aaaaa%@",result);
    return result;
}
+(NSData*)httpRequestWith:(NSURL*)url{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                          timeoutInterval:30];
    //[urlRequest addValue: @"text/html" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    
    
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if(urlData==nil)
    {
        return  nil;
    }
    
    DebugLog(@"服务器返回的未经处理的字符串:%@",[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding]);
    // Construct a String around the Data from the response
    return urlData;
}
+(void)getServerKey{
    RSAEncryptAndDecrypt * rsa = [RSAEncryptAndDecrypt sharedRSAEncryptAndDecrypt];
    [rsa generateKeyPair];
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@DataKey?userPublicKey=%@",webAddress,[rsa getPublicKeyModExp]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    DebugLog(@"ServerKeyURL=%@",url);
    //ResultData* result=[[ResultData alloc] initWithUrlData:[self httpRequestWith:url]];
    
    //    NSString * sSymmetricKey = [result contentAsString];//[[result contentAsString] dataUsingEncoding:NSISOLatin1StringEncoding];
    //    rsa.symmetricKey=[sSymmetricKey dataUsingEncoding:NSISOLatin1StringEncoding];
    
    //DebugLog(@"加密前serverKey=%@",[[NSString alloc] initWithData:rsa.symmetricKey encoding:NSISOLatin1StringEncoding]);
    //[rsa testAsymmetricEncryptionAndDecryption];
    //Byte b[]={-22, 31, 76, 13, 37, 37, 41, -33};
    //DebugLog(@"%@",[[result contentAsString] stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"]);
    rsa.symmetricKey=[rsa decryptWithPrivateKeyByRSA:[[NSString alloc] initWithData:[self httpRequestWith:url] encoding:NSUTF8StringEncoding]];
    //[[rsa decryptWithPrivateKeyByRSA:[[NSString alloc] initWithData:[self httpRequestWith:url] encoding:NSUTF8StringEncoding]] dataUsingEncoding:NSUTF8StringEncoding];
    //rsa.symmetricKey = [NSData dataWithBytes:b length:8];
    DebugLog(@"获取ServerKey=%@",rsa.symmetricKey);
}

@end
