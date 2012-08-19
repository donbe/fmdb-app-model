//
//  AppDbManage.m
//  ttye
//
//  Created by Chu Mohua on 12-8-19.
//
//

#import "AppDbManage.h"

@interface AppDbManage()
{
    FMDatabase *db;
}

@end

@implementation AppDbManage

-(id)initWithDbPath:(NSString *)path{
    self = [super init];
    if (self) {
        db = [FMDatabase databaseWithPath:path];
        if (![db open]){
            NSAssert1(0, @"%@ can not open.", path);
        }
    }
    return self;
}

#pragma mark -
-(NSDictionary *)selectRecordFields:(NSString *)fields
                               from:(NSString *)table
                              where:(id)conditions{
    return [self selectRecordFields:fields from:table where:conditions orderBy:nil];
}

-(NSDictionary *)selectRecordFields:(NSString *)fields
                               from:(NSString *)table
                              where:(id)conditions
                            orderBy:(NSString *)orderBy{
    return [self selectRecordFields:fields from:table where:conditions orderBy:orderBy offset:0];
}

-(NSDictionary *)selectRecordFields:(NSString *)fields
                               from:(NSString *)table
                              where:(id)conditions
                            orderBy:(NSString *)orderBy
                             offset:(int)offset{
    NSArray *result = [self selectRecordsssFields:fields from:table where:conditions groupBy:nil orderBy:orderBy limit:1 offset:offset];
    return [result lastObject];
}

#pragma mark -
-(NSArray *)selectRecordsssFields:(NSString *)fields
                           from:(NSString *)table
                          where:(id)conditions{
    return [self selectRecordsssFields:fields from:table where:conditions limit:0 offset:0];
}

-(NSArray *)selectRecordsssFields:(NSString *)fields
                           from:(NSString *)table
                          where:(id)conditions
                          limit:(int)limit
                         offset:(int)offset{
    return [self selectRecordsssFields:fields from:table where:conditions orderBy:nil limit:limit offset:offset];
}

-(NSArray *)selectRecordsssFields:(NSString *)fields
                           from:(NSString *)table
                          where:(id)conditions
                        orderBy:(NSString *)orderBy{
    return [self selectRecordsssFields:fields from:table where:conditions orderBy:orderBy limit:0 offset:0];
}

-(NSArray *)selectRecordsssFields:(NSString *)fields
                           from:(NSString *)table
                          where:(id)conditions
                        orderBy:(NSString *)orderBy
                          limit:(int)limit
                         offset:(int)offset{
    return [self selectRecordsssFields:fields from:table where:conditions groupBy:nil orderBy:orderBy limit:limit offset:offset];
}


/*
 参数
 fidlds
 id,name,password
 nil 表示所有字段
 table
 cities
 conditions
 1 可以直接使用字符串 "id=1"
 2 可以使用数组 表示id=1 而且id=2
 array("id = 1","id = 1")
 3 可以使用字典 表示id = 1 或者id =2 的记录
 or => array("id = 1","id = 1")
 4 字典和数组一起用
 5 nil 表示无条件
 groupBy
 name,id
 nil 表示不分组
 orderBy
 id asc,name desc
 nil 表示不排序
 limit
 1
 0 表示返回所有记录
 offset
 1
 0 表示从从开始搜索记录
 */
-(NSArray *)selectRecordsssFields:(NSString *)fields
                           from:(NSString *)table
                          where:(id)conditions
                        groupBy:(NSString *)groupBy
                        orderBy:(NSString *)orderBy
                          limit:(int)limit
                         offset:(int)offset{
    fields = fields ? fields : @"*";
    
    NSString *sql = [NSString stringWithFormat:@"select %@ from %@ ",fields, table];
    if (conditions) {
        sql = [sql stringByAppendingFormat:@"where %@ ",[self implodeConditions:conditions joinString:nil]];
    }
    if (groupBy) {
        sql = [sql stringByAppendingFormat:@"group by %@ ",groupBy];
    }
    if (orderBy) {
        sql = [sql stringByAppendingFormat:@"order by %@ ",orderBy];
    }
    if (limit) {
        sql = [sql stringByAppendingFormat:@"limit %d ",limit];
    }
    if (offset) {
        sql = [sql stringByAppendingFormat:@"offset %d ",offset];
    }
    sql = [sql stringByAppendingString:@";"];
    
#ifdef DEBUG
    db.traceExecution = YES;
#endif
    FMResultSet *myWbSet = [db executeQuery:sql];
    if(!myWbSet)
        return nil;
    NSMutableArray *returnArr = [[NSMutableArray alloc] init];
    while ([myWbSet next]) {
        [returnArr addObject:[myWbSet resultDictionary]];
    }
    return returnArr;
}

-(NSString *)implodeConditions:(id)conditions
                    joinString:(NSString *)joinString{
    if (!conditions) {
        return nil;
    }
    
    if ([conditions isKindOfClass:[NSString class]]) {
        return conditions;
    }
    
    joinString = joinString ? joinString : @" and ";
    if ([conditions isKindOfClass:[NSArray class]]) {
        NSMutableArray *tmp = [[NSMutableArray alloc] init];
        for (id obj in conditions) {
            if ([obj isKindOfClass:[NSString class]]) {
                [tmp addObject:obj];
            }else{
                [tmp addObject:[self implodeConditions:obj joinString:nil]];
            }
        }
        return [tmp componentsJoinedByString:joinString];
    }
    
    if ([conditions isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *tmp = [[NSMutableArray alloc] init];
        for (NSString *key in conditions) {
            if (![key isKindOfClass:[NSString class]]) {
                NSAssert(0, @"where param error");
            }
            id value = [conditions objectForKey:key];
            if ([[key lowercaseString] isEqualToString:@"and"] || [[key lowercaseString] isEqualToString:@"or"]) {
                [tmp addObject:[self implodeConditions:value joinString:[NSString stringWithFormat:@" %@ ",key]]];
            }else{
                NSAssert(0, @"where param error");
            }
        }
        return [tmp componentsJoinedByString:joinString];
    }
    
    NSAssert(0, @"where param error");
    return nil;
}

@end
