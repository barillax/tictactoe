//
//  ORGameViewController.m
//  TicTacToe
//
//  Created by Ori Ratner on 9/8/12.
//  Copyright (c) 2012 Ori Ratner. All rights reserved.
//

#import "ORGameViewController.h"

@interface ORGameViewController ()
- (void)updateTurn;
- (BOOL)checkGameOverAfterTap:(int)tapIndex forPlayer:(int)currentPlayer;
@end

@implementation ORGameViewController {
    UIImage *defaultImage;
    UIImage *playerOneImage;
    UIImage *playerTwoImage;
    
    int playerTurn;
    int filledTiles;
    BOOL gameOver;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    defaultImage = [UIImage imageNamed:@"tile_default.png"];
    playerOneImage = [UIImage imageNamed:@"tile_player_1.png"];
    playerTwoImage = [UIImage imageNamed:@"tile_player_2.png"];
    
    filledTiles = 0;
    
    for (UIImageView *imageView in self.tiles) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        [imageView addGestureRecognizer:tap];
        
    }
}

- (void)viewDidUnload
{
    [self setTiles:nil];
    [self setTurnLabel:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self newGame:nil];
}

// Update the label to explan who's turn it is
- (void)updateTurn
{
    self.turnLabel.text = [NSString stringWithFormat:@"Player %d's Turn!", playerTurn];
}

- (BOOL)checkGameOverAfterTap:(int)tapIndex forPlayer:(int)currentPlayer
{
    // sort tiles by tag for easy lookup
    NSSortDescriptor *ascendingSort = [[NSSortDescriptor alloc] initWithKey:@"tag" ascending:YES];
    NSArray *sortedTiles = [self.tiles sortedArrayUsingDescriptors:@[ascendingSort]];
    
    // Pre-compute row, col, and target player image
    int col = tapIndex % 3;
    int row = (tapIndex - col) / 3;
    
    UIImage *playerImage = currentPlayer == 1 ? playerOneImage : playerTwoImage;
    
    // Track whether we found a win across rows, cols, and diagonals
    int rowSum = 0;
    int colSum = 0;
    int diagonalSum1 = 0;
    int diagonalSum2 = 0;
    
    for (int i = 0; i < 3; i++) {
        // Check horizontal 
        if ( ((UIImageView *)[sortedTiles objectAtIndex:(row*3+i)]).image == playerImage)
            rowSum++;
        // Check vertical 
        if ( ((UIImageView *)[sortedTiles objectAtIndex:(i*3+col)]).image == playerImage)
            colSum++;
        // Check diagonals
        if ( ((UIImageView *)[sortedTiles objectAtIndex:(i*3+i)]).image == playerImage)
            diagonalSum1++;
        if ( ((UIImageView *)[sortedTiles objectAtIndex:(i*3+2-i)]).image == playerImage)
            diagonalSum2++;
    }
    
    // Check end-game state
    if (3 == rowSum || 3 == colSum || 3 == diagonalSum1 || 3 == diagonalSum2)
        return YES;
    return NO;
}

- (void)cellTapped:(UITapGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateEnded || gameOver)
        return;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    
    // Only accept the tap if it's on a blank square
    // Otherwise, players could overwrite each other's moves!
    if ( imageView.image == defaultImage ) {
        
        // Increment filled tiles count
        filledTiles++;
        
        // Update the view to show the tap and change the turn
        int currentPlayer = playerTurn;
        if (playerTurn == 1) {
            [imageView setImage:playerOneImage];
            playerTurn = 2;
        } else {
            [imageView setImage:playerTwoImage];
            playerTurn = 1;
        }
        
        // If game over, show new message
        if ( [self checkGameOverAfterTap:imageView.tag forPlayer:currentPlayer] == YES ) {
            self.turnLabel.text = [NSString stringWithFormat:@"Player %d wins!", playerTurn];
            gameOver = YES;
        } else if ( 9 == filledTiles ) {
            self.turnLabel.text = @"It's a tie!";
            gameOver = YES;
        } else {
            [self updateTurn];
        }
    }
}

- (IBAction)exitGame:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)newGame:(id)sender {
    // Initialize view to be all-blank
    for (UIImageView *imageView in self.tiles) {
        [imageView setImage:defaultImage];
    }
    
    // Set first player's turn
    playerTurn = 1;
    filledTiles = 0;
    gameOver = NO;
    
    [self updateTurn];
}

@end
