

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDataManager *)sharedManager;

- (void)saveContext;

- (NSManagedObject *) addNewObjectOfClass:(Class)objectClass;

- (NSManagedObject *) getObjectOfClass:(Class)objectClass;

- (NSArray *) getObjectsOfClass:(Class)objectClass
                predicate:(NSPredicate *)predicate
                  orderBy:(NSString *)key
                ascending:(BOOL)ascending;

- (NSArray *) getObjectsOfClass:(Class)objectClass
                      predicate:(NSPredicate *)predicate;

- (NSManagedObject *)getObjectOfClass:(Class)objectClass 
                            predicate:(NSPredicate *)predicate
                              orderBy:(NSString *)key
                            ascending:(BOOL)ascending;

// for unique object
- (NSManagedObject *)getObjectOfClass:(Class)objectClass 
                            predicate:(NSPredicate *)predicate;

- (NSArray *) getAllObjectOfClass:(Class)objectClass;

- (NSArray *) getAllObjectOfClass:(Class)objectClass
                        orderBy:(NSString *)key
                      ascending:(BOOL)ascending;

- (void)deleteAllObjectsOfClass:(Class)objectClass;
- (void) deleteObject:(NSManagedObject *)object;
- (void) deleteObjects: (NSArray *)objects;
- (void) clearDatabase;

@end
