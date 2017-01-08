//
//  WeekDay.m
//  fitnessApp
//
//  Created by Hester Corne on 08/01/2017.
//  Copyright © 2017 Hester Corne. All rights reserved.
//

#import "WeekDay.h"

@implementation WeekDay
-(WeekDay*)initWithDayOfTheWeek:(int)dayOfTheWeek{
    self = [super init];
    _dayOfTheWeek = dayOfTheWeek;
    _workout = NO;
    return self;
}
@end

