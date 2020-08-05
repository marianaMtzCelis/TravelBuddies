//
//  Post.h
//  TravelBuddies
//
//  Created by Mariana Martinez on 13/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSString *place;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lng;
@property (nonatomic, strong) NSNumber *searchNum;
@property (nonatomic, strong) NSMutableArray *likesArr;
@property (nonatomic, assign) BOOL isLiked;
@property (nonatomic, assign) BOOL isSaved;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) NSString *address;

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withPlace: ( NSString * _Nullable )place withCity: ( NSString * _Nullable )city withTags: ( NSMutableArray * _Nullable )tags withLng: ( NSNumber * _Nullable )lng withLat: ( NSNumber * _Nullable )lat withSearchNum: ( NSNumber * _Nullable )searchNum withAddress: (NSString * _Nullable)address withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
