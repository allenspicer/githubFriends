//
//  RepoTableViewCell.m
//  githubFriends
//
//  Created by Allen Spicer on 4/26/16.
//  Copyright © 2016 Allen Spicer. All rights reserved.
//

#import "RepoTableViewCell.h"

@implementation RepoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected){
    self.contentView.backgroundColor = [UIColor orangeColor];
    }else{
        self.contentView.backgroundColor = [UIColor blueColor];
    }
    // Configure the view for the selected state
}

@end
