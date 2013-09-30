//
//  MovieFileRenamer.h
//  MovieFileRenamerXPort
//
//  Created by Office on 13-9-29.
//  Copyright (c) 2013年 EzComponent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieFileRenamer : NSObject

@property NSString* processPath;

-(NSArray*) getFiles;
-(NSDictionary*) searchMovieInTmdb:(NSString*) searchKey;


@end
