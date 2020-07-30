//
//  Post.m
//  TravelBuddies
//
//  Created by Mariana Martinez on 13/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import "Post.h"

@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic caption;
@dynamic image;
@dynamic likeCount;
@dynamic place;
@dynamic city;
@dynamic tags;
@dynamic lng;
@dynamic lat;
@dynamic searchNum;
@dynamic likesArr;
@dynamic isLiked;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withPlace: ( NSString * _Nullable )place withCity: ( NSString * _Nullable )city withTags: ( NSMutableArray * _Nullable )tags withLng: ( NSNumber * _Nullable )lng withLat: ( NSNumber * _Nullable )lat withSearchNum: ( NSNumber * _Nullable )searchNum withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    newPost.likeCount = @(0);
    newPost.place = place;
    newPost.city = city;
    newPost.tags = tags;
    newPost.lng = lng;
    newPost.lat = lat;
    newPost.searchNum = searchNum;
    newPost.likesArr = [[NSMutableArray alloc] init];
    newPost.isLiked = NO;
    
    [newPost saveInBackgroundWithBlock: completion];
}


+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
