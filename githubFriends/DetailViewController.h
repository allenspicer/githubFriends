//
//  DetailViewController.h
//  githubFriends
//
//  Created by Allen Spicer on 4/25/16.
//  Copyright © 2016 Allen Spicer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

