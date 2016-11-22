//
//  ViewController.m
//  ASPLoginDemo
//
//  Created by Robert Ryan on 11/22/16.
//  Copyright © 2016 Robert Ryan. All rights reserved.
//

#import "ViewController.h"
#import "TFHpple.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#warning Please change these three fields
    NSURL *url = [NSURL URLWithString:@"http://XXX.azurewebsites.net/Login"];
    NSString *userid = @"XXX";
    NSString *password = @"XXX";
    
    [self retrieveLoginFieldsFromURL:url completionHandler:^(NSDictionary *parameters) {
        [self loginWithURL:url user:userid password:password parameters:parameters completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"success");
            } else {
                NSLog(@"failure");
            }
        }];
    }];
}

- (void)retrieveLoginFieldsFromURL:(NSURL *)url completionHandler:(void (^)(NSDictionary *parameters))completionHandler {
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data == nil || error != nil) {
            NSLog(@"%@", error);
            return;
        }
        
        TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
        
        NSArray *hidden = [doc searchWithXPathQuery:@"//input[@type='hidden']"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        for (TFHppleElement *element in hidden) {
            NSString *key = element[@"id"];
            NSString *value = element[@"value"];
            if (key) { parameters[key] = value ?: @""; }
        }
        completionHandler(parameters);
    }];
    [task resume];
}

- (void)loginWithURL:(NSURL *)url user:(NSString *)user password:(NSString *)password parameters:(NSDictionary *)parameters completionHandler:(void (^)(BOOL))completionHandler {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSMutableDictionary *fullParameters = [parameters mutableCopy];
    fullParameters[@"TxtUserName"] = user;
    fullParameters[@"TxtPassword"] = password;
    fullParameters[@"BtnLogin"] = @"Login";
    
    [request setHTTPBody:[self httpBodyForParameters:fullParameters]];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data == nil || error != nil) {
            NSLog(@"%@", error);
            return;
        }
        
        // we can determine success from whether we're still at login page or not; if so, we failed; if not, we succeeded
        
        BOOL success = ![response.URL.path isEqualToString:@"/Login"];
        
        // if failure, let's see what it says
        
        if (!success) {
            NSLog(@"response: %@", response);
            NSLog(@"responseString: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }
        
        // let's call completion handler
        
        completionHandler(success);
    }];
    [task resume];
}

/** Build the body of a `application/x-www-form-urlencoded` request from a dictionary of keys and string values
 
 @param parameters The dictionary of parameters.
 @return The `application/x-www-form-urlencoded` body of the form `key1=value1&key2=value2`
 */
- (NSData *)httpBodyForParameters:(NSDictionary *)parameters {
    NSMutableArray *parameterArray = [NSMutableArray array];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        NSString *param = [NSString stringWithFormat:@"%@=%@", [self percentEscapeString:key], [self percentEscapeString:obj]];
        [parameterArray addObject:param];
    }];
    
    NSString *string = [parameterArray componentsJoinedByString:@"&"];
    
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

/** Percent escapes values to be added to a URL query as specified in RFC 3986.
 
 See http://www.ietf.org/rfc/rfc3986.txt
 
 @param string The string to be escaped.
 @return The escaped string.
 */
- (NSString *)percentEscapeString:(NSString *)string {
    NSCharacterSet *allowed = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~"];
    return [string stringByAddingPercentEncodingWithAllowedCharacters:allowed];
}

@end
