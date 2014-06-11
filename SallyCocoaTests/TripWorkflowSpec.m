//
//  TripWorkflowSpec.m
//  Sally
//
//  Created by Zaid Al-Jarrah on 2/2/2014.
//  Copyright (c) 2014 Tokenize. All rights reserved.
//

#import "SallyManager.h"
#import "MockSallyManagerDelegate.h"
#import "MockSallyCommunicator.h"
#import "User.h"
#import "Trip.h"

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

SpecBegin(TripWorkflowSpec)

describe(@"TripWorkflowSpec", ^{

    __block SallyManager *manager;
    __block MockSallyManagerDelegate *delegate;
    __block NSError *underlyingError;
    __block NSArray *tripArray;

    beforeEach(^{
        manager = [[SallyManager alloc] init];
        delegate = [[MockSallyManagerDelegate alloc] init];
        underlyingError = [NSError errorWithDomain: @"Test Domain" code: 0 userInfo: nil];
        Trip *trip = [[Trip alloc] init];
        tripArray = [NSArray arrayWithObject: trip];

        manager.delegate = delegate;
    });

    afterEach(^{
        manager = nil;
        delegate = nil;
        underlyingError = nil;
        tripArray = nil;
    });

    describe(@"manager's delegate", ^{
        it(@"should not allow a non-conforming object to be delegate", ^{
            expect(^{ manager.delegate = (id<SallyManagerDelegate>)[NSNull null]; }).to.raiseAny();
        });

        it(@"should allow conforming object to be delegate", ^{
            id<SallyManagerDelegate> mockDelegate = [[MockSallyManagerDelegate alloc] init];

            expect(^{ manager.delegate = mockDelegate; }).toNot.raiseAny();

            mockDelegate = nil;
        });

        it(@"should accept nil as delegate", ^{
            expect(^{ manager.delegate = nil; }).toNot.raiseAny();
        });
    });

    describe(@"fetch trips", ^{
        it(@"should ask communicator to fetch data", ^{
            MockSallyCommunicator *communicator = [[MockSallyCommunicator alloc] init];
            User *user = [[User alloc] initWithDictionary:@{@"firstName": @"John", @"lastName": @"Doe", @"email": @"jdoe@tokenize.ca"} error: nil];

            manager.user = user;
            manager.communicator = communicator;

            [manager fetchTrips];

            expect(communicator.wasAskedToFetchTrips).to.beTruthy();

            communicator = nil;
            user = nil;
        });

        context(@"success", ^{
            __block NSArray *trips;

            beforeEach(^{
                trips = @[@{@"id": @1, @"name": @"Test Trip 1", @"start_at": @"2014-04-05T17:09:41.960Z"}];
            });

            afterEach(^{
                trips = nil;
            });

            it(@"should pass an array of Trips to delegate", ^{
                [manager sallyCommunicator: nil didFetchTrips: trips];

                expect([delegate.receivedTrips count]).to.equal(1);
                expect([[delegate.receivedTrips objectAtIndex: 0] class]).to.equal([Trip class]);
                expect([[delegate.receivedTrips objectAtIndex: 0] name]).to.equal(@"Test Trip 1");
                expect([[delegate.receivedTrips objectAtIndex: 0] startAt]).toNot.beNil();
            });

            it(@"should not notify the delegate of any error", ^{
                [manager sallyCommunicator: nil didFetchTrips: trips];

                expect(delegate.error).to.beNil();
            });
        });

        context(@"failure", ^{
            it(@"should return a higher-level error to delegate", ^{
                NSError *communicatorError = [NSError errorWithDomain: @"Test domain" code: 0 userInfo: nil];
                [manager sallyCommunicator: nil fetchTripsFailedWithError: communicatorError];

                expect(communicatorError).toNot.equal(delegate.error);

                communicatorError = nil;
            });

            it(@"should include underlying error", ^{
                NSError *communicatorError = [NSError errorWithDomain: @"Test domain" code: 0 userInfo: nil];
                [manager sallyCommunicator: nil fetchTripsFailedWithError: communicatorError];

                expect([[delegate.error userInfo] objectForKey: NSUnderlyingErrorKey]).to.equal(communicatorError);

                communicatorError = nil;
            });
        });
    });

    describe(@"create trip", ^{
        context(@"success", ^{
            __block NSDictionary *tripJSON;

            beforeEach(^{
                tripJSON = @{@"id": @2, @"name": @"Trip 2", @"start_at": @"2014-04-09T23:54:06.000Z"};
            });

            afterEach(^{
                tripJSON = nil;
            });

            context(@"success", ^{
                it(@"should pass the created trip to the delegate", ^{
                    [manager sallyCommunicator: nil didCreateTrip: tripJSON];

                    expect(delegate.trip).toNot.beNil();
                    expect(delegate.trip.tripId).to.equal(2);
                    expect(delegate.trip.name).to.equal(@"Trip 2");
                    expect(delegate.trip.startAt).toNot.beNil();
                });

                it(@"should not notify the delegate of any errors", ^{
                    [manager sallyCommunicator: nil didCreateTrip: tripJSON];

                    expect(delegate.error).to.beNil();
                });
            });

            context(@"failure", ^{
                __block NSError *communicatorError;

                beforeEach(^{
                    communicatorError = [NSError errorWithDomain: @"Test domain" code: 0 userInfo: nil];
                });

                afterEach(^{
                    communicatorError = nil;
                });

                it(@"should return a higher-level error to delegate", ^{
                    [manager sallyCommunicator: nil createTripFailedWithError: communicatorError];

                    expect(delegate.error).toNot.equal(communicatorError);
                });

                it(@"should include underlying error", ^{
                    [manager sallyCommunicator: nil createTripFailedWithError: communicatorError];

                    expect([[delegate.error userInfo] objectForKey: NSUnderlyingErrorKey]).to.equal(communicatorError);
                });
            });
        });
    });

    describe(@"update trip", ^{
        context(@"success", ^{
            __block NSDictionary *tripJSON;

            beforeEach(^{
                tripJSON = @{@"id": @3, @"name": @"Trip 3", @"start_at": @"2014-04-14T23:54:06.000Z"};
            });

            afterEach(^{
                tripJSON = nil;
            });

            context(@"success", ^{
                it(@"should pass the updated trip to the delegate", ^{
                    [manager sallyCommunicator: nil didUpdateTrip: tripJSON];

                    expect(delegate.trip).toNot.beNil();
                    expect(delegate.trip.tripId).to.equal(3);
                    expect(delegate.trip.name).to.equal(@"Trip 3");
                    expect(delegate.trip.startAt).toNot.beNil();
                });

                it(@"should not notify the delegate of any errors", ^{
                    [manager sallyCommunicator: nil didUpdateTrip: tripJSON];

                    expect(delegate.error).to.beNil();
                });
            });

            context(@"failure", ^{
                __block NSError *communicatorError;

                beforeEach(^{
                    communicatorError = [NSError errorWithDomain: @"Test domain" code: 0 userInfo: nil];
                });

                afterEach(^{
                    communicatorError = nil;
                });

                it(@"should return a higher-level error to delegate", ^{
                    [manager sallyCommunicator: nil updateTripFailedWithError: communicatorError];

                    expect(delegate.error).toNot.equal(communicatorError);
                });

                it(@"should include underlying error", ^{
                    [manager sallyCommunicator: nil updateTripFailedWithError: communicatorError];

                    expect([[delegate.error userInfo] objectForKey: NSUnderlyingErrorKey]).to.equal(communicatorError);
                });
            });
        });
    });

    describe(@"delete trip", ^{
        context(@"success", ^{
            __block NSDictionary *tripJSON;

            beforeEach(^{
                tripJSON = @{@"id": @3, @"name": @"Trip 3", @"start_at": @"2014-04-14T23:54:06.000Z"};
            });

            afterEach(^{
                tripJSON = nil;
            });

            context(@"success", ^{
                it(@"should pass the deleted trip to the delegate", ^{
                    [manager sallyCommunicator: nil didDeleteTrip: tripJSON];

                    expect(delegate.trip).toNot.beNil();
                    expect(delegate.trip.tripId).to.equal(3);
                    expect(delegate.trip.name).to.equal(@"Trip 3");
                    expect(delegate.trip.startAt).toNot.beNil();
                });

                it(@"should not notify the delegate of any errors", ^{
                    [manager sallyCommunicator: nil didDeleteTrip: tripJSON];

                    expect(delegate.error).to.beNil();
                });
            });

            context(@"failure", ^{
                __block NSError *communicatorError;

                beforeEach(^{
                    communicatorError = [NSError errorWithDomain: @"Test domain" code: 0 userInfo: nil];
                });

                afterEach(^{
                    communicatorError = nil;
                });

                it(@"should return a higher-level error to delegate", ^{
                    [manager sallyCommunicator: nil deleteTripFailedWithError: communicatorError];

                    expect(delegate.error).toNot.equal(communicatorError);
                    expect([delegate.error domain]).will.equal(@"SallyManagerError");
                    expect([delegate.error code]).will.equal(SallyManagerErrorDeleteTrip);
                });

                it(@"should include underlying error", ^{
                    [manager sallyCommunicator: nil deleteTripFailedWithError: communicatorError];

                    expect([[delegate.error userInfo] objectForKey: NSUnderlyingErrorKey]).to.equal(communicatorError);
                });
            });
        });
    });
});

SpecEnd
