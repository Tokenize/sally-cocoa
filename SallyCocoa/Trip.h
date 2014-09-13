//
//  Trip.h
//  Sally
//
//  Created by Zaid Al-Jarrah on 1/27/2014.
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
#import "Mantle.h"

// Forward Declarations
@class Location;

@interface Trip : MTLModel <MTLJSONSerializing>

extern NSString * const TripErrorDomain;

enum {
    TripErrorMissingName,
    TripErrorMissingStartAt,
};

@property NSUInteger tripId;
@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSString *description;
@property (readonly, nonatomic) NSDate *startAt;
@property (readonly, nonatomic) NSDate *endAt;
@property (readonly, nonatomic) NSArray *locations;

- (void)addLocation:(Location *)newLocation;

@end
