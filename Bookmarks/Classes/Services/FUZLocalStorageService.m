//
//  LocalStorageService.m
//  Bookmarks
//
//  Created by fuzza on 12/1/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import "FUZLocalStorageService.h"
#import "FUZBookmark.h"

@interface FUZLocalStorageService()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation FUZLocalStorageService

+ (instancetype)sharedInstance
{
    static FUZLocalStorageService *sharedStorageService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStorageService = [[self alloc] init];
    });
    return sharedStorageService;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self setupCoreDataStack];
    }
    return self;
}

- (void)setupCoreDataStack
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Bookmarks" withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
    NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"Bookmarks.sqlite"];
        
    NSError *error = nil;
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
    if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    if (self.persistentStoreCoordinator)
    {
        self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        [self.managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
}

- (void)createBookmarkFromLocation:(CLLocation *)location
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:[FUZBookmark entityName] inManagedObjectContext:self.managedObjectContext];

    FUZBookmark* newBookmark = [[FUZBookmark alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    newBookmark.location = location;
    
    [self saveContext];
}

- (BOOL)saveContext;
{
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    return (error == nil);
}

- (NSFetchedResultsController *)fetchedResultControllerForAllBookmarks
{
    NSFetchRequest *allBookmarksRequest = [[NSFetchRequest alloc] initWithEntityName:[FUZBookmark entityName]];
    [allBookmarksRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    return [self fetchedResultWithFetchRequest:allBookmarksRequest];
}

- (NSFetchedResultsController *)fetchedResultWithFetchRequest:(NSFetchRequest *)request;
{
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    return fetchedResultsController;
}

@end
