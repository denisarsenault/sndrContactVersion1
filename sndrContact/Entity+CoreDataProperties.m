//
//  Entity+CoreDataProperties.m
//  
//
//  Created by Denis Arsenault on 9/9/18.
//
//

#import "Entity+CoreDataProperties.h"

@implementation Entity (CoreDataProperties)

+ (NSFetchRequest<Entity *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Entity"];
}

@dynamic address;
@dynamic city;
@dynamic company_name;
@dynamic county;
@dynamic email;
@dynamic first_name;
@dynamic jpg;
@dynamic last_name;
@dynamic phone1;
@dynamic phone2;
@dynamic state;
@dynamic web;
@dynamic zip;

@end
