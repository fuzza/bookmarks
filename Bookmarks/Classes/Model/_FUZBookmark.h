// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FUZBookmark.h instead.

#import <CoreData/CoreData.h>

extern const struct FUZBookmarkAttributes {
	__unsafe_unretained NSString *location;
	__unsafe_unretained NSString *name;
} FUZBookmarkAttributes;

@class NSObject;

@interface FUZBookmarkID : NSManagedObjectID {}
@end

@interface _FUZBookmark : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FUZBookmarkID* objectID;

@property (nonatomic, strong) id location;

//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@end

@interface _FUZBookmark (CoreDataGeneratedPrimitiveAccessors)

- (id)primitiveLocation;
- (void)setPrimitiveLocation:(id)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

@end
