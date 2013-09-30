//
//  MovieFileRenamerXPortTests.m
//  MovieFileRenamerXPortTests
//
//  Created by Office on 13-9-30.
//  Copyright (c) 2013年 EzComponent. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MovieFileRenamer.h"

@interface MovieFileRenamerXPortTests : XCTestCase

@end

@implementation MovieFileRenamerXPortTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_get_10_search_results_in_tmdb
{
    MovieFileRenamer* renamer=[MovieFileRenamer new];
    NSDictionary* jsonObj=[renamer searchMovieInTmdb:@"Fight Club"];
    
    XCTAssertNotNil(jsonObj, @"Should get response");
    XCTAssertEqual([NSNumber numberWithLong:10], [jsonObj objectForKey:@"total_results"], @"Should get 10 results");
}

- (void) test_should_get_1_file_in_list {
    MovieFileRenamer* renamer=[MovieFileRenamer new];
    renamer.processPath=@"/etc/hosts";
    NSArray* files=[renamer getFiles];
    
    XCTAssertEqual(1, (int)[files count], @"should get 1 file");
    XCTAssertEqual(@"/etc/hosts", [files objectAtIndex:0], @"Should get /etc/hosts");
}

- (void) test_get_more_than_one_files_in_list {
    MovieFileRenamer* renamer=[MovieFileRenamer new];
    renamer.processPath=@"/etc/";
    NSArray* files=[renamer getFiles];
    
    XCTAssertTrue((int)[files count]>1, @"Should get more than one files");
    XCTAssertTrue([files containsObject:@"/etc/hosts"], @"Should contains /etc/hosts");
}



@end
