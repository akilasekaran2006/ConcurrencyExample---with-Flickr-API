//
//  FlickrNetworkCommunicator.h
//  ConcurrencyExample-Flickr
//
//  Created by Akila Sivapathasekaran on 9/25/13.
//  Copyright (c) 2013 Akila Sivapathasekaran. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^RequestCompletionBlock)(BOOL success, UIImage *image);

@interface FlickrNetworkCommunicator : NSObject

@property (nonatomic,retain) NSOperationQueue *operationQueue;

+ (instancetype)sharedCommunicator;

- (void)requestImageForPhotoId:(NSString *)photoId
                withCompletion:(RequestCompletionBlock)completionBlock;

@end
