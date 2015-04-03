//
//  GuessViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 23..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "GuessViewController.h"
#import "SelectWordView.h"
#import "GiveUpPopupVIewController.h"
#import "NetworkController.h"
#import "WYStoryboardPopoverSegue.h"
#import "GuessRightViewController.h"
#import "GuessGiveupViewController.h"

#define OBSERVERNAME @"solvedTheMonkeyProcess"
@interface GuessViewController() <GiveUpPopupDelegate,WYPopoverControllerDelegate>

@end

@implementation GuessViewController
@synthesize hintCount;
@synthesize keyboardHeight;
@synthesize answerText;
@synthesize popoverController;
@synthesize gameItem;
@synthesize resultType;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initView];
    [self setNavigationItem];
    [self registerNotification];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initView {
    
    //init subviews
    self.hintCount = 0;
    self.HintView.hidden = YES;
    self.AgainView.hidden = YES;
    self.WordViewFrame.layer.borderColor = [UIColor yellowColor].CGColor;
    self.WordViewFrame.layer.borderWidth = 1.0f;
    
    //load image from url
    NSURL *url = [NSURL URLWithString:gameItem.imageUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if(data) {
        UIImage *image = [[UIImage alloc]initWithData:data];
        self.imageView.image = image;
    }
    
    //set profile image
    [self.profile setImage:[[UIImage alloc]initWithData:gameItem.imageData]];
    self.profile.layer.cornerRadius = self.profile.frame.size.height /2;
    self.profile.layer.masksToBounds = YES;
    self.profile.layer.borderWidth = 0;
    
    self.name.text = gameItem.name;
    self.hintText.text = gameItem.hint;
    
    //init hint label
    
    if(gameItem.keyword.length <= [self.underBarCollection count]) {
        for(int i=0; i<gameItem.keyword.length; i++) {
            UILabel *underbar = [self.underBarCollection objectAtIndex:i];
            UILabel *text = [self.textWordCollection objectAtIndex:i];
            underbar.hidden = FALSE;
            text.text = [NSString stringWithFormat:@"%C",[gameItem.keyword characterAtIndex:i]];
        }
    }
}

- (void)registerNotification {
    
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    [sendNotification addObserver:self selector:@selector(solvedTheMonkeyProcess:) name:OBSERVERNAME object:nil];
    
    
}

- (void)solvedTheMonkeyProcess:(NSNotification *)notification { //network notify the result of update request
    
    //do something..
    
    NSDictionary* dict = notification.userInfo;
    
    NSString *result = (NSString*)dict[@"result"];
    NSString *message = (NSString*)dict[@"message"];
    
    if([result isEqualToString:@"error"]) { // if update failed
        
        //show pop up
        
        NSLog(@"Error Message=%@",message);
    }
    else {
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                      bundle:nil];
        
        if([resultType intValue]==0) {// guess right
            GuessRightViewController* vc = [sb instantiateViewControllerWithIdentifier:@"GuessRightViewController"];
            vc.gameItem = gameItem;
            self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
            [self presentViewController:vc animated:YES completion:nil];
            vc.view.alpha = 0;
            [UIView animateWithDuration:1 animations:^{
                vc.view.alpha = 1;
            }];
        }
        else { //give up
            GuessGiveupViewController* vc = [sb instantiateViewControllerWithIdentifier:@"GuessGiveupViewController"];
            vc.gameItem = gameItem;
            self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
            [self presentViewController:vc animated:YES completion:nil];
            vc.view.alpha = 0;
            [UIView animateWithDuration:1 animations:^{
                vc.view.alpha = 1;
            }];
        }
        
        [self performSegueWithIdentifier:@"SelectWordSegue" sender:self];
    }
}

- (void)setNavigationItem {
    
    UIButton *buttonLeft  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)okbtnPressed:(id)sender
{
    [self.view endEditing:YES];
    
    if ([[answerText text] isEqualToString:gameItem.keyword]) { //answer right
        
        self.resultType = [NSNumber numberWithInt:0];
        NetworkController *networkController = [NetworkController sharedInstance];
        [networkController solveTheMonkey:gameItem.gameNo GameLevel:gameItem.level ObserverName:OBSERVERNAME];
    }
    else {
        if(self.AgainView.hidden==YES) {
            self.AgainView.hidden = NO;
            [self performSelector:@selector(hideAgainView)withObject:nil afterDelay:2.0];
        }
    }
}

- (void)hideAgainView {
    self.AgainView.hidden = YES;
}

- (IBAction)hintbtnPressed:(id)sender {
    
    hintCount++;
    
    if(hintCount==1) {
        self.HintView.hidden = NO;
    }
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registNotification];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unregistNotification];
}

- (void) registNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) unregistNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification*)aNotification {

    NSDictionary *userInfo = [aNotification userInfo];
    keyboardHeight = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [self setViewMovedUp:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {

    [self setViewMovedUp:NO];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.

        rect.origin.y -= keyboardHeight.height;
        rect.size.height += keyboardHeight.height;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += keyboardHeight.height;
        rect.size.height -= keyboardHeight.height;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GiveUpSegue"])
    {
        GiveUpPopupVIewController *giveUpPopupViewController = segue.destinationViewController;
        giveUpPopupViewController.delegate = self;
        
        WYStoryboardPopoverSegue *popoverSegue = (WYStoryboardPopoverSegue *)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionUp
                                                             animated:YES
                                                              options:WYPopoverAnimationOptionFadeWithScale
                                                                 mode:3];
        popoverController.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"SelectWordSegue"]) {
        
        SelectWordView *wordView = (SelectWordView*)segue.destinationViewController;
        
        int newRound = [gameItem.round intValue];
        newRound = newRound+1;
        NSMutableDictionary *gameInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  gameItem.memberNo, @"targetNumber",
                                  gameItem.gameNo,@"gameNumber",
                                  [NSString stringWithFormat:@"%d",newRound],@"round",
                                  nil];
        wordView.gameInfo = gameInfo;
        
    }
}

- (NSString *)GetUTF8String:(NSString *)hanggulString {
    NSArray *chosung = [[NSArray alloc] initWithObjects:@"ㄱ",@"ㄲ",@"ㄴ",@"ㄷ",@"ㄸ",@"ㄹ",@"ㅁ",@"ㅂ",@"ㅃ",@"ㅅ",@"ㅆ",@"ㅇ",@"ㅈ",@"ㅉ",@"ㅊ",@"ㅋ",@"ㅌ",@"ㅍ",@"ㅎ",nil];
    NSArray *jungsung = [[NSArray alloc] initWithObjects:@"ㅏ",@"ㅐ",@"ㅑ",@"ㅒ",@"ㅓ",@"ㅔ",@"ㅕ",@"ㅖ",@"ㅗ",@"ㅘ",@"ㅙ",@"ㅚ",@"ㅛ",@"ㅜ",@"ㅝ",@"ㅞ",@"ㅟ",@"ㅠ",@"ㅡ",@"ㅢ",@"ㅣ",nil];
    NSArray *jongsung = [[NSArray alloc] initWithObjects:@"",@"ㄱ",@"ㄲ",@"ㄳ",@"ㄴ",@"ㄵ",@"ㄶ",@"ㄷ",@"ㄹ",@"ㄺ",@"ㄻ",@"ㄼ",@"ㄽ",@"ㄾ",@"ㄿ",@"ㅀ",@"ㅁ",@"ㅂ",@"ㅄ",@"ㅅ",@"ㅆ",@"ㅇ",@"ㅈ",@"ㅊ",@"ㅋ",@" ㅌ",@"ㅍ",@"ㅎ",nil];
    NSString *textResult = @"";
    for (int i=0;i<[hanggulString length];i++) {
        NSInteger code = [hanggulString characterAtIndex:i];
        if (code >= 44032 && code <= 55203) {
            NSInteger uniCode = code - 44032;
            NSInteger chosungIndex = uniCode / 21 / 28;
            NSInteger jungsungIndex = uniCode % (21 * 28) / 28;
            NSInteger jongsungIndex = uniCode % 28;
            textResult = [NSString stringWithFormat:@"%@%@%@%@", textResult, [chosung objectAtIndex:chosungIndex], [jungsung objectAtIndex:jungsungIndex], [jongsung objectAtIndex:jongsungIndex]];
            NSLog(@"%@",[chosung objectAtIndex:chosungIndex]);
        }
    }
    return textResult;
}
- (void)closePopup {
    [popoverController dismissPopoverAnimated:YES];
    popoverController.delegate = nil;
    popoverController = nil;
}

#pragma mark Giveup popup delegate

- (void)giveupProcess {
    
    [self.view endEditing:YES];
    [self closePopup];
    
    self.resultType = [NSNumber numberWithInt:1];
    NetworkController *networkController = [NetworkController sharedInstance];
    [networkController solveTheMonkey:gameItem.gameNo GameLevel:@"0" ObserverName:OBSERVERNAME];
    
}
@end
