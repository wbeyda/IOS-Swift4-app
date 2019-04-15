//
//  SortDate.h
//  blink
//
//  Created by Dharmesh Sonani on 13/04/19.
//  Copyright © 2019 Deedcoin Office. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APContact.h"

NS_ASSUME_NONNULL_BEGIN

@interface SortDate : NSObject

+(NSArray<APContact *> *)sortContactLast24hours:(NSArray<APContact *>*)contacts;
+(NSArray<APContact *> *)sortContactLastWeek:(NSArray<APContact *>*)contacts;
+(NSArray<APContact *> *)sortContact:(NSArray<APContact *>*)contacts;
@end

NS_ASSUME_NONNULL_END
