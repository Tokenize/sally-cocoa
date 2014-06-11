//
//  MockSallyCommunicatorDelegate.m
//  Sally
//
//  Created by Zaid Al-Jarrah on 2014-03-25.
//  Copyright (c) 2014 Tokenize. All rights reserved.
//

#import "MockSallyCommunicatorDelegate.h"

@implementation MockSallyCommunicatorDelegate

@synthesize apiToken;

- (void)sallyCommunicator:(SallyCommunicator *)communicator didSignInWithToken:(NSString *)token {
    self.apiToken = token;
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator signInFailedWithError:(NSError *)error {
    self.error = error;
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator didFetchTrips:(NSArray *)trips {
    self.trips = trips;
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator fetchTripsFailedWithError:(NSError *)error {
    self.error = error;
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator didFetchLocationsForTrip:(NSArray *)locations {
    self.locations = locations;
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator fetchLocationsForTripFailedWithError:(NSError *)error {
    self.error = error;
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator didCreateTrip:(NSDictionary *)trip {
    self.trip = trip;
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator createTripFailedWithError:(NSError *)error {
    self.error = error;
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator didCreateLocation:(NSDictionary *)location {
    self.location = location;
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator createLocationFailedWithError:(NSError *)error {
    self.error = error;
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator didUpdateTrip:(NSDictionary *)trip {
    self.trip = trip;
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator updateTripFailedWithError:(NSError *)error {
    self.error = error;
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator didDeleteTrip:(NSDictionary *)trip {
    self.trip = trip;
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator deleteTripFailedWithError:(NSError *)error {
    self.error = error;
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator didUpdateLocation:(NSDictionary *)location {
    self.location = location;
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator updateLocationFailedWithError:(NSError *)error {
    self.error = error;
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator didDeleteLocation:(NSDictionary *)location {
    self.location = location;
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator deleteLocationFailedWithError:(NSError *)error {
    self.error = error;
}

@end
