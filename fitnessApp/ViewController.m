//
//  ViewController.m
//  fitnessApp
//
//  Created by Hester Corne on 05/01/2017.
//  Copyright © 2017 Hester Corne. All rights reserved.
//

#import "ViewController.h"
#import <HealthKit/HealthKit.h>

@interface ViewController ()
@property (strong,nonatomic) HKHealthStore *healthStore;
@property (strong,nonatomic) NSArray *workoutList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loadOverviewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadOverviewData{
    _healthStore = [self enableHealthStore];
    _workoutList = [self fetchWorkouts];
}

-(HKHealthStore*)enableHealthStore{
    HKHealthStore *hs = [[HKHealthStore alloc] init];
    if(![HKHealthStore isHealthDataAvailable]){
        NSLog(@"Health data not available");
        return nil;
    }
    NSArray *readTypes = @[[HKObjectType workoutType],[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate]];
    NSArray *writeTypes = @[[HKObjectType workoutType]];
    [hs requestAuthorizationToShareTypes:[NSSet setWithArray:writeTypes] readTypes:[NSSet setWithArray:readTypes] completion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"Error authorizing: %@", [error description]);
        }
    }];
    return hs;
}

-(NSArray*)fetchWorkouts{
    __block NSArray *listOfWorkouts = nil;
    
    //Only return workouts from the last 7 days
    NSDate *today = [NSDate date];
    NSDate *day1 = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                    value:-7
                                                                   toDate:today
                                                                  options:0];
    
    NSPredicate *thisWeekPredicate = [HKQuery predicateForSamplesWithStartDate:day1 endDate:today options:HKQueryOptionNone];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:HKSampleSortIdentifierStartDate ascending:false];
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:[HKWorkoutType workoutType]
                                                                 predicate:thisWeekPredicate
                                                                     limit:HKObjectQueryNoLimit
                                                           sortDescriptors:@[sortDescriptor]
                                                            resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error)
                                  {
                                      
                                      if(!error && results){
                                          listOfWorkouts = results;
                                          [self setWeekView:listOfWorkouts];
                                      }else{
                                          NSLog(@"Error retrieving workouts %@",error);
                                      }
                                  }];
    [_healthStore executeQuery:sampleQuery];
    return listOfWorkouts;
}

-(void)setWeekView:(NSArray *)workouts{
    //Get the today's day of the week as an integer
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    int today = (int)[comp weekday]; // 1 = Sunday, 2 = Monday, etc.
   
    //Set an array with days of the week
    NSMutableArray<WeekDay *> *daysOfTheWeek = [NSMutableArray array];
    for(int i = 1; i<8; i++){
        WeekDay *newDay = [[WeekDay alloc] initWithDayOfTheWeek:i]; ///<-- should it be i-1?
        [daysOfTheWeek addObject:newDay];
    }
    
    //Set an array for today's workouts
    NSMutableArray<HKWorkout*> *todaysWorkouts = [NSMutableArray array];
    
    //Add the workouts to the daysOfTheWeek array
    for(HKQuantitySample *samples in workouts){
        //Get the workout's day of the week as an integer
        HKWorkout *workout = (HKWorkout *)samples;
        NSDate *workoutDateAndTime = workout.endDate;
        
        //If the workout was today add it to todaysWorkouts
        unsigned unitFlags = (NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear);
        NSDateComponents *workoutDateComponents = [cal components:unitFlags fromDate:workoutDateAndTime];
        NSDateComponents *todayComponents = [cal components:unitFlags fromDate:[NSDate date]];
        NSDate *workoutDateOnly = [cal dateFromComponents:workoutDateComponents];
        NSDate *todayDateOnly = [cal dateFromComponents:todayComponents];
        
        NSComparisonResult result = [workoutDateOnly compare:todayDateOnly];
        if (result == NSOrderedSame) {
            [todaysWorkouts addObject:workout];
        }
        
        comp = [cal components:NSCalendarUnitWeekday fromDate:workoutDateAndTime];
        int workoutDay = (int)[comp weekday];
        
        //Add the workout to daysOfTheWeek
        for(int i=0; i<daysOfTheWeek.count; i++){
            WeekDay *currentDay = daysOfTheWeek[i];
           if(currentDay.dayOfTheWeek == workoutDay){
               [currentDay setWorkout:YES];
           }
        }
    }
    
    //Set an array for the labels and images of the week view bar
    WeekViewItem *item1 = [[WeekViewItem alloc] initWithLabel:_day1Label image:_day1Image];
    WeekViewItem *item2 = [[WeekViewItem alloc] initWithLabel:_day2Label image:_day2Image];
    WeekViewItem *item3 = [[WeekViewItem alloc] initWithLabel:_day3Label image:_day3Image];
    WeekViewItem *item4 = [[WeekViewItem alloc] initWithLabel:_day4Label image:_day4Image];
    WeekViewItem *item5 = [[WeekViewItem alloc] initWithLabel:_day5Label image:_day5Image];
    WeekViewItem *item6 = [[WeekViewItem alloc] initWithLabel:_day6Label image:_day6Image];
    WeekViewItem *item7 = [[WeekViewItem alloc] initWithLabel:_day7Label image:_day7Image];
    NSArray<WeekViewItem *> *weekViewList = @[item1,item2,item3,item4,item5,item6,item7];
    
    //Set the items in weekViewList based on daysOfTheWeek          //today = day of the week starting 1
    for(int i=0; i<7; i++){
        UILabel *label = weekViewList[6-i].label;
        dispatch_async(dispatch_get_main_queue(), ^{
            label.text = [self stringFromWeekday:today-1 format:@"short"];
            if(daysOfTheWeek[today-1].workout){
                UIImageView *image = weekViewList[6-i].image;
                [image setImage:[UIImage imageNamed:@"completeWeekViewImage.png"]];
            }
        });
        today--;
        if(today ==0){
            today = 7;
        }
    }
    
    //Show today's workout(s)
    [self setWorkoutView:todaysWorkouts];
}

- (NSString *)stringFromWeekday:(NSInteger)weekday format:(NSString*)format {
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_UK"];
    if([format isEqualToString:@"short"]){
        return dateFormatter.shortWeekdaySymbols[weekday];
    }
    else{
        return dateFormatter.weekdaySymbols[weekday];
    }
}

- (void)setWorkoutView:(NSArray<HKWorkout*>*)workouts{
    //Get todays day of the week
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    int weekdayInt = (int)[comp weekday]; // 1 = Sunday, 2 = Monday, etc.
    NSString *weekdayString = [[self stringFromWeekday:weekdayInt-1 format:@"long"]stringByAppendingString:@" "];
    
    //Get todays date of the month
    comp = [cal components:NSCalendarUnitDay fromDate:[NSDate date]];
    int dayInt = (int)[comp day];
    NSString *dayString = [NSString stringWithFormat: @"%ld", (long)dayInt];
    
    switch(dayInt){
        case 1:
        case 21:
        case 31:
            dayString = [dayString stringByAppendingString:@"st "];
            break;
        case 2:
        case 22:
            dayString = [dayString stringByAppendingString:@"nd "];
            break;
        case 3:
        case 23:
            dayString = [dayString stringByAppendingString:@"rd "];
            break;
        default:
            dayString = [dayString stringByAppendingString:@"th "];
            break;
    }

    //Get todays month
    comp = [cal components:NSCalendarUnitMonth fromDate:[NSDate date]];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_UK"];
    int monthInt = (int)[comp month];
    NSString *monthString = dateFormatter.shortMonthSymbols[monthInt-1];
    
    //Set today label
    dispatch_async(dispatch_get_main_queue(), ^{
        _todayLabel.text=[@"Today: " stringByAppendingString:[weekdayString stringByAppendingString:[dayString stringByAppendingString:monthString]]];
    });
    
    //if no workout, display nothing
    if(workouts == nil){
        dispatch_async(dispatch_get_main_queue(), ^{
            _workoutTypeLabel.text=@"No workouts";
        });
    }
    else{
        //Display every workout for the day <----- Need to do a scroll view
        for(int i=0; i<workouts.count; i++){
            HKWorkout *workout = workouts[i];
            NSLog(@"Workout: %lu", (unsigned long)workout.workoutActivityType);
            NSDate *startTime = workout.startDate;
            NSDate *endTime = workout.endDate;
            
            //Get start time in hours and minutes
            NSDateComponents *timeComponent = [cal components:(NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:startTime];
            NSInteger startHour = [timeComponent hour];
            NSInteger startMinute = [timeComponent minute];
            NSString *startMinuteString = [NSString stringWithFormat: @"%ld", (long)startMinute];
            if(startMinute <10){
                startMinuteString = [@"0" stringByAppendingString:startMinuteString];
            }
            NSString *startTimeString = [NSString stringWithFormat: @"%ld", (long)startHour];
            startTimeString = [startTimeString stringByAppendingString:@":"];
            startTimeString = [startTimeString stringByAppendingString:startMinuteString];
            NSLog(@"%@", startTimeString);
            
            //Get total distance
            double totalDistance = [workout.totalDistance doubleValueForUnit:[HKUnit meterUnit]];
            NSLog(@"Total Distance: %ld",(long)totalDistance);
            NSString *distanceString = @"Total Distance: ";
            
            //Get total energy burned
            double totalEnergy = [workout.totalEnergyBurned doubleValueForUnit:[HKUnit kilocalorieUnit]];
            NSLog(@"Total Calories: %ld",(long)totalEnergy);
            NSString *energyString = [NSString stringWithFormat:@"%ld", (long)totalEnergy];
            
            //Get workout duration
            NSTimeInterval duration = workout.duration;
            NSLog(@"Duration: %f", duration);
            NSInteger durationMinutes = (int)round(duration/60);
            NSInteger durationSeconds = (int)round(duration-durationMinutes*60);
            NSString *durationString = [NSString stringWithFormat:@"%ld", (long)durationSeconds];
            if(durationSeconds < 10){
                durationString = [@"0" stringByAppendingString:durationString];
            }
            durationString = [[[NSString stringWithFormat:@"%ld", (long)durationMinutes] stringByAppendingString:@":"]stringByAppendingString:durationString];
            
            //Get workout type as a string
            HKWorkoutActivityType workoutType = workout.workoutActivityType;
            NSString *workoutString = @"";
            
            NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
            [fmt setPositiveFormat:@"0.##"];
            
           
            switch(workoutType){
                case 52:
                    workoutString = @"Walk: ";
                    //Display distance in km
                    totalDistance = round(totalDistance)/1000;
                    distanceString = [distanceString stringByAppendingString:[fmt stringFromNumber:[NSNumber numberWithFloat:totalDistance]]];
                    distanceString = [distanceString stringByAppendingString:@"km"];
                    break;
                case 46:
                    workoutString = @"Swim: ";
                    //Display distacne in lengths
                    totalDistance = round(totalDistance/25);
                    distanceString = [distanceString stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)totalDistance]];
                    distanceString = [distanceString stringByAppendingString:@" Lengths"];
                    break;
                case 37:
                    workoutString = @"Run: ";
                    //Display distance in km
                    totalDistance = round(totalDistance)/1000;
                    distanceString = [distanceString stringByAppendingString:[fmt stringFromNumber:[NSNumber numberWithFloat:totalDistance]]];
                    distanceString = [distanceString stringByAppendingString:@"km"];
                default:
                    break;
            }
            
            NSLog(@"Total Distance: %f",totalDistance);
            
            //Set the workout data
            dispatch_async(dispatch_get_main_queue(), ^{
                _workoutTypeLabel.text=[workoutString stringByAppendingString:startTimeString];
                _parameter1Label.text = distanceString;
                _parameter2Label.text = [[@"Total Engergy: " stringByAppendingString:energyString] stringByAppendingString:@"kcal"];
                _parameter3Label.text = [@"Duration: " stringByAppendingString:durationString];
            });
            
            //Get the heart rate data
            NSPredicate *heartRatePredicate = [HKQuery predicateForSamplesWithStartDate:startTime endDate:endTime options:HKQueryOptionNone];
            
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:HKSampleSortIdentifierStartDate ascending:false];
            HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:[HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate]
                                                                         predicate:heartRatePredicate
                                                                             limit:HKObjectQueryNoLimit
                                                                   sortDescriptors:@[sortDescriptor]
                                                                    resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error)
                                          {
                                              
                                              if(!error && results){
                                                  NSLog(@"Success!");
                                                  
                                                  [self displayHeartRate:results];
                                              }else{
                                                  NSLog(@"Error retrieving heart rate %@",error);
                                              }
                                          }];
            [_healthStore executeQuery:sampleQuery];
        }
    }
}

-(void)displayHeartRate:(NSArray *)heartRateSamples{
    double avgHR = 0;
    double peakHR = 0;
    for(HKQuantitySample *sample in heartRateSamples){
        double hr = [sample.quantity doubleValueForUnit:[[HKUnit countUnit] unitDividedByUnit:[HKUnit minuteUnit]]];
        if(hr>peakHR){
            peakHR = hr;
        }
        avgHR += hr;
    }
    avgHR = avgHR/heartRateSamples.count;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _parameter4Label.text = [@"Average Heart Rate: " stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)avgHR]];
        _parameter5Label.text = [@"Peak Heart Rate: " stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)peakHR]];
        
        //Create an instance of HeartRateView (with axes)
        HeartRateView *hrView = _heartRateView;
        //Plot the heeart rate
        [hrView plotHeartRate:heartRateSamples];
    });
}
@end
