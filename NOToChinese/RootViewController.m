//
//  RootViewController.m
//  NOToChinese
//
//  Created by lin on 15/4/8.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()<UITextFieldDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    [self CretView];
    
    // Do any additional setup after loading the view.
}

//UI 实现
- (void)CretView
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    //CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat longth = (width - 40);
    
    UITextField * numField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, longth, 30)];
    [numField becomeFirstResponder];
    numField.borderStyle = UITextBorderStyleRoundedRect;
    numField.delegate = self;
    numField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    numField.tag = 100;
    numField.clearButtonMode = YES;
    numField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:numField];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(40, 150,(width - 80),40);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"转换" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    //btn.titleLabel.text = @"转换";
    //btn.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:btn];
    
    UITextField * newField = [[UITextField alloc] initWithFrame:CGRectMake(20, 200, longth, 30)];
    newField.borderStyle = UITextBorderStyleRoundedRect;
    newField.tag = 200;
    newField.userInteractionEnabled = NO;
    [self.view addSubview:newField];
    
    
}

//转换事件
- (void)btnClick:(UIButton *)btn
{
    [self.view endEditing:YES];
    UITextField * num = (UITextField *)[self.view viewWithTag:100];
    UITextField * new = (UITextField *)[self.view viewWithTag:200];
    new.text = [self translation:num.text];
}

//转换功能实现具体代码
- (NSString *)translation:(NSString *)arebic
{
    if (arebic.length == 0) {
        return nil;
    }
    
    for (int i = 0; i < arebic.length; i++) {
        if ([arebic characterAtIndex:i] < '0' || [arebic characterAtIndex:i] > '9') {
            NSLog(@"%@",[arebic substringWithRange:NSMakeRange(i, 1)]);
            NSLog(@"%u",[arebic characterAtIndex:i]);
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"错误，请输入数字" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alert show];
            return nil;
        }
    }
    
    NSString *regex = @"[0-9]";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:arebic] == YES)
    {
        NSLog(@"123");
    }
    
    NSString *str = arebic;
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[str.length -i-1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]])
        {
            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
            {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]])
                {
                    [sums removeLastObject];
                }
            }else
            {
                sum = chinese_numerals[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum])
            {
                continue;
            }
        }
        
        [sums addObject:sum];
    }
    
    NSString *sumStr = [sums  componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
    NSLog(@"%@",str);
    NSLog(@"%@",chinese);
    return chinese;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITextField * new = (UITextField *)[self.view viewWithTag:200];
    new.text = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self btnClick:nil];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
