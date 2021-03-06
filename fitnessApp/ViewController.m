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
    
    //Only return workouts from the last 7 days
    NSDate *today = [NSDate date];
    NSDate *day1 = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                    value:-6
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
                                          NSLog(@"Retrieved the following workouts");
                                          listOfWorkouts = results;
                                          for(HKQuantitySample *samples in results)
                                          {
                                              // your code here
                                              HKWorkout *workout = (HKWorkout *)samples;
                                              NSLog(@"%lu",(unsigned long)workout.endDate);
                                          }
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
        WeekDay *newDay = [[WeekDay alloc] initWithDayOfTheWeek:i];
        [daysOfTheWeek addObject:newDay];
    }
    
    //Add the workouts to the daysOfTheWeek array
    for(HKQuantitySample *samples in workouts){
        //Get the workout's day of the week as an integer
        HKWorkout *workout = (HKWorkout *)samples;
        NSDate *workoutDate = workout.endDate;
        comp = [cal components:NSCalendarUnitWeekday fromDate:workoutDate];
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
        label.text = [self stringFromWeekday:today-1];
        
        if(daysOfTheWeek[today-1].workout){
            UIImageView *image = weekViewList[6-i].image;
            dispatch_async(dispatch_get_main_queue(), ^{
                [image setImage:[UIImage imageNamed:@"completeWeekViewImage.png"]];
            });
        }
        today--;
        if(today ==0){
            today = 7;
        }
    }
}

- (NSString *)stringFromWeekday:(NSInteger)weekday {
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    return dateFormatter.shortWeekdaySymbols[weekday];
}

@end
