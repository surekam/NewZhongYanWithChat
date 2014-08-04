//
//  SKSignatureViewController.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-7-31.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKSignatureViewController.h"

@interface SKSignatureViewController ()
@property (nonatomic, strong) UITextView *signatureTextView;
@end

@implementation SKSignatureViewController
@synthesize signatureContent = _signatureContent;
@synthesize signatureTextView = _signatureTextView;

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
    
    if (System_Version_Small_Than_(7)) {
        UIButton* backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backbtn setFrame:CGRectMake(0, 0, 50, 30)];
        [backbtn setBackgroundImage:Image(@"back") forState:UIControlStateNormal];
        [backbtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
        self.navigationItem.leftBarButtonItem = backItem;
        
        UIButton * doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneBtn setFrame:CGRectMake(0, 0, 50, 30)];
        [doneBtn setImage:Image(@"btn_done") forState:UIControlStateNormal];
        [doneBtn setImage:Image(@"btn_done_blue") forState:UIControlStateHighlighted];
        [doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    }else{
        UIBarButtonItem* backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        self.navigationItem.backBarButtonItem = backItem;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
        self.navigationController.navigationBar.translucent = NO;
    }
    self.navigationItem.title = @"个性签名";
    
    _signatureTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, 320, 200)];
    _signatureTextView.font = [UIFont fontWithName:@"Arial" size:17];
    
    [_signatureTextView setText:_signatureContent];
    [_signatureTextView setKeyboardType:UIKeyboardTypeDefault];
    [_signatureTextView becomeFirstResponder];
    _signatureTextView.contentInset = UIEdgeInsetsZero;
    [self.view addSubview:_signatureTextView];
    [self.view setBackgroundColor:COLOR(239, 239, 239)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)done {
    
}

@end
