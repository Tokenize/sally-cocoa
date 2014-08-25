//
//  MockSallyCommunicator.m
//  Sally
//
//  Created by Zaid Al-Jarrah on 2/3/2014.
//  Copyright (c) 2014 Tokenize. All rights reserved.
//

#import "MockSallyCommunicator.h"

@implementation MockSallyCommunicator

@synthesize wasAskedToSignIn;
@synthesize wasAskedToFetchTrips;
@synthesize wasAskedToFetchLocations;

- (void)signInWithEmail:(NSString *)email password:(NSString *)password
{
    wasAskedToSignIn = true;
}

- (void)fetchTrips
{
    wasAskedToFetchTrips = true;
}

- (void)fetchLocationsForTrip:(NSUInteger)tripID
{
    wasAskedToFetchLocations = true;
}

@end
