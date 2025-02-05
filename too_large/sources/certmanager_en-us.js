(function() {  
    return {
	certfilemng: "File",
	certinfomng: "Certificate Information",
	changecancel: "Cancel changing the private-key password.",
	changeok: "The private-key password change success",
	changefail: "The private-key password change fail",
	changepass: "Change Password",
	copy: "Copy",
	copycancel: "Cancel to copy certificate.",
	copyconfirm: "The same certificate exists already.\nDo you want to overwrite it?",
	copyfail: "Fail to copy certificate.\nThere is same certificate or can't save disk.",
	copyfail_iccard: "Fail to copy certificate.\nNot supported 2048 certificate.",
	copyfail_ubikey: "Copy the certificate is canceled or an error has occurred.",
	copyingcert: "... [Exporting certificate] Wait please ...",
	copyok1: "Selected Certificate is copied from [",
	copyok2: "] to [",
	copyok3: "].",
	copysamemedia: "The target media and the source media are the same.",
	deletecert: "Delete",
	deletecancel: "Cancel to delete certificate.",
	deleteconfirm: "Are you sure you want to delete the selected certificate [%cert,] ?",
	deleteconfirm2: "Are you sure you want to delete the selected certificate?",
	deletefail: "Fail to delete certificate.",
	deleteok: "Delete the certificate !",
	descdelete: "Delete Certificate.",
	descinstall: "Install the Root Certificate Authority",
	descroot: "Verify the Root Certificate Authority.",
	descvertify: "View Information of Certificate.",
	gettingcert: "... [Importing certificate] Wait please ...",
	hdd: "Hard Disk",
	hddlist: "Certificate List at Hard Disk",
	iccard: "IC Card",
	iccardlist: "Certificate List at ICCARD",
	kepcoiccard: "KEPCO IC Card",
	importexport: "Export / Import",
	exportcert: "Export Certificate",
	importcert: "Import Certificate",
	installroot: "Install",
	mounterror: "Can't mount disk.",
	nocert: "There isn't certificate.",
	noremovable: "Can't find any removable drive or any certificate in the removable drive in this system.",
	noselection: "Select Certificate !",
    noselection_media: "Select Media !",
	notfoundusb: "Can't find portable disk.",
	notsupportexport: "[Export] is not supported in this media.",
	notsupportimport: "[Import] is not supported in this media.",
    notsupportexportimport: "[Export/Import] is not supported in this media.",
	ownerverify: "User Details",
	phonelist: "Certificate List in the Mobile Phone",
	pkcs11: "Crypto Token",
	pkcs11cancel: "The input for pin number is canceled.",
	pkcs11incorrect: "Incorrect pin number.",
	pkcs11list: "Certificate List at Cryptographic Token(PKCS#11)",
	pkcs11selectcancel: "The provider selection is canceled.",
	pricatab: "Private CA",
	privatecert: "Common",
	pubcatab: "Public CA",
	removable: "Removable Disk",
	removablelist: "Certificate List at Removable Disk",
	rootcert: "Root",
	roottab: "Trusted Root CA",
	rootverify: "Verify Root CA",
	title: "Certificate Manager",
	usertab: "Personal",
	verifycancel: "Cancel to verify User Details.",
	verifyidnerr: "The number you entered does not match that of the selected certificate.",
	verifyingcert: "Now verifying certificate...",
	verifypasserr: "The password is incorrect. Make sure that <Caps Loc> is off and re-enter your password.",
	verifyvid: "The number you entered corresponds with our records.",
	verifyvidtitle: "Verify Identification Number.",
	verify: "View / Verify",
	warningcsp: "Not supported function.",
	warningfloppy: "Not supported function.",
	warningiccard: "Not supported function.",
	importsuccess: "Success to import certificate.",
	importfail: "Fail to import certificate.",
	importcancel: "Cancel to import certificate.",
	exportcomplete: "Complete to export certificate.",
	exportsuccess: "Success to export certificate.",
	exportfail: "Fail to export certificate.",
	exportcancel: "Cancel to export certificate.",
	incorrect_kmcertPW: "Different from the password for the certificate for encryption.\nFor more information, contact your administrator.\nDo you want to continue?",

	media_location: "Location",
	media_localstorage: "Browser",
	media_memorystorage: "Find",
	media_hdd: "Hard Disk",
	media_iccard: "IC Card",
	media_mobile: "Mobile Phone",
	media_pkcs11: "Crypto Token",
	media_removable: "Portable Drive",
	media_savetoken: "Storage Token",
	media_securedisk: "Secure Disk",
    media_xfs: "FreeSign",
	media_left:"◀",
	media_right:"▶",
	media_left_title:"Previous",
	media_right_title:"Next",
	
	mobile_mobi: "Certific Storing/Electronic Signature",
	mobile_info: "Certificate Storing Mobilephone Service",

	table_expire: "Expiration",
	table_issuer: "Issuer",
	table_section: "Division",
	table_user: "User",

	button_ok: "OK",
	button_cancel: "Cancel",
	
	open_new_window: "Open a new window. ",
	open_layer: "Open a layer ",
	xvvcursor_guide: "Certificate management layer is open. Sense reader users seamless use, please turn off the virtual cursor. Virtual cursor position, press the Enter key when the current is turned off.",

	installNotify: "Do you want to go to the mobile authentication install page?",
	installNotifyHSM: "Do you want to go to the HSM install page?",
	pkcs11List: "Certificate List at Cryptographic Token(PKCS#11)",
	tokenNotify: "Check whether cryptographic token is available.",

	/* Accessibility */
	banner: "Banner",
	certtable: "Certificate list",
	table_summary: "Division, User, Expiration, Issuer",

	table_select: "Select ",
	cert_status0: "Valid certificate",
	cert_status1: "The certificate is scheduled to expire.",
	cert_status2: "Expired certificate",

	media_removable_list: "Portable Drive list box",
	media_savetoken_list: "Storage Token list box",
	
	close: "close",

	blank: "",

	notSupported: "This function is not supported.",
	
	/* 20130219 synchronized as-is */
	savetoken_msg: "Cant't find the application for crypto token.\n(http://www.rootca.or.kr)",
	rootca_url: "http://www.rootca.or.kr",
	
	anysign4pc_update: "[AnySign for PC] Installation of certified authentication security program is required.\nIf you select OK to go to the installation page.",
	selectKeyworderror: "The password is incorrect. Make sure that <Caps Lock> is off and re-enter your password.",
	notsupportexport_flash: "You can not use the certificate export.\nIn order to export the certificate to a file stored on a web browser(Internet Explorer), you must have Flash 10 or higher.\nPlease use after installing Adobe Flash to connect to the website.",
	
	securedisk_install: "Secure Disk program is not installed.\nDo you want to go to the installation page?",
	securedisk_notable: "Secure Disk program is not installed or is not available.",
	securedisk_error: "An error occurred while running the Secure Disk.",
	
	kepcoiccard_notable: "An error occurred while running the KEPCO IC Card.",
    
    xfs_no_cert: "No certificates are available."
	}
})();
