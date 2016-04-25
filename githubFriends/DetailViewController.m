//
//  DetailViewController.m
//  githubFriends
//
//  Created by Allen Spicer on 4/25/16.
//  Copyright © 2016 Allen Spicer. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <NSURLSessionDelegate>

//NSMUTableData is specific type that can hold this information coming in
@property NSMutableData * recievedData;

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
        NSString * urlString = [NSString stringWithFormat:@"https://api.github.com/users/%@", username];
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
    [self configureView];
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

//figure out if the download happened with or without an error
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{

    if (!error) {
       //if no error, say successful
       // NSLog(@"Download Successful! %@", [self.recievedData description]);
        
        NSDictionary * jsonResponse = [NSJSONSerialization JSONObjectWithData:self.recievedData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", [jsonResponse description]);
    }
}

//magic code
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
}





@end
