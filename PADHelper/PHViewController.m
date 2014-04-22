//
//  PHViewController.m
//  PADHelper
//
//  Created by BIINGYANN HSIUNG on 4/10/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

#import "PHViewController.h"
#import "PHScreenParser.h"

@implementation PHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    [[self navigationController]setNavigationBarHidden:YES];
    //skView.showsNodeCount = YES;
        
    // Create and configure the scene.
    PHMyScene * scene = [PHMyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.delegateToVc = self;
    
    // Present the scene.
    [skView presentScene:scene];
}
-(void)viewDidAppear:(BOOL)animated
{
    [[self navigationController]setNavigationBarHidden:YES animated:YES];
}
-(void)historyClicked
{
    [self performSegueWithIdentifier:@"openHistorySegue" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"openHistorySegue"]) {
        PHHistoryVc *vc = [segue destinationViewController];
        [vc testPass:@"bear"];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
