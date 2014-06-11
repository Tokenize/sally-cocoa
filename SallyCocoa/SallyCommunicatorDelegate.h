//
//  SallyCommunicatorDelegate.h
//  Sally
//
//  Created by Zaid Al-Jarrah on 2014-03-17.
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

#import <Foundation/Foundation.h>

// Forward Declarations
@class SallyCommunicator;

@protocol SallyCommunicatorDelegate <NSObject>

- (void)sallyCommunicator:(SallyCommunicator *)communicator didSignInWithToken:(NSString *)token;
- (void)sallyCommunicator:(SallyCommunicator *)communicator signInFailedWithError:(NSError *)error;
- (void)sallyCommunicator:(SallyCommunicator *)communicator didFetchTrips:(NSArray *)trips;
- (void)sallyCommunicator:(SallyCommunicator *)communicator fetchTripsFailedWithError:(NSError *)error;
- (void)sallyCommunicator:(SallyCommunicator *)communicator didFetchLocationsForTrip:(NSArray *)locations;
- (void)sallyCommunicator:(SallyCommunicator *)communicator fetchLocationsForTripFailedWithError:(NSError *)error;
- (void)sallyCommunicator:(SallyCommunicator *)communicator didCreateTrip:(NSDictionary *)trip;
- (void)sallyCommunicator:(SallyCommunicator *)communicator createTripFailedWithError:(NSError *)error;
- (void)sallyCommunicator:(SallyCommunicator *)communicator didCreateLocation:(NSDictionary *)location;
- (void)sallyCommunicator:(SallyCommunicator *)communicator createLocationFailedWithError:(NSError *)error;
- (void)sallyCommunicator:(SallyCommunicator *)communicator didUpdateTrip:(NSDictionary *)trip;
- (void)sallyCommunicator:(SallyCommunicator *)communicator updateTripFailedWithError:(NSError *)error;
- (void)sallyCommunicator:(SallyCommunicator *)communicator didDeleteTrip:(NSDictionary *)trip;
- (void)sallyCommunicator:(SallyCommunicator *)communicator deleteTripFailedWithError:(NSError *)error;
- (void)sallyCommunicator:(SallyCommunicator *)communicator didUpdateLocation:(NSDictionary *)location;
- (void)sallyCommunicator:(SallyCommunicator *)communicator updateLocationFailedWithError:(NSError *)error;
- (void)sallyCommunicator:(SallyCommunicator *)communicator didDeleteLocation:(NSDictionary *)location;
- (void)sallyCommunicator:(SallyCommunicator *)communicator deleteLocationFailedWithError:(NSError *)error;

@end
