//
//  FUZCoreDataStack.m
//  Bookmarks
//
//  Created by fuzza on 12/2/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import "FUZCoreDataStack.h"

@interface FUZCoreDataStack()

@property (strong, nonatomic, readwrite) NSManagedObjectContext *managedObjectContext;

@end

@implementation FUZCoreDataStack

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self createManagedObjectContext];
    }
    return self;
}

- (void)createManagedObjectContext
{
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSError *error = nil;
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:nil error:&error];
    
    if(error)
    {
        NSLog(@"Error %@", error.localizedDescription);
        abort();
    }
    
    if(coordinator)
    {
        self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [self.managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
}

- (NSManagedObjectModel *)managedObjectModel
{
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:[self modelURL]];
}

- (NSURL *)modelURL
{
    return [[NSBundle mainBundle] URLForResource:@"Bookmarks" withExtension:@"momd"];
}

- (NSURL *)storeURL
{
    NSURL *applicationDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [applicationDirectoryURL URLByAppendingPathComponent:@"Bookmarks.sqlite"];
}

@end
