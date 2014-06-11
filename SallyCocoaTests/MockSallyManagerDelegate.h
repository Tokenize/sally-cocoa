//
//  MockSallyManagerDelegate.h
//  Sally
//
//  Created by Zaid Al-Jarrah on 2/2/2014.
//  Copyright (c) 2014 Tokenize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SallyManagerDelegate.h"

@interface MockSallyManagerDelegate : NSObject <SallyManagerDelegate>

@property (nonatomic) NSError *error;
@property (nonatomic) NSArray *receivedTrips;
@property (nonatomic) NSArray *receivedLocations;
@property (nonatomic) Trip *trip;
@property (nonatomic) Location *location;
@property (nonatomic) NSString *auth_token;

@end
