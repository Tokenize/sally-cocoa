//
//  SallyManagerDelegate.h
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

#import <Foundation/Foundation.h>

// Forward Declarations
@class Trip;
@class Location;
@class SallyManager;

@protocol SallyManagerDelegate <NSObject>

- (void)sallyManager:(SallyManager *)manager didSignInWithToken:(NSString *)token;
- (void)sallyManager:(SallyManager *)manager signInFailedWithError:(NSError *)error;
- (void)sallyManager:(SallyManager *)manager didFetchTrips:(NSArray *)trips;
- (void)sallyManager:(SallyManager *)manager fetchTripsFailedWithError:(NSError *)error;
- (void)sallyManager:(SallyManager *)manager didCreateTrip:(Trip *)trip;
- (void)sallyManager:(SallyManager *)manager createTripFailedWithError:(NSError *)error;
- (void)sallyManager:(SallyManager *)manager didUpdateTrip:(Trip *)trip;
- (void)sallyManager:(SallyManager *)manager updateTripFailedWithError:(NSError *)error;
- (void)sallyManager:(SallyManager *)manager didDeleteTrip:(Trip *)trip;
- (void)sallyManager:(SallyManager *)manager deleteTripFailedWithError:(NSError *)error;
- (void)sallyManager:(SallyManager *)manager didFetchLocationsForTrip:(NSArray *)locations;
- (void)sallyManager:(SallyManager *)manager fetchLocationsForTripFailedWithError:(NSError *)error;
- (void)sallyManager:(SallyManager *)manager didCreateLocation:(Location *)location;
- (void)sallyManager:(SallyManager *)manager createLocationFailedWithError:(NSError *)error;
- (void)sallyManager:(SallyManager *)manager didUpdateLocation:(Location *)location;
- (void)sallyManager:(SallyManager *)manager updateLocationFailedWithError:(NSError *)error;
- (void)sallyManager:(SallyManager *)manager didDeleteLocation:(Location *)location;
- (void)sallyManager:(SallyManager *)manager deleteLocationFailedWithError:(NSError *)error;

@end
