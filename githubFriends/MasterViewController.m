//
//  MasterViewController.m
//  githubFriends
//
//  Created by Allen Spicer on 4/25/16.
//  Copyright © 2016 Allen Spicer. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController () <NSURLSessionDelegate>

//NSMUTableData is specific type that can hold this information coming in
@property NSMutableData * recievedData;
@property NSMutableArray *objects;
@property NSMutableArray *repositories;
@end



@implementation MasterViewController

#pragma mark - Managing the detail item


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.objects = [[NSMutableArray alloc] init];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(GotToNewItemViewController:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (void)getData {
    // Update the user interface for the detail item.
    
    //set input from user to new variable - username
    NSString * username = [self.objects lastObject];
    
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



#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;

        //empty recievedData so that it can be used in Detail View
            self.recievedData = nil;

        
        
    }
}

-(IBAction)GotToNewItemViewController:(id)sender{
    //create instance of ui alert controller and amend settings
    UIAlertController *alertController = [UIAlertController
    alertControllerWithTitle: @"Add a Friend"
                    message:@"Enter a valid github username"
            preferredStyle:UIAlertControllerStyleAlert];
    //format information while presenting
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Username";
    }];
    
    UIAlertAction * okAlert = [UIAlertAction actionWithTitle: @"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
    UITextField* textField = alertController.textFields.lastObject;
    NSLog(@"%@", textField.text);
    [_objects addObject:textField.text];
    
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_objects count]-1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self getData];
    }];
    
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle: @"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        NSLog(@"User Canceled");

}];
    [alertController addAction:okAlert];
    [alertController addAction:cancelAction];
    
    [self presentViewController: alertController animated:YES completion: nil];

}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = self.objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
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
