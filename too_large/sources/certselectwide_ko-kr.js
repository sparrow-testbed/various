(function() { 
    return {
	media_location: "인증서 위치",
	media_localstorage: "브라우저",
	media_memorystorage: "인증서찾기",
	media_hdd: "하드디스크",
	media_mobile: "휴대폰",
	media_pkcs11: "보안토큰",
	media_removable: "이동식디스크",
	media_savetoken: "저장토큰",
	media_smartcert: "스마트인증",
	media_nfciccard: "금융IC카드",
	media_securedisk: "안전디스크",
    media_xfs: "프리싸인",
    media_webpage: "프리싸인",

	table_expire: "만료일",
	table_issuer: "발급자",
	table_section: "구분",
	table_user: "사용자",
	table_manager: "인증서관리",

	input_mouse: "마우스로 입력",
	input_guide: "인증서 선택 후 암호를 입력하세요.",
    input_guide2: "인증서를 선택하세요.",

	button_ok: "확인",
	button_cancel: "취소",
	
	open_new_window: "새창 열림 ",
	open_layer: "레이어 열림 ",
	xvvcursor_guide: "인증서 입력(전자서명) 영역으로 진입하였습니다. 센스리더 사용자는 원활한 사용을 위해 가상커서를 해제해주시기 바랍니다. 가상커서는 현재 위치에서 엔터키를 입력하면 해제됩니다.",

	decpasswd: "인증서 암호는 대소문자를 구분합니다.",
	deenvelope: "복호화에 사용할 인증서 선택",
	deletecert: "인증서삭제",
	duplicateerror: "동일한 인증서로 이미 서명되어 있습니다.\n다른 인증서를 선택해 주십시오.",
	envelope: "암호화에 사용할 인증서 선택",
	info: "전자서명 정보",
	login: "로그인할 인증서 선택",
	nokeyworderror: "인증서 암호를 입력하십시오.",
	noremovable: "시스템에 이동식 드라이브가 없거나 이동식 드라이브에 저장된 인증서가 없습니다.",
	passwd: "인증서 암호",
	keyworderror: "인증서 암호가 올바르지 않습니다.\n인증서 암호는 대문자 소문자를 구분합니다.\n<Caps Lock>키가 켜져 있는지 확인하시고 다시 입력하십시오.",
	keywordfail: "인증서 암호를 %s회이상 실패하셨습니다.",
	pkcs11cancel: "보안토큰 비밀번호 입력이 취소되었습니다.",
	pkcs11incorrect: "잘못된 보안토큰 비밀번호입니다.",
	renew: "갱신할 인증서 선택",
	revoke: "폐기/효력정지할 인증서 선택",
	searchcert: "인증서찾기",
	selectdeenvelope: "복호화에 사용할 인증서를 선택하십시오.",
	selectenvelope: "암호화에 사용할 인증서를 선택하십시오.",
	selecterror: "인증서를 선택하지 않았습니다.",
	selectlogin: "인증서를 선택하고 인증서 암호를 입력하십시오.",
	selectrenew: "갱신할 인증서를 선택하십시오.",
	selectrevoke: "폐기/효력정지할 인증서를 선택하십시오.",
	selectsign: "서명에 사용할 인증서를 선택하십시오.",
	selectverifyvid: "신원확인을 위한 인증서를 선택하십시오.",
	title: "인증서 입력 (전자서명)",
	verifyvid: "신원확인을 위한 인증서 선택",
	viewcert: "인증서보기",
	noselection: "인증서를 선택하지 않았습니다.",
	privatecert: "일반인증서",
	incorrect_kmcertPW: "암호화용 인증서의 비밀번호가 다릅니다.\n복구하시려면 재발급이 필요합니다.\n자세한 사항은 관리자에게 문의 하십시오. 계속 진행하시겠습니까?",
	
	mobile_mobi: "휴대폰 인증서 저장/전자서명(금융결제원)",
	mobile_info: "휴대폰 인증서 저장 서비스",

	iccard: "IC 카드",
	mscsp: "Microsoft CSP",
	usbtoken: "USB 토큰",
	kepcoiccard: "KEPCO IC 카드",
	
	willbeexpired: "선택하신 인증서는\n%s 만료 예정입니다.",
	renewplease1: "만료일 이전에 인증서를 ",
	renewplease2: "갱신해 주시기 바랍니다.",

	deletefail: "인증서 삭제에 실패하였습니다.",
	deleteok: "인증서를 삭제하였습니다.",
	deleteconfirm: "선택된 인증서는 영구히 삭제됩니다.\n계속하시겠습니까?",

	installNotify: "휴대폰 인증 설치 페이지로 이동하시겠습니까?",
	installNotifyHSM: "현재 사용가능한 상태가 아닙니다.\n\n보안토큰 구동프로그램을 설치하시겠습니까?",
	mobileError: "유효기간이 지났거나 유효하지 않은 인증서입니다.",

	/* 접근성 */
	banner: "배너",
	certtable: "인증서 목록",
	table_summary: "구분, 사용자, 만료일, 발급자, 인증서관리",

	cert_status0: "정상 인증서",
	cert_status1: "만료 예정 인증서",
	cert_status2: "만료 된 인증서",

	media_hdd_icon: "하드디스크 아이콘",
	media_mobile_icon: "휴대폰 아이콘",
	media_pkcs11_icon: "보안토큰 아이콘",
	media_removable_icon: "이동식디스크 아이콘",
	media_savetoken_icon: "저장토큰 아이콘",
	
	media_removable_list: "이동식디스크 목록 상자",
	media_savetoken_list: "저장토큰 목록 상자",

	blank: "",
	exclamation: "인증서 선택 후 암호를 입력하세요.",
	exclamation_img: "알림",

	/* wooribank request */
	wb_explain: "우리은행 WooriBank Internet Banking",
	close: "닫기",
	sign_complete_msg: "전자서명이 완료 되었습니다.",
	go_next_step_msg: "다음 과정을 진행하여 주십시요.",
	tooltip_capslock1: "\"CapsLock\" ",
	tooltip_capslock2: "이 켜져 있습니다.",
	
	/* 20130219 sync from as-is */
	savetoken_msg: "해당 보안토큰 구동프로그램 정보를 찾을 수 없습니다.\n(http://www.rootca.or.kr [KISA전자서명인증관리센터]에서 관련 내용을 확인하시기 바랍니다.)",
	rootca_url: "http://www.rootca.or.kr",
	
	notableCert: "사용할 수 없는 인증서 입니다.",
	not_supported : "지원하지 않는 기능입니다.",
	not_allowed: "키보드보안이 실행되지 않은 경우 사용할 수 없습니다. \n계속적으로 문제가 발생할 경우 고객센터로 문의 하시기 바랍니다.",
	
	smartcert_install: "스마트 공인인증 서비스 프로그램이 설치되어 있지 않습니다.\n설치페이지로 이동하시겠습니까?",
	smartcert_error : "스마트 공인인증 프로그램 실행 중 오류가 발생하였습니다.",
	smartcert_cancel : "스마트 공인인증 프로그램 실행을 취소하였습니다.",
	smartcert_not_supported : "지원하지 않는 스마트 공인인증 서비스 업체입니다.",
	verifyHSM_fail: "인증받은 보안토큰이 아니거나 검증할 수 없습니다.\n(http://www.rootca.or.kr에서 관련 내용을 확인하시기 바랍니다.)\n\n계속 진행하시겠습니까?",
	anysign4pc_update: "[AnySign for PC] 공인인증 보안 프로그램 설치가 필요합니다.\n[확인]을 선택하시면 설치페이지로 연결됩니다.",
	
	securedisk_install: "안전디스크 프로그램이 설치되어 있지 않습니다.\n설치페이지로 이동하시겠습니까?",
	securedisk_notable: "안전디스크 프로그램이 설치되어 있지 않거나 사용할 수 없습니다.",
	securedisk_error: "안전디스크 실행 중 오류가 발생하였습니다.",
	
	kepcoiccard_notable: "KEPCO IC Card 프로그램이 설치되어 있지 않거나 사용할 수 없습니다.",
	
	xfs_no_cert: "사용 가능한 인증서가 없습니다."
	}
})();
