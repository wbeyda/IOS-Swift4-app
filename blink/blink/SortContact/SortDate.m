//
//  SortDate.m
//  blink
//
//  Created by Dharmesh Sonani on 13/04/19.
//  Copyright © 2019 Deedcoin Office. All rights reserved.
//

#import "SortDate.h"
#import <CoreTelephony/CoreTelephonyDefines.h>

@implementation SortDate

+(NSArray<APContact *> *)sortContactLast24hours:(NSArray<APContact *>*)contacts
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = -1;
    NSDate *newDate = [calendar dateByAddingComponents:components toDate:date options:0];
    
    NSPredicate *predicate24hours = [NSPredicate predicateWithFormat:@"(recordDate.creationDate <= %@) AND (recordDate.creationDate >= %@)", date, newDate];
    
    NSArray *sorted24hours = [contacts filteredArrayUsingPredicate:predicate24hours];
    
    return sorted24hours;
}

+(NSArray<APContact *> *)sortContactLastWeek:(NSArray<APContact *> *)contacts
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = -1;
    NSDate *newDate = [calendar dateByAddingComponents:components toDate:date options:0];
    
    NSDate *date2 = [NSDate date];
    NSCalendar *calendar2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components2 = [[NSDateComponents alloc] init];
    components2.day = -7;
    NSDate *newDate2 = [calendar2 dateByAddingComponents:components2 toDate:date2 options:0];
    
    NSPredicate *predicateLastWeek = [NSPredicate predicateWithFormat:@"(recordDate.creationDate <= %@) AND (recordDate.creationDate >= %@)", newDate, newDate2];
    
    NSArray *sortedLastWeek = [contacts filteredArrayUsingPredicate:predicateLastWeek];
    
    return sortedLastWeek;
}

+(NSArray<APContact *> *)sortContact:(NSArray<APContact *> *)contacts
{
    NSDate *date2 = [NSDate date];
    NSCalendar *calendar2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components2 = [[NSDateComponents alloc] init];
    components2.day = -7;
    NSDate *newDate2 = [calendar2 dateByAddingComponents:components2 toDate:date2 options:0];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(recordDate.creationDate < %@)", newDate2];
    NSArray *sortedArray = [contacts filteredArrayUsingPredicate:predicate];

    return  sortedArray;
}



@end
