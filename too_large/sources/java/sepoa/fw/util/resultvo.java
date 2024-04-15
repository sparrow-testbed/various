package sepoa.fw.util;

import java.util.ArrayList;

public class ResultVo {
    public int count;
    public int status;
    public String message;
    public String[] result;
    public boolean flag;
    public ArrayList array;
	public ArrayList getArray() {
		return array;
	}
	public void setArray(ArrayList array) {
		this.array = array;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	public boolean isFlag() {
		return flag;
	}
	public void setFlag(boolean flag) {
		this.flag = flag;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String[] getResult() {
		return result;
	}
	public void setResult(String[] result) {
		this.result = result;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
    
}
