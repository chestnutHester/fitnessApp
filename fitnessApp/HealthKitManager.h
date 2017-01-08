//
//  HeakthKitManager.h
//  fitnessApp
//
//  Created by Hester Corne on 07/01/2017.
//  Copyright © 2017 Hester Corne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthKitManager : NSObject

+ (HealthKitManager *)sharedManager;

- (void)requestAuthorization;
- (void)readWorkoutOverview;

@end
