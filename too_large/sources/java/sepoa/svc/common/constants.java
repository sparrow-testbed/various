package sepoa.svc.common;

/**
 * 비즈니스 소스 로직에서 사용되는 하드코딩된 문자열들을 상수로 처리하여<br/>
 * 차후에 소프트웨어 재사용성을 높이도록 처리했다.<br/>
 * 계정코드등과 차/대변 값 등등, 타입이나 유형등의 상수들을 모아 놓는다.<br/>
 * made by 최원철 2013-10-25
 */
public class constants {
    public constants()
    {
    }
    /** [R102210241178][2022-12-30] (전자구매)총무부 경비팀의 결제지원센터 이전에 따른 일괄작업 SR요청  */
    public static final String DEFAULT_ACC_JUMCD = "084611";  // 결제지원센터
    
    
    /** TOBE 2017-07-01 총무부 ,ICT 상수 선언 */
    public static final String DEFAULT_GAM_JUMCD = "020644";   // 총무부
    public static final String DEFAULT_ICT_JUMCD = "020325";   // ICT
    
    /** 하드코딩을 피하기 위하여 기본적으로 사용될 회사코드(0001) */
    public static final String DEFAULT_COMPANY_CODE = "0001";   // 하드코딩을 피하기 위하여 기본적으로 사용될 회사코드
    /** 하드코딩을 피하기 위하여 기본적으로 사용될 회사명(동아) */
    public static final String DEFAULT_COMPANY_NAME = "동아";  // 하드코딩을 피하기 위하여 기본적으로 사용될 회사명

    /** 하드코딩을 피하기 위하여 기본적으로 사용될 사업장코드(A0) */
    public static final String DEFAULT_PLANT_CODE = "A0";   // 하드코딩을 피하기 위하여 기본적으로 사용될 사업장코드
    /** 하드코딩을 피하기 위하여 기본적으로 사용될 사업장명(동아) */
    public static final String DEFAULT_PLANT_NAME = "동아";  // 하드코딩을 피하기 위하여 기본적으로 사용될 사업장명

    /** 하드코딩을 피하기 위하여 기본적으로 사용될 구매그룹과 사업장코드의 첫째자리 문자(J) */
    public static final String DEFAULT_CTRL_CODE_PREFIX = "J";

    /** 하드코딩을 피하기 위하여 기본적으로 사용될 조회조건 시작일자 */
    public static final String SEARCH_FROM_DATE = "20140303";
    
    /** 하드코딩을 피하기 위하여 기본적으로 사용될 신규계약 종료일자 */
    public static final String DEFAULT_TO_DATE = "20991231";   	//동아 통합구매시스템에서 추가  CHO
    															//신규로 단가계약시 계약시작일은 오늘로 자동입력되나 계약종료일은 필수입력값이 아님
    															//계약종료일을 입력하지않은 건에 대해서는 계약종료일을 무제한으로 설정

    /** 하드코딩을 피하기 위하여 창성에서 기본적으로 사용되는 MRO 구매대행업체 코드 */
    public static final String MRO_SELLER_CODE = "858801";

    
    public static final String MONEY_FORMAT = "FM9999999999999999999999.9999";
    
    
    public static final String SCODE_QU_CODE = "D015";
    
    public static final String TITLE_PHONE_NUMBER = "029208114";
    
    

    /** 하드코딩을 피하기 위하여 기본적으로 공급업체 정보 */
    public static final String DEFAULT_SELLER_COMPANY_CODE = "S999";   // 하드코딩을 피하기 위하여 기본적으로 사용될 회사코드
    public static final String DEFAULT_SELLER_USER_ID      = "SUPPLIER";   // 하드코딩을 피하기 위하여 기본적으로 사용될 회사코드

    /**
       USER_TYPE 상태에 사용되는 열거형자료   SCODE.M103 <br/>
       Partner("P")   // 파트너업체 <br/>
       ,Seller("S")  // 공급업체 <br/>
       ,BBB("B")  // 바이어 ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        <br/>
     */
    public enum UserType {  // USER_TYPE 상태에 사용되는 열거형자료   SCODE.M103
         Partner("P")   // 파트너업체
        ,Seller("S")  // 공급업체
        ,BBB("B")  // 바이어 ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ;

        UserType( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
    }
    
    /**  동아 추가 2014.03.05 CHO
    PLANT_CODE 상태에 사용되는 열거형자료 SCODE.미등록 <br/>
    Cheonan("25")   	// 		천안   			<br/>
    ,Dalseong("29")  	// 		달성 				<br/>
    ,Banwoul("21")  	// 		반월 				<br/>
    ,DMB("23")  		// 		DMB 			<br/>
    ,Songdo("E0")  		// 		메이지바이오(송도) 	<br/>
    ,Icheon("28")  		// 		이천 				<br/>
     <br/>
    */
    
    public enum PlantCode {  // 플랜트코드 에 사용되는 열거형 자료    SCODE.미등록
    	Cheonan("25")   	// 천안
        ,Dalseong("29")  	// 달성
        ,Banwoul("21")  	// 반월
        ,DMB("23")  		// DMB
//        ,Songdo("E0")  		// 메이지바이오(송도)
        ,Icheon("28")  		// 이천
        ;

    	PlantCode( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
    }
    
    
    /** 	동아 추가 2014.03.05 CHO
    PRGubun 상태에 사용되는 열거형자료 SCODE.미등록 			<br/>
    Usual("AA")   			// 일반   					<br/>
    ,DirectOrder("BB")  	// 직발주의뢰 				<br/>
    ,NewContract("CC")  	// 신규단가계약 				<br/>
     <br/>
    */
    
    public enum PRGubun {  	// 구매요청구분 에 사용되는 열거형 자료    SCODE.미등록
    	Usual("AA")   			// 일반
        ,DirectOrder("BB")  	// 직발주의뢰
        ,NewContract("CC")  	// 신규단가계약
        ;

    	PRGubun( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
    }
    
    
    
    
    /** 	동아 추가 2014.03.05 CHO
      컴파니코드 상태에 사용되는 열거형자료 SCODE.미등록 <br/>
    ST("0001")   		// ST   			<br/>
    ,Holdings("0002")  	// 홀딩스 				<br/>
    ,medicine("0003")  	// 제약 				<br/>
    <br/>
    */
    
    public enum CompanyCode {  // 컴파니코드 에 사용되는 열거형 자료    SCODE.미등록
    	Holdings("0001")   		// ST
        ,ST("0002")  	// 홀딩스
        ,medicine("0003")  	// 제약
        ;

    	CompanyCode( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
    }
    
    
    

    /**
        SIGN_STATUS 상태에 사용되는 열거형자료   SCODE.M110 <br/>
        TempSave("T")   				// 임시저장 <br/>
        ,Approving("P")  				// 승인중 <br/>
        ,Approved("E")  				// 승인완료 <br/>
        ,Rejected("R")  				// 반려 <br/>
        ,ApproveSuccess_Regist("CE") 	// 결재완료_등록 <br/>
        ,ApproveSuccess_Temp("AE") 		// 결재완료(임시) <br/>
        ,Eval_Complete("BE") 			// 평가 완료 <br/>
        ,Access("A") 					// 평가 완료 <br/>
         <br/>
     */
    public enum SignStatus {  // SIGN_STATUS 상태에 사용되는 열거형자료   SCODE.M110
        TempSave("T")   // 임시저장
        ,Approving("P")  // 승인중
        ,Approved("E")  // 승인완료
        ,Rejected("R")  // 반려
        ,ApproveSuccess_Regist("CE") // 결재완료_등록
        ,ApproveSuccess_Temp("AE") // 결재완료(임시)
        ,Eval_Complete("BE") // 평가 완료
        ,Access("A") // 평가 완료
        ;

        SignStatus( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
    }

    /**
        JOB_STATUS 상태에 사용되는 열거형자료   SCODE.M116/M250/U001 <br/>
        TempSave("T")   // 임시저장 <br/>
        ,Approving("P")  // 승인중 <br/>
        ,Approved("E")  // 승인완료 <br/>
        ,Rejected("R")  // 반려 <br/>
        ,UnRegist("W") // 미등록 <br/>
        ,ReqTarget("X") // 신청대상 <br/>
         <br/>
         
         M250 : 업체 승인 상태
     */
    public enum JobStatus {  // JOB_STATUS 상태에 사용되는 열거형자료   SCODE.M116/M250/U001
        TempSave("T")   // 임시저장
        ,Approving("P")  // 승인중
        ,Approved("E")  // 승인완료
        ,Rejected("R")  // 반려
        ,UnRegist("W") // 미등록
        ,ReqTarget("X") // 신청대상
        ;

        JobStatus( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
    }

    /**
        group ware 전자 결재에 사용되는 열거형 자료   SCODE.D009<br/>
          TempSave("T")             // 임시저장 <br/>
        , Approving("P")            // 승인중 <br/>
        , Approved("E")             // 승인완료 <br/>
        , Rejected("R")             // 반려 <br/>
        , ApprovalCancellation("A") // 승인취소
         <br/>
         
         D009 : 그룹전자결재상태
     */
    public enum ElApDocStatus {    // group ware 전자 결재에 사용되는 열거형 자료   SCODE.D009
         TempSave("T")             // 임시저장
        ,Approving("P")            // 승인중
        ,Approved("E")             // 승인완료
        ,Rejected("R")             // 반려
        ,AppCancel("A")            // 승인취소
        ;

         ElApDocStatus( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
    }

    
    
    
    /**
        IV_STATUS 상태에 사용되는 열거형자료   SCODE.M1012 <br/>
        NotInsert("N")   // 미작성 <br/>
        TempSave("T")   // 임시저장 <br/>
        ,ExamStand("P")  // 검수대기 <br/>
        ,ExamCompleted("E")  // 검수완료 <br/>
        ,GrCompleted("IO")  // 입고완료 <br/>
        ,ExamRejected("R")  // 검수반려 <br/>
        ,PurchaseRejected("NR") // 구매팀 반려 <br/>
        ,E1("E1")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,E2("E2")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
         <br/>
     */
    public enum IVStatus {  // IV_STATUS 상태에 사용되는 열거형자료   SCODE.M1012
         NotInsert("N")   // 미작성
        ,TempSave("T")   // 임시저장
        ,ExamStand("P")  // 검수대기
        ,ExamCompleted("E")  // 검수완료
        ,GrCompleted("IO")  // 입고완료
        ,ExamRejected("R")  // 검수반려
        ,PurchaseRejected("NR") // 구매팀 반려
        ,E1("E1")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,E2("E2")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ;

        IVStatus( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
    }

    /**
        APP_STATUS 상태에 사용되는 열거형자료   SCODE.M109/M301 <br/>
        TempSave("T")   // 임시저장/미처리 <br/>
        ,Approving("P")  // 결재진행 <br/>
        ,Approved("E")  // 결재완료 <br/>
        ,Rejected("R")  // 결재반려 <br/>
         <br/>
     */
    public enum AppStatus {  // APP_STATUS 상태에 사용되는 열거형자료   SCODE.M109/M301
        TempSave("T")   // 임시저장/미처리
        ,Approving("P")  // 결재진행
        ,Approved("E")  // 결재완료
        ,Rejected("R")  // 결재반려
        ;

        AppStatus( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
    }

    /**
        PR_STATUS 상태에 사용되는 열거형자료   SCODE.M157/M159/M420 <br/>
        SelectSeller("A")   // 업체선정 <br/>
        ,ConsultCompleted("B")  // 품의완료 <br/>
        ,Estimating("C")  // 견적진행 <br/>
        ,ExplanNotice("E")  // 현설공고 <br/>
        ,PurchaseRequest("P")  // 구매요청 <br/>
        ,PurchaseRejected("R")  // 구매반송 <br/>
        ,TTT("T")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
         <br/>
     */
    public enum PRStatus {  // PR_STATUS 상태에 사용되는 열거형자료   SCODE.M157/M159/M420
         SelectSeller("A")   // 업체선정
        ,ConsultCompleted("B")  // 발주완료o
        ,Estimating("C")  // 견적진행
        ,ExplanNotice("E")  // 현설공고
        ,PurchaseRequest("P")  // 구매요청o
        ,PurchaseRejected("R")  // 구매반송
        ,TTT("T")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.(임시저장)o
        ;

        PRStatus( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
    }

    /**
        PR_PROCEEDING_FLAG 상태에 사용되는 열거형자료   SCODE.M159 <br/>
        SelectSeller("A")   // 업체선정 <br/>
        ,Estimating("C")  // 견적진행 <br/>
        ,ExplanNotice("E")  // 현설공고 <br/>
        ,PurchaseRequest("P")  // 구매요청 <br/>
        ,PurchaseRejected("R")  // 구매반송 <br/>
        ,YYY("Y")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,NNN("N")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,BBB("B")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,OOO("O")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,RR("RR")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,RP("RP")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,BR("BR")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,BP("BP")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,PF("PF")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,QP("QP")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,QF("QF")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,QT("QT")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,QW("QW")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,DDD("D")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        <br/>
     */
    public enum PRProceedingFlag {  // PR_PROCEEDING_FLAG 상태에 사용되는 열거형자료   SCODE.M159
        SelectSeller("A")   // 업체선정
        ,Estimating("C")  // 견적진행
        ,ExplanNotice("E")  // 현설공고
        ,PurchaseRequest("P")  // 구매요청
        ,PurchaseRejected("R")  // 구매반송
        ,YYY("Y")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,NNN("N")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,BBB("B")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,OOO("O")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,RR("RR")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,RP("RP")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,BR("BR")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,BP("BP")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,PF("PF")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,QP("QP")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,QF("QF")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,QT("QT")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,QW("QW")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,DDD("D")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ;

        PRProceedingFlag( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
    }

    /**
        RFQ_STATUS 상태에 사용되는 열거형자료   SCODE.M639 <br/>
        All("A")   // 전체 <br/>
        ,Evaluating("B")  // 평가중 <br/>
        ,EstimateCompleted("C")  // 견적종료 <br/>
        ,EvalCompleted("E")  // 평가완료 <br/>
        ,Estimating("G")  // 견적중 <br/>
        ,EstimateTerminated("P")  // 견적마감 <br/>
        ,Writing("T")  // 작성중 <br/>
        ,DDD("D")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,HHH("H")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,NNN("N")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,RRR("R")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,UUU("U")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,YYY("Y")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        <br/>
     */
    public enum RFQStatus {  // RFQ_STATUS 상태에 사용되는 열거형자료   SCODE.M639
        All("A")   // 전체
        ,Evaluating("B")  // 평가중
        ,EstimateCompleted("C")  // 견적종료
        ,EvalCompleted("E")  // 평가완료
        ,Estimating("G")  // 견적중
        ,EstimateTerminated("P")  // 견적마감
        ,Writing("T")  // 작성중
        ,DDD("D")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,HHH("H")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,NNN("N")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,RRR("R")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,UUU("U")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,YYY("Y")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ;

        RFQStatus( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
    }

    /**
        RFQ_FLAG 상태에 사용되는 열거형자료   SCODE.M702/M731/M168 <br/>
        EstimateCompleted("C")   // 견적종료 <br/>
        ,TBECompleted("E")  // TBE완료 <br/>
        ,EstimateTerminated("G")  // 견적마감 <br/>
        ,NegoCompleted("H")  // Nego완료 <br/>
        ,TempSave("N")  // 임시저장 <br/>
        ,BidOpen("O")  // 입찰개봉 <br/>
        ,Estimating("P")  // 견적진행 <br/>
        ,NegoRequest("R")  // Nego요청 <br/>
        ,TBERequest("T")  // TBE요청 <br/>
        ,BidMiss("U")  // 유찰 <br/>
        ,SSS("S")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,DDD("D")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        <br/>
     */
    public enum RFQFlag {  // RFQ_FLAG 상태에 사용되는 열거형자료   SCODE.M702/M731/M168
        EstimateCompleted("C")   // 견적종료
        ,TBECompleted("E")  // TBE완료
        ,EstimateTerminated("G")  // 견적마감
        ,NegoCompleted("H")  // Nego완료
        ,TempSave("N")  // 임시저장
        ,BidOpen("O")  // 입찰개봉
        ,Estimating("P")  // 견적진행
        ,NegoRequest("R")  // Nego요청
        ,TBERequest("T")  // TBE요청
        ,BidMiss("U")  // 유찰
        ,SSS("S")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,DDD("D")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ;

        RFQFlag( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
    }

    /**
        TBE_STATUS 상태에 사용되는 열거형자료   SCODE.M346 <br/>
        EvalCompleted("E")   // 평가완료 <br/>
        ,Evaluating("P")  // 평가진행 <br/>
        ,Rejected("R")  // 결제반려 <br/>
        ,EvalWait("T")  // 평가대기 <br/>
        <br/>
     */
    public enum TBEStatus {  // TBE_STATUS 상태에 사용되는 열거형자료   SCODE.M346
        EvalCompleted("E")   // 평가완료
        ,Evaluating("P")  // 평가진행
        ,Rejected("R")  // 결제반려
        ,EvalWait("T")  // 평가대기
        ;

        TBEStatus( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
    }

    /**
        SELLER_COND 상태에 사용되는 열거형자료   SCODE.M071 <br/>
        NewSeller("O")   // 신규업체 <br/>
        ,TempSeller("P1")  // 임시업체 <br/>
        ,TempOneSeller("P2")  // 임시업체(1회성) <br/>
        ,CorSeller("R")  // 협력업체 <br/>
        ,PPP("P")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,VVV("V")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,V1("V1")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,V2("V2")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,V3("V3")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        ,VT("VT")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다. <br/>
        <br/>
     */
    public enum SellerCond {  // SELLER_COND 상태에 사용되는 열거형자료   SCODE.M071
        NewSeller("O")   // 신규업체
        ,TempSeller("P1")  // 임시업체
        ,TempOneSeller("P2")  // 임시업체(1회성)
        ,CorSeller("R")  // 협력업체
        ,PPP("P")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,VVV("V")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,V1("V1")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,V2("V2")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,V3("V3")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ,VT("VT")  // ???, SCODE 에는 없는데 소스에는 있는 하드코딩 되어있던 문자이다.
        ;

        SellerCond( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
    }

    /**
        레벨에 사용되는 열거형자료   SLVEL.TYPE <br/>
        FIRST("M2000")      // 레벨 1단계 <br/>
        ,SECOND("M2001")      // 레벨 2단계 <br/>
        ,THIRD("M2002")      // 레벨 3단계 <br/>
        ,FOUR("M2003")      // 레벨 4단계 <br/>
        ,FIVE("M2004")      // 레벨 5단계 <br/>
        <br/>
     */
    public enum LevelCode{  // 레벨에 사용되는 열거형자료   SLVEL.TYPE
        FIRST("M2000")      // 레벨 1단계
        ,SECOND("M2001")      // 레벨 2단계
        ,THIRD("M2002")      // 레벨 3단계
        ,FOUR("M2003")      // 레벨 4단계
        ,FIVE("M2004")      // 레벨 5단계
        ;

        LevelCode( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
    }

    /**
     * 
     * 동아 통합구매시스템      CHO
		대분류 상태에 사용되는 열거형자료   <br/>  
        A01("A01")   // A01, 원료		<br/>
        ,A02("A02")  // A02, 재료		<br/>
        ,A03("A03")  // A03, 상품		<br/>
        ,A04("A04")  // A04, 외주가공	<br/>
        ,A05("A05")  // A05, 영선		<br/>
        ,A06("A06")  // A06, 연구/품질	<br/>
        ,A07("A07")  // A07, 판촉물	<br/>
        ,A08("A08")  // A08, 홍보물	<br/>
        ,A09("A09")  // A09, 간행물	<br/>
        <br/>
     */
    public enum ItemType {  //
    	
    	A01("A01")  // Item1, 원료
        ,A02("A02")  // Item2, 재료
        ,A03("A03")  // Item3, 상품
        ,A04("A04")  // Item4, 외주가공
        ,A05("A05")  // Item5, 영선
        ,A06("A06")  // Item6, 연구/품질
        ,A07("A07")  // Item7, 판촉물
        ,A08("A08")  // Item7, 홍보물
        ,A09("A09")  // Item7, 간행물
      // 2014.03.31 창성 소스 복사 후 주석 처리.
        ,MRO("006")          // 006 : MRO
        ;

    	ItemType( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
    }
    
    /**
     * 
     * 동아 통합구매시스템      CHO
		PR_TYPE 상태에 사용되는 열거형자료      <br/>  
        ZPR0("ZPR0")   // ZPR0, 직발주	<br/>  
        ,ZPR1("ZPR1")  // ZPR1, 일반		<br/>  
        ,ZPR2("ZPR2")  // ZPR2, 사전견적	<br/>  
        ,ZPR3("ZPR3")  // ZPR3, 단가계약	<br/>  
        ,ZPR4("ZPR4")  // ZPR4, 임시		<br/>  
        ,ZPR5("ZPR5")  // ZPR5, 임시		<br/>  
        ,ZPR6("ZPR6")  // ZPR6, 임시		<br/>  
        ,ZPR7("ZPR7")  // ZPR7, 직발주	<br/>  
        ,ZPR8("ZPR8")  // ZPR7, 임시		<br/>  
        ,ZPR9("ZPR9")  // ZPR7, 임시		<br/>  
        <br/>
     */
    public enum PRType {  // PR_TYPE 상태에 사용되는 열거형자료   
        ZPR0("ZPR0")   // ZPR0, 임시
        ,ZPR1("ZPR1")  // ZPR1, 일반
        ,ZPR2("ZPR2")  // ZPR2, 사전견적
        ,ZPR3("ZPR3")  // ZPR3, 단가계약 - 구매팀
        ,ZPR4("ZPR4")  // ZPR4, 단가계약 - 사업부
        ,ZPR5("ZPR5")  // ZPR5, 임시
        ,ZPR6("ZPR6")  // ZPR6, 임시
        ,ZPR7("ZPR7")  // ZPR7, 직발주
        ,ZPR8("ZPR8")  // ZPR7, 임시
        ,ZPR9("ZPR9")  // ZPR7, 단가계약(변경)
        ;

        PRType( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
    }

    /**
        PR_TYPE 상태에 사용되는 열거형자료   SCODE.M085 <br/>
         Materials_Unconf("001")// 001 : 원자재(미확정단가 적용) <br/>
        ,Materials("002")       // 002 : 원자재 <br/>
        ,Subsidiary("003")      // 003 : 부자재 <br/>
        ,Equipment("004")       // 004 : 설비 <br/>
        ,Consumables("005")     // 005 : 소모품 <br/>
        ,MRO("006")             // 006 : MRO <br/>
        ,Construction("007")    // 007 : 공사 <br/>
        ,Service("008")         // 008 : 용역 <br/>
        ,Product("009")         // 009 : 제품 <br/>
        <br/>
     */
    public enum M085 {  // PR_TYPE 상태에 사용되는 열거형자료   SCODE.M085
         Materials_Unconf("001")// 001 : 원자재(미확정단가 적용)
        ,Materials("002")       // 002 : 원자재
        ,Subsidiary("003")      // 003 : 부자재
        ,Equipment("004")       // 004 : 설비
        ,Consumables("005")     // 005 : 소모품
        ,MRO("006")             // 006 : MRO
        ,Construction("007")    // 007 : 공사
        ,Service("008")         // 008 : 용역
        ,Product("009")         // 009 : 제품
        ;
        
        M085( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
    }

    /**
     * SHIPPER_TYPE(내외자구분)에 사용되는 열거형자료   SCODE.M410 <br/>
     * DOMESTIC("D")   // D, 내자 <br/>
     * ,FOREIGN("O")   // O, 외자 <br/>
     * <br/>
     */
    public enum ShipperType {  // SHIPPER_TYPE(내외자구분)에 사용되는 열거형자료   SCODE.M410
        DOMESTIC("D")   // D, 내자
        ,FOREIGN("O")   // O, 외자
        ;
 
        ShipperType( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
    }

    /**
     * SETTLE_FLAG 가 사용되는 열거형자료 ( SDRLN 테이블에서의 선정여부 ) <br/>
     * YYY("Y")   // Y, ??? <br/>
     * ,NNN("N")   // N, ??? <br/>
     * ,DDD("D")   // D, ??? <br/>
     * ,XXX("X")   // X, ??? <br/>
     * <br/>
     */
    public enum SettleFlag {  // SETTLE_FLAG 가 사용되는 열거형자료 ( SDRLN 테이블에서의 선정여부 )
         YYY("Y")   // Y, ???
        ,NNN("N")   // N, ???
        ,DDD("D")   // D, ???
        ,XXX("X")   // X, ???
        ;
        
        SettleFlag( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
    }

    /**
        PAY_STATUS 에 사용되는 열거형자료   SCODE.M441 <br/>
        Canceled("CR")  //  지결취소 <br/>
        , Completed("E")  //   완료 <br/>
        , PurchaseRejected("NR")  //  구매담당자 반려 <br/>
        , Approving("P")  //   결재진행 <br/>
        , SignRejected("R")   //   결재반려 <br/>
        , Waiting("T")    //   대기 <br/>
        <br/>
     */
    public enum PayStatus {  // PAY_STATUS 에 사용되는 열거형자료   SCODE.M441
        Canceled("CR")  //  지결취소
        , Completed("E")  //   완료
        , PurchaseRejected("NR")  //  구매담당자 반려
        , Approving("P")  //   결재진행
        , SignRejected("R")   //   결재반려
        , Waiting("T")    //   대기
       ;
       
        PayStatus( String pValue ) {
           mValue = pValue;
       }
       private String mValue;
       public String getValue(){
           return mValue;
       }
   }

    /**
        TAX_STATUS 상태에 사용되는 열거형자료   SCODE.M516<br/>
        Deployed("100")  //  발행<br/>
        , Accepted("1")  //  승인<br/>
        , Canceled("700")  //  폐기<br/>
        , Completed("E")  //  완료<br/>
        , NRNR("NR")  //  ????<br/>
        , PPPP("P")  //  ????<br/>
        , Rejected("270")  //   반려승인<br/>
        , SendReq("000")  //  발행요청<br/>
        <br/>
     */
    public enum TaxStatus {  // TAX_STATUS 상태에 사용되는 열거형자료   SCODE.M516
        Deployed("100")  //  발행
        , Accepted("1")  //  승인
        , Canceled("700")  //  폐기
        , Completed("E")  //  완료
        , NRNR("NR")  //  ????
        , PPPP("P")  //  ????
        , Rejected("270")  //   반려승인
        , SendReq("000")  //  발행요청
       ;
       
        TaxStatus( String pValue ) {
           mValue = pValue;
       }
       private String mValue;
       public String getValue(){
           return mValue;
       }
   }
    
    /**
    TAX_STATUS 상태에 사용되는 열거형자료   SCODE.M516<br/>
      Completion("E")  //  완료<br/>
    , PurchReqsting("P")  //  구매요청진행<br/>
    , PurchReqStand("T")  //  구매요청대기<br/>
        , SendComplet("R")  //  SAP 전송완료 상태<br/>
    <br/>
     */
    public enum CoStatus {  // TAX_STATUS 상태에 사용되는 열거형자료   SCODE.M516
          Completion("E")  //  완료
        , PurchReqsting("P")  //  구매요청진행
        , PurchReqStand("T")  //  구매요청대기
        , SendComplet("R")  //  SAP 전송완료 상태
       ;
       
          CoStatus( String pValue ) {
           mValue = pValue;
       }
       private String mValue;
       public String getValue(){
           return mValue;
       }
    }

    /**
    CUR 상태에 사용되는 열거형자료   SCODE.M1009<br/>
      KRW("KRW")  //  원화<br/>
       , USD("USD") // USD<br/>
       , JPY("JPY") // 엔화<br/>
    <br/>
     */
    public enum CUR {  // TAX_STATUS 상태에 사용되는 열거형자료   SCODE.M1009
        KRW("KRW")  //원화
       , USD("USD") // USD
       , JPY("JPY") // 엔화
       ;
       
        CUR( String pValue ) {
           mValue = pValue;
       }
       private String mValue;
       public String getValue(){
           return mValue;
       }
    }

    /**
     ADV_FLAG 상태에 사용되는 열거형자료   SCODE.M452<br/>
       First("1")  //선급<br/>
       , Second("2") // 중도<br/>
       , Last("3") // 잔금<br/>
    <br/>
     */
    public enum ADVFlag {  // ADV_FLAG 상태에 사용되는 열거형자료   SCODE.M452
        First("1")  //선급
       , Second("2") // 중도
       , Last("3") // 잔금
       ;
       
        ADVFlag( String pValue ) {
           mValue = pValue;
       }
       private String mValue;
       public String getValue(){
           return mValue;
       }
    }

    /**
     INSPECT_METHOD 상태에 사용되는 열거형자료   SCODE.M437<br/>
        FullPayment("1")  // 완납(일시불)<br/>
       , Installment("2") // 분납<br/>
       , 기성("3") // 기성<br/>
    <br/>
     */
    public enum InspectMethod {  // INSPECT_METHOD 상태에 사용되는 열거형자료   SCODE.M437
        FullPayment("1")  // 완납(일시불)
       , Installment("2") // 분납
       , 기성("3") // 기성
       ;
       
        InspectMethod( String pValue ) {
           mValue = pValue;
       }
       private String mValue;
       public String getValue(){
           return mValue;
       }
    }
    /**
      TAX_STATUS 상태에 사용되는 열거형자료   SCODE.M453<br/>
        V1("V1")  //  매입/일반세금계산서 10%<br/>
      , VA("VA")  //  매입/영세율<br/>
      , VC("VC")  //  매입/면세(계산서)<br/>
      , VN("VN")  //  매입/증빙없음<br/>
      , VO("VO")  //  매입/영수증<br/>
      , XA("XA")  //  매입/불공제<br/>

     */
    public enum TaxType {  // TAX_STATUS 상태에 사용되는 열거형자료   SCODE.M453
        V1("V1")  //  매입/일반세금계산서 10%
      , VA("VA")  //  매입/영세율
      , VC("VC")  //  매입/면세(계산서)
      , VN("VN")  //  매입/증빙없음
      , VO("VO")  //  매입/영수증
      , XA("XA")  //  매입/불공제
      , V5("V5")  //  ???
     ;
     
        TaxType( String pValue ) {
         mValue = pValue;
     }
     private String mValue;
     public String getValue(){
         return mValue;
     }
  }
    /**
    EST_SIGN_STATUS 상태에 사용되는 열거형자료   SCODE.M240 -> MRO품목 승인/조회<br/>
    Requested ( "T" )        // 견적요청<br/>
    , Received ( "S" )      // 견적수신<br/>
    , ReEstimated ( "R" )   // 재견적<br/>
    , Approved ( "E" )     // 승인<br/>
    */
    public enum mroEstStatus { // EST_SIGN_STATUS 상태에 사용되는 열거형자료 SCODE.M240 -> MRO품목 승인/조회
        Requested ( "T" )        // 견적요청
        , Received ( "S" )      // 견적수신
        , ReEstimated ( "R" )   // 재견적
        , Approved ( "E" )     // 승인
        ;
        
        mroEstStatus ( String pValue ) {
            mValue = pValue ;
        }
        
        private String mValue ;
        
        public String getValue ( ) {
            return mValue ;
        }
    }
    
    /**
    MRO I/F 용 트리거테이블(dbo.KEPTRXL)의 문서구분(DOC_NAME)에 사용되는 열거형자료 PO(발주), GR(입고), RE(견적)<br/>
    PuchaseOrder ( "PO" )   // 발주<br/>
    , Warehousing ( "GR" )  // 입고<br/>
    , Estimation ( "RE" )   // 견적<br/>
    */
    public enum mroDocName { // MRO I/F 용 트리거테이블(dbo.KEPTRXL)의 문서구분(DOC_NAME)에 사용되는 열거형자료 PO(발주), GR(입고), RE(견적)
        PuchaseOrder ( "PO" )   // 발주
        , Warehousing ( "GR" )  // 입고
        , Estimation ( "RE" )   // 견적
        ;
        
        mroDocName ( String pValue ) {
            mValue = pValue ;
        }
        
        private String mValue ;
        
        public String getValue ( ) {
            return mValue ;
        }
    }
    
    /**
    MRO I/F 용 트리거테이블(dbo.KEPTRXL)의 문서구분(DOC_NAME)에 사용되는 열거형자료 PO(발주), GR(입고), RE(견적)<br/>
    PuchaseOrder ( "PO" )   // 발주<br/>
    , Warehousing ( "GR" )  // 입고<br/>
    , Estimation ( "RE" )   // 견적<br/>
    */
    public enum ApprovalDocType { // MRO I/F 용 트리거테이블(dbo.KEPTRXL)의 문서구분(DOC_NAME)에 사용되는 열거형자료 PO(발주), GR(입고), RE(견적)
          PuchaseOrder ( "PO" )   // 발주
        , Warehousing ( "GR" )    // 입고
        , Estimation ( "RE" )     // 견적
        , Subcontractor ( "VM" )  // 신규업체
        , ExpenseReport ( "EX" )  // 구매품의서
        , Retroaction ( "UD" )    // 단가승인요청
        , PriceChange ("PC")	  // 단가변경요청
        ;
           
          ApprovalDocType ( String pValue ) {
            mValue = pValue ;
        }
        
        private String mValue ;
        
        public String getValue ( ) {
            return mValue ;
        }
    }
    
    /**
     * 전자 결재시 사용 되는 form id
     *    FormIn0001( "853" )      // (협조)동아쏘시오홀딩스     :H         
     *    FormIn0002( "852" )      // (협조)동아ST               :E   
     *    FormIn0003( "854" )      // (협조)동아제약             :O     
     *    FormCo0001( "850" )      // (내부)동아쏘시오홀딩스     :H         
     *    FormCo0002( "849" )      // (내부)동아ST               :E   
     *    FormCo0003( "851" )      // (내부)동아제약             :O     
     *     
     */
    public enum GroupWareFormId {   // 전자 결재시 사용 되는 form id
          FormIn( "IN" )           // 내부 결재
        , FormIn0001( "853" )      // (내부)동아쏘시오홀딩스     :H
        , FormIn0002( "852" )      // (내부)동아ST               :E 
        , FormIn0003( "854" )      // (내부)동아제약             :O
        , FormCo( "CO" )           // 협조 공문
        , FormCo0001( "850" )      // (협조)동아쏘시오홀딩스     :H
        , FormCo0002( "849" )      // (협조)동아ST               :E 
        , FormCo0003( "851" )      // (협조)동아제약             :O
        ;
        
          GroupWareFormId ( String pValue ) {
              mValue = pValue ;
          }
        
          private String mValue ;
        
          public String getValue ( ) {
              return mValue ;
              
          }
          
    } // end of method GroupWareFormId
    
    

	
	
	/**
	의뢰형태 SCODE M427
		 Tender("B")	 입찰의뢰<br/>
		,Purch_req("P")  구매의뢰<br/>
		,CCC("C")  // ???? <br/>
	 <br/>
	 */
	public enum REQ_TYPE {  // 의뢰형태 SCODE M427
		Tender("B")   // 입찰의뢰
		,Purch_req("P")  // 구매의뢰
		,Cont("C")  // 구매팀단가계약
		;
	
		REQ_TYPE( String pValue ) {
			mValue = pValue;
		}
		private String mValue;
		public String getValue(){
			return mValue;
		}
	}




	/**
		GW 의 결재상태에 사용되는 열거형자료<br/>
		Processing("P")   // 진행<br/>
		,Canceled("C")  // 상신취소<br/>
		,Completed("E")  // 완료<br/>
		,Rejected("R")  // 반려<br/>
		, (1:완료, 3:진행, 5:반려, 8:상신취소)
		 <br/>
	 */
	public enum GWSignStatus {  // GW 의 결재상태에 사용되는 열거형자료
		Processing("P")   // 진행
		,Canceled("C")  // 상신취소
		,Completed("E")  // 완료
		,Rejected("R")  // 반려
		;

		GWSignStatus( String pValue ) {
			mValue = pValue;
		}
		private String mValue;
		public String getValue(){
			return mValue;
		}
	}


	/**
	 그룹웨어 결재 타입에 사용되는 열거형자료<br/>
		구매요청("110")   // 구매요청<br/>
		,구매결의("111")  // 구매결의<br/>
		,검수확인("112")  // 검수확인<br/>
		,지출결의("113")  // 지출결의<br/>
		,외자비용("114")  // 외자비용<br/>
		,경비법인카드("210")  // 경비법인카드<br/>
		,경비현금("211")  // 경비현금<br/>
		,경비지출결의("212")  // 경비지출결의<br/>
	<br/>
	 */
	public enum GWKyuljaeType {
		구매요청("110")   // 구매요청
		,구매결의("111")  // 구매결의
		,검수확인("112")  // 검수확인
		,지출결의("113")  // 지출결의
		,외자비용("114")  // 외자비용
		,경비법인카드("210")  // 경비법인카드
		,경비현금("211")  // 경비현금
		,경비지출결의("212")  // 경비지출결의
		;
	
		GWKyuljaeType( String pValue ) {
			mValue = pValue;
		}
		private String mValue;
		public String getValue(){
			return mValue;
		}
	}

	/**
	 업체등급에 사용되는 열거형자료<br/>
		EXBP("A")   	// 우수BP<br/>
		,BP("B")  		// BP<br/>
		,SELLER("C")  	// 거래업체<br/>
	<br/>
	 */
	public enum sellerGrade {
		EXBP("A")   	// 우수BP
		,BP("B")  		// BP
		,SELLER("C")  	// 거래업체
		;
	
		sellerGrade( String pValue ) {
			mValue = pValue;
		}
		private String mValue;
		public String getValue(){
			return mValue;
		}
	}

	/**
	  COMPUTE_REASON (금액산정근거) 상태에 사용되는 열거형자료   SCODE.M415<br/>
		사전견적("01")   	// 사전견적<br/>
		,업체및가격결정("02")   	// 업체및가격결정<br/>
		,예산금액("03")   	// 예산금액<br/>
		,현업검토예산("04")   	// 현업검토예산<br/>
	<br/>
	 */
	public enum ComputeReason {
		사전견적("01")   	// 사전견적
		,업체및가격결정("02")   	// 업체및가격결정
		,예산금액("03")   	// 예산금액
		,현업검토예산("04")   	// 현업검토예산
		;

		ComputeReason( String pValue ) {
			mValue = pValue;
		}
		private String mValue;
		public String getValue(){
			return mValue;
		}
	}

	/**
	  DELY_TO_CONDITION (금액산정근거) 상태에 사용되는 열거형자료   SCODE.M412<br/>
		,직접입력("02")   	// 업체및가격결정<br/>
		사전견적("01")   	// 사전견적<br/>
	<br/>
	 */
	public enum DelyToCondition {
		설치및검수완료("01")   	// 사전견적
		,직접입력("02")   	// 업체및가격결정
		;

		DelyToCondition( String pValue ) {
			mValue = pValue;
		}
		private String mValue;
		public String getValue(){
			return mValue;
		}
	}

	/**
	  SELLER_TYPE (업체형태) 상태에 사용되는 열거형자료   SCODE.M412<br/>
		 C("20")   	// 창성 협력업체<br/>
		,D("21")   	// 동현 협력업체<br/>
		,CD("22")   // 창성/동현 협력업체<br/>
	<br/>
	 */
	public enum SellerType {
		CS("20")   	// 창성 협력업체
		,DH("21")   	// 동현 협력업체
		,CD("22")   // 창성/동현 협력업체
		;

		SellerType( String pValue ) {
			mValue = pValue;
		}
		private String mValue;
		public String getValue(){
			return mValue;
		}
	}
	/**
	  CD_COMPANY (회계시스템 회사코드 - 창성/동현 구분코드) 상태에 사용되는 열거형자료   SCODE.M412<br/>
		 CS("1000")   	// 창성<br/>
		,DH("2000")   	// 동현<br/>
	<br/>
	 */
	public enum AcctComanyCd {
		CS("1000")   	// 창성
		,DH("2000")   	// 동현
		;

		AcctComanyCd( String pValue ) {
			mValue = pValue;
		}
		private String mValue;
		public String getValue(){
			return mValue;
		}
	}
	
	/**
	낙찰상태 SCODE M121
	 Success("B")	 낙찰<br/>
	,Failure("P")  유찰<br/>
	 */
	public enum BID_STATUS {  // 낙찰상태 SCODE M121
		Success("B")   // 낙찰
		,Failure("P")  // 유찰
		;
	
		BID_STATUS( String pValue ) {
			mValue = pValue;
		}
		private String mValue;
		public String getValue(){
			return mValue;
		}
	}
	
	
	/**
	 	대금지불조건 또는 만기일자 SCODE M421_1<br/>
		 KP08("KP08")   // 즉시현금<br/>
		 KP23("KP23")   // 익월말 현금지급<br/>
		 WWP3("WWP3")   // 익월말 30일 어음<br/>
		,WWP6("WWP6")   // 익월말 60일 어음<br/>
		,WWP9("WWP9")   // 익월말 90일 어음<br/>
		,WW12("WW12")   // 익월말 120일 어음<br/>
		<br/>
	 */
	public enum PayTerms {  // 대금지불조건 또는 만기일자 SCODE M421_1
		 KP08("KP08")   // 즉시현금
		,KP23("KP23")   // 익월말 현금지급
		,WWP3("WWP3")   // 익월말 30일 어음
		,WWP6("WWP6")   // 익월말 60일 어음
		,WWP9("WWP9")   // 익월말 90일 어음
		,WW12("WW12")   // 익월말 120일 어음
		;
	
		PayTerms( String pValue ) {
			mValue = pValue;
		}
		private String mValue;
		public String getValue(){
			return mValue;
		}
	}

	/**
		창성 회계 전표의 CD_PC 구분자<br/>
		인천동현("1000")	// 인천동현=1000<br/>
		,청주("2000")	// 청주=2000<br/>
		,평택("3000")	// 평택=3000<br/>
		<br/>
	 */
	public enum CD_PCS {  // 창성 회계 전표의 CD_PC 구분자
		인천동현("1000")	// 인천동현=1000
		,청주("2000")	// 청주=2000
		,평택("3000")	// 평택=3000
		;
	
		CD_PCS( String pValue ) {
			mValue = pValue;
		}
		private String mValue;
		public String getValue(){
			return mValue;
		}
	}

	/**
		창성 회계 전표시 사용될 사업장 구분자<br/>
		인천("A0")	// 인천=A0<br/>
		,청주("B0")	// 청주=B0<br/>
		,평택("C0")	// 평택=C0<br/>
		<br/>
	 */
	public enum PLANT_CD {  // 창성 회계 전표시 사용될 사업장 구분자
		인천("A0")	// 인천=A0
		,청주("B0")	// 청주=B0
		,평택("C0")	// 평택=C0
		;
	
		PLANT_CD( String pValue ) {
			mValue = pValue;
		}
		private String mValue;
		public String getValue(){
			return mValue;
		}
	}

	/**
		더존U 회계 전표시 사용될 차변/대변 구분자<br/>
		차변("1")	// 차변=1<br/>
		,대변("2")	// 대변=2<br/>
		<br/>
	 */
	public enum DUZONU_TP_DRCR {  // 더존U 회계 전표시 사용될 차변/대변 구분자
		차변("1")	// 차변=1
		,대변("2")	// 대변=2
		;
	
		DUZONU_TP_DRCR( String pValue ) {
			mValue = pValue;
		}
		private String mValue;
		public String getValue(){
			return mValue;
		}
	}

	/**
		더존U 회계 전표시 사용될 전표유형 구분자<br/>
		구매("45")		// 구매=45<br/>
		,외자비용("46")	// 외자비용=46<br/>
		,법인카드("17")	// 법인카드=17<br/>
		<br/>
	 */
	public enum DUZONU_CD_DOCU {  // 더존U 회계 전표시 사용될 전표유형 구분자
		구매("45")		// 구매=45
		,외자비용("46")	// 외자비용=46
		,법인카드("17")	// 법인카드=17
		;
	
		DUZONU_CD_DOCU( String pValue ) {
			mValue = pValue;
		}
		private String mValue;
		public String getValue(){
			return mValue;
		}
	}

	/**
		더존U 회계 전표시 사용될 세무코드 구분자<br/>
		과세("21")		// 과세(매입세금계산서)=21<br/>
		,영세("23")	// 영세(세금계산서)=23<br/>
		,면세("26")	// 면세(계산서)=26<br/>
		,법인카드("24")	//기타(법인카드)=24<br/>
		<br/>
	 */
	public enum DUZONU_VAT_TP_TAX {  // 더존U 회계 전표시 사용될 세무코드 구분자
		과세("21")		// 과세(매입세금계산서)=21
		,영세("23")	// 영세(세금계산서)=23
		,면세("26")	// 면세(계산서)=26
		,법인카드("24")	//기타(법인카드)=24
		;
	
		DUZONU_VAT_TP_TAX( String pValue ) {
			mValue = pValue;
		}
		private String mValue;
		public String getValue(){
			return mValue;
		}
	}

	/**
		창성 회계 전표시 사용될 사업장별 계정코드<br/>
		본지점인천("15001")	// 인천=15001<br/>
		,본지점청주("15002")	// 청주=15002<br/>
		,본지점평택("15003")	// 평택=15003<br/>
		<br/>
	 */
	public enum PLANT_ACCT_CODE {  // 창성 회계 전표시 사용될 사업장별 계정코드
		본지점인천("15001")	// 인천=15001 인천=A0
		,본지점청주("15002")	// 청주=15002 청주=B0
		,본지점평택("15003")	// 평택=15003 평택=C0
		;

		PLANT_ACCT_CODE( String pValue ) {
			mValue = pValue;
		}
		private String mValue;
		public String getValue(){
			return mValue;
		}
	}

	public static final String DUZONU_NO_TAX = "*";	//부가세라인이아닐경우 * 표시해야 한다.
	public static final String DUZONU_ST_DOCU = "1";	// 더존U 회계 전표시 사용될 승인여부
	public static final String DUZONU_원자재수입_ACCT_CODE = "15402";	//15402(원자재수입)
	public static final String DUZONU_미착_ACCT_CODE = "16500";	//16500(미착품)
	public static final String DUZONU_선급_ACCT_CODE = "13100";	//13100(선급금)
	public static final String DUZONU_V_ACCT_CODE = "13500";	//13500(부가세)
	public static final String DUZONU_현금_CODE = "10100";	//10100(현금)
	public static final String DUZONU_지급어음_CODE = "25200";	//25200(지급어음)
	public static final String DUZON_A10_CODE = "A10";	// A10 품명
	public static final String DUZON_A10_NAME = "품명";	// A10 품명
	public static final String DUZON_D68_CODE = "D68";	// D68 수량
	public static final String DUZON_D68_NAME = "수량";	// D68 수량
	public static final String DUZONU_A09_CODE = "810";	//810(하나은행)
	public static final String DUZONU_A09_NAME = "하나은행";	//하나은행
	public static final String DUZONU_JICHUL_POSTFIX = "B";	//B(타지점 지출결의시 접미어) 

	public static final String DUZONU_TITLE_사원 = "사원";	//사원
	public static final String DUZONU_TITLE_사업자번호 = "사업자번호";	//사업자번호
	public static final String DUZONU_TITLE_발생일자 = "발생일자";	//발생일자
	public static final String DUZONU_TITLE_과세표준액 = "과세표준액";	//과세표준액
	public static final String DUZONU_TITLE_신용카드 = "신용카드";	//신용카드
	public static final String DUZONU_TITLE_세무구분 = "세무구분";	//세무구분
	public static final String DUZONU_TITLE_수량 = "수량";	//수량
	public static final String DUZONU_TITLE_만기일자 = "만기일자";	//만기일자
	public static final String DUZONU_VAL_지급어음번호 = "123456";	//123456(지급어음번호)
	public static final String DUZONU_TITLE_지급어음번호 = "지급어음번호";	//지급어음번호
	public static final String DUZONU_VAL_지급어음정리구분 = "1";	//1(지급어음정리구분)
	public static final String DUZONU_TITLE_지급어음정리구분 = "지급어음정리구분";	//지급어음정리구분

	/**
	구매대행 인터페이스 진행시 사용할 상태 코드<br/>
	 Create("C")	// 신규<br/>
	,Update("R")	// 수정<br/>
	,Delete("D")	// 취소<br/>
	<br/>
	 */
	public enum mroIfStatus {
		Create("C")		// 신규
		,Update("R")	// 수정
		,Delete("D")	// 취소
		;
	
		 mroIfStatus( String pValue ) {
			mValue = pValue;
		}
		private String mValue;
		public String getValue(){
			return mValue;
		}
	}
	
	/**
	구매대행 인터페이스 진행시 사용할 IF_FLAG 코드<br/>
	 Complete("Y")		// 처리완료<br/>
	,NotProcessing("N")	// 미처리<br/>
	,False("F")			// 납품번호 중복 - 이미 처리된 건<br/>
	,Approving("P")		// 결재진행중/결재완료건으로 처리하지않음<br/>
	<br/>
	 */
	public enum mroIfFlag {
		 Complete("Y")		// 처리완료
		,NotProcessing("N")	// 미처리
		,False("F")			// 납품번호 중복 - 이미 처리된 건
		,Approving("P")		// 결재진행중/결재완료건으로 처리하지않음
		;
	
		mroIfFlag( String pValue ) {
			mValue = pValue;
		}
		private String mValue;
		public String getValue(){
			return mValue;
		}
	}
	


	/**
		창성 입고처리 인터페이스시 사용될 사업장코드<br/>
		인천("A211")	// 인천=A211 인천=A0<br/>
		,동현전자("A212")	// 동현전자=A212 청주=B0<br/>
		,평택("A213")	// 평택=A213 평택=C0<br/>
		,청주("A214")	// 청주=A214 청주=B0<br/>
		<br/>
	 */
	public enum INCOME_PLANT_CODE {  // 창성 입고처리 인터페이스시 사용될 사업장코드
		인천("A211")	// 인천=A211 인천=A0
		,동현전자("A212")	// 동현전자=A212 청주=B0
		,평택("A213")	// 평택=A213 평택=C0
		,청주("A214")	// 청주=A214 청주=B0
		;

		INCOME_PLANT_CODE( String pValue ) {
			mValue = pValue;
		}
		private String mValue;
		public String getValue(){
			return mValue;
		}
	}
	
	
	/**
		// 창성 품목분류에 의해서 견적요청 / 세금계산서 / 지결 생략<br/>
		nomal_price("NOM")	// 일반소싱<br/>
		,year_price("YEA")	// 년단가<br/>
		,un_conf_price("UNC")	// 미확정단가<br/>
		<br/>
	 */
	public enum Material_Categorize {  // 창성 품목분류에 의해서 견적요청 / 세금계산서 / 지결 생략
		 nomal_price("NOM")	// 일반소싱
		,year_price("YEA")	// 년단가
		,un_conf_price("UNC")	// 미확정단가
		;
		
		Material_Categorize( String pValue ) {
			mValue = pValue;
		}
		private String mValue;
		public String getValue(){
			return mValue;
		}
	}
    
    
    /**
        // 창성 품목분류에 의해서 견적요청 / 세금계산서 / 지결 생략<br/>
        nomal_price("NOM")  // 일반소싱<br/>
        ,year_price("YEA")  // 년단가<br/>
        ,un_conf_price("UNC")   // 미확정단가<br/>
        <br/>
     */
    public enum ApprovalDept {  // 결재 권한 부서 코드 : D012
        codeScodeType("D012")
        ,codeDept01("C230") , codeCcompany01("0002")  // 구매부 회사코드
        ,codeDept02("C231") , codeCcompany02("0002")  // 구매부 회사코드
        ;
        
         ApprovalDept( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
        
/*  //해당 값 사용시 참조
      int    foreachIndex = 0;
      String foreachDept  = "";
      String foreachComp  = "";
      for( sepoa.svc.common.constants.ApprovalDept approvalDept : sepoa.svc.common.constants.ApprovalDept.values() ){
          if( foreachIndex == 0 ){
              foreachIndex++;
              continue;
              
          }
          
          foreachDept  = "";
          foreachComp  = "";
          
          if( ( foreachIndex % 2 ) == 1 ){
              foreachDept = approvalDept.getValue();
              System.out.println( "foreachDept : " + foreachDept );
              
          } else {
              foreachComp = approvalDept.getValue();
              System.out.println( "foreachComp : " + foreachComp );
              
          }
          
          foreachIndex++;
          
      } // end for
 */        
        
        
    }
    
	    /**
		연구/품질과 Rcode와의 인터페이스<br/>
		A0601("A"),	//실험기기<br/>
		A0602("B"),	//시약<br/>
		A0603("D"),	//재료(기구)<br/>
		A0604("C"),	//동물<br/>
		A0605("E"),	//수리<br/>
		A0606("B"),	//합성중간체<br/>
		A0607("B")	//완제의약품<br/>
		<br/>
	 */
	public enum A06_RCODE {
		A0601("A"),	//실험기기
		A0602("B"),	//시약
		A0603("D"),	//재료(기구)
		A0604("C"),	//동물
		A0605("E"),	//수리
		A0606("B"),	//합성중간체
		A0607("B")	//완제의약품
		;
		
	
		A06_RCODE( String pValue ) {
			mValue = pValue;
		}
		private String mValue;
		public String getValue(){
			return mValue;
		}
	}

	public static final String INCOME_LEVEL_TYPE = "A211";	//입고처리 레벨유형

	

    
    /**
              D006 : 납품요청일
              Code001("7"  ) // 발주일 7일 이내      
            , Code002("15" ) // 발주일 15일 이내     
            , Code003("30" ) // 발주일 30일 이내     
            , Code004("60" ) // 발주일 60일 이내     
            , Code005("90" ) // 발주일 90일 이내     
            , Code006("ETC") // 기타             
        <br/>
     */
	public enum RdCode {
	          Code001("7"  ) // 발주일 7일 이내      
	        , Code002("15" ) // 발주일 15일 이내     
	        , Code003("30" ) // 발주일 30일 이내     
	        , Code004("60" ) // 발주일 60일 이내     
	        , Code005("90" ) // 발주일 90일 이내     
	        , Code006("ETC") // 기타             
        ;
        
        RdCode( String pValue ) {
            mValue = pValue;
        }
        private String mValue;
        public String getValue(){
            return mValue;
        }
    }
	
	public enum Inspect_Method {
        Code001("1") // 완납      
      , Code002("2") // 분납     
      , Code003("3") // 기성              
      ;
  
        Inspect_Method( String pValue ) {
        	mValue = pValue;
        }
        private String mValue;
        public String getValue(){
        	return mValue;
        }
	}

	public enum Bid_Type {
        HD("HD") // 문서별      
      , DT("DT") // 품목별            
      ;
  
        Bid_Type( String pValue ) {
        	mValue = pValue;
        }
        private String mValue;
        public String getValue(){
        	return mValue;
        }
	}
}

