//
//  LocationWorkflowSpec.m
//  Sally
//
//  Created by Zaid Al-Jarrah on 2/17/2014.
//  Copyright (c) 2014 Tokenize. All rights reserved.
//

#import "SallyManager.h"
#import "MockSallyManagerDelegate.h"
#import "MockSallyCommunicator.h"
#import "Location.h"
#import "Trip.h"

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

SpecBegin(LocationWorkflowSpec)

describe(@"LocationWorkflowSpec", ^{
    __block SallyManager *manager;
    __block MockSallyManagerDelegate *delegate;
    __block NSError *underlyingError;
    __block NSArray *locationsArray;
    __block Trip *trip;

    beforeEach(^{
        manager = [[SallyManager alloc] init];
        delegate = [[MockSallyManagerDelegate alloc] init];
        underlyingError = [NSError errorWithDomain: @"Test Domain" code: 0 userInfo: nil];
        Location *location = [[Location alloc] init];
        locationsArray = [NSArray arrayWithObject: location];
        trip = [[Trip alloc] initWithDictionary: @{@"tripId": @1, @"name": @"Test", @"startAt": [NSDate date]} error: nil];

        manager.delegate = delegate;
    });

    afterEach(^{
        manager = nil;
        delegate = nil;
        underlyingError = nil;
        locationsArray = nil;
        trip = nil;
    });

    describe(@"fetch locations for trip", ^{
        it(@"should ask communicator to fetch data", ^{
            MockSallyCommunicator *communicator = [[MockSallyCommunicator alloc] init];
            manager.communicator = communicator;

            [manager fetchLocationsForTrip: trip.tripId];

            expect(communicator.wasAskedToFetchLocations).to.beTruthy();

            communicator = nil;
        });

        context(@"success", ^{
            __block NSArray *locations;

            beforeEach(^{
                locations = @[@{@"id": @1, @"time": @"2014-03-29T16:43:23.838Z", @"direction": @"North", @"latitude": @123456, @"longitude": @654321, @"speed": @50}];
            });

            afterEach(^{
                locations = nil;
            });

            it(@"should pass an array of Locations to delegate", ^{
                [manager sallyCommunicator: nil didFetchLocationsForTrip: locations];

                expect([delegate.receivedLocations count]).to.equal(1);
                expect([[delegate.receivedLocations firstObject] class]).to.equal(Location.class);
                expect([[delegate.receivedLocations firstObject] locationId]).to.equal(1);
                expect([[delegate.receivedLocations firstObject] time]).toNot.beNil();
                expect([[delegate.receivedLocations firstObject] travelDirection]).to.equal(@"North");
                expect([[delegate.receivedLocations firstObject] latitude]).to.equal(123456);
                expect([[delegate.receivedLocations firstObject] longitude]).to.equal(654321);
                expect([[delegate.receivedLocations firstObject] travelSpeed]).to.equal(50);
            });

            it(@"should not notify the delegate of any errors", ^{
                [manager sallyCommunicator: nil didFetchLocationsForTrip: locations];

                expect(delegate.error).to.beNil();
            });
        });

        context(@"failure", ^{
            it(@"should return a higher-level error to delegate", ^{
                NSError *communicatorError = [NSError errorWithDomain: @"Test domain" code: 0 userInfo: nil];

                [manager sallyCommunicator: nil fetchLocationsForTripFailedWithError: communicatorError];

                expect(communicatorError).toNot.equal(delegate.error);

                communicatorError = nil;
            });

            it(@"should include underlying error", ^{
                NSError *communicatorError = [NSError errorWithDomain: @"Test domain" code: 0 userInfo: nil];

                [manager sallyCommunicator: nil fetchLocationsForTripFailedWithError: communicatorError];

                expect([[delegate.error userInfo] objectForKey: NSUnderlyingErrorKey]).to.equal(communicatorError);

                communicatorError = nil;
            });
        });
    });

    describe(@"create location for trip", ^{
        context(@"success", ^{
            __block NSDictionary *locationJSON;

            beforeEach(^{
                locationJSON = @{@"id": @1, @"time": @"2014-03-29T16:43:23.838Z", @"direction": @"North", @"latitude": @123456, @"longitude": @654321, @"speed": @50};
            });

            afterEach(^{
                locationJSON = nil;
            });

            it(@"should ask the communicator to create location", ^{
                MockSallyCommunicator *communicator = [[MockSallyCommunicator alloc] init];

                manager.communicator = communicator;

                Location *location = [[Location alloc] initWithDictionary: @{@"locationId": @6, @"tripId": @2, @"time": [NSDate distantPast], @"latitude": @123456789, @"longitude": @123456785, @"travelDirection": @"North", @"travelSpeed": @42} error: nil];

                [manager createLocation: location];

                expect(communicator.wasAskedToCreateLocation).to.beTruthy();

                communicator = nil;
                location = nil;
            });

            it(@"should pass the created location to the delegate", ^{
                [manager sallyCommunicator: nil didCreateLocation: locationJSON];

                expect(delegate.location).toNot.beNil();
                expect(delegate.location.locationId).to.equal(1);
                expect(delegate.location.time).toNot.beNil();
                expect(delegate.location.travelDirection).to.equal(@"North");
                expect(delegate.location.latitude).to.equal(123456);
                expect(delegate.location.longitude).to.equal(654321);
                expect(delegate.location.travelSpeed).to.equal(50);
            });

            it(@"should not notify the delegate of any errors", ^{
                [manager sallyCommunicator: nil didCreateLocation: locationJSON];

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
                [manager sallyCommunicator: nil createLocationFailedWithError: communicatorError];

                expect(delegate.error).toNot.equal(communicatorError);
            });

            it(@"should include underlying error", ^{
                [manager sallyCommunicator: nil createLocationFailedWithError: communicatorError];

                expect([[delegate.error userInfo] objectForKey: NSUnderlyingErrorKey]).to.equal(communicatorError);
            });
        });
    });

    describe(@"update location for trip", ^{
        context(@"success", ^{
            __block NSDictionary *locationJSON;

            beforeEach(^{
                locationJSON = @{@"id": @1, @"time": @"2014-03-29T16:43:23.838Z", @"direction": @"North", @"latitude": @123456, @"longitude": @654321, @"speed": @50};
            });

            afterEach(^{
                locationJSON = nil;
            });

            it(@"should pass the updated location to the delegate", ^{
                [manager sallyCommunicator: nil didUpdateLocation: locationJSON];

                expect(delegate.location).toNot.beNil();
                expect(delegate.location.locationId).to.equal(1);
                expect(delegate.location.time).toNot.beNil();
                expect(delegate.location.travelDirection).to.equal(@"North");
                expect(delegate.location.latitude).to.equal(123456);
                expect(delegate.location.longitude).to.equal(654321);
                expect(delegate.location.travelSpeed).to.equal(50);
            });

            it(@"should not notify the delegate of any errors", ^{
                [manager sallyCommunicator: nil didUpdateLocation: locationJSON];

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
                [manager sallyCommunicator: nil updateLocationFailedWithError: communicatorError];

                expect(delegate.error).toNot.equal(communicatorError);
                expect([delegate.error domain]).to.equal(SallyManagerErrors);
                expect([delegate.error code]).to.equal(SallyManagerErrorUpdateLocation);
            });

            it(@"should include underlying error", ^{
                [manager sallyCommunicator: nil updateLocationFailedWithError: communicatorError];

                expect([[delegate.error userInfo] objectForKey: NSUnderlyingErrorKey]).to.equal(communicatorError);
            });
        });
    });

    describe(@"delete location for trip", ^{
        context(@"success", ^{
            __block NSDictionary *locationJSON;

            beforeEach(^{
                locationJSON = @{@"id": @1, @"time": @"2014-03-29T16:43:23.838Z", @"direction": @"North", @"latitude": @123456, @"longitude": @654321, @"speed": @50};
            });

            afterEach(^{
                locationJSON = nil;
            });

            it(@"should pass the deleted location to the delegate", ^{
                [manager sallyCommunicator: nil didDeleteLocation: locationJSON];

                expect(delegate.location).toNot.beNil();
                expect(delegate.location.locationId).to.equal(1);
                expect(delegate.location.time).toNot.beNil();
                expect(delegate.location.travelDirection).to.equal(@"North");
                expect(delegate.location.latitude).to.equal(123456);
                expect(delegate.location.longitude).to.equal(654321);
                expect(delegate.location.travelSpeed).to.equal(50);
            });

            it(@"should not notify the delegate of any errors", ^{
                [manager sallyCommunicator: nil didDeleteLocation: locationJSON];

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
                [manager sallyCommunicator: nil deleteLocationFailedWithError: communicatorError];

                expect(delegate.error).toNot.equal(communicatorError);
                expect([delegate.error domain]).to.equal(SallyManagerErrors);
                expect([delegate.error code]).to.equal(SallyManagerErrorDeleteLocation);
            });

            it(@"should include underlying error", ^{
                [manager sallyCommunicator: nil deleteLocationFailedWithError: communicatorError];

                expect([[delegate.error userInfo] objectForKey: NSUnderlyingErrorKey]).to.equal(communicatorError);
            });
        });
    });
});

SpecEnd