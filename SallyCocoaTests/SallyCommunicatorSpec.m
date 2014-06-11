//
//  SallyCommunicatorSpec.m
//  Sally
//
//  Created by Zaid Al-Jarrah on 2014-03-25.
//  Copyright (c) 2014 Tokenize. All rights reserved.
//

#import "SallyCommunicator.h"
#import "MockSallyCommunicatorDelegate.h"

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "Nocilla.h"

SpecBegin(SallyCommunicator)

describe(@"SallyCommunicator", ^{
    
    __block SallyCommunicator *communicator;
    __block MockSallyCommunicatorDelegate *communicatorDelegate;
    
    beforeAll(^{
        [Expecta setAsynchronousTestTimeout: 5];
        [[LSNocilla sharedInstance] start];
    });

    beforeEach(^{
        communicator = [SallyCommunicator sharedSallyCommunicator];
        communicatorDelegate = [[MockSallyCommunicatorDelegate alloc] init];
        
        communicator.delegate = communicatorDelegate;
    });
    
    afterEach(^{
        [[LSNocilla sharedInstance] clearStubs];

        communicator = nil;
        communicatorDelegate = nil;
    });

    afterAll(^{
        [[LSNocilla sharedInstance] stop];
    });

    describe(@"Sign-in", ^{
        context(@"success", ^{
            it(@"should pass the token to the delegate", ^{
                stubRequest(@"GET", @"https://sally-api.tokenize.ca/api/users/sign_in?email=zaid%40tokenize.ca&password=secret").
                andReturn(200).
                withHeader(@"Content-Type", @"application/json").
                withBody(@"\"api_token\"");

                [communicator signInWithEmail: @"zaid@tokenize.ca" password: @"secret"];

                expect(communicatorDelegate.apiToken).will.equal(@"api_token");
            });
        });
        
        context(@"failure", ^{
            it(@"should notify delegate of error", ^{
                stubRequest(@"GET", @"https://sally-api.tokenize.ca/api/users/sign_in?email=zaid%40tokenize.ca&password=invalid").
                andReturn(401).
                withHeader(@"Content-Type", @"application/json").
                withBody(@"{\"message\":\"Access Denied\"}");

                [communicator signInWithEmail: @"zaid@tokenize.ca" password: @"invalid"];

                expect(communicatorDelegate.error).willNot.beNil();
                expect(communicatorDelegate.apiToken).will.beNil();
            });
        });
    });
    
    describe(@"Fetch trips", ^{
        context(@"success", ^{
            it(@"should pass the trips to the delegate", ^{
                stubRequest(@"GET", @"https://sally-api.tokenize.ca/api/trips?auth_token=secret").
                andReturn(200).
                withHeader(@"Content-Type", @"application/json").
                withBody(@"[{\"id\":1,\"name\":\"Test 1\",\"start_at\":\"2014-03-25T00:41:21+00:00\"}]");

                communicator.parameters[@"auth_token"] = @"secret";
                [communicator fetchTrips];

                expect([communicatorDelegate.trips count]).will.beGreaterThan(0);
            });
        });
        
        context(@"failure", ^{
            it(@"should notify delegate of error", ^{
                stubRequest(@"GET", @"https://sally-api.tokenize.ca/api/trips?auth_token=invalid_token").
                andReturn(401).
                withHeader(@"Content-Type", @"application/json").
                withBody(@"{\"message\":\"Access Denied\"}");

                communicator.parameters[@"auth_token"] = @"invalid_token";
                [communicator fetchTrips];

                expect(communicatorDelegate.error).willNot.beNil();
                expect([communicatorDelegate.trips count]).will.equal(0);
            });
        });
    });

    describe(@"Fetch Locations for a Trip",  ^{
        context(@"success", ^{
            it(@"should pass the locations to the delegate", ^{
                stubRequest(@"GET", @"https://sally-api.tokenize.ca/api/trips/1/locations?auth_token=secret").
                andReturn(200).
                withHeader(@"Content-Type", @"application/json").
                withBody(@"[{\"id\":2,\"trip_id\":1,\"latitude\":123456,\"longitude\":654321,\"time\":\"2014-03-25T00:45:21+00:00\",\"direction\": \"N\",\"speed\":100}]");

                communicator.parameters[@"auth_token"] = @"secret";
                [communicator fetchLocationsForTrip: 1];

                expect([communicatorDelegate.locations count]).will.beGreaterThan(0);
            });
        });

        context(@"failure", ^{
            it(@"should notify delegate of error", ^{
                stubRequest(@"GET", @"https://sally-api.tokenize.ca/api/trips/0/locations?auth_token=secret").
                andFailWithError([NSError errorWithDomain: @"AFNetworkingErrorDomain" code: -1011 userInfo: @{@"message": @"Invalid Trip"}]);

                communicator.parameters[@"auth_token"] = @"secret";
                [communicator fetchLocationsForTrip: 0];

                expect(communicatorDelegate.error).willNot.beNil();
                expect([communicatorDelegate.locations count]).will.equal(0);
            });
        });
    });
    
    describe(@"Create trip", ^{
        context(@"success", ^{
            it(@"should pass the newly created trip to the delegate", ^{
                stubRequest(@"POST", @"https://sally-api.tokenize.ca/api/trips").
                withHeader(@"Content-Type", @"application/json; charset=utf-8").
                withBody(@"{\"name\":\"Test 2\",\"start_at\":\"4001-01-01 00:00:00 +0000\",\"auth_token\":\"secret\"}").
                andReturn(201).
                withHeader(@"Content-Type", @"application/json").
                withBody(@"{\"id\":2,\"name\":\"Test 2\",\"start_at\":\"2014-03-25T00:41:21+00:00\"}");

                NSDictionary *tripAttributes = @{@"name": @"Test 2", @"start_at": [[NSDate distantFuture] description]};
                
                communicator.parameters[@"auth_token"] = @"secret";
                [communicator createTrip: tripAttributes];

                expect(communicatorDelegate.trip).willNot.beNil();
                expect(communicatorDelegate.trip[@"name"]).will.equal(@"Test 2");
            });
        });
        
        context(@"failure", ^{
            it(@"should notify delegate of error", ^{
                stubRequest(@"POST", @"https://sally-api.tokenize.ca/api/trips").
                withHeader(@"Content-Type", @"application/json; charset=utf-8").
                withBody(@"{\"auth_token\":\"secret\",\"random\":\"key\"}").
                andReturn(500).
                withHeader(@"Content-Type", @"application/json").
                withBody(@"{\"message\":\"Missing required fields\"}");

                communicator.parameters[@"auth_token"] = @"secret";
                [communicator createTrip: @{@"random": @"key"}];

                expect(communicatorDelegate.error).willNot.beNil();
                expect(communicatorDelegate.trip).will.beNil();
            });
        });
    });

    describe(@"Create location", ^{
        context(@"success", ^{
            it(@"should pass the newly created location to the delegate", ^{
                stubRequest(@"POST", @"https://sally-api.tokenize.ca/api/trips/1/locations").
                withHeader(@"Content-Type", @"application/json; charset=utf-8").
                withBody(@"{\"trip_id\":\"1\",\"auth_token\":\"secret\",\"latitude\":\"123456789\",\"longitude\":\"987654321\",\"time\":\"4001-01-01 00:00:00 +0000\"}").
                andReturn(201).
                withHeader(@"Content-Type", @"application/json").
                withBody(@"{\"id\":3,\"latitude\":\"123456789\",\"longitude\":\"987654321\",\"time\":\"4001-01-01 00:00:00 +0000\"}");

                NSDictionary *locationAttributes = @{@"trip_id": @"1", @"time": [[NSDate distantFuture] description], @"latitude": @"123456789", @"longitude": @"987654321"};

                communicator.parameters[@"auth_token"] = @"secret";
                [communicator createLocationForTrip: locationAttributes];

                expect(communicatorDelegate.location).willNot.beNil();
                expect(communicatorDelegate.error).will.beNil();
            });
        });

        context(@"failure", ^{
            it(@"should notify delegate of error", ^{
                stubRequest(@"POST", @"https://sally-api.tokenize.ca/api/trips/1/locations").
                withHeader(@"Content-Type", @"application/json; charset=utf-8").
                withBody(@"{\"trip_id\":\"1\",\"auth_token\":\"secret\",\"latitude\":\"123456789\",\"longitude\":\"987654321\"}").
                andReturn(400).
                withHeader(@"Content-Type", @"application/json").
                withBody(@"{\"error\": \"Time is required\"}");

                NSDictionary *locationAttributes = @{@"trip_id": @"1", @"latitude": @"123456789", @"longitude": @"987654321"};

                communicator.parameters[@"auth_token"] = @"secret";
                [communicator createLocationForTrip: locationAttributes];

                expect(communicatorDelegate.error).willNot.beNil();
                expect(communicatorDelegate.location).will.beNil();
            });
        });
    });

    describe(@"Update location", ^{
        context(@"success", ^{
            it(@"should pass the newly updated location to the delegate", ^{
                stubRequest(@"PUT", @"https://sally-api.tokenize.ca/api/trips/1/locations/2").
                withHeader(@"Content-Type", @"application/json; charset=utf-8").
                withBody(@"{\"trip_id\":1,\"id\":2,\"auth_token\":\"secret\",\"latitude\":\"123456789\",\"longitude\":\"987654321\",\"time\":\"4001-01-01 00:00:00 +0000\"}").
                andReturn(201).
                withHeader(@"Content-Type", @"application/json").
                withBody(@"{\"id\":2,\"latitude\":\"123456789\",\"longitude\":\"987654321\",\"time\":\"4001-01-01 00:00:00 +0000\"}");

                NSDictionary *locationAttributes = @{@"id": @2, @"trip_id": @1, @"time": [[NSDate distantFuture] description], @"latitude": @"123456789", @"longitude": @"987654321"};

                communicator.parameters[@"auth_token"] = @"secret";
                [communicator updateLocationForTrip: locationAttributes];

                expect(communicatorDelegate.location).willNot.beNil();
                expect(communicatorDelegate.error).will.beNil();
            });
        });

        context(@"failure", ^{
            it(@"should notify delegate of error", ^{
                stubRequest(@"PUT", @"https://sally-api.tokenize.ca/api/trips/1/locations/2").
                withHeader(@"Content-Type", @"application/json; charset=utf-8").
                withBody(@"{\"trip_id\":1,\"id\":2,\"auth_token\":\"secret\",\"latitude\":\"123456789\",\"longitude\":\"987654321\"}").
                andReturn(400).
                withHeader(@"Content-Type", @"application/json").
                withBody(@"{\"error\": \"Time is required\"}");

                NSDictionary *locationAttributes = @{@"id": @2, @"trip_id": @1, @"latitude": @"123456789", @"longitude": @"987654321"};

                communicator.parameters[@"auth_token"] = @"secret";
                [communicator updateLocationForTrip: locationAttributes];

                expect(communicatorDelegate.error).willNot.beNil();
                expect(communicatorDelegate.location).will.beNil();
            });
        });
    });

    describe(@"Update trip", ^{
        context(@"success", ^{
            it(@"should pass the updated trip to the delegate", ^{
                stubRequest(@"PUT", @"https://sally-api.tokenize.ca/api/trips/1").
                withHeader(@"Content-Type", @"application/json; charset=utf-8").
                withBody(@"{\"auth_token\":\"secret\",\"id\":1,\"name\":\"Test 3\",\"start_at\":\"4001-01-01 00:00:00 +0000\"}").
                andReturn(200).
                withHeader(@"Content-Type", @"application/json").
                withBody(@"{\"id\":1,\"name\":\"Test 3\",\"start_at\":\"4001-01-01T00:00:00.000Z\"}");

                NSDictionary *tripParameters = @{@"id": @1, @"name": @"Test 3", @"start_at": [[NSDate distantFuture] description]};

                communicator.parameters[@"auth_token"] = @"secret";
                [communicator updateTrip: tripParameters];

                expect(communicatorDelegate.trip).willNot.beNil();
                expect(communicatorDelegate.trip[@"id"]).will.equal(@1);
                expect(communicatorDelegate.trip[@"name"]).will.equal(@"Test 3");
                expect(communicatorDelegate.trip[@"start_at"]).willNot.beNil();
                expect(communicatorDelegate.error).will.beNil();

                tripParameters = nil;
            });
        });

        context(@"failure", ^{
            it(@"should notify delegate of error", ^{
                stubRequest(@"PUT", @"https://sally-api.tokenize.ca/api/trips/1").
                withHeader(@"Content-Type", @"application/json; charset=utf-8").
                withBody(@"{\"auth_token\":\"secret\",\"id\":1,\"name\":\"\",\"start_at\":\"4001-01-01 00:00:00 +0000\"}").
                andReturn(403).
                withHeader(@"Content-Type", @"application/json").
                withBody(@"{\"error\":\"Validation failed: Name can't be blank\"}");

                NSDictionary *tripParameters = @{@"id": @1, @"name": @"", @"start_at": [[NSDate distantFuture] description]};

                communicator.parameters[@"auth_token"] = @"secret";
                [communicator updateTrip: tripParameters];

                expect(communicatorDelegate.error).willNot.beNil();
                expect(communicatorDelegate.trip).will.beNil();
            });
        });
    });

    describe(@"Delete trip", ^{
        context(@"success", ^{
            it(@"should pass the deleted trip to the delegate", ^{
                stubRequest(@"DELETE", @"https://sally-api.tokenize.ca/api/trips/1?auth_token=secret").
                andReturn(200).
                withHeader(@"Content-Type", @"application/json").
                withBody(@"{\"id\":1,\"name\":\"Test 1\",\"start_at\":\"2014-03-25T00:41:21+00:00\"}");

                communicator.parameters[@"auth_token"] = @"secret";
                [communicator deleteTrip: 1];

                expect(communicatorDelegate.trip).willNot.beNil();
                expect(communicatorDelegate.trip[@"id"]).will.equal(1);
                expect(communicatorDelegate.trip[@"name"]).will.equal(@"Test 1");
                expect(communicatorDelegate.trip[@"start_at"]).willNot.beNil();
                expect(communicatorDelegate.error).will.beNil();
            });
        });

        context(@"failure", ^{
            it(@"should notify delegate of error", ^{
                stubRequest(@"DELETE", @"https://sally-api.tokenize.ca/api/trips/1?auth_token=secret").
                andReturn(404).
                withHeader(@"Content-Type", @"application/json").
                withBody(@"{\"error\":\"Trip not found.\"}");

                communicator.parameters[@"auth_token"] = @"secret";
                [communicator deleteTrip: 1];

                expect(communicatorDelegate.error).willNot.beNil();
                expect(communicatorDelegate.trip).will.beNil();
            });
        });
    });

    context(@"Delete location", ^{
        context(@"success", ^{
            it(@"should pass the deleted location to the delegate", ^{
                stubRequest(@"DELETE", @"https://sally-api.tokenize.ca/api/trips/1/locations/2?auth_token=secret").
                andReturn(200).
                withHeader(@"Content-Type", @"application/json").
                withBody(@"{\"id\":2,\"latitude\":\"123456789\",\"longitude\":\"987654321\",\"time\":\"4001-01-01 00:00:00 +0000\"}");

                NSDictionary *locationAttributes = @{@"id": @2, @"trip_id": @1};

                communicator.parameters[@"auth_token"] = @"secret";
                [communicator deleteLocationForTrip: locationAttributes];

                expect(communicatorDelegate.location).willNot.beNil();
                expect(communicatorDelegate.error).will.beNil();
            });
        });

        context(@"failure", ^{
            it(@"should notify delegate of error", ^{
                stubRequest(@"DELETE", @"https://sally-api.tokenize.ca/api/trips/1/locations/2?auth_token=secret").
                andReturn(404).
                withHeader(@"Content-Type", @"application/json").
                withBody(@"{\"error\": \"Location not found\"}");

                NSDictionary *locationAttributes = @{@"id": @2, @"trip_id": @1};

                communicator.parameters[@"auth_token"] = @"secret";
                [communicator deleteLocationForTrip: locationAttributes];

                expect(communicatorDelegate.error).willNot.beNil();
                expect(communicatorDelegate.location).will.beNil();
            });
        });
    });
});

SpecEnd
