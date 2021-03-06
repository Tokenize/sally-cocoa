//
//  Location.m
//  Sally
//
//  Created by Zaid Al-Jarrah on 1/28/2014.
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

#import "Location.h"

@implementation Location

@synthesize locationId;
@synthesize time;
@synthesize travelDirection;
@synthesize latitude;
@synthesize longitude;
@synthesize travelSpeed;

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"locationId": @"id",
             @"tripId": @"trip_id",
             @"time": @"time",
             @"travelDirection": @"direction",
             @"latitude": @"latitude",
             @"longitude": @"longitude",
             @"travelSpeed": @"speed"
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

+ (NSValueTransformer *)timeJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

@end