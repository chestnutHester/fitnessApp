//
//  HeakthKitManager.m
//  fitnessApp
//
//  Created by Hester Corne on 07/01/2017.
//  Copyright © 2017 Hester Corne. All rights reserved.
//

#import <HealthKit/HealthKit.h>
#import "HealthKitManager.h"

@interface HealthKitManager ()
@property (nonatomic, retain) HKHealthStore *healthStore;
@end


@implementation HealthKitManager

+ (HealthKitManager *)sharedManager {
    static dispatch_once_t pred = 0;
    static HealthKitManager *instance = nil;
    //Create a singleton for the healthStore property
    dispatch_once(&pred, ^{
        instance = [[HealthKitManager alloc] init];
        instance.healthStore = [[HKHealthStore alloc] init];
    });
    return instance;
}

- (void)requestAuthorization {
    
    if ([HKHealthStore isHealthDataAvailable] == NO) {
        // If our device doesn't support HealthKit -> return.
        return;
    }

    NSArray *readTypes = @[[HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth]];
    
    NSArray *writeTypes = @[[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass]];
    
    [self.healthStore requestAuthorizationToShareTypes:[NSSet setWithArray:readTypes]
                                             readTypes:[NSSet setWithArray:writeTypes] completion:nil];
}
- (void)readWorkoutOverview{
    
}
@end
