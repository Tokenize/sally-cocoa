//
//  SallyManager.m
//  Sally
//
//  Created by Zaid Al-Jarrah on 2/2/2014.
//  Copyright (c) 2014 Tokenize. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "SallyManager.h"
#import "SallyManagerDelegate.h"
#import "SallyCommunicator.h"
#import "Trip.h"
#import "Location.h"
#import "User.h"

@implementation SallyManager

@synthesize delegate;
@synthesize communicator;
@synthesize user;

NSString *SallyManagerErrors = @"SallyManagerError";

- (void)setDelegate:(id<SallyManagerDelegate>)newDelegate
{
    if (newDelegate && ![newDelegate conformsToProtocol: @protocol(SallyManagerDelegate)]) {
        [[NSException exceptionWithName: NSInvalidArgumentException
                                 reason: @"Delegate does not conform to the SallyManagerDelegate protocol"
                               userInfo: nil] raise];
    }
    
    delegate = newDelegate;
}

#pragma mark - Authentication Methods

- (void)sallyCommunicator:(SallyCommunicator *)communicator didSignInWithToken:(NSString *)token
{
    [self.delegate sallyManager: self didSignInWithToken: token];
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator signInFailedWithError:(NSError *)error
{
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObject: error forKey: NSUnderlyingErrorKey];
    NSError *reportableError = [NSError errorWithDomain: SallyManagerErrors code: SallyManagerErrorSignIn userInfo: errorInfo];

    [self.delegate sallyManager: self signInFailedWithError: reportableError];
}

#pragma mark - Trip Methods

- (void)fetchTrips
{
    [communicator fetchTrips];
}

- (void)createTrip:(Trip *)trip
{
    NSDictionary *tripParameters = [MTLJSONAdapter JSONDictionaryFromModel: trip];

    [self.communicator createTrip: tripParameters];
}

#pragma mark -

- (void)sallyCommunicator:(SallyCommunicator *)communicator didFetchTrips:(NSArray *)trips
{
    NSValueTransformer *tripsTransformer = [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass: Trip.class];

    [self.delegate sallyManager: self didFetchTrips: [tripsTransformer transformedValue: trips]];
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator fetchTripsFailedWithError:(NSError *)error
{
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObject: error forKey: NSUnderlyingErrorKey];
    NSError *reportableError = [NSError errorWithDomain: SallyManagerErrors code: SallyManagerErrorTripFetchCode userInfo: errorInfo];

    [self.delegate sallyManager: self fetchTripsFailedWithError: reportableError];
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator didCreateTrip:(NSDictionary *)tripJSON
{
    Trip *trip = [MTLJSONAdapter modelOfClass: Trip.class fromJSONDictionary: tripJSON error: nil];

    [self.delegate sallyManager: self didCreateTrip: trip];
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator createTripFailedWithError:(NSError *)error
{
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObject: error forKey: NSUnderlyingErrorKey];
    NSError *reportableError = [NSError errorWithDomain: SallyManagerErrors code: SallyManagerErrorCreateTrip userInfo: errorInfo];

    [self.delegate sallyManager: self createTripFailedWithError: reportableError];
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator didUpdateTrip:(NSDictionary *)tripJSON
{
    Trip *trip = [MTLJSONAdapter modelOfClass: Trip.class fromJSONDictionary: tripJSON error: nil];

    [self.delegate sallyManager: self didUpdateTrip: trip];
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator updateTripFailedWithError:(NSError *)error
{
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObject: error forKey: NSUnderlyingErrorKey];
    NSError *reportableError = [NSError errorWithDomain: SallyManagerErrors code: SallyManagerErrorUpdateTrip userInfo: errorInfo];

    [self.delegate sallyManager: self updateTripFailedWithError: reportableError];
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator didCreateLocation:(NSDictionary *)locationJSON
{
    Location *location = [MTLJSONAdapter modelOfClass: Location.class fromJSONDictionary: locationJSON error: nil];

    [self.delegate sallyManager: self didCreateLocation: location];
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator didDeleteTrip:(NSDictionary *)tripJSON
{
    Trip *trip = [MTLJSONAdapter modelOfClass: Trip.class fromJSONDictionary: tripJSON error: nil];

    [self.delegate sallyManager: self didDeleteTrip: trip];
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator deleteTripFailedWithError:(NSError *)error
{
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObject: error forKey: NSUnderlyingErrorKey];
    NSError *reportableError = [NSError errorWithDomain: SallyManagerErrors code: SallyManagerErrorDeleteTrip userInfo: errorInfo];

    [self.delegate sallyManager: self deleteTripFailedWithError: reportableError];
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator createLocationFailedWithError:(NSError *)error
{
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObject: error forKey: NSUnderlyingErrorKey];
    NSError *reportableError = [NSError errorWithDomain: SallyManagerErrors code: SallyManagerErrorCreateLocation userInfo: errorInfo];

    [self.delegate sallyManager: self createLocationFailedWithError: reportableError];
}

- (void)fetchLocationsForTrip:(NSUInteger)tripID
{
    [communicator fetchLocationsForTrip: tripID];
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator didFetchLocationsForTrip:(NSArray *)locations
{
    NSValueTransformer *locationsTransformer = [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass: Location.class];

    [self.delegate sallyManager: self didFetchLocationsForTrip: [locationsTransformer transformedValue: locations]];
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator fetchLocationsForTripFailedWithError:(NSError *)error
{
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObject: error forKey: NSUnderlyingErrorKey];
    NSError *reportableError = [NSError errorWithDomain: SallyManagerErrors code: SallyManagerErrorLocationFetchCode userInfo: errorInfo];

    [delegate sallyManager: self fetchLocationsForTripFailedWithError: reportableError];
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator didUpdateLocation:(NSDictionary *)locationJSON
{
    Location *location = [MTLJSONAdapter modelOfClass: Location.class fromJSONDictionary: locationJSON error: nil];

    [self.delegate sallyManager: self didUpdateLocation: location];
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator updateLocationFailedWithError:(NSError *)error
{
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObject: error forKey: NSUnderlyingErrorKey];
    NSError *reportableError = [NSError errorWithDomain: SallyManagerErrors code: SallyManagerErrorUpdateLocation userInfo: errorInfo];

    [self.delegate sallyManager: self updateLocationFailedWithError: reportableError];
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator didDeleteLocation:(NSDictionary *)locationJSON
{
    Location *location = [MTLJSONAdapter modelOfClass: Location.class fromJSONDictionary: locationJSON error: nil];

    [self.delegate sallyManager: self didDeleteLocation: location];
}

- (void)sallyCommunicator:(SallyCommunicator *)communicator deleteLocationFailedWithError:(NSError *)error
{
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObject: error forKey: NSUnderlyingErrorKey];
    NSError *reportableError = [NSError errorWithDomain: SallyManagerErrors code: SallyManagerErrorDeleteLocation userInfo: errorInfo];

    [self.delegate sallyManager: self deleteLocationFailedWithError: reportableError];
}

@end


