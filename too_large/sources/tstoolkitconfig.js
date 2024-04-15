//** 환경 설정시 주의사항 ***************************************************************	//
//
// . 인증기관 LDAP 정보 모음 은 LDAP 에서 인증서를 가져올 때 반드시 사용된다.
//
//**************************************************************************************//

//** 기본정보 설정			************************************************************//

// == 인증기관 관련 정보 모음		================================= //
//var CA_LDAP_INFO = "CrossCert:dir.crosscert.com:389|TradeSign:ldap.tradesign.net:389";
//var CA_LDAP_INFO = "KICA:ldap.signgate.com:389|TradeSign:ldap.tradesign.net:389";
var CA_LDAP_INFO = "KISA:dirsys.rootca.or.kr:389|KICA:ldap.signgate.com:389|SignKorea:dir.signkorea.com:389|Yessign:203.233.91.35:389|CrossCert:dir.crosscert.com:389|TradeSign:ldap.tradesign.net:389|NCASign:ds.nca.or.kr:389|";


// == 인증서 정책  관련 		===================================== //
// -- 법인 상호연동용 OID 모음
//var FIRST_COMP_CERT_POLICIES = "1 2 410 200012 1 1 3:전자거래법인서명용|1 2 410 200004 5 1 1 7:전자거래법인서명용|1 2 410 200005 1 1 5:전자거래법인서명용|1 2 410 200004 5 2 1 1:전자거래법인서명용|1 2 410 200004 5 2 1 4:전자거래법인서명용|1 2 410 200004 5 2 1 5:전자거래법인서명용|1 2 410 200004 5 4 1 2:전자거래법인서명용|1 2 410 200012 5 2 1 41:전자거래법인서명용|1 2 410 200012 1 1 3:전자거래법인서명용|1 2 410 200012 5 18 1 11:전자거래법인서명용|1 2 410 200005 1 1 6 8:전자거래법인서명용|1 2 410 200004 5 1 1 9:전자거래법인서명용|1 2 410 200012 5 18 1 11:전자거래법인서명용|1 2 410 200012 5 18 1 71:전자거래법인서명용|";
//var FIRST_COMP_CERT_POLICIES = "1 2 410 200012 1 1 3:범용(법인/단체)|1 2 410 200004 5 1 1 7:범용(법인업무)|1 2 410 200005 1 1 5:범용(기업/법인/단체)|1 2 410 200004 5 2 1 1:1등급(법인)|1 2 410 200004 5 2 1 4:1등급(서버)|1 2 410 200004 5 4 1 2:범용(법인/단체)|1 2 410 200005 1 1 6 8:전자세금계산서용|";
var FIRST_COMP_CERT_POLICIES = "1 2 410 200012 1 1 3:범용(법인/단체)|1 2 410 200004 5 1 1 7:범용(법인업무)|1 2 410 200005 1 1 5:범용(기업/법인/단체)|1 2 410 200004 5 2 1 1:1등급(법인)|1 2 410 200004 5 4 1 2:범용(법인/단체)|";

// -- 개인 상호연동용 OID 모음
var FIRST_INDI_CERT_POLICIES = "1 2 410 200012 1 1 1:전자거래개인서명용|1 2 410 200004 5 1 1 5:전자거래개인서명용|1 2 410 200005 1 1 1:전자거래개인서명용|1 2 410 200005 1 1 4:전자거래개인서명용|1 2 410 200004 5 2 1 1:전자거래개인서명용|1 2 410 200004 5 4 1 1:전자거래개인서명용|";
// -- TradeSign 용도제한용 OID 모음
var TRADESIGN_LIMITED_COMP_CERT_POLICIES = "1 2 410 200012 1 1 9|1 2 410 200012 1 1 10|1 2 410 200012 1 1 15|1 2 410 200012 1 1 16|1 2 410 200012 1 1 201|1 2 410 200012 1 1 202|1 2 410 200012 5 1 1 11|1 2 410 200012 1 1 12|1 2 410 200012 5 1 1 21|1 2 410 200012 1 1 22|1 2 410 200012 5 1 1 31|1 2 410 200012 1 1 32|1 2 410 200012 5 1 1 41|1 2 410 200012 1 1 42|1 2 410 200012 5 1 1 51|1 2 410 200012 1 1 52|1 2 410 200012 5 1 1 61|1 2 410 200012 1 1 62";


// -- 모든 인증서 허용
var ALL_CERT_POLICIES = "";
// ============================================================== //

// == 인증서 저장매체 관련 	===================================== //
var HARD_DISK 		= 0;
var REMOVABLE_DISK 	= 1;
var IC_CARD 		= 2;
var PKCS11	 		= 3;
// ============================================================== //

// == 인증서 Type 관련 		===================================== //
var CERT_TYPE_SIGN 		= 1;
var CERT_TYPE_KM 		= 2;
var DATA_TYPE_PEM		= 0;
var DATA_TYPE_BASE64 	= 1;
// ============================================================== //

// == HASH 알고리즘		========================================= //
var HASH_ID_MD5				= 1;
var HASH_ID_RIPEMD160		= 2;
var HASH_ID_SHA1			= 3;		// 기본적으로 사용함.
var HASH_ID_HAS160			= 4;
// ============================================================== //

// == 대칭키 알고리즘 & 모드	===================================== //
var SYMMETRIC_ID_DES		= 1;
var SYMMETRIC_ID_3DES		= 2;		// 기본적으로 사용함.
var SYMMETRIC_ID_SEED		= 3;
var SYMMETRIC_MODE_ECB		= 1;
var SYMMETRIC_MODE_CBC		= 2;		// 기본적으로 사용함.
var SYMMETRIC_MODE_CFB		= 3;
var SYMMETRIC_MODE_OFB		= 4;
// ============================================================== //

// == 인증서 정보 관련 설정값		================================= //
var CERT_ATTR_VERSION						= 1;
var CERT_ATTR_SERIAL_NUBMER 				= 2;
var CERT_ATTR_SIGNATURE_ALGO_ID 			= 3;
var CERT_ATTR_ISSUER_DN 					= 4;
var CERT_ATTR_SUBJECT_DN 					= 5;
var CERT_ATTR_SUBJECT_PUBLICKEY_ALGO_ID 	= 6;
var CERT_ATTR_VALID_FROM 					= 7;
var CERT_ATTR_VALID_TO 						= 8;
var CERT_ATTR_PUBLIC_KEY 					= 9;
var CERT_ATTR_SIGNATURE 					= 10;
var CERT_ATTR_KEY_USAGE 					= 11;
var CERT_ATTR_AUTORITY_KEY_ID 				= 12;
var CERT_ATTR_SUBJECT_KEY_ID 				= 13;
var CERT_ATTR_EXT_KEY_USAGE 				= 14;
var CERT_ATTR_SUBJECT_ALT_NAME 				= 15;
var CERT_ATTR_BASIC_CONSTRAINT 				= 16;
var CERT_ATTR_POLICY 						= 17;
var CERT_ATTR_CRLDP 						= 18;
var CERT_ATTR_AIA 							= 19;
var CERT_ATTR_VALID 						= 20;
// ============================================================== //

// == 인증서 Type 관련 		===================================== //
var DATA_TYPE_CACERT 		= 1;
var DATA_TYPE_SIGN_CERT 	= 2;
var DATA_TYPE_KM_CERT		= 3;
var DATA_TYPE_CRL	 		= 4;
var DATA_TYPE_ARL	 		= 5;
// ============================================================== //

//**************************************************************************************//

//** 환경 설정				************************************************************//

// 인증서 선택시 기본 매체.
var STORAGE_TYPE = HARD_DISK;

// 보고자하는 인증서 정책 모음.
var POLICIES = ALL_CERT_POLICIES;
var POLICIES1 = FIRST_COMP_CERT_POLICIES;

// 서명시 필요한 Config 조절.
// 서명 생성시 인증서 포함 여부, 0 : 서명자 인증서만 포함.(기본), 1 : 서명자 & CA 인증서 포함.
var INC_CERT_SIGN 		= 0;
// 서명 생성시 CRL 인증서 포함 여부, 0 : 미포함 (기본), 1 : 포함,
var INC_CRL_SIGN		= 0;
// 서명 생성시 서명시간 포함 여부, 0 : 미포함, 1 : 포함(기본)
var INC_SIGN_TIME_SIGN	= 1;
// 서명 생성시 원본데이타 포함 여부 , 0 : 미포함, 1 : 포함(기본)
var INC_CONTENT_SIGN 	= 1;

// 인증서 검증에 필요한 Config 조절
// 사용자 인증서 검증 조건, 0 : CRL 체크 안함. 1 : 현재시간기준으로 유효한 CRL 사용(기본), 2 : 현재 시간기준으로 유효한 CRL 못 구할 시 이전 CRL 사용.
var USING_CRL_CHECK		= 1;
// CA 인증서 검증 조건, 0 : ARL 체크 안함. 1 : 현재시간기준으로 유효한 ARL 사용(기본), 2 : 현재 시간기준으로 유효한 CRL 못 구할 시 이전 ARL 사용.
var USING_ARL_CHECK		= 0;

var CTL_INFO = "";

// Envelop 테스트시 사용하는 상대방 인증서
var pemSignCert, pemSignKey, pemKMCert, pemKMKey;
pemSignCert = "-----BEGIN CERTIFICATE-----MIIE8TCCA9mgAwIBAgIEWWi9YzANBgkqhkiG9w0BAQUFADBOMQswCQYDVQQGEwJLUjESMBAGA1UECgwJVHJhZGVTaWduMRUwEwYDVQQLDAxBY2NyZWRpdGVkQ0ExFDASBgNVBAMMC1RyYWRlU2lnbkNBMB4XDTA2MDcxMzAwMTkzMloXDTA3MDcwNjA0MTE0N1owYTELMAkGA1UEBhMCS1IxEjAQBgNVBAoMCVRyYWRlU2lnbjETMBEGA1UECwwKTGljZW5zZWRDQTEOMAwGA1UECwwFS1RORVQxGTAXBgNVBAMMEO2FjOyKpO2KuChLVE5FVCkwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBANtZJe+enVDx2ujjuVOduML2WonoqQILFbkzEfPalLKbLMLMfGbK1RakMVIR7+zkp4Sg305R9fM6+WH6v1p9i+7yjT3s+sB33h1t+ScwbCRwDYc9qrAIj9JLN/av55rmfLUjliqJj8meyD+61XQEztKvFrrLKRBLdiahabX5fXqdAgMBAAGjggJGMIICQjCBjwYDVR0jBIGHMIGEgBQrdgKuglx97oGRnvWJW7nimVupr6FopGYwZDELMAkGA1UEBhMCS1IxDTALBgNVBAoMBEtJU0ExLjAsBgNVBAsMJUtvcmVhIENlcnRpZmljYXRpb24gQXV0aG9yaXR5IENlbnRyYWwxFjAUBgNVBAMMDUtJU0EgUm9vdENBIDGCAidkMB0GA1UdDgQWBBT2zWzKAmszsJZc3lsv70E7tVz7xjAOBgNVHQ8BAf8EBAMCBsAwegYDVR0gAQH/BHAwbjBsBgkqgxqMmkwBAQMwXzAuBggrBgEFBQcCAjAiHiDHdAAgx3jJncEcspQAIKz1x3jHeMmdwRwAIMeFssiy5DAtBggrBgEFBQcCARYhaHR0cDovL3d3dy50cmFkZXNpZ24ubmV0L2Nwcy5odG1sMFgGA1UdEQRRME+gTQYJKoMajJpECgEBoEAwPgwJ7YWM7Iqk7Yq4MDEwLwYKKoMajJpECgEBATAhMAcGBSsOAwIaoBYEFGWJUmCbyKkY5MbvfKhBZn8Hl8G4MGQGA1UdHwRdMFswWaBXoFWGU2xkYXA6Ly9sZGFwLnRyYWRlc2lnbi5uZXQ6Mzg5L2NuPWNybDFkcDE5LG91PWNybGRwLG91PUFjY3JlZGl0ZWRDQSxvPVRyYWRlU2lnbixjPUtSMEMGCCsGAQUFBwEBBDcwNTAzBggrBgEFBQcwAYYnaHR0cDovL29jc3AudHJhZGVzaWduLm5ldDo4MC9PQ1NQU2VydmVyMA0GCSqGSIb3DQEBBQUAA4IBAQAg4v/4ITv36yyUV1mdwynCxsg9TsUYFZ+P6DSgjfc+KfnzTjS+HYWDobrp/+TalkKOSjjBVDVopiayBezegwg/3tnx01i9LZtpyvTQZJN3CGJu2m+aOGIGKB/GQ6ZmcLd3mRVK/q9kBO+jXJ6ffXlLWVeILVqXDiJzM2CsSmUZr95GqJTIRI8kJ18qg6PvxVEwYO2LuICt1UdZYlW3lHUIizd2SJL3pEjCTIgDXfaShcUY5kw66h4s2lNysAIeShJQFHrpIaAgpJ8P/MJlssRNLrbMSta7eXQSeg1/RhFLhDObSTxe3sw+TcEaUNxr8NFMhInCKA3JB4ZJFr4/HKMo-----END CERTIFICATE-----";
pemSignKey = "-----BEGIN ENCRYPTED PRIVATE KEY-----MIIC/jBIBgkqhkiG9w0BBQ0wOzAbBgkqhkiG9w0BBQwwDgQIMvxtzjSaF+4CAgQAMBwGCCqDGoyaRAEEBBDrmyg4EXUQwhf05DD0ybBPBIICsCYue7d9DhPifZiDtvs1KxZofx6dC4ji10ogVAWvesLDL6f9mTiA2PAav/a+Wr1agf4FmjGHXvAY856JMgFEUj9D9DLg73sSJV76MRykaNqL4G+1KEJL2vLzTSWjvcd+q/B4nhjxH0CLvo9LFyeFrnUvX+69Ys2fg/e4EnW/95Si2Gp7YYARFp6hXhWmQYVjVdoJiGmW+gQDBOiPeQWQOi9+LpThcxUNsX4E4AAjsLrbOMLWXF7/Y8ViPduPPwguJ0vJYfn0x9Fump3Enm77FGOCMnmi0f3GwI4jn/YdvPAUC9vsp5LXRqUzy2epCB0a3IWyMKT82SuLUWFu4BdLkRaMS/N61QagcdRE6zVhOHZeI6fVLM2EdwN9+4W5mClbuG07RWwvbwhK6zuJwXGnzsBFlvtSi05Zr6ofmqxPFrM8uj3qQiiWBD1tBj9TWWFjvwjAjXq5+/D9wrEdI5p0expl5KJoqiEX0xypcoCfzmHakra7g1A6KABSvQxanykTClaehWeOkeoDwFuc/ppQggIHhGKjzRnDFy652FhmzMJW4KhRk2c6kTq8fyjO3Ogg6dKcN0FGQlJwbt+/dAj+mk1Sy5gEYsOWccCnJz6ZIP4jvFWweq1lsTa7U4Qk8h8abM+YeLtbyA9AgcQB1FJQOVw1ONdOiNf7xet1jb6cx2UQrs0rMlqWBZUqXK7lVP3K9wCIvHMW3oRkB8B85jIAUskzwynS3L3+WLkpzQjZz7LbIey9gWruBACCMZzygQHcXTCm5d7LznXCdcXdoDRgozUAmLYGZrJCtU2FBu9TTZJbxGOosBu+xXe5Z/my0k8UHGPIQt40P/kbM4PLa5v5DFMX1367goeQylqP2FQEbDbA7xMHWmxKix5W3vJXfMe1c+5fSsgU56XDXYt8P/sm3Ew=-----END ENCRYPTED PRIVATE KEY-----";
pemKMCert = "-----BEGIN CERTIFICATE-----MIIElzCCA3+gAwIBAgIEWWi9ZDANBgkqhkiG9w0BAQUFADBOMQswCQYDVQQGEwJLUjESMBAGA1UECgwJVHJhZGVTaWduMRUwEwYDVQQLDAxBY2NyZWRpdGVkQ0ExFDASBgNVBAMMC1RyYWRlU2lnbkNBMB4XDTA2MDcxMzAwMTkzMloXDTA3MDcwNjA0MTE0N1owYTELMAkGA1UEBhMCS1IxEjAQBgNVBAoMCVRyYWRlU2lnbjETMBEGA1UECwwKTGljZW5zZWRDQTEOMAwGA1UECwwFS1RORVQxGTAXBgNVBAMMEO2FjOyKpO2KuChLVE5FVCkwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBANkPj+BixUvpQGDv7XIkX2iRs32W+ArkTMdsezU/kY5zE5Nphb8VZKmG2n7JAaejRpqiyWlo1X9rU71fUfqp4uSO05OjDjBy5B0lW/GpXgXnFPCL2WhRfVq8Ck2dYBs/i/9koyDeVme7IE3bxFi9V/p6MWY+T6hkpRDpEnBhM5chAgMBAAGjggHsMIIB6DCBjwYDVR0jBIGHMIGEgBQrdgKuglx97oGRnvWJW7nimVupr6FopGYwZDELMAkGA1UEBhMCS1IxDTALBgNVBAoMBEtJU0ExLjAsBgNVBAsMJUtvcmVhIENlcnRpZmljYXRpb24gQXV0aG9yaXR5IENlbnRyYWwxFjAUBgNVBAMMDUtJU0EgUm9vdENBIDGCAidkMB0GA1UdDgQWBBR/5P1QNi9IB0T+KwEkuoZ05URDLzAOBgNVHQ8BAf8EBAMCBSAwegYDVR0gAQH/BHAwbjBsBgkqgxqMmkwBAQQwXzAuBggrBgEFBQcCAjAiHiDHdAAgx3jJncEcspQAIKz1x3jHeMmdwRwAIMeFssiy5DAtBggrBgEFBQcCARYhaHR0cDovL3d3dy50cmFkZXNpZ24ubmV0L2Nwcy5odG1sMGQGA1UdHwRdMFswWaBXoFWGU2xkYXA6Ly9sZGFwLnRyYWRlc2lnbi5uZXQ6Mzg5L2NuPWNybDFkcDE5LG91PWNybGRwLG91PUFjY3JlZGl0ZWRDQSxvPVRyYWRlU2lnbixjPUtSMEMGCCsGAQUFBwEBBDcwNTAzBggrBgEFBQcwAYYnaHR0cDovL29jc3AudHJhZGVzaWduLm5ldDo4MC9PQ1NQU2VydmVyMA0GCSqGSIb3DQEBBQUAA4IBAQBl/+hLSwmrV4DnYiMMbGIRRWdqYFqpInkIRdvvk2EWvyA5YmCn2SX1AeWc+jVBY+EoFcbRo1uhp2RoEn29A+a3GoH4xLFK3pkVuL8s291RvXaJ0upPquLke4nVAXlBl6aHQjDooVZRfXs0E1se46xvf+F3UmnaPfwqyhfIgme/Z4o4vGt8hOc3pxik29szN/L7+zFREWVLIRAWVlhMhgdugpNjQsBy9gTLxuyZXy4EX5fSmAjlTjDz9QQ9tKGXKksRFX8SONwouMTic1WJ0Ag5m1O9cJUihhmil/7wwIpNFMgQDKSvFs8jJezCLEsd9/kJY1RIScHB8PNzh3CjbNVR-----END CERTIFICATE-----";
pemKMKey = "-----BEGIN ENCRYPTED PRIVATE KEY-----MIICzjBIBgkqhkiG9w0BBQ0wOzAbBgkqhkiG9w0BBQwwDgQI/nKx+7EOmT0CAgQAMBwGCCqDGoyaRAEEBBA/LfH91cY0nxWKjdr7G1j4BIICgEtwN56o7pOGOMFqM/dC9ead2hJJBhMJougT4MNXM8JUSzAKQ0JNRkkHkuzLX+paNwyrLYIIhUjW+pFm1f1iGZWIDDY7FqBHzKQa7lD1IqQToPFjChRH90+Ceg/Ooq1uy1Z4eFTmSSqxGWXh0LfwCfp8sRuAnehrfwxjksPoDtj4NHdWrvHKk7rt+VzHxFW4UV+sZGbEfYp/risbR5fH7rHodrAhIhc0f3MeTx96q8Jry2H/CW62bwm4owbYqiOh6IZlb5aAXfW4eAhi4NZ8S1L3mWUzjqbOB7JmuFju77CsjqE6h5CW4QKdCje874/gDyPcpFNyvPveF8eES39ZrYu8kyW+rXLo/thY0CWEFdfxQ78hI6/+IZGuP9FRCpnxkCUjrLz6Nyftnfiyh3iTYBEaVN5g7ScmTFL1vZcJptw1AZz8dsDrE102gFpirqy2+FWQe96kyNTi2kt7qwFx84yDeoLo0+IdAWEdRfDVFVNkCb9fuI6PRdQs3AowAtl+FoTjqidGsyScsY1whUlb66dyU9DgWrwwl0fTT+dJsmbXiYJ3MrwPWILnjhwFL8myPRkNM8DXo53oSHqdb+NXhdoAoToipe9hs1TqAb6uG+zipVsiVebHoUiFpjUKfUH58rxJowfN/BX594M3Yf+hz+aY47cNJtfG3VlEdxOFBGzdBfD8nM7foInVQ3eb+lEVKZ3mY30j7OblE9S3sm63WxWTaRHZVvCnof1B3Fmjn1bjnua6zkGQ5InLPwS7KT1JXRl3VUTusY+vMZ5ek1+WdkF4LZCW+2kjZae1ixYfDIG6KPUn3c4mWPOH4XX0Pa6eGDcVaRE9iJfQw9w+LZ6m070=-----END ENCRYPTED PRIVATE KEY-----";


//**************************************************************************************//

    function escape_url(url) {
    	var i;
    	var ch;
    	var out = '';
    	var url_string = '';

    	url_string = String(url);

    	for (i = 0; i < url_string.length; i++) {
    		ch = url_string.charAt(i);
    		if (ch == ' ')
    		    out += '%20';
    		else if (ch == '%')
    		    out += '%25';
    		else if (ch == '&')
    		    out += '%26';
    		else if (ch == '+')
    		    out += '%2B';
    		else if (ch == '=')
    		    out += '%3D';
    		else if (ch == '?')
    		    out += '%3F';
    		else
    		    out += ch;
    	}
    	return out;
    }


    //인증서 유효확인
    function verifyCertificate(){
    	var nRet;
    	var certdn, storage;

    	// 모든 Condition 설정.
    	nRet = TSToolkit.SetConfig("", CA_LDAP_INFO, CTL_INFO, POLICIES,
    							INC_CERT_SIGN, INC_SIGN_TIME_SIGN, INC_CRL_SIGN, INC_CONTENT_SIGN,
    							USING_CRL_CHECK, USING_ARL_CHECK);
    	if (nRet > 0)
    	{
    		alert(nRet + " : " + TSToolkit.GetErrorMessage());
    		return false;
    	}

    	// 사용자가 자신의 인증서를 선택.
    	nRet = TSToolkit.SelectCertificate(STORAGE_TYPE, 0, "");
    	if (nRet > 0)
    	{
    		alert("SelectCertificate : " + TSToolkit.GetErrorMessage());
    		return false;
    	}

    	nRet = TSToolkit.GetCertificate(CERT_TYPE_SIGN, DATA_TYPE_PEM);
    	if (nRet > 0)
    	{
    		alert("GetCertificate : " + TSToolkit.GetErrorMessage());
    		return false;
    	}

    	var cert;
    	cert = TSToolkit.OutData

    	nRet = TSToolkit.CertificateValidation(cert);
    	if (nRet > 0)
    	{
    		alert(nRet + " : " + TSToolkit.GetErrorMessage());
    		if (nRet == 141)
    		{
    			var revokedTime;
    			revokedTime = TSToolkit.OutData;
    			alert("폐지 또는 효력정지 시각 : " + revokedTime);
    		}
    		return false;
    	}

    	alert("Sucess!!!");
    	return true;
    }

    // 인증검증
    function CheckIDN(ssn)
    {
    	var nRet, certdn, storage;

    	// 사용자가 자신의 인증서를 선택.
    	// 인증서 검증할 인증서 꺼내오기 위해서만 사용.
    	var loginConf;
    	var myCertDirPath, myCert, myPriKeyInfo;

    	// 모든 Condition 설정.
    	nRet = TSToolkit.SetConfig("", CA_LDAP_INFO, CTL_INFO, POLICIES,
    							INC_CERT_SIGN, INC_SIGN_TIME_SIGN, INC_CRL_SIGN, INC_CONTENT_SIGN,
    							USING_CRL_CHECK, USING_ARL_CHECK);

    	// 사용자가 자신의 인증서를 선택.
    	nRet = TSToolkit.SelectCertificate(STORAGE_TYPE, 0, "");
    	if (nRet > 0)
    	{
    		alert(nRet + " : " + TSToolkit.GetErrorMessage());
    		return false;
    	}

    	nRet = TSToolkit.VerifyVID(ssn);
    	if (nRet > 0)
    	{
    		alert(nRet + " : " + TSToolkit.GetErrorMessage());
    		return false;
    	}

    	if (TSToolkit.OutData != "true")
    	{
    		alert("신원확인불일치");
    		return false;
    	}
    	// 인증서 유효확인
    	//nRet = TSToolkit.GetCertificate(CERT_TYPE_SIGN, DATA_TYPE_PEM);
    	//if (nRet > 0)
    	//{
    	//	alert("GetCertificate : " + TSToolkit.GetErrorMessage());
    	//	return false;
    	//}
    	//
    	//var cert;
    	//cert = TSToolkit.OutData
    	//
    	//nRet = TSToolkit.CertificateValidation(cert);
    	//if (nRet > 0)
    	//{
    	//	alert(nRet + " : " + TSToolkit.GetErrorMessage());
    	//	if (nRet == 141)
    	//	{
    	//		var revokedTime;
    	//		revokedTime = TSToolkit.OutData;
    	//		alert("폐지 또는 효력정지 시각 : " + revokedTime);
    	//	}
    	//	return false;
    	//}

    	// 메모리 정리하기.
		nRet = TSToolkit.ClearMemory();
		if (nRet > 0)
		{
			alert(nRet + " : " + TSToolkit.GetErrorMessage());
			return false;
		}

		alert("Sucess!!!");

    	return true;

    }

    // 암호화
    function Encrypt(obj1, obj2, obj3, type){
    	var nRet;                   // 메소드 결과값
    	var secretKey;              // 대칭키
    	var rawData;                // 암호화 될 값
    	var encryptedData;          // 암호화된 값
    	var nEncryptionAlgorithm;   // 암호 알고리즘
    	var nEncryptionMode;        // 암호 모드

    	if ( type == "N") rawData = del_comma(LRTrim(obj1.value));
    	else rawData = LRTrim(obj1.value);

    	nRet = TSToolkit.SetEncryptionAlgoAndMode(SYMMETRIC_ID_3DES, SYMMETRIC_MODE_CBC);
    	if (nRet > 0) {
    		alert(nRet + " : " + TSToolkit.GetErrorMessage());
    		return false;
    	}

        if (obj2.value == '') {
        	nRet = TSToolkit.GenerateSymmetricKey("");
        	if (nRet > 0)
        	{
        		alert(nRet + " : " + TSToolkit.GetErrorMessage());
        		return false;
        	}

        	secretKey = TSToolkit.OutData;
        	obj2.value = secretKey;
        }
    	nRet = TSToolkit.EncryptData(rawData, secretKey);
    	if (nRet > 0)
    	{
    		alert(nRet + " : " + TSToolkit.GetErrorMessage());
    		return false;
    	}

    	obj3.value = TSToolkit.OutData;
    	return true;
    }

    // 암호화
    function EncryptValue(objValue1, objValue2, type){
    	var nRet;                   // 메소드 결과값
    	var secretKey;              // 대칭키
    	var rawData;                // 암호화 될 값
    	var encryptedData;          // 암호화된 값
    	var nEncryptionAlgorithm;   // 암호 알고리즘
    	var nEncryptionMode;        // 암호 모드

    	if ( type == "N") rawData = del_comma(objValue1);
    	else rawData = objValue1;

    	nRet = TSToolkit.SetEncryptionAlgoAndMode(SYMMETRIC_ID_3DES, SYMMETRIC_MODE_CBC);
    	if (nRet > 0) {
    		alert(nRet + " : " + TSToolkit.GetErrorMessage());
    		return false;
    	}

        if (objValue2 == '') {
    		alert("대칭키가 존재하지 않습니다.");
    		return false;

        }

    	nRet = TSToolkit.EncryptData(rawData, objValue2);
    	if (nRet > 0)
    	{
    		alert(nRet + " : " + TSToolkit.GetErrorMessage());
    		return false;
    	}

    	return TSToolkit.OutData;
    }

    // 복호화
    function Decrypt(obj1, obj2, obj3, type)
    {
    	var nRet;
    	var secretKey;
    	var encryptedData;

    	encryptedData = obj1.value;

    	secretKey = obj2.value;

    	nRet = TSToolkit.DecryptData(encryptedData, secretKey);
    	if (nRet > 0)
    	{
    		alert(nRet + " : " + TSToolkit.GetErrorMessage());
    		return false;
    	}

    	if (type == 'N') obj3.value = add_comma(TSToolkit.OutData);
    	   else obj3.value = TSToolkit.OutData;

    	return true;
    }
    // 복호화2
    function DecryptValue(objValue, keyValue)
    {
    	var nRet;
    	var secretKey;
    	var encryptedData;

    	encryptedData = objValue;

    	secretKey = keyValue;

    	nRet = TSToolkit.DecryptData(encryptedData, secretKey);
    	if (nRet > 0)
    	{
    		alert(nRet + " : " + TSToolkit.GetErrorMessage());
    		return false;
    	}

    	return TSToolkit.OutData;
    }

    function Sign(obj0, obj1, obj2, obj3, obj4)
	{
		var plainText, signMsg;
		var nRet, certdn, storage;

		// 서명할 문자열 데이타 설정.
		//plainText = form.plainText.value;

		// 모든 Condition 설정.
		nRet = TSToolkit.SetConfig("", CA_LDAP_INFO, CTL_INFO, POLICIES,
								INC_CERT_SIGN, INC_SIGN_TIME_SIGN, INC_CRL_SIGN, INC_CONTENT_SIGN,
								USING_CRL_CHECK, USING_ARL_CHECK);
		if (nRet > 0)
		{
			alert(nRet + " : " + TSToolkit.GetErrorMessage());
			return false;
		}

		// 사용자가 자신의 인증서를 선택.
		nRet = TSToolkit.SelectCertificate(STORAGE_TYPE, 0, "");
		if (nRet > 0)
		{
			alert(nRet + " : " + TSToolkit.GetErrorMessage());
			return false;
		}

		nRet = TSToolkit.VerifyVID(obj0.value);
    	if (nRet > 0)
    	{
    		alert(nRet + " : " + TSToolkit.GetErrorMessage());
    		return false;
    	}

    	if (TSToolkit.OutData != "true")
    	{
    		alert("신원확인불일치");
    		return false;
    	}

		nRet = TSToolkit.SignData(obj1.value);
		if (nRet > 0)
		{
			alert(nRet + " : " + TSToolkit.GetErrorMessage());
			return false;
		}

		obj3.value = TSToolkit.OutData;

		nRet = TSToolkit.SignData(obj2.value);
		if (nRet > 0)
		{
			alert(nRet + " : " + TSToolkit.GetErrorMessage());
			return false;
		}

		obj4.value = TSToolkit.OutData;

		return true;
	}

