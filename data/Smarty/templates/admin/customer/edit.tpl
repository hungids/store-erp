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

<script type="text/javascript">
<!--
    function fnReturn() {
        document.search_form.action = './<!--{$smarty.const.DIR_INDEX_PATH}-->';
        document.search_form.submit();
        return false;
    }
	
	$(function(){
        var dateFormat = $.datepicker.regional['<!--{$smarty.const.LANG_CODE}-->'].dateFormat;

        <!--{if $arrForm.year != '' && $arrForm.month != '' && $arrForm.day != ''}-->
        var year  = '<!--{$arrForm.year|h}-->';
        var month = '<!--{$arrForm.month|h}-->';
        var day   = '<!--{$arrForm.day|h}-->';
        var ymd = $.datepicker.formatDate(dateFormat, new Date(year, month - 1, day));
        $("#datepickercustomer_edit").val(ymd);
        // console.log(ymd);
        <!--{/if}-->

		$( "#datepickercustomer_edit" ).datepicker({
		beforeShowDay: function(date) {
			if(date.getDay() == 0) {
				return [true,"date-sunday"]; 
			} else if(date.getDay() == 6){
				return [true,"date-saturday"];
			} else {
				return [true];
			}
		},changeMonth: 'true'
		,changeYear: 'true'
		,onSelect: function(dateText, inst){
            var year  = inst.selectedYear;
            var month = inst.selectedMonth + 1;
            var day   = inst.selectedDay;
			setDatecustomer_edit(year + '/' + month + '/' + day);
		},
		showButtonPanel: true,
		beforeShow: showAdditionalButtoncustomer_edit,       
		onChangeMonthYear: showAdditionalButtoncustomer_edit
		});
		
		$("#datepickercustomer_edit").change( function() {
            var dateText   = $(this).val();
            var dateFormat = $.datepicker.regional['<!--{$smarty.const.LANG_CODE}-->'].dateFormat;
            // console.log(dateText);
            // console.log(dateFormat);
            var date;
            var year  = '';
            var month = '';
            var day   = '';
            try {
                date = $.datepicker.parseDate(dateFormat, dateText);
                year  = date.getFullYear();
                month = date.getMonth() + 1;
                day   = date.getDate();
            } catch (e) {
                // console.log(e);
                // clear date text
                $(this).val('');
            }
            setDatecustomer_edit(year + '/' + month + '/' + day);
		});
		
	});
	
	var btn = $('<button class="ui-datepicker-current ui-state-default ui-priority-secondary ui-corner-all" type="button">Clear</button>');
	
	var showAdditionalButtoncustomer_edit = function (input) {
		setTimeout(function () {
			var buttonPane = $(input)
					 .datepicker("widget")
					 .find(".ui-datepicker-buttonpane");
			btn
					.unbind("click")
					.bind("click", function () {
						$.datepicker._clearDate(input);
						$("*[name=year]").val("");
						$("*[name=month]").val("");
						$("*[name=day]").val("");
					});
			btn.appendTo(buttonPane);
		}, 1);
	};
	
	function setDatecustomer_edit(dateText){
	var dates = dateText.split('/');
	$("*[name=year]").val(dates[0]);
	$("*[name=month]").val(dates[1]);
	$("*[name=day]").val(dates[2]);
	}
//-->
</script>

<form name="search_form" method="post" action="">
    <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
    <input type="hidden" name="mode" value="search" />

    <!--{foreach from=$arrSearchData key="key" item="item"}-->
        <!--{if $key ne "customer_id" && $key ne "mode" && $key ne "edit_customer_id" && $key ne $smarty.const.TRANSACTION_ID_NAME}-->
            <!--{if is_array($item)}-->
                <!--{foreach item=c_item from=$item}-->
                    <input type="hidden" name="<!--{$key|h}-->[]" value="<!--{$c_item|h}-->" />
                <!--{/foreach}-->
            <!--{else}-->
                <input type="hidden" name="<!--{$key|h}-->" value="<!--{$item|h}-->" />
            <!--{/if}-->
        <!--{/if}-->
    <!--{/foreach}-->
</form>

<form name="form1" id="form1" method="post" action="?" autocomplete="off">
    <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
    <input type="hidden" name="mode" value="confirm" />
    <input type="hidden" name="customer_id" value="<!--{$arrForm.customer_id|h}-->" />

    <!-- 検索条件の保持 -->
    <!--{foreach from=$arrSearchData key="key" item="item"}-->
        <!--{if $key ne "customer_id" && $key ne "mode" && $key ne "edit_customer_id" && $key ne $smarty.const.TRANSACTION_ID_NAME}-->
            <!--{if is_array($item)}-->
                <!--{foreach item=c_item from=$item}-->
                    <input type="hidden" name="search_data[<!--{$key|h}-->][]" value="<!--{$c_item|h}-->" />
                <!--{/foreach}-->
            <!--{else}-->
                <input type="hidden" name="search_data[<!--{$key|h}-->]" value="<!--{$item|h}-->" />
            <!--{/if}-->
        <!--{/if}-->
    <!--{/foreach}-->

    <div id="customer" class="contents-main">
        <table class="form">
            <!--{if $arrForm.customer_id}-->
            <tr>
                <th>Mã khách hàng</th>
                <td><!--{$arrForm.customer_id|h}--></td>
            </tr>
            <!--{/if}-->
            <tr>
                <th>Họ và Tên</th>
                <td>
                    <span class="attention"><!--{$arrErr.name01}--><!--{$arrErr.name02}--></span>
                    <input type="text" name="name01" value="<!--{$arrForm.name01|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" size="30" class="box30" <!--{if $arrErr.name01 != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> />&nbsp;&nbsp;<input type="text" name="name02" value="<!--{$arrForm.name02|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" size="30" class="box30" <!--{if $arrErr.name02 != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> />
                </td>
            </tr>
            <tr>
                <th>Địa chỉ</th>
                <td>
                    <span class="attention"><!--{$arrErr.addr01}--><!--{$arrErr.addr02}--></span>
                    <input type="text" name="addr01" value="<!--{$arrForm.addr01|h}-->" size="60" class="box60" <!--{if $arrErr.addr01 != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> /><br />
                    <input type="text" name="addr02" value="<!--{$arrForm.addr02|h}-->" size="60" class="box60" <!--{if $arrErr.addr02 != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> /><br />
                </td>
            </tr>
            <tr>
                <th>Email</th>
                <td>
                    <span class="attention"><!--{$arrErr.email}--></span>
                    <input type="text" name="email" value="<!--{$arrForm.email|h}-->" size="60" class="box60" <!--{if $arrErr.email != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> />
                </td>
            </tr>
            <tr>
                <th>Số điện thoại</th>
                <td>
                    <span class="attention"><!--{$arrErr.tel}--></span>
                    <input type="text" name="tel" value="<!--{$arrForm.tel|h}-->" size="60" class="box60" <!--{if $arrErr.tel != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> /> (Nhập cách nhau bởi dấu phẩy )
                </td>
            </tr>
            <tr>
                <th>Ghi chú</th>
                <td>
                    <span class="attention"><!--{$arrErr.note}--></span>
                    <textarea name="note" maxlength="<!--{$smarty.const.LTEXT_LEN}-->" <!--{if $arrErr.note != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> cols="60" rows="8" class="area60"><!--{"\n"}--><!--{$arrForm.note|h}--></textarea>
                </td>
            </tr>
        </table>

        <div class="btn-area">
            <ul>
                <li><a class="btn-action" href="javascript:;" onclick="return fnReturn();"><span class="btn-prev"><!--{t string="tpl_Return to search screen_01"}--></span></a></li>
                <li><a class="btn-action" href="javascript:;" onclick="fnSetFormSubmit('form1', 'mode', 'confirm'); return false;"><span class="btn-next"><!--{t string="tpl_Confirmation page_01"}--></span></a></li>
            </ul>
        </div>

        <input type="hidden" name="order_id" value="" />
        <input type="hidden" name="search_pageno" value="<!--{$tpl_pageno}-->">
        <input type="hidden" name="edit_customer_id" value="<!--{$edit_customer_id}-->" >

        <h2><!--{t string="tpl_Purchase history list_01"}--></h2>
        <!--{if $tpl_linemax > 0}-->
        <p><!--購入履歴一覧--><!--{t string="tpl_<span class='attention'>T_ARG1 items</span>&nbsp; were found._01" escape="none" T_ARG1=$tpl_linemax}--></p>

        <!--{include file=$tpl_pager}-->

            <!--{* 購入履歴一覧表示テーブル *}-->
            <table class="list">
                <tr>
                    <th><!--{t string="tpl_Date_01"}--></th>
                    <th><!--{t string="tpl_Order number_01"}--></th>
                    <th><!--{t string="tpl_Purchase amount_01"}--></th>
                    <th><!--{t string="tpl_Shipment date_01"}--></th>
                    <th><!--{t string="tpl_Payment method_01"}--></th>
                </tr>
                <!--{section name=cnt loop=$arrPurchaseHistory}-->
                    <tr>
                        <td><!--{$arrPurchaseHistory[cnt].create_date|sfDispDBDate}--></td>
                        <td class="center"><a href="../order/edit.php?order_id=<!--{$arrPurchaseHistory[cnt].order_id}-->" ><!--{$arrPurchaseHistory[cnt].order_id}--></a></td>
                        <td class="center"><!--{t string="tpl_&#36; T_ARG1_01" escape="none" T_ARG1=$arrPurchaseHistory[cnt].payment_total|number_format}--></td>
                        <td class="center"><!--{if $arrPurchaseHistory[cnt].status eq 5}--><!--{$arrPurchaseHistory[cnt].commit_date|sfDispDBDate}--><!--{else}--><!--{t string="tpl_Not shipped_01"}--><!--{/if}--></td>
                        <td class="center"><!--{$arrPurchaseHistory[cnt].payment_method|h}--></td>
                    </tr>
                <!--{/section}-->
            </table>
            <!--{* 購入履歴一覧表示テーブル *}-->
        <!--{else}-->
            <div class="message"><!--{t string="tpl_There is no purchase history_01"}--></div>
        <!--{/if}-->

    </div>
</form>
