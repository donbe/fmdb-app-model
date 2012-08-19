//
//  LocalDbManageTest.m
//  ttye
//
//  Created by Chu Mohua on 12-8-19.
//
//

static NSString *citiesTableName =@"cities";

#import <GHUnitIOS/GHUnit.h>
#import "AppDbManage.h"

@interface LocalDbManageTest : GHTestCase {
    AppDbManage *manage;
}

@end


@implementation LocalDbManageTest

-(void)setUpClass{
    manage = [[AppDbManage alloc] initWithDbPath:[self dbPath]];
}

-(void)setUp{
    
}

-(void)tearDown{
    
}

-(void)tearDownClass{
    
}

#pragma mark -

-(void)testSelectAll{
//    select * from cities ;
    NSArray *results = [manage selectRecordsssFields:nil from:citiesTableName where:nil];
    GHAssertTrue([results count] == 372, @"fail");
}

-(void)testSelectAnd{
//    select id,province_id from cities where province_id=7 and id>20 ;
    NSMutableArray *params = [[NSMutableArray alloc] init];
    [params addObject:@"province_id=7"];
    [params addObject:@"id>20"];
    NSDictionary *orConditions = [NSDictionary dictionaryWithObject:params forKey:@"and"];
    NSArray *results = [manage selectRecordsssFields:@"id,province_id" from:citiesTableName where:orConditions];
    GHAssertTrue([results count] == 9,nil);
}

-(void)testSelectAndDefault{
//    select id,province_id from cities where province_id=7 and id>20 ;
    NSMutableArray *params = [[NSMutableArray alloc] init];
    [params addObject:@"province_id=7"];
    [params addObject:@"id>20"];
    NSArray *results = [manage selectRecordsssFields:@"id,province_id" from:citiesTableName where:params];
    GHAssertTrue([results count] == 9,nil);
}

-(void)testSelectOr{
//    select id,province_id from cities where id=1 or id=2 ;
    NSMutableArray *params = [[NSMutableArray alloc] init];
    [params addObject:@"id=1"];
    [params addObject:@"id=2"];
    NSDictionary *orConditions = [NSDictionary dictionaryWithObject:params forKey:@"or"];
    
    NSArray *results = [manage selectRecordsssFields:@"id,province_id" from:citiesTableName where:orConditions];
    GHAssertTrue([results count] == 2,nil);
}

-(void)testSelectAndOr{
//    select id,province_id from cities where province_id=7 and id>20 or id = 1 ;
    NSMutableArray *param1 = [[NSMutableArray alloc] init];
    [param1 addObject:@"province_id=7"];
    [param1 addObject:@"id>20"];
    
    NSString *param2 = @"id = 1";

    NSArray *params = [NSArray arrayWithObjects:param1,param2, nil];
    
    NSDictionary *orConditions = [NSDictionary dictionaryWithObject:params forKey:@"or"];
    
    NSArray *results = [manage selectRecordsssFields:@"id,province_id" from:citiesTableName where:orConditions];
    GHAssertTrue([results count] == 10,nil);
}

#pragma mark -
-(void)testSelectOne{
//    select * from cities limit 1 ;
    NSDictionary *result = [manage selectRecordFields:nil from:citiesTableName where:nil];
    GHAssertTrue([[result objectForKey:@"name"] isEqualToString:@"北京市"], nil);
}

-(void)testSelectOrderBy{
//    select * from cities order by id desc limit 1 ;
    NSDictionary *result = [manage selectRecordFields:nil from:citiesTableName where:nil orderBy:@"id desc"];
    GHAssertTrue([[result objectForKey:@"name"] isEqualToString:@"屏东"], nil);
}

-(void)testSelectOrderByOffset{
//    select * from cities order by id desc limit 1 offset 1 ;
    NSDictionary *result = [manage selectRecordFields:nil from:citiesTableName where:nil orderBy:@"id desc" offset:1];
    GHAssertTrue([[result objectForKey:@"name"] isEqualToString:@"香港特别行政区"], nil);
}

-(void)testSelectBJ{
//    select * from cities where id=2 limit 1 ;
    NSDictionary *result = [manage selectRecordFields:nil from:citiesTableName where:@"id=2"];
    GHAssertTrue([[result objectForKey:@"name"] isEqualToString:@"天津市"], nil);
}

#pragma mark -
-(NSString *)dbPath{
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"appDbManageTest.sqlite"];
}
@end
