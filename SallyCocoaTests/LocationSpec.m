//
//  LocationSpec.m
//  Sally
//
//  Created by Zaid Al-Jarrah on 1/28/2014.
//  Copyright (c) 2014 Tokenize. All rights reserved.
//

#import "Location.h"

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

SpecBegin(LocationSpec)

describe(@"LocationSpec", ^{
    __block Location *location;
    
    beforeEach(^{
        location = [[Location alloc] init];
    });

    afterEach(^{
        location = nil;
    });

    describe(@"initialization", ^{
        context(@"without any parameters", ^{
            it(@"should have a locationId of zero", ^{
                expect(location.locationId).to.equal(0);
            });
        });

        context(@"with a list of parameters", ^{
            __block Location *filledLocation;

            beforeEach(^{
                filledLocation = [[Location alloc] initWithDictionary: @{@"locationId": @6, @"tripId": @2, @"time": [NSDate distantPast], @"latitude": @123456789, @"longitude": @123456785, @"travelDirection": @"North", @"travelSpeed": @42} error: nil];
            });

            afterEach(^{
                filledLocation = nil;
            });

            it(@"should have the correct 'tripId'", ^{
                expect(filledLocation.tripId).to.equal(2);
            });

            it(@"should have the correct 'locationId'", ^{
                expect(filledLocation.locationId).to.equal(6);
            });

            it(@"should have the correct 'time'", ^{
                expect([filledLocation.time description]).to.equal([[NSDate distantPast] description]);
            });

            it(@"should have the correct 'latitude'", ^{
                expect(filledLocation.latitude).to.equal(123456789);
            });

            it(@"should have the correct 'longitude'", ^{
                expect(filledLocation.longitude).to.equal(123456785);
            });

            it(@"should have the correct 'travelDirection'", ^{
                expect(filledLocation.travelDirection).to.equal(@"North");
            });

            it(@"should have the correct 'travelSpeed'", ^{
                expect(filledLocation.travelSpeed).to.equal(42);
            });
        });
    });
});

SpecEnd
