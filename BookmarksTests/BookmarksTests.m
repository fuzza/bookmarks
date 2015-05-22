//
//  BookmarksTests.m
//  BookmarksTests
//
//  Created by fuzza on 12/1/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import "FUZFoursquareVenue.h"

SpecBegin(FUZFoursquareVenue)

describe(@"fields", ^{
    it(@"should assign fields", ^{
        FUZFoursquareVenue *sut = [[FUZFoursquareVenue alloc] init];
        
        sut.uid = @"uid";
        sut.name = @"test_name";
        
        EXP_expect(sut.uid).equal(@"uid");
        EXP_expect(sut.name).equal(@"test_name");
    });
    
    it(@"shouldn't pass", ^{
        EXP_failure(@"fail");
    });
});

SpecEnd