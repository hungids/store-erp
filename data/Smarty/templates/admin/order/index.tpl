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
    function fnSelectCheckSubmit(action){

        var fm = document.form1;

        if (!fm["pdf_order_id[]"]) {
            return false;
        }

        var checkflag = false;
        var max = fm["pdf_order_id[]"].length;

        if (max) {
            for (var i=0; i<max; i++) {
                if(fm["pdf_order_id[]"][i].checked == true){
                    checkflag = true;
                }
            }
        } else {
            if(fm["pdf_order_id[]"].checked == true) {
                checkflag = true;
            }
        }

        if(!checkflag){
            alert('<!--{t string="tpl_A checkbox has not been selected_01"}-->');
            return false;
        }

        fnOpenPdfSettingPage(action);
    }

    function fnOpenPdfSettingPage(action){
        var fm = document.form1;
        win02("about:blank", "pdf_input", "620","650");

        // 退避
        tmpTarget = fm.target;
        tmpMode = fm.mode.value;
        tmpAction = fm.action;

        fm.target = "pdf_input";
        fm.mode.value = 'pdf';
        fm.action = action;
        fm.submit();

        // 復元
        fm.target = tmpTarget;
        fm.mode.value = tmpMode;
        fm.action = tmpAction;
    }
    
    
    function fnSelectMailCheckSubmit(action){

        var fm = document.form1;

        if (!fm["mail_order_id[]"]) {
            return false;
        }

        var checkflag = false;
        var max = fm["mail_order_id[]"].length;

        if (max) {
            for (var i=0; i<max; i++) {
                if(fm["mail_order_id[]"][i].checked == true){
                    checkflag = true;
                }
            }
        } else {
            if(fm["mail_order_id[]"].checked == true) {
                checkflag = true;
            }
        }

        if(!checkflag){
            alert('<!--{t string="tpl_A checkbox has not been selected_01"}-->');
            return false;
        }
        
        fm.mode.value="mail_select";
        fm.action=action;
        fm.submit();
    }
	
	$(function(){
		var dateFormat = $.datepicker.regional['<!--{$smarty.const.LANG_CODE}-->'].dateFormat;

        <!--{if $arrForm.search_sbirthyear.value != '' && $arrForm.search_sbirthmonth.value != '' && $arrForm.search_sbirthday.value != ''}-->
        var search_sbirthyear  = '<!--{$arrForm.search_sbirthyear.value|h}-->';
        var search_sbirthmonth = '<!--{$arrForm.search_sbirthmonth.value|h}-->';
        var search_sbirthday   = '<!--{$arrForm.search_sbirthday.value|h}-->';
        var search_sbirth_ymd = $.datepicker.formatDate(dateFormat, new Date(search_sbirthyear, search_sbirthmonth - 1, search_sbirthday));
        $("#datepickersearch_sbirth").val(search_sbirth_ymd);
        <!--{/if}-->

		$( "#datepickersearch_sbirth" ).datepicker({
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
            setDatesearch_sbirth(year + '/' + month + '/' + day);
		},
		showButtonPanel: true,
		beforeShow: showAdditionalButtonsearch_sbirth,       
		onChangeMonthYear: showAdditionalButtonsearch_sbirth
		});
		
		$("#datepickersearch_sbirth").change( function() {
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
            setDatesearch_sbirth(year + '/' + month + '/' + day);
		});

        <!--{if $arrForm.search_ebirthyear.value != '' && $arrForm.search_ebirthmonth.value != '' && $arrForm.search_ebirthday.value != ''}-->
        var search_ebirthyear  = '<!--{$arrForm.search_ebirthyear.value|h}-->';
        var search_ebirthmonth = '<!--{$arrForm.search_ebirthmonth.value|h}-->';
        var search_ebirthday   = '<!--{$arrForm.search_ebirthday.value|h}-->';
        var search_ebirth_ymd = $.datepicker.formatDate(dateFormat, new Date(search_ebirthyear, search_ebirthmonth - 1, search_ebirthday));
        $("#datepickersearch_ebirth").val(search_ebirth_ymd);
        <!--{/if}-->

		$( "#datepickersearch_ebirth" ).datepicker({
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
            setDatesearch_ebirth(year + '/' + month + '/' + day);
		},
		showButtonPanel: true,
		beforeShow: showAdditionalButtonsearch_ebirth,       
		onChangeMonthYear: showAdditionalButtonsearch_ebirth
		});
		
		$("#datepickersearch_ebirth").change( function() {
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
            setDatesearch_ebirth(year + '/' + month + '/' + day);
		});
		
        <!--{if $arrForm.search_sorderyear.value != '' && $arrForm.search_sordermonth.value != '' && $arrForm.search_sorderday.value != ''}-->
        var search_sorderyear  = '<!--{$arrForm.search_sorderyear.value|h}-->';
        var search_sordermonth = '<!--{$arrForm.search_sordermonth.value|h}-->';
        var search_sorderday   = '<!--{$arrForm.search_sorderday.value|h}-->';
        var search_sorder_ymd = $.datepicker.formatDate(dateFormat, new Date(search_sorderyear, search_sordermonth - 1, search_sorderday));
        $("#datepickersearch_sorder").val(search_sorder_ymd);
        <!--{/if}-->
        
		$( "#datepickersearch_sorder" ).datepicker({
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
            setDatesearch_sorder(year + '/' + month + '/' + day);
		},
		showButtonPanel: true,
		beforeShow: showAdditionalButtonsearch_sorder,       
		onChangeMonthYear: showAdditionalButtonsearch_sorder
		});
		
		$("#datepickersearch_sorder").change( function() {
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
            setDatesearch_sorder(year + '/' + month + '/' + day);
		});

        <!--{if $arrForm.search_eorderyear.value != '' && $arrForm.search_eordermonth.value != '' && $arrForm.search_eorderday.value != ''}-->
        var search_eorderyear  = '<!--{$arrForm.search_eorderyear.value|h}-->';
        var search_eordermonth = '<!--{$arrForm.search_eordermonth.value|h}-->';
        var search_eorderday   = '<!--{$arrForm.search_eorderday.value|h}-->';
        var search_eorder_ymd = $.datepicker.formatDate(dateFormat, new Date(search_eorderyear, search_eordermonth - 1, search_eorderday));
        $("#datepickersearch_eorder").val(search_eorder_ymd);
        <!--{/if}-->
        
		$( "#datepickersearch_eorder" ).datepicker({
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
            setDatesearch_eorder(year + '/' + month + '/' + day);
		},
		showButtonPanel: true,
		beforeShow: showAdditionalButtonsearch_eorder,       
		onChangeMonthYear: showAdditionalButtonsearch_eorder
		});
		
		$("#datepickersearch_eorder").change( function() {
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
            setDatesearch_eorder(year + '/' + month + '/' + day);
		});
		
        <!--{if $arrForm.search_supdateyear.value != '' && $arrForm.search_supdatemonth.value != '' && $arrForm.search_supdateday.value != ''}-->
        var search_supdateyear  = '<!--{$arrForm.search_supdateyear.value|h}-->';
        var search_supdatemonth = '<!--{$arrForm.search_supdatemonth.value|h}-->';
        var search_supdateday   = '<!--{$arrForm.search_supdateday.value|h}-->';
        var search_supdate_ymd = $.datepicker.formatDate(dateFormat, new Date(search_supdateyear, search_supdatemonth - 1, search_supdateday));
        $("#datepickersearch_supdate").val(search_supdate_ymd);
        <!--{/if}-->
		$( "#datepickersearch_supdate" ).datepicker({
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
            setDatesearch_supdate(year + '/' + month + '/' + day);
		},
		showButtonPanel: true,
		beforeShow: showAdditionalButtonsearch_supdate,       
		onChangeMonthYear: showAdditionalButtonsearch_supdate
		});
		
		$("#datepickersearch_supdate").change( function() {
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
            setDatesearch_supdate(year + '/' + month + '/' + day);
		});

        <!--{if $arrForm.search_eupdateyear.value != '' && $arrForm.search_eupdatemonth.value != '' && $arrForm.search_eupdateday.value != ''}-->
        var search_eupdateyear  = '<!--{$arrForm.search_eupdateyear.value|h}-->';
        var search_eupdatemonth = '<!--{$arrForm.search_eupdatemonth.value|h}-->';
        var search_eupdateday   = '<!--{$arrForm.search_eupdateday.value|h}-->';
        var search_eupdate_ymd = $.datepicker.formatDate(dateFormat, new Date(search_eupdateyear, search_eupdatemonth - 1, search_eupdateday));
        $("#datepickersearch_eupdate").val(search_eupdate_ymd);
        <!--{/if}-->
		$( "#datepickersearch_eupdate" ).datepicker({
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
            setDatesearch_eupdate(year + '/' + month + '/' + day);
		},
		showButtonPanel: true,
		beforeShow: showAdditionalButtonsearch_eupdate,       
		onChangeMonthYear: showAdditionalButtonsearch_eupdate
		});
		
		$("#datepickersearch_eupdate").change( function() {
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
            setDatesearch_eupdate(year + '/' + month + '/' + day);
		});
	
	});
	
	var btn = $('<button class="ui-datepicker-current ui-state-default ui-priority-secondary ui-corner-all" type="button">Clear</button>');
	
	var showAdditionalButtonsearch_sbirth = function (input) {
		setTimeout(function () {
			var buttonPane = $(input)
					 .datepicker("widget")
					 .find(".ui-datepicker-buttonpane");
			btn
					.unbind("click")
					.bind("click", function () {
						$.datepicker._clearDate(input);
						$("*[name=search_sbirthyear]").val("");
						$("*[name=search_sbirthmonth]").val("");
						$("*[name=search_sbirthday]").val("");
					});
			btn.appendTo(buttonPane);
		}, 1);
	};
	
	var showAdditionalButtonsearch_ebirth = function (input) {
		setTimeout(function () {
			var buttonPane = $(input)
					 .datepicker("widget")
					 .find(".ui-datepicker-buttonpane");
			btn
					.unbind("click")
					.bind("click", function () {
						$.datepicker._clearDate(input);
						$("*[name=search_ebirthyear]").val("");
						$("*[name=search_ebirthmonth]").val("");
						$("*[name=search_ebirthday]").val("");
					});
			btn.appendTo(buttonPane);
		}, 1);
	};
	
	var showAdditionalButtonsearch_sorder = function (input) {
		setTimeout(function () {
			var buttonPane = $(input)
					 .datepicker("widget")
					 .find(".ui-datepicker-buttonpane");
			btn
					.unbind("click")
					.bind("click", function () {
						$.datepicker._clearDate(input);
						$("*[name=search_sorderyear]").val("");
						$("*[name=search_sordermonth]").val("");
						$("*[name=search_sorderday]").val("");
					});
			btn.appendTo(buttonPane);
		}, 1);
	};
	
	var showAdditionalButtonsearch_eorder = function (input) {
		setTimeout(function () {
			var buttonPane = $(input)
					 .datepicker("widget")
					 .find(".ui-datepicker-buttonpane");
			btn
					.unbind("click")
					.bind("click", function () {
						$.datepicker._clearDate(input);
						$("*[name=search_eorderyear]").val("");
						$("*[name=search_eordermonth]").val("");
						$("*[name=search_eorderday]").val("");
					});
			btn.appendTo(buttonPane);
		}, 1);
	};
	
	var showAdditionalButtonsearch_supdate = function (input) {
		setTimeout(function () {
			var buttonPane = $(input)
					 .datepicker("widget")
					 .find(".ui-datepicker-buttonpane");
			btn
					.unbind("click")
					.bind("click", function () {
						$.datepicker._clearDate(input);
						$("*[name=search_supdateyear]").val("");
						$("*[name=search_supdatemonth]").val("");
						$("*[name=search_supdateday]").val("");
					});
			btn.appendTo(buttonPane);
		}, 1);
	};
	
	var showAdditionalButtonsearch_eupdate = function (input) {
		setTimeout(function () {
			var buttonPane = $(input)
					 .datepicker("widget")
					 .find(".ui-datepicker-buttonpane");
			btn
					.unbind("click")
					.bind("click", function () {
						$.datepicker._clearDate(input);
						$("*[name=search_eupdateyear]").val("");
						$("*[name=search_eupdatemonth]").val("");
						$("*[name=search_eupdateday]").val("");
					});
			btn.appendTo(buttonPane);
		}, 1);
	};
	
	function setDatesearch_sbirth(dateText){
	var dates = dateText.split('/');
	$("*[name=search_sbirthyear]").val(dates[0]);
	$("*[name=search_sbirthmonth]").val(dates[1]);
	$("*[name=search_sbirthday]").val(dates[2]);
	}
	
	function setDatesearch_ebirth(dateText){
	var dates = dateText.split('/');
	$("*[name=search_ebirthyear]").val(dates[0]);
	$("*[name=search_ebirthmonth]").val(dates[1]);
	$("*[name=search_ebirthday]").val(dates[2]);
	}
	
	function setDatesearch_sorder(dateText){
	var dates = dateText.split('/');
	$("*[name=search_sorderyear]").val(dates[0]);
	$("*[name=search_sordermonth]").val(dates[1]);
	$("*[name=search_sorderday]").val(dates[2]);
	}
	
	function setDatesearch_eorder(dateText){
	var dates = dateText.split('/');
	$("*[name=search_eorderyear]").val(dates[0]);
	$("*[name=search_eordermonth]").val(dates[1]);
	$("*[name=search_eorderday]").val(dates[2]);
	}
	
	function setDatesearch_supdate(dateText){
	var dates = dateText.split('/');
	$("*[name=search_supdateyear]").val(dates[0]);
	$("*[name=search_supdatemonth]").val(dates[1]);
	$("*[name=search_supdateday]").val(dates[2]);
	}
	
	function setDatesearch_eupdate(dateText){
	var dates = dateText.split('/');
	$("*[name=search_eupdateyear]").val(dates[0]);
	$("*[name=search_eupdatemonth]").val(dates[1]);
	$("*[name=search_eupdateday]").val(dates[2]);
	}
//-->
</script>
<div id="order" class="contents-main">
<form name="search_form" id="search_form" method="post" action="?">
<input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
<input type="hidden" name="mode" value="search" />
    <h2>Tìm Kiếm Vé</h2>
    <!--{* 検索条件設定テーブルここから *}-->
    <table>
        <tr>
            <th>CODE</th>
            <td>
                <!--{assign var=key1 value="search_order_code"}-->
                <span class="attention"><!--{$arrErr[$key1]}--></span>
                <input type="text" name="<!--{$key1}-->" value="<!--{$arrForm[$key1].value|h}-->" maxlength="<!--{$arrForm[$key1].length}-->" style="<!--{$arrErr[$key1]|sfGetErrorColor}-->" size="30" class="box30" />
            </td>
            <th>Tên Khách Hàng</th>
            <td>
                <!--{assign var=key value="search_order_name"}-->
                <span class="attention"><!--{$arrErr[$key]}--></span>
                <input type="text" name="<!--{$key}-->" value="<!--{$arrForm[$key].value|h}-->" maxlength="<!--{$arrForm[$key].length}-->" style="<!--{$arrErr[$key]|sfGetErrorColor}-->" size="30" class="box30" />
            </td>
        </tr>
        <tr>
            <th>Email</th>
            <td>
                <!--{assign var=key value="search_order_email"}-->
                <span class="attention"><!--{$arrErr[$key]}--></span>
                <input type="text" name="<!--{$key}-->" value="<!--{$arrForm[$key].value|h}-->" maxlength="<!--{$arrForm[$key].length}-->" style="<!--{$arrErr[$key]|sfGetErrorColor}-->" size="30" class="box30" />
            </td>
            <th>Số Điện Thoại</th>
            <td>
                <!--{assign var=key value="search_order_tel"}-->
                <span class="attention"><!--{$arrErr[$key]}--></span>
                <input type="text" name="<!--{$key}-->" value="<!--{$arrForm[$key].value|h}-->" maxlength="<!--{$arrForm[$key].length}-->" style="<!--{$arrErr[$key]|sfGetErrorColor}-->" size="30" class="box30" />
            </td>
        </tr>
        <tr>
            <th>Trạng Thái Vé</th>
            <td colspan="3">
                <!--{assign var=key value="search_order_status"}-->
                <span class="attention"><!--{$arrErr[$key]}--></span>
                <!--{html_checkboxes name="$key" options=$arrORDERSTATUS selected=$arrForm[$key].value}-->
            </td>
        </tr>
        <tr>
            <th>NV Đặt</th>
            <td colspan="3">
                <!--{assign var=key value="search_order_member"}-->
                <span class="attention"><!--{$arrErr[$key]}--></span>
                <!--{html_checkboxes name="$key" options=$arrMembers selected=$arrForm[$key].value}-->
            </td>
        </tr>
        <tr>
            <th>Ngày Bay</th>
            <td colspan="3">
            <!--{if $arrErr.search_sbirthyear || $arrErr.search_ebirthyear}-->
                <span class="attention"><!--{$arrErr.search_sbirthyear}--></span>
                <span class="attention"><!--{$arrErr.search_ebirthyear}--></span>
            <!--{/if}-->
                <input id="datepickersearch_sbirth" type="text" value="" <!--{if $arrErr.search_sbirthyear != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> />
                <input type="hidden" name="search_sbirthyear" value="<!--{$arrForm.search_sbirthyear.value|h}-->" />
                <input type="hidden" name="search_sbirthmonth" value="<!--{$arrForm.search_sbirthmonth.value|h}-->" />
                <input type="hidden" name="search_sbirthday" value="<!--{$arrForm.search_sbirthday.value|h}-->" />
            <!--{t string="-"}-->
                <input id="datepickersearch_ebirth" type="text" value="" <!--{if $arrErr.search_ebirthyear != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> />
                <input type="hidden" name="search_ebirthyear" value="<!--{$arrForm.search_ebirthyear.value|h}-->" />
                <input type="hidden" name="search_ebirthmonth" value="<!--{$arrForm.search_ebirthmonth.value|h}-->" />
                <input type="hidden" name="search_ebirthday" value="<!--{$arrForm.search_ebirthday.value|h}-->" />
            </td>
        </tr>
        <tr>
            <th>Giờ Bay</th>
            <td colspan="3">
                <!--{assign var=key1 value="search_shour"}-->
                <!--{assign var=key2 value="search_sminute"}-->
                <!--{assign var=key3 value="search_ehour"}-->
                <!--{assign var=key4 value="search_eminute"}-->
                <!--{if $arrErr.search_shour || $arrErr.search_ehour}-->
                    <span class="attention"><!--{$arrErr.search_shour}--></span>
                    <span class="attention"><!--{$arrErr.search_ehour}--></span>
                <!--{/if}-->
                <select name="<!--{$key1}-->" style="<!--{$arrErr[$key]|sfGetErrorColor}-->">
                    <option value="">Chọn</option>
                    <!--{html_options options=$arrHour selected=$arrForm[$key1].value}-->
                </select>
                <span>Giờ</span>
                <select name="<!--{$key2}-->" style="<!--{$arrErr[$key]|sfGetErrorColor}-->">
                    <option value="">Chọn</option>
                    <!--{html_options options=$arrMinutes selected=$arrForm[$key2].value}-->
                </select>
                <span>Phút</span>
                [--- Đến ---]
                <select name="<!--{$key3}-->" style="<!--{$arrErr[$key]|sfGetErrorColor}-->">
                    <option value="">Chọn</option>
                    <!--{html_options options=$arrHour selected=$arrForm[$key3].value}-->
                </select>
                <span>Giờ</span>
                <select name="<!--{$key4}-->" style="<!--{$arrErr[$key]|sfGetErrorColor}-->">
                    <option value="">Chọn</option>
                    <!--{html_options options=$arrMinutes selected=$arrForm[$key4].value}-->
                </select>
                <span>Phút</span>
            </td>
        </tr>
        <tr>
            <th>Nợ</th>
            <td colspan="3">
                <!--{assign var=key value="search_order_debt"}-->
                <span class="attention"><!--{$arrErr[$key]}--></span>
                <!--{html_radios name="$key" options=$arrDebtStatus selected=$arrForm[$key].value separator=' '}-->
            </td>
        </tr>
        <tr>
            <th>Trạng Thái Thanh Toán</th>
            <td colspan="3">
                <!--{assign var=key value="search_payments_status"}-->
                <span class="attention"><!--{$arrErr[$key]|h}--></span>
                <!--{html_checkboxes name="$key" options=$arrPaymentStatus selected=$arrForm[$key].value}-->
            </td>
        </tr>
    </table>

    <div class="btn">
        <p class="page_rows"><!--{t string="tpl_Results displayed_01"}-->
            <!--{assign var=key value="search_page_max"}-->
            <span class="attention"><!--{$arrErr[$key]}--></span>
            <!--{t string="record_prefix"}-->
            <select name="<!--{$arrForm[$key].keyname}-->" style="<!--{$arrErr[$key]|sfGetErrorColor}-->">
            <!--{html_options options=$arrPageMax selected=$arrForm[$key].value}-->
            </select> 
            <!--{t string="record_suffix"}-->
        </p>
        <div class="btn-area">
            <ul>
                <li><a class="btn-action" href="javascript:;" onclick="fnFormModeSubmit('search_form', 'search', '', ''); return false;"><span class="btn-next">Tìm Kiếm</span></a></li>
            </ul>
        </div>
    </div>
    <!--検索条件設定テーブルここまで-->
</form>

<!--{if count($arrErr) == 0 and ($smarty.post.mode == 'search' or $smarty.post.mode == 'delete')}-->

<!--★★検索結果一覧★★-->
<form name="form1" id="form1" method="post" action="?">
<input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
<input type="hidden" name="mode" value="search" />
<input type="hidden" name="order_id" value="" />
<!--{foreach key=key item=item from=$arrHidden}-->
    <!--{if is_array($item)}-->
        <!--{foreach item=c_item from=$item}-->
        <input type="hidden" name="<!--{$key|h}-->[]" value="<!--{$c_item|h}-->" />
        <!--{/foreach}-->
    <!--{else}-->
        <input type="hidden" name="<!--{$key|h}-->" value="<!--{$item|h}-->" />
    <!--{/if}-->
<!--{/foreach}-->
    <h2>Danh Sách Kết Quả</h2>
        <div class="btn">
        <!--検索結果数--><!--{t string="tpl_<span class='attention'>T_ARG1 items</span>&nbsp; were found._01" escape="none" T_ARG1=$tpl_linemax}-->
        <!--{if $smarty.const.ADMIN_MODE == '1'}-->
        <a class="btn-normal" href="javascript:;" onclick="fnModeSubmit('delete_all','',''); return false;"><span><!--{t string="tpl_Delete all search results_01"}--></span></a>
        <!--{/if}-->
        <a class="btn-normal" href="javascript:;" onclick="fnModeSubmit('csv','',''); return false;"><!--{t string="tpl_CSV download_01"}--></a>
        <a class="btn-normal" href="../contents/csv.php?tpl_subno_csv=order"><!--{t string="tpl_CSV output settings_01"}--></a>
        <a class="btn-normal" href="javascript:;" onclick="fnSelectCheckSubmit('pdf.php'); return false;"><span><!--{t string="tpl_PDF batch output_01"}--></span></a>
        <a class="btn-normal" href="javascript:;" onclick="fnSelectMailCheckSubmit('mail.php'); return false;"><span><!--{t string="tpl_Batch e-mail notification_01"}--></span></a>
    </div>
    <!--{if count($arrResults) > 0}-->

    <!--{include file=$tpl_pager}-->

    <!--{* 検索結果表示テーブル *}-->
        <table class="list">
        <col width="10%" />
        <col width="8%" />
        <col width="15%" />
        <col width="15%" />
        <col width="10%" />
        <col width="10%" />
        <col width="10%" />
        <col width="10%" />
        <col width="5%" />
        <col width="5%" />
        <!--{* ペイジェントモジュール連携用 *}-->
        <!--{assign var=path value=`$smarty.const.MODULE_REALDIR`mdl_paygent/paygent_order_index.tpl}-->
        <!--{if file_exists($path)}-->
            <!--{include file=$path}-->
        <!--{else}-->
        <tr>
            <th>Ngày tạo</th>
            <th>CODE</th>
            <th>Khách Hàng</th>
            <th>Hành Trình</th>
            <th>Giờ Bay</th>
            <th>NV Đặt</th>
            <th>Trạng Thái</th>
            <th>Số Điện Thoại</th>
            <th>Sửa</th>
            <th>Xóa</th>
        </tr>

        <!--{section name=cnt loop=$arrResults}-->
        <!--{assign var=status value="`$arrResults[cnt].status`"}-->
        <tr style="background:<!--{$arrORDERSTATUS_COLOR[$status]}-->;">
            <td class="center"><!--{$arrResults[cnt].create_date|sfDispDBDate}--></td>
            <td class="center"><!--{$arrResults[cnt].order_code}--></td>
            <td><!--{$arrResults[cnt].order_name01|h}--> <!--{$arrResults[cnt].order_name02|h}--></td>
            <td><!--{$arrResults[cnt].order_dept|h}--> - <!--{$arrResults[cnt].order_arriv|h}--></td>
            <td class="center">
                <span><!--{$arrResults[cnt].start_date|sfDispDBDate:false}--></span>
                <span><!--{$arrResults[cnt].start_time}--></span>
            </td>
            <!--{assign var=member value="`$arrResults[cnt].creator_id`"}-->
            <td><!--{$arrMembers[$member]}--></td>
            <td><!--{$arrORDERSTATUS[$status]}--></td>
            <td class="center"><!--{$arrResults[cnt].order_tel}--></td>
            <td class="center"><a href="?" onclick="fnChangeAction('<!--{$smarty.const.ADMIN_ORDER_EDIT_URLPATH}-->'); fnModeSubmit('pre_edit', 'order_id', '<!--{$arrResults[cnt].order_id}-->'); return false;"><span class="icon_edit">Sửa</span></a></td>
            <td class="center"><a href="?" onclick="fnModeSubmit('delete_order', 'order_id', <!--{$arrResults[cnt].order_id}-->); return false;"><span class="icon_delete">Xóa</span></a></td>
        </tr>
        <!--{/section}-->
        <!--{/if}-->
    </table>
    <!--{* 検索結果表示テーブル *}-->

    <!--{/if}-->

</form>
<!--{/if}-->
</div>
