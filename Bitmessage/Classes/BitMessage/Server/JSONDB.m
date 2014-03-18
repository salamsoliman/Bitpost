//
//  JSONDB.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/17/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "JSONDB.h"
#import "NSFileManager+DirectoryLocations.h"

@implementation JSONDB

/*
+ (NSMutableDictionary *)readDictWithName:(NSString *)aName
{
    JSONDB *db = [[JSONDB alloc] init];
    [db setName:aName];
    return [db dict];
}

+ (void)writeDict:(NSMutableDictionary *)dict withName:(NSString *)aName
{
    JSONDB *db = [[JSONDB alloc] init];
    [db setName:aName];
    [db setDict:dict];
    [db write];
}
*/


- (id)init
{
    self = [super init];
    _name = @"default";
    return self;
}

- (void)setName:(NSString *)name
{
    _name = name;
}

- (NSString *)path
{
    NSString *folder = [[NSFileManager defaultManager] applicationSupportDirectory];
    return [folder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", self.name]];
}

- (NSDictionary *)dict
{
    if (!_dict)
    {
        [self read];
    }
    
    return _dict;
}

- (void)read
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.path])
    {
        self.dict = [NSMutableDictionary dictionary];
        return;
    }
    
    NSData *jsonData = [NSData dataWithContentsOfFile:self.path];
    NSError *error;
    
    id jsonObject = [NSJSONSerialization
                     JSONObjectWithData:jsonData
                     options:NSJSONReadingMutableContainers
                     error:&error];
    
    if (error)
    {
        NSLog(@"JSON Parse Error: %@", [[error userInfo] objectForKey:@"NSDebugDescription"]);
        [NSException raise:@"JSON Parse Error" format:@""];
    }
    else
    {
        self.dict = (NSMutableDictionary *)jsonObject;
    }
}

- (void)write
{
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.dict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    
    if (error)
    {
        NSLog(@"JSON Error: %@", [[error userInfo] objectForKey:@"NSDebugDescription"]);
        [NSException raise:@"JSON Error" format:@""];
    }
    else
    {
        [data writeToFile:self.path atomically:YES];
    }
}


@end
