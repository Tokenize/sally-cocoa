//
//  MockSallyCommunicator.h
//  Sally
//
//  Created by Zaid Al-Jarrah on 2/3/2014.
//  Copyright (c) 2014 Tokenize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SallyCommunicator.h"

@interface MockSallyCommunicator : SallyCommunicator

@property (readonly) BOOL wasAskedToSignIn;
@property (readonly) BOOL wasAskedToFetchTrips;
@property (readonly) BOOL wasAskedToFetchLocations;

@end
