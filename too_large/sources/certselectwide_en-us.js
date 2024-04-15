(function() {  
    return {
	media_location: "Location",
	media_localstorage: "Browser",
	media_memorystorage: "Find",
	media_hdd: "Hard Disk",
	media_mobile: "Mobile Phone",
	media_pkcs11: "Crypto Token",
	media_removable: "Portable Drive",
	media_savetoken: "Storage Token",
	media_smartcert: "Smart Cert",
	media_nfciccard: "NFC ICCard",
	media_securedisk: "Secure Disk",
    media_xfs: "FreeSign",
    media_webpage: "FreeSign",
	
	table_expire: "Expiration",
	table_issuer: "Issuer",
	table_section: "Division",
	table_user: "User",
	table_manager: "certificate manager",

	input_mouse: "input mouse",
	input_guide: "Put password after select certificate.",
    input_guide2: "Select certificate.",
	
	button_ok: "OK",
	button_cancel: "Cancel",
	
	open_new_window: "Open a new window",
	open_layer: "Open a layer ",
	xvvcursor_guide: "Select certificate (digital signature) layer is open. Sense to the reader using the user has smooth, please turn off the virtual cursor. Virtual cursor position, press the Enter key when the current is turned off.",
	
	decpasswd: "Password for the digital certificate is case sensitive",
	deenvelope: "Select certificate for deenveloping",
	deletecert: "Delete",
	duplicateerror: "The selected certificate is already used for signature.\nPlease, select different certificate.",
	envelope: "Select certificate for enveloping",
	info: "Information to be signed",
	login: "Login with certificate",
	nokeyworderror: "The password is missing.",
	noremovable: "Can't find any removable drive or any certificate in the removable drive in this system.",
	passwd: "Password : ",
	keyworderror: "The password is incorrect. Make sure that <Caps Lock> is off and re-enter your password.",
	keywordfail: "Incorrect password more than %s times.",
	pkcs11cancel: "The input for pin number is canceled.",
	pkcs11incorrect: "Incorrect pin number.",
	renew: "Select certificate for renewal",
	revoke: "Select certificate for revoke",
	searchcert: "Find",
	selectdeenvelope: "Select certificate for deenveloping",
	selectenvelope: "Select certificate for enveloping",
	selecterror: "Select the certificate!",
	selectlogin: "Select certificate for log-on",
	selectrenew: "Select certificate to renew",
	selectrevoke: "Select certificate to revoke",
	selectsign: "Select certificate for signing",
	selectverifyvid: "Select the certificate for the verification of ID number.",
	title: "Certificate",
	verifyvid: "Select certificate for verifying ID",
	viewcert: "View/Verify",
	noselection: "Select Certificate !",
	privatecert: "Common",
	incorrect_kmcertPW: "Different from the password for the certificate for encryption.\nFor more information, contact your administrator.\nDo you want to continue?",

	mobile_mobi: "Certific Storing/Electronic Signature",
	mobile_info: "Certificate Storing Mobilephone Service",

	iccard: "IC Card",
	mscsp: "Microsoft CSP",
	usbtoken: "USB Token",
	kepcoiccard: "KEPCO IC Card",

	willbeexpired: "The chosen certificate will be expired in %s.",
	renewplease1: "",
	renewplease2: "",

	deletefail: "Fail to delete certificate.",
	deleteok: "Deleted the certificate !",
	deleteconfirm: "Are you sure you want to delete the selected certificate?",

	installNotify: "Do you want to go to the mobile authentication install page?",
	installNotifyHSM: "You should install the appropriate application for selected location.\nWould you install the application?",
	mobileError: "certification is not valid or expiration date of certification is passed",

	/* Accessibility */
	banner: "Banner",
	certtable: "Certificate list",
	table_summary: "Division, User, Expiration, Issuer, Certificate manage",

	cert_status0: "",
	cert_status1: "",
	cert_status2: "",

	media_hdd_icon: "Hard Disk",
	media_mobile_icon: "Mobile Phone",
	media_pkcs11_icon: "Crypto Token",
	media_removable_icon: "Portable Drive",
	media_savetoken_icon: "Storage Token",
	
	media_removable_list: "Portable Drive list box",
	media_savetoken_list: "Storage Token list box",

	blank: "",
	exclamation: "The input for password after select certificate",
	exclamation_img: "notice",

	/* wooribank request */
	wb_explain: "wooriBank Internet Banking",
	close: "close",
	sign_complete_msg: "Signed Message has been completed.",
	go_next_step_msg: "Please proceed as follows.",
	tooltip_capslock1: "\"CapsLock\" ",
	tooltip_capslock2: "is On.",
	
	/* 20130219 sync from as-is */
	savetoken_msg: "Cant't find the application for crypto token.\n(http://www.rootca.or.kr)",
	rootca_url: "http://www.rootca.or.kr",

	notableCert: "Certificate is not available",
	not_supported : "Not supported",
	not_allowed: "If security is not a keyboard, you can not be used.\nIf you continue to experience problems, please contact Customer Service.",
	
	smartcert_install: "Smart accredited certification service program is not installed.\nDo you want to go to the installation page?",
	smartcert_error : "Smart accredited certification program, an error has occurred during execution.",
	smartcert_cancel : "Smart accredited certification service program execution is canceled.",
	smartcert_not_supported : "Service provider that does not support",
	verifyHSM_fail: "Crypto token can not be certified or is not verified.\n(http://www.rootca.or.kr)\n\nDo you want to continue?",
	anysign4pc_update: "[AnySign for PC] Installation of certified authentication security program is required.\nIf you select OK to go to the installation page.",
	
	securedisk_install: "Secure Disk program is not installed.\nDo you want to go to the installation page?",
	securedisk_notable: "Secure Disk program is not installed or is not available.",
	securedisk_error: "An error occurred while running the Secure Disk.",
	
	kepcoiccard_notable: "An error occurred while running the KEPCO IC Card.",
	
	xfs_no_cert: "No certificates are available."
	}
})();
