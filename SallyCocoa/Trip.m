//
//  Trip.m
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

#import "Trip.h"
#import "Location.h"

NSString * const TripErrorDomain = @"TripErrorDomain";

@implementation Trip
{
    NSMutableArray *locationsList;
}

@synthesize tripId;
@synthesize name;
@synthesize description;
@synthesize startAt;
@synthesize endAt;

- (id)init {
    if (self = [super init]) {
        locationsList = [[NSMutableArray alloc] init];
    }

    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"tripId": @"id",
             @"name": @"name",
             @"description": @"description",
             @"startAt": @"start_at",
             @"endAt": @"end_at"
    };
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];

    return dateFormatter;
}

#pragma mark - Transformers

+ (NSValueTransformer *)startAtJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)endAtJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

#pragma mark - Validations

- (BOOL)validateName:(NSString **)tripName error:(NSError **)error {
    if (*tripName != nil) {
        return YES;
    }
    else {
        if (error != NULL) {
            *error = [NSError errorWithDomain: TripErrorDomain code: TripErrorMissingName userInfo: nil];
        }
        return NO;
    }
}

- (BOOL)validateStartAt:(NSDate **)tripStartAt error:(NSError **)error {
    if (*tripStartAt != nil) {
        return YES;
    }
    else {
        if (error != NULL) {
            *error = [NSError errorWithDomain: TripErrorDomain code: TripErrorMissingStartAt userInfo: nil];
        }
    }
    return NO;
}

- (void)addLocation:(Location *)newLocation
{
    [locationsList addObject: newLocation];
}

- (NSArray *)locations
{
    return locationsList;
}

@end
