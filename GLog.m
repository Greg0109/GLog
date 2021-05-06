#import "GLog.h"

@implementation GLog

-(id)initWithIP:(NSString *)pcip {
    _ip = pcip;
    return self;
}

-(void)sendLog:(NSString *)log {
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:5000/", _ip]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    // Create a simple dictionary with numbers.
    NSDictionary *mapData;
    NSData *base64data = [log dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64string = [base64data base64EncodedStringWithOptions:0];
    mapData = @{ @"GLog" : base64string };
    // Convert the dictionary into JSON data.
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {}];
    [postDataTask resume];
}

@end
