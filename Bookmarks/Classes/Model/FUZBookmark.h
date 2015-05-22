#import "_FUZBookmark.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface FUZBookmark : _FUZBookmark <MKAnnotation> {}

- (BOOL)isUnnamed;

+ (NSString *)entityName;
+ (NSFetchedResultsController *)fetchedResultsControllerForAllBookmarksInContext:(NSManagedObjectContext *)context;
+ (instancetype)createBookmarWithCoordinates:(CLLocationCoordinate2D)coordinates inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (void)deleteBookmark:(FUZBookmark *)bookmark;

@end
