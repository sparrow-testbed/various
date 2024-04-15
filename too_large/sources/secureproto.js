/*!
* AnySign for PC, v1.1.1.0, r1710
*
* For more information on this product, please see
* http://hsecure.co.kr/
*
* Copyright (c) Hancom Secure Co.,Ltd All Rights Reserved.
*
* Date: 2017-10-10
*/
/*
 * Error Message Type : [AnySign4PC][sendApplication][envelopeCreateKeyBlock] ErrorMsg(errorCode)
 */
Secure = (function() {
	var Utils = sofo.utils || {};
	var Crypto = sofo.crypto || {};
	
	if (!Object.create) {
    Object.create = function(o, properties) {
        if (typeof o !== 'object' && typeof o !== 'function') throw new TypeError('Object prototype may only be an Object: ' + o);
        else if (o === null) throw new Error("This browser's implementation of Object.create is a shim and doesn't support 'null' as the first argument.");

        if (typeof properties != 'undefined') throw new Error("This browser's implementation of Object.create is a shim and doesn't support a second argument.");

        function F() {}

        F.prototype = o;

        return new F();
    };
	}
	
	var ErrorCodeList={ 
			"close_notify" : "40000",
			"unexpected_message" : "40010",
			"bad_record_mac" : "40020" ,
			"decryption_failed_RESERVED" : "40021",
			"record_overflow" : "40022",
			"bad_verify_hash" : "40023",		// 해쉬값 검증 실패
			"bad_verify_mac" : "40024",			// 맥값 검증 실패
			"decompression_failure" : "40030",
			"no_certificate_RESERVED" : "40041",
			"bad_certificate" : "40042",		// 잘못된 인증서 포맷
			"unsupported_certificate" : "40043",// 지원 하지 않는 인증서
			"certificate_revoked" : "40044",
			"certificate_expired" : "40045",
			"certificate_unknown" : "40046",	// 알 수 없는 인증서
			"illegal_parameter" : "40047",		// 잘못된 파라미터 전달
			"unknown_ca" : "40048",
			"access_denied" : "40049",
			"decode_error" : "40050",			// 디코드 실패
			"decrypt_error" : "40051",			// 복호화 실패
			//SecurePoto ErrorCode
			"unknown_error" : "41000",			// 알수 없는 에러
			"create_keyBlock_failure" : "41001",// 키블록 생성 실패
			"generatorRandom_fail" : "41002",	// 랜덤값 생성 실패
			"unknown_sym_algorithm" : "41003",	// 알수 없는 대칭키 알고리즘
			"unknown_hash_algorithm" : "41004",	// 알수 없는 해쉬 알고리즘
			"invalid_keyBlock" : "41005", 		// 유효하지 않은 키블록, The key block enter does not correctly.
			"invalid_pem_format" : "41006",		// 유효하지 않은 인증서 포맷
			"utf8_decode_fail" : "41007",		// UTF8 디코드 실패       
			"unsupported_protocol_type" : "41010"// 지원하지 않는 프로토콜 타입
	  };
			
			
	var mSID = "", mVersion = "1.0.0"; //보안 프로토콜 버전 1.0.0
	var mClientHelloHash, mExchangeClientHash, mServerHelloHash;
	var mCertPem;
	var mRNC, mRNS, mPMK, mMSK;
	var mIV, mHmacKey, mEncKey;
	var keyBlock = {};
	var mProtocolType;
	var encKey;
	var iv;
	var macKey;
	var encryptedData;

	var CipherSuite = function() {
		return { value:"", 
				 param:{publicKeyAlg:null,
						symKeyAlg:null,
						hashAlg:null },
				iv		:{},
				macKey	:{},
				encKey	:{},
				server	:{iv	:{},
						  macKey:{},
						  encKey:{} }
				};
	};
	
		var cipher = new CipherSuite();  
	var mDicCipher = {};

	var createSecureProto = function (msg, hash) {		
		return { protocolType:"secure",
			message:msg,
			hash:hash };
	};
	
	var createEnvelopeProto = function (msg, hash) {		
		return { protocolType:"envelope",
		 		 message:msg,
		 		 hash:hash };
	};
	// 보안 프로토콜 에러 정의 	
	function SecureError(msg, funcCall) {
		this.errorCode = ErrorCodeList[msg];
		this.errorMsg = msg;
		if(funcCall == null || funcCall == undefined)
			this.funcCall = "";
		else
			this.funcCall = funcCall;
	}
	SecureError.prototype = Object.create(Error.prototype);
	SecureError.prototype.constructor = SecureError;

	function envelopeCreateKeyBlock(cipherSuite) { 
		var macLen = cipherSuite.macKey.length;
		var keyLen = cipherSuite.encKey.length;
		var ivLen = cipherSuite.iv.length;
		var keyBlock, keyBlockLen;
		
		try {
			keyBlockLen = macLen + keyLen + ivLen;
			cipherSuite.macKey.value = Utils.generatorRandom(macLen);
			cipherSuite.encKey.value = Utils.generatorRandom(keyLen);
			cipherSuite.iv.value = Utils.generatorRandom(ivLen);
	
			keyBlock = Utils.createBuffer(keyBlockLen);

			var offset = 0;
			Utils.memcpy(cipherSuite.macKey.value, 0, keyBlock,  offset, macLen); offset += 20;
			Utils.memcpy(cipherSuite.encKey.value, 0, keyBlock,  offset, keyLen); offset += 16;
			Utils.memcpy(cipherSuite.iv.value, 0, keyBlock,  offset, ivLen); offset += 16;
			if(keyBlock===undefined ||
			   keyBlock==null) {
				throw new SecureError("unknown_sym_algorithm");
			}
			return keyBlock;
		} catch(e) {
			if(e.errorMsg)
				throw  new SecureError(e.errorMsg, "[envelopeCreateKeyBlock]");
			else
				throw  new SecureError(e.message, "[envelopeCreateKeyBlock]");
		}
	}
	
	function setCipher(cipherSuite) {
		/* 
		 * 디폴트 : iv.length=16,
		 * 			encKey.length=16,
		 * 			macKey.length=20
		 */
		try {
			switch(cipherSuite.param.symKeyAlg)
			{
				case "seedCBC": {
					cipherSuite.iv.length = 16;
					cipherSuite.encKey.length = 16;
				} break;
				case "aesCBC": {
					cipherSuite.iv.length = 16;
					cipherSuite.encKey.length = 16;
				} break;
				default: {
					throw new SecureError("unknown_sym_algorithm");	//알수 없는 대칭키 알고리즘
				} break;
			}
			
			switch(cipherSuite.param.hashAlg) 
			{
				case "macWithSHA": {
					cipherSuite.macKey.length = 20;
				} break;
				default: {
					 throw new SecureError("unknown_hash_algorithm");	//알수 없는 해쉬 알고리즘
				} break;
			}
		}catch(e) {
			if(e.errorMsg)
				throw  new Error("[AnySign4PC][setCipher] ErrorMsg : " +  e.errorMsg + "(" + e.errorCode + ")" );
			else
				throw e;
		}
	}
	
	function setAlgorithm(protocolType, cipherSuite) {
		if(cipherSuite === undefined) cipherSuite = new CipherSuite();
		
		try {
			switch(protocolType) {
				case "secure": {
					cipherSuite.param.publicKeyAlg="RSAES-PKCS1-V1_5";
					cipherSuite.param.hashAlg="macWithSHA";
					cipherSuite.param.symKeyAlg="seedCBC"; //cipherSuite.param.symKeyAlg="aesCBC";
				} break;
				case "envelope": {
					cipherSuite.value="RSA_SEED_128_SHA";
					cipherSuite.param.hashAlg="macWithSHA";
					cipherSuite.param.publicKeyAlg="RSAES-PKCS1-V1_5";
					cipherSuite.param.symKeyAlg="aesCBC"; //cipherSuite.param.symKeyAlg="seedCBC";
				} break;
				default: {
					throw new SecureError("unsupported_protocol_type");	//지원하지 않는 프로토콜 타입
				} break;
			}
		} catch(e) {
			throw  new Error("[AnySign4PC][setAlgorithm] ErrorMsg : " +  e.errorMsg + "(" + e.errorCode + ")" );
		}
	}
	
	var clientHello = function(protocolType, sendFn) {
		var sendMsg;
	
		try{	
			if(protocolType == "secure") {
				mRNC = Utils.generatorRandom(32);

				if(mRNC===undefined ||
				   mRNC==null) {
					throw new SecureError("generatorRandom_fail");
				}
				
				var msg = { sid:mSID,
							messageType:"client_hello",
							version:mVersion,
							random:Utils.base64Encode(mRNC) };
	
				var clientHash = Crypto.SHA1(JSON.stringify(msg));
					
				mClientHelloHash = Utils.base64Encode(clientHash.getBytes());
				sendMsg = JSON.stringify(createSecureProto(msg, mClientHelloHash));
			} else {
				var msg = { sid:"",
							messageType:"client_hello",
							version:mVersion
							   };
				mClientHelloHash = "";

				sendMsg = JSON.stringify(createEnvelopeProto(msg, mClientHelloHash));
			}
			sendFn(sendMsg);
		} catch(e) {
			if(e.errorMsg)
				throw  new Error("[AnySign4PC][clientHello] ErrorMsg : " +  e.errorMsg + "(" + e.errorCode + ")" );
			else 
				throw  new Error("[AnySign4PC][clientHello][Native] ErrorMsg : " +  e.message);
		}
	}	

	function keyBlockToCipherSuite(block, cipherSuite){
		try {
			if(block === undefined || block.length <= 0)
				throw new SecureError("invalid_keyBlock"); //유효 하지 않은 키블록
			
			var toHex = sofo.utils.bytesToHex(block.data);
			var macLen = cipherSuite.macKey.length,
			keyLen = cipherSuite.encKey.length,
			ivLen = cipherSuite.iv.length;
			
			var pos = 0;
			cipherSuite.macKey.value = sofo.utils.hexToBytes(toHex.slice(pos, macLen*2)); pos+=macLen*2;
			cipherSuite.server.macKey.value = sofo.utils.hexToBytes(toHex.slice(pos, pos+macLen*2)); pos+=macLen*2;
			cipherSuite.encKey.value = sofo.utils.hexToBytes(toHex.slice(pos, pos+keyLen*2)); pos+=keyLen*2;
			cipherSuite.server.encKey.value = sofo.utils.hexToBytes(toHex.slice(pos, pos+keyLen*2)); pos+=keyLen*2;
			cipherSuite.iv.value = sofo.utils.hexToBytes(toHex.slice(pos, pos+ivLen*2)); pos+=ivLen*2;
			cipherSuite.server.iv.value = sofo.utils.hexToBytes(toHex.slice(pos, pos+16*2));
		}
		catch(e) {
			if(e.errorMsg)
				throw  new SecureError(e.errorMsg, "[keyBlockToCipherSuite]");
			else
				throw  new SecureError(e.message, "[keyBlockToCipherSuite]");
				
		}
	};
	
	var serverHello = function(protocolType, parse, cipherSuite) {
			
		try {
			mCertPem = parse.message.cert;
			if(!Utils.isValiedPemFormat(mCertPem))	//유효 하지 않는 pem 포맷
				throw new SecureError("invalid_pem_format");
			
			if(protocolType == "secure") {
				mRNS = Utils.base64Decode(parse.message.random);
				mSID = Utils.base64Decode(parse.message.sid);

				var jsonStrMsg = JSON.stringify(parse.message);
				var serverHelloUpdateHash = Crypto.hashUpdate(jsonStrMsg, mClientHelloHash, "sha1");

				if(Utils.base64Encode(serverHelloUpdateHash.getBytes()) !== (mServerHelloHash = parse.hash)) //해쉬 미스매치 에러 
					throw new SecureError("bad_verify_hash");
				
				mPMK = Utils.generatorRandom(48);
				mMSK = Utils.calcuratorBlock(mPMK, mRNC, mRNS, 7);
			
				keyBlockToCipherSuite(mMSK, cipherSuite);	
			} else { 
				setAlgorithm(mProtocolType,cipher);
				setCipher(cipher); 
				keyBlock = envelopeCreateKeyBlock(cipher);
								
				encKey = cipher.encKey.value;
				iv = cipher.iv.value;
				macKey = cipher.macKey.value;

				cert = forge.pki.certificateFromPem(mCertPem);
				encryptedKey = cert.publicKey.encrypt(keyBlock.data, cipher.param.publicKeyAlg);
			}
			return true;
		} catch(e) {
			if(e.errorMsg)
				throw  new Error("[AnySign4PC][serverHello]" +e.funcCall+ "ErrorMsg : " +e.errorMsg+ "(" +e.errorCode+ ")" );
			else
				throw  new Error("[AnySign4PC][serverHello]" +e.funcCall+ "[Native] ErrorMsg : " +  e.message);
		}
	};

		
	var keyExchange = function(sendFn, cipherSuite, certPem) {
		try {
			var rsaEncryptionData;
			var cert = forge.pki.certificateFromPem(certPem);  
			
			if(!Utils.isValiedPemFormat(certPem)) //유효 하지 않는 pem 포맷
				throw new SecureError("invalid_pem_format"); 
			
			var encryptedData = cert.publicKey.encrypt(mPMK, cipherSuite.param.publicKeyAlg); 

			var sendMsg = { messageType:"key_exchange",
							sid:Utils.base64Encode(mSID),
							envelopedData:Utils.base64Encode(encryptedData) //rsaEncryptionData
						  };

			var clientHash = Crypto.hashUpdate(JSON.stringify(sendMsg), mServerHelloHash, "sha1");
			mExchangeClientHash = Utils.base64Encode(clientHash.getBytes());
			
			sendFn(JSON.stringify(createSecureProto(sendMsg, mExchangeClientHash)));
			return true;
		}catch(e) {
			if(e.errorMsg)
				throw  new Error("[AnySign4PC][serverHello][keyExchange] ErrorMsg : " + e.errorMsg + "(" + e.errorCode + ")" );
			else
				throw  new Error("[AnySign4PC][serverHello][keyExchange][Native] ErrorMsg : " +  e.message);
		}
	};

	var finish = function(parse) {
		try {
			var mskUpdate = Crypto.hashUpdate(Utils.base64Encode(mMSK.data), "finish", "sha1");
			var finishHash = Crypto.hashUpdate(Utils.base64Encode(mskUpdate.data), mExchangeClientHash, "sha1");

			if(Utils.base64Encode(finishHash.data) !== parse.hash)
				throw new SecureError("bad_verify_hash"); //해쉬값 미스 매치
			else	
				return "finish";
		} catch(e) {
			if(e.errorMsg)
				throw  new Error("[AnySign4PC][finish] ErrorMsg : " + e.errorMsg + "(" + e.errorCode + ")" );
			else
				throw  new Error("[AnySign4PC][finish][Native] ErrorMsg : " +  e.message);
		}
	};
	
	function sendApplication(protocolType, sid, input, cipherSuite, certPem) {	
		var sengMsg;
		var encKey = cipherSuite.encKey.value;
		var iv = cipherSuite.iv.value;
		var macKey = cipherSuite.macKey.value;
		var encryptedData;
		
		try {
			var inputUTF8 = Utils.createBuffer(input, 'utf8');

			if(protocolType == "secure") {
				encryptedData = Crypto.encrypt(input, encKey, iv, cipherSuite.param.symKeyAlg); // 대칭키 암호화 오류
				var msg = { messageType:"application",
							sid:Utils.base64Encode(mSID),
							encryptedData:Utils.base64Encode(encryptedData)
							};
				var sendMsgMac = Crypto.HMAC(inputUTF8.data, macKey);
				sendMsg = JSON.stringify(createSecureProto(msg, Utils.base64Encode(sendMsgMac.data)));
			} else {				
				encryptedData = Crypto.encrypt(input, encKey, iv, cipherSuite.param.symKeyAlg); //대칭키 암호화 오류
				
				var	msg = { messageType:"application",
							sid:sid,
							ciphersuite:cipherSuite.value,
							encryptedKey:Utils.base64Encode(encryptedKey),
							encryptedData:Utils.base64Encode(encryptedData) //rsaEncryptionData
				   			};

				var sendMsgMac = Crypto.HMAC(inputUTF8.data, macKey);
				sendMsg = JSON.stringify(createEnvelopeProto(msg, Utils.base64Encode(sendMsgMac.data)));
			}
		} catch(e) {
			if(e.errorMsg)
				throw  new Error("[AnySign4PC][sendApplication]" +e.funcCall+ " ErrorMsg : " + e.errorMsg + "(" + e.errorCode + ")" );
			else
				throw  new Error("[AnySign4PC][sendApplication]" +e.funcCall+ "[Native] ErrorMsg : " +  e.message);
		}
		return sendMsg;
	}
	
	function receiveApplication(protocolType, parse, cipherSuite) {
		var encKey, macKey, iv;
		
		try {
			if(protocolType == "secure") {
				macKey = cipherSuite.server.macKey.value;
				encKey = cipherSuite.server.encKey.value;
				iv = cipherSuite.server.iv.value;
			} else {
				macKey = cipherSuite.macKey.value;
				encKey = cipherSuite.encKey.value;
				iv = cipherSuite.iv.value;
			}

			var encryptedData = parse.message.encryptedData;
		
			var plainData = Crypto.decrypt(Utils.base64Decode(encryptedData), encKey, iv, cipherSuite.param.symKeyAlg); // 복호화 오류
			
			var receiveHmac = Crypto.HMAC(plainData, macKey);
	
			if(Utils.base64Encode(receiveHmac.getBytes()) !== parse.hash)
				throw new SecureError("bad_verify_hash"); //해쉬값 미스 매치
			else {
				var decode;
					
				decode = Utils.decodeUTF8(plainData); //UTF-8 디코딩 오류
				if(decode === undefined ||
				   decode == null)
					throw new SecureError("utf8_decode_fail");
				
				return decode;
			}
		}catch(e) {
			if(e.errorMsg)
				throw  new Error("[AnySign4PC][receiveApplication] ErrorMsg : " + e.errorMsg + "(" + e.errorCode + ")" );
			else
				throw  new Error("[AnySign4PC][receiveApplication][Native] ErrorMsg : " +  e.message);
		}
	}	
	
	return { start : function(protocolType, sendFn) {
				try{
					if(protocolType === undefined || protocolType == null)
						mProtocolType = "secure"; // secure
				
					mProtocolType = protocolType;
					
					if(mProtocolType == "secure") {
						mDicCipher["secure"] = new CipherSuite();
						var cipher = mDicCipher["secure"];
	
						setAlgorithm(mProtocolType, cipher);
						setCipher(cipher);
					}
					clientHello(mProtocolType, sendFn);
				}	catch(e) {
					throw e;
				}
			},
			handShake : function(sendFn, parse) {
				var res=false;
				try {
					if(mProtocolType == "secure") {
						var cipher = mDicCipher["secure"];
						if(serverHello(mProtocolType, parse, cipher))
							res = keyExchange(sendFn, cipher, mCertPem);
					} else  {
						res = serverHello(mProtocolType, parse);
					}
				} catch(e) {
					throw e;
				}
				return res;
			},
			finish : function(parse) {
				return finish(parse);
			},
			end : function() {
				mProtocolType = null;
				  var cipherSuite = mDicCipher["secure"];	
				  if(mProtocolType === "secure") {
					  cipherSuite.macKey.value = null;
					  cipherSuite.encKey.value = null;
					  cipherSuite.iv.value = null;
					  cipherSuite.server.macKey.value = null;
					  cipherSuite.server.encKey.value = null;
					  cipherSuite.server.iv.value = null;
					  delete  mDicCipher["secure"];
				 
				  mMSK = null;
				} else if(mProtocolType == "envelope") {
					mEncKey = null;
					mIV = null;
					mHmacKey = null;
				}
		    },
			sendApplication : function(input) {
				var sid="";
				var sendMsg;

				try {
					if(mProtocolType == "secure")
						 cipher = mDicCipher["secure"];
					
					sendMsg = sendApplication(mProtocolType, sid, input, cipher, mCertPem);
					return sendMsg;
				} catch(e) {
					throw e;
				}				
			},
			receiveApplication : function(input) {
				var parse = input;
				var recMsg;
				try {
					if(mProtocolType == "secure")
						cipher = mDicCipher["secure"];
					
					recMsg = receiveApplication(mProtocolType, input, cipher);
					return recMsg;
				}	catch(e) {
					throw e;
				}				
			}
	}
})();
