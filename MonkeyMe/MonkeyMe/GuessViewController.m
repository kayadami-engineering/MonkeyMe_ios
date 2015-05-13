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
#import "WYStoryboardPopoverSegue.h"
#import "GuessRightViewController.h"
#import "GuessGiveupViewController.h"
#import "PuzzelRightViewController.h"
#import "SVProgressHUD.h"
#import "CommonSharedObject.h"

#define OBSERVERNAME1 @"solvedTheMonkeyProcess"
#define OBSERVERNAME2 @"getRandomGameProcess"

#define PVPMODE     1
#define RANDMODE    2

@interface GuessViewController() <GiveUpPopupDelegate,WYPopoverControllerDelegate>

@end

@implementation GuessViewController
@synthesize hintCount;
@synthesize keyboardHeight;
@synthesize answerText;
@synthesize popoverController;
@synthesize gameItem;
@synthesize resultType;
@synthesize currentMode;
@synthesize networkController;
@synthesize rndNumber;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self registerNotification];
    [self registNotification];
    [self setNavigationItem];
    [self initView];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initView {
    
    //init subviews
    self.hintCount = 0;
    self.WordViewFrame.layer.borderColor = [UIColor yellowColor].CGColor;
    self.WordViewFrame.layer.borderWidth = 1.0f;
    
    self.profile.layer.cornerRadius = self.profile.frame.size.height /2;
    self.profile.layer.masksToBounds = YES;
    self.profile.layer.borderWidth = 0;
    
    networkController = [NetworkController sharedInstance];
    
    //PVP Mode
    if(currentMode==PVPMODE) {
        self.optionBtn.hidden = false;
        [self loadGameItem];
        
    }
    //Puzzel Mode
    else {
        [self getRandomItemNetwork];
    }
}

- (void)resetView {
    
    for(UILabel *underbar in self.underBarCollection) {
        underbar.hidden = true;
    }
    for(UILabel *text in self.textWordCollection) {
        text.text = @"";
    }
    
    self.answerText.text = @"";
    self.HintView.hidden = YES;
}

- (void)getRandomItemNetwork {
    
    [SVProgressHUD setViewForExtension:self.view];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:120.0/255.0 green:194.0/255.0 blue:222.0/255.0 alpha:0.90]];
    [SVProgressHUD show];
    
    [networkController getRandomItem:OBSERVERNAME2];
}
- (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size
{
    double x = (image.size.width - size.width) / 2.0;
    double y = (image.size.height - size.height) / 2.0;
    
    CGRect cropRect = CGRectMake(x, y, size.height, size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

- (void)loadGameItem {
    //load image from url
    NSURL *url = [NSURL URLWithString:gameItem.imageUrl];
    NSString *ext = [[gameItem.imageUrl componentsSeparatedByString:@"."] lastObject];
   
    //image
    if([ext isEqualToString:@"jpeg"] || [ext isEqualToString:@"bmp"]) {
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        if(data) {
            UIImage *image = [[UIImage alloc]initWithData:data];
            self.imageView.image = [self imageByCroppingImage:image toSize:self.imageView.frame.size];
            self.imageView.image = image;
        }
    }
    // video
    else {
        
        NSURL *url = [NSURL URLWithString:gameItem.imageUrl];
        self.videoController = [[MPMoviePlayerController alloc] init];
        
        [self.videoController setContentURL:url];
        [self.videoController.view setFrame:self.imageView.frame];
        [self.view addSubview:self.videoController.view];
        
        [self.videoController play];
    }
    
    //set profile image
    [self.profile setImage:[[UIImage alloc]initWithData:gameItem.imageData]];
    
    self.name.text = gameItem.name;
    self.hintText.text = gameItem.hint;
    
    //init hint label
    
    if(gameItem.keyword.length <= [self.underBarCollection count]) {
        for(int i=0; i<gameItem.keyword.length; i++) {
            UILabel *underbar = [self.underBarCollection objectAtIndex:i];
            UILabel *text = [self.textWordCollection objectAtIndex:i];
            underbar.hidden = FALSE;
            //text.text = [NSString stringWithFormat:@"%C",[gameItem.keyword characterAtIndex:i]];
        }
    }
}

- (void)registerNotification {
    
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    [sendNotification addObserver:self selector:@selector(solvedTheMonkeyProcess:) name:OBSERVERNAME1 object:nil];
    [sendNotification addObserver:self selector:@selector(getRandomGameProcess:) name:OBSERVERNAME2 object:nil];
    
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
        
        CommonSharedObject *commonSharedObject = [CommonSharedObject sharedInstance];
        NSString *storyboardName = commonSharedObject.storyboardName;
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboardName
                                                                 bundle: nil];
        
        //PVP mode
        if(currentMode==PVPMODE) {
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
        
        //Puzzel mode
        else {
            PuzzelRightViewController* vc = [sb instantiateViewControllerWithIdentifier:@"PuzzelRightViewController"];
            vc.gameItem = gameItem;
            self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
            [self presentViewController:vc animated:YES completion:nil];
            vc.view.alpha = 0;
            [UIView animateWithDuration:1 animations:^{
                vc.view.alpha = 1;
            }];
            
            [self resetView];
            [self performSelector:@selector(getRandomItemNetwork) withObject:nil afterDelay:0.5];
        }
    }
}

- (void)getRandomGameProcess:(NSNotification *)notification { //network notify the result of update request
    
    //do something..
    
    [SVProgressHUD dismiss];
    
    NSDictionary* dict = notification.userInfo;
    
    NSString *result = (NSString*)dict[@"result"];
    NSString *message = (NSString*)dict[@"message"];
    
    if([result isEqualToString:@"error"]) { // if update failed
        
        //show pop up
        
        NSLog(@"Error Message=%@",message);
    }
    else {
        
        NSMutableArray *randomGame = (NSMutableArray*)dict[@"gameItem"];
        
        // Get user profile info
        gameItem = [[MainTableViewCell alloc] init];
        
        for(NSDictionary *item in randomGame) {
        
            gameItem.gameNo = (NSString*)item[@"gameNo"];
            gameItem.memberNo = (NSString*)item[@"memberNo"];
            gameItem.imageUrl = (NSString*)item[@"imageUrl"];
            gameItem.keyword = (NSString*)item[@"keyword"];
            gameItem.hint = (NSString*)item[@"hint"];
            gameItem.profileUrl = (NSString*)item[@"profileUrl"];
            gameItem.name = (NSString*)item[@"name"];
            rndNumber = (NSString*)item[@"rnd_no"];
        }
        
        NSURL *url = [NSURL URLWithString:gameItem.profileUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        if(data)
            gameItem.imageData = data;
        
        self.navigationItem.title = [NSString stringWithFormat:@"#%@",rndNumber];
        [self loadGameItem];
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
        
        if (self.currentMode==PVPMODE) {
            self.resultType = [NSNumber numberWithInt:0];
            [networkController solveTheMonkey:gameItem.gameNo BananaCount:gameItem.b_count ObserverName:OBSERVERNAME1];
        }
        else {
            [networkController solveTheRandom:rndNumber ObserverName:OBSERVERNAME1];
        }
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
    else {
        int index = hintCount-2;
        if(index < gameItem.keyword.length) {
            UILabel *label = [self.textWordCollection objectAtIndex:index];
            label.text = [self GetChosungAtIndex:gameItem.keyword Index:index];
        }
    }
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
    if (movedUp && self.view.frame.origin.y >=0)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        
        rect.origin.y -= keyboardHeight.height;
        rect.size.height += keyboardHeight.height;
    }
    else if(!movedUp && self.view.frame.origin.y < 0)
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

- (NSString *)GetChosungAtIndex:(NSString *)hanggulString Index:(int)index {
    NSArray *chosung = [[NSArray alloc] initWithObjects:@"ㄱ",@"ㄲ",@"ㄴ",@"ㄷ",@"ㄸ",@"ㄹ",@"ㅁ",@"ㅂ",@"ㅃ",@"ㅅ",@"ㅆ",@"ㅇ",@"ㅈ",@"ㅉ",@"ㅊ",@"ㅋ",@"ㅌ",@"ㅍ",@"ㅎ",nil];
    NSString *textResult = @"";
    NSInteger code = [hanggulString characterAtIndex:index];
    if (code >= 44032 && code <= 55203) {
        NSInteger uniCode = code - 44032;
        NSInteger chosungIndex = uniCode / 21 / 28;
        textResult = [NSString stringWithFormat:@"%@", [chosung objectAtIndex:chosungIndex]];
    }
    
    return textResult;
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

    [networkController solveTheMonkey:gameItem.gameNo BananaCount:@"0" ObserverName:OBSERVERNAME1];
    
}

@end
