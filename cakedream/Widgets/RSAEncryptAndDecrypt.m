#import "RSAEncryptAndDecrypt.h" 
//#import "DESEncryptAndDecrypt.h"
#import <Security/SecBase.h>

static const size_t KEY_SIZE = 1024;
static const size_t BUFFER_SIZE = 512; 
static const size_t CIPHER_BUFFER_SIZE = 1024; 
static const uint32_t PADDING = kSecPaddingPKCS1; 
static const UInt8 publicKeyIdentifier[] = "cn.com.newcom.xingxuntong.publickey/0"; 
static const UInt8 privateKeyIdentifier[] = "cn.com.newcom.xingxuntong.privatekey/0"; 
static const UInt8 passKeyIdentifier[] = "wanghaifeng/0";
static NSString *_key = @"12345678";

static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short _base64DecodingTable[256] = {
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
	52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
	-2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
	15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
	-2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
	41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};

 
@implementation RSAEncryptAndDecrypt 

@synthesize symmetricKey;

static RSAEncryptAndDecrypt * __sharedRSAEncryptAndDecrypt = nil;

#pragma mark - 生命周期
+ (RSAEncryptAndDecrypt *)sharedRSAEncryptAndDecrypt {
    @synchronized(self) {
        if (__sharedRSAEncryptAndDecrypt == nil) {
            [[self alloc] init];
        }
    }
    return __sharedRSAEncryptAndDecrypt;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (__sharedRSAEncryptAndDecrypt == nil) {
            __sharedRSAEncryptAndDecrypt = [super allocWithZone:zone];
            return __sharedRSAEncryptAndDecrypt;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)release {
}

- (id)retain {
    return self;
}

- (id)autorelease {
    return self;
}

- (NSUInteger)retainCount {
    return UINT_MAX;
}

-(id)init {
    if (self = [super init])
    {
        // Tag data to search for keys.
        privateTag = [[NSData alloc] initWithBytes:privateKeyIdentifier length:sizeof(privateKeyIdentifier)];
        publicTag = [[NSData alloc] initWithBytes:publicKeyIdentifier length:sizeof(publicKeyIdentifier)];
        passTag = [[NSData alloc] initWithBytes:passKeyIdentifier length:sizeof(passKeyIdentifier)];
    }
	
	return self;
}
- (void)dealloc {
    [privateTag release];
    [publicTag release];
	[passTag release];
	[super dealloc];
}

#pragma mark - 编码方法
- (NSString *) md5:(NSString *)str

{
    
	const char *cStr = [str UTF8String];
    
	unsigned char result[CC_MD5_DIGEST_LENGTH];
    
	CC_MD5( cStr, strlen(cStr), result );
    
	return [NSString 
            
			stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            
			result[0], result[1],
            
			result[2], result[3],
            
			result[4], result[5],
            
			result[6], result[7],
            
			result[8], result[9],
            
			result[10], result[11],
            
			result[12], result[13],
            
			result[14], result[15]
            
			];
    
}

- (NSString *)encodeBase64WithData:(const char *)objData intLength:(int)intLength {
	const unsigned char * objRawData = objData;
	char * objPointer;
	char * strResult;
    
	// Get the Raw Data length and ensure we actually have data
	//int intLength = [objData length];
	if (intLength == 0) return nil;
    
	// Setup the String-based Result placeholder and pointer within that placeholder
	//strResult = (char *)calloc(((intLength + 2) / 3) * 4, sizeof(char));
    
    strResult = malloc( ((intLength + 2) / 3) * 4 * sizeof(char) );
	memset((void *)strResult, 0x0, ((intLength + 2) / 3) * 4);
    objPointer = strResult;
    
	// Iterate through everything
	while (intLength > 2) { // keep going until we have less than 24 bits
		*objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
		*objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
		*objPointer++ = _base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
		*objPointer++ = _base64EncodingTable[objRawData[2] & 0x3f];
        
		// we just handled 3 octets (24 bits) of data
		objRawData += 3;
		intLength -= 3;
	}
    
	// now deal with the tail end of things
	if (intLength != 0) {
		*objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
		if (intLength > 1) {
			*objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
			*objPointer++ = _base64EncodingTable[(objRawData[1] & 0x0f) << 2];
			*objPointer++ = '=';
		} else {
			*objPointer++ = _base64EncodingTable[(objRawData[0] & 0x03) << 4];
			*objPointer++ = '=';
			*objPointer++ = '=';
		}
	}
    
	// Terminate the string-based result
	*objPointer = '\0';
    
    NSString * returnResult = [NSString stringWithCString:strResult encoding:NSASCIIStringEncoding];
    if (strResult) {
        free(strResult);
    }
	// Return the results as an NSString object
	return [returnResult copy];
}

/*- (NSString *)encodeBase64WithData:(NSData *)objData {
	const unsigned char * objRawData = [objData bytes];
	char * objPointer;
	char * strResult;
    
	// Get the Raw Data length and ensure we actually have data
	int intLength = [objData length];
	if (intLength == 0) return nil;
    
	// Setup the String-based Result placeholder and pointer within that placeholder
	//strResult = (char *)calloc(((intLength + 2) / 3) * 4, sizeof(char));
    
    strResult = malloc( ((intLength + 2) / 3) * 4 * sizeof(char) );
	memset((void *)strResult, 0x0, ((intLength + 2) / 3) * 4);
    objPointer = strResult;
    
	// Iterate through everything
	while (intLength > 2) { // keep going until we have less than 24 bits
		*objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
		*objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
		*objPointer++ = _base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
		*objPointer++ = _base64EncodingTable[objRawData[2] & 0x3f];
        
		// we just handled 3 octets (24 bits) of data
		objRawData += 3;
		intLength -= 3;
	}
    
	// now deal with the tail end of things
	if (intLength != 0) {
		*objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
		if (intLength > 1) {
			*objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
			*objPointer++ = _base64EncodingTable[(objRawData[1] & 0x0f) << 2];
			*objPointer++ = '=';
		} else {
			*objPointer++ = _base64EncodingTable[(objRawData[0] & 0x03) << 4];
			*objPointer++ = '=';
			*objPointer++ = '=';
		}
	}
    
	// Terminate the string-based result
	*objPointer = '\0';
    
    NSString * returnResult = [NSString stringWithCString:strResult encoding:NSASCIIStringEncoding];
    if (strResult) {
        free(strResult);
    }
	// Return the results as an NSString object
	return [returnResult copy];
}*/
- (NSString*) encodeBase64WithData:(NSData *)data
{
//    static char base64EncodingTable[64] = {
//        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
//        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
//        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
//        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
//    };
    int length = [data length];
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length]; 
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0; 
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0) 
            break;        
        for (i = 0; i < 3; i++) { 
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1: 
                ctcopy = 2; 
                break;
            case 2: 
                ctcopy = 3; 
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", _base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }     
    return result;
}

- (NSData*) decodeBase64WithString:(NSString *)string
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[4];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil) {
        return [NSData data];
    }
    
    ixtext = 0;
    
    tempcstring = (const unsigned char *)[string UTF8String];
    
    lentext = [string length];
    
    theData = [NSMutableData dataWithCapacity: lentext];
    
    ixinbuf = 0;
    
    while (true) {
        if (ixtext >= lentext){
            break;
        }
        
        ch = tempcstring [ixtext++];
        
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z')) {
            ch = ch - 'A';
        } else if ((ch >= 'a') && (ch <= 'z')) {
            ch = ch - 'a' + 26;
        } else if ((ch >= '0') && (ch <= '9')) {
            ch = ch - '0' + 52;
        } else if (ch == '+') {
            ch = 62;
        } else if (ch == '=') {
            flendtext = true;
        } else if (ch == '/') {
            ch = 63;
        } else {
            flignore = true; 
        }
        
        if (!flignore) {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext) {
                if (ixinbuf == 0) {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2)) {
                    ctcharsinbuf = 1;
                } else {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4) {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++) {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak) {
                break;
            }
        }
    }
    
    return theData;
}
/*
- (NSData *)decodeBase64WithString:(NSString *)strBase64 {
	const char * objPointer = [strBase64 cStringUsingEncoding:NSASCIIStringEncoding];
	int intLength = strlen(objPointer);
	int intCurrent;
	int i = 0, j = 0, k;
    
	unsigned char * objResult;
	//objResult = calloc(intLength, sizeof(char));
    objResult = malloc(intLength * sizeof(char));
	memset((void *)objResult, 0x0, intLength);
    
	// Run through the whole string, converting as we go
	while ( ((intCurrent = *objPointer++) != '\0') && (intLength-- > 0) ) {
		if (intCurrent == '=') {
			if (*objPointer != '=' && ((i % 4) == 1)) {// || (intLength > 0)) {
				// the padding character is invalid at this point -- so this entire string is invalid
				free(objResult);
				return nil;
			}
			continue;
		}
        
		intCurrent = _base64DecodingTable[intCurrent];
		if (intCurrent == -1) {
			// we're at a whitespace -- simply skip over
			continue;
		} else if (intCurrent == -2) {
			// we're at an invalid character
			free(objResult);
			return nil;
		}
        
		switch (i % 4) {
			case 0:
				objResult[j] = intCurrent << 2;
				break;
                
			case 1:
				objResult[j++] |= intCurrent >> 4;
				objResult[j] = (intCurrent & 0x0f) << 4;
				break;
                
			case 2:
				objResult[j++] |= intCurrent >>2;
				objResult[j] = (intCurrent & 0x03) << 6;
				break;
                
			case 3:
				objResult[j++] |= intCurrent;
				break;
		}
		i++;
	}
    
	// mop things up if we ended on a boundary
	k = j;
	if (intCurrent == '=') {
		switch (i % 4) {
			case 1:
				// Invalid state
				free(objResult);
				return nil;
                
			case 2:
				k++;
				// flow through
			case 3:
				objResult[k] = 0;
		}
	}
    
	// Cleanup and setup the return NSData
	NSData * objData = [[NSData alloc] initWithBytes:objResult length:j];
	if (objResult) {
        free(objResult);
    } 
	return [objData copy];
}*/

#pragma mark - RSA

- (int)derEncodingGetSizeFrom:(NSData*)buf at:(int*)iterator 
{ 
    const uint8_t* data = [buf bytes]; 
    int itr = *iterator; 
    int num_bytes = 1; 
    int ret = 0; 
    
    if (data[itr] > 0x80) { 
        num_bytes = data[itr] - 0x80; 
        itr++; 
    } 
    
    for (int i = 0 ; i < num_bytes; i++) ret = (ret * 0x100) + data[itr + i]; 
    
    *iterator = itr + num_bytes; 
    return ret; 
} 

- (NSData *)getPublicKeyBits {
	OSStatus sanityCheck = noErr;
	NSData * publicKeyBits = nil;
	
	NSMutableDictionary * queryPublicKey = [[NSMutableDictionary alloc] init];
    
	// Set the public key query dictionary.
	[queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
	[queryPublicKey setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
	[queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
	[queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnData];
    
	// Get the key bits.
	sanityCheck = SecItemCopyMatching((__bridge CFDictionaryRef)queryPublicKey, (CFTypeRef *)&publicKeyBits);
    
	if (sanityCheck != noErr)
	{
		publicKeyBits = nil;
	}
    
	[queryPublicKey release];
    /*NSLog(@"lenght: %lu", sizeof(publicKeyBits));
     NSLog(@"lenght: %lu", sizeof(passKeyIdentifier));
     
     NSData * result = [NSData dataWithBytes:publicKeyBits length:sizeof(publicKeyBits)];*/
	return [publicKeyBits copy];
}

- (NSData *)getPublicKeyExp 
{ 
    NSData* pk = [self getPublicKeyBits]; 
    if (pk == NULL) return NULL; 
    
    int iterator = 0; 
    
    iterator++; // TYPE - bit stream - mod + exp 
    [self derEncodingGetSizeFrom:pk at:&iterator]; // Total size 
    
    iterator++; // TYPE - bit stream mod 
    int mod_size = [self derEncodingGetSizeFrom:pk at:&iterator]; 
    iterator += mod_size; 
    
    iterator++; // TYPE - bit stream exp 
    int exp_size = [self derEncodingGetSizeFrom:pk at:&iterator]; 
    
    return [[pk subdataWithRange:NSMakeRange(iterator, exp_size)] copy]; 
} 

- (NSData *)getPublicKeyMod 
{ 
    NSData* pk = [self getPublicKeyBits]; 
    if (pk == NULL) return NULL; 
    
    int iterator = 0; 
    
    iterator++; // TYPE - bit stream - mod + exp 
    [self derEncodingGetSizeFrom:pk at:&iterator]; // Total size 
    
    iterator++; // TYPE - bit stream mod 
    int mod_size = [self derEncodingGetSizeFrom:pk at:&iterator]; 
    
    return [[pk subdataWithRange:NSMakeRange(iterator, mod_size)] copy]; 
} 

- (SecKeyRef)getKeyRefWithPersistentKeyRef:(CFTypeRef)persistentRef {
	OSStatus sanityCheck = noErr;
	SecKeyRef keyRef = NULL;
	
	//LOGGING_FACILITY(persistentRef != NULL, @"persistentRef object cannot be NULL." );
	
	NSMutableDictionary * queryKey = [[NSMutableDictionary alloc] init];
	
	// Set the SecKeyRef query dictionary.
	[queryKey setObject:(__bridge id)persistentRef forKey:(__bridge id)kSecValuePersistentRef];
	[queryKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
	
	// Get the persistent key reference.
	sanityCheck = SecItemCopyMatching((__bridge CFDictionaryRef)queryKey, (CFTypeRef *)&keyRef);
	//[queryKey release];
	
	return keyRef;
}

- (void)removePassPublicKey {
	OSStatus sanityCheck = noErr;

	NSMutableDictionary * passPublicKeyAttr = [[NSMutableDictionary alloc] init];
	
	[passPublicKeyAttr setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
	[passPublicKeyAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
	[passPublicKeyAttr setObject:passTag forKey:(__bridge id)kSecAttrApplicationTag];
	
	sanityCheck = SecItemDelete((__bridge CFDictionaryRef) passPublicKeyAttr);

	[passPublicKeyAttr release];
}

- (SecKeyRef)addPassPublicKey:(NSData *)passPublicKey {
	OSStatus sanityCheck = noErr;
	SecKeyRef peerKeyRef = NULL;
	CFTypeRef persistPeer = NULL;
	
	//LOGGING_FACILITY( peerName != nil, @"Peer name parameter is nil." );
	//LOGGING_FACILITY( publicKey != nil, @"Public key parameter is nil." );
	[self removePassPublicKey];
	NSMutableDictionary * passPublicKeyAttr = [[NSMutableDictionary alloc] init];
	
	[passPublicKeyAttr setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
	[passPublicKeyAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
	[passPublicKeyAttr setObject:passTag forKey:(__bridge id)kSecAttrApplicationTag];
	[passPublicKeyAttr setObject:passPublicKey forKey:(__bridge id)kSecValueData];
	[passPublicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnPersistentRef];
	
	sanityCheck = SecItemAdd((__bridge CFDictionaryRef) passPublicKeyAttr, (CFTypeRef *)&persistPeer);
	
	if (persistPeer) {
		peerKeyRef = [self getKeyRefWithPersistentKeyRef:persistPeer];
	} else {
        NSMutableDictionary *queryPublicKey = [[NSMutableDictionary alloc] init]; 
        
        // Set the public key query dictionary. 
        [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass]; 
        [queryPublicKey setObject:passTag forKey:(__bridge id)kSecAttrApplicationTag]; 
        [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType]; 
        [queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef]; 
        
        
        // Get the key. 
        sanityCheck = SecItemCopyMatching((__bridge CFDictionaryRef)queryPublicKey, (CFTypeRef *)&peerKeyRef); 
	}

	if (persistPeer) CFRelease(persistPeer);
    [passPublicKeyAttr release];
	return peerKeyRef;
}

- (NSData *)encryptWithPassKey:(NSData *)plainBuffer keyRef:(SecKeyRef)passKey
{ 
    
    /*NSLog(@"== encryptWithPublicKey()"); 
    
    OSStatus status = noErr; 
    uint8_t * plainData;
	plainData = calloc([plainBuffer length], sizeof(char));
    [plainBuffer getBytes:plainData length:[plainBuffer length]];
    //NSLog(@"** original plain text 0: %s", plainBuffer); 
    
    uint8_t * cipherResult;
    
    size_t plainBufferSize = [plainBuffer length]; 
    size_t cipherBufferSize = CIPHER_BUFFER_SIZE; 
    
    //NSLog(@"SecKeyGetBlockSize() public = %lu", SecKeyGetBlockSize([self getPassKeyRef])); 
    //  Error handling 
    // Encrypt using the public. 
    status = SecKeyEncrypt(passKey, 
                           PADDING, 
                           plainData, 
                           plainBufferSize, 
                           &cipherResult[0], 
                           &cipherBufferSize 
                           ); 
    free(plainData);
    return [[NSData dataWithBytes:cipherResult length:cipherBufferSize] copy];
    //NSLog(@"encryption result code: %ld (size: %lu)", status, cipherBufferSize); 
    //NSLog(@"encrypted text: %s", cipherBuffer); */
    OSStatus sanityCheck = noErr;
	size_t cipherBufferSize = 0;
	size_t keyBufferSize = 0;
	
	NSData * cipher = nil;
	uint8_t * cipherBuffer = NULL;
	
	// Calculate the buffer sizes.
	cipherBufferSize = SecKeyGetBlockSize(passKey);
	keyBufferSize = [plainBuffer length];

	
	// Allocate some buffer space. I don't trust calloc.
    //cipherBuffer = calloc(cipherBufferSize, sizeof(uint8_t));
	cipherBuffer = malloc( cipherBufferSize * sizeof(uint8_t) );
	memset((void *)cipherBuffer, 0x0, cipherBufferSize);
	
	// Encrypt using the public key.
	sanityCheck = SecKeyEncrypt(	passKey,
                                PADDING,
                                (const uint8_t *)[plainBuffer bytes],
                                keyBufferSize,
                                cipherBuffer,
                                &cipherBufferSize
								);
	
	//LOGGING_FACILITY1( sanityCheck == noErr, @"Error encrypting, OSStatus == %d.", sanityCheck );
	
	// Build up cipher text blob.
	cipher = [NSData dataWithBytes:(const void *)cipherBuffer length:(NSUInteger)cipherBufferSize];
	
	if (cipherBuffer) free(cipherBuffer);
	
	return [cipher copy];
} 

-(SecKeyRef)getPublicKeyRef {  
    
    OSStatus sanityCheck = noErr;  
    SecKeyRef publicKeyReference = NULL; 
 
    NSMutableDictionary *queryPublicKey = [[NSMutableDictionary alloc] init]; 
    
    // Set the public key query dictionary. 
    [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass]; 
    [queryPublicKey setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag]; 
    [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType]; 
    [queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef]; 
    
    
    // Get the key. 
    sanityCheck = SecItemCopyMatching((__bridge CFDictionaryRef)queryPublicKey, (CFTypeRef *)&publicKeyReference); 
    
    
    if (sanityCheck != noErr) 
    { 
        publicKeyReference = NULL; 
    } 

    return publicKeyReference; 
} 

- (SecKeyRef)getPrivateKeyRef { 
    OSStatus resultCode = noErr; 
    SecKeyRef privateKeyReference = NULL; 
    
    NSMutableDictionary * queryPrivateKey = [[NSMutableDictionary alloc] init]; 
    
    // Set the private key query dictionary. 
    [queryPrivateKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass]; 
    [queryPrivateKey setObject:privateTag forKey:(__bridge id)kSecAttrApplicationTag]; 
    [queryPrivateKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType]; 
    [queryPrivateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef]; 
    
    // Get the key. 
    resultCode = SecItemCopyMatching((__bridge CFDictionaryRef)queryPrivateKey, (CFTypeRef *)&privateKeyReference); 
    
    if(resultCode != noErr) 
    { 
        privateKeyReference = NULL; 
    } 
    
    return privateKeyReference; 
} 
 
-(SecKeyRef)getPassKeyRef {  
 
    OSStatus sanityCheck = noErr;  
    SecKeyRef publicKeyReference = NULL; 
  
    NSMutableDictionary *queryPublicKey = [[NSMutableDictionary alloc] init]; 

    // Set the public key query dictionary. 
    [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass]; 
    [queryPublicKey setObject:passTag forKey:(__bridge id)kSecAttrApplicationTag]; 
    [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType]; 
    [queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef]; 


    // Get the key. 
    sanityCheck = SecItemCopyMatching((__bridge CFDictionaryRef)queryPublicKey, (CFTypeRef *)&publicKeyReference); 


    if (sanityCheck != noErr) 
    { 
        publicKeyReference = NULL; 
    } 
 
    return publicKeyReference; 
} 
  
- (void)encryptWithPublicKey:(uint8_t *)plainBuffer cipherBuffer:(uint8_t *)cipherBuffer plainBufferSize:(size_t)plainBufferSize
{  
    OSStatus status = noErr; 
    //size_t plainBufferSize = strlen((char *)plainBuffer); 
    size_t cipherBufferSize = CIPHER_BUFFER_SIZE; 
    //  Error handling 
    // Encrypt using the public. 
    status = SecKeyEncrypt([self getPublicKeyRef], 
                           PADDING, 
                           plainBuffer, 
                           plainBufferSize, 
                           &cipherBuffer[0], 
                           &cipherBufferSize 
                           ); 
} 
 
- (NSData *)decryptWithPrivateKey:(NSData *)cipherBuffer
{ 
    OSStatus sanityCheck = noErr;
	size_t cipherBufferSize = 0;
	size_t keyBufferSize = 0;
	
	NSData * resultData = nil;
	uint8_t * keyBuffer = NULL;
	
	SecKeyRef privateKey = NULL;
	
	privateKey = [self getPrivateKeyRef];
	//LOGGING_FACILITY( privateKey != NULL, @"No private key found in the keychain." );
	
	// Calculate the buffer sizes.
	cipherBufferSize = SecKeyGetBlockSize(privateKey);
	keyBufferSize = [cipherBuffer length];
	
	//LOGGING_FACILITY( keyBufferSize <= cipherBufferSize, @"Encrypted nonce is too large and falls outside multiplicative group." );
	
	// Allocate some buffer space. I don't trust calloc.
    //keyBuffer = calloc(keyBufferSize, sizeof(uint8_t));
	keyBuffer = malloc( keyBufferSize * sizeof(uint8_t) );
	memset((void *)keyBuffer, 0x0, keyBufferSize);
	
	// Decrypt using the private key.
	sanityCheck = SecKeyDecrypt(	privateKey,
                                PADDING,
                                (const uint8_t *) [cipherBuffer bytes],
                                cipherBufferSize,
                                keyBuffer,
                                &keyBufferSize
								);
	
	//LOGGING_FACILITY1( sanityCheck == noErr, @"Error decrypting, OSStatus == %d.", sanityCheck );
	
	// Build up plain text blob.
	resultData = [NSData dataWithBytes:(const void *)keyBuffer length:(NSUInteger)keyBufferSize];
	
	if (keyBuffer) free(keyBuffer);
	
	return [resultData copy];
    /*OSStatus status = noErr; 
 
    //size_t cipherBufferSize = strlen((char *)cipherBuffer); 
 
    NSLog(@"decryptWithPrivateKey: length of buffer: %lu", BUFFER_SIZE); 
    NSLog(@"decryptWithPrivateKey: length of input: %lu", cipherBufferSize); 
 
    // DECRYPTION 
    size_t plainBufferSize = BUFFER_SIZE; 
 
    //  Error handling 
    status = SecKeyDecrypt([self getPrivateKeyRef], 
                           PADDING, 
                           &cipherBuffer[0], 
                           cipherBufferSize, 
                           &plainBuffer[0], 
                           &plainBufferSize 
                           ); 
    NSLog(@"decryption result code: %ld (size: %lu)", status, plainBufferSize); 
    NSLog(@"FINAL decrypted text: %s", plainBuffer); */
 
} 

- (NSData *) decryptWithPrivateKeyByRSA:(NSString *)cipherString
{
    NSData * cipherData = [self decodeBase64WithString:cipherString];    
    NSData * resultData = [self decryptWithPrivateKey:cipherData];
    //NSString * resultString = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    return [resultData copy];
}
 
- (void)deleteAsymmetricKeys {
	OSStatus sanityCheck = noErr;
	NSMutableDictionary * queryPublicKey = [[NSMutableDictionary alloc] init];
	NSMutableDictionary * queryPrivateKey = [[NSMutableDictionary alloc] init];
	
	// Set the public key query dictionary.
	[queryPublicKey setObject:(id)kSecClassKey forKey:(id)kSecClass];
	[queryPublicKey setObject:publicTag forKey:(id)kSecAttrApplicationTag];
	[queryPublicKey setObject:(id)kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
	
	// Set the private key query dictionary.
	[queryPrivateKey setObject:(id)kSecClassKey forKey:(id)kSecClass];
	[queryPrivateKey setObject:privateTag forKey:(id)kSecAttrApplicationTag];
	[queryPrivateKey setObject:(id)kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
	
	// Delete the private key.
	sanityCheck = SecItemDelete((CFDictionaryRef)queryPrivateKey);
	//LOGGING_FACILITY1( sanityCheck == noErr || sanityCheck == errSecItemNotFound, @"Error removing private key, OSStatus == %d.", sanityCheck );
	
	// Delete the public key.
	sanityCheck = SecItemDelete((CFDictionaryRef)queryPublicKey);
	//LOGGING_FACILITY1( sanityCheck == noErr || sanityCheck == errSecItemNotFound, @"Error removing public key, OSStatus == %d.", sanityCheck );
	
	[queryPrivateKey release];
	[queryPublicKey release];

}
 
 
- (void)generateKeyPair { 
    OSStatus sanityCheck = noErr; 
    SecKeyRef publicKey = NULL; 
    SecKeyRef privateKey = NULL; 
 
// First delete current keys. 
    [self deleteAsymmetricKeys]; 
 
    // Container dictionaries. 
    NSMutableDictionary * privateKeyAttr = [[NSMutableDictionary alloc] init]; 
    NSMutableDictionary * publicKeyAttr = [[NSMutableDictionary alloc] init]; 
    NSMutableDictionary * keyPairAttr = [[NSMutableDictionary alloc] init]; 
 
    // Set top level dictionary for the keypair. 
    [keyPairAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType]; 
    [keyPairAttr setObject:[NSNumber numberWithUnsignedInteger:KEY_SIZE] forKey:(__bridge id)kSecAttrKeySizeInBits]; 
 
    // Set the private key dictionary. 
    [privateKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent]; 
    [privateKeyAttr setObject:privateTag forKey:(__bridge id)kSecAttrApplicationTag]; 
    // See SecKey.h to set other flag values. 
 
    // Set the public key dictionary. 
    [publicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent]; 
    [publicKeyAttr setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag]; 
    // See SecKey.h to set other flag values. 
 
    // Set attributes to top level dictionary. 
    [keyPairAttr setObject:privateKeyAttr forKey:(__bridge id)kSecPrivateKeyAttrs]; 
    [keyPairAttr setObject:publicKeyAttr forKey:(__bridge id)kSecPublicKeyAttrs]; 
 
    // SecKeyGeneratePair returns the SecKeyRefs just for educational purposes. 
    sanityCheck = SecKeyGeneratePair((__bridge CFDictionaryRef)keyPairAttr, &publicKey, &privateKey); 
    if(sanityCheck == noErr  && publicKey != NULL && privateKey != NULL) 
    { 
    } 
    [privateKeyAttr release]; 
    [publicKeyAttr release]; 
    [keyPairAttr release]; 
    //if (publicKey) CFRelease(publicKey);
	//if (privateKey) CFRelease(privateKey);
} 
 
- (NSString *)getPublicKeyModExp
{
    NSMutableString * sModExp=[[NSMutableString alloc]initWithString:@""];
    [sModExp appendFormat:@"%@%@",
     [self encodeBase64WithData:[self getPublicKeyMod]],
     [self encodeBase64WithData:[self getPublicKeyExp]]];
    NSLog(@"key==%@",sModExp);
    return [sModExp copy];
}



- (void)testAsymmetricEncryptionAndDecryption { 
    
    uint8_t *plainBuffer; 
    uint8_t *cipherBuffer; 
    uint8_t *decryptedBuffer; 
    
    //const char inputString[] = "Mitul bhai and Parth and Devang and Gajendra are iPhone Dev";
    const char inputString[] = "7Ö|®";
    int len = strlen(inputString); 
    if (len > BUFFER_SIZE) len = BUFFER_SIZE-1; 
    
    plainBuffer = (uint8_t *)calloc(BUFFER_SIZE, sizeof(uint8_t)); 
    cipherBuffer = (uint8_t *)calloc(CIPHER_BUFFER_SIZE, sizeof(uint8_t)); 
    decryptedBuffer = (uint8_t *)calloc(BUFFER_SIZE, sizeof(uint8_t)); 
    
    strncpy( (char *)plainBuffer, inputString, len); 
    
    //[self deleteAsymmetricKeys];
    [self generateKeyPair]; 
    
    NSString * publicKeyString = [self encodeBase64WithData:[self getPublicKeyBits]];
    //publicKeyString = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCyMeNHNVIddRJzAugGGWg+ Eecy+3e0qJTFfx3BnsmjwCIKuTWA+NCtwOvojnIIOYTBXiOHTRI0z3sOlWq+ 0LjbwR1IItHIl8C2ibhULpmJvbCMfJYJ1N2OtHxQGyrhfoQoL4Ttd5aEYqlO On8VBWEjRZh3RNNCghtxLA40HwEN7QIDAQAB";
    //NSLog(@"mod:%@",[DESEncryptAndDecrypt encodeBase64WithData:[self getPublicKeyMod]]);
    //NSLog(@"exp:%@",[DESEncryptAndDecrypt encodeBase64WithData:[self getPublicKeyExp]]);
    NSLog(@"publicKeyString: %@",publicKeyString); 
    NSLog(@"init() plainBuffer: %s", plainBuffer); 
    //NSLog(@"init(): sizeof(plainBuffer): %d", sizeof(plainBuffer)); 
    NSData * passKey = [self decodeBase64WithString:publicKeyString];
    //NSData * passKey = [self getPublicKeyBits];
    SecKeyRef passKeyRef = [self addPassPublicKey:passKey];
    NSData * cipherResult = [self encryptWithPassKey:[NSData dataWithBytes:plainBuffer length:strlen(plainBuffer)] keyRef:passKeyRef]; 
    NSLog(@"encrypted data: %@", cipherResult); 
    NSString * cipherString = [self encodeBase64WithData:[NSData dataWithBytes:[cipherResult bytes] length:[cipherResult length]]];
    //NSString * cipherString = @"Qv1whXoiagX93jgMVAihAlrrPAKNxLQZ629pcSSY9CgmX7pl2BC+YjPhP6Nr NqSggApbY4Hb80vclH1NVL4F9l4lDdIwXQwQksQ+B45KarFwvqQRt6e3gugx +mRZCFejjjh7O1PGALx2w2UZ8xhmBNSAQH2NyoJ6FsBv8ADzg74=";
    NSLog(@"cipherString: %@",cipherString);
    NSString * plainString = [self decryptWithPrivateKeyByRSA:cipherString];
    //NSLog(@"init(): sizeof(cipherBuffer): %d", sizeof(cipherBuffer));
    NSData * cipherData = [self decodeBase64WithString:cipherString];
    NSLog(@"encrypted data1: %s", cipherBuffer);
    NSLog(@"encrypted data length1: %lu", strlen(cipherBuffer));
    NSLog(@"encrypted data2: %s", (UInt8 *)[cipherData bytes]);
    NSLog(@"encrypted data length2: %lu", strlen((UInt8 *)[cipherData bytes]));
    NSLog(@"%d",[cipherData length]);
    
    
    unsigned char * objResult;
	objResult = calloc([cipherData length]+1, sizeof(char));
    [cipherData getBytes:objResult length:[cipherData length]];
    objResult[[cipherData length]] = 0;
    NSData * resultData = [self decryptWithPrivateKey:cipherData]; 
    //[self decryptWithPrivateKey:objResult plainBuffer:decryptedBuffer]; 
    //[self decryptWithPrivateKey:cipherBuffer plainBuffer:decryptedBuffer];
    
    NSLog(@"decrypted data: %@", [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding] ); 
    //NSLog(@"init(): sizeof(decryptedBuffer): %d", sizeof(decryptedBuffer)); 
    NSLog(@"====== /second test ======================================="); 
    
    free(plainBuffer); 
    free(cipherBuffer); 
    free(decryptedBuffer); 
}

#pragma mark - DES
//DES 加密  RSA 解密

- (NSString *)doCipher:(NSString *)sTextIn context:(CCOperation)encryptOrDecrypt {
	NSStringEncoding EnC = NSUTF8StringEncoding;
    
    NSMutableData * dTextIn;
    if (encryptOrDecrypt == kCCDecrypt) {
        dTextIn = [[self decodeBase64WithString:sTextIn] mutableCopy];
    }
    else{
        dTextIn = [[sTextIn dataUsingEncoding: EnC] mutableCopy];
    }
    //NSMutableData * dKey = [[sKey dataUsingEncoding:EnC] mutableCopy];
    //[dKey setLength:kCCBlockSizeDES];
    uint8_t *bufferPtr1 = NULL;
    size_t bufferPtrSize1 = 0;
    size_t movedBytes1 = 0;
    //uint8_t iv[kCCBlockSizeDES];
	//memset((void *) iv, 0x0, (size_t) sizeof(iv));
	//Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    Byte iv[] = {1, 9, 8, 2, 0, 7, 0, 5};
    bufferPtrSize1 = ([sTextIn length] + kCCKeySizeDES+100) & ~(kCCKeySizeDES -1);
    bufferPtr1 = malloc(bufferPtrSize1 * sizeof(uint8_t));
    memset((void *)bufferPtr1, 0x00, bufferPtrSize1);
    //bufferPtr1 = calloc(bufferPtrSize1, sizeof(uint8_t));
	CCCryptorStatus returnStatus = CCCrypt(encryptOrDecrypt, // CCOperation op 
                                           kCCAlgorithmDES, // CCAlgorithm alg    
                                           kCCOptionPKCS7Padding, // CCOptions options    
                                           [self.symmetricKey bytes], // const void *key    
                                           [self.symmetricKey length], // size_t keyLength    
                                           iv, // const void *iv    
                                           [dTextIn bytes], // const void *dataIn
                                           [dTextIn length],  // size_t dataInLength    
                                           (void *)bufferPtr1, // void *dataOut    
                                           bufferPtrSize1,     // size_t dataOutAvailable 
                                           &movedBytes1);      // size_t *dataOutMoved  
    if (returnStatus == kCCDecodeError) {
        if(bufferPtr1) free(bufferPtr1);
        //return @"";
        NSException * keyexception = [NSException
                                                      exceptionWithName: @"keyerror"   
                                                      reason: @"keyerror" 
                                                      userInfo: nil];
        //xxtException.exceptionType = 1116;
        @throw keyexception;
    }
    NSString * sResult;
    if (encryptOrDecrypt == kCCDecrypt){
        sResult = [[NSString alloc] initWithBytes:bufferPtr1 length:movedBytes1 encoding:EnC];
        //sResult = [[ NSString alloc] initWithData:[NSData dataWithBytes:bufferPtr1 length:movedBytes1] encoding:EnC];
    }
    else {
        //char * temp = "wanghaifeng\0";
        //NSData *dResult = [[NSData alloc] initWithBytes:temp length:strlen(temp)];
        NSData *dResult = [[NSData alloc] initWithBytes:bufferPtr1 length:movedBytes1];//[NSData dataWithBytes:bufferPtr1 length:movedBytes1];
        //[dResult release];
        sResult = [self encodeBase64WithData:dResult];
        //sResult = [self encodeBase64WithData:bufferPtr1 intLength:bufferPtrSize1];
    }
    if(bufferPtr1) 
    {
        free(bufferPtr1);
        bufferPtr1 = nil;            
    }
    return [sResult copy];
}
/*
- (NSString *)doCipher:(NSString *)sTextIn context:(CCOperation)encryptOrDecrypt 
{
	CCCryptorStatus ccStatus = kCCSuccess;
	// Symmetric crypto reference.
	CCCryptorRef thisEncipher = NULL;
	// Pointer to output buffer.
	uint8_t * bufferPtr = NULL;
	// Total size of the buffer.
	size_t bufferPtrSize = 0;
	// Remaining bytes to be performed on.
	size_t remainingBytes = 0;
	// Number of bytes moved to buffer.
	size_t movedBytes = 0;
	// Length of plainText buffer.
	size_t plainTextBufferSize = 0;
	// Placeholder for total written.
	size_t totalBytesWritten = 0;
	// A friendly helper pointer.
	uint8_t * ptr;
	
    NSStringEncoding EnC = NSUTF8StringEncoding;
    
    NSMutableData * plainText;
    if (encryptOrDecrypt == kCCDecrypt) {
        plainText = [[self decodeBase64WithString:sTextIn] mutableCopy];
    }
    else{
        plainText = [[sTextIn dataUsingEncoding: EnC] mutableCopy];
    }
    uint8_t iv[] = {1, 9, 8, 2, 0, 7, 0, 5};
	// Initialization vector; dummy in this case 0's.
//	uint8_t iv[kChosenCipherBlockSize];
//	memset((void *) iv, 0x0, (size_t) sizeof(iv));
//	
//	LOGGING_FACILITY(plainText != nil, @"PlainText object cannot be nil." );
//	LOGGING_FACILITY(symmetricKey != nil, @"Symmetric key object cannot be nil." );
//	LOGGING_FACILITY(pkcs7 != NULL, @"CCOptions * pkcs7 cannot be NULL." );
//	LOGGING_FACILITY([symmetricKey length] == kChosenCipherKeySize, @"Disjoint choices for key size." );
//    
	plainTextBufferSize = [plainText length];
	
	//LOGGING_FACILITY(plainTextBufferSize > 0, @"Empty plaintext passed in." );
	
	// We don't want to toss padding on if we don't need to
//	if (encryptOrDecrypt == kCCEncrypt) {
//		if (*pkcs7 != kCCOptionECBMode) {
//			if ((plainTextBufferSize % kChosenCipherBlockSize) == 0) {
//				*pkcs7 = 0x0000;
//			} else {
//				*pkcs7 = kCCOptionPKCS7Padding;
//			}
//		}
//	} else if (encryptOrDecrypt != kCCDecrypt) {
//		LOGGING_FACILITY1( 0, @"Invalid CCOperation parameter [%d] for cipher context.", *pkcs7 );
//	} 
	
	// Create and Initialize the crypto reference.
	ccStatus = CCCryptorCreate(	encryptOrDecrypt, 
                               kCCAlgorithmDES, 
                               kCCOptionPKCS7Padding, 
                               (const void *)[symmetricKey bytes], 
                               kCCKeySizeDES, 
                               (const void *)iv, 
                               &thisEncipher
                               );
	
	//LOGGING_FACILITY1( ccStatus == kCCSuccess, @"Problem creating the context, ccStatus == %d.", ccStatus );
	
	// Calculate byte block alignment for all calls through to and including final.
	bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);
	
	// Allocate buffer.
	bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t) );
	
	// Zero out buffer.
	memset((void *)bufferPtr, 0x0, bufferPtrSize);
	
	// Initialize some necessary book keeping.
	
	ptr = bufferPtr;
	
	// Set up initial size.
	remainingBytes = bufferPtrSize;
	
	// Actually perform the encryption or decryption.
	ccStatus = CCCryptorUpdate( thisEncipher,
                               (const void *) [plainText bytes],
                               plainTextBufferSize,
                               ptr,
                               remainingBytes,
                               &movedBytes
                               );
	
	//LOGGING_FACILITY1( ccStatus == kCCSuccess, @"Problem with CCCryptorUpdate, ccStatus == %d.", ccStatus );
	
	// Handle book keeping.
	ptr += movedBytes;
	remainingBytes -= movedBytes;
	totalBytesWritten += movedBytes;
	
	// Finalize everything to the output buffer.
	ccStatus = CCCryptorFinal(	thisEncipher,
                              ptr,
                              remainingBytes,
                              &movedBytes
                              );
	
	totalBytesWritten += movedBytes;
	
	if (thisEncipher) {
		(void) CCCryptorRelease(thisEncipher);
		thisEncipher = NULL;
	}
	
	//LOGGING_FACILITY1( ccStatus == kCCSuccess, @"Problem with encipherment ccStatus == %d", ccStatus );
	
	//cipherOrPlainText = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];
    
	
	NSString * sResult;
    if (encryptOrDecrypt == kCCDecrypt){
        sResult = [[NSString alloc] initWithBytes:bufferPtr length:totalBytesWritten encoding:EnC];
        //sResult = [[ NSString alloc] initWithData:[NSData dataWithBytes:bufferPtr1 length:movedBytes1] encoding:EnC];
    }
    else {
        NSData *dResult = [NSData dataWithBytes:bufferPtr length:totalBytesWritten];
        sResult = [self encodeBase64WithData:dResult];
    }
    
    if (bufferPtr) free(bufferPtr);
    
	return sResult;
	
//	
//	 Or the corresponding one-shot call:
//	 
//	 ccStatus = CCCrypt(	encryptOrDecrypt,
//     kCCAlgorithmAES128,
//     typeOfSymmetricOpts,
//     (const void *)[self getSymmetricKeyBytes],
//     kChosenCipherKeySize,
//     iv,
//     (const void *) [plainText bytes],
//     plainTextBufferSize,
//     (void *)bufferPtr,
//     bufferPtrSize,
//     &movedBytes
//     );
//	 
}
*/ 
@end 
