//
//  DetailViewController.m
//  githubFriends
//
//  Created by Allen Spicer on 4/25/16.
//  Copyright © 2016 Allen Spicer. All rights reserved.
//

#import "DetailViewController.h"
#import "Friend.h"
#import "RepoTableViewCell.h"

@interface DetailViewController () <NSURLSessionDelegate, UITableViewDelegate, UITableViewDataSource>

//NSMUTableData is specific type that can hold this information coming in
@property NSMutableData * recievedData;
@property IBOutlet UITableView * tableView;
@property NSMutableArray * repoArray;


@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
        
        //set input from user to new varaible - username
        NSString * username = [self.detailItem description];
        //create string which puts together api address and username
        NSString * urlString = [NSString stringWithFormat:@"https://api.github.com/users/%@/repos", username];
        //create NS URL from string
        NSURL * url = [NSURL URLWithString:urlString];
        
        //configure what part of processor is being used - main Queue is where all UI elements need to happen
        NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession * session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        //create data task - which downloads from url
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url];
        // tell data task whether to start, stop, resume etc
        [dataTask resume];
        
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   // [self configureView];
     self.repoArray = [[NSMutableArray alloc]init];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[RepoTableViewCell class] forCellReuseIdentifier:@"friendIdentifier"];
    
    [self.view addSubview:self.tableView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NSURLSessionDelegate

//bring in data task information
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    //use variable created above. create loop to incrementaly add to our mutable data variable
    if (!self.recievedData) {
        self.recievedData = [[NSMutableData alloc]initWithData:data];
    }else{
        [self.recievedData appendData:data];
    }
}

//determine if the download happened with or without an error
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{

    if (!error) {
       //if no error, say successful
       // NSLog(@"Download Successful! %@", [self.recievedData description]);
        
        NSArray * jsonResponse = [NSJSONSerialization JSONObjectWithData:self.recievedData options:NSJSONReadingMutableContainers error:nil];
        self.repoArray = [jsonResponse mutableCopy];
        
        
        if(self.repoArray) {
            self.recievedData = nil;
            [self.tableView reloadData];
        
        NSLog(@"%@", [self.repoArray description]);
        
        }
        

      //  self.numberOfReposLabel.text = [NSString stringWithFormat:@"Number of Repositories: %lu",(unsigned long)[jsonResponse count]];
        
        
      // NSLog(@"%@", [jsonResponse objectForKey:@"name"]);
      
    }
}

//magic code
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
}



#pragma mark - Table view data source

// create cell for each username to populate table

//place repo name in each cell

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return self.repoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendIdentifier" forIndexPath:indexPath];
    
    cell.textLabel.text = self.repoArray[indexPath.row][@"name"];
    
    return cell;
}



@end
