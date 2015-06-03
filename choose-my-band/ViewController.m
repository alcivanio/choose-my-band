//
//  ViewController.m
//  choose-my-band
//
//  Created by Alcivanio on 16/09/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _albumImage.layer.cornerRadius = 4;
    _albumImage.clipsToBounds = YES;
    _imageProfile.layer.cornerRadius = 4;
    _imageProfile.clipsToBounds = YES;
    
    CGRect recImgAlbum = _albumImage.frame;
    recImgAlbum.size = CGSizeMake(310, 190);
    _albumImage.frame = recImgAlbum;
    
    //Essa parte retira as bordas do TextView
    self.textAtualiza.textContainer.lineFragmentPadding = 0;
    self.textAtualiza.textContainerInset = UIEdgeInsetsZero;
    
    //Agora vamos deixar apenas o primeiro nome azul
    NSMutableAttributedString *textString =
    [[NSMutableAttributedString alloc]initWithString:self.textAtualiza.text];
    
    NSString *stringNome = [self.textAtualiza.text componentsSeparatedByString:@" "][0];
    
    NSRange rangeUserName = [self.textAtualiza.text rangeOfString:stringNome];
    NSRange rangeAllText = [self.textAtualiza.text rangeOfString:self.textAtualiza.text];
    
    [textString addAttribute:NSForegroundColorAttributeName
    value:[UIColor colorWithRed:77.0f/255.0f green:205.0f/255.0f blue:242.0f/255.0f alpha:1]
    range:rangeUserName];
    
    [textString removeAttribute:NSFontAttributeName range:rangeAllText];
    [textString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:rangeAllText];
    
    [self.textAtualiza setAttributedText:textString];
    
    /*
    NSURL *url =
    [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/p/1/005/07f/0eb/3476406.jpg"];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    
    UIImage *tmpImage = [[UIImage alloc] initWithData:data];
    
    _albumImage.image = tmpImage;*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
