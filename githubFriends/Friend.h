//
//  Friend.h
//  githubFriends
//
//  Created by Allen Spicer on 4/25/16.
//  Copyright © 2016 Allen Spicer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject


@property (nonatomic) NSString *repoName;
//@property (nonatomic) NSString *repo;


+ (Friend *)friendWithDictionary:(NSDictionary *) friendDict;


@end
