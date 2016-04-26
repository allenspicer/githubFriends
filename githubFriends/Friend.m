//
//  Friend.m
//  githubFriends
//
//  Created by Allen Spicer on 4/25/16.
//  Copyright © 2016 Allen Spicer. All rights reserved.
//

#import "Friend.h"

@implementation Friend

+ (Friend *)friendWithDictionary:(NSDictionary *)friendDict
{
    Friend *aFriend = nil;
    if (friendDict) {
        aFriend = [[Friend alloc] init];
        aFriend.repoName = [friendDict objectForKey:@"name"];
        
    }
    return aFriend;
}

@end


