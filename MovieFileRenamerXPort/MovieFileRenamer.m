//
//  MovieFileRenamer.m
//  MovieFileRenamerXPort
//
//  Created by Office on 13-9-29.
//  Copyright (c) 2013年 EzComponent. All rights reserved.
//

#import "MovieFileRenamer.h"

@implementation MovieFileRenamer

@synthesize processPath;

-(NSDictionary*) searchMovieInTmdb:(NSString *)searchKey
{
    NSDictionary* jsonObj;
    
    NSString* host=@"http://api.themoviedb.org/3/search/movie?";
    NSString* query=[self urlEncodeUsingEncoding:[NSString stringWithFormat:@"api_key=2d47f493560c897a2b6471bc6dc66bf7&language=zh&query=%@", searchKey]];
    NSString* urlStr=[host stringByAppendingString:query];
    NSLog(@"urlStr is %@",urlStr);
    
    NSURL* url=[NSURL URLWithString:urlStr];
    NSMutableURLRequest* request=[NSMutableURLRequest new];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSError* error = [[NSError alloc] init];
    NSHTTPURLResponse* responseCode = nil;
    
    NSData* respData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %li,error %@", url, (long)[responseCode statusCode],error);
        return nil;
    }
    
    NSError *jsonParsingError = nil;
    jsonObj=[NSJSONSerialization JSONObjectWithData:respData options:0 error:&jsonParsingError];
    
    if (jsonParsingError) {
        NSLog(@"Json parse error:%@",jsonParsingError);
        return nil;
    }
    
    
    return jsonObj;
}

-(NSString *)urlEncodeUsingEncoding:(NSString*)str {
    return [str stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}

-(NSArray *)getFiles{
    NSFileManager* fm=[NSFileManager defaultManager];
    BOOL isDir;
    if ([fm fileExistsAtPath:self.processPath isDirectory:&isDir]) {
        if (isDir) {
            NSArray* paths=[fm contentsOfDirectoryAtPath:self.processPath error:nil];
            NSMutableArray* absolutePaths=[NSMutableArray new];
            for(NSString* path in paths){
                [absolutePaths addObject:[self.processPath stringByAppendingPathComponent:path ]];
            }
            return absolutePaths;
        } else {
            return [NSArray arrayWithObject:self.processPath];
        }
    }else{
        @throw [NSException exceptionWithName:@"FILE_NOT_EXISTS" reason:@"File is not exits" userInfo:nil];
    }
}

@end
