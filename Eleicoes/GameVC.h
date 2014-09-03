//
//  GameVC.h
//  Eleicoes
//
//  Created by Katha on 19.08.14.
//  Copyright (c) 2014 Nappix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@import AVFoundation;

@interface GameVC : UIViewController
{
    int first;
    int second;
    int posNumber;
    float count;
    int state;
    float level;
}

@property (strong, nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@property (weak, nonatomic) IBOutlet UIView *screenEnd;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSDictionary* lists;
@property (nonatomic) SystemSoundID gameOverSound;
@property (weak, nonatomic) IBOutlet UILabel *lblFirstNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblSecondNumber;
@property (weak, nonatomic) IBOutlet UIImageView *imgCandidatePicture;
@property (weak, nonatomic) IBOutlet UILabel *lblParty;
@property (weak, nonatomic) IBOutlet UILabel *lblPosition;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (nonatomic, strong) NSTimer *myTimer;
@property (weak, nonatomic) IBOutlet UILabel *lblScore;
@property (weak, nonatomic) IBOutlet UILabel *lblHighscore;
@property (weak, nonatomic) IBOutlet UILabel *lblShowScore;
@property (weak, nonatomic) IBOutlet UIView *screenStart;
@property (weak, nonatomic) IBOutlet UIButton *btnBlank;
@property (weak, nonatomic) IBOutlet UIButton *btnErase;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
@property (weak, nonatomic) IBOutlet UIView *screenWho;
@property (weak, nonatomic) IBOutlet UIImageView *imgEye;
@property (weak, nonatomic) IBOutlet UIImageView *imgSmile;
@property (weak, nonatomic) IBOutlet UIImageView *imgHair;

- (void)startCount;
- (IBAction)btnClickNumber:(id)sender;
- (IBAction)btnClickBlank:(id)sender;
- (IBAction)btnClickErase:(id)sender;
- (IBAction)btnClickConfirm:(id)sender;

@end
