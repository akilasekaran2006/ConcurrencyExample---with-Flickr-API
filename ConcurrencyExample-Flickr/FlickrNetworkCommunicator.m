//
//  FlickrNetworkCommunicator.m
//  ConcurrencyExample-Flickr
//
//  Created by Akila Sivapathasekaran on 9/25/13.
//  Copyright (c) 2013 Akila Sivapathasekaran. All rights reserved.
//

#import "FlickrNetworkCommunicator.h"

@implementation FlickrNetworkCommunicator

+ (instancetype)sharedCommunicator
{
    static FlickrNetworkCommunicator *sharedInstance;
    
    // TODO:
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)requestImageForPhotoId:(NSString *)photoId
                withCompletion:(RequestCompletionBlock)completionBlock
{
    [self.operationQueue addOperationWithBlock:
    ^{
        
        NSString *photoURLDictionaryString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=a89b85007437a89df3fe1d31a777a6ed&photo_id=%@&format=json&nojsoncallback=1", photoId];
        
        NSString *photoURL = [NSString stringWithString:[self getPhotoUrlForThisPhoto:photoURLDictionaryString]];
        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]]];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completionBlock(YES, image);
        }];
    }];
}

- (NSString *)getPhotoUrlForThisPhoto:(NSString*) photoURLDictionaryString
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoURLDictionaryString]];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSArray *photoURLArray = [[json objectForKey:@"sizes"] objectForKey:@"size"] ;
    
    NSString *photoURL = [[photoURLArray objectAtIndex:arc4random() % photoURLArray.count] objectForKey:@"source"];
    
    NSLog(@"photourl :: %@",photoURL);
    
    return photoURL;
    
}


@end
