//
//  ViewController.m
//  iOS-通讯录操作
//
//  Created by zero on 15/11/3.
//  Copyright © 2015年 zerorobot. All rights reserved.
//

#import "ViewController.h"
#import <ContactsUI/ContactsUI.h>
#import <ContactsUI/CNContactPickerViewController.h>
#import <ContactsUI/CNContactViewController.h>

@interface ViewController ()<CNContactPickerDelegate>
@property(nonatomic,strong)CNContactPickerViewController *con;

@end

@implementation ViewController






/**
 *  加载视图
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置视图按钮
    [self setButtons];
}

/**
 *  设置按钮
 */
-(void)setButtons
{
    
    UIButton *button = [[UIButton alloc]initWithFrame:(CGRect){50,100,100,50}];
    [button setTitle:@"通讯录" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    
    [button addTarget:self action:@selector(openContactViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *creatButton = [[UIButton alloc]initWithFrame:(CGRect){50,160,100,50}];
    [creatButton setTitle:@"创建联系人" forState:UIControlStateNormal];
    [creatButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    
    [creatButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [creatButton setBackgroundColor:[UIColor whiteColor]];
    
    [creatButton addTarget:self action:@selector(creataContact:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:creatButton];
    
    UIButton *checkBtn = [[UIButton alloc]initWithFrame:(CGRect){50,220,100,50}];
    [checkBtn setTitle:@"提取联系人" forState:UIControlStateNormal];
    [checkBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    
    [checkBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [checkBtn setBackgroundColor:[UIColor whiteColor]];
    
    [checkBtn addTarget:self action:@selector(checkContact:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkBtn];
}


/**
 *  打开通讯录
 *
 *  @param btn
 */
-(void)openContactViewController:(UIButton*)btn
{

    [self presentViewController:self.con animated:YES completion:nil];
    
}

/**
 *  创建联系人
 *
 *  @param btn btn description
 */
-(void)creataContact:(UIButton*)btn
{
    CNMutableContact *contact = [[CNMutableContact alloc]init];
    // 设置联系人头像
    contact.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"touxiang03"]);
    // 设置联系人姓名
    contact.givenName = @"泽东";
    contact.familyName =  @"毛";
    
    // 设置邮箱
    CNLabeledValue *homnEmail = [CNLabeledValue labeledValueWithLabel:CNLabelHome value:@"21223423@qq.com"];
    CNLabeledValue *workEmail = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:@"2134344@qq.com"];
    
    contact.emailAddresses = @[homnEmail,workEmail];
    
    // 设置联系人电话
    CNLabeledValue *phoneNumber = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:[CNPhoneNumber phoneNumberWithStringValue:@"12344312321"]];
    contact.phoneNumbers = @[phoneNumber];
    
    // 设置联系人地址
    CNMutablePostalAddress *homeAddress = [[CNMutablePostalAddress alloc]init];
    homeAddress.street = @"中山大道西";
    homeAddress.city = @"广州";
    homeAddress.state = @"中国";
    homeAddress.postalCode = @"1212212";
    
    contact.postalAddresses = @[[CNLabeledValue labeledValueWithLabel:CNLabelHome value:homeAddress]];
    
    NSDateComponents * birthday = [[NSDateComponents  alloc]init];
    birthday.day=7;
    birthday.month=5;
    birthday.year=1992;
    contact.birthday=birthday;

    
//     保存联系人
    [self saveContact:contact];
    
//    // 测试展示联系人详情
//    CNContactViewController *detailsVC = [CNContactViewController viewControllerForContact:contact];
//    
//    [self presentViewController:detailsVC animated:YES completion:nil];
}
/**
 *  保存联系人
 *
 *  @param contact
 */
-(void)saveContact:(CNMutableContact*)contact
{
    CNSaveRequest *saveRequest = [[CNSaveRequest alloc]init];
    
    // 添加联系人 // id 可传空
    [saveRequest addContact:contact toContainerWithIdentifier:nil];
    
    // 写入操作
    CNContactStore *store  = [[CNContactStore alloc]init];
    NSError *error ;
    [store executeSaveRequest:saveRequest error:&error];
    if(error)
    {
        NSLog(@"添加联系人失败");
    }else
    {
        NSLog(@"添加联系人成功");
    }
}
/**
 *  获取格式化的联系人姓名
 *
 *  @param contact 联系人对象
 *  @param style   风格：CNContactFormatterStyleFullName/CNContactFormatterStylePhoneticFullName
 *
 *  @return 返回字符串
 */
-(NSString*)getFormatterContactText:(CNContact*)contact WithStyle:(CNContactFormatterStyle)style
{
    NSString *formatter = [CNContactFormatter stringFromContact:contact style:style];
    return formatter;
}
/**
 *  获取格式化的联系人地址
 *
 *  @param homeAddress 地址对象
 *
 *  @return 返回字符串
 */
-(NSString*)getPostalAddressFormatterByContact:(CNPostalAddress*)homeAddress
{
    NSString * foematter =[CNPostalAddressFormatter stringFromPostalAddress:homeAddress style:CNPostalAddressFormatterStyleMailingAddress];
    return foematter;
}

/**
 *  提取联系人
 *
 *  @param btn nil
 */
-(void)checkContact:(UIButton*)btn
{
    CNContactStore *store = [[CNContactStore alloc]init];
    
    // 检索条件，检索所有名字中有XXX联系人
    NSPredicate *predicate = [CNContact predicateForContactsMatchingName:@"泽东"];
    // 提取数据
    NSArray *contacts = [store unifiedContactsMatchingPredicate:predicate  keysToFetch:@[CNContainerNameKey] error:nil];
    
    [contacts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CNContact *contact = (CNContact*)obj;
        
        NSLog(@"--%@",contact);
        
    }];
    
//    // 第二种方法 请求的方式
//    CNContactStore * stroe = [[CNContactStore alloc]init];
//    CNContactFetchRequest * request = [[CNContactFetchRequest alloc]initWithKeysToFetch:@[CNContactPhoneticFamilyNameKey]];
//    [stroe enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
//        NSLog(@"%@",contact);
//    }];
    
}

#pragma mark - CNContactPickerDelegate
/**
 *  视图取消时调用的方法
 *
 *  @param picker
 */
-(void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    NSLog(@"--%s--%d",__FUNCTION__,__LINE__);
}
-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
//    NSLog(@"%@---%@",contact.familyName,contact.identifier);
//    
//    [contact.phoneNumbers enumerateObjectsUsingBlock:^(CNLabeledValue<CNPhoneNumber *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        CNLabeledValue *value= (CNLabeledValue *)obj;
//        
//        CNPhoneNumber *phoneNumber = value.value;
//        
//        
//        NSLog(@"--%@",phoneNumber.stringValue);
//    }];
//    
    [contact.emailAddresses enumerateObjectsUsingBlock:^(CNLabeledValue<NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
        
    }];


    
    
}

/**
 *  响应点击联系人方法
 *
 *  @param picker          non
 *  @param contactProperty non
 */
-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    NSLog(@"--%s--%d",__FUNCTION__,__LINE__);
}

/**
 *  懒加载
 *
 *  @return _con
 */
-(CNContactPickerViewController *)con
{
    if(!_con)
    {
        CNContactPickerViewController *con = [[CNContactPickerViewController alloc]init];
        con.delegate = self;
        _con = con;
    }
    return _con;
}

@end
