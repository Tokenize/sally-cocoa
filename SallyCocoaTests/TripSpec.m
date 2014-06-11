//
//  TripSpec.m
//  Sally
//
//  Created by Zaid Al-Jarrah on 1/27/2014.
//  Copyright (c) 2014 Tokenize. All rights reserved.
//

#import "Trip.h"
#import "Location.h"

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

SpecBegin(TripSpec)

describe(@"TripSpec", ^{

    __block Trip *trip;

    beforeEach(^{
        trip = [[Trip alloc] initWithDictionary: @{@"name": @"Morning walk", @"description": @"A short morning walk",
                                                   @"startAt": [[NSDate distantPast] description], @"endAt": [[NSDate distantFuture] description]} error: nil];
    });

    afterEach(^{
        trip = nil;
    });

    describe(@"initialization", ^{
        it(@"should have an ID of zero", ^{
            expect(trip.tripId).to.equal(0);
        });

        it(@"should have zero locations", ^{
            expect([trip.locations count]).to.equal(0);
        });

        it(@"should have the correct name", ^{
            expect(trip.name).to.equal(@"Morning walk");
        });

        it(@"should have the correct description", ^{
            expect(trip.description).to.equal(@"A short morning walk");
        });

        it(@"should have the correct startAt", ^{
            expect([trip.startAt description]).to.equal([[NSDate distantPast] description]);
        });

        it(@"should have the correct endAt", ^{
            expect([trip.endAt description]).to.equal([[NSDate distantFuture] description]);
        });
    });

    describe(@"validations", ^{
        context(@"required fields", ^{
            it(@"should be invalid without 'name'", ^{
                Trip *newTrip = [[Trip alloc] initWithDictionary: @{@"startAt": [[NSDate distantPast] description]} error: nil];

                expect([newTrip validate: nil]).to.beFalsy();

                newTrip = nil;
            });

            it(@"should be invalid without 'startAt'", ^{
                Trip *newTrip = [[Trip alloc] initWithDictionary: @{@"name": @"Some trip"} error: nil];

                expect([newTrip validate: nil]).to.beFalsy();

                newTrip = nil;
            });
        });

        context(@"optional fields", ^{
            it(@"should be valid without 'description'", ^{
                Trip *newTrip = [[Trip alloc] initWithDictionary: @{@"name": @"Test", @"startAt": [[NSDate distantPast] description], @"endAt": [[NSDate distantFuture] description]} error: nil];

                expect([newTrip validate: nil]).to.beTruthy();
                expect(newTrip.name).to.equal(@"Test");
                expect(newTrip.description).to.beNil();
                expect([newTrip.startAt description]).to.equal([[NSDate distantPast] description]);
                expect([newTrip.endAt description]).to.equal([[NSDate distantFuture] description]);

                newTrip = nil;
            });

            it(@"should be valid without 'endAt'", ^{
                Trip *newTrip = [[Trip alloc] initWithDictionary: @{@"name": @"Test", @"startAt": [[NSDate distantPast] description]} error: nil];

                expect([newTrip validate: nil]).to.beTruthy();
                expect(newTrip.name).to.equal(@"Test");
                expect(newTrip.description).to.beNil();
                expect([newTrip.startAt description]).to.equal([[NSDate distantPast] description]);
                expect(newTrip.endAt).to.beNil();

                newTrip = nil;
            });
        });
    });

    it(@"should be able to update the tripId", ^{
        trip.tripId = 5;

        expect(trip.tripId).to.equal(5);
    });

    describe(@"location managment", ^{
        it(@"should be able to add locations", ^{
            Location *newLocation = [[Location alloc] init];

            expect(^{ [trip addLocation: newLocation]; }).toNot.raiseAny();

            newLocation = nil;
        });

        it(@"should return locations in the same order they were added", ^{
            Location *newLocation1 = [[Location alloc] init];
            Location *newLocation2 = [[Location alloc] init];
            Location *newLocation3 = [[Location alloc] init];

            newLocation1.time = [NSDate distantPast];
            newLocation2.time = [NSDate distantFuture];
            newLocation3.travelDirection = @"South";

            [trip addLocation: newLocation1];
            [trip addLocation: newLocation2];
            [trip addLocation: newLocation3];

            NSArray *locations = trip.locations;

            expect([locations firstObject]).to.equal(newLocation1);
            expect([locations objectAtIndex: 1]).to.equal(newLocation2);
            expect([locations lastObject]).to.equal(newLocation3);

            newLocation1 = nil;
            newLocation2 = nil;
            newLocation3 = nil;
            locations = nil;
        });
    });

});

SpecEnd
