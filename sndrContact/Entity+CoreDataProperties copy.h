//
//  Entity+CoreDataProperties.h
//  
//
//  Created by Denis Arsenault on 9/9/18.
//
//

#import "Entity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Entity (CoreDataProperties)

+ (NSFetchRequest<Entity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *city;
@property (nullable, nonatomic, copy) NSString *company_name;
@property (nullable, nonatomic, copy) NSString *county;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *first_name;
@property (nullable, nonatomic, retain) NSData *jpg;
@property (nullable, nonatomic, copy) NSString *last_name;
@property (nullable, nonatomic, copy) NSString *phone1;
@property (nullable, nonatomic, copy) NSString *phone2;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *web;
@property (nullable, nonatomic, copy) NSString *zip;

@end

NS_ASSUME_NONNULL_END
