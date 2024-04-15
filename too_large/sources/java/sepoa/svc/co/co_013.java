/**
 * ����ν�� �������� ����
 * sepoa_grid_common.jsp �� js�� ��ȯ�Ͽ� �׸��带 JS-Objectȭ�� ���
 * Ajax�� �̿��Ͽ� DB�κ��� ������ �������� ���� ����
 * 
 */
package sepoa.svc.co;

import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONObject;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaFormater;

public class CO_013 extends SepoaService {

    public CO_013(String s, SepoaInfo sepoainfo) throws SepoaServiceException {
        super(s, sepoainfo);
        setVersion("1.0.0");
    }

    public SepoaOut getGridData(Map map) {
        setFlag(true);
        setStatus(0);
        String screenId = (String)map.get("screen_id");
        
        
        try {
            
            Map<String, String> resMap = new HashMap<String, String>();

            StringBuffer sb = new StringBuffer();

            ConnectionContext ctx = super.getConnectionContext();
            ParamSql sm = new ParamSql(info.getSession("ID"), "MessageUtil", ctx);
            sm.removeAllValue();
            sb.append(" select /*+ rule */ \n ");
            sb.append("   screen_id, \n ");
            sb.append("   language, \n ");
            sb.append("   code, \n ");
            sb.append("   type, \n ");
            sb.append("   contents, \n ");
            sb.append("   add_user_id, \n ");
            sb.append("   del_flag, \n ");
            sb.append("   col_type, \n ");
            sb.append("   col_format, \n ");
            sb.append("   col_width, \n ");
            sb.append("   col_max_len, \n ");
            sb.append("   col_align,  \n ");
            sb.append("   col_visible, \n ");
            sb.append("   col_seq, \n ");
            sb.append("   col_color, \n");
            sb.append("   col_combo, \n");
            sb.append("   col_sort, \n");
            sb.append("   selected_yn \n");
            sb.append(" from slang \n ");
            sb.append(sm.addFixString(" where screen_id = ? \n "));
            sm.addStringParameter(screenId);
            sb.append(sm.addFixString("   and language = ?  \n "));
            sm.addStringParameter(info.getSession("LANGUAGE"));
            sb.append("    and " + DB_NULL_FUNCTION + "(del_flag, 'N') = 'N' \n ");
            sb.append("    and type = 'B' \n ");
            sb.append(" order by screen_id, col_seq, language, code, type ");

            String rtn = sm.doSelect(sb.toString());

            SepoaFormater sf = new SepoaFormater(rtn);

            String KRW_AMT_TYPE = "0,000";
            String USD_AMT_TYPE = "0,000.00";
            String QTY_TYPE = "0,000";
            String PRICE_TYPE = "0,000.00";
            String SMALL_AMT_TYPE = "0,000.0";

            String Mcolor = "#ffff63";
            String Ocolor = "#fdfdd4";
            String Rcolor = "#f7f7f7";
            String Scolor = "#f9f7b7";
            String Lcolor = "#fef0c5";

            String grid_header = "";
            String grid_init_widths = "";
            String grid_col_align = "";
            String grid_col_id = "";
            String grid_col_color = "";
            String grid_col_sort = "";
            String grid_col_type = "";
            String grid_combo_data = "";
            String grid_num_format = "";
            String grid_date_format = "";
            String grid_col_visible = "";
            String grid_selected = "";
            String grid_footer_msg = "\"Msg,";
            String grid_read_only_col = "";
            String grid_column_type = "";
            String grid_back_color = "";
            String grid_bk_color = "";
            int grid_read_check = 0;
            int grid_footer_cnt = 0;

            for (int depth = 0; depth < sf.getRowCount(); depth++) {
                grid_header += sf.getValue("contents", depth) + ",";
                grid_init_widths += sf.getValue("col_width", depth) + ",";
                grid_col_align += sf.getValue("col_align", depth) + ",";
                grid_col_id += sf.getValue("code", depth) + ",";
                grid_column_type = sf.getValue("col_type", depth);

                // �� ȭ�� SCREEN_ID �������� Buyer ȭ���� ��쿡�� �÷��� ReadOnly �̰�
                // Supplier ȭ���� ��쿡 edit �� ��쿡�� �Ʒ��� ���� Ŭ�������ٰ� �÷����� addElement
                // �Ͻø� �˴ϴ�.
                // ��ȯ�Ǵ� �÷�Ÿ�� ������ �Ʒ��� �����ϴ�.
                // ed -> ro(EditBox -> ReadOnlyBox),
                // edn, -> ron(NumberEditBox -> NumberReadOnlyBox),
                // dhxCalendar -> ro(CalendarBox -> ReadOnlyBox),
                // txt -> ro(TextBox -> ReadOnlyBox)
                // sepoa_grid_common.jsp ���� �÷�Ÿ���� ���� ���� �ݴϴ�.
                // ���� Vector dhtmlx_read_cols_vec ��ü�� sepoa_common.jsp���� �� ����
                // �ݴϴ�.
                // if(dhtmlx_read_cols_vec != null &&
                // dhtmlx_read_cols_vec.size() > 0) {
                // grid_read_check = 0;
                //
                // for(int ro_depth =0; ro_depth < dhtmlx_read_cols_vec.size();
                // ro_depth++)
                // {
                // grid_read_only_col =
                // (String)dhtmlx_read_cols_vec.elementAt(ro_depth);
                //
                // if(grid_read_only_col != null &&
                // grid_read_only_col.indexOf("=") > 0) {
                // if(grid_read_only_col != null &&
                // grid_read_only_col.startsWith(sf.getValue("CODE", depth))) {
                // grid_column_type =
                // grid_read_only_col.substring(grid_read_only_col.indexOf("=")
                // + 1, grid_read_only_col.length()).toLowerCase();
                // grid_read_only_col = grid_read_only_col.substring(0,
                // grid_read_only_col.indexOf("=") - 1);
                // grid_col_type += grid_column_type + ",";
                // grid_read_check++;
                // break;
                // }
                // } else {
                // if(grid_read_only_col != null &&
                // grid_read_only_col.equals(sf.getValue("CODE", depth))) {
                // if(grid_column_type.equals("edn")) {
                // grid_col_type += "ron,";
                // grid_read_check++;
                // break;
                // } else if(grid_column_type.equals("ed") ||
                // grid_column_type.equals("edtxt") ||
                // grid_column_type.equals("txt") ||
                // grid_column_type.equals("txttxt") ||
                // grid_column_type.equals("dhxCalendar")) {
                // grid_col_type += "ro,";
                // grid_read_check++;
                // break;
                // }
                // }
                // }
                // }
                //
                // if(grid_read_check == 0) {
                // grid_col_type += grid_column_type + ",";
                // }
                // } else {
                grid_col_type += grid_column_type + ",";
                // }

                // 'SL0400','M210',''
                if (grid_column_type.equals("coro") && sf.getValue("COL_COMBO", depth).length() > 0) {
                    grid_combo_data += " doRequestUsingPOST_dhtmlxGrid( " + sf.getValue("COL_COMBO", depth) + " ); \n";
                }

                if ((grid_column_type.equals("edn") || grid_column_type.equals("ron")) && sf.getValue("COL_FORMAT", depth).length() > 0) {
                    if (sf.getValue("COL_FORMAT", depth).equals("KRW_AMT_TYPE")) {
                        grid_num_format += "this.setNumberFormat(\"" + KRW_AMT_TYPE + "\", this.getColIndexById(\"" + sf.getValue("CODE", depth) + "\"));";
                    } else if (sf.getValue("COL_FORMAT", depth).equals("USD_AMT_TYPE")) {
                        grid_num_format += "this.setNumberFormat(\"" + USD_AMT_TYPE + "\", this.getColIndexById(\"" + sf.getValue("CODE", depth) + "\"));";
                    } else if (sf.getValue("COL_FORMAT", depth).equals("QTY_TYPE")) {
                        grid_num_format += "this.setNumberFormat(\"" + QTY_TYPE + "\", this.getColIndexById(\"" + sf.getValue("CODE", depth) + "\"));";
                    } else if (sf.getValue("COL_FORMAT", depth).equals("PRICE_TYPE")) {
                        grid_num_format += "this.setNumberFormat(\"" + PRICE_TYPE + "\", this.getColIndexById(\"" + sf.getValue("CODE", depth) + "\"));";
                    } else if (sf.getValue("COL_FORMAT", depth).equals("SMALL_AMT_TYPE")) {
                        grid_num_format += "this.setNumberFormat(\"" + SMALL_AMT_TYPE + "\", this.getColIndexById(\"" + sf.getValue("CODE", depth) + "\"));";
                    }
                }

                /* �ӽ� �� ���� ���� */

                // if(dhtmlx_back_cols_vec != null &&
                // dhtmlx_back_cols_vec.size() > 0) {
                // grid_read_check = 0;
                //
                // for(int co_depth =0; co_depth < dhtmlx_back_cols_vec.size();
                // co_depth++)
                // {
                // grid_back_color =
                // (String)dhtmlx_back_cols_vec.elementAt(co_depth);
                //
                // if(grid_back_color != null && grid_back_color.indexOf("=") >
                // 0) {
                // if(grid_back_color != null &&
                // grid_back_color.startsWith(sf.getValue("CODE", depth))) {
                // grid_bk_color =
                // grid_back_color.substring(grid_back_color.indexOf("=") + 1,
                // grid_back_color.length()).toUpperCase();
                // if(grid_bk_color.equals("MCOLOR")) {
                // grid_col_color += Mcolor + ",";
                // grid_read_check++;
                // } else if(grid_bk_color.equals("OCOLOR")) {
                // grid_col_color += Ocolor + ",";
                // grid_read_check++;
                // } else if(grid_bk_color.equals("RCOLOR")) {
                // grid_col_color += Rcolor + ",";
                // grid_read_check++;
                // } else if(grid_bk_color.equals("SCOLOR")) {
                // grid_col_color += Scolor + ",";
                // grid_read_check++;
                // } else if(grid_bk_color.equals("LCOLOR")) {
                // grid_col_color += Lcolor + ",";
                // grid_read_check++;
                // } else {
                // grid_col_color += grid_bk_color + ",";
                // grid_read_check++;
                // }
                // break;
                // }
                // }
                // }
                //
                // if(grid_read_check == 0) {
                // if(sf.getValue("COL_COLOR", depth).length() > 0)
                // {
                // if(sf.getValue("COL_COLOR", depth).equals("Mcolor")) {
                // grid_col_color += Mcolor + ",";
                // } else if(sf.getValue("COL_COLOR", depth).equals("Ocolor")) {
                // grid_col_color += Ocolor + ",";
                // } else if(sf.getValue("COL_COLOR", depth).equals("Rcolor")) {
                // grid_col_color += Rcolor + ",";
                // } else if(sf.getValue("COL_COLOR", depth).equals("Scolor")) {
                // grid_col_color += Scolor + ",";
                // } else if(sf.getValue("COL_COLOR", depth).equals("Lcolor")) {
                // grid_col_color += Lcolor + ",";
                // }
                // }
                // }
                // } else {
                if (sf.getValue("COL_COLOR", depth).length() > 0) {
                    if (sf.getValue("COL_COLOR", depth).equals("Mcolor")) {
                        grid_col_color += Mcolor + ",";
                    } else if (sf.getValue("COL_COLOR", depth).equals("Ocolor")) {
                        grid_col_color += Ocolor + ",";
                    } else if (sf.getValue("COL_COLOR", depth).equals("Rcolor")) {
                        grid_col_color += Rcolor + ",";
                    } else if (sf.getValue("COL_COLOR", depth).equals("Scolor")) {
                        grid_col_color += Scolor + ",";
                    } else if (sf.getValue("COL_COLOR", depth).equals("Lcolor")) {
                        grid_col_color += Lcolor + ",";
                    }
                }
                // }

                if (grid_column_type.equals("edn") || grid_column_type.equals("ron")) {
                    grid_col_sort += "int,";
                } else {
                    if (grid_column_type.equals("ch")) {
                        grid_col_sort += "na,";
                    } else if (sf.getValue("COL_SORT", depth).trim().length() > 0) {
                        grid_col_sort += sf.getValue("COL_SORT", depth) + ",";
                    } else {
                        grid_col_sort += "str,";
                    }
                }

                if (grid_column_type.equals("dhxCalendar") && sf.getValue("COL_FORMAT", depth).length() > 0 && grid_date_format.length() == 0) {
                    grid_date_format = "this.setDateFormat(\"" + sf.getValue("COL_FORMAT", depth) + "\");";
                }

                if (sf.getValue("COL_VISIBLE", depth).length() > 0 && sf.getValue("COL_VISIBLE", depth).equals("false")) {
                    grid_col_visible += "this.setColumnHidden(this.getColIndexById(\"" + sf.getValue("CODE", depth) + "\")" + ", true);";
                }

                if (sf.getValue("SELECTED_YN", depth).equals("Y") && grid_selected.length() == 0) {
                    grid_selected = sf.getValue("CODE", depth);
                }

                grid_footer_cnt++;

                if (grid_footer_cnt == 1)
                    grid_footer_msg += "<div id='message'></div>";
                else if (grid_footer_cnt >= 2)
                    grid_footer_msg += ",#cspan";

                
            }

            if (grid_header.length() > 0)
                grid_header = grid_header.substring(0, grid_header.length() - 1);
            if (grid_init_widths.length() > 0)
                grid_init_widths = grid_init_widths.substring(0, grid_init_widths.length() - 1);
            if (grid_col_align.length() > 0)
                grid_col_align = grid_col_align.substring(0, grid_col_align.length() - 1);
            if (grid_col_id.length() > 0)
                grid_col_id = grid_col_id.substring(0, grid_col_id.length() - 1);
            if (grid_col_color.length() > 0)
                grid_col_color = grid_col_color.substring(0, grid_col_color.length() - 1);
            if (grid_col_sort.length() > 0)
                grid_col_sort = grid_col_sort.substring(0, grid_col_sort.length() - 1);
            if (grid_col_type.length() > 0)
                grid_col_type = grid_col_type.substring(0, grid_col_type.length() - 1);
            if (grid_footer_msg.indexOf("cspan") > 0)
                grid_footer_msg += "\" ";
            
            resMap.put("grid_header", grid_header);
            resMap.put("grid_init_widths", grid_init_widths);
            resMap.put("grid_col_align", grid_col_align);
            resMap.put("grid_col_id", grid_col_id);
            resMap.put("grid_col_color", grid_col_color);
            resMap.put("grid_col_sort", grid_col_sort);
            resMap.put("grid_col_type", grid_col_type);
            resMap.put("grid_footer_msg", grid_footer_msg);
            
            setValue(JSONObject.toJSONString(resMap));
        } catch (Exception e) {
            setFlag(false);
            
        }
        return getSepoaOut();
    }

}
