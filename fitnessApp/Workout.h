//
//  Workout.h
//  fitnessApp
//
//  Created by Hester Corne on 30/01/2017.
//  Copyright © 2017 Hester Corne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Workout : NSObject
@property(strong,nonatomic) NSDate *startDate;
@property(strong,nonatomic) NSDate *endDate;
@property NSTimeInterval duration;
@property int workoutType;
@property double totalDistance;
@property double totaEnergyBurned;
@property(strong,nonatomic) NSArray *heartRateData;

-(Workout*)initWithRecord:(NSDate*)startDate :(NSDate*)endDate :(NSTimeInterval)duration :(int)workoutType :(double)totalDistance :(double)totalEnergyBurned :(NSArray*)heartRateData;
@end
