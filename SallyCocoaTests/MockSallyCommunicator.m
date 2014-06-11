//
//  MockSallyCommunicator.m
//  Sally
//
//  Created by Zaid Al-Jarrah on 2/3/2014.
//  Copyright (c) 2014 Tokenize. All rights reserved.
//

#import "MockSallyCommunicator.h"

@implementation MockSallyCommunicator

@synthesize wasAskedToFetchTrips;
@synthesize wasAskedToFetchLocations;

- (void)fetchTrips
{
    wasAskedToFetchTrips = true;
}

- (void)fetchLocationsForTrip:(NSUInteger)tripID
{
    wasAskedToFetchLocations = true;
}

@end
