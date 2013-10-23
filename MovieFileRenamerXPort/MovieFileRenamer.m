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
                if (![path hasPrefix:@"."]) {
                    [absolutePaths addObject:[self.processPath stringByAppendingPathComponent:path ]];
                }
                
            }
            return absolutePaths;
        } else {
            return [NSArray arrayWithObject:self.processPath];
        }
    }else{
        @throw [NSException exceptionWithName:@"FILE_NOT_EXISTS" reason:@"File is not exits" userInfo:nil];
    }
}

-(void) handleInConsole{
    NSString* pathString=[MovieFileRenamer readFromConsoleInput:1024 withPrompt:@"Please input the dir or file path:"];
    self.processPath=pathString;
    NSArray* files=[self getFiles];
    
    for (NSString* filePath in files) {
        NSString* whetherProcess=[MovieFileRenamer readFromConsoleInput:1 withPrompt:[NSString stringWithFormat:@"R U sure to process this file:%@ (y/n)",filePath]];
        if ([whetherProcess isEqualToString:@"y"]) {
            [self selectMovieInConsole];
        }
        
        
    }
}

+(NSString*) readFromConsoleInput:(int) inputLength withPrompt:(NSString*) prompt{

    printf("%s",[prompt cStringUsingEncoding:NSUTF8StringEncoding]);
    
    NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];
    NSData *inputData = [NSData dataWithData:[input availableData]];
    NSString *inputString = [[NSString alloc] initWithData:inputData
                                                  encoding:NSUTF8StringEncoding];
    inputString = [inputString stringByTrimmingCharactersInSet:
                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    return inputString;
}

-(NSDictionary *) selectMovieInConsole{
    NSString* selectedIndex=@"0";
    while ([selectedIndex isEqualToString:@"0"]) {
        NSString* searchKey=[MovieFileRenamer readFromConsoleInput:1024 withPrompt:@"Please input the search key:"];
        NSArray* results=[[self searchMovieInTmdb:searchKey] valueForKey:@"results"];
        while ([results count]==0) {
            searchKey=[MovieFileRenamer readFromConsoleInput:1024 withPrompt:@"Please input the search key:"];
            results=[[self searchMovieInTmdb:searchKey] valueForKey:@"results"];
        }
        
        int index=1;
        for (NSDictionary* result in results) {
            printf("%d\t%s\t%s\t%s\n",index,
                   [((NSString *)[result valueForKey:@"original_title"]) UTF8String],
                   [(NSString *)[result valueForKey:@"title"] UTF8String],
                   [(NSString *)[result valueForKey:@"release_date"] UTF8String]);
            
            index++;
        }
        printf("0\t input again\n");
        selectedIndex=[MovieFileRenamer readFromConsoleInput:100 withPrompt:@"Please input the choice:"];
    }
    
    return nil;
}


@end
