/*
 
 Contact editor by memeller@gmail.com
 isSupported function by https://github.com/mateuszmackowiak
 
 */
#import "ContactEditor.h"
#import "ContactEditorHelper.h"
#import "ContactEditorAddContactHelper.h"
#import "ContactEditorViewDetailsHelper.h"
@implementation ContactEditor

ContactEditorHelper *contactEditorHelper;
ContactEditorViewDetailsHelper *contactEditorViewDetailsHelper;
ContactEditorAddContactHelper *contactEditorAddContactHelper;
ABAddressBookRef addressBook;

BOOL createOwnAddressBook(void)
{
    
    __block BOOL isAllowed=NO;
    if (&ABAddressBookCreateWithOptions != NULL) {
        CFErrorRef error = nil;
        switch (ABAddressBookGetAuthorizationStatus()){
            case kABAuthorizationStatusAuthorized:{
                addressBook = ABAddressBookCreateWithOptions(NULL, &error);
                isAllowed=YES;
                break;
            }
            case kABAuthorizationStatusDenied:{
                isAllowed=NO;
                break;
            }
            case kABAuthorizationStatusNotDetermined:{
                addressBook = ABAddressBookCreateWithOptions(NULL, &error);
                ABAddressBookRequestAccessWithCompletion
                (addressBook, ^(bool granted, CFErrorRef error) {
                    if (granted){
                        isAllowed=YES;
                        DLog(@"Access was granted");
                    } else {
                        isAllowed=NO;
                        DLog(@"Access was not granted");
                    }
                    
                });
                break;
            }
            case kABAuthorizationStatusRestricted:{
                isAllowed=NO;
                break;
            }
        }
        addressBook = ABAddressBookCreateWithOptions(NULL,&error);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            // callback can occur in background, address book must be accessed on thread it was created on
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    isAllowed=NO;
                } else if (!granted) {
                    isAllowed=NO;
                } else {
                    isAllowed=YES;
                }
            });
        });
    } else {
        // iOS 4/5
        addressBook = ABAddressBookCreate();
        isAllowed=YES;
    }
    return isAllowed;
}

FREObject showContactDetailsInWindow(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    DLog(@"showing contact details using native window");
    if (!contactEditorViewDetailsHelper) {
        contactEditorViewDetailsHelper = [[ContactEditorViewDetailsHelper alloc] init];
    }
    uint32_t recordId;
    if(FRE_OK==FREGetObjectAsUint32(argv[0], &recordId))
    {
        uint32_t boolean;
        FREGetObjectAsBool(argv[1], &boolean);
        if(createOwnAddressBook())
        {
            ABRecordID abrecordId=recordId;
            ABRecordRef aRecord = ABAddressBookGetPersonWithRecordID(addressBook, abrecordId);
            if(aRecord)
            {
                [contactEditorViewDetailsHelper setContext:ctx];
                [contactEditorViewDetailsHelper showContactDetailsInWindow:aRecord isEditable:boolean];
            }
        }
        
    }
    
    return NULL;    
}
FREObject addContactInWindow(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    DLog(@"adding contact using native window");
    if(createOwnAddressBook())
    {
        if (!contactEditorAddContactHelper) {
            contactEditorAddContactHelper = [[ContactEditorAddContactHelper alloc] init];
        }
    
        [contactEditorAddContactHelper setContext:ctx];
        [contactEditorAddContactHelper addContactInWindow];
    
    }
    return NULL;    
}
FREObject showContactPicker(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    if(createOwnAddressBook())
    {
        if (!contactEditorHelper) {
            contactEditorHelper = [[ContactEditorHelper alloc] init];
        }
    
        [contactEditorHelper setContext:ctx];
        [contactEditorHelper showContactPicker];
    }
    
    
    return NULL;    
}
FREObject removeContact(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject retBool = nil;
    uint32_t boolean=0;
    uint32_t recordId;
    if(FRE_OK==FREGetObjectAsUint32(argv[0], &recordId))
    {
        if(createOwnAddressBook())
        {
            ABRecordID abrecordId=recordId;
            ABRecordRef aRecord = ABAddressBookGetPersonWithRecordID(addressBook, abrecordId);
            if(aRecord)
            {
                DLog(@"record found, trying to remove %i",abrecordId);
                ABAddressBookRemoveRecord(addressBook, aRecord, NULL);
                    // CFRelease(aRecord);
                    boolean=1;
                DLog(@"ContactRemoved");
            }
            if(ABAddressBookHasUnsavedChanges)
                ABAddressBookSave(addressBook, NULL);
            DLog(@"Release");
            CFRelease(addressBook);
            DLog(@"Return data");
        }
    }
    else
        DLog(@"something wrong with value");
    DLog(@"setting returned value");
    FRENewObjectFromBool(boolean, &retBool);
    return retBool;
    
}
FREObject contactEditorIsSupported(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    FREObject retVal;
    if(FRENewObjectFromBool(YES, &retVal) == FRE_OK){
        return retVal;
    }else{
        return nil;
    }
}
FREObject addContact(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    if(createOwnAddressBook())
    {
	uint32_t usernameLength;
    const uint8_t *name;
    uint32_t surnameLength;
    const uint8_t *surname;
    uint32_t usercontactLength;
    const uint8_t *contact;
    uint32_t usercompanyLength;
    const uint8_t *company;
    uint32_t useremailLength;
    const uint8_t *email;
	uint32_t websiteLength;
    const uint8_t *website;
	DLog(@"Parsing data...");
    //Turn our actionscrpt code into native code.
    FREGetObjectAsUTF8(argv[0], &usernameLength, &name);
    FREGetObjectAsUTF8(argv[1], &surnameLength, &surname);
    FREGetObjectAsUTF8(argv[2], &usercontactLength, &contact);
    FREGetObjectAsUTF8(argv[3], &usercompanyLength, &company);
    FREGetObjectAsUTF8(argv[4], &useremailLength, &email);
	FREGetObjectAsUTF8(argv[5], &websiteLength, &website);
    NSString *username = nil;
    NSString *usersurname=nil;
    NSString *usercontact = nil;
    NSString *usercompany = nil;
    NSString *useremail = nil;
    NSString *userwebsite = nil;
    DLog(@"Creating strings");
    //Create NSStrings from CStrings
    if (FRE_OK == FREGetObjectAsUTF8(argv[0], &usernameLength, &name)) {
        username = [NSString stringWithUTF8String:(char*)name];
    }
    if (FRE_OK == FREGetObjectAsUTF8(argv[1], &surnameLength, &name)) {
        usersurname = [NSString stringWithUTF8String:(char*)surname];
    }
    if (FRE_OK == FREGetObjectAsUTF8(argv[2], &usercontactLength, &contact)) {
        usercontact = [NSString stringWithUTF8String:(char*)contact];
    }
    
    if (FRE_OK == FREGetObjectAsUTF8(argv[3], &usercompanyLength, &company)) {
        usercompany = [NSString stringWithUTF8String:(char*)company];
    }
    
    if (argc >= 4 && (FRE_OK == FREGetObjectAsUTF8(argv[4], &useremailLength, &email))) {
        useremail = [NSString stringWithUTF8String:(char*)email];
    }
    
    if (argc >= 5 && (FRE_OK == FREGetObjectAsUTF8(argv[5], &websiteLength, &website))) {
        userwebsite = [NSString stringWithUTF8String:(char*)website];
    }
    
    ABRecordRef aRecord = ABPersonCreate(); 
    CFErrorRef  anError = NULL;
    
    DLog(@"Adding name");
    // Username
    ABRecordSetValue(aRecord, kABPersonFirstNameProperty, (__bridge CFTypeRef)(username), &anError);
    ABRecordSetValue(aRecord, kABPersonLastNameProperty, (__bridge CFTypeRef)(usersurname), &anError);
    // Phone Number.
    if(usercontact)
    {
        DLog(@"Adding phone number");
        ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multi, (__bridge CFStringRef)usercontact, kABWorkLabel, NULL);
        ABRecordSetValue(aRecord, kABPersonPhoneProperty, multi, &anError);
        //    CFRelease(multi);
    }
    // Company
    DLog(@"Adding company");
    if(usercompany)
    {
        ABRecordSetValue(aRecord, kABPersonOrganizationProperty, (__bridge CFTypeRef)(usercompany), &anError);
    }
    //// email
    DLog(@"Adding email");
    if(usercompany)
    {
        ABMutableMultiValueRef multiemail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiemail, (__bridge CFStringRef)useremail, kABWorkLabel, NULL);
        ABRecordSetValue(aRecord, kABPersonEmailProperty, multiemail, &anError);
        //  CFRelease(multiemail);
    }
    // website
    DLog(@"Adding website");
    //DLog(userwebsite);
    if(userwebsite)
    {
        ABMutableMultiValueRef multiweb = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiweb, (__bridge CFStringRef)userwebsite, kABHomeLabel, NULL);
        ABRecordSetValue(aRecord, kABPersonURLProperty, multiweb, &anError);
        //  CFRelease(multiweb);
    }
    // Function
    //ABRecordSetValue(aRecord, kABPersonJobTitleProperty, userrole, &anError);
    CFErrorRef error =nil;
    DLog(@"Writing values");
    
    
    DLog(@"Saving to contacts");
    ABAddressBookAddRecord(addressBook, aRecord, &error);
    if (error != NULL) { 
		
		DLog(@"error while creating..");
	} 
    if(ABAddressBookHasUnsavedChanges)
        ABAddressBookSave(addressBook, &error);
    
    DLog(@"Releasing data");
    //CFRelease(aRecord);
    //[username release];
    //[usersurname release];
    //[usercontact release];
    //[usercompany release];
    //[useremail release];
    //[userwebsite release];
    CFRelease(addressBook);
    }
    return NULL;
}
FREObject hasPermission(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject retVal;
    if(createOwnAddressBook()){
        FRENewObjectFromBool(YES, &retVal);
        CFRelease(addressBook);
        return retVal;
    }else{
        FRENewObjectFromBool(NO, &retVal);
        return retVal;
    }
    
}
FREObject getContactDetails(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    
    uint32_t argrecordId;
    FREObject contact=NULL;
    FRENewObject((const uint8_t*)"Object", 0, NULL, &contact,NULL);
    if(FRE_OK==FREGetObjectAsUint32(argv[0], &argrecordId))
    {
        if(createOwnAddressBook())
        {
        ABRecordID abrecordId=argrecordId;
        ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, abrecordId);
        FREObject retStr=NULL;
        int personId = (int)ABRecordGetRecordID(person);
        DLog(@"Adding person with id: %i",personId);
        FREObject recordId;
        FRENewObjectFromInt32(personId, &recordId);
        FRESetObjectProperty(contact, (const uint8_t*)"recordId", recordId, NULL);
        
        //composite name
        CFStringRef personCompositeName = ABRecordCopyCompositeName(person);
        retStr=NULL;
        if(personCompositeName)
        {
            NSString *personCompositeString = [NSString stringWithString:(__bridge NSString *)personCompositeName];
            DLog(@"Adding composite name: %@",personCompositeString);
            FRENewObjectFromUTF8(strlen([personCompositeString UTF8String])+1, (const uint8_t*)[personCompositeString UTF8String], &retStr);
            FRESetObjectProperty(contact, (const uint8_t*)"compositename", retStr, NULL);
            //[personCompositeString release];
            CFRelease(personCompositeName);
        }
        else
            FRESetObjectProperty(contact, (const uint8_t*)"compositename", retStr, NULL);
        
        retStr=NULL;
        
        
        
        //person first name
        CFStringRef personName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        if(personName)
        {
            NSString *personNameString = [NSString stringWithString:(__bridge NSString *)personName];
            DLog(@"Adding first name: %@",personNameString);
            FRENewObjectFromUTF8(strlen([personNameString UTF8String])+1, (const uint8_t*)[personNameString UTF8String], &retStr);
            FRESetObjectProperty(contact, (const uint8_t*)"name", retStr, NULL);
            //[personNameString release];
            CFRelease(personName);
        }
        else
            FRESetObjectProperty(contact, (const uint8_t*)"name", retStr, NULL);
        retStr=NULL;
        //surname
        CFStringRef personSurName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        if(personSurName)
        {
            NSString *personSurNameString = [NSString stringWithString:(__bridge NSString *)personSurName];
            DLog(@"Adding last name: %@",personSurNameString);
            FRENewObjectFromUTF8(strlen([personSurNameString UTF8String])+1, (const uint8_t*)[personSurNameString UTF8String], &retStr);
            FRESetObjectProperty(contact, (const uint8_t*)"lastname", retStr, NULL);
            //[personSurNameString release];
            CFRelease(personSurName);
        }
        else
            FRESetObjectProperty(contact, (const uint8_t*)"lastname", retStr, NULL);
        retStr=NULL;
        
        //birthdate
        NSDate *personBirthdate = (__bridge NSDate*)ABRecordCopyValue(person, kABPersonBirthdayProperty);
        if(personBirthdate)
        {
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            
            NSString *personBirthdateString = [dateFormatter stringFromDate:personBirthdate];
            DLog(@"Adding birthdate: %@",personBirthdateString);
            FRENewObjectFromUTF8(strlen([personBirthdateString UTF8String])+1, (const uint8_t*)[personBirthdateString UTF8String], &retStr);
            FRESetObjectProperty(contact, (const uint8_t*)"birthdate", retStr, NULL);
            //[personBirthdateString release];
            //[dateFormatter release];
            //CFRelease(personBirthdate);
        }
        else
            FRESetObjectProperty(contact, (const uint8_t*)"birthdate", retStr, NULL);
        
        //emails
        retStr=NULL;
        FREObject emailsArray = NULL;
        FRENewObject((const uint8_t*)"Array", 0, NULL, &emailsArray, nil);
        
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        if(emails)
        {
            for (CFIndex k=0; k < ABMultiValueGetCount(emails); k++) {
                NSString* email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emails, k);
                DLog(@"Adding email: %@",email);
                FRENewObjectFromUTF8(strlen([email UTF8String])+1, (const uint8_t*)[email UTF8String], &retStr);
                FRESetArrayElementAt(emailsArray, k, retStr);
                //[email release];
            }
            CFRelease(emails);
            FRESetObjectProperty(contact, (const uint8_t*)"emails", emailsArray, NULL);
        }
        else
            FRESetObjectProperty(contact, (const uint8_t*)"emails", NULL, NULL);
        retStr=NULL;
        //phones
        FREObject phonesArray = NULL;
        FRENewObject((const uint8_t*)"Array", 0, NULL, &phonesArray, nil);
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        if(phones)
        {
            for (CFIndex k=0; k < ABMultiValueGetCount(phones); k++) {
                NSString* phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, k);
                DLog(@"Adding phone: %@",phone);
                FRENewObjectFromUTF8(strlen([phone UTF8String])+1, (const uint8_t*)[phone UTF8String], &retStr);
                FRESetArrayElementAt(phonesArray, k, retStr);
                //[phone release];
                
            }
            CFRelease(phones);
            FRESetObjectProperty(contact, (const uint8_t*)"phones", phonesArray, NULL);            
        }
        else
            FRESetObjectProperty(contact, (const uint8_t*)"phones", NULL, NULL);
        retStr=NULL;
        FREObject addressesArray = NULL;
        FRENewObject((const uint8_t*)"Array", 0, NULL, &addressesArray, nil);
        ABMultiValueRef addresses = ABRecordCopyValue(person, kABPersonAddressProperty);
        if(addresses)
        {
            DLog(@"found addresses");
            int32_t addressNum=0;
            for (CFIndex k = 0; k<ABMultiValueGetCount(addresses);k++){
                DLog(@"found address %i",addressNum);
                 FREObject addressObj=NULL;
                FRENewObject((const uint8_t*)"Object", 0, NULL, &addressObj,NULL);
                CFDictionaryRef dict = ABMultiValueCopyValueAtIndex(addresses, k);
                CFStringRef typeTmp = ABMultiValueCopyLabelAtIndex(addresses, k);
                CFStringRef labeltype = ABAddressBookCopyLocalizedLabel(typeTmp);
                if(labeltype)
                    FRENewObjectFromUTF8(strlen([(__bridge NSString *)labeltype UTF8String])+1, (const uint8_t*)[(__bridge NSString *)labeltype UTF8String], &retStr);
                FRESetObjectProperty(addressObj, (const uint8_t*)"type", retStr, NULL);
                retStr=NULL;
                NSString *street = [(NSString *)CFDictionaryGetValue(dict, kABPersonAddressStreetKey) copy];
                if(street)
                 FRENewObjectFromUTF8(strlen([street UTF8String])+1, (const uint8_t*)[street UTF8String], &retStr);
                FRESetObjectProperty(addressObj, (const uint8_t*)"street", retStr, NULL);
                retStr=NULL;
                NSString *city = [(NSString *)CFDictionaryGetValue(dict, kABPersonAddressCityKey) copy];
                if(city)
                FRENewObjectFromUTF8(strlen([city UTF8String])+1, (const uint8_t*)[city UTF8String], &retStr);
                FRESetObjectProperty(addressObj, (const uint8_t*)"city", retStr, NULL);
                retStr=NULL;  
                NSString *state = [(NSString *)CFDictionaryGetValue(dict, kABPersonAddressStateKey) copy];
                if(state)
                    FRENewObjectFromUTF8(strlen([state UTF8String])+1, (const uint8_t*)[state UTF8String], &retStr);
                FRESetObjectProperty(addressObj, (const uint8_t*)"state", retStr, NULL);
                retStr=NULL;  
                NSString *zip = [(NSString *)CFDictionaryGetValue(dict, kABPersonAddressZIPKey) copy];
                if(zip)
                    FRENewObjectFromUTF8(strlen([zip UTF8String])+1, (const uint8_t*)[zip UTF8String], &retStr);
                FRESetObjectProperty(addressObj, (const uint8_t*)"zip", retStr, NULL);
                retStr=NULL;  
                NSString *country = [(NSString *)CFDictionaryGetValue(dict, kABPersonAddressCountryKey) copy];
                if(country)
                    FRENewObjectFromUTF8(strlen([country UTF8String])+1, (const uint8_t*)[country UTF8String], &retStr);
                FRESetObjectProperty(addressObj, (const uint8_t*)"country", retStr, NULL);
                retStr=NULL;  
               
                FRESetArrayElementAt(addressesArray, k, addressObj);
                //[street release];
                //[city release];
                //[state release];
                //[zip release];
                //[country release];
                CFRelease(dict);
                CFRelease(labeltype);
                CFRelease(typeTmp);
                addressNum++;
            }
            CFRelease(addresses);
        
        }
            FRESetObjectProperty(contact, (const uint8_t*)"addresses", addressesArray, NULL);
        
        CFRelease(addressBook);
        }
    }
    return contact;
}
FREObject getBitmapDimensions(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    uint32_t argrecordId;
    FREObject size=NULL;
    FRENewObject((const uint8_t*)"flash.geom.Point", 0, NULL, &size,NULL);
    if(FRE_OK==FREGetObjectAsUint32(argv[0], &argrecordId))
    {
        if(createOwnAddressBook())
        {
        ABRecordID abrecordId=argrecordId;
        ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, abrecordId);
        
        
        if (ABPersonHasImageData(person))
        {
            DLog(@"found image");
            UIImage *image;
            //iOS 4.1 and before from http://goddess-gate.com/dc2/index.php/post/421
            if ( &ABPersonCopyImageDataWithFormat != nil ) {
                // iOS >= 4.1
                image= [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)];
            } else {
                // iOS < 4.1
                image= [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageData(person)];
            }
            
            //FREReleaseByteArray( objectByteArray );
            UIGraphicsEndImageContext();
            
            // Now we'll pull the raw pixels values out of the image data
            CGImageRef imageRef = [image CGImage];
            NSUInteger width = CGImageGetWidth(imageRef);
            NSUInteger height = CGImageGetHeight(imageRef);
            DLog(@"found image with dimensions %i, %i",width,height);
            
            CFRelease(addressBook);
            FREObject temp;
            FRENewObjectFromUint32(width, &temp);
            FRESetObjectProperty(size, (const uint8_t*)"x", temp, NULL);
            FRENewObjectFromUint32(height, &temp);
            FRESetObjectProperty(size, (const uint8_t*)"y", temp, NULL);
            
        }
    }
    }
    return size;
}
FREObject setContactImage(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    uint32_t argrecordId;
    if(FRE_OK==FREGetObjectAsUint32(argv[1], &argrecordId))
    {
        if(createOwnAddressBook())
        {
        ABRecordID abrecordId=argrecordId;
        ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, abrecordId);
        FREBitmapData bitmapData;
        //BitmapData to CGImageRef from http://forums.adobe.com/message/4201451
        FREAcquireBitmapData(argv[0], &bitmapData);
        int width       = bitmapData.width;
        int height      = bitmapData.height;

        
        // make data provider from buffer
        CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData.bits32, (width * height * 4), NULL);
        
        // set up for CGImage creation
        int                     bitsPerComponent    = 8;
        int                     bitsPerPixel        = 32;
        int                     bytesPerRow         = 4 * width;
        CGColorSpaceRef         colorSpaceRef       = CGColorSpaceCreateDeviceRGB();   
        CGBitmapInfo            bitmapInfo;
        
        if( bitmapData.hasAlpha )
        {
            if( bitmapData.isPremultiplied )
                bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst;
            else
                bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaFirst;           
        }
        else
        {
            bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst; 
        }
        
        CGColorRenderingIntent  renderingIntent     = kCGRenderingIntentDefault;
        CGImageRef              imageRef            = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
        UIImage *myImage = [UIImage imageWithCGImage:imageRef];   
        NSData * dataRef = UIImagePNGRepresentation(myImage);
        ABPersonSetImageData(person,(__bridge CFDataRef)dataRef,nil);
        ABAddressBookAddRecord(addressBook, person, nil);
        ABAddressBookSave(addressBook, nil);
        FREReleaseBitmapData(argv[0]);
        CFRelease(addressBook);
        CGColorSpaceRelease(colorSpaceRef);
        CGImageRelease(imageRef);
        CGDataProviderRelease(provider);   
        
    }
    }
        return NULL;
}
FREObject drawToBitmap(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    // grab the AS3 bitmapData object for writing to
    uint32_t argrecordId;
    FREObject contact=NULL;
    FRENewObject((const uint8_t*)"Object", 0, NULL, &contact,NULL);
    if(FRE_OK==FREGetObjectAsUint32(argv[1], &argrecordId))
    {
        if(createOwnAddressBook())
        {
        ABRecordID abrecordId=argrecordId;
        ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, abrecordId);
        
    FREBitmapData bmd;
    FREAcquireBitmapData(argv[0], &bmd);
    
    if (ABPersonHasImageData(person))
    {
        DLog(@"found image");
        UIImage *image;
        //iOS 4.1 and before from http://goddess-gate.com/dc2/index.php/post/421
        if ( &ABPersonCopyImageDataWithFormat != nil ) {
            // iOS >= 4.1
            image= [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)];
        } else {
            // iOS < 4.1
            image= [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageData(person)];
        }
        
        //FREReleaseByteArray( objectByteArray );
    UIGraphicsEndImageContext();
    //drawing uiimage to as3 bitmapdata from http://tyleregeto.com/drawing-ios-uiviews-to-as3-bitmapdata-via-air
    // Now we'll pull the raw pixels values out of the image data
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
        DLog(@"found image with dimensions %i, %i",width,height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Pixel color values will be written here 
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Pixels are now in rawData in the format RGBA8888
    // We'll now loop over each pixel write them into the AS3 bitmapData memory
    int x, y;
    // There may be extra pixels in each row due to the value of
    // bmd.lineStride32, we'll skip over those as needed
    int offset = bmd.lineStride32 - bmd.width;
    int offset2 = bytesPerRow - bmd.width*4;
    int byteIndex = 0;
    uint32_t *bmdPixels = bmd.bits32;
    DLog(@"processing image");
    // NOTE: In this example we are assuming that our AS3 bitmapData and our native UIView are the same dimensions to keep things simple.
    for(y=0; y<bmd.height; y++) {
        for(x=0; x<bmd.width; x++, bmdPixels ++, byteIndex += 4) {
            // Values are currently in RGBA8888, so each colour
            // value is currently a separate number
            int red   = (rawData[byteIndex]);
            int green = (rawData[byteIndex + 1]);
            int blue  = (rawData[byteIndex + 2]);
            int alpha = (rawData[byteIndex + 3]);
            // Combine values into ARGB32
            * bmdPixels = (alpha << 24) | (red << 16) | (green << 8) | blue;
        }
        
        bmdPixels += offset;
        byteIndex += offset2;
    }
    DLog(@"releasing image");
    // free the the memory we allocated
    free(rawData);
      
    // Tell Flash which region of the bitmapData changes (all of it here)
    FREInvalidateBitmapDataRect(argv[0], 0, 0, bmd.width, bmd.height);
    // Release our control over the bitmapData
    FREReleaseBitmapData(argv[0]);
         CFRelease(addressBook);
    }
        }
    }
    return NULL;
}

FREObject getContactsSimple(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    DLog(@"Getting contact data");
    FREObject returnedArray = NULL;
    
    if(createOwnAddressBook())
    {
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    DLog(@"Parsing data");
    FRENewObject((const uint8_t*)"Array", 0, NULL, &returnedArray, nil);
    FRESetArrayLength(returnedArray, CFArrayGetCount(people));
    int32_t j=0;
    FREObject retStr=NULL;
    for (CFIndex i = 0; i < CFArrayGetCount(people); i++) {
        FREObject contact;
        FRENewObject((const uint8_t*)"Object", 0, NULL, &contact,NULL);
        
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        
        //person id
        int personId = (int)ABRecordGetRecordID(person);
        DLog(@"Adding person with id: %i",personId);
        FREObject recordId;
        FRENewObjectFromInt32(personId, &recordId);
        FRESetObjectProperty(contact, (const uint8_t*)"recordId", recordId, NULL);
        
        //composite name
        CFStringRef personCompositeName = ABRecordCopyCompositeName(person);
        retStr=NULL;
        if(personCompositeName)
        {
            NSString *personCompositeString = [NSString stringWithString:(__bridge NSString *)personCompositeName];
            DLog(@"Adding composite name: %@",personCompositeString);
            FRENewObjectFromUTF8(strlen([personCompositeString UTF8String])+1, (const uint8_t*)[personCompositeString UTF8String], &retStr);
            FRESetObjectProperty(contact, (const uint8_t*)"compositename", retStr, NULL);
            //[personCompositeString release];
            CFRelease(personCompositeName);
        }
        else
            FRESetObjectProperty(contact, (const uint8_t*)"compositename", retStr, NULL);
        
        DLog(@"Adding element to array %ld",i);
        FRESetArrayElementAt(returnedArray, j, contact);
        j++;
        CFRelease(person);
    }
    DLog(@"Release");
    CFRelease(addressBook);
    DLog(@"Return data");
    }
    return returnedArray;
}

FREObject getContactCount(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject contactCount;
    
    if(createOwnAddressBook())
    {
        DLog(@"Getting emails");
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
        FRENewObjectFromInt32(CFArrayGetCount(people), &contactCount);
        // create an instance of Object and save it to FREObject position
        DLog(@"Release");
        CFRelease(addressBook);
        DLog(@"Return data");
    }
    else
        FRENewObjectFromInt32(0, &contactCount);
    
    return contactCount;
    
}

// ContextInitializer()
//
// The context initializer is called when the runtime creates the extension context instance.

void ContactEditorContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, 
                                     uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
	
    
	*numFunctionsToTest = 13;
	FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction) * (*numFunctionsToTest));
    
	func[0].name = (const uint8_t*)"addContact";
	func[0].functionData = NULL;
	func[0].function = &addContact;
    func[1].name = (const uint8_t*)"hasPermission";
	func[1].functionData = NULL;
	func[1].function = &hasPermission;
    func[2].name = (const uint8_t*)"getContactCount";
	func[2].functionData = NULL;
	func[2].function = &getContactCount;
    func[3].name = (const uint8_t*)"removeContact";
	func[3].functionData = NULL;
	func[3].function = &removeContact;
    func[4].name = (const uint8_t*)"contactEditorIsSupported";
	func[4].functionData = NULL;
	func[4].function = &contactEditorIsSupported;
    func[5].name = (const uint8_t*)"getContactsSimple";
	func[5].functionData = NULL;
	func[5].function = &getContactsSimple;
    func[6].name = (const uint8_t*)"getContactDetails";
	func[6].functionData = NULL;
	func[6].function = &getContactDetails;
    func[7].name = (const uint8_t*)"pickContact";
	func[7].functionData = NULL;
	func[7].function = &showContactPicker;
    func[8].name = (const uint8_t*)"addContactInWindow";
	func[8].functionData = NULL;
	func[8].function = &addContactInWindow;
    func[9].name = (const uint8_t*)"showContactDetailsInWindow";
	func[9].functionData = NULL;
	func[9].function = &showContactDetailsInWindow;
    func[10].name = (const uint8_t*)"drawToBitmap";
	func[10].functionData = NULL;
	func[10].function = &drawToBitmap;
    func[11].name = (const uint8_t*)"getBitmapDimensions";
	func[11].functionData = NULL;
    func[11].function = &getBitmapDimensions;
    func[12].name = (const uint8_t*)"setContactImage";
	func[12].functionData = NULL;
    func[12].function = &setContactImage;
	*functionsToSet = func;
    DLog(@"Exiting ContactEditorContextInitializer()");
}



// ContextFinalizer()
//
// The context finalizer is called when the extension's ActionScript code
// calls the ExtensionContext instance's dispose() method.
// If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls
// ContextFinalizer().

void ContactEditorContextFinalizer(FREContext ctx) {
	if(contactEditorHelper)
    {
        [contactEditorHelper setContext:NULL];
        contactEditorHelper = nil;
    }
    if(contactEditorAddContactHelper)
    {
        [contactEditorAddContactHelper setContext:NULL];
        contactEditorHelper = nil;
    }
    if(contactEditorViewDetailsHelper)
    {
        [contactEditorViewDetailsHelper setContext:NULL];
        contactEditorViewDetailsHelper = nil;
    }
        // Nothing to clean up.
    
	return;
}



// ExtInitializer()
//
// The extension initializer is called the first time the ActionScript side of the extension
// calls ExtensionContext.createExtensionContext() for any context.

void ContactEditorExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, 
                                 FREContextFinalizer* ctxFinalizerToSet) {
	
  	*extDataToSet = NULL;
	*ctxInitializerToSet = &ContactEditorContextInitializer;
	*ctxFinalizerToSet = &ContactEditorContextFinalizer;
} 



// ExtFinalizer()
//
// The extension finalizer is called when the runtime unloads the extension. However, it is not always called.

void ContactEditorExtFinalizer(void* extData) {
	
    
	// Nothing to clean up.
	
    
    
	return;
}

@end