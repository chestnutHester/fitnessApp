//
//  Workout.m
//  fitnessApp
//
//  Created by Hester Corne on 30/01/2017.
//  Copyright © 2017 Hester Corne. All rights reserved.
//

#import "Workout.h"

@implementation Workout
-(Workout*)initWithRecord:(NSDate *)startDate :(NSDate *)endDate :(NSTimeInterval)duration :(int)workoutType :(double)totalDistance :(double)totalEnergyBurned :(NSArray *)heartRateData{
    self = [super init];
    _startDate = startDate;
    _endDate = endDate;
    _duration = duration;
    _workoutType = workoutType;
    _totalDistance = totalDistance;
    _totaEnergyBurned = totalEnergyBurned;
    _heartRateData = heartRateData;
    return self;
}
@end
