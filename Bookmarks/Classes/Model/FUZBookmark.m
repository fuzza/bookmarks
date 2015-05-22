#import "FUZBookmark.h"

@interface FUZBookmark (PrimitiveAccessors)

- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)primitiveName;

@end

@interface FUZBookmark ()

// Private interface goes here.

@end

@implementation FUZBookmark

- (NSString *)name
{
    [self willAccessValueForKey:@"name"];
    NSString *nameViaPrimitive = [self primitiveName];
    [self didAccessValueForKey:@"name"];
    return nameViaPrimitive ? nameViaPrimitive : @"Unnamed";
}

- (void)setName:(NSString *)name
{
    [self willChangeValueForKey:@"title"];
    [self willChangeValueForKey:@"name"];
    [self setPrimitiveName:name];
    [self didChangeValueForKey:@"name"];
    [self didChangeValueForKey:@"title"];
}

- (BOOL)isUnnamed
{
    return ([self primitiveName] == nil);
}

+ (void)deleteBookmark:(FUZBookmark *)bookmark
{
    [bookmark.managedObjectContext deleteObject:bookmark];
}

+ (instancetype)createBookmarWithCoordinates:(CLLocationCoordinate2D)coordinates inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    FUZBookmark* newBookmark = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:managedObjectContext];
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:coordinates.latitude longitude:coordinates.longitude];
    newBookmark.location = loc;
    
    return newBookmark;
}

+ (NSFetchedResultsController *)fetchedResultsControllerForAllBookmarksInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *allBookmarksRequest = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    [allBookmarksRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:allBookmarksRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    return fetchedResultsController;
}

+ (NSString *)entityName
{
    return NSStringFromClass(self);
}

#pragma mark MKAnnotation

- (CLLocationCoordinate2D)coordinate
{
    return ((CLLocation *)self.location).coordinate;
}

- (NSString *)title
{
    return self.name;
}

@end
