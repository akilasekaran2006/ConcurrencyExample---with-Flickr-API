//
//  PhotosViewController.m
//  ConcurrencyExample-Flickr
//
//  Created by Akila Sivapathasekaran on 9/25/13.
//  Copyright (c) 2013 Akila Sivapathasekaran. All rights reserved.
//

#import "PhotosViewController.h"
#import "FlickrNetworkCommunicator.h"

@interface PhotosViewController ()

@property (nonatomic, strong) NSMutableArray *displayedImages;

@property (nonatomic,strong) NSDictionary *jsonDictionary;
@property (nonatomic,strong) NSMutableArray *photoIDsArray;
@property (nonatomic, strong) FlickrNetworkCommunicator *networkCommunicator;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PhotosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.displayedImages = [NSMutableArray array];
    self.networkCommunicator = [[FlickrNetworkCommunicator alloc] init];
    
    self.view.frame = [[UIScreen mainScreen] bounds];

    self.tableView = [[ UITableView alloc] init];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    CGRect tableFrame = self.view.frame;
    self.tableView.frame = tableFrame;
    
    
    [self. view addSubview: self.tableView];
    
    [self getJSONDictionary];
    
    
    self.photoIDsArray = [[NSMutableArray alloc] init];
    
    [self getPhotoID];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(addButtonPressed:)];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.displayedImages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];

    }
    UIImage *photo = [self.displayedImages objectAtIndex:indexPath.row];
    cell.textLabel.text = @"Cell text";
    cell.imageView.image = photo;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 200;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.imageView.clipsToBounds = YES;
    cell.imageView.layer.cornerRadius = 50;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) getJSONDictionary
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flickr-response"
                                                         ofType:@"json"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    self.jsonDictionary = [NSJSONSerialization JSONObjectWithData:fileData options:0 error:nil];
    
}


-(void) getPhotoID
{
    
    for (NSDictionary *eachPhoto in [[self.jsonDictionary objectForKey:@"photos"] objectForKey:@"photo"])
    {
        [self.photoIDsArray addObject:[eachPhoto objectForKey:@"id"]];
    }
    
    
}



- (void)addButtonPressed:(id)sender
{
    static NSInteger nextPhotoToFetch = 0;
    NSString *nextPhotoIDFromPhotoIDsArray = [self.photoIDsArray objectAtIndex:nextPhotoToFetch];
    nextPhotoToFetch++;
    
    [self.networkCommunicator requestImageForPhotoId:nextPhotoIDFromPhotoIDsArray
                                      withCompletion:^(BOOL success, UIImage *image)
    {
                                          if(success)
                                          {
                                              [self.displayedImages insertObject:image
                                                                         atIndex:0];
                                          }
                                          
        
        [self.tableView reloadData];
    }];
    
}

@end
