//
//  Comment.m
//  TravelBuddies
//
//  Created by Mariana Martinez on 04/08/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@dynamic author;
@dynamic comment;
@dynamic post;
@dynamic likesArr;
@dynamic isLiked;

+ (nonnull NSString *)parseClassName {
    return @"Comment";
}

+ (void) postComment: (NSString * _Nullable)comment toPost: (Post * _Nullable)post withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Comment *newComment = [Comment new];
    newComment.author = [PFUser currentUser];
    newComment.comment = comment;
    newComment.post = post;
    newComment.likesArr = [[NSMutableArray alloc] init];
    newComment.isLiked = NO;
    
    [newComment saveInBackgroundWithBlock: completion];
    
}

@end
