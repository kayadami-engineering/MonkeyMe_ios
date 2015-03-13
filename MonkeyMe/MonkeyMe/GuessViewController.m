//
//  GuessViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 23..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "GuessViewController.h"

#import "GiveUpPopupVIewController.h"
#import "WYStoryboardPopoverSegue.h"

@interface GuessViewController() <GiveUpPopupDelegate,WYPopoverControllerDelegate>

@end

@implementation GuessViewController
@synthesize hintCount;
@synthesize keyboardHeight;
@synthesize answerText;
@synthesize popoverController;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initView];
    [self setNavigationItem];
    
}

- (void)initView {
    self.hintCount = 0;
    self.HintView.hidden = YES;
    self.AgainView.hidden = YES;
    self.WordViewFrame.layer.borderColor = [UIColor yellowColor].CGColor;
    self.WordViewFrame.layer.borderWidth = 1.0f;
    
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
    
    if ([[answerText text] isEqualToString:@"ans"]) { //answer right
        
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                      bundle:nil];
        UIViewController* vc = [sb instantiateViewControllerWithIdentifier:@"GuessRightViewController"];
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:vc animated:YES completion:nil];
        vc.view.alpha = 0;
        [UIView animateWithDuration:1 animations:^{
            vc.view.alpha = 1;
        }];
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];

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

@end
