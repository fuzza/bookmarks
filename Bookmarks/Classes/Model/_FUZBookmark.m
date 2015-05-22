// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FUZBookmark.m instead.

#import "_FUZBookmark.h"

const struct FUZBookmarkAttributes FUZBookmarkAttributes = {
	.location = @"location",
	.name = @"name",
};

@implementation FUZBookmarkID
@end

@implementation _FUZBookmark

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"FUZBookmark" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"FUZBookmark";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"FUZBookmark" inManagedObjectContext:moc_];
}

- (FUZBookmarkID*)objectID {
	return (FUZBookmarkID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic location;

@dynamic name;

@end

