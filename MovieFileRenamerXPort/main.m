//
//  main.m
//  MovieFileRenamerXPort
//
//  Created by Office on 13-9-30.
//  Copyright (c) 2013年 EzComponent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieFileRenamer.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        
        MovieFileRenamer* renamer=[MovieFileRenamer new];
        [renamer handleInConsole];
        
    }
    return 0;
}