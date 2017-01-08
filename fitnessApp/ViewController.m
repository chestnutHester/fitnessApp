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
    
    
    //need to make sure healthkit data has been retrieved first
    [self setWeekView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setWeekView{
    //Get the day of the week
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger dayInt = [comp weekday]; // 1 = Sunday, 2 = Monday, etc.
    
    switch(dayInt){
        case 1:
            _day1Label.text = @"Mon";
            _day2Label.text = @"Tue";
            _day3Label.text = @"Wed";
            _day4Label.text = @"Thu";
            _day5Label.text = @"Fri";
            _day6Label.text = @"Sat";
            _day7Label.text = @"Sun";
            break;
        case 2:
            _day1Label.text = @"Tue";
            _day2Label.text = @"Wed";
            _day3Label.text = @"Thu";
            _day4Label.text = @"Fri";
            _day5Label.text = @"Sat";
            _day6Label.text = @"Sun";
            _day7Label.text = @"Mon";
            break;
        case 3:
            _day1Label.text = @"Wed";
            _day2Label.text = @"Thu";
            _day3Label.text = @"Fri";
            _day4Label.text = @"Sat";
            _day5Label.text = @"Sun";
            _day6Label.text = @"Mon";
            _day7Label.text = @"Tue";
            break;
        case 4:
            _day1Label.text = @"Thu";
            _day2Label.text = @"Fri";
            _day3Label.text = @"Sat";
            _day4Label.text = @"Sun";
            _day5Label.text = @"Mon";
            _day6Label.text = @"Tue";
            _day7Label.text = @"Wed";
            break;
        case 5:
            _day1Label.text = @"Fri";
            _day2Label.text = @"Sat";
            _day3Label.text = @"Sun";
            _day4Label.text = @"Mon";
            _day5Label.text = @"Tue";
            _day6Label.text = @"Wed";
            _day7Label.text = @"Thu";
            break;
        case 6:
            _day1Label.text = @"Sat";
            _day2Label.text = @"Sun";
            _day3Label.text = @"Mon";
            _day4Label.text = @"Tue";
            _day5Label.text = @"Wed";
            _day6Label.text = @"Thu";
            _day7Label.text = @"Fri";
            break;
        case 7:
            _day1Label.text = @"Sun";
            _day2Label.text = @"Mon";
            _day3Label.text = @"Tue";
            _day4Label.text = @"Wed";
            _day5Label.text = @"Thu";
            _day6Label.text = @"Fri";
            _day7Label.text = @"Sat";
            break;
    }
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
    NSArray *readTypes = @[[HKObjectType workoutType]];
    NSArray *writeTypes = @[[HKObjectType workoutType]];
    [hs requestAuthorizationToShareTypes:[NSSet setWithArray:writeTypes] readTypes:[NSSet setWithArray:readTypes] completion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"Erro authorizing: %@", [error description]);
        }
    }];
    return hs;
}

-(NSArray*)fetchWorkouts{
    __block NSArray *listOfWorkouts = nil;
    
    //read workouts of 30mins or more
    NSPredicate *predicate = [HKQuery predicateForWorkoutsWithOperatorType:NSGreaterThanPredicateOperatorType duration:1800];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:HKSampleSortIdentifierStartDate ascending:false];
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:[HKWorkoutType workoutType]
                                                                 predicate:predicate
                                                                     limit:HKObjectQueryNoLimit
                                                           sortDescriptors:@[sortDescriptor]
                                                            resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error)
                                  {
                                      
                                      if(!error && results){
                                          NSLog(@"Retrieved the following workouts");
                                          listOfWorkouts = results;
                                          for(HKQuantitySample *samples in results)
                                          {
                                              // your code here
                                              HKWorkout *workout = (HKWorkout *)samples;
                                              NSLog(@"%lu",(unsigned long)workout.workoutActivityType);
                                          }
                                      }else{
                                          NSLog(@"Error retrieving workouts %@",error);
                                      }
                                  }];
    [_healthStore executeQuery:sampleQuery];
    return listOfWorkouts;
}

@end
