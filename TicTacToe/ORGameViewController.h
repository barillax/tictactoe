//
//  ORGameViewController.h
//  TicTacToe
//
//  Created by Ori Ratner on 9/8/12.
//  Copyright (c) 2012 Ori Ratner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ORGameViewController : UIViewController

// Reference to the tiles on the game board
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *tiles;

// Indicate whose turn it is
@property (weak, nonatomic) IBOutlet UILabel *turnLabel;

// Handle tap on the exit game button
- (IBAction)exitGame:(id)sender;
// Handle tap on new game button
- (IBAction)newGame:(id)sender;

// Handle tap on the cells
- (void)cellTapped:(UITapGestureRecognizer *)sender;

@end
