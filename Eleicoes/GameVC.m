//
//  GameVC.m
//  Eleicoes
//
//  Created by Katha on 19.08.14.
//  Copyright (c) 2014 Nappix. All rights reserved.
//

#import "GameVC.h"
#include <stdlib.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <FacebookSDK/FacebookSDK.h>
#import <iAd/iAd.h>

@import AVFoundation;

@interface GameVC ()

@end

@implementation GameVC
@synthesize lblFirstNumber,lblSecondNumber, lblScore, lblShowScore, lblHighscore, imgCandidatePicture, lblName, lblParty, lblPosition, screenEnd, score, progressView, backgroundMusicPlayer, screenStart, gameOverSound, btnBlank, btnConfirm, btnErase, screenWho, lists, imgEye,imgHair,imgSmile;

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
    first = (arc4random() % 8)+1;
    second = (arc4random() % 9);
    posNumber = score = 0; level = 0.03;
    
    lblSecondNumber.text = [NSString stringWithFormat:@"%d",second ];
    lblFirstNumber.text = [NSString stringWithFormat:@"%d",first ];
    
    NSString* pathList = [[NSBundle mainBundle] pathForResource:@"nameList" ofType:@"plist"];
    lists = [NSDictionary dictionaryWithContentsOfFile:pathList];
    [self configureAudioPlayer];
    [self changeStateTo:3];
    
    self.canDisplayBannerAds = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self changeStateTo:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TIMER

-(void)startCount
{
    count = 0.65;
    [self startTimer];
}

-(void)startTimer
{
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateUI:) userInfo:nil repeats:YES];
}
-(void)finishTimer
{
    [self.myTimer invalidate];
    self.myTimer = nil;
}

- (void)updateUI:(NSTimer *)timer
{
    count-=level;
    
    if (count >0)
    {
        self.progressView.progress = count;
    }
    else
    {
        [self finishTimer];
        [self gameOver];
    }
    
  
    [self gameLoop];
}

#pragma mark - Buttons

- (IBAction)btnClickNumber:(id)sender
{
    if (state == 1) {
        if (posNumber == 0)
        {
            if ([sender tag] == first)// se aceertou primeiro numero
            {
                lblFirstNumber.textColor = [UIColor greenColor];
                posNumber = 1;
            }
            else
            {
                [self gameOver];
            }
        }
        else
        {
            if ([sender tag] == second || (second == 0 && [sender tag] == 10))// se aceertou primeiro numero
            {
                lblSecondNumber.textColor = [UIColor greenColor];
                posNumber = 0;
                score++; lblShowScore.text =  [NSString stringWithFormat:@"%ld",(long)score];
                [self newVote];
            }
            else
            {
                [self gameOver];
            }
        }
    }
}

-(IBAction)btnClickErase:(id)sender //pause on and pause off and remove ads
{
    if (state == 1)
    {
        [self changeStateTo:0];
    }
    else if (state == 0)
    {
        [self changeStateTo:4];
    }
    else if (state == 5)
    {
        [self changeStateTo:3];
    }
    else
    {
        //TODO: remove ads
    }
}

-(IBAction)btnClickBlank:(id)sender //developers and share and
{
    if (state==2)
    {
        [self postOnFacebook];
    }
    else if (state == 3)
    {
        [self changeStateTo:5];
    }
    else if (state == 5)
    {
        [self changeStateTo:3];
    }
    else
    {
        [self gotoReviews];
    }
}

-(IBAction)btnClickConfirm:(id)sender// new game and retry and nothing in pause
{
    if(state == 3 || state == 2 || state == 5) [self changeStateTo:1];
}

#pragma mark - Game Methods

-(void) gameOver
{
    AudioServicesPlaySystemSound(gameOverSound);
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"highscore"] < score)
        [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"highscore"];
    lblHighscore.text = [NSString stringWithFormat:@"%ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"highscore"]];
    lblScore.text = [NSString stringWithFormat:@"%ld",(long)score];
    [self changeStateTo:2];
}
- (void) newVote
{
    first = (arc4random() % 8)+1;
    second = (arc4random() % 9);
    posNumber = 0;
    [self newParty];
    [self newFace];
    [self newName];
    
    lblSecondNumber.text = [NSString stringWithFormat:@"%d",second ];
    lblFirstNumber.text = [NSString stringWithFormat:@"%d",first ];
    lblSecondNumber.textColor = lblFirstNumber.textColor = [UIColor darkGrayColor];
    if (count < 1)
        count+=(level*1.3);//trocar por nível
    
}
-(void) newName
{
    NSArray *names = [lists objectForKey:@"Nomes"];
    lblName.text = [names objectAtIndex:arc4random_uniform((uint)[names count])];
}

-(void) newParty
{
    NSString* partido;
    int letraCount = arc4random_uniform(2);
    int secondChar = arc4random_uniform(25)+65;
    int thirdChar = arc4random_uniform(25)+65;
    if (letraCount) partido = [NSString stringWithFormat:@"P%c%c",(char)secondChar,(char)thirdChar];
    else partido=[NSString stringWithFormat:@"P%c",(char)secondChar];
    
    lblParty.text = partido;
}
-(void)newFace
{
    UIImage *image1 = [UIImage imageNamed: [NSString stringWithFormat:@"smile%d.png",arc4random_uniform(3)+1]];
    UIImage *image2 = [UIImage imageNamed: [NSString stringWithFormat:@"hair%d.png",arc4random_uniform(3)+1]];
    UIImage *image3 = [UIImage imageNamed: [NSString stringWithFormat:@"eye%d.png",arc4random_uniform(3)+1]];
    [imgSmile setImage:image1];
    [imgHair setImage:image2];
    [imgEye setImage:image3];
}

-(void)changeStateTo:(int)states
{
    switch (states)
    {
        case 1://new game
            [self startCount];
            [btnErase setTitle:@"Pausar" forState:UIControlStateNormal];
            [btnBlank setTitle:@"Branco" forState:UIControlStateNormal];
            screenEnd.hidden = screenStart.hidden = screenWho.hidden = YES; lblShowScore.hidden = progressView.hidden = NO;
            score = 0; level = 0.03;
            [self newVote];
            break;
        case 2://game over
            [btnErase setTitle:@"Liberar" forState:UIControlStateNormal];
            [btnBlank setTitle:@"Contar" forState:UIControlStateNormal];
            screenEnd.hidden =  NO; screenStart.hidden = screenWho.hidden = YES; lblShowScore.hidden = progressView.hidden = YES;
            break;
        case 0://pause game
            [self finishTimer];
            break;
        case 3://start screen
            screenEnd.hidden = screenWho.hidden = YES; screenStart.hidden = NO; lblShowScore.hidden = progressView.hidden = YES;
            [btnErase setTitle:@"Corrigir" forState:UIControlStateNormal];
            [btnBlank setTitle:@"Branco" forState:UIControlStateNormal];
            break;
        case 4://pausing back
            [self startTimer];
            states = 1;
            break;
        case 5://who made
            screenEnd.hidden = screenStart.hidden = lblShowScore.hidden = progressView.hidden = YES;
            screenWho.hidden = NO;
            break;
    }
    state = states;
}

- (void)configureAudioPlayer {
    //NSURL *audioFileURL = [[NSBundle mainBundle] URLForResource:@"backSong" withExtension:@"wav"];
    //NSError *error;
    //backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileURL error:&error];
    //if (error) {
       // NSLog(@"%@", [error localizedDescription]);
    //}
    //[backgroundMusicPlayer setNumberOfLoops:-1];
    //[backgroundMusicPlayer play];
    
    gameOverSound = 0;
    NSURL *audioFileURL = [[NSBundle mainBundle] URLForResource:@"over" withExtension:@"aif"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)audioFileURL, &gameOverSound);
    
}

-(void) gameLoop
{
    if (score>50 && (score%20 == 0))
    {
        
        level += 0.01;
    }
    else
    {
        switch (score)
        {
            case 7:
                level = 0.05;
                break;
            case 15:
                level = 0.06;
                break;
            case 25:
                level = 0.08;
                break;
            case 40:
                level = 0.1;
                break;
            case 50:
                level = 0.11;
                break;
            default:
                break;
        }
    }
    
}

#pragma mark - Social

- (void)gotoReviews
{
    NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
    str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str];
    str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];
    
    // Here is the app id from itunesconnect
    str = [NSString stringWithFormat:@"%@id310633997", str];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void)postOnFacebook
{
    //TODO: share button
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params])
    {
        // Present the share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                             // NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              //NSLog(@"result %@", results);
                                          }
                                      }];
    }
    else
    {
        // FALLBACK: publish just a link using the Feed dialog
        
        // Put together the dialog parameters
        NSString* caption = [NSString stringWithFormat:@"Votei por %ld pessoas. Você consegue fazer melhor?",(long)score];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Boca de Urna", @"name",
                                       caption, @"caption",
                                       @"Boca de Urna é um jogo viciante de humor sobre as eleições. Confira agora mesmo na Apple Store", @"description",
                                       @"https://developers.facebook.com/docs/ios/share/", @"link",
                                       @"http://i.imgur.com/g3Qc1HN.png", @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                         // NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              //NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  //NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  //NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                 // NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }

}
// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}


@end
