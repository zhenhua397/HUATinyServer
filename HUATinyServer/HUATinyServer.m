//
//  HUATinyServer.m
//  HUATinyServer
//
//  Created by hua on 2017/12/26.
//  Copyright © 2017年 hua. All rights reserved.
//

#import "HUATinyServer.h"
#import <objc/runtime.h>
#import "GCDWebServer.h"
#import "GCDWebServerURLEncodedFormRequest.h"
#import "GCDWebServerDataResponse.h"

@implementation HUATinyServer

+ (void)startWithDirectory:(NSString *)dir
{
    self.webServer = [[GCDWebServer alloc] init];
    
    __block NSString *requestURL = nil;
    __block NSString *requestFilePath = nil;
    [self.webServer addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
        
        NSString *url = request.URL.absoluteString;
        NSString *fileName = [url lastPathComponent];
        requestFilePath = [dir stringByAppendingPathComponent:fileName];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:requestFilePath]) {
            return [GCDWebServerDataResponse responseWithHTML:@"<html><body><h1>404 Not Found</h1></body></html>"];
        }
        
        requestURL = url;
        NSString *oldValue = [NSString stringWithContentsOfFile:requestFilePath encoding:NSUTF8StringEncoding error:nil];
        NSString *html = [self createHTML:oldValue];
        return [GCDWebServerDataResponse responseWithHTML:html];
    }];
    
    [self.webServer addDefaultHandlerForMethod:@"POST"
                                  requestClass:[GCDWebServerURLEncodedFormRequest class]
                                  processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                                      
                                      NSString* value = [[(GCDWebServerURLEncodedFormRequest*)request arguments] objectForKey:@"value"];
                                      value = [value stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                                      value = [value stringByReplacingOccurrencesOfString:@" {" withString:@"{"];
                                      NSString *path = requestFilePath;
                                      NSString *oldValue = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                                      if (![self isJson:value equalTo:oldValue]) {
                                          [value writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
                                      }
                                      
                                      NSString *html = [self createHTML:value];
                                      return [GCDWebServerDataResponse responseWithHTML:html];
                                  }];
    
    [self.webServer start];
}

+ (BOOL)isJson:(NSString *)json1 equalTo:(NSString *)json2
{
    // 表单做了修改，需要去除特殊符号判断
    json1 = [json1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    json1 = [json1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    json2 = [json2 stringByReplacingOccurrencesOfString:@" " withString:@""];
    json2 = [json2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return [json1 isEqualToString:json2];
}

+ (NSString *)createHTML:(NSString *)value
{
    NSString* html = [NSString stringWithFormat:@" \
                      <html><body> \
                      <form name=\"input\" action=\"/\" method=\"post\" enctype=\"application/x-www-form-urlencoded\"> \
                      <textarea style='width:100%%;height:70%%;font-size:17px;font-family:宋体' type=\"text\" name=\"value\"> %@ </textarea> \
                      <input style='width:200px;height:100px;font-size:17px;font-family:宋体;background-color:#fff' type=\"submit\" value=\"提交看看\"> \
                      </form> \
                      </body></html> \
                      ", value];
    return html;
}

+ (void)setWebServer:(GCDWebServer *)server
{
    objc_setAssociatedObject(self, "HUAWebServer", server, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (GCDWebServer *)webServer
{
    return objc_getAssociatedObject(self, "HUAWebServer");
}

@end
