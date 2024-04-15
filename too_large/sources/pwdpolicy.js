var pwdTemp = new Array( '12345678', 'abcdefgh' );

// 비밀번호는 영문,숫자,특수문자가 포함된 8자리 이상의 조합으로 한다.
// (2010-07-13 보안정책에 의한 변경)

// 암호화 정책에 의하여... 암화 정상여부 체크
function isNewValidPwd( str_id, str_pwd )
{
	var cnt=0;
	if ( str_pwd=="" )
	{
		alert("비밀번호를 입력하세요.");
		return false;
	} else if ( !isNoSpace(str_pwd) ) {
		alert("비밀번호에는 공백을 사용할 수 없습니다.");
		return false;
	}

	for( var i=0; i<str_pwd.length; ++i)
	{
		if( str_pwd.charAt(0) == str_pwd.substring( i, i+1 ) ) ++cnt;
	}

	if ( cnt == str_pwd.length )
	{
		// 동일문자 사용금지....
		alert("보안상의 이유로 한 문자로 연속된 비밀번호는 허용하지 않습니다.");
		return false;
	}


	// 영문, 숫자, 특수문자가 아닌 것은 사용 할 수 없음.:8~10자리 채워서
	var isPW = /^[A-Za-z0-9`\-=\\\[\];,\./~!@#\$%\^&\*\(\)_\+|\{\}:"<>\?]{8,10}$/;
	

	if( !isPW.test(str_pwd) )
	{
		alert("비밀번호는 8~10자의 영문 대소문자와 숫자, 특수문자를 사용할 수 있습니다.");
		return false;
	}

	var nPassLen = str_pwd.length
	var nPassFlag01 = false;
	var nPassFlag02 = false;
	var nPassFlag03 = false;

	var isPW = /^[A-Za-z]{1,1}$/;
	// 영문자 사용했는지...
	nPassFlag01 = isStringExist(isPW, str_pwd);

	var isPW = /^[0-9]{1,1}$/;
	// 숫자 사용했는지...
	nPassFlag02 = isStringExist(isPW, str_pwd);

	var isPW = /^[`\-=\\\[\];,\./~!@#\$%\^&\*\(\)_\+|\{\}:"<>\?]{1,1}$/;
	// 특수문자 사용했는지...
	nPassFlag03 = isStringExist(isPW, str_pwd);


	if (nPassFlag01 == true && nPassFlag02 == true && nPassFlag03 == true )
	{
		// 	isPW 에서 최소 8자리는 이미 체크 했으므로 통과	
	}
	else
	{
		if (    ( nPassFlag01 == true &&  (nPassFlag02 == true || nPassFlag03 == true)  )
		     || ( nPassFlag02 == true &&  (nPassFlag01 == true || nPassFlag03 == true)  )
		     || ( nPassFlag03 == true &&  (nPassFlag01 == true || nPassFlag02 == true)  )
		   )
		{
			if ( nPassLen < 10 )
			{
				alert("패스워드는 영문 대소문자, 숫자, 특수문자중\n2가지 조합일경우 10자리\n3가지 조합일경우 8자리 이상으로 구성하셔야 합니다.");
				return false;
			}
		}
	}

	/*
	if( nPassFlag01 == false || nPassFlag02 == false || nPassFlag03 == false )
	{
		alert("비밀번호는 8~10자의 영문 대소문자, 숫자, 특수문자로 구성하셔야 합니다.");
		return false;
	}
	*/


	// 예측문자열 : '12345678', 'abcdefgh' 사용불가
	for(var i =0; i < pwdTemp.length; i++)
	{
		if (str_pwd == pwdTemp[i])
		{  alert(pwdTemp[i] +"는 비밀번호로 사용하실수 없습니다.");
			return false;
		}       
	}

	if (str_pwd == str_id)
	{
		alert("아이디와 동일한 비밀번호를 사용하실수 없습니다. ")
		return false;
	}

	return true;
}

// 해당문자가 사용되었는지 여부
function isStringExist(isPW, strString)
{
	var retFlag = false;

	for( var i=0; i<strString.length; ++i)
	{
		if ( isPW.test(strString.charAt(i)) == true )
		{
			retFlag = true;
			break;
		}
	}
	return retFlag;
}

function isModValidPwd( str_id, str_old_pwd, str_new_pwd )
{
	var cnt=0;

	if ( str_new_pwd=="" )
	{
		alert("비밀번호를 입력하세요.");
		return false;
	} else if ( !isNoSpace(str_new_pwd) ) {
		alert("비밀번호에는 공백을 사용할 수 없습니다.");
		return false;
	}

	for( var i=0; i<str_new_pwd.length; ++i)
	{
		if( str.charAt(0) == str.substring( i, i+1 ) ) ++cnt;
	}

	if ( cnt == str_new_pwd.length )
	{
		// 동일문자 사용금지....
		alert("보안상의 이유로 한 문자로 연속된 비밀번호는 허용하지 않습니다.");
		return false;
	}

	var isPW = /^[A-Za-z0-9`\-=\\\[\];',\./~!@#\$%\^&\*\(\)_\+|\{\}:"<>\?]{6,10}$/;
	if( !isPW.test(str_new_pwd) )
	{
		alert("비밀번호는 6~10자의 영문 대소문자와 숫자, 특수문자를 사용할 수 있습니다.");
		return false;
	}


	for(var i =0; i < pwdTemp.length; i++)
	{
		if (str_new_pwd == pwdTemp[i])
		{
			alert(pwdTemp[i] +"는 비밀번호로 사용하실수 없습니다.");
			return false;
		}
	}

	if (str_new_pwd == str_old_pwd)
	{
		alert("현재 비밀번호와 동일한 비밀번호를 사용하실수 없습니다. ")
		return false;
	}

	if (str_new_pwd == str_id)
	{
		alert("아이디와 동일한 비밀번호를 사용하실수 없습니다. ")
		return false;
	}

	return true;
}

function isNoSpace( str )
{
	if ( str.search(/\s/) == -1 )
	{
		return true;
	}
	else
	{
		return false;
	}
}