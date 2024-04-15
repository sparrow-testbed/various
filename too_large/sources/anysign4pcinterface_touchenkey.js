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
document.write("<!-- AnySign stylesheet -->");
document.write("<link rel='stylesheet' id='anySignCSS' type='text/css' href='/AnySign/AnySign4PC/css/common.css' />");
document.write("<script type=\"text/javascript\" src=\"" + "/AnySign/AnySign4PC/ext/AnySign4PC_min.js\"></scr"+"ipt>");
document.write("<script type=\"text/javascript\" src=\"" + "/AnySign/AnySign4PC/ext/SecureProto.js\"></scr"+"ipt>");
function AnySignInitialize ()
{
	/*------------------------------------------------------------------------
	 * AnySign 기본 설정.
	 *----------------------------------------------------------------------*/
	// AnySign 디렉토리 설치경로.
	// ex)aBasePath = window.location.protocol + "//reaver.softforum.com/...";
	//var aBasePath = window.location.protocol + "";
	var aBasePath = "https://epro.wooribank.com/AnySign/AnySign4PC";
	
	var gProtocol = document.location.protocol;
	var gHost = document.location.hostname;
	//var gPort = document.location.gPort;
        var gPort = document.location.port;
        	
	var gHostName = "";
	
	if (gPort == ""){
		gHostName = gHost;
	} else {
		gHostName = gHost + ":" + gPort; // document.location.host 또는 window.location.host
	}
	// AnySign의 License 정보.
	var aLicense = "";

	if(gHostName == "127.0.0.1") {
		aLicense = "30820678020101310b300906052b0e03021a0500305606092a864886f70d010701a0490447313a3132372e302e302e313a67657450465841636365737361626c654d656469614c6973742c676574504658466f6c6465724c6973742c7769662c67657456494452616e646f6da0820467308204633082034ba003020102020107300d06092a864886f70d01010505003077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d301e170d3034303431393030303030305a170d3333303131333030303030305a308192310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e311e301c060355040b1315536563757269747920524e44204469766973696f6e311c301a06035504031313536f6674666f72756d205075626c69632043413125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d30820121300d06092a864886f70d01010105000382010e00308201090282010043340b4e1f2f30d6634c818e9fa4b35c199e0628503dbe0d1f5ad2c05890a918408dc330c991083bc7cdfc50021303c04afab4cb522d22fced11d1be6559835f1f000d466120cff97a2a80e4fdf972ac127f9bb8e8ddb84974323e4cb822c5f15b22f82da3de6ef61a0b6798ca49a85af3d8f8298912b4d26411e2e1635c081a3306931716c5e56b279c4d36068a4b645c10aa582693086e14132ba67fb03526312790261f9c641993e2ffc3fd9e8df3efebfddecd722e874d6366ad1252ac0d8bddb5674533cc2717a7342e5cfb18f8a301e7196ca33d6c3bb7e1f1e4bee34f5358af6ae0fd52a9fc3bdd4925f5eab7db6628e24738f6c882bb0aaa0e10afbf0203010001a381de3081db301f0603551d2304183016801409b5e27e7d2ac24a8f56bb67accebb93f5318fd3301d0603551d0e041604142e49ab278ae8c8af977537de8b74bb240e0d275f300e0603551d0f0101ff04040302010630120603551d130101ff040830060101ff02010030750603551d1f046e306c306aa068a06686646c6461703a2f2f6c6461702e736f6674666f72756d2e636f6d3a3338392f434e3d58656375726543524c505542432c4f553d536563757269747920524e44204469766973696f6e2c4f3d536f6674666f72756d20436f72706f726174696f6e2c433d4b52300d06092a864886f70d010105050003820101003ce700a0492b225b1665d9c73d84c34f7a5faad7b397ed49231f030e4e0e91953a607bd9006425373d490ef3ba1cf47810ca8c22fabe0c609f93823efdede64744458e910267f9f857c907318e286da6c131c9dd5fada43fd8cfdf6bd1b1b239338cea83eb6b6893b88fbcfd8e86a677b7270ad96be5a82b40569efc2dda6df4bcd642d067183186d6cace6c8f73b80f30b57acb3bcd5cbbc51307922d5edb38cb0d90c3917a8e37534183ba10f403c1c034287f39442df795050f39d78ddad97da8a43f02d7641549af9b5d68908e49faa8a1597cfed4a43baadd42c8fe4fd44c96d314df56147b8a7fa6ba65ffdee9ed3a5da52ef9ac7f9ca5afb633e1ccdf318201a13082019d020101307c3077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d020107300706052b0e03021a300d06092a864886f70d01010505000482010014fbcedb1c444b993f193a5a102d1969e5f10e292eeb1ebc2b4f163fd1ff083b98767faba8cfb40573c214fe068bdcb424d04a7dd68bc2a240dd641b0964a902d8f5ac4f04dcd571ba31ad34a60b59212dec354a0230a0002f4791ff1cbb8afaa0420f945acf309de07eb8ac668999eedc6aec73fa1abdc3885ca7915a648fd37e06a9414254000a9efb56b0b3bbad21ad974ba243f16bbc96cfb7d548aaa3a16aabbfd9ad54fe1913b4f17cc72316d3e564b6ff463c206c314ebb1ccd8d9e4b2eb037d16a92fb82c985d1bd466631f0ca69e760b9e2053a08b00677957473bf7107f9b89e789161a47b575f97398b271d1df36235df6bf399e5c35308813fef";
	} else if(gHostName == "epro.wooribank.com") {
		aLicense = "30820a4b020101310b300906052b0e03021a05003082042706092a864886f70d010701a082041804820414313a6570726f2e776f6f726962616e6b2e636f6d3a67657443657274547265652c6765744d656469614c6973742c7369676e44617461434d532c73657449644e756d2c76657269667950617373776f72642c766572696679436572742c766572696679436572744f776e65722c766572696679526f6f744361436572742c64656c65746543657274696669636174652c6368616e67654365727450617373776f72642c636865636b5046585077642c696d706f7274436572742c6578706f7274436572742c676574504658466f6c6465724c6973742c73617665436572742c626c6f636b446563436f6e7374616e742c7265717565737443657274696669636174652c72656e657743657274696669636174652c7265766f6b6543657274696669636174652c656e76656c6f7049644e756d2c676574566964496e666f2c7365744c616e67756167652c696e7374616c6c43657274696669636174652c736574497373756572436f6e766572745461626c652c736574506f6c696379436f6e766572745461626c652c656e76656c6f7065446174615769746850454d2c656e76656c6f70654461746157697468436572742c656e76656c6f706544617461576974685061737377642c6465456e76656c6f70654461746157697468436572742c6465456e76656c6f706544617461576974685061737377642c6765744c6173744c6f636174696f6e2c6c6f67696e504b4353313146726f6d496e6465782c6c6f67696e504b4353313146726f6d4e616d652c676574504b4353313144656661756c7450726f76696465722c7369676e44617461576974685046582c67657450465841636365737361626c654d656469614c6973742c7769662c66696e616c697a65504b4353313146726f6d4e616d652c696e697469616c697a65504b4353313146726f6d4e616d652c68736d4472697665724d616e616765722c636865636b50617373776f72644c656e2c67657443657274496e666f45782c6765744361636865436572744c6f636174696f6e2c626c6f636b456e632c626c6f636b44656345782c73656c65637446696c652c7369676e46696c6545782c76657269667946696c652c676574566572696669656446696c6543657274496e666f2c6578747261637446696c652c656e76656c6f7049644e756d2c656e76656c6f706546696c655769746850454d2c656e76656c6f706546696c6557697468436572742c6465456e76656c6f706546696c6557697468436572742c656e76656c6f706546696c65576974685061737377642c6465456e76656c6f706546696c65576974685061737377642c676574456e76656c6f70656446696c65496e666f2c75706c6f616446696c652c646f776e6c6f616446696c652c67657446696c65496e666f2c636c65617254656d7046696c652c7a697046696c652c75a0820467308204633082034ba003020102020107300d06092a864886f70d01010505003077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d301e170d3034303431393030303030305a170d3333303131333030303030305a308192310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e311e301c060355040b1315536563757269747920524e44204469766973696f6e311c301a06035504031313536f6674666f72756d205075626c69632043413125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d30820121300d06092a864886f70d01010105000382010e00308201090282010043340b4e1f2f30d6634c818e9fa4b35c199e0628503dbe0d1f5ad2c05890a918408dc330c991083bc7cdfc50021303c04afab4cb522d22fced11d1be6559835f1f000d466120cff97a2a80e4fdf972ac127f9bb8e8ddb84974323e4cb822c5f15b22f82da3de6ef61a0b6798ca49a85af3d8f8298912b4d26411e2e1635c081a3306931716c5e56b279c4d36068a4b645c10aa582693086e14132ba67fb03526312790261f9c641993e2ffc3fd9e8df3efebfddecd722e874d6366ad1252ac0d8bddb5674533cc2717a7342e5cfb18f8a301e7196ca33d6c3bb7e1f1e4bee34f5358af6ae0fd52a9fc3bdd4925f5eab7db6628e24738f6c882bb0aaa0e10afbf0203010001a381de3081db301f0603551d2304183016801409b5e27e7d2ac24a8f56bb67accebb93f5318fd3301d0603551d0e041604142e49ab278ae8c8af977537de8b74bb240e0d275f300e0603551d0f0101ff04040302010630120603551d130101ff040830060101ff02010030750603551d1f046e306c306aa068a06686646c6461703a2f2f6c6461702e736f6674666f72756d2e636f6d3a3338392f434e3d58656375726543524c505542432c4f553d536563757269747920524e44204469766973696f6e2c4f3d536f6674666f72756d20436f72706f726174696f6e2c433d4b52300d06092a864886f70d010105050003820101003ce700a0492b225b1665d9c73d84c34f7a5faad7b397ed49231f030e4e0e91953a607bd9006425373d490ef3ba1cf47810ca8c22fabe0c609f93823efdede64744458e910267f9f857c907318e286da6c131c9dd5fada43fd8cfdf6bd1b1b239338cea83eb6b6893b88fbcfd8e86a677b7270ad96be5a82b40569efc2dda6df4bcd642d067183186d6cace6c8f73b80f30b57acb3bcd5cbbc51307922d5edb38cb0d90c3917a8e37534183ba10f403c1c034287f39442df795050f39d78ddad97da8a43f02d7641549af9b5d68908e49faa8a1597cfed4a43baadd42c8fe4fd44c96d314df56147b8a7fa6ba65ffdee9ed3a5da52ef9ac7f9ca5afb633e1ccdf318201a13082019d020101307c3077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d020107300706052b0e03021a300d06092a864886f70d0101050500048201001d808d0d05cead3ca7fe769767fad3a741f87ab0b0e13ae5309b0a49698b61849610812b2b492ad6d82413fdd79d5c70a49ca34bd2d916ba19a1c562e4e4d75aa3c5ae80166aca4e78159c963bb67c58a066744241b6dc591ba0f2cd18e7a432238200980da1be91c4e5ed45aa432da957646a71cf2fbbdf37a5f5526ebf272a4f8f1420b926675cbff8fb7ec71b8047f59ccedfdbd2072255d6f75ea0ed9971f9b91e7e444753dd75f90ea04cf1add6cfa01c27b2210c38c96f087514d548cc2c9f868cc8ef546725da1fa8f83b9b4d48eeb4308cdfe5c973e6962d2edcf0320a806dfb44df2112abbbb02732c03fc84e289984f90673757e8338341af2ae52";
	} else if(gHostName == "eprodev.wooribank.com") {
		aLicense = "30820a4e020101310b300906052b0e03021a05003082042a06092a864886f70d010701a082041b04820417313a6570726f6465762e776f6f726962616e6b2e636f6d3a67657443657274547265652c6765744d656469614c6973742c7369676e44617461434d532c73657449644e756d2c76657269667950617373776f72642c766572696679436572742c766572696679436572744f776e65722c766572696679526f6f744361436572742c64656c65746543657274696669636174652c6368616e67654365727450617373776f72642c636865636b5046585077642c696d706f7274436572742c6578706f7274436572742c676574504658466f6c6465724c6973742c73617665436572742c626c6f636b446563436f6e7374616e742c7265717565737443657274696669636174652c72656e657743657274696669636174652c7265766f6b6543657274696669636174652c656e76656c6f7049644e756d2c676574566964496e666f2c7365744c616e67756167652c696e7374616c6c43657274696669636174652c736574497373756572436f6e766572745461626c652c736574506f6c696379436f6e766572745461626c652c656e76656c6f7065446174615769746850454d2c656e76656c6f70654461746157697468436572742c656e76656c6f706544617461576974685061737377642c6465456e76656c6f70654461746157697468436572742c6465456e76656c6f706544617461576974685061737377642c6765744c6173744c6f636174696f6e2c6c6f67696e504b4353313146726f6d496e6465782c6c6f67696e504b4353313146726f6d4e616d652c676574504b4353313144656661756c7450726f76696465722c7369676e44617461576974685046582c67657450465841636365737361626c654d656469614c6973742c7769662c66696e616c697a65504b4353313146726f6d4e616d652c696e697469616c697a65504b4353313146726f6d4e616d652c68736d4472697665724d616e616765722c636865636b50617373776f72644c656e2c67657443657274496e666f45782c6765744361636865436572744c6f636174696f6e2c626c6f636b456e632c626c6f636b44656345782c73656c65637446696c652c7369676e46696c6545782c76657269667946696c652c676574566572696669656446696c6543657274496e666f2c6578747261637446696c652c656e76656c6f7049644e756d2c656e76656c6f706546696c655769746850454d2c656e76656c6f706546696c6557697468436572742c6465456e76656c6f706546696c6557697468436572742c656e76656c6f706546696c65576974685061737377642c6465456e76656c6f706546696c65576974685061737377642c676574456e76656c6f70656446696c65496e666f2c75706c6f616446696c652c646f776e6c6f616446696c652c67657446696c65496e666f2c636c65617254656d7046696c652c7a697046696c652c75a0820467308204633082034ba003020102020107300d06092a864886f70d01010505003077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d301e170d3034303431393030303030305a170d3333303131333030303030305a308192310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e311e301c060355040b1315536563757269747920524e44204469766973696f6e311c301a06035504031313536f6674666f72756d205075626c69632043413125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d30820121300d06092a864886f70d01010105000382010e00308201090282010043340b4e1f2f30d6634c818e9fa4b35c199e0628503dbe0d1f5ad2c05890a918408dc330c991083bc7cdfc50021303c04afab4cb522d22fced11d1be6559835f1f000d466120cff97a2a80e4fdf972ac127f9bb8e8ddb84974323e4cb822c5f15b22f82da3de6ef61a0b6798ca49a85af3d8f8298912b4d26411e2e1635c081a3306931716c5e56b279c4d36068a4b645c10aa582693086e14132ba67fb03526312790261f9c641993e2ffc3fd9e8df3efebfddecd722e874d6366ad1252ac0d8bddb5674533cc2717a7342e5cfb18f8a301e7196ca33d6c3bb7e1f1e4bee34f5358af6ae0fd52a9fc3bdd4925f5eab7db6628e24738f6c882bb0aaa0e10afbf0203010001a381de3081db301f0603551d2304183016801409b5e27e7d2ac24a8f56bb67accebb93f5318fd3301d0603551d0e041604142e49ab278ae8c8af977537de8b74bb240e0d275f300e0603551d0f0101ff04040302010630120603551d130101ff040830060101ff02010030750603551d1f046e306c306aa068a06686646c6461703a2f2f6c6461702e736f6674666f72756d2e636f6d3a3338392f434e3d58656375726543524c505542432c4f553d536563757269747920524e44204469766973696f6e2c4f3d536f6674666f72756d20436f72706f726174696f6e2c433d4b52300d06092a864886f70d010105050003820101003ce700a0492b225b1665d9c73d84c34f7a5faad7b397ed49231f030e4e0e91953a607bd9006425373d490ef3ba1cf47810ca8c22fabe0c609f93823efdede64744458e910267f9f857c907318e286da6c131c9dd5fada43fd8cfdf6bd1b1b239338cea83eb6b6893b88fbcfd8e86a677b7270ad96be5a82b40569efc2dda6df4bcd642d067183186d6cace6c8f73b80f30b57acb3bcd5cbbc51307922d5edb38cb0d90c3917a8e37534183ba10f403c1c034287f39442df795050f39d78ddad97da8a43f02d7641549af9b5d68908e49faa8a1597cfed4a43baadd42c8fe4fd44c96d314df56147b8a7fa6ba65ffdee9ed3a5da52ef9ac7f9ca5afb633e1ccdf318201a13082019d020101307c3077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d020107300706052b0e03021a300d06092a864886f70d01010505000482010001d15b4c820f55957dac734cc18ff5dfabf3c83c0ec72a389d092084991e992be907f17f623eb0e41b2f89fa64ac2bb61c834682ce52daf4bfc4593eef62f3389479abdbe69b36a8e2c7dab26e0d2e4496d0a9f6bbc46e01c235225305c49c3126fc6f27b57c89e2902e1e45b82db74193cc16c94f82f913d47cf79a261b7180df5c6fd6441cd256553796b14a25a81900aba28bd43e0816682ab010c99b31307f46f7521f2a8f84d70260827d3c51efc36c060387ae092441e692db47366f366b278814459f1704e614e2397df5e3240f35b349fe22ed93b78f7d7fb5d50fc836c8a00af0b8a9eaf995e6deb3ee4dc996258dd01d8936df40fce9d729e6b913";
	} else {
		// localhost
		aLicense = "30820a4b020101310b300906052b0e03021a05003082042706092a864886f70d010701a082041804820414313a6570726f2e776f6f726962616e6b2e636f6d3a67657443657274547265652c6765744d656469614c6973742c7369676e44617461434d532c73657449644e756d2c76657269667950617373776f72642c766572696679436572742c766572696679436572744f776e65722c766572696679526f6f744361436572742c64656c65746543657274696669636174652c6368616e67654365727450617373776f72642c636865636b5046585077642c696d706f7274436572742c6578706f7274436572742c676574504658466f6c6465724c6973742c73617665436572742c626c6f636b446563436f6e7374616e742c7265717565737443657274696669636174652c72656e657743657274696669636174652c7265766f6b6543657274696669636174652c656e76656c6f7049644e756d2c676574566964496e666f2c7365744c616e67756167652c696e7374616c6c43657274696669636174652c736574497373756572436f6e766572745461626c652c736574506f6c696379436f6e766572745461626c652c656e76656c6f7065446174615769746850454d2c656e76656c6f70654461746157697468436572742c656e76656c6f706544617461576974685061737377642c6465456e76656c6f70654461746157697468436572742c6465456e76656c6f706544617461576974685061737377642c6765744c6173744c6f636174696f6e2c6c6f67696e504b4353313146726f6d496e6465782c6c6f67696e504b4353313146726f6d4e616d652c676574504b4353313144656661756c7450726f76696465722c7369676e44617461576974685046582c67657450465841636365737361626c654d656469614c6973742c7769662c66696e616c697a65504b4353313146726f6d4e616d652c696e697469616c697a65504b4353313146726f6d4e616d652c68736d4472697665724d616e616765722c636865636b50617373776f72644c656e2c67657443657274496e666f45782c6765744361636865436572744c6f636174696f6e2c626c6f636b456e632c626c6f636b44656345782c73656c65637446696c652c7369676e46696c6545782c76657269667946696c652c676574566572696669656446696c6543657274496e666f2c6578747261637446696c652c656e76656c6f7049644e756d2c656e76656c6f706546696c655769746850454d2c656e76656c6f706546696c6557697468436572742c6465456e76656c6f706546696c6557697468436572742c656e76656c6f706546696c65576974685061737377642c6465456e76656c6f706546696c65576974685061737377642c676574456e76656c6f70656446696c65496e666f2c75706c6f616446696c652c646f776e6c6f616446696c652c67657446696c65496e666f2c636c65617254656d7046696c652c7a697046696c652c75a0820467308204633082034ba003020102020107300d06092a864886f70d01010505003077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d301e170d3034303431393030303030305a170d3333303131333030303030305a308192310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e311e301c060355040b1315536563757269747920524e44204469766973696f6e311c301a06035504031313536f6674666f72756d205075626c69632043413125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d30820121300d06092a864886f70d01010105000382010e00308201090282010043340b4e1f2f30d6634c818e9fa4b35c199e0628503dbe0d1f5ad2c05890a918408dc330c991083bc7cdfc50021303c04afab4cb522d22fced11d1be6559835f1f000d466120cff97a2a80e4fdf972ac127f9bb8e8ddb84974323e4cb822c5f15b22f82da3de6ef61a0b6798ca49a85af3d8f8298912b4d26411e2e1635c081a3306931716c5e56b279c4d36068a4b645c10aa582693086e14132ba67fb03526312790261f9c641993e2ffc3fd9e8df3efebfddecd722e874d6366ad1252ac0d8bddb5674533cc2717a7342e5cfb18f8a301e7196ca33d6c3bb7e1f1e4bee34f5358af6ae0fd52a9fc3bdd4925f5eab7db6628e24738f6c882bb0aaa0e10afbf0203010001a381de3081db301f0603551d2304183016801409b5e27e7d2ac24a8f56bb67accebb93f5318fd3301d0603551d0e041604142e49ab278ae8c8af977537de8b74bb240e0d275f300e0603551d0f0101ff04040302010630120603551d130101ff040830060101ff02010030750603551d1f046e306c306aa068a06686646c6461703a2f2f6c6461702e736f6674666f72756d2e636f6d3a3338392f434e3d58656375726543524c505542432c4f553d536563757269747920524e44204469766973696f6e2c4f3d536f6674666f72756d20436f72706f726174696f6e2c433d4b52300d06092a864886f70d010105050003820101003ce700a0492b225b1665d9c73d84c34f7a5faad7b397ed49231f030e4e0e91953a607bd9006425373d490ef3ba1cf47810ca8c22fabe0c609f93823efdede64744458e910267f9f857c907318e286da6c131c9dd5fada43fd8cfdf6bd1b1b239338cea83eb6b6893b88fbcfd8e86a677b7270ad96be5a82b40569efc2dda6df4bcd642d067183186d6cace6c8f73b80f30b57acb3bcd5cbbc51307922d5edb38cb0d90c3917a8e37534183ba10f403c1c034287f39442df795050f39d78ddad97da8a43f02d7641549af9b5d68908e49faa8a1597cfed4a43baadd42c8fe4fd44c96d314df56147b8a7fa6ba65ffdee9ed3a5da52ef9ac7f9ca5afb633e1ccdf318201a13082019d020101307c3077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d020107300706052b0e03021a300d06092a864886f70d0101050500048201001d808d0d05cead3ca7fe769767fad3a741f87ab0b0e13ae5309b0a49698b61849610812b2b492ad6d82413fdd79d5c70a49ca34bd2d916ba19a1c562e4e4d75aa3c5ae80166aca4e78159c963bb67c58a066744241b6dc591ba0f2cd18e7a432238200980da1be91c4e5ed45aa432da957646a71cf2fbbdf37a5f5526ebf272a4f8f1420b926675cbff8fb7ec71b8047f59ccedfdbd2072255d6f75ea0ed9971f9b91e7e444753dd75f90ea04cf1add6cfa01c27b2210c38c96f087514d548cc2c9f868cc8ef546725da1fa8f83b9b4d48eeb4308cdfe5c973e6962d2edcf0320a806dfb44df2112abbbb02732c03fc84e289984f90673757e8338341af2ae52";
	}

	// TransKey 디렉토리 설치경로.
	var aTransKeyPath = "/XecureDemo/transkeyServlet";
	
	// Inca Keypad 이미지 경로
	var aIncaNOSv10KeypadImgPath = "";

	// AnySign의 Security Context 정보.
	var aSecurityContext = "";

	// AnySign의 License 정보.
	//var aLicense = "";

	// 사이트에서 사용할 AnySign 버전.
	var aVersion = "1.1.1.0";

	// support ko-KR and en-US
	var aLanguage = "ko-KR";

	// support euc-kr and utf-8
	var aCharset = "utf-8";

	// blockEnc, blockDec 인코딩 정보, euc-kr 인코딩을 원할 경우 설정
	var aEncCharset = "";

	// TransKey 체크박스 사용 여부.(xc는 미지원)
	var aTransKeyCheckBoxEnable = false;

	// TransKey 사용 여부.
	var aTransKeyEnable = false;
	
	// TouchEnKey 사용 여부.
	var aTouchEnKeyEnable = true;

	// 키보드보안/가상키패드를 사용하지 않는 일반 키보드 입력 허용 여부
	var aAllowNativeInput = false;

	// Openkeyboard 사용 여부.
	var aOpenkeyboardEnable = false;
	
	// K-Defense 사용 여부.
	var aKDefenseEnable = false;
	
	// K-Defense E2E 적용 시 Prefix
	var aKDefenseE2EPrefix = "xk";

	// 잉카 VKeypad 사용 여부.
	var aVKeypadEnable = false;
	
	// 잉카 KeyCrypt_HTML5 사용 여부.
	var aKeyCryptHTML5Enable = false;

	// XecureKeyPad 사용 여부.
	var aXecureKeyPadEnable = false;

	// ASTx 사용 여부.
	var aASTxEnable = false;
	
	// TouchEn nxKey 사용 여부.
	var aTouchEnnxKeyEnable = false;
	
	// 잉카 NOS(nProtect Online Security V1.0) (키보드보안)
	var aIncaNOSv10Enable = false;
	
	// 잉카 NOS(nProtect Online Security V1.0) (가상키패드)
	var aIncaNOSv10KeypadEnable = false;
	
	// Kings Non-activeX 키보드보안 사용 여부
	var aKOSKeyEnable = false;
	
	// 소프트일레븐 ezKeytec 키보드 보안 사용 여부
	var aEzKeyTecEnable = false;

	/*------------------------------------------------------------------------
	 * AnySignLite 설정.
	 *----------------------------------------------------------------------*/
	// AnySignLite 지원 브라우저 (XCrypto.js 지원)
	// Firefox 3.6 이상, Chrome 7 이상, IE 10 이상, Opera 12.02 이상, Safari 6.0.2 이상
	
	// AnySignLite 사용 여부.
	var aAnySignLiteEnable = false;
	
	// hConvert2pfx.exe 다운로드 경로 (PFX 인증서 변환 프로그램)
	var aHConvert2pfxDownloadURL = aBasePath + "/download/hConvert2pfx.exe";
	
	// 브라우저 인증서 내보내기 기능 지원
	// 1) FileSaver : Javascript library (FileSaver.min.js)
	//    Chrome 14, Firefox 20.0, IE 13(Edge 13), Opera 15, Safari(미지원)
	//    IE 10 ~ 11
	// 2) HTML <a> download Attribute
	//    Chrome 14, Firefox 20.0, IE 13(Edge 13), Opera 15, Safari(미지원)
	//    IE 10 ~ 11 (미지원)
	
	// * Downloadify -> FileSaver 로 대체되어 사용안함
	// - Downloadify : Javascript + Flash library (swfobject.js, downloadify.min.js)
	//   Flash 10 이상 설치 필요 (Safari 미지원)
	var aExportCertDownloadify = {
		// Downloadify 설정
		swf: aBasePath + "/swf/downloadify.swf",
		btnImg_koKR: aBasePath + "/img/btn_complete.png",
		btnImgWidth_koKR: 52,
		btnImgHeight_koKR: 25,
		btnImg_enUS: aBasePath + "/img/btn_complete_eng.png",
		btnImgWidth_enUS: 80,
		btnImgHeight_enUS: 25
	}
	
	// XecureKeyPad HTML5 사용 여부.
	var aXecureKeyPadHTML5Enable = false;
	
	/*----------------------------------------------------------------------*/
	
	// AnySign 사용 여부.
	var aAnySignEnable = true;
	
	// AnySign 로딩 여부. 로딩이 성공하면 true로 변경.
	var aAnySignLoad = false;

	// AnySign 로딩 이미지 사용 여부.
	var aAnySignShowImg = {
		showImg: true,
		//showUpdateImg: true,
		showDiv: true,
		zIndex: 530000,
		endImgAfterDec: false
	}

	// AnySign Live Update.
	var aAnySignLiveUpdate = false;

	// AnySign JSESSIONID.
	var aAnySignSID = window.location.host;

	// AnySign IntegrityID
	var aAnySignITGT = "";
	
	// 화면 내 DIV 영역으로 인증서 선택창 UI 위치
	// 0 : pop(default), 1 : wide, 2 : mini
	var aDivInsertOption = false;

	// EN_FINAANCIAL = 0, EN_KEB = 1 (IC카드)
	var aFinancialType = 0;

	// 유효기간 만료된 인증서 보이기
	var aShowExpiredCert = false;

	// certsaveloc dialog 
	// 0 : none(인증서 발급 시 IC카드로 발급), 1 : display
	var aShowLocationDialog = 1;
	
	// 인증서 갱신 시 다른 저장매체에 저장
	var aShowRenewCertSaveLoc = false;
	
	// WB스타일 적용
	var aWBStyleApply = false;
	
	// AnySign 암호화 페이지 복호화(BlockDec) 완료 여부.
	var aPageBlockDecDone = false;

	// AnySign 설치 페이지 새창으로 실행 여부.
	var aInstallPageNewOpen = false;

	// 강화된 비밀번호 정책 적용 범위
	// 자릿수 10자리 이상, 숫자/영문/특수문자(space 포함) 반드시 포함, 특수문자 4종 제외(' " | \)
	var aEnhancedPW = {
		_change: true,
		_export: true,
		_import: true,
		_copy: false 
	}

	// UBIKey
	var aUbikeyDataList =
	[
		{
			mSite : "WOORIBANK",
			mLiveUpdate : "https://spib.wooribank.com/pib/Dream?withyou=CMCOM0151|1|jsp|714|384|22",
			mSecurity : "SOFTFORUM",
			mKeyboardSecurity : "SOFTFORUM",
			mInstallURL : "https://spib.wooribank.com/pib/Dream?withyou=CTCER0069",
			mInstallPageOption : "width=450,height=400,left=10,top=10",
			mPlatForm : "Linux",
			mVersion : "1,0,0,1"
		},
		{
			mSite : "WOORIBANK",
			mLiveUpdate : "https://spib.wooribank.com/pib/Dream?withyou=CMCOM0151|1|jsp|714|384|22",
			mSecurity : "SOFTFORUM",
			mKeyboardSecurity : "SOFTFORUM",
			mInstallURL : "https://spib.wooribank.com/pib/Dream?withyou=CTCER0069",
			mInstallPageOption : "width=450,height=400,left=10,top=10",
			mPlatForm : "Mac",
			mVersion : "1,0,0,1"
		},
		{
			mSite : "WOORIBANK",
			mLiveUpdate : "https://spib.wooribank.com/pib/Dream?withyou=CMCOM0151|1|jsp|714|384|MSIE",
			mSecurity : "SOFTFORUM",
			mKeyboardSecurity : "SOFTFORUM",
			mInstallURL : "https://spib.wooribank.com/pib/Dream?withyou=CTCER0069",
			mInstallPageOption : "width=450,height=400,left=10,top=10",
			mPlatForm : "Win32",
			mVersion : "1,2,3,6"
		},
		{
			mSite : "",
			mLiveUpdate : "https://spib.wooribank.com/pib/Dream?withyou=CMCOM0151|1|jsp|714|384|MSIE",
			mSecurity : "SOFTFORUM",
			mKeyboardSecurity : "SOFTFORUM",
			mInstallURL : "https://spib.wooribank.com/pib/Dream?withyou=CTCER0069",
			mInstallPageOption : "width=450,height=400,left=10,top=10",
			mPlatForm : "Win64",
			mVersion : "1,1,0,5"
		}
	]
	
	// MobiSign URL
	var aMobiSignData = { mSite : "123456",
						  mInstallURL : "http://www.mobisign.kr/mobisigndll.htm",
						  mInstallPageOption : "width=450,height=400,left=10,top=10",
						  mVersion : "5.0.3.7" }
	
	// 스마트인증, aStorage = SMARTCERT
	var aSmartCertEnable = true; // true 설정 시 보안토큰 리스트에 안보임
	var aSmartCertDataList =
	[
		{
			// DreamSecurity
			mProvider : "Mobile_SmartCert",
			mDriverName : "USIM_0002",
			mInstallURL : "http://ids.smartcert.kr", // http://download.smartcert.kr/
			mInstallPageOption : "width=500, height=380", // width=595,height=288
			mSiteDomainURL : "www.softforum.com",
			mServiceServerIP : "center.smartcert.kr",
			mServiceServerPort : "443",
			mSiteCode : "",				// 사용 안함
			mMagicNum : "19579238",
			mPlainDataView : "NO",		// 전자서명 시 휴대폰에서 원문확인 (YES or NO) *SignedAttributes 옵션 필요
			mFilterShowExpired : "1",	// 유효기간 만료된 인증서 표시 여부 (0:보여줌, 1:안보여줌)
			mFilterOIDList : "",		// OID 로 인증서 필터링 (구분자:|)
			mFilterCACert : "",			// CA SubjectDN목록으로 인증서 필터링 (구분자:|)
			mFilterUserCert : "",		// 사용자 인증서 필터링 (포맷: subject=홍길동,issuer=yessign,serial=132411FF)
			mLoginOrder : "1"			// 0:로그인->인증서 선택, 1:인증서 선택->로그인
		},
		{
			// RaonSecure
			mProvider : "Mobile_USIMsmartCERT",
			mDriverName : "USIM_0001",
			mInstallURL : "http://www.usimcert.com/popup/pop_install.html",
			mInstallPageOption : "width=516,height=419,left=0,top=0",
			mSiteDomainURL : "www.softforum.com",
			mServiceServerIP : "",
			mServiceServerPort : "",
			mSiteCode : "6|000000000",	// ModCode|SiteCode
			mMagicNum : "19579238",
			mPlainDataView : "NO",		// 미지원
			mFilterShowExpired : "1",	// 유효기간 만료된 인증서 표시 여부 (0:보여줌, 1:안보여줌)
			mFilterOIDList : "",		// OID 로 인증서 필터링 (구분자:|)
			mFilterCACert : "",			// CA SubjectDN목록으로 인증서 필터링 (구분자:|)
			mFilterUserCert : "",		// 사용자 인증서 필터링 (포맷: IssuerDN $ SubjectDN $ Serial)
										// 순서대로 입력하고 값이 없으면 NONE을 입력 (예: yessign$홍길동$132411FF, NONE$홍길동)
			mLoginOrder : "1"			// 0:로그인->인증서 선택, 1:인증서 선택->로그인
		}
	]
	
	// Ubikey 보안토큰
	var aUbikeyPKCS11Enable = false; // true 설정 시 설치 유무와 상관없이 보안토큰 리스트에 보임
	var aUbikeyPKCS11Data = {
	 		mProvider : "UBIKey_USIM",
	 		mSite : "WOORIBANK",
	 		mLiveUpdate : "https://spib.wooribank.com/pib/Dream?withyou=CMCOM0151|1|jsp|714|384|22",
	 		mSecurity : "SOFTFORUM",
	 		mKeyboardSecurity : "SOFTFORUM",
	 		mInstallURL : "./Dream?withyou=CTCER0069",
	 		mInstallPageOption : "width=450,height=400,left=10,top=10"
	}
	
	// 안전디스크, aStorage = SECUREDISK
	var aSecureDiskEnable = true; // true 설정 시 보안토큰 리스트에 안보임
	var aSecureDiskData = {
		mProvider : "SecureDisk",
		mInstallURL : "../securedisk/install.html",
		mInstallPageOption : "width=450,height=400,left=10,top=10"
	}
	
	// XecureFreeSign : aStorage = XFS
	var aXecureFreeSignEnable = false;
	var aXecureFreeSignData = {
		serviceURL : "https://xfs.hsecure.co.kr:8070/xfs/api/", // OpenAPI default URL
		registURL : "https://xfs.hsecure.co.kr:8081/portal/index.html#/main/", // 회원 가입 URL (새창 열림)
		serviceKey : "2",		// 서비스 키
		loginPass2 : true,		// 2차 인증 사용 유무
		signType : "server",	// 서명 방법, "server":서버 서명(default), "server-digest":서버 해쉬(원문) 서명, "client":클라이언트 서명(인증서 로밍)
		signOption : 0,			// 서명 옵션
		asyncOption: 3			// 0: 비동기 방식(진행창 O), 1: 동기 방식(진행창 X), 2: 저장매체 클릭 시만 비동기 방식, 3: 자동
	}
	
	// WebPage : aStorage = WEBPAGE
	var aWebPageStorageEnable = false;
	var aWebPageStorageData = {
		type : 0, // type - 0:value(certList), 1:DOM(storageElementID)
		certList : "",
		storageElementID : "AnySignCertInfo"
	}
	
	// XecureKeyPad E2E 사용 여부 (XecureFreeSign, WebPage 저장매체에 적용)
	var aXecureKeyPadE2EEnable = false;
	
	// Default Xgate Address.
	var aXgateAddress = window.location.hostname + ":20443:20999";

	// Xgate 접속 방식 (0: direct->proxy, 1:proxy, 2:proxy->direct)
	var aProxyUsage = "";

	// Default 패스워드 틀린횟수.
	var aLimitedTrial = 3;

	// Default CA list.
	/*
	var aCAList	= "Root CA,XecurePKI51 ca,cn=CA131000010,pki50ca,pki70_test_CA";
	aCAList		+= ",CA131000002Test,CA131000002,CA131000010,Softforum CA 3.0";
	aCAList		+= ",SoftforumCA,yessignCA-OCSP,signGATE CA,signGATE CA4,SignKorea CA,SignKorea CA2,CrossCertCA,CrossCertCA2";
	aCAList		+= ",CrossCertCA-Test2,3280TestCAServer,NCASignCA,TradeSignCA,TradeSignCA2,yessignCA-TEST";
	aCAList		+= ",lotto test CA,NCATESTSign,SignGateFTCA,SignKorea Test CA,SignKorea Test CA2,TestTradeSignCA";
	aCAList		+= ",Softforum Demo CA,mma ca,병무청 인증기관,MND CA,signGATE FTCA02";
	aCAList		+= ",.ROOT.CA.KT.BCN.BU,CA974000001,setest CA,3280TestCAServer";
	aCAList		+= ",yessignCA-Test Class 0,yessignCA-Test Class 1,yessignCA-Test Class 2,yessignCA-Test Class 3,TradeSignCA2009Test2,CrossCertTestCA2,1024TestCA";
	aCAList		+= ",yessignCA,yessignCA Class 1,yessignCA Class 2";
	aCAList		+= ",CA130000031T,CA131000031T,CA131100001,CA134040001,Test1024CA,subca,subca_02,MMACA001";
	*/
	var aCAList	= "yessignCA Class 1:1.2.410.200005.1.1.5";
	aCAList += ",yessignCA Class 2:1.2.410.200005.1.1.5";
	aCAList += ",yessignCA Class 3:1.2.410.200005.1.1.5";
	
	aCAList += ",TradeSignCA2:1.2.410.200012.1.1.3"; 
	aCAList += ",TradeSignCA3:1.2.410.200012.1.1.3";
	aCAList += ",TradeSignCA4:1.2.410.200012.1.1.3";
	
	aCAList += ",SignKorea CA2:1.2.410.200004.5.1.1.7";
	aCAList += ",SignKorea CA3:1.2.410.200004.5.1.1.7";
	aCAList += ",SignKorea CA4:1.2.410.200004.5.1.1.7";
	
	aCAList += ",CrossCertCA2:1.2.410.200004.5.4.1.2";
	aCAList += ",CrossCertCA3:1.2.410.200004.5.4.1.2";
	aCAList += ",CrossCertCA4:1.2.410.200004.5.4.1.2";
	
	aCAList += ",signGATE CA4:1.2.410.200004.5.2.1.1";
	aCAList += ",signGATE CA5:1.2.410.200004.5.2.1.1";
	aCAList += ",signGATE CA6:1.2.410.200004.5.2.1.1";
	
	// Storage 정보.
	var aStorage = "HARD,REMOVABLE,ICCARD,PKCS11,USBTOKEN,MOBISIGN,MPHONE,CSP,SMARTCERT,SECUREDISK";
	
	// 저장매체 버튼(인증서 위치) 사용 여부.
	var aStorageEnable = true;

	// Security Option 정보.
	var aSecurityOption = "0:browser:hard:removable:pkcs11:mphone:securedisk";

	// Security Key 정보.
	var aSecurityKey = "XW_SKS_SFVIRTUAL_DRIVER";

	// 인증서 선택시 만료일 경고창 설정 (Alert)
	var aExpireDateAlert = false;

	// SignDataCMSWithHTMLEx 설정
	var aSignHTMLOption = { aDelimiter: "&",
							aStringFormat: "%s" };

	// AnySignLite WebCMP RelayServer 정보.
	var aWebCMPRelayServerInfo = { aAddress: window.location.protocol + "//" + window.location.hostname,
							   	   aPort: window.location.protocol.indexOf("https") !== -1 ? "7072" : "7071" };

	// 인증서 관리자의 소유자 검증 버튼 사용 여부
	var aVerifyCertOwnerBtn = true;
	
	// Extension 관련 설정
	var aExtensionSetting = {
		mEncCallback: "",
		mLoadCallback: {func:null, param:null},
		mExternalCallback: {func:null, result:-1},
		mPageDecCallback: [],
		mPort: 31026,
		mDirectPort: 10530,
		mTrialPortRange: 1,
		mDialog: "", // guidewindow
		mInstallCheck_CB: null,
		mInstallCheck_State: null,
		mInstallCheck_Level: 0,
		mIntegrityPageURL: aBasePath + "/../test/check_integrity.jsp",
		mIgnoreInstallPage: false,
		mImgIntervalFunc: null,
		mImgIntervalError: false,
		mIsIE7: false
	};

	var aUISettings = {
		mCSSDefault : ""
	}
	
	return new UnifiedPluginInterface (aBasePath,
									   aTransKeyPath,
									   aTransKeyEnable,
									   aTransKeyCheckBoxEnable,
									   aTouchEnKeyEnable,
									   aAllowNativeInput,
									   aOpenkeyboardEnable,
									   aKDefenseEnable,
									   aVKeypadEnable,
									   aKeyCryptHTML5Enable,
									   aXecureKeyPadEnable,
									   aXecureKeyPadHTML5Enable,
									   aXecureKeyPadE2EEnable,
									   aASTxEnable,
									   aTouchEnnxKeyEnable,
									   aIncaNOSv10Enable,
									   aIncaNOSv10KeypadEnable,
									   aIncaNOSv10KeypadImgPath,
									   aKOSKeyEnable,
									   aEzKeyTecEnable,
									   aAnySignEnable,
									   aAnySignLiteEnable,
									   aHConvert2pfxDownloadURL,
									   aExportCertDownloadify,
									   aAnySignLoad,
									   aAnySignShowImg,
									   aAnySignLiveUpdate,
									   aAnySignSID,
									   aAnySignITGT,
									   aKDefenseE2EPrefix,
									   aUbikeyDataList,
									   aMobiSignData,
									   aVersion,
									   aXgateAddress,
									   aProxyUsage,
									   aLimitedTrial,
									   aCAList,
									   aStorage,
									   aSecurityOption,
									   aSecurityKey,
									   aSecurityContext,
									   aLicense,
									   aLanguage,
									   aCharset,
									   aEncCharset,
									   aExpireDateAlert,
									   aSignHTMLOption,
									   aExtensionSetting,
									   aUISettings,
									   aDivInsertOption,
									   aFinancialType,
									   aShowExpiredCert,
									   aShowLocationDialog,
									   aShowRenewCertSaveLoc,
									   aWBStyleApply,
									   aPageBlockDecDone,
									   aInstallPageNewOpen,
									   aEnhancedPW,
									   aSmartCertEnable,
									   aSmartCertDataList,
									   aUbikeyPKCS11Enable,
									   aUbikeyPKCS11Data,
									   aSecureDiskEnable,
									   aSecureDiskData,
									   aWebCMPRelayServerInfo,
									   aVerifyCertOwnerBtn,
									   aXecureFreeSignEnable,
									   aXecureFreeSignData,
									   aWebPageStorageEnable,
									   aWebPageStorageData,
									   aStorageEnable);
}

function UnifiedPluginInterface (aBasePath,
								 aTransKeyPath,
								 aTransKeyEnable,
								 aTransKeyCheckBoxEnable,
								 aTouchEnKeyEnable,
								 aAllowNativeInput,
								 aOpenkeyboardEnable,
								 aKDefenseEnable,
								 aVKeypadEnable,
								 aKeyCryptHTML5Enable,
								 aXecureKeyPadEnable,
								 aXecureKeyPadHTML5Enable,
								 aXecureKeyPadE2EEnable,
								 aASTxEnable,
								 aTouchEnnxKeyEnable,
								 aIncaNOSv10Enable,
								 aIncaNOSv10KeypadEnable,
								 aIncaNOSv10KeypadImgPath,
								 aKOSKeyEnable,
								 aEzKeyTecEnable,
								 aAnySignEnable,
								 aAnySignLiteEnable,
								 aHConvert2pfxDownloadURL,
								 aExportCertDownloadify,
								 aAnySignLoad,
								 aAnySignShowImg,
								 aAnySignLiveUpdate,
								 aAnySignSID,
								 aAnySignITGT,
								 aKDefenseE2EPrefix,
								 aUbikeyDataList,
								 aMobiSignData,
								 aVersion,
								 aXgateAddress,
								 aProxyUsage,
								 aLimitedTrial,
								 aCAList,
								 aStorage,
								 aSecurityOption,
								 aSecurityKey,
								 aSecurityContext,
								 aLicense,
								 aLanguage,
								 aCharset,
								 aEncCharset,
								 aExpireDateAlert,
								 aSignHTMLOption,
								 aExtensionSetting,
								 aUISettings,
								 aDivInsertOption,
								 aFinancialType,
								 aShowExpiredCert,
								 aShowLocationDialog,
								 aShowRenewCertSaveLoc,
								 aWBStyleApply,
								 aPageBlockDecDone,
								 aInstallPageNewOpen,
								 aEnhancedPW,
								 aSmartCertEnable,
								 aSmartCertDataList,
								 aUbikeyPKCS11Enable,
								 aUbikeyPKCS11Data,
								 aSecureDiskEnable,
								 aSecureDiskData,
								 aWebCMPRelayServerInfo,
								 aVerifyCertOwnerBtn,
								 aXecureFreeSignEnable,
								 aXecureFreeSignData,
								 aWebPageStorageEnable,
								 aWebPageStorageData,
								 aStorageEnable)
{
	this.mAnySignForPC = (function() {
			var req;
			if (window.ActiveXObject) {
				try {
					req = new ActiveXObject("MSXML2.XMLHTTP.3.0");
				}catch(e) {
					try {
						req = new ActiveXObject("Microsoft.XMLHTTP");
					}catch(e){}
				}
			}
			else if (window.XMLHttpRequest) {
				req = new window.XMLHttpRequest;
			}

			var d = new Date();
			var year = d.getFullYear().toString();
			var month = (d.getMonth()+1).toString();
			var day = d.getDate().toString();
			var hour = d.getHours().toString();
			var minutes = Math.floor(d.getMinutes()/10) * 10
					
			var path = aBasePath + "/AnySign4PC.js?version=" + year + month + day + hour + minutes;
			req.open ('GET', path, false);
			req.send (null);
			return eval(GetSafeResponse(req.responseText));			
		})();


	this.mPlatformList = 
	[
		{
			aName				: "linux",
			aSearchWord			: "Linux",
			aAnySignInstallPath	: 
			[
				window.location.protocol + "//download.softforum.com/Published/AnySign/v" + aVersion + "/anysign4pc_linux_i386.deb",
				window.location.protocol + "//download.softforum.com/Published/AnySign/v" + aVersion + "/anysign4pc_linux_i386.rpm",
				window.location.protocol + "//download.softforum.com/Published/AnySign/v" + aVersion + "/anysign4pc_linux_x86_64.deb",
				window.location.protocol + "//download.softforum.com/Published/AnySign/v" + aVersion + "/anysign4pc_linux_x86_64.rpm"
			],
			aInstallPage	: "./installAnySign.jsp"
		},
		{
			aName				: "mac universal",
			aSearchWord			: "Mac",
			aAnySignInstallPath	: window.location.protocol + "//download.softforum.com/Published/AnySign/v" + aVersion + "/anysign4pc_mac_universal.pkg",
			aInstallPage		: "./installAnySign.jsp"
		},
		{
			aName				: "windows 32bit",
			aSearchWord			: "Win32",
			aCABInstallPath		: "../install/xwcup_install_windows_x86.cab",
			aInstallPath		: "../install/xwcup_install_windows_x86.exe",
			aAnySignInstallPath	: "https://epro.wooribank.com/AnySign/install/AnySign_Installer.exe",
			aInstallPage		: "/AnySign/installAnySign.jsp"
		},
		{
			aName				: "windows 64bit",
			aSearchWord			: "Win64",
			aCABInstallPath		: "../install/xwcup_install_windows_x64.cab",
			aInstallPath		: "../install/xwcup_install_windows_x64.exe",
			aAnySignInstallPath	: "https://epro.wooribank.com/AnySign/install/AnySign_Installer.exe",
			aInstallPage		: "/AnySign/installAnySign.jsp"
		}
	]

	this.mBrowserList = 
	[
		{
			aName			: "opera",
			aSearchWord		: "OPR",
			aSearchLength	: 4,
			aMinVersion		: "20.00",
			aMaxVersion		: "9999.00"
		},
		{
			aName			: "explorer",
			aSearchWord		: "Edge",
			aSearchLength	: 5,
			aMinVersion		: "12.0",
			aMaxVersion		: "9999.0"
		},
		{
			aName			: "chrome",
			aSearchWord		: "Chrome",
			aSearchLength	: 7,
			aMinVersion		: "24.0",
			aMaxVersion		: "9999.0"
		},
		{
			aName			: "firefox",
			aSearchWord		: "Firefox",
			aSearchLength	: 8,
			aMinVersion		: "27.0",
			aMaxVersion		: "9999.0"
		},
		{
			aName			: "safari",
			aSearchWord		: "Safari",
			aSearchWord2	: "Version",
			aSearchLength	: 8,
			aMinVersion		: "5.0",
			aMaxVersion		: "9999.0"
		},
		{
			aName			: "opera",
			aSearchWord		: "Opera",
			aSearchWord2	: "Version",
			aSearchLength	: 8,
			aMinVersion		: "20.00",
			aMaxVersion		: "9999.00"
		},
		{
			aName			: "explorer",
			aSearchWord		: "MSIE",
			aSearchLength	: 5,
			aMinVersion		: "6.0",
			aMaxVersion		: "9999.0"
		},
		{
			aName			: "explorer",
			aSearchWord		: "Trident",
			aSearchWord2	: "rv",
			aSearchLength	: 3,
			aMinVersion		: "6.0",
			aMaxVersion		: "9999.0"
		}
	]

	this.mCAInfoList = 
	[
		{
			aName			: "Yessign test",
			aType			: 10,
			aCAType			: 11,
			aCAIPAddress	: "203.233.91.234",
			aCAPort			: 4512
		},
		{
			aName			: "XecureCA RSA",
			aType			: 11,
			aCAType			: 101,
			aCAIPAddress	: "192.168.0.26;1024TestCA",
			aCAPort			: 29211
		},
		{
			aName			: "XecureCA KCDSA",
			aType			: 12,
			aCAType			: 102,
			aCAIPAddress	: "192.168.0.26;1024TestCA",
			aCAPort			: 29211
		},
		{
			aName			: "Yessign test 2048",
			aType			: 13,
			aCAType			: 11,
			aCAIPAddress	: "203.233.91.231",
			aCAPort			: 4512,
			aCAHTTPService	: "/XFS/yessign/processCmp"
		},
		{
			aName			: "XecureCA 2048 RSA",
			aType			: 14,
			aCAType			: 101,
			aCAIPAddress	: "192.168.0.4;subca",
			aCAPort			: 21201,
			aCAHTTPService  : "/XFS/xecureca/processCmp"
		},
		{
			aName			: "XecureCA 2048 KCDSA",
			aType			: 15,
			aCAType			: 102,
			aCAIPAddress	: "192.168.0.4;CA974000031,Test2048CA",
			aCAPort			: 21201,
			aCAHTTPService  : "/XFS/xecureca/processCmp"
		},
		{
			aName			: "SignKorea",
			aType			: 16,
			aCAType			: 3,
			aCAIPAddress	: "211.175.81.101",
			aCAPort			: 4099
		},
		{
			aName			: "SignKorea test",
			aType			: 17,
			aCAType			: 13,
			aCAIPAddress	: "211.175.81.101",
			aCAPort			: 4099
		},
		{
			aName			: "Yessign MPKI test",
			aType			: 18,
			aCAType			: 110,
			aCAIPAddress	: "192.168.0.43",
			aCAPort			: 5302
		}
	]

	this.mRAList = 
	[
	 	{
	 		aOU				: "KFTC",
	 		aKRName			: "금융결제원",
	 		aUSName			: "Korea Financial Telecommunications & Clearings Institute"
	 	},
	 	{
	 		aOU				: "산업은행",
	 		aKRName			: "KDB",
	 		aUSName			: "Korea Development Bank"
	 	},
	 	{
	 		aOU				: "IBK",
	 		aKRName			: "기업은행",
	 		aUSName			: "Industrial Bank of Korea"
	 	},
	 	{
	 		aOU				: "KMB",
	 		aKRName			: "국민은행",
	 		aUSName			: "Kookmin Bank"
	 	},
	 	{
	 		aOU				: "KEB",
	 		aKRName			: "외환은행",
	 		aUSName			: "Korea Exchange Bank"
	 	},
	 	{
	 		aOU				: "NFFC",
	 		aKRName			: "수협은행",
	 		aUSName			: "National Federation of Fisheries Cooperatives"
	 	},
	 	{
	 		aOU				: "NACF",
	 		aKRName			: "농협은행",
	 		aUSName			: "National Agricultural Cooperatives Foundation"
	 	},
	 	{
	 		aOU				: "WOORI",
	 		aKRName			: "우리은행",
	 		aUSName			: "Woori Bank"
	 	},
	 	{
	 		aOU				: "CHB",
	 		aKRName			: "조흥은행",
	 		aUSName			: "Chohung Bank"
	 	},
	 	{
	 		aOU				: "KFB",
	 		aKRName			: "제일은행",
	 		aUSName			: "Standard Chartered Bank Korea Limited"
	 	},
	 	{
	 		aOU				: "SEOULBANK",
	 		aKRName			: "서울은행",
	 		aUSName			: "Seoul Bank"
	 	},
	 	{
	 		aOU				: "SHB",
	 		aKRName			: "신한은행",
	 		aUSName			: "Shinhan Bank"
	 	},
	 	{
	 		aOU				: "KAB",
	 		aKRName			: "한미은행",
	 		aUSName			: "KorAm Bank"
	 	},
	 	{
	 		aOU				: "DGB",
	 		aKRName			: "대구은행",
	 		aUSName			: "Daegu Bank"
	 	},
	 	{
	 		aOU				: "PSB",
	 		aKRName			: "부산은행",
	 		aUSName			: "Busan Bank"
	 	},
	 	{
	 		aOU				: "KJB",
	 		aKRName			: "광주은행",
	 		aUSName			: "Kwangju Bank"
	 	},
	 	{
	 		aOU				: "CJB",
	 		aKRName			: "제주은행",
	 		aUSName			: "Jeju Bank"
	 	},
	 	{
	 		aOU				: "JBB",
	 		aKRName			: "전북은행",
	 		aUSName			: "Jeonbuk Bank"
	 	},
	 	{
	 		aOU				: "KNBBANK",
	 		aKRName			: "경남은행",
	 		aUSName			: "Kyongnam Bank"
	 	},
	 	{
	 		aOU				: "KFCC",
	 		aKRName			: "새마을금고",
	 		aUSName			: "Korean Federation of Community Credit Cooperative"
	 	},
	 	{
	 		aOU				: "CUBANK",
	 		aKRName			: "신협",
	 		aUSName			: "National Credit Union Federation of Korea"
	 	},
	 	{
	 		aOU				: "CITI",
	 		aKRName			: "씨티은행",
	 		aUSName			: "Citibank"
	 	},
	 	{
	 		aOU				: "HSBC",
	 		aKRName			: "홍콩상하이은행",
	 		aUSName			: "Hongkong and Shanghai Banking Corporation"
	 	},
	 	{
	 		aOU				: "DEUT",
	 		aKRName			: "도이치뱅크",
	 		aUSName			: "Deutsche Bank"
	 	},
	 	{
	 		aOU				: "BANA",
	 		aKRName			: "Bank of America",
	 		aUSName			: "Bank of America"
	 	},
	 	{
	 		aOU				: "HNB",
	 		aKRName			: "하나은행",
	 		aUSName			: "Hana Bank"
	 	},
	 	{
	 		aOU				: "SOFTFORUM",
	 		aKRName			: "소프트포럼",
	 		aUSName			: "SoftForum"
	 	}
	]

	try
	{
		this.mID = "XWCDataPlugin";
		this.mMimeType = "application/xecureweb-unified-plugin";
		this.mClassID = "CLSID:02CD96E4-8C5B-451C-AEE8-FE89D83BFC58";
		this.mVersion = aVersion;
		this.mAnySignVersion = aVersion;
		this.mXgateAddress = aXgateAddress;
		this.mProxyUsage = aProxyUsage;
		this.mLimitedTrial = aLimitedTrial;
		this.mCAList = aCAList;
		this.mStorage = aStorage;
		this.mSecurityOption = aSecurityOption;
		this.mSecurityKey = aSecurityKey;
		this.mSecurityContext = aSecurityContext;
		this.mLicense = aLicense;
		this.mLanguage = aLanguage;
		this.mCharset = aCharset;
		this.mEncCharset = aEncCharset;
		this.mBasePath = aBasePath;
		this.mTransKeyPath = aTransKeyPath;
		this.mTransKeyEnable = aTransKeyEnable;
		this.mTransKeyCheckBoxEnable = aTransKeyCheckBoxEnable;
		this.mTransKeyIsXC = false;
		this.mTouchEnKeyEnable = aTouchEnKeyEnable;
		this.mUbikeyData = this.GetUbiKeyData (aUbikeyDataList);
		this.mMobiSignData = aMobiSignData;
		this.mExpireDateAlert = aExpireDateAlert;
		this.mSignHTMLOption = aSignHTMLOption;
		this.mPlatform = this.GetPlatform ();
		this.mBrowser = this.GetBrowser ();
		this.mBrowser.aVersion = this.GetBrowserVersion ();
		this.mExtensionSetting = aExtensionSetting;
		this.mUISettings= aUISettings;
		this.mAllowNativeInput = aAllowNativeInput;
		this.mOpenkeyboardEnable = aOpenkeyboardEnable;
		this.mKDefenseEnable = aKDefenseEnable;
		this.mVKeypadEnable = aVKeypadEnable;
		this.mKeyCryptHTML5Enable = aKeyCryptHTML5Enable;
		this.mXecureKeyPadEnable = aXecureKeyPadEnable;
		this.mXecureKeyPadHTML5Enable = aXecureKeyPadHTML5Enable;
		this.mXecureKeyPadE2EEnable = aXecureKeyPadE2EEnable;
		this.mASTxEnable = aASTxEnable;
		this.mTouchEnnxKeyEnable = aTouchEnnxKeyEnable;
		this.mIncaNOSv10Enable = aIncaNOSv10Enable;
		this.mIncaNOSv10KeypadEnable = aIncaNOSv10KeypadEnable;
		this.mIncaNOSv10KeypadImgPath = aIncaNOSv10KeypadImgPath;
		this.mKOSKeyEnable = aKOSKeyEnable;
		this.mEzKeyTecEnable = aEzKeyTecEnable;
		this.mAnySignEnable = aAnySignEnable;
		this.mAnySignLiteEnable = aAnySignLiteEnable;
		this.mAnySignLiteSupport = aAnySignLiteEnable;
		this.mHConvert2pfxDownloadURL = aHConvert2pfxDownloadURL;
		this.mExportCertDownloadify = aExportCertDownloadify;
		this.mStartAnySign = false;
		this.mAnySignLoad = aAnySignLoad;
		this.mAnySignShowImg = aAnySignShowImg;
		this.mAnySignLiveUpdate = aAnySignLiveUpdate;
		this.mAnySignSID = aAnySignSID;
		this.mAnySignITGT = aAnySignITGT;
		this.mKDefenseE2EPrefix = aKDefenseE2EPrefix;
		this.mDivInsertOption = aDivInsertOption;
		this.mFinancialType = aFinancialType;
		this.mShowExpiredCert = aShowExpiredCert;
		this.mShowLocationDialog = aShowLocationDialog;
		this.mShowRenewCertSaveLoc = aShowRenewCertSaveLoc;
		this.mWBStyleApply = aWBStyleApply;
		this.mPageBlockDecDone = aPageBlockDecDone;
		this.mInstallPageNewOpen = aInstallPageNewOpen;
		this.mEnhancedPW = aEnhancedPW;
		this.mSmartCertEnable = aSmartCertEnable;
		this.mSmartCertDataList = aSmartCertDataList;
		this.mUbikeyPKCS11Enable = aUbikeyPKCS11Enable;
		this.mUbikeyPKCS11Data = aUbikeyPKCS11Data;
		this.mSecureDiskEnable = aSecureDiskEnable;
		this.mSecureDiskData = aSecureDiskData;
		this.mWebCMPRelayServerInfo = aWebCMPRelayServerInfo;
		this.mVerifyCertOwnerBtn = aVerifyCertOwnerBtn;
		this.mXecureFreeSignEnable = aXecureFreeSignEnable;
		this.mXecureFreeSignSupport = aXecureFreeSignEnable;
		this.mXecureFreeSignData = aXecureFreeSignData;
		this.mWebPageStorageEnable = aWebPageStorageEnable;
		this.mWebPageStorageSupport = aWebPageStorageEnable;
		this.mWebPageStorageData = aWebPageStorageData;
		this.mStorageEnable = aStorageEnable;
	}
	catch (aException)
	{
		var aMessage = null;

		switch (aException)
		{
			case "UPE_UNKNOWN_PLATFORM":
				aMessage = "Unknown Platform";
				break;
			case "UPE_UNKNOWN_BROWSER":
				aMessage = "Unknown Browser";
				break;
			case "UPE_BROWSER_SEARCHWORD_FAIL":
				aMessage = "Set Browser Search Word";
				break;
			default:
				aMessage = "Unknown Exception";
				break;
		}

		alert ("EXCEPTION\n" + aMessage);
	}
}

UnifiedPluginInterface.prototype.GetUbiKeyData = function (aUbikeyDataList)
{
	var aResult = null;
	var aIter = 0;
	var aStartPosition = 0;
	
	for (aIter = 0; aIter < aUbikeyDataList.length; ++aIter)
	{
		aStartPosition = navigator.platform.indexOf (aUbikeyDataList[aIter].mPlatForm);
		if (aStartPosition == -1)
			continue;
	
		aResult = aUbikeyDataList[aIter];
		break;
	}
	
	if (aResult == null)
		throw ("UPE_UNKNOWN_UBIKEYDATA");
	
	return aResult;
}

UnifiedPluginInterface.prototype.GetPlatform = function ()
{
	var aResult = null;
	var aIter = 0;
	var aStartPosition = 0;

	for (aIter = 0; aIter < this.mPlatformList.length; ++aIter)
	{
		aStartPosition = navigator.platform.indexOf (this.mPlatformList [aIter].aSearchWord);
		if (aStartPosition == -1)
		{
			continue;
		}

		aResult = this.mPlatformList [aIter];
	}

	if (aResult == null)
	{
		throw ("UPE_UNKNOWN_PLATFORM");
	}

	return aResult;
}

UnifiedPluginInterface.prototype.GetBrowser = function ()
{
	var aResult = null;
	var aIter = 0;
	var aCurrentBrowser = 0;
	var aStartPosition = 0;

	for (aIter = 0; aIter < this.mBrowserList.length; ++aIter)
	{
		aStartPosition = navigator.userAgent.indexOf (this.mBrowserList [aIter].aSearchWord);

		if (aStartPosition == -1)
		{
			continue;
		}

		aResult = this.mBrowserList [aIter];
		break;
	}

	if (aResult == null)
	{
		throw ("UPE_UNKNOWN_BROWSER");
	}

	return aResult;
}

UnifiedPluginInterface.prototype.GetBrowserVersion = function ()
{
	var aResult = null;
	var aStartPosition = 0;
	var aEndPosition = 0;

	if (this.mBrowser.aSearchWord2 != undefined)
	{
		aStartPosition = navigator.userAgent.indexOf (this.mBrowser.aSearchWord2);
	}
	else
	{
		aStartPosition = navigator.userAgent.indexOf (this.mBrowser.aSearchWord);
	}

	if (aStartPosition == -1)
	{
		throw ("UPE_BROWSER_SEARCHWORD_FAIL");
	}

	aStartPosition += this.mBrowser.aSearchLength;
	aResult = navigator.userAgent.substr (aStartPosition);

	if( this.mBrowser.aSearchWord.indexOf("MSIE") == -1 )
	{
		aEndPosition = aResult.indexOf (" ");
	}
	else
	{
		aEndPosition = aResult.indexOf (";");
	}

	if (aEndPosition == -1)
	{
		aResult = aResult.substr (0);
	}
	else
	{
		aResult = aResult.substring (0, aEndPosition);
	}

	aResult = aResult.replace (";", "");
	aResult = aResult.replace (")", "");

	return aResult;
}

UnifiedPluginInterface.prototype.IsSupportedBrowser = function ()
{
	var aResult = false;
	var aRoopCount = 0;
	var aIter = 0;
	var aLocalVersion = null;
	var aMinVersion = null;
	var aMaxVersion = null;

	aLocalVersion = this.mBrowser.aVersion.split (".");
	aMinVersion = this.mBrowser.aMinVersion. split (".");
	aMaxVersion = this.mBrowser.aMaxVersion. split (".");

	if (aLocalVersion.length - aMinVersion.length > 0)
	{
		aRoopCount = aLocalVersion.length;
	}
	else
	{
		aRoopCount = aMinVersion.length;
	}

	for (aIter = 0;aRoopCount > aIter;aIter++)
	{
		if (aLocalVersion [aIter] == undefined)
		{
			aLocalVersion [aIter] = '0';
		}

		if (aMinVersion [aIter] == undefined)
		{
			aMinVersion [aIter] = '0';
		}

		if (aLocalVersion [aIter] - aMinVersion [aIter] < 0)
		{
			aResult = false;
			break;
		}

		if (aLocalVersion [aIter] - aMinVersion [aIter] > 0)
		{
			aResult = true;
			break;
		}

		if (aRoopCount - 1 == aIter)
		{
			aResult = true;
		}
	}

	if (aResult == false)
	{
		return aResult;
	}

	if (aLocalVersion.length - aMaxVersion.length > 0)
	{
		aRoopCount = aLocalVersion.length;
	}
	else
	{
		aRoopCount = aMaxVersion.length;
	}

	for (aIter = 0;aRoopCount > aIter;aIter++)
	{
		if (aLocalVersion [aIter] == undefined)
		{
			aLocalVersion [aIter] = '0';
		}

		if (aMaxVersion [aIter] == undefined)
		{
			aMaxVersion [aIter] = '0';
		}

		if (aLocalVersion [aIter] - aMaxVersion [aIter] > 0)
		{
			aResult = false;
			break;
		}

		if (aLocalVersion [aIter] - aMaxVersion [aIter] < 0)
		{
			aResult = true;
			break;
		}

		if (aRoopCount - 1 == aIter)
		{
			aResult = true;
		}
	}

	return aResult;
}

UnifiedPluginInterface.prototype.IsNull = function (aCheckValue,
	   												aDefaultValue)
{
	var aResult = null;

	if (aCheckValue == null || aCheckValue.length == 0)
	{
		aResult = aDefaultValue;
	}
	else
	{
		aResult = aCheckValue;
	}

	return aResult;
}

UnifiedPluginInterface.prototype.SetUITarget = function (aElement)
{
	if (AnySign.mDivInsertOption == true || AnySign.mDivInsertOption > 0) {
		AnySign.mUISettings.mUITarget = aElement;
	}
}

UnifiedPluginInterface.prototype.GetUITarget= function ()
{
	return AnySign.mUISettings.mUITarget;
}

UnifiedPluginInterface.prototype.LoadExtension= function (aName)
{
	return this.mAnySignForPC.LoadExtension(aName);
}

UnifiedPluginInterface.prototype.StartAnySign = function (aIgnoreInstallpage, aTargetElement)
{
	var aAnySignModule,
		aConnectPort = AnySign.mExtensionSetting.mDirectPort+1,
		aName = "Unknown",
		aURL;
	
	// 중복 호출 방지
	/*
	if (AnySign.mStartAnySign == true)
		return;
	*/
	if (AnySign.mAnySignLoad == true)
		return;
	
	AnySign.mStartAnySign = true;
	
	if (this.IsSupportedBrowser () == false)
	{
		alert (this.mBrowser.aName + " " + this.mBrowser.aVersion +
			   "은(는) 지원하지 않는 브라우저입니다.\n최신버전으로 업데이트하시기 바랍니다.");
		return;
	}

	try {
		if (typeof WebSocket != "undefined") {
			if (this.mBrowser.aName == "explorer") {
				aURL = "wss://127.0.0.1:";
			} else {
				aURL = "wss://localhost:";
			}
			aURL = aURL + aConnectPort;
			var aWS = new WebSocket(aURL);
			aName = "AnySign.js";
			aWS.close();
		} else if (typeof XDomainRequest != "undefined") {
			if (window.location.protocol.indexOf("http:") != 0) {
				aURL = "https://127.0.0.1:" + aConnectPort;
			} else {
				aURL = "http://127.0.0.1:" + aConnectPort;
			} 
				var aXDR = new XDomainRequest();
				aXDR.open("POST", aURL);
				aName = "AnySignJSONP.js";
		} else {
			AnySign.mExtensionSetting.mIsIE7 = true;
			aName = "AnySignJSONP.js";
		}
	} catch (e) {
		if (aName == "Unknown") {
			aName = "AnySignJSONP.js";
		}
	}

	AnySign.mExtensionSetting.mIgnoreInstallPage = aIgnoreInstallpage;
	if (AnySign.mAnySignShowImg.showImg)
		AnySign.mExtensionSetting.mImgIntervalFunc = setInterval(showAnySignLoadingImg, 50);

	console.log ("[AnySign4PC] " + this.mBrowser.aName + ": " + this.mBrowser.aVersion);
	console.log ("[AnySign4PC] Extension Module Type: " + aName);

	if (aName != "AnySignJSONP.js") {
		try {
			var JSONData = {"anySign":[{"module":"ext"}]}
			var JSONResult = JSON.stringify (JSONData);
		} catch (e) {
			aAnySignModule = this.LoadExtension ("json2.js");
		}
	}

	aAnySignModule = this.LoadExtension (aName);
	this.mAnySignForPC.SetExtension(aAnySignModule);
}

UnifiedPluginInterface.prototype.setAnySignLite = function(aEnableLite, aEnableXFS)
{
	// AnySignLite setting
	if (aEnableLite == false) {
		this.mAnySignLiteSupport = false;
	} else {
		this.mAnySignLiteSupport = this.mAnySignLiteEnable;
	}
	
	// XecureFreeSign, WebPage Storage setting
	if (aEnableXFS == false) {
		this.mXecureFreeSignSupport = false;
		this.mWebPageStorageSupport = false;
	} else {
		this.mXecureFreeSignSupport = this.mXecureFreeSignEnable;
		this.mWebPageStorageSupport = this.mWebPageStorageEnable;
	}
	
	if (!this.mAnySignLiteSupport && !this.mXecureFreeSignSupport && !this.mWebPageStorageSupport) {
		this.mAnySignEnable = true;
		return false;
	}
	
	if (typeof XCrypto == "undefined") {
		this.mAnySignEnable = true;
		this.mAnySignLiteSupport = false;
		this.mXecureFreeSignSupport = false;
		this.mWebPageStorageSupport = false;
		return false;
	}
	
	if (XCrypto.checkXCrypto() != 0) {
		this.mAnySignEnable = true;
		this.mAnySignLiteSupport = false;
		this.mXecureFreeSignSupport = false;
		this.mWebPageStorageSupport = false;
		return false;
	}
	
	// AnySignLite or XecureFreeSign support
	this.mAnySignEnable = false;
	return true;
}

UnifiedPluginInterface.prototype.GetDefaultLocation = function (aCertLocation)
{
	function _getDefaultLocation() {
		if (AnySign.mAnySignLiteSupport) {
			AnySign.mAnySignEnable = false;
			return 2000;	// localstorage
		} else if (AnySign.mXecureFreeSignSupport) {
			AnySign.mAnySignEnable = false;
			return 2300;	// XecureFreeSign
		} else {
			AnySign.mAnySignEnable = true;
			return 1;		// hdd
		}
	}
	
	// null
	if (aCertLocation == undefined || aCertLocation == null || aCertLocation == "" || aCertLocation.length == 0 || aCertLocation < 0) {
		return _getDefaultLocation();
	}
	
	// lite
	if (aCertLocation == 2000 || aCertLocation == 2100 || aCertLocation == 2200) {
		return _getDefaultLocation();
	}
	
	// XecureFreeSign
	if (aCertLocation == 2300) {
		if (!this.mXecureFreeSignSupport) {
			return _getDefaultLocation();
		}
		this.mAnySignEnable = false;
		return 2300;
	}
	
	// 4pc
	this.mAnySignEnable = true;
	return aCertLocation;
}

UnifiedPluginInterface.prototype.GetCertPath = function (aUserCallback, aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	this.mAnySignForPC.GetCertPath (aUserCallback, aErrCallback);
}

UnifiedPluginInterface.prototype.SignDataCMS = function (aXgateAddress,
														 aCAList,
														 aPlain,
														 aOption,
														 aDescription,
														 aLimitedTrial,
														 aUserCallback,
														 aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);

	this.mAnySignForPC.SignDataCMS (aXgateAddress,
									aCAList,
									aPlain,
									aOption,
									aDescription,
									aLimitedTrial,
									aUserCallback,
									aErrCallback);
}

UnifiedPluginInterface.prototype.SignDataAdd = function (aXgateAddress,
														 aCAList,
														 aPlain,
														 aOption,
														 aDescription,
														 aLimitedTrial,
														 aUserCallback,
														 aErrCallback)
{
	// AnySignLite 지원
	if (this.mXecureFreeSignData.signType != "client")
		this.setAnySignLite(true, false);
	else
		this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);

	this.mAnySignForPC.SignDataAdd (aXgateAddress,
									aCAList,
									aPlain,
									aOption,
									aDescription,
									aLimitedTrial,
									aUserCallback,
									aErrCallback);
}

UnifiedPluginInterface.prototype.SignDataAddWithCacheCert = function (aOption,
																	  aPlain,
																	  aUserCallback,
																	  aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	this.mAnySignForPC.SignDataAddWithCacheCert (this.mXgateAddress,
												 aOption,
												 aPlain,
												 aUserCallback,
												 aErrCallback);
}

UnifiedPluginInterface.prototype.SignDataCMSWithCacheCert = function (aXgateAddress,
																	  aPlain,
																	  aOption,
																	  aUserCallback,
																	  aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);

	this.mAnySignForPC.SignDataCMSWithCacheCert (aXgateAddress,
												 aPlain,
												 aOption,
												 aUserCallback,
												 aErrCallback);
}

UnifiedPluginInterface.prototype.SignFile = function (aXgateAddress,
													  aCAList,
													  aPlainFilePath,
													  aSignedFilePath,
													  aOption,
													  aDescription,
													  aLimitedTrial,
													  aUserCallback,
													  aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);

	this.mAnySignForPC.SignFile (aXgateAddress,
								 aCAList,
								 aPlainFilePath,
								 aSignedFilePath,
								 aOption,
								 aDescription,
								 aLimitedTrial,
								 aUserCallback,
								 aErrCallback);
}

UnifiedPluginInterface.prototype.ShowSignFileSelectDialog = function (aUserCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	this.mAnySignForPC.ShowSignFileSelectDialog (aUserCallback);
}

UnifiedPluginInterface.prototype.SignDataCMSWithSerial = function (aXgateAddress,
																   aCAList,
																   aCertSerial,
																   aCertLocation,
																   aPlain,
																   aOption,
																   aDescription,
																   aLimitedTrial,
																   aUserCallback,
																   aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aCertSerial		= this.IsNull (aCertSerial, "");
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	
	aCertLocation	= this.GetDefaultLocation (aCertLocation);

	this.mAnySignForPC.SignDataCMSWithSerial (aXgateAddress,
											  aCAList,
											  aCertSerial,
											  aCertLocation,
											  aPlain,
											  aOption,
											  aDescription,
											  aLimitedTrial,
											  aUserCallback,
											  aErrCallback);
}

UnifiedPluginInterface.prototype.SignDataCMSWithSerial_Location = function (aXgateAddress,
																			aCAList,
																			aCertSerial,
																			aCertLocation,
																			aPlain,
																			aOption,
																			aDescription,
																			aLimitedTrial,
																			aUserCallback,
																			aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aCertSerial		= this.IsNull (aCertSerial, "");
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	
	_CB_getLastLocation = function (aResult)
	{
		if (aResult) aCertLocation = aResult;
		
		aCertLocation = AnySign.GetDefaultLocation (aCertLocation);
		
		AnySign.mAnySignForPC.SignDataCMSWithSerial (aXgateAddress,
													 aCAList,
													 aCertSerial,
													 aCertLocation,
													 aPlain,
													 aOption,
													 aDescription,
													 aLimitedTrial,
													 aUserCallback,
													 aErrCallback);
	}
	
	this.mAnySignForPC.GetLastLocation (_CB_getLastLocation);
}

UnifiedPluginInterface.prototype.SignDataCMSWithHTMLEx = function (aXgateAddress,
																   aCAList,
																   aForm,
																   aPlain,
																   aCert,
																   aOption,
																   aDescription,
																   aLimitedTrial,
																   aUserCallback,
																   aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);

	this.mAnySignForPC.SignDataCMSWithHTMLEx (aXgateAddress,
											  aCAList,
											  aForm,
											  aPlain,
											  aCert,
											  aOption,
											  aDescription,
											  aLimitedTrial,
											  aUserCallback,
											  aErrCallback);
}

UnifiedPluginInterface.prototype.SignDataCMSWithHTMLExAndSerial = function (aXgateAddress,
																			aCAList,
																			aCertSerial,
																			aCertLocation,
																			aForm,
																			aPlain,
																			aCert,
																			aOption,
																			aDescription,
																			aLimitedTrial,
																			aUserCallback,
																			aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aCertSerial		= this.IsNull (aCertSerial, "");
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	
	aCertLocation	= this.GetDefaultLocation (aCertLocation);

	this.mAnySignForPC.SignDataCMSWithHTMLExAndSerial (aXgateAddress,
													   aCAList,
													   aCertSerial,
													   aCertLocation,
													   aForm,
													   aPlain,
													   aCert,
													   aOption,
													   aDescription,
													   aLimitedTrial,
													   aUserCallback,
													   aErrCallback);
}

UnifiedPluginInterface.prototype.SignDataCMSWithHTMLExAndSerial_Location = function (aXgateAddress,
																					 aCAList,
																					 aCertSerial,
																					 aCertLocation,
																					 aForm,
																					 aPlain,
																					 aCert,
																					 aOption,
																					 aDescription,
																					 aLimitedTrial,
																					 aUserCallback,
																					 aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aCertSerial		= this.IsNull (aCertSerial, "");
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	
	_CB_getLastLocation = function (aResult)
	{
		if (aResult) aCertLocation = aResult;
		
		aCertLocation = AnySign.GetDefaultLocation (aCertLocation);
		
		AnySign.mAnySignForPC.SignDataCMSWithHTMLExAndSerial (aXgateAddress,
															  aCAList,
															  aCertSerial,
															  aCertLocation,
															  aForm,
															  aPlain,
															  aCert,
															  aOption,
															  aDescription,
															  aLimitedTrial,
															  aUserCallback,
															  aErrCallback);
	}
	
	this.mAnySignForPC.GetLastLocation (_CB_getLastLocation);
}

UnifiedPluginInterface.prototype.SignDataWithVID = function (aXgateAddress,
															 aCAList,
															 aPlain,
															 aOption,
															 aDescription,
															 aLimitedTrial,
															 aIdn,
															 aSvrCert,
															 aUserCallback,
															 aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);

	AnySignForPC.SignDataWithVID_Serial (aXgateAddress,
										 aCAList,
										 null,
										 null,
										 aPlain,
										 aOption,
										 aDescription,
										 aLimitedTrial,
										 aIdn,
										 aSvrCert,
										 aUserCallback,
										 aErrCallback);
}

UnifiedPluginInterface.prototype.SignDataAddWithVID = function (aXgateAddress,
																aCAList,
																aPlain,
																aOption,
																aDescription,
																aLimitedTrial,
																aIdn,
																aSvrCert,
																aUserCallback,
																aErrCallback)
{
	// AnySignLite 지원
	if (this.mXecureFreeSignData.signType != "client")
		this.setAnySignLite(true, false);
	else
		this.setAnySignLite();

	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	aXgateAddress = this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList   = this.IsNull (aCAList, this.mCAList);
	aDescription = this.IsNull (aDescription, "");
	aLimitedTrial = this.IsNull (aLimitedTrial, this.mLimitedTrial);

	AnySignForPC.SignDataAddWithVID_Serial (aXgateAddress,
											aCAList,
											null,
											null,
											aPlain,
											aOption,
											aDescription,
											aLimitedTrial,
											aIdn,
											aSvrCert,
											aUserCallback,
											aErrCallback);
}

UnifiedPluginInterface.prototype.SignDataWithVID_Serial = function (aXgateAddress,
																	aCAList,
																	aCertSerial,
																	aCertLocation,
																	aPlain,
																	aOption,
																	aDescription,
																	aLimitedTrial,
																	aIdn,
																	aSvrCert,
																	aUserCallback,
																	aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aCertSerial		= this.IsNull (aCertSerial, "");
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	
	aCertLocation	= this.GetDefaultLocation (aCertLocation);

	AnySignForPC.SignDataWithVID_Serial (aXgateAddress,
										 aCAList,
										 aCertSerial,
										 aCertLocation,
										 aPlain,
										 aOption,
										 aDescription,
										 aLimitedTrial,
										 aIdn,
										 aSvrCert,
										 aUserCallback,
										 aErrCallback);
}

UnifiedPluginInterface.prototype.SignDataWithVID_Serial_Location = function (aXgateAddress,
																			 aCAList,
																			 aCertSerial,
																			 aCertLocation,
																			 aPlain,
																			 aOption,
																			 aDescription,
																			 aLimitedTrial,
																			 aIdn,
																			 aSvrCert,
																			 aUserCallback,
																			 aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aCertSerial		= this.IsNull (aCertSerial, "");
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	
	_CB_getLastLocation = function (aResult)
	{
		if (aResult) aCertLocation = aResult;
		
		aCertLocation = AnySign.GetDefaultLocation (aCertLocation);
		
		AnySign.mAnySignForPC.SignDataWithVID_Serial (aXgateAddress,
													  aCAList,
													  aCertSerial,
													  aCertLocation,
													  aPlain,
													  aOption,
													  aDescription,
													  aLimitedTrial,
													  aIdn,
													  aSvrCert,
													  aUserCallback,
													  aErrCallback);
	}
	
	this.mAnySignForPC.GetLastLocation (_CB_getLastLocation);
}

UnifiedPluginInterface.prototype.SignDataWithVID_CacheCert = function (aXgateAddress,
																	   aPlain,
																	   aOption,
																	   aIdn,
																	   aSvrCert,
																	   aUserCallback,
																	   aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aSvrCert == null || aSvrCert.length == 0)
	{
		alert ("[SignDataWithVID_CacheCert] invalid parameters");
		return;
	}
	/*
	if (!((aOption & 0x08) || (aOption & 0x10)))
	{
		alert("[SignDataWithVID_CacheCert] invalid option.");
		return;
	}
	*/
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	
	AnySignForPC.SignDataWithVID_CacheCert (aXgateAddress,
											aPlain,
											aOption,
											aIdn,
											aSvrCert,
											aUserCallback,
											aErrCallback);
}

UnifiedPluginInterface.prototype.SignFileInfo = function (aXgateAddress,
														  aCAList,
														  aFileInfo,
														  aFileHash,
														  aOption,
														  aDescription,
														  aLimitedTrial,
														  aUserCallback,
														  aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
		
	if (aFileInfo == undefined || aFileInfo == "" || aFileHash == undefined || aFileHash == "")
	{
		alert("[SignFileInfo] invalid parameters.");
		return;
	}
	
	var aFileInfoArray = aFileInfo.split("|");
	var aFileHashArray = aFileHash.split("|");
	if (aFileInfoArray[1] == undefined || aFileInfoArray[1] == "" || aFileHashArray[1] == undefined || aFileHashArray[1] == "")
	{
		alert("[SignFileInfo] invalid parameters.");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	
	this.mAnySignForPC.SignFileInfo (aXgateAddress,
									 aCAList,
									 aFileInfo,
									 aFileHash,
									 aOption,
									 aDescription,
									 aLimitedTrial,
									 aUserCallback,
									 aErrCallback);
}

UnifiedPluginInterface.prototype.SignFileInfoWithSerial = function (aXgateAddress,
																	aCAList,
																	aCertSerial,
																	aCertLocation,
																	aFileInfo,
																	aFileHash,
																	aOption,
																	aDescription,
																	aLimitedTrial,
																	aUserCallback,
																	aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
		
	if (aFileInfo == undefined || aFileInfo == "" || aFileHash == undefined || aFileHash == "")
	{
		alert("[SignFileInfoWithSerial] invalid parameters.");
		return;
	}
	
	var aFileInfoArray = aFileInfo.split("|");
	var aFileHashArray = aFileHash.split("|");
	if (aFileInfoArray[1] == undefined || aFileInfoArray[1] == "" || aFileHashArray[1] == undefined || aFileHashArray[1] == "")
	{
		alert("[SignFileInfoWithSerial] invalid parameters.");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aCertSerial		= this.IsNull (aCertSerial, "");
	aCertLocation	= this.IsNull (aCertLocation, 1);	 // 1 hdd
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	
	this.mAnySignForPC.SignFileInfoWithSerial (aXgateAddress,
											   aCAList,
											   aCertSerial,
											   aCertLocation,
											   aFileInfo,
											   aFileHash,
											   aOption,
											   aDescription,
											   aLimitedTrial,
											   aUserCallback,
											   aErrCallback);
}

UnifiedPluginInterface.prototype.SignFileInfoWithVID = function (aXgateAddress,
																 aCAList,
																 aFileInfo,
																 aFileHash,
																 aOption,
																 aDescription,
																 aLimitedTrial,
																 aIdn,
																 aSvrCert,
																 aUserCallback,
																 aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
		
	if (aFileInfo == undefined || aFileInfo == "" || aFileHash == undefined || aFileHash == "")
	{
		alert("[SignFileInfoWithVID] invalid parameters.");
		return;
	}
	
	var aFileInfoArray = aFileInfo.split("|");
	var aFileHashArray = aFileHash.split("|");
	if (aFileInfoArray[1] == undefined || aFileInfoArray[1] == "" || aFileHashArray[1] == undefined || aFileHashArray[1] == "")
	{
		alert("[SignFileInfoWithVID] invalid parameters.");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	
	this.mAnySignForPC.SignFileInfoWithVID_Serial (aXgateAddress,
												   aCAList,
												   null,
												   null,
												   aFileInfo,
												   aFileHash,
												   aOption,
												   aDescription,
												   aLimitedTrial,
												   aIdn,
												   aSvrCert,
												   aUserCallback,
												   aErrCallback);
}

UnifiedPluginInterface.prototype.SignFileInfoWithVID_Serial = function (aXgateAddress,
																		aCAList,
																		aCertSerial,
																		aCertLocation,
																		aFileInfo,
																		aFileHash,
																		aOption,
																		aDescription,
																		aLimitedTrial,
																		aIdn,
																		aSvrCert,
																		aUserCallback,
																		aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
		
	if (aFileInfo == undefined || aFileInfo == "" || aFileHash == undefined || aFileHash == "")
	{
		alert("[SignFileInfoWithVID_Serial] invalid parameters.");
		return;
	}
	
	var aFileInfoArray = aFileInfo.split("|");
	var aFileHashArray = aFileHash.split("|");
	if (aFileInfoArray[1] == undefined || aFileInfoArray[1] == "" || aFileHashArray[1] == undefined || aFileHashArray[1] == "")
	{
		alert("[SignFileInfoWithVID_Serial] invalid parameters.");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aCertSerial		= this.IsNull (aCertSerial, "");
	aCertLocation	= this.IsNull (aCertLocation, 1);	 // 1 hdd
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	
	this.mAnySignForPC.SignFileInfoWithVID_Serial (aXgateAddress,
												   aCAList,
												   aCertSerial,
												   aCertLocation,
												   aFileInfo,
												   aFileHash,
												   aOption,
												   aDescription,
												   aLimitedTrial,
												   aIdn,
												   aSvrCert,
												   aUserCallback,
												   aErrCallback);
}

UnifiedPluginInterface.prototype.MultiSignFileInfo = function (aMultiSignID,
															   aXgateAddress,
															   aCAList,
															   aOption,
															   aDescription,
															   aLimitedTrial,
															   aUserCallback,
															   aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	
	this.mAnySignForPC.MultiSignFileInfo (aMultiSignID,
										  aXgateAddress,
										  aCAList,
										  aOption,
										  aDescription,
										  aLimitedTrial,
										  aUserCallback,
										  aErrCallback);
}

UnifiedPluginInterface.prototype.MultiSignFileInfoWithSerial = function (aMultiSignID,
																		 aXgateAddress,
																		 aCAList,
																		 aCertSerial,
																		 aCertLocation,
																		 aOption,
																		 aDescription,
																		 aLimitedTrial,
																		 aUserCallback,
																		 aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aCertSerial		= this.IsNull (aCertSerial, "");
	aCertLocation	= this.IsNull (aCertLocation, 1);	 // 1 hdd
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	
	this.mAnySignForPC.MultiSignFileInfoWithSerial (aMultiSignID,
													aXgateAddress,
													aCAList,
													aCertSerial,
													aCertLocation,
													aOption,
													aDescription,
													aLimitedTrial,
													aUserCallback,
													aErrCallback);
}

UnifiedPluginInterface.prototype.GetVidInfo = function (aUserCallback, aErrCallback)
{
	// AnySignLite 지원
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	return AnySignForPC.GetVidInfo (aUserCallback, aErrCallback);
}

UnifiedPluginInterface.prototype.DeleteCertificate = function (aSubjectRDN,
															   aUserCallback,
															   aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	return AnySignForPC.DeleteCertificate (1,
										   aSubjectRDN,
										   aUserCallback,
										   aErrCallback);
}

UnifiedPluginInterface.prototype.DeleteCertificateFromRevoke = function (aSubjectRDN,
																		 aUserCallback,
																		 aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	return AnySignForPC.DeleteCertificateFromRevoke (1,
													 aSubjectRDN,
													 aUserCallback,
													 aErrCallback);
}

UnifiedPluginInterface.prototype.EnvelopData = function (aXgateAddress,
														 aCAList,
														 aPlainData,
														 aOption,
														 aEnvKeyword,
														 aEnvCertPEM,
														 aCertSerial,
														 aCertLocation,
														 aDescription,
														 aUserCallback,
														 aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aCertSerial		= this.IsNull (aCertSerial, "");
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");
	
	aCertLocation	= this.GetDefaultLocation (aCertLocation);

	AnySignForPC.EnvelopeData (aXgateAddress,
							   aCAList,
							   aPlainData,
							   aOption,
							   aEnvKeyword,
							   aEnvCertPEM,
							   aCertSerial,
							   aCertLocation,
							   aDescription,
							   aUserCallback,
							   aErrCallback);
}

UnifiedPluginInterface.prototype.EnvelopData_Location = function (aXgateAddress,
																  aCAList,
																  aPlainData,
																  aOption,
																  aEnvKeyword,
																  aEnvCertPEM,
																  aCertSerial,
																  aCertLocation,
																  aDescription,
																  aUserCallback,
																  aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aCertSerial		= this.IsNull (aCertSerial, "");
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");
	
	_CB_getLastLocation = function (aResult)
	{
		if (aResult) aCertLocation = aResult;
		
		aCertLocation = AnySign.GetDefaultLocation (aCertLocation);
		
		AnySign.mAnySignForPC.EnvelopeData (aXgateAddress,
											aCAList,
											aPlainData,
											aOption,
											aEnvKeyword,
											aEnvCertPEM,
											aCertSerial,
											aCertLocation,
											aDescription,
											aUserCallback,
											aErrCallback);
	}
	
	this.mAnySignForPC.GetLastLocation (_CB_getLastLocation);
}

UnifiedPluginInterface.prototype.DeEnvelopData = function (aXgateAddress,
														   aCAList,
														   aEnvelopedData,
														   aDeEnvOption,
														   aDeEnvKeyword,
														   aDescription,
														   aLimitedTrial, 
														   aUserCallback,
														   aErrCallback)
{
	// AnySignLite 지원
	if (aDeEnvOption == 1 && this.mXecureFreeSignData.signType != "client")
		this.setAnySignLite(true, false);
	else
		this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aDeEnvOption	= this.IsNull (aDeEnvOption, 0);
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial		= this.IsNull (aLimitedTrial, this.mLimitedTrial);

	AnySignForPC.DeEnvelopeData (aXgateAddress,
								 aCAList,
								 aEnvelopedData,
								 aDeEnvOption,
								 aDeEnvKeyword,
								 aDescription,
								 aLimitedTrial, 
								 aUserCallback,
								 aErrCallback);
}

UnifiedPluginInterface.prototype.DeEnvelopDataWithCacheCert = function (aXgateAddress,
																		aEnvelopedData,
																		aUserCallback,
																		aErrCallback,
																		aAnySignType)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);

	AnySignForPC.DeEnvelopeDataWithCacheCert (aXgateAddress,
											  aEnvelopedData,
											  aUserCallback,
											  aErrCallback);
}

UnifiedPluginInterface.prototype.GetCAInfo = function (aType)
{
	var aIter = 0;
	var aCAInfo = null;
	var fCAHTTPAddressEnable = false;
	var fCAHTTPPortEnable = false;

	for (aIter = 0; aIter < this.mCAInfoList.length; ++aIter)
	{
		if (this.mCAInfoList [aIter].aType != aType)
		{
			continue;
		}

		aCAInfo = this.mCAInfoList [aIter];
		break;
	}

	if (aCAInfo == null)
	{
		return null;
	}

	if (aCAInfo.aCAName == undefined)
	{
		aCAInfo.aCAName = "";
	}

	if (aCAInfo.aRAName == undefined)
	{
		aCAInfo.aRAName = "";
	}

	fCAHTTPAddressEnable = 'aCAHTTPAddress' in aCAInfo;
	fCAHTTPPortEnable = 'aCAHTTPPort' in aCAInfo;

	if (fCAHTTPAddressEnable == false)
	{
		if (typeof this.mWebCMPRelayServerInfo.aAddress != "undefined" && this.mWebCMPRelayServerInfo.aAddress != "")
			aCAInfo.aCAHTTPAddress = this.mWebCMPRelayServerInfo.aAddress;
	}

	if (fCAHTTPPortEnable == false)
	{
		if (fCAHTTPAddressEnable == false)
		{
			if (typeof this.mWebCMPRelayServerInfo.aPort != "undefined")
			{
				if (this.mWebCMPRelayServerInfo.aPort != "80" && this.mWebCMPRelayServerInfo.aPort != 80)
				{
					aCAInfo.aCAHTTPPort = typeof this.mWebCMPRelayServerInfo.aPort == "string" ? this.mWebCMPRelayServerInfo.aPort : this.mWebCMPRelayServerInfo.aPort.toString();
				}
			}
			
		}
		
	}

	return aCAInfo;
}

UnifiedPluginInterface.prototype.RequestCertificate = function (aType,
																aReferenceNumber,
																aAuthenticationCode,
																aOption,
																aUserCallback,
																aErrCallback,
																aUbiKeyUserCallback)
{
	// AnySignLite 지원
	this.setAnySignLite(true, false);
	
	var aCAInfo = null;

	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	aCAInfo = this.GetCAInfo (aType);
	if (aCAInfo == null)
	{
		alert ("cainfo error");
		return null;
	}

	AnySign.mDivInsertOption = 0;
	this.mAnySignForPC.RequestCertificateEx2WithWebCMP (aCAInfo.aCAPort,
														aCAInfo.aCAHTTPPort,
											 			aCAInfo.aCAIPAddress,
											 			aCAInfo.aCAHTTPAddress,
											 			aCAInfo.aCAHTTPService,
											 			aReferenceNumber,
											 			aAuthenticationCode,
											 			aCAInfo.aCAType,
											 			aOption,
											 			aCAInfo.aCAName,
											 			aCAInfo.aRAName,
											 			0,
											 			aUserCallback,
											 			aErrCallback,
											 			aUbiKeyUserCallback);
}

UnifiedPluginInterface.prototype.RenewCertificate = function (aType,
															  aCertLocation,
															  aOption,
															  aLimitedTrial,
															  aUserCallback,
															  aErrCallback)
{
	// AnySignLite 지원
	var aAnySignLite = this.setAnySignLite(true, false);
	
	var aCAInfo = null;

	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	aCAInfo = this.GetCAInfo (aType);
	if (aCAInfo == null)
	{
		alert ("cainfo error");
		return null;
	}

	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	
	aCertLocation	= this.GetDefaultLocation (aCertLocation);

	this.mAnySignForPC.RenewCertificateWithSerialWithWebCMP (aCAInfo.aCAPort,
															 aCAInfo.aCAHTTPPort,
															 aCAInfo.aCAIPAddress,
															 aCAInfo.aCAHTTPAddress,
															 aCAInfo.aCAHTTPService,
															 "",
															 aCertLocation,
															 aCAInfo.aCAType,
															 aLimitedTrial,
															 aUserCallback,
															 aErrCallback);
}

UnifiedPluginInterface.prototype.RenewCertificate_Location = function (aType,
																	   aCertLocation,
																	   aOption,
																	   aLimitedTrial,
																	   aUserCallback,
																	   aErrCallback)
{
	// AnySignLite 지원
	var aAnySignLite = this.setAnySignLite(true, false);
	
	var aCAInfo = null;
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	
	aCAInfo = this.GetCAInfo (aType);
	if (aCAInfo == null)
	{
		alert ("cainfo error");
		return null;
	}
	
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	
	_CB_getLastLocation = function (aResult)
	{
		if (aResult) aCertLocation = aResult;
		
		aCertLocation = AnySign.GetDefaultLocation (aCertLocation);
		
		AnySign.mAnySignForPC.RenewCertificateWithSerialWithWebCMP (aCAInfo.aCAPort,
																	aCAInfo.aCAHTTPPort,
																	aCAInfo.aCAIPAddress,
																	aCAInfo.aCAHTTPAddress,
																	aCAInfo.aCAHTTPService,
															 		"",
																	aCertLocation,
																	aCAInfo.aCAType,
																	aLimitedTrial,
																	aUserCallback,
																	aErrCallback);
	}
	
	this.mAnySignForPC.GetLastLocation (_CB_getLastLocation);
}

UnifiedPluginInterface.prototype.RenewCertificateWithSerial = function (aType,
																	    aCertSerial,
																		aCertLocation,
																	    aOption,
																	    aLimitedTrial,
																	    aUserCallback,
																	    aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite(true, false);
	
	var aCAInfo = null;

	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	aCAInfo = this.GetCAInfo (aType);
	if (aCAInfo == null)
	{
		alert ("cainfo error");
		return null;
	}

	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);

	this.mAnySignForPC.RenewCertificateWithSerialWithWebCMP (aCAInfo.aCAPort,
															 aCAInfo.aCAHTTPPort,
														     aCAInfo.aCAIPAddress,
														     aCAInfo.aCAHTTPAddress,
														     aCAInfo.aCAHTTPService,
															 aCertSerial,
															 aCertLocation,
														     aCAInfo.aCAType,
														     aLimitedTrial,
														     aUserCallback,
														     aErrCallback);
}

UnifiedPluginInterface.prototype.RenewCertificateWithSerial_Location = function (aType,
																				 aCertSerial,
																				 aCertLocation,
																				 aOption,
																				 aLimitedTrial,
																				 aUserCallback,
																				 aErrCallback)
{
	// AnySignLite 지원
	var aAnySignLite = this.setAnySignLite(true, false);
	
	var aCAInfo = null;
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	aCAInfo = this.GetCAInfo (aType);
	if (aCAInfo == null)
	{
		alert ("cainfo error");
		return null;
	}
	
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	
	_CB_getLastLocation = function (aResult)
	{
		if (aResult) aCertLocation = aResult;
		
		aCertLocation = AnySign.GetDefaultLocation (aCertLocation);
		
		AnySign.mAnySignForPC.RenewCertificateWithSerialWithWebCMP (aCAInfo.aCAPort,
																	aCAInfo.aCAHTTPPort,
																    aCAInfo.aCAIPAddress,
																    aCAInfo.aCAHTTPAddress,
																    aCAInfo.aCAHTTPService,
																    aCertSerial,
																    aCertLocation,
																    aCAInfo.aCAType,
																    aLimitedTrial,
																    aUserCallback,
																    aErrCallback);
	}
	
	this.mAnySignForPC.GetLastLocation (_CB_getLastLocation);
}

UnifiedPluginInterface.prototype.RevokeCertificate = function (aType,
															   aJobCode,
															   aReason,
															   aLimitedTrial,
															   aUserCallback,
															   aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	var aCAInfo = null;

	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	aCAInfo = this.GetCAInfo (aType);
	if (aCAInfo == null)
	{
		alert ("cainfo error");
		return null;
	}

	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);

	this.mAnySignForPC.RevokeCertificate (aCAInfo.aCAPort,
										  aCAInfo.aCAIPAddress,
										  aJobCode,
										  aReason,
										  aCAInfo.aCAType,
										  aLimitedTrial,
										  aUserCallback,
										  aErrCallback);
}

UnifiedPluginInterface.prototype.ShowCertManager = function (aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	AnySign.mDivInsertOption = 0;

	this.mAnySignForPC.ShowCertManager (aErrCallback);
}

UnifiedPluginInterface.prototype.MultiSignInit = function ()
{
	return this.mAnySignForPC.MultiSignInit();
}

UnifiedPluginInterface.prototype.SetMultiSignData = function (aMultiSignID, aPlain, aPlain2)
{
	this.mAnySignForPC.SetMultiSignData (aMultiSignID, aPlain, aPlain2);
}

UnifiedPluginInterface.prototype.MultiSignEx = function (aMultiSignID,
														 aXgateAddress,
														 aCAList,
														 aOption,
														 aDescription,
														 aLimitedTrial,
														 aUserCallback,
														 aErrCallback) 
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);

	this.mAnySignForPC.MultiSignEx (aMultiSignID,
								    aXgateAddress,
									aCAList,
									aOption,
									aDescription,
									aLimitedTrial,
									aUserCallback,
									aErrCallback);
}

UnifiedPluginInterface.prototype.MultiSignExWithSerial = function (aMultiSignID,
																   aXgateAddress,
																   aCAList,
																   aCertSerial,
																   aCertLocation,
																   aOption,
																   aDescription,
																   aLimitedTrial,
																   aUserCallback,
																   aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aCertSerial		= this.IsNull (aCertSerial, "");
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	
	aCertLocation	= this.GetDefaultLocation (aCertLocation);

	this.mAnySignForPC.MultiSignExWithSerial (aMultiSignID,
											  aXgateAddress,
											  aCAList,
											  aCertSerial,
											  aCertLocation,
											  aOption,
											  aDescription,
											  aLimitedTrial,
											  aUserCallback,
											  aErrCallback);
}

UnifiedPluginInterface.prototype.MultiSignExWithVID_Serial = function (aMultiSignID,
																   aXgateAddress,
																   aCAList,
																   aCertSerial,
																   aCertLocation,
																   aOption,
																   aDescription,
																   aSvrCert,
																   aLimitedTrial,
																   aUserCallback,
																   aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aCertSerial		= this.IsNull (aCertSerial, "");
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	
	aCertLocation	= this.GetDefaultLocation (aCertLocation);

	this.mAnySignForPC.MultiSignExWithVID_Serial (aMultiSignID,
											  aXgateAddress,
											  aCAList,
											  aCertSerial,
											  aCertLocation,
											  aOption,
											  aDescription,
											  aSvrCert,
											  aLimitedTrial,
											  aUserCallback,
											  aErrCallback);
}

UnifiedPluginInterface.prototype.MultiSignExWithSerial_Location = function (aMultiSignID,
																		    aXgateAddress,
																			aCAList,
																			aCertSerial,
																			aCertLocation,
																			aOption,
																			aDescription,
																			aLimitedTrial,
																			aUserCallback,
																			aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aCertSerial		= this.IsNull (aCertSerial, "");
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	
	_CB_getLastLocation = function (aResult)
	{
		if (aResult) aCertLocation = aResult;
		
		aCertLocation = AnySign.GetDefaultLocation (aCertLocation);
		
		AnySign.mAnySignForPC.MultiSignExWithSerial (aMultiSignID,
													 aXgateAddress,
													 aCAList,
													 aCertSerial,
													 aCertLocation,
													 aOption,
													 aDescription,
													 aLimitedTrial,
													 aUserCallback,
													 aErrCallback);
	}
	
	this.mAnySignForPC.GetLastLocation (_CB_getLastLocation);
}

UnifiedPluginInterface.prototype.MultiSignExWithVID_Serial_Location = function (aMultiSignID,
																		    aXgateAddress,
																			aCAList,
																			aCertSerial,
																			aCertLocation,
																			aOption,
																			aDescription,
																			aSvrCert,
																			aLimitedTrial,
																			aUserCallback,
																			aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aCertSerial		= this.IsNull (aCertSerial, "");
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	
	_CB_getLastLocation = function (aResult)
	{
		if (aResult) aCertLocation = aResult;
		
		aCertLocation = AnySign.GetDefaultLocation (aCertLocation);
		
		AnySign.mAnySignForPC.MultiSignExWithVID_Serial (aMultiSignID,
													 aXgateAddress,
													 aCAList,
													 aCertSerial,
													 aCertLocation,
													 aOption,
													 aDescription,
													 aSvrCert,
													 aLimitedTrial,
													 aUserCallback,
													 aErrCallback);
	}
	
	this.mAnySignForPC.GetLastLocation (_CB_getLastLocation);
}

UnifiedPluginInterface.prototype.MultiFileSign = function (aMultiSignID,
														   aXgateAddress,
														   aCAList,
														   aOption,
														   aDescription,
														   aLimitedTrial,
														   aUserCallback,
														   aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aDescription	= this.IsNull (aDescription, "");
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);

	this.mAnySignForPC.MultiFileSign (aMultiSignID,
									  aXgateAddress,
									  aCAList,
									  aOption,
									  aDescription,
									  aLimitedTrial,
									  aUserCallback,
									  aErrCallback);
}

UnifiedPluginInterface.prototype.GetMultiSignedData = function (aMultiSignID, aIndex)
{
	return this.mAnySignForPC.GetMultiSignedData (aMultiSignID, aIndex);
}

UnifiedPluginInterface.prototype.MultiSignFinal = function (aMultiSignID)
{
	this.mAnySignForPC.MultiSignFinal (aMultiSignID);
}

UnifiedPluginInterface.prototype.InstallCertificate = function (aCertType, aCertificate, aUserCallback)
 
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	this.mAnySignForPC.InstallCertificate (1, /* aMediaID */
										   aCertType,
										   aCertificate,
										   "", /* aPassword */
										   aUserCallback);
}

UnifiedPluginInterface.prototype.SetIssuerConvertTableFirst = function (aIssuer, aConvertedPool, aComment, aUserCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aIssuer == undefined) return;
	if (aConvertedPool == undefined) return;
	
	aComment = this.IsNull (aComment, "");
	
	this.mAnySignForPC.SetIssuerConvertTable (aIssuer, aConvertedPool, aComment, 0, aUserCallback);
}

UnifiedPluginInterface.prototype.SetIssuerConvertTableNext = function (aIssuer, aConvertedPool, aComment, aLanguage, aUserCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();

	if (aIssuer == undefined) return;
	if (aConvertedPool == undefined) return;
	
	aComment = this.IsNull (aComment, "");
	
	this.mAnySignForPC.SetIssuerConvertTable (aIssuer, aConvertedPool, aComment, 0, aUserCallback);
}

UnifiedPluginInterface.prototype.SetIssuerConvertTableFinal = function ()
{
	return 0;
}

UnifiedPluginInterface.prototype.SetPolicyConvertTableFirst = function (aPolicy, aConvertedPool, aComment)
{
	// AnySignLite 지원
	this.setAnySignLite();

	if (aPolicy == undefined) return;
	if (aConvertedPool == undefined) return;
	
	aComment = this.IsNull (aComment, "");
	
	this.mAnySignForPC.SetPolicyConvertTable (aPolicy, aConvertedPool, aComment, 0);
}

UnifiedPluginInterface.prototype.SetPolicyConvertTableNext = function (aPolicy, aConvertedPool, aComment, aLanguage)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aPolicy == undefined) return;
	if (aConvertedPool == undefined) return;
	
	aComment = this.IsNull (aComment, "");
	
	this.mAnySignForPC.SetPolicyConvertTable (aPolicy, aConvertedPool, aComment, 0);
}

UnifiedPluginInterface.prototype.SetPolicyConvertTableFinal = function ()
{
	return 0;
}

UnifiedPluginInterface.prototype.GetLastLocation = function (aUserCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();

	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	this.mAnySignForPC.GetLastLocation(aUserCallback);
}

UnifiedPluginInterface.prototype.GetCacheCertLocation = function (aXgateAddress, aUserCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();

	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	this.mAnySignForPC.GetCacheCertLocation(aXgateAddress, aUserCallback);
}

UnifiedPluginInterface.prototype.GetCacheCertLocationEx = function (aXgateAddress, aOption, aUserCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	this.mAnySignForPC.GetCacheCertLocationEx (aXgateAddress, aOption, aUserCallback);
}

UnifiedPluginInterface.prototype.ClearCachedData = function (aXgateAddress, aOption, aUserCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	this.mAnySignForPC.ClearCachedData (aXgateAddress, aOption, aUserCallback);
}

UnifiedPluginInterface.prototype.GetCertInfo = function (aSignedData, aOpOption, aInfoOption, aUserCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);

	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	this.mAnySignForPC.GetCertInfoEx (aSignedData, "", aOpOption, aInfoOption, 0, aUserCallback);
}

UnifiedPluginInterface.prototype.VerifyData = function (aSignedData, aOriginalData, aOption, aUserCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();

	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	this.mAnySignForPC.VerifyData (aSignedData, aOriginalData, aOption, aUserCallback);
}

UnifiedPluginInterface.prototype.Wif = function (aOption, aPEM, aUserCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);

	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	this.mAnySignForPC.Wif(aOption, aPEM, aUserCallback);
}

UnifiedPluginInterface.prototype.SetCharset = function (aCharset, aUserCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	this.mAnySignForPC.SetCharset(aCharset, aUserCallback);
}

UnifiedPluginInterface.prototype.XecureLink = function (link)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);

	var aXgateAddress	= this.mXgateAddress;

	return this.mAnySignForPC.XecureLink (aXgateAddress, link);
}

UnifiedPluginInterface.prototype.XecureSubmit = function (form, aSessionKey)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);

	var aXgateAddress	= this.mXgateAddress;

	return this.mAnySignForPC.XecureSubmit (aXgateAddress, form, aSessionKey);
}

UnifiedPluginInterface.prototype.XecureNavigate = function (url, aTarget, aFeature)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);

	var aXgateAddress   = this.mXgateAddress;

	return this.mAnySignForPC.XecureNavigate (aXgateAddress, url, aTarget, aFeature);
}

UnifiedPluginInterface.prototype.BlockEnc = function (aPath, aPlain, aMethod, aUserCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);

	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	var aXgateAddress = this.mXgateAddress;

	this.mAnySignForPC.BlockEnc (aXgateAddress, aPath, aPlain, aMethod, aUserCallback);
}

UnifiedPluginInterface.prototype.BlockEnc2 = function (aPath, aPlain, aMethod, aCharset, aUserCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);

	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	var aXgateAddress = this.mXgateAddress;

	this.mAnySignForPC.BlockEnc2 (aXgateAddress, aPath, aPlain, aMethod, aCharset, aUserCallback);
}

UnifiedPluginInterface.prototype.BlockEncEx = function (aPath, aPlain, aMethod, aCharset, aUserCallback, aParam)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);

	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	var aXgateAddress = this.mXgateAddress;

	this.mAnySignForPC.BlockEncEx (aXgateAddress, aPath, aPlain, aMethod, aCharset, aUserCallback, aParam);
}

UnifiedPluginInterface.prototype.BlockDec = function (aCipher, aElement, aUserCallback, aParam)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);

	var aXgateAddress = this.mXgateAddress;

	if (this.mEncCharset)
		return this.mAnySignForPC.BlockDecEx(aXgateAddress, aCipher, this.mEncCharset, aElement, aUserCallback, aParam);
	else
		return this.mAnySignForPC.BlockDecEx(aXgateAddress, aCipher, "utf-8", aElement, aUserCallback, aParam);
}

UnifiedPluginInterface.prototype.FileHash = function (aPath, aAlg, aUserCallback, aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);

	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	this.mAnySignForPC.FileHash (aPath, aAlg, aUserCallback, aErrCallback);
}

UnifiedPluginInterface.prototype.getKTBScanInfo = function (aServerIP, aServerPort, aUserCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);

	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	this.mAnySignForPC.getKTBScanInfo(aServerIP, aServerPort, aUserCallback);
}

UnifiedPluginInterface.prototype.GenerateRandom = function (aLength, aOption, aUserCallback)
{	
	// AnySignLite 미지원
	this.setAnySignLite(false, false);

	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	this.mAnySignForPC.generateRandom(aLength, aOption, aUserCallback);
}

UnifiedPluginInterface.prototype.GetCertPEM = function (aMediaID,
														aIssuerRDN,
														aCertSerial,
														aOption,
														aUserCallback,
														aErrCallback)
{
	// AnySignLite 지원
	this.setAnySignLite();

	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aMediaID == null ||
		aIssuerRDN == null || aIssuerRDN.length == 0 ||
		aCertSerial == null || aCertSerial.length == 0)
	{
		alert("[GetCertPEM] invalid parameters.");
		return;
	}

	aOption = this.IsNull (aOption, 0);

	this.mAnySignForPC.GetCertPEM (aMediaID,
								   aIssuerRDN,
								   aCertSerial,
								   aOption,
								   aUserCallback,
								   aErrCallback);
}

UnifiedPluginInterface.prototype.AnySign4PC_installCheck = function (aUserCallback)
{
	this.mAnySignForPC.AnySign4PC_installCheck (aUserCallback);
}

UnifiedPluginInterface.prototype.AnySign4PC_installCallback = function (aUserCallback)
{
	this.mAnySignForPC.AnySign4PC_installCallback (aUserCallback);
}

UnifiedPluginInterface.prototype.AnySign4PC_LoadCallback = function (aUserCallback)
{
	this.mAnySignForPC.AnySign4PC_LoadCallback (aUserCallback);
}

UnifiedPluginInterface.prototype.setBlockDec_callback = function  (aUserCallback, aParam)
{
	this.mAnySignForPC.setBlockDec_callback  (aUserCallback, aParam);
}

// FCMS
UnifiedPluginInterface.prototype.SelectFile = function (aInitPath,
														aFilterString,
														aOption,
														aUserCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	aInitPath		= this.IsNull (aInitPath, "");
	aFilterString	= this.IsNull (aFilterString, "");

	this.mAnySignForPC.SelectFile (aInitPath,
								   aFilterString,
								   aOption,
								   aUserCallback);
}

UnifiedPluginInterface.prototype.SignFileEx = function (aXgateAddress,
														aCAList,
														aLimitedTrial,
														aInFilePath,
														aOutFilePath,
														aOption,
														aDescription,
														aUserCallback,
														aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aInFilePath == null || aInFilePath.length == 0)
	{
		alert ("invalid parameters");
		return;
	}

	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	aOutFilePath	= this.IsNull (aOutFilePath, "");
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");

	this.mAnySignForPC.SignFileEx (aXgateAddress,
								   aCAList,
								   "",
								   "",
								   aLimitedTrial,
								   aInFilePath,
								   aOutFilePath,
								   aOption,
								   aDescription,
								   aUserCallback,
								   aErrCallback);
}

UnifiedPluginInterface.prototype.SignFileExWithSerial = function (aXgateAddress,
																  aCAList,
																  aCertSerial,
																  aCertLocation,
																  aLimitedTrial,
																  aInFilePath,
																  aOutFilePath,
																  aOption,
																  aDescription,
																  aUserCallback,
																  aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aInFilePath == null || aInFilePath.length == 0)
	{
		alert ("invalid parameters");
		return;
	}

	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aCertSerial		= this.IsNull (aCertSerial, "");
	aCertLocation	= this.IsNull (aCertLocation, 1);	 // 1 hdd
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	aOutFilePath	= this.IsNull (aOutFilePath, "");
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");

	this.mAnySignForPC.SignFileEx (aXgateAddress,
								   aCAList,
								   aCertSerial,
								   aCertLocation,
								   aLimitedTrial,
								   aInFilePath,
								   aOutFilePath,
								   aOption,
								   aDescription,
								   aUserCallback,
								   aErrCallback);
}

UnifiedPluginInterface.prototype.SignFileExWithCacheCert = function (aXgateAddress,
																	 aInFilePath,
																	 aOutFilePath,
																	 aOption,
																	 aDescription,
																	 aUserCallback,
																	 aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aInFilePath == null || aInFilePath.length == 0)
	{
		alert ("invalid parameters");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aOutFilePath	= this.IsNull (aOutFilePath, "");
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");
	
	this.mAnySignForPC.SignFileExWithCacheCert (aXgateAddress,
												aInFilePath,
												aOutFilePath,
												aOption,
												aDescription,
												aUserCallback,
												aErrCallback);
}

UnifiedPluginInterface.prototype.SignFileExWithCacheCert2 = function (aXgateAddress,
																	  aInFilePath,
																	  aOutFilePath,
																	  aOption,
																	  aDescription,
																	  aUserCallback,
																	  aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aInFilePath == null || aInFilePath.length == 0)
	{
		alert ("invalid parameters");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aOutFilePath	= this.IsNull (aOutFilePath, "");
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");

	this.mAnySignForPC.SignFileExWithCacheCert2 (aXgateAddress,
												 aInFilePath,
												 aOutFilePath,
												 aOption,
												 aDescription,
												 aUserCallback,
												 aErrCallback);
}

UnifiedPluginInterface.prototype.ClearCacheCert2 = function (aUserCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);

	this.mAnySignForPC.ClearCacheCert2 (aUserCallback);
}

UnifiedPluginInterface.prototype.SignFileExWithVID = function (aXgateAddress,
															   aCAList,
															   aLimitedTrial,
															   aInFilePath,
															   aOutFilePath,
															   aIdn,
															   aSvrCert,
															   aOption,
															   aDescription,
															   aUserCallback,
															   aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aInFilePath == null || aInFilePath.length == 0)
	{
		alert ("invalid parameters");
		return;
	}
	
	if (aSvrCert == null || aSvrCert.length == 0)
	{
		alert ("invalid parameters");
		return;
	}

	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	aOutFilePath	= this.IsNull (aOutFilePath, "");
	aIdn			= this.IsNull (aIdn, "");
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");

	this.mAnySignForPC.SignFileExWithVID (aXgateAddress,
										  aCAList,
										  "",
										  "",
										  aLimitedTrial,
										  aInFilePath,
										  aOutFilePath,
										  aIdn,
										  aSvrCert,
										  aOption,
										  aDescription,
										  aUserCallback,
										  aErrCallback);
}

UnifiedPluginInterface.prototype.SignFileExWithVID_Serial = function (aXgateAddress,
																	  aCAList,
																	  aCertSerial,
																	  aCertLocation,
																	  aLimitedTrial,
																	  aInFilePath,
																	  aOutFilePath,
																	  aIdn,
																	  aSvrCert,
																	  aOption,
																	  aDescription,
																	  aUserCallback,
																	  aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aInFilePath == null || aInFilePath.length == 0)
	{
		alert ("invalid parameters");
		return;
	}
	
	if (aSvrCert == null || aSvrCert.length == 0)
	{
		alert ("invalid parameters");
		return;
	}

	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aCertSerial		= this.IsNull (aCertSerial, "");
	aCertLocation	= this.IsNull (aCertLocation, 1);	 // 1 hdd
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	aOutFilePath	= this.IsNull (aOutFilePath, "");
	aIdn			= this.IsNull (aIdn, "");
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");

	this.mAnySignForPC.SignFileExWithVID (aXgateAddress,
										  aCAList,
										  aCertSerial,
										  aCertLocation,
										  aLimitedTrial,
										  aInFilePath,
										  aOutFilePath,
										  aIdn,
										  aSvrCert,
										  aOption,
										  aDescription,
										  aUserCallback,
										  aErrCallback);
}

UnifiedPluginInterface.prototype.SignFileExWithVID_CacheCert = function (aXgateAddress,
																		 aInFilePath,
																		 aOutFilePath,
																		 aIdn,
																		 aSvrCert,
																		 aOption,
																		 aDescription,
																		 aUserCallback,
																		 aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aInFilePath == null || aInFilePath.length == 0)
	{
		alert ("[SignFileExWithVID_CacheCert] invalid parameters");
		return;
	}
	
	if (aSvrCert == null || aSvrCert.length == 0)
	{
		alert ("[SignFileExWithVID_CacheCert] invalid parameters");
		return;
	}
	/*
	if (!((aOption & 0x08) || (aOption & 0x10)))
	{
		alert("[SignFileExWithVID_CacheCert] invalid option.");
		return;
	}
	*/
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aOutFilePath	= this.IsNull (aOutFilePath, "");
	aIdn			= this.IsNull (aIdn, "");
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");
	
	AnySignForPC.SignFileExWithVID_CacheCert (aXgateAddress,
											  aInFilePath,
											  aOutFilePath,
											  aIdn,
											  aSvrCert,
											  aOption,
											  aDescription,
											  aUserCallback,
											  aErrCallback);
}

UnifiedPluginInterface.prototype.VerifyFile = function (aInFilePath,
														aSignedData,
														aOption,
														aDescription,
														aUserCallback,
														aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aInFilePath == null || aInFilePath.length == 0)
	{
		alert ("invalid parameters");
		return;
	}
	
	aSignedData		= this.IsNull (aSignedData, "");
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");
	
	this.mAnySignForPC.VerifyFile (aInFilePath,
								   aSignedData,
								   aOption,
								   aDescription,
								   aUserCallback,
								   aErrCallback);
}

UnifiedPluginInterface.prototype.VerifyAndSignFile = function (aXgateAddress,
															   aCAList,
															   aCertSerial,
															   aCertLocation,
															   aLimitedTrial,
															   aInFilePath,
															   aOutFilePath,
															   aSignedData,
															   aVerifyOption,
															   aSignOption,
															   aVerifyDescription,
															   aSignDescription,
															   aUserCallback,
															   aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aInFilePath == null || aInFilePath.length == 0)
	{
		alert ("invalid parameters");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aCertSerial		= this.IsNull (aCertSerial, "");
	aCertLocation	= this.IsNull (aCertLocation, 1);
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	aOutFilePath	= this.IsNull (aOutFilePath, "");
	aSignedData		= this.IsNull (aSignedData, "");
	aVerifyOption	= this.IsNull (aVerifyOption, 0);
	aSignOption		= this.IsNull (aSignOption, 0);
	aDescription	= this.IsNull (aVerifyDescription, "");
	aDescription	= this.IsNull (aSignDescription, "");
	
	this.mAnySignForPC.VerifyAndSignFile (aXgateAddress,
										  aCAList,
										  aCertSerial,
										  aCertLocation,
										  aLimitedTrial,
										  aInFilePath,
										  aOutFilePath,
										  aSignedData,
										  aVerifyOption,
										  aSignOption,
										  aVerifyDescription,
										  aSignDescription,
										  aUserCallback,
										  aErrCallback);
}

UnifiedPluginInterface.prototype.GetVerifiedFileCertInfo = function (aOption,
																 	 aIndex,
																 	 aUserCallback,
																 	 aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aIndex < 0)
	{
		alert ("invalid parameters");
		return;
	}
	
	aOption			= this.IsNull (aOption, 0);
	
	this.mAnySignForPC.GetVerifiedFileCertInfo (aOption,
												aIndex,
												aUserCallback,
												aErrCallback);
}

UnifiedPluginInterface.prototype.ExtractFile = function (aInFilePath,
														 aOutFilePath,
														 aOption,
														 aDescription,
														 aUserCallback,
														 aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aInFilePath == null || aInFilePath.length == 0)
	{
		alert ("invalid parameters");
		return;
	}
	
	aOutFilePath	= this.IsNull (aOutFilePath, "");
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");
	
	this.mAnySignForPC.ExtractFile (aInFilePath,
									aOutFilePath,
									aOption,
									aDescription,
									aUserCallback,
									aErrCallback);
}

UnifiedPluginInterface.prototype.EnvelopeFileWithPEM = function (aInFilePath,
																 aOutFilePath,
																 aCertPEM,
																 aOption,
																 aDescription,
																 aUserCallback,
																 aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}

	if (aInFilePath == null || aInFilePath.length == 0)
	{
		alert ("invalid parameters");
		return;
	}

	aOutFilePath	= this.IsNull (aOutFilePath, "");
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");

	this.mAnySignForPC.EnvelopeFileWithPEM (aInFilePath,
											aOutFilePath,
											aCertPEM,
											aOption,
											aDescription,
											aUserCallback,
											aErrCallback);
}

UnifiedPluginInterface.prototype.EnvelopeFileWithCert = function  (aXgateAddress,
																   aCAList,
																   aInFilePath,
																   aOutFilePath,
																   aOption,
																   aDescription,
																   aUserCallback,
																   aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aInFilePath == null || aInFilePath.length == 0)
	{
		alert ("invalid parameters");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aOutFilePath	= this.IsNull (aOutFilePath, "");
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");
	
	this.mAnySignForPC.EnvelopeFileWithCert (aXgateAddress,
											 aCAList,
											 null,
											 null,
											 aInFilePath,
											 aOutFilePath,
											 aOption,
											 aDescription,
											 aUserCallback,
											 aErrCallback);
}

UnifiedPluginInterface.prototype.EnvelopeFileWithCert_Serial = function  (aXgateAddress,
																		  aCAList,
																		  aCertSerial,
																		  aCertLocation,
																		  aInFilePath,
																		  aOutFilePath,
																		  aOption,
																		  aDescription,
																		  aUserCallback,
																		  aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aInFilePath == null || aInFilePath.length == 0)
	{
		alert ("invalid parameters");
		return;
	}

	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aCertSerial		= this.IsNull (aCertSerial, "");
	aCertLocation	= this.IsNull (aCertLocation, 1);
	aOutFilePath	= this.IsNull (aOutFilePath, "");
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");
	
	this.mAnySignForPC.EnvelopeFileWithCert (aXgateAddress,
											 aCAList,
											 aCertSerial,
											 aCertLocation,
											 aInFilePath,
											 aOutFilePath,
											 aOption,
											 aDescription,
											 aUserCallback,
											 aErrCallback);
}

UnifiedPluginInterface.prototype.DeEnvelopeFileWithCert = function (aXgateAddress,
																	aCAList,
																	aLimitedTrial,
																	aInFilePath,
																	aOutFilePath,
																	aOption,
																	aDescription,
																	aUserCallback,
																	aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aInFilePath == null || aInFilePath.length == 0)
	{
		alert ("invalid parameters");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	aOutFilePath	= this.IsNull (aOutFilePath, "");
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");
	
	this.mAnySignForPC.DeEnvelopeFileWithCert (aXgateAddress,
											   aCAList,
											   null,
											   null,
											   aLimitedTrial,
											   aInFilePath,
											   aOutFilePath,
											   aOption,
											   aDescription,
											   aUserCallback,
											   aErrCallback);
}

UnifiedPluginInterface.prototype.DeEnvelopeFileWithCert_Serial = function (aXgateAddress,
																		   aCAList,
																		   aCertSerial,
																		   aCertLocation,
																		   aLimitedTrial,
																		   aInFilePath,
																		   aOutFilePath,
																		   aOption,
																		   aDescription,
																		   aUserCallback,
																		   aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aInFilePath == null || aInFilePath.length == 0)
	{
		alert ("invalid parameters");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aCAList			= this.IsNull (aCAList, this.mCAList);
	aCertSerial		= this.IsNull (aCertSerial, "");
	aCertLocation	= this.IsNull (aCertLocation, 1);
	aLimitedTrial	= this.IsNull (aLimitedTrial, this.mLimitedTrial);
	aOutFilePath	= this.IsNull (aOutFilePath, "");
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");
	
	this.mAnySignForPC.DeEnvelopeFileWithCert (aXgateAddress,
											   aCAList,
											   aCertSerial,
											   aCertLocation,
											   aLimitedTrial,
											   aInFilePath,
											   aOutFilePath,
											   aOption,
											   aDescription,
											   aUserCallback,
											   aErrCallback);
}

UnifiedPluginInterface.prototype.EnvelopeFileWithPasswd = function (aInFilePath,
																	aOutFilePath,
																	aSymKey,
																	aOption,
																	aDescription,
																	aUserCallback,
																	aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aInFilePath == null || aInFilePath.length == 0)
	{
		alert ("invalid parameters");
		return;
	}
	
	if (!(aOption & 1))
	{
		if (aSymKey == null || aSymKey.length == 0)
		{
			alert ("invalid parameters");
			return;
		}
	}
	else
	{
		aSymKey = "";
	}
	
	aOutFilePath 	= this.IsNull (aOutFilePath, "");
	aSymKey 		= this.IsNull (aSymKey, "");
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");
	
	this.mAnySignForPC.EnvelopeFileWithPasswd (aInFilePath,
											   aOutFilePath,
											   aSymKey,
											   aOption,
											   aDescription,
											   aUserCallback,
											   aErrCallback);
}

UnifiedPluginInterface.prototype.DeEnvelopeFileWithPasswd = function (aInFilePath,
																	  aOutFilePath,
																	  aSymKey,
																	  aOption,
																	  aDescription,
																	  aUserCallback,
																	  aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aInFilePath == null || aInFilePath.length == 0)
	{
		alert ("invalid parameters");
		return;
	}
	
	if (!(aOption & 1))
	{
		if (aSymKey == null || aSymKey.length == 0)
		{
			alert ("invalid parameters");
			return;
		}
	}
	else
	{
		aSymKey = "";
	}
	
	aOutFilePath 	= this.IsNull (aOutFilePath, "");
	aSymKey 		= this.IsNull (aSymKey, "");
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");
	
	this.mAnySignForPC.DeEnvelopeFileWithPasswd (aInFilePath,
												 aOutFilePath,
												 aSymKey,
												 aOption,
												 aDescription,
												 aUserCallback,
												 aErrCallback);
}

UnifiedPluginInterface.prototype.GetEnvelopedFileInfo = function (aEnvelopedFile,
		  														  aOption,
		  														  aUserCallback,
		  														  aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);

	this.mAnySignForPC.GetEnvelopedFileInfo (aEnvelopedFile,
											 aOption,
											 aUserCallback,
											 aErrCallback);
}

UnifiedPluginInterface.prototype.UploadFile = function (aXgateAddress,
		  												aPath,
		  												aQuery,
		  												aHostName,
		  												aPort,
		  												aInFilePath,
		  												aOption,
														aDescription,
														aUserCallback,
														aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aPath == null || aPath.length == 0)
	{
		alert ("invalid parameters");
		return;
	}
	
	if (aHostName == null || aHostName.length == 0)
	{
		alert ("invalid parameters");
		return;
	}
	
	if (aInFilePath == null || aInFilePath.length == 0)
	{
		alert ("invalid parameters");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aQuery			= this.IsNull (aQuery, "");
	aPort 			= this.IsNull (aPort, "80");
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");

	this.mAnySignForPC.UploadFile (aXgateAddress,
								   aPath,
								   aQuery,
								   aHostName,
								   aPort,
								   aInFilePath,
								   aOption,
								   aDescription,
								   aUserCallback,
								   aErrCallback);
}

UnifiedPluginInterface.prototype.DownloadFile = function (aXgateAddress,
														  aPath,
														  aQuery,
														  aHostName,
														  aPort,
														  aTargetFilePath,
														  aDownloadFilePath,
														  aOption,
														  aDescription,
														  aUserCallback,
														  aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aPath == null || aPath.length == 0)
	{
		alert ("invalid parameters");
		return;
	}
	
	if (aHostName == null || aHostName.length == 0)
	{
		alert ("invalid parameters");
		return;
	}
	
	if (aTargetFilePath == null || aTargetFilePath.length == 0)
	{
		alert ("invalid parameters");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aQuery 			= this.IsNull (aQuery, "");
	aPort 			= this.IsNull (aPort, "80");
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");

	this.mAnySignForPC.DownloadFile (aXgateAddress,
									 aPath,
									 aQuery,
									 aHostName,
									 aPort,
									 aTargetFilePath,
									 aDownloadFilePath,
									 aOption,
									 aDescription,
									 aUserCallback,
									 aErrCallback);
}

UnifiedPluginInterface.prototype.ZipFile = function (aXgateAddress,
													 aSourceFile,
													 aTargetFile,
													 aOption,
													 aDescription,
													 aUserCallback,
													 aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aSourceFile == null || aSourceFile.length == 0)
	{
		alert ("invalid parameters");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");
	
	this.mAnySignForPC.ZipFile (aXgateAddress,
								aSourceFile,
								aTargetFile,
								aOption,
								aDescription,
								aUserCallback,
								aErrCallback);
}

UnifiedPluginInterface.prototype.UnZipFile = function (aXgateAddress,
													   aSourceFile,
													   aDestDir,
													   aOption,
													   aDescription,
													   aUserCallback,
													   aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aSourceFile == null || aSourceFile.length == 0)
	{
		alert ("invalid parameters");
		return;
	}
	
	aXgateAddress	= this.IsNull (aXgateAddress, this.mXgateAddress);
	aOption			= this.IsNull (aOption, 0);
	aDescription	= this.IsNull (aDescription, "");
	
	this.mAnySignForPC.UnZipFile (aXgateAddress,
								  aSourceFile,
								  aDestDir,
								  aOption,
								  aDescription,
								  aUserCallback,
								  aErrCallback);
}

UnifiedPluginInterface.prototype.GetFileInfo = function (aFilePath,
														 aOption,
														 aUserCallback,
														 aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	if (aFilePath == null || aFilePath.length == 0)
	{
		alert ("invalid parameters");
		return;
	}
	
	aOption			= this.IsNull (aOption, 0);
	
	this.mAnySignForPC.GetFileInfo (aFilePath,
									aOption,
									aUserCallback,
									aErrCallback);
}

UnifiedPluginInterface.prototype.ClearTempFile = function (aXgateAddress,
														   aUserCallback,
														   aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	this.mAnySignForPC.ClearTempFile (aXgateAddress,
									  aUserCallback,
									  aErrCallback);
}

UnifiedPluginInterface.prototype.GetHomeDir = function (aUserCallback,
														aErrCallback)
{
	// AnySignLite 미지원
	this.setAnySignLite(false, false);
	
	if (aUserCallback == undefined)
	{
		alert ("callback error");
		return;
	}
	
	this.mAnySignForPC.GetHomeDir (aUserCallback,
									  aErrCallback);
}

UnifiedPluginInterface.prototype.XFSLogout = function (aUserCallback)
{
	if (aUserCallback == undefined)
	{
		aUserCallback = function (){};
	}
	
	return this.mAnySignForPC.XFSLogout (aUserCallback);
}

var AnySign = AnySignInitialize ();

PrintObjectTag = function (aIgnoreInstallpage, aTargetElement)
{
	AnySign.StartAnySign (aIgnoreInstallpage, aTargetElement);
}

/*
 * Error Callback
 */

function SignDataCMS_ErrCallback(aResult)
{
	alert("ErrCode [" + aResult.code + "] ErrMsg [" +aResult.msg+"]");
}

function SignDataCMSWithSerial_ErrCallback(aResult)
{
	alert("ErrCode [" + aResult.code + "] ErrMsg [" +aResult.msg+"]");
}

function SignDataCMSWithHTMLEx_ErrCallback(aResult)
{
	alert("ErrCode [" + aResult.code + "] ErrMsg [" +aResult.msg+"]");
}

function SignDataWithVID_ErrCallback(aResult)
{
	alert("ErrCode [" + aResult.code + "] ErrMsg [" +aResult.msg+"]");
}

function SignDataWithVID_Serial_ErrCallback(aResult)
{
	alert("ErrCode [" + aResult.code + "] ErrMsg [" +aResult.msg+"]");
}

function MultiSignEx_ErrCallback(aResult)
{
	alert("ErrCode [" + aResult.code + "] ErrMsg [" +aResult.msg+"]");
}

function MultiFileSign_ErrCallback(aResult)
{
	alert("ErrCode [" + aResult.code + "] ErrMsg [" +aResult.msg+"]");
}

function MultiSignExWithSerial_ErrCallback(aResult)
{
	alert("ErrCode [" + aResult.code + "] ErrMsg [" +aResult.msg+"]");
}

function MultiSignFileInfo_ErrCallback(aResult)
{
	alert("ErrCode [" + aResult.code + "] ErrMsg [" +aResult.msg+"]");
}

function MultiSignFileInfoWithSerial_ErrCallback(aResult)
{
	alert("ErrCode [" + aResult.code + "] ErrMsg [" +aResult.msg+"]");
}

function ShowCertManager_ErrCallback(aResult)
{
	alert("ErrCode [" + aResult.code + "] ErrMsg [" +aResult.msg+"]");
}

function RequestCertificate_ErrCallback(aResult)
{
	alert("ErrCode [" + aResult.code + "] ErrMsg [" +aResult.msg+"]");
}

function RenewCertificate_ErrCallback(aResult)
{
	alert("ErrCode [" + aResult.code + "] ErrMsg [" +aResult.msg+"]");
}

function RevokeCertificate_ErrCallback(aResult)
{
	alert("ErrCode [" + aResult.code + "] ErrMsg [" +aResult.msg+"]");
}

function GetVidInfo_ErrCallback(aResult)
{
	alert("ErrCode [" + aResult.code + "] ErrMsg [" +aResult.msg+"]");
}

function FileHash_ErrCallback(aResult)
{
	alert("ErrCode [" + aResult.code + "] ErrMsg [" +aResult.msg+"]");
}

function EnvelopData_ErrCallback(aResult)
{
	alert("ErrCode [" + aResult.code + "] ErrMsg [" +aResult.msg+"]");
}

function DeEnvelopData_ErrCallback(aResult)
{
	alert("ErrCode [" + aResult.code + "] ErrMsg [" +aResult.msg+"]");
}

/*
 * 인증서 관리자
 */
ShowCertManager = function ()
{
	AnySign.ShowCertManager (ShowCertManager_ErrCallback);
}

/* 
 * 서명 함수
 */
Sign_with_option = function (aOption,
	   						 aPlain,
							 aUserCallback)
{
	/*------------------------------------------------------------------------
	 * Don't return result.
	 *----------------------------------------------------------------------*/
	AnySign.SignDataCMS (null,
						 null,
						 aPlain,
						 aOption,
						 null,
						 null,
						 aUserCallback,
						 SignDataCMS_ErrCallback);
}

Sign_with_serial = function (aCertSerial,
							 aCertLocation,
							 aPlain,
							 aOption,
							 aUserCallback)
{
	/*------------------------------------------------------------------------
	 * Don't return result.
	 *----------------------------------------------------------------------*/
	AnySign.SignDataCMSWithSerial (null,
								   null,
								   aCertSerial,
								   aCertLocation,
								   aPlain,
								   aOption,
								   null,
								   null,
								   aUserCallback,
								   SignDataCMSWithSerial_ErrCallback);
}

Sign_with_vid_user= function (aOption,
	   						  aPlain,
							  aSvrCert,
							  aUserCallback)
{
	/*------------------------------------------------------------------------
	 * Don't return result.
	 *----------------------------------------------------------------------*/
	aOption = aOption +4;
	AnySign.SignDataWithVID_Serial (null,
									null,
									null,
									null,
									aPlain,
									aOption,
									null,
									null,
									null,
									aSvrCert,
									aUserCallback,
									SignDataWithVID_ErrCallback);
}

Sign_with_vid_web = function (aOption,
	   						  aPlain,
	   						  aIdn,
							  aSvrCert,
							  aUserCallback)
{
	/*------------------------------------------------------------------------
	 * Don't return result.
	 *----------------------------------------------------------------------*/
	aOption = aOption +12;
	AnySign.SignDataWithVID_Serial (null,
									null,
									null,
									null,
									aPlain,
									aOption,
									null,
									null,
									aIdn,
									aSvrCert,
									aUserCallback,
									SignDataWithVID_ErrCallback);
}

Sign_without_vid_web = function (aOption,
								 aPlain,
								 aSvrCert,
								 aIdn, 
								 aUserCallback,
								 aErrorCallback)
{
	/*------------------------------------------------------------------------
	 * Don't return result.
	 *----------------------------------------------------------------------*/
	aOption = aOption + 20;
	AnySign.SignDataWithVID_Serial (null,
									null,
									null,
									null,
									aPlain,
									aOption,
									null,
									null,
									aIdn,
									aSvrCert,
									aUserCallback,
									aErrorCallback,
									SignDataWithVID_ErrCallback);
}

Sign_with_vid_user_serial = function (aCertSerial,
									  aCertLocation,
									  aOption,
									  aPlain,
									  aSvrCert,
									  aUserCallback)
{
	/*------------------------------------------------------------------------
	 * Don't return result.
	 *----------------------------------------------------------------------*/
	aOption = aOption +4;
	AnySign.SignDataWithVID_Serial (null,
									null,
									aCertSerial,
									aCertLocation,
									aPlain,
									aOption,
									null,
									null,
									null,
									aSvrCert,
									aUserCallback,
									SignDataWithVID_Serial_ErrCallback);
}

Sign_with_vid_web_serial = function (aCertSerial,
									 aCertLocation,
									 aOption,
									 aPlain,
									 aSvrCert,
									 aIdn,
									 aUserCallback)
{
	/*------------------------------------------------------------------------
	 * Don't return result.
	 *----------------------------------------------------------------------*/
	aOption = aOption +12;
	AnySign.SignDataWithVID_Serial (null,
									null,
									aCertSerial,
									aCertLocation,
									aPlain,
									aOption,
									null,
									null,
									aIdn,
									aSvrCert,
									aUserCallback,
									SignDataWithVID_Serial_ErrCallback);
}

Sign_with_option_htmlex = function (aOption,
									aForm,
									aPlain,
									aCert,
									aUserCallback)
{
	/*------------------------------------------------------------------------
	 * Don't return result.
	 *----------------------------------------------------------------------*/
	AnySign.SignDataCMSWithHTMLEx (null,
								   null,
								   aForm,
								   aPlain,
								   aCert,
								   aOption,
								   null,
								   null,
								   aUserCallback,
								   SignDataCMSWithHTMLEx_ErrCallback);
}

Sign_with_option_htmlex_Serial = function (aOption,
										   aForm,
										   aPlain,
										   aCert,
										   aCertSerial,
										   aCertLocation,
										   aUserCallback)
{
	/*------------------------------------------------------------------------
	 * Don't return result.
	 *----------------------------------------------------------------------*/
	AnySign.SignDataCMSWithHTMLExAndSerial (null,
											null,
											aCertSerial,
											aCertLocation,
											aForm,
											aPlain,
											aCert,
											aOption,
											null,
											null,
											aUserCallback,
											SignDataCMSWithHTMLEx_ErrCallback);
}

/* 
 * CMP
 */
RequestCertificate = function (aType,
							   aReferenceNumber,
							   aAuthenticationCode,
							   aUserCallback,
							   aUbiKeyUserCallback)
{
	/*------------------------------------------------------------------------
	 * Don't return result.
	 *----------------------------------------------------------------------*/
	var aOption = 2;

	AnySign.RequestCertificate (aType,
								aReferenceNumber,
								aAuthenticationCode,
								aOption,
								aUserCallback,
								RequestCertificate_ErrCallback,
								aUbiKeyUserCallback);
}

RenewCertificate = function (aType,
							 aUserCallback)
{
	/*------------------------------------------------------------------------
	 * Don't return result.
	 *----------------------------------------------------------------------*/
	var aOption = 0;

	AnySign.RenewCertificate (aType,
							  null,
							  aOption,
							  null,
							  aUserCallback,
							  RenewCertificate_ErrCallback);
}

RenewCertificateWithSerial = function (aType,
									   aCertSerial,
									   aCertLocation,
							 		   aUserCallback)
{
	/*------------------------------------------------------------------------
	 * Don't return result.
	 *----------------------------------------------------------------------*/
	var aOption = 0;

	AnySign.RenewCertificateWithSerial (aType,
										aCertSerial,
										aCertLocation,
										aOption,
										null,
										aUserCallback,
										RenewCertificate_ErrCallback);
}

RevokeCertificate = function (aType,
							  aJobCode,
							  aReason,
							  aUserCallback)
{
	/*------------------------------------------------------------------------
	 * Don't return result.
	 *----------------------------------------------------------------------*/
	AnySign.RevokeCertificate (aType,
							   aJobCode,
							   aReason,
							   null,
							   aUserCallback,
							   RevokeCertificate_ErrCallback);
}

MultiSign = function (aTotal, 
					  aPlainMsg, 
					  aDelimeter, 
					  aUserCallback)
{
	var aSignedMsg = "";
	var aMultiSignID = "";
	var aPlainPointer = aPlainMsg;
	var aIndex= "";
	var aLength = "";
	var aSigned = "";

	if (aTotal <= 0 || aPlainMsg == undefined || aPlainMsg == "")
	{
		alert("input err");
		return "";
	}

	aMultiSignID = AnySign.MultiSignInit();

	for(i =0;i < aTotal ;i++)
	{
		aLength = aPlainPointer.length;
		aIndex = aPlainPointer.indexOf(aDelimeter);
		
		AnySign.SetMultiSignData (aMultiSignID,aPlainPointer.substring(0,aIndex));
		aPlainPointer = aPlainPointer.substring (aIndex+1,aLength);
	}
	
	MultiSign_closure_callback = function (aResult)
	{
		if (aResult == 0)
		{
			for(i = 0; i < aTotal ; i++)
			{
				aSigned = AnySign.GetMultiSignedData (aMultiSignID, i);
				aSignedMsg += aSigned + aDelimeter;
			}	
		} else {
			aSigned = AnySign.GetMultiSignedData (aMultiSignID, 0);
			aSignedMsg = aSigned + aDelimeter;
		}

		aUserCallback(aSignedMsg);
		AnySign.MultiSignFinal(aMultiSignID);
	}

	AnySign.MultiSignEx(aMultiSignID, 
						null, 
						null, 
						0, 
						null, 
						3, 
						MultiSign_closure_callback, 
						MultiSignEx_ErrCallback);
}

MultiSignWithSerial = function (aTotal, 
								aPlainMsg, 
								aDelimeter, 
								aCertSerial,
								aCertLocation,
								aUserCallback)
{
	var aSignedMsg = "";
	var aMultiSignID = "";
	var aPlainPointer = aPlainMsg;
	var aIndex= "";
	var aLength = "";
	var aSigned = "";

	if (aTotal <= 0 || aPlainMsg == undefined || aPlainMsg == "")
	{
		alert("input err");
		return "";
	}

	aMultiSignID = AnySign.MultiSignInit();

	for(i =0;i < aTotal ;i++)
	{
		aLength = aPlainPointer.length;
		aIndex = aPlainPointer.indexOf (aDelimeter);

		AnySign.SetMultiSignData (aMultiSignID,aPlainPointer.substring(0,aIndex));
		aPlainPointer = aPlainPointer.substring (aIndex+1,aLength);
	}

	MultiSignWithSerial_closure_callback = function (aResult)
	{
		if (aResult == 0)
		{
			for(i = 0; i < aTotal ; i++)
			{
				aSigned = AnySign.GetMultiSignedData (aMultiSignID, i);
				aSignedMsg += aSigned + aDelimeter;
			}
		} else {
			aSigned = AnySign.GetMultiSignedData (aMultiSignID, 0);
			aSignedMsg = aSigned + aDelimeter;
		}
		
		aUserCallback(aSignedMsg);
		AnySign.MultiSignFinal(aMultiSignID);
	}

	AnySign.MultiSignExWithSerial (aMultiSignID,
								   null,
								   null,
								   aCertSerial,
								   aCertLocation,
								   0,
								   null,
								   null,
								   MultiSignWithSerial_closure_callback,
								   MultiSignExWithSerial_ErrCallback);
}

MultiSignWithVID_Serial = function (aTotal, 
								aPlainMsg, 
								aDelimeter, 
								aCertSerial,
								aCertLocation,
								aSvrCert,
								aUserCallback)
{
	var aSignedMsg = "";
	var aMultiSignID = "";
	var aPlainPointer = aPlainMsg;
	var aIndex= "";
	var aLength = "";
	var aSigned = "";

	if (aTotal <= 0 || aPlainMsg == undefined || aPlainMsg == "")
	{
		alert("input err");
		return "";
	}

	aMultiSignID = AnySign.MultiSignInit();

	for(i =0;i < aTotal ;i++)
	{
		aLength = aPlainPointer.length;
		aIndex = aPlainPointer.indexOf (aDelimeter);

		AnySign.SetMultiSignData (aMultiSignID,aPlainPointer.substring(0,aIndex));
		aPlainPointer = aPlainPointer.substring (aIndex+1,aLength);
	}

	MultiSignWithSerial_closure_callback = function (aResult)
	{
		if (aResult == 0)
		{
			for(i = 0; i < aTotal ; i++)
			{
				aSigned = AnySign.GetMultiSignedData (aMultiSignID, i);
				aSignedMsg += aSigned + aDelimeter;
			}
		} else {
			aSigned = AnySign.GetMultiSignedData (aMultiSignID, 0);
			aSignedMsg = aSigned + aDelimeter;
		}
		
		aUserCallback(aSignedMsg);
		AnySign.MultiSignFinal(aMultiSignID);
	}

	AnySign.MultiSignExWithVID_Serial (aMultiSignID,
								   null,
								   null,
								   aCertSerial,
								   aCertLocation,
								   0,
								   null,
								   aSvrCert,
								   null,								   
								   MultiSignWithSerial_closure_callback,
								   MultiSignExWithSerial_ErrCallback);
}

MultiFileSign = function (aTotal,
						  aPlainMsg,
						  aDelimeter,
						  aUserCallback)
{
	var aSignedFiles = "";
	var aSignedPath = "";
	var aMultiSignID = "";
	var aPlainPointer = aPlainMsg;
	var aIndex= "";
	var aLength = "";

	if (aTotal <= 0 || aPlainMsg == undefined || aPlainMsg == "")
	{
		alert("[MultiFileSign] invalid parameters.");
		return "";
	}

	aMultiSignID = AnySign.MultiSignInit ();

	for (i = 0; i < aTotal; i++)
	{
		aLength = aPlainPointer.length;
		aIndex = aPlainPointer.indexOf(aDelimeter);

		AnySign.SetMultiSignData (aMultiSignID,aPlainPointer.substring(0,aIndex));
		aPlainPointer = aPlainPointer.substring (aIndex+1,aLength);
	}

	MultiFileSign_closure_callback = function (aResult)
	{
		if (aResult == 0)
		{
			for(i = 0; i < aTotal ; i++)
			{
				aSignedPath = AnySign.GetMultiSignedData (aMultiSignID, i);
				if (aSignedPath == "")
					continue;

				aSignedFiles += aSignedPath + aDelimeter;
			}
			aUserCallback(aSignedFiles);
		}
		AnySign.MultiSignFinal(aMultiSignID);
	}
	AnySign.MultiFileSign(aMultiSignID,
						  null,
						  null,
						  0,
						  null,
						  3,
						  MultiFileSign_closure_callback,
						  MultiFileSign_ErrCallback);
}

MultiSignFileInfo = function (aXgateAddress,
							  aCAList,
							  aTotal,
							  aDelimeter,
							  aFileInfo,
							  aFileHash,
							  aOption,
							  aDescription,
							  aLimitedTrial,
							  aUserCallback,
							  aErrCallback)
{
	var aSignedMsg = "";
	var aMultiSignID = "";
	var aFileInfoPointer = aFileInfo;
	var aFileHashPointer = aFileHash;
	var aIndex1= "";
	var aIndex2= "";
	var aLength1 = "";
	var aLength2 = "";
	var aSigned = "";
	
	if (aTotal <= 0 || aFileInfo == undefined || aFileInfo == "" || aFileHash == undefined || aFileHash == "")
	{
		alert("input err");
		return "";
	}

	aMultiSignID = AnySign.MultiSignInit();
	
	for(i =0;i < aTotal ;i++)
	{
		aLength1 = aFileInfoPointer.length;
		aIndex1 = aFileInfoPointer.indexOf (aDelimeter);
		
		aLength2 = aFileHashPointer.length;
		aIndex2 = aFileHashPointer.indexOf (aDelimeter);
		
		AnySign.SetMultiSignData (aMultiSignID, aFileInfoPointer.substring(0,aIndex1), aFileHashPointer.substring(0,aIndex2));
		aFileInfoPointer = aFileInfoPointer.substring (aIndex1+1,aLength1);
		aFileHashPointer = aFileHashPointer.substring (aIndex2+1,aLength2);
	}
	
	MultiSignFileInfo_closure_callback = function (aResult)
	{
		if (aResult == 0)
		{
			for(i = 0; i < aTotal ; i++)
			{
				aSigned = AnySign.GetMultiSignedData (aMultiSignID, i);
				aSignedMsg += aSigned + aDelimeter;
			}
			
			aUserCallback(aSignedMsg);
		}
		
		AnySign.MultiSignFinal(aMultiSignID);
	}
	
	AnySign.MultiSignFileInfo (aMultiSignID,
							   aXgateAddress,
							   aCAList,
							   aOption,
							   aDescription,
							   aLimitedTrial,
							   MultiSignFileInfo_closure_callback,
							   aErrCallback);
}

MultiSignFileInfoWithSerial = function (aXgateAddress,
										aCAList,
										aCertSerial,
										aCertLocation,
										aTotal,
										aDelimeter,
										aFileInfo,
										aFileHash,
										aOption,
										aDescription,
										aLimitedTrial,
										aUserCallback,
										aErrCallback)
{
	var aSignedMsg = "";
	var aMultiSignID = "";
	var aFileInfoPointer = aFileInfo;
	var aFileHashPointer = aFileHash;
	var aIndex1= "";
	var aIndex2= "";
	var aLength1 = "";
	var aLength2 = "";
	var aSigned = "";
	
	if (aTotal <= 0 || aFileInfo == undefined || aFileInfo == "" || aFileHash == undefined || aFileHash == "")
	{
		alert("input err");
		return "";
	}

	aMultiSignID = AnySign.MultiSignInit();
	
	for(i =0;i < aTotal ;i++)
	{
		aLength1 = aFileInfoPointer.length;
		aIndex1 = aFileInfoPointer.indexOf (aDelimeter);
		
		aLength2 = aFileHashPointer.length;
		aIndex2 = aFileHashPointer.indexOf (aDelimeter);
		
		AnySign.SetMultiSignData (aMultiSignID, aFileInfoPointer.substring(0,aIndex1), aFileHashPointer.substring(0,aIndex2));
		aFileInfoPointer = aFileInfoPointer.substring (aIndex1+1,aLength1);
		aFileHashPointer = aFileHashPointer.substring (aIndex2+1,aLength2);
	}
	
	MultiSignFileInfoWithSerial_closure_callback = function (aResult)
	{
		if (aResult == 0)
		{
			for(i = 0; i < aTotal ; i++)
			{
				aSigned = AnySign.GetMultiSignedData (aMultiSignID, i);
				aSignedMsg += aSigned + aDelimeter;
			}
			
			aUserCallback(aSignedMsg);
		}
		
		AnySign.MultiSignFinal(aMultiSignID);
	}
	
	AnySign.MultiSignFileInfoWithSerial (aMultiSignID,
										 aXgateAddress,
										 aCAList,
										 aCertSerial,
										 aCertLocation,
										 aOption,
										 aDescription,
										 aLimitedTrial,
										 MultiSignFileInfoWithSerial_closure_callback,
										 aErrCallback);
}

send_vid_info = function (aUserCallback)
{
	/*------------------------------------------------------------------------
	 * Should have a function(aUserCallback)
	 *----------------------------------------------------------------------*/
	return AnySign.GetVidInfo (aUserCallback, GetVidInfo_ErrCallback);
}

XecureLink = function (link)
{
	return AnySign.XecureLink (link);
}

XecureSubmit = function (form, aSessionKey)
{
	return AnySign.XecureSubmit (form, aSessionKey);
}

XecureNavigate = function (url, aTarget, aFeature)
{
	return AnySign.XecureNavigate (url, aTarget, aFeature);
}

BlockEnc = function (aPlain, aMethod, aUserCallback)
{
	AnySign.BlockEnc("/", aPlain, aMethod, aUserCallback);
}

BlockEnc2 = function (aPlain, aMethod, aCharset, aUserCallback)
{
	AnySign.BlockEnc2("/", aPlain, aMethod, aCharset, aUserCallback);
}

BlockEncEx = function (aPlain, aMethod, aCharset, aUserCallback, aParam)
{
	AnySign.BlockEncEx ("/", aPlain, aMethod, aCharset, aUserCallback, aParam);
}

BlockDec = function (aCipher, aElement, aUserCallback, aParam)
{
	return AnySign.BlockDec(aCipher, aElement, aUserCallback, aParam);
}

FileHash = function (aPath, aAlg, aUserCallback)
{
	AnySign.FileHash (aPath, aAlg, aUserCallback, FileHash_ErrCallback);
}

function vKeypadOK(type, formName, decInputName ) {}

function GetSafeResponse(aText) { return aText; }

function setExtension_encCallback (aUserCallback)
{
	if (AnySign.mAnySignEnable)
		AnySign.mExtensionSetting.mEncCallback = aUserCallback;
	else
		aUserCallback ();
}

function setBlockDec_callback (aUserCallback, aParam)
{
	if (AnySign.mAnySignEnable)
		AnySign.setBlockDec_callback(aUserCallback, aParam);
	else
		aUserCallback (aParam);
}

function setExternal_callback (aUserCallback)
{
	AnySign.mExtensionSetting.mExternalCallback.func = aUserCallback;
}

function getIEVersion () {
	var aUserAgent = navigator.userAgent,
		aBrowserVersion,
		aRegExp;

	if (aUserAgent.indexOf("MSIE") >= 0 || aUserAgent.indexOf("Trident") >= 0)
	{
		if(document.documentMode) {
			aBrowserVersion = document.documentMode;
		} else {
			aRegExp  = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
		}
	}

	if (aRegExp && aRegExp.exec(aUserAgent) != null)
		aBrowserVersion = parseFloat( RegExp.$1 );

	return aBrowserVersion;
}

SetConvertTable = function ()
{
	AnySign.SetPolicyConvertTableFirst("1.2.410.200005.1.1.1", "범용개인", "");		//은행,카드

	AnySign.SetPolicyConvertTableNext("1.2.410.200004.2.201", "범용개인", "");		//은행,카드

	AnySign.SetPolicyConvertTableNext("1.2.410.200004.5.1.1.5", "범용개인", "");		//은행,카드
}

function showAnySignLoadingImg (aType) {
	var aImageSRC;
	var aElement1 = document.getElementById("AnySign4PCLoadingImg");
	var aElement2 = document.getElementById("AnySign4PCLoadingImg_overlay");
	//KB927917 오류 관련
	//페이지 상단에 AnySign4PCLoadElement ID로 된 DIV가 필요함
	var aElement3 = document.getElementById("AnySign4PCLoadElement");

	if (document.body != null && aElement1 == null)
	{
		if (AnySign.mAnySignShowImg.showDiv) {
			var aOverlay = document.createElement('div');
			var _resizeOverlayFunction;
			aOverlay.style.zIndex = AnySign.mAnySignShowImg.zIndex + 100;
			aOverlay.style.backgroundImage = 'none';
			aOverlay.style.marginLeft = '0px';
			aOverlay.style.cursor = 'auto';
			aOverlay.onclick = null;
			aOverlay.id = "AnySign4PCLoadingImg_overlay";
			aOverlay.style.position = 'fixed';
			aOverlay.style.width = '100%';
			aOverlay.style.height = '100%';
			aOverlay.style.top = '0';
			aOverlay.style.left = '0';

			var aBrowserVersion = parseInt(AnySign.mBrowser.aVersion);

			if (aBrowserVersion < 9) {
				aOverlay.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+AnySign.mBasePath+"/img/gray.png', sizingMethod='scale')";
			}
			else if(AnySign.mBrowser.aName == "chrome" && aBrowserVersion > 9) {
				aOverlay.style.background = '-webkit-radial-gradient(rgba(127, 127, 127, 0.5), rgba(127, 127, 127, 0.5) 35%, rgba(0, 0, 0, 0.7))';
			}
			else if(AnySign.mBrowser.aName == "firefox")
			{
				aOverlay.style.background = '-moz-radial-gradient(rgba(127, 127, 127, 0.5), rgba(127, 127, 127, 0.5) 35%, rgba(0, 0, 0, 0.7))';
			}
			else {
				aOverlay.style.backgroundColor = '#333333';
				aOverlay.style.opacity = '0.2';
			}

			if (aElement3 != null) {
				aElement3.appendChild (aOverlay);
			} else {
				document.body.appendChild (aOverlay);
			}
		}

		if (aType == "update") {
			aImageSRC = "loading_update";
		} else {
			aImageSRC = "loading";
		}

		var aImage = document.createElement("img");
		if (typeof AnySign.mLanguage === 'string' && AnySign.mLanguage.toLowerCase() == "ko-kr") {
			aImage.src = AnySign.mBasePath + "/img/" + aImageSRC + ".gif";
		}
		else {
			aImage.src = AnySign.mBasePath + "/img/" + aImageSRC + "_en.gif";
		}

		aImage.style.width = 'auto';
		aImage.style.height= 'auto';
		aImage.style.position = 'fixed';
		aImage.style.top = '20%';
		aImage.style.left= '50%';
		aImage.style.marginLeft = '-150px';
		aImage.style.zIndex = AnySign.mAnySignShowImg.zIndex + 1000;
		aImage.id = 'AnySign4PCLoadingImg';

		if (aElement3 != null) {
			aElement3.appendChild (aImage);
		} else {
			document.body.appendChild (aImage);
		}
	}

	if ((AnySign.mAnySignLoad == true && (AnySign.mAnySignShowImg.endImgAfterDec ? AnySign.mPageBlockDecDone == true : true) && aElement1 != null)
		|| AnySign.mExtensionSetting.mImgIntervalError == true)
	{
		if (aElement1) {
			clearInterval (AnySign.mExtensionSetting.mImgIntervalFunc);
			if (aElement3 != null) {
				aElement3.removeChild (aElement1);
			} else {
				document.body.removeChild (aElement1);
			}

			if (aElement2) {
				if (aElement3 != null) {
					aElement3.removeChild (aElement2);
				} else {
					document.body.removeChild (aElement2);
				}
			}
		}
	}
}

function AnySign4PC_installCheck (aUserCallback) {
	AnySign.mExtensionSetting.mImgIntervalError = true;
	AnySign.AnySign4PC_installCheck (aUserCallback);
}

function AnySign4PC_installCallback (aUserCallback) {
	AnySign.AnySign4PC_installCallback (aUserCallback);
}

function AnySign4PC_LoadCallback (aUserCallback) {
	AnySign.AnySign4PC_LoadCallback (aUserCallback);
}
