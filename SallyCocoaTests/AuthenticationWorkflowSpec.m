//
//  AuthenticationWorkflowSpec.m
//  Sally
//
//  Created by Zaid Al-Jarrah on 10/4/2014.
//  Copyright (c) 2014 Tokenize. All rights reserved.
//

#import "SallyManager.h"
#import "MockSallyManagerDelegate.h"
#import "MockSallyCommunicator.h"

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

SpecBegin(AuthenticationWorkflowSpec)

describe(@"AuthenticationWorkflowSpec", ^{
    __block SallyManager *manager;
    __block MockSallyManagerDelegate *delegate;
    __block NSError *underlyingError;

    beforeEach(^{
        manager = [[SallyManager alloc] init];
        delegate = [[MockSallyManagerDelegate alloc] init];
        underlyingError = [NSError errorWithDomain: @"Test Domain" code: 0 userInfo: nil];

        manager.delegate = delegate;
    });

    afterEach(^{
        manager = nil;
        delegate = nil;
        underlyingError = nil;
    });

    describe(@"sign in", ^{
        context(@"success", ^{
            it(@"should ask the communicator to sign in", ^{
                MockSallyCommunicator *communicator = [[MockSallyCommunicator alloc] init];

                manager.communicator = communicator;
                [manager signInWithEmail: @"foo" password: @"bar"];

                expect(communicator.wasAskedToSignIn).to.equal(true);

                manager.communicator = nil;
                communicator = nil;
            });

            it(@"should pass the authentication token to the delegate", ^{
                [manager sallyCommunicator: nil didSignInWithToken: @"api_token"];

                expect(delegate.auth_token).to.equal(@"api_token");
            });

            it(@"should not notify delegate of any error", ^{
                [manager sallyCommunicator: nil didSignInWithToken: @"api_token"];

                expect(delegate.error).to.beNil();
            });
        });

        context(@"failure", ^{
            __block NSError *communicatorError;

            beforeEach(^{
                communicatorError = [NSError errorWithDomain: @"Test Domain" code: 0 userInfo: nil];
            });

            afterEach(^{
                communicatorError = nil;
            });

            it(@"should return a higher-level error to delegate", ^{
                [manager sallyCommunicator: nil signInFailedWithError: communicatorError];

                expect(delegate.error).toNot.equal(communicatorError);
            });

            it(@"should include underlying error", ^{
                [manager sallyCommunicator: nil signInFailedWithError: communicatorError];

                expect([[delegate.error userInfo] objectForKey: NSUnderlyingErrorKey]).to.equal(communicatorError);
            });
        });
    });
});

SpecEnd