//
//  MockSallyManagerDelegate.m
//  Sally
//
//  Created by Zaid Al-Jarrah on 2/2/2014.
//  Copyright (c) 2014 Tokenize. All rights reserved.
//

#import "MockSallyManagerDelegate.h"

@implementation MockSallyManagerDelegate

@synthesize error;
@synthesize receivedTrips;
@synthesize receivedLocations;
@synthesize trip;
@synthesize auth_token;

- (void)sallyManager:(SallyManager *)manager didSignInWithToken:(NSString *)token
{
    self.auth_token = token;
}

- (void)sallyManager:(SallyManager *)manager signInFailedWithError:(NSError *)signInError
{
    self.error = signInError;
}

- (void)sallyManager:(SallyManager *)manager didFetchTrips:(NSArray *)trips
{
    self.receivedTrips = trips;
}

- (void)sallyManager:(SallyManager *)manager fetchTripsFailedWithError:(NSError *)fetchError
{
    self.error = fetchError;
}

- (void)sallyManager:(SallyManager *)manager fetchLocationsForTripFailedWithError:(NSError *)fetchError
{
    self.error = fetchError;
}

- (void)sallyManager:(SallyManager *)manager didFetchLocationsForTrip:(NSArray *)locations
{
    self.receivedLocations = locations;
}

- (void)sallyManager:(id)manager didCreateTrip:(Trip *)createdTrip
{
    self.trip = createdTrip;
}

- (void)sallyManager:(id)manager createTripFailedWithError:(NSError *)createError
{
    self.error = createError;
}

- (void)sallyManager:(SallyManager *)manager didCreateLocation:(Location *)createdLocation
{
    self.location = createdLocation;
}

- (void)sallyManager:(SallyManager *)manager createLocationFailedWithError:(NSError *)createError
{
    self.error = createError;
}

- (void)sallyManager:(SallyManager *)manager didUpdateTrip:(Trip *)updatedTrip
{
    self.trip = updatedTrip;
}

- (void)sallyManager:(SallyManager *)manager updateTripFailedWithError:(NSError *)updateError
{
    self.error = updateError;
}

- (void)sallyManager:(SallyManager *)manager didDeleteTrip:(Trip *)deletedTrip
{
    self.trip = deletedTrip;
}

- (void)sallyManager:(SallyManager *)manager deleteTripFailedWithError:(NSError *)deleteError
{
    self.error = deleteError;
}

- (void)sallyManager:(SallyManager *)manager didUpdateLocation:(Location *)updatedLocation
{
    self.location = updatedLocation;
}

- (void)sallyManager:(SallyManager *)manager updateLocationFailedWithError:(NSError *)updateError
{
    self.error = updateError;
}

- (void)sallyManager:(SallyManager *)manager didDeleteLocation:(Location *)deletedLocation
{
    self.location = deletedLocation;
}

- (void)sallyManager:(SallyManager *)manager deleteLocationFailedWithError:(NSError *)deleteError
{
    self.error = deleteError;
}

@end
