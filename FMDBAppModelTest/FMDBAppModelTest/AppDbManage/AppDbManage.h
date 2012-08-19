//
//  AppDbManage.h
//  ttye
//
//  Created by Chu Mohua on 12-8-19.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface AppDbManage : NSObject

-(id)initWithDbPath:(NSString *)path;

-(NSDictionary *)selectRecordFields:(NSString *)fields
                               from:(NSString *)table
                              where:(id)conditions;

-(NSDictionary *)selectRecordFields:(NSString *)fields
                               from:(NSString *)table
                              where:(id)conditions
                            orderBy:(NSString *)orderBy;

-(NSDictionary *)selectRecordFields:(NSString *)fields
                               from:(NSString *)table
                              where:(id)conditions
                            orderBy:(NSString *)orderBy
                             offset:(int)offset;

#pragma mark -
-(NSArray *)selectRecordsssFields:(NSString *)fields
                             from:(NSString *)table
                            where:(id)conditions;

-(NSArray *)selectRecordsssFields:(NSString *)fields
                             from:(NSString *)table
                            where:(id)conditions
                            limit:(int)limit
                           offset:(int)offset;

-(NSArray *)selectRecordsssFields:(NSString *)fields
                             from:(NSString *)table
                            where:(id)conditions
                          orderBy:(NSString *)orderBy;

-(NSArray *)selectRecordsssFields:(NSString *)fields
                             from:(NSString *)table
                            where:(id)conditions
                          orderBy:(NSString *)orderBy
                            limit:(int)limit
                           offset:(int)offset;
-(NSArray *)selectRecordsssFields:(NSString *)fields
                             from:(NSString *)table
                            where:(id)conditions
                          groupBy:(NSString *)groupBy
                          orderBy:(NSString *)orderBy
                            limit:(int)limit
                           offset:(int)offset;

@end
