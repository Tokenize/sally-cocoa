//
//  SallyCommunicator.h
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
#import "AFHTTPSessionManager.h"

// Forward declarations
@protocol SallyCommunicatorDelegate;

@interface SallyCommunicator : AFHTTPSessionManager

#pragma mark - Properties
@property (nonatomic, weak) id<SallyCommunicatorDelegate>delegate;
@property (nonatomic) NSMutableDictionary *parameters;

#pragma mark - Class Methods
+ (SallyCommunicator *)sharedSallyCommunicator;

#pragma mark - Trip Methods
- (void)fetchTrips;
- (void)createTrip:(NSDictionary *)tripAttributes;
- (void)updateTrip:(NSDictionary *)tripAttributes;
- (void)deleteTrip:(NSUInteger)tripID;

#pragma mark - Location Methods
- (void)fetchLocationsForTrip:(NSUInteger)tripID;
- (void)createLocationForTrip:(NSDictionary *)locationAttributes;
- (void)updateLocationForTrip:(NSDictionary *)locationAttributes;
- (void)deleteLocationForTrip:(NSDictionary *)locationAttributes;

#pragma mark - Authentication Methods
- (void)signInWithEmail:(NSString *)email password:(NSString *)password;

@end
