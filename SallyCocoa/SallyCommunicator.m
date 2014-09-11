//
//  SallyCommunicator.m
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

#import "SallyCommunicator.h"
#import "SallyCommunicatorDelegate.h"

@implementation SallyCommunicator

@synthesize delegate;
@synthesize parameters;

+ (SallyCommunicator *)sharedSallyCommunicator {
    static SallyCommunicator *_sharedSallyCommunicator = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedSallyCommunicator = [[SallyCommunicator alloc] initWithBaseURL: [NSURL URLWithString: @"https://sally-api.tokenize.ca/api"]];
    });
    
    return _sharedSallyCommunicator;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL: url];
    
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions: NSJSONReadingAllowFragments];
        self.parameters = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)signInWithEmail:(NSString *)email password:(NSString *)password {
    NSMutableDictionary *temporaryParams = [[NSMutableDictionary alloc] initWithDictionary: @{@"email": [email copy], @"password": [password copy]}];
    
    [self GET: @"users/sign_in" parameters:temporaryParams success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.delegate sallyCommunicator: self didSignInWithToken: responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate sallyCommunicator: self signInFailedWithError: error];
    }];
    
    temporaryParams = nil;
}

- (void)fetchTrips {
    [self GET: @"trips" parameters: self.parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.delegate sallyCommunicator: self didFetchTrips: responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate sallyCommunicator: self fetchTripsFailedWithError: error];
    }];
}

- (void)fetchLocationsForTrip:(NSUInteger)tripID {
    NSString  *locationsUrl = [NSString stringWithFormat: @"trips/%lu/locations", (unsigned long)tripID];

    [self GET: locationsUrl parameters: parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.delegate sallyCommunicator: self didFetchLocationsForTrip: responseObject];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate sallyCommunicator: self fetchLocationsForTripFailedWithError: error];
    }];
}

- (void)createTrip:(NSDictionary *)tripAttributes {
    NSMutableDictionary *temporaryParams = [[NSMutableDictionary alloc] initWithDictionary: tripAttributes];
    [temporaryParams addEntriesFromDictionary: self.parameters];
    
    [self POST: @"trips" parameters: temporaryParams success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.delegate sallyCommunicator: self didCreateTrip: responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate sallyCommunicator: self createTripFailedWithError: error];
        
    }];
    
    temporaryParams = nil;
}

- (void)createLocationForTrip:(NSDictionary *)locationAttributes {
    NSString  *locationsUrl = [NSString stringWithFormat: @"trips/%@/locations", locationAttributes[@"trip_id"]];

    NSMutableDictionary *temporaryParams = [[NSMutableDictionary alloc] initWithDictionary: locationAttributes];
    [temporaryParams addEntriesFromDictionary: self.parameters];

    [self POST: locationsUrl parameters: temporaryParams success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.delegate sallyCommunicator: self didCreateLocation: responseObject];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate sallyCommunicator: self createLocationFailedWithError: error];
    }];

    temporaryParams = nil;
}

- (void)updateTrip:(NSDictionary *)tripAttributes {
    NSString  *tripUrl = [NSString stringWithFormat: @"trips/%@", tripAttributes[@"id"]];

    NSMutableDictionary *temporaryParams = [[NSMutableDictionary alloc] initWithDictionary: tripAttributes];
    [temporaryParams addEntriesFromDictionary: self.parameters];

    [self PUT: tripUrl parameters: temporaryParams success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.delegate sallyCommunicator: self didUpdateTrip: responseObject];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate sallyCommunicator: self updateTripFailedWithError: error];
    }];

    temporaryParams = nil;
    tripUrl = nil;
}

- (void)deleteTrip:(NSUInteger)tripID {
    NSString  *tripUrl = [NSString stringWithFormat: @"trips/%lu", (unsigned long)tripID];

    [self DELETE: tripUrl parameters: self.parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.delegate sallyCommunicator: self didDeleteTrip: responseObject];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate sallyCommunicator: self deleteTripFailedWithError: error];
    }];

    tripUrl = nil;
}

- (void)updateLocationForTrip:(NSDictionary *)locationAttributes {
    NSString  *locationsUrl = [NSString stringWithFormat: @"trips/%@/locations/%@", locationAttributes[@"trip_id"], locationAttributes[@"id"]];

    NSMutableDictionary *temporaryParams = [[NSMutableDictionary alloc] initWithDictionary: locationAttributes];
    [temporaryParams addEntriesFromDictionary: self.parameters];

    [self PUT: locationsUrl parameters: temporaryParams success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.delegate sallyCommunicator: self didUpdateLocation: responseObject];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate sallyCommunicator: self updateLocationFailedWithError: error];
    }];

    temporaryParams = nil;
    locationsUrl = nil;
}

- (void)deleteLocationForTrip:(NSDictionary *)locationAttributes {
    NSString  *locationsUrl = [NSString stringWithFormat: @"trips/%@/locations/%@", locationAttributes[@"trip_id"], locationAttributes[@"id"]];

    [self DELETE: locationsUrl parameters: self.parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.delegate sallyCommunicator: self didDeleteLocation: responseObject];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate sallyCommunicator: self deleteLocationFailedWithError: error];
    }];

    locationsUrl = nil;
}

@end
