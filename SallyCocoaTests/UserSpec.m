//
//  UserSpec.m
//  Sally
//
//  Created by Zaid Al-Jarrah on 1/27/2014.
//  Copyright (c) 2014 Tokenize. All rights reserved.
//

#import "User.h"

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

SpecBegin(UserSpec)

describe(@"UserSpec", ^{
    __block User *user;

    beforeEach(^{
        user = [[User alloc] initWithDictionary: @{@"firstName": @"Joe", @"lastName": @"Tester", @"email": @"joe@example.ca"} error: nil];
    });

    afterEach(^{
        user = nil;
    });

    describe(@"initialization", ^{
        it(@"should have the correct firstName", ^{
            expect(user.firstName).to.equal(@"Joe");
        });

        it(@"should have the correct lastName", ^{
            expect(user.lastName).to.equal(@"Tester");
        });

        it(@"should have the correct email", ^{
            expect(user.email).to.equal(@"joe@example.ca");
        });
    });
});

SpecEnd
