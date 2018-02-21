<!--{*
/*
 * This file is part of EC-CUBE
 *
 * Copyright(c) 2000-2012 LOCKON CO.,LTD. All Rights Reserved.
 *
 * http://www.lockon.co.jp/
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */
*}-->

<form name="form1" id="form1" method="POST" action="?" >
<input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
<input type="hidden" name="mode" value="" />
<input type="hidden" name="status" value="<!--{if $arrForm.status == ""}-->1<!--{else}--><!--{$arrForm.status}--><!--{/if}-->" />
<input type="hidden" name="search_pageno" value="<!--{$tpl_pageno}-->" >
<input type="hidden" name="order_id" value="" />
<input type="hidden" name="debt_status" value="" />
<div id="order" class="contents-main">
    <h2>Điều Kiện Trạng Thái</h2>
        <div class="btn">
        <!--{foreach key=key item=item from=$arrORDERSTATUS}-->
            <a
                class="btn-normal"
                style="padding-right: 1em;"
                <!--{if $key != $SelectedStatus}-->
                    href="javascript:;"
                    onclick="document.form1.search_pageno.value='1'; fnModeSubmit('search','status','<!--{$key}-->' ); return false;"
                <!--{/if}-->
            ><!--{$item}--></a>
        <!--{/foreach}-->
        <a class="btn-normal" style="padding-right: 1em;" href="javascript:;"
           onclick="document.form1.search_pageno.value='1'; fnModeSubmit('search','debt_status','debt_status' ); return false;"
            >VÉ CÒN NỢ</a>
        </div>
    <h2>Thay Đổi Trạng Thái</h2>
    <!--{* 登録テーブルここから *}-->
    <!--{if $tpl_linemax > 0}-->
        <div class="btn">
            <select name="change_status">
                <option value="" selected="selected" style="<!--{$Errormes|sfGetErrorColor}-->" >Vui Lòng Chọn</option>
                <!--{foreach key=key item=item from=$arrORDERSTATUS}-->
                <!--{if $key ne $SelectedStatus}-->
                <option value="<!--{$key}-->" ><!--{$item}--></option>
                <!--{/if}-->
                <!--{/foreach}-->
                <option value="delete">Xóa</option>
            </select>
            <a class="btn-normal" href="javascript:;" onclick="fnSelectCheckSubmit(); return false;"><span>Chuyển</span></a>
        </div>

        <p class="remark">
            <!--{t string="T_ARG1 kết quả" T_ARG1=$tpl_linemax}-->
            <!--{$tpl_strnavi}-->
        </p>

        <table class="list center">
            <col width="5%" />
            <col width="12%" />
            <col width="5%" />
            <col width="9%" />
            <col width="12%" />
            <col width="15%" />
            <col width="14%" />
            <col width="8%" />
            <col width="10%" />
            <col width="10%" />
            <tr>
                <th><label for="move_check">Chọn</label> <input type="checkbox" name="move_check" id="move_check" onclick="fnAllCheck(this, 'input[name=move[]]')" /></th>
                <th>Trạng Thái</th>
                <th>Xem</th>
                <th>CODE</th>
                <th>Ngày Tạo</th>
                <th>Tên Khách Hàng</th>
                <th>Hành Trình</th>
                <th>Giờ Bay</th>
                <th>Hạn Giữ Chỗ</th>
                <th>NV Đặt</th>
                <th>Số Điện Thoại</th>
            </tr>
            <!--{section name=cnt loop=$arrStatus}-->
            <!--{assign var=status value="`$arrStatus[cnt].status`"}-->
            <tr style="background:<!--{$arrORDERSTATUS_COLOR[$status]}-->;">
                <td><input type="checkbox" name="move[]" value="<!--{$arrStatus[cnt].order_id}-->" ></td>
                <td><!--{$arrORDERSTATUS[$status]}--></td>
                <td class="center"><a href="#" onclick="fnOpenWindow('./disp.php?order_id=<!--{$arrStatus[cnt].order_id}-->','order_disp','800','900'); return false;" ><!--{$arrStatus[cnt].order_id}--></a></td>
                <td><!--{$arrStatus[cnt].order_code}--></td>
                <td><!--{$arrStatus[cnt].create_date|sfDispDBDate}--></td>
                <td><!--{$arrStatus[cnt].order_name01|h}--> <!--{$arrStatus[cnt].order_name02|h}--></td>
                <!--{assign var=payment_id value=`$arrStatus[cnt].payment_id`}-->
                <td><!--{$arrStatus[cnt].order_dept|h}--> - <!--{$arrStatus[cnt].order_arriv|h}--></td>
                <!--{assign var=member value=`$arrStatus[cnt].creator_id`}-->
                <td class="center"><!--{$arrStatus[cnt].start_date|sfDispDBDate:false}--> <!--{$arrStatus[cnt].start_time}--></td>
                <td class="center"><!--{if $arrStatus[cnt].is_export}-->Xuất Bay Gấp<!--{else}--><!--{$arrStatus[cnt].due_date|sfDispDBDate:false}--> <!--{$arrStatus[cnt].due_time}--><!--{/if}--></td>
                <td><!--{$arrMembers[$member]}--></td>
                <td><!--{$arrStatus[cnt].order_tel}--></td>
            </tr>
            <!--{/section}-->
        </table>

        <p><!--{$tpl_strnavi}--></p>

    <!--{elseif $arrStatus != "" & $tpl_linemax == 0}-->
        <div class="message">
            <!--{t string="tpl_No applicable data exists._01"}-->
        </div>
    <!--{/if}-->

    <!--{* 登録テーブルここまで *}-->
</div>
</form>


<script type="text/javascript">
<!--
function fnSelectCheckSubmit(){
    var selectflag = 0;
    var fm = document.form1;

    if (fm.change_status.options[document.form1.change_status.selectedIndex].value == "") {
        selectflag = 1;
    }

    if (selectflag == 1) {
        alert('<!--{t string="tpl_A selection box has not been selected_01"}-->');
        return false;
    }
    var i;
    var checkflag = 0;
    var max = fm["move[]"].length;

    if (max) {
        for (i=0;i<max;i++){
            if(fm["move[]"][i].checked == true) {
                checkflag = 1;
            }
        }
    } else {
        if (fm["move[]"].checked == true) {
            checkflag = 1;
        }
    }

    if (checkflag == 0){
        alert('<!--{t string="tpl_A checkbox has not been selected_01"}-->');
        return false;
    }

    if (selectflag == 0 && checkflag == 1) {
        document.form1.mode.value = 'update';
        document.form1.submit();
    }
}
//-->
</script>
