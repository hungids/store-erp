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
    function fnEdit(customer_id) {
        document.form1.action = '<!--{$smarty.const.ROOT_URLPATH}--><!--{$smarty.const.ADMIN_DIR}-->customer/edit.php';
        document.form1.mode.value = "edit"
        document.form1['customer_id'].value = customer_id;
        document.form1.submit();
        return false;
    }

    function fnCopyFromOrderData() {
        df = document.form1;
        
        // お届け先名のinputタグのnameを取得
        var shipping_data = $('input[name^=shipping_name01]').attr('name'); 
        var shipping_slt  = shipping_data.split("shipping_name01");
        
        var shipping_key = "[0]";
        if(shipping_slt.length > 1) {
            shipping_key = shipping_slt[1];
        }
        
        df['shipping_name01'+shipping_key].value = df.order_name01.value;
        df['shipping_name02'+shipping_key].value = df.order_name02.value;
//        df['shipping_zip01[0]'].value = df.order_zip01.value;
//        df['shipping_zip02[0]'].value = df.order_zip02.value;
        df['shipping_zipcode'+shipping_key].value = df.order_zipcode.value;
        df['shipping_tel01'+shipping_key].value = df.order_tel01.value;
        df['shipping_tel02'+shipping_key].value = df.order_tel02.value;
        df['shipping_tel03'+shipping_key].value = df.order_tel03.value;
        df['shipping_fax01'+shipping_key].value = df.order_fax01.value;
        df['shipping_fax02'+shipping_key].value = df.order_fax02.value;
        df['shipping_fax03'+shipping_key].value = df.order_fax03.value;
        df['shipping_addr01'+shipping_key].value = df.order_addr01.value;
        df['shipping_addr02'+shipping_key].value = df.order_addr02.value;
    }

    function fnFormConfirm() {
        if (fnConfirm()) {
            document.form1.submit();
        }
    }

    function fnMultiple() {
        win03('<!--{$smarty.const.ROOT_URLPATH}--><!--{$smarty.const.ADMIN_DIR}-->order/multiple.php', 'multiple', '600', '500');
        document.form1.anchor_key.value = "shipping";
        document.form1.mode.value = "multiple";
        document.form1.submit();
        return false;
    }

    function fnAppendShipping() {
        document.form1.anchor_key.value = "shipping";
        document.form1.mode.value = "append_shipping";
        document.form1.submit();
        return false;
    }

    function fnCheckIsExport(icolor) {
        if(document.form1['is_export']) {
            list = new Array(
                'due_date',
                'due_date_hour',
                'due_date_min'
                );
            if(document.form1['is_export'].checked) {
                fnChangeDisabled(list, icolor);
                document.form1['due_date'].value = "";
                document.form1['due_date_hour'].value = 0;
                document.form1['due_date_min'].value = 0;
            } else {
                fnChangeDisabled(list, '');
            }
        }
    }

    $(function(){
        var dateFormat = $.datepicker.regional['<!--{$smarty.const.LANG_CODE}-->'].dateFormat;
        <!--{if $arrForm.year.value != '' && $arrForm.month.value != '' && $arrForm.day.value != ''}-->
        var year  = '<!--{$arrForm.year.value|h}-->';
        var month = '<!--{$arrForm.month.value|h}-->';
        var day   = '<!--{$arrForm.day.value|h}-->';
        var ymd = $.datepicker.formatDate(dateFormat, new Date(year, month - 1, day));
        $("#datepickerorder_edit").val(ymd);
        <!--{/if}-->

        $( "#datepickerorder_edit" ).datepicker({
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
        
        $("#datepickerorder_edit").change( function() {
            var dateText   = $(this).val();
            var dateFormat = $.datepicker.regional['<!--{$smarty.const.LANG_CODE}-->'].dateFormat;
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
                $(this).val('');
            }
            setDatecustomer_edit(year + '/' + month + '/' + day);
        });

        <!--{if $arrForm.due_date_year.value != '' && $arrForm.due_date_month.value != '' && $arrForm.due_date_day.value != ''}-->
        var year  = '<!--{$arrForm.due_date_year.value|h}-->';
        var month = '<!--{$arrForm.due_date_month.value|h}-->';
        var day   = '<!--{$arrForm.due_date_day.value|h}-->';
        var ymd = $.datepicker.formatDate(dateFormat, new Date(year, month - 1, day));
        $("#due_date_datepicker").val(ymd);
        <!--{/if}-->
        $( "#due_date_datepicker" ).datepicker({
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
                setDateExport_edit(year + '/' + month + '/' + day);
            },
            showButtonPanel: true,
            beforeShow: showAdditionalButtonExport_edit,
            onChangeMonthYear: showAdditionalButtonExport_edit
            });
            
            $("#due_date_datepicker").change( function() {
                var dateText   = $(this).val();
                var dateFormat = $.datepicker.regional['<!--{$smarty.const.LANG_CODE}-->'].dateFormat;
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
                    $(this).val('');
                }
                setDateExport_edit(year + '/' + month + '/' + day);
            });

        $('.price_check').change( function() {
            var price_net = $('#price_net').val();
            var price_sale = $('#price_sale').val();
            var earning = 0;
            if (price_net > 0 && price_sale > price_net) {
                earning = price_sale - price_net;
            }
            $('#earning').val(earning);
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

    var showAdditionalButtonExport_edit = function (input) {
        setTimeout(function () {
            var buttonPane = $(input)
                     .datepicker("widget")
                     .find(".ui-datepicker-buttonpane");
            btn
                    .unbind("click")
                    .bind("click", function () {
                        $.datepicker._clearDate(input);
                        $("*[name=due_date_year]").val("");
                        $("*[name=due_date_month]").val("");
                        $("*[name=due_date_day]").val("");
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

    function setDateExport_edit(dateText){
        var dates = dateText.split('/');
        $("*[name=due_date_year]").val(dates[0]);
        $("*[name=due_date_month]").val(dates[1]);
        $("*[name=due_date_day]").val(dates[2]);
    }

//-->
</script>
<form name="form1" id="form1" method="post" action="?">
<input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
<input type="hidden" name="mode" value="<!--{$tpl_mode|default:"edit"|h}-->" />
<input type="hidden" name="order_id" value="<!--{$arrForm.order_id.value|h}-->" />
<input type="hidden" name="edit_customer_id" value="" />
<input type="hidden" name="anchor_key" value="" />
<input type="hidden" id="add_product_id" name="add_product_id" value="" />
<input type="hidden" id="add_product_class_id" name="add_product_class_id" value="" />
<input type="hidden" id="edit_product_id" name="edit_product_id" value="" />
<input type="hidden" id="edit_product_class_id" name="edit_product_class_id" value="" />
<input type="hidden" id="no" name="no" value="" />
<input type="hidden" id="delete_no" name="delete_no" value="" />
<!--{foreach key=key item=item from=$arrSearchHidden}-->
    <!--{if is_array($item)}-->
        <!--{foreach item=c_item from=$item}-->
        <input type="hidden" name="<!--{$key|h}-->[]" value="<!--{$c_item|h}-->" />
        <!--{/foreach}-->
    <!--{else}-->
        <input type="hidden" name="<!--{$key|h}-->" value="<!--{$item|h}-->" />
    <!--{/if}-->
<!--{/foreach}-->

<div id="order" class="contents-main">

    <!--▼お客様情報ここから-->
    <table class="form">
        <!--{if $arrForm.order_id.value > 0}-->
        <tr>
            <th>ID</th>
            <td><!--{$arrForm.order_id.value|h}--></td>
        </tr>
        <tr>
            <th>Ngày Tạo</th>
            <td><!--{$arrForm.create_date.value|sfDispDBDate|h}--><input type="hidden" name="create_date" value="<!--{$arrForm.create_date.value|h}-->" /></td>
        </tr>
        <tr>
            <th>Người Tạo (NV)</th>
            <!--{assign var=key value=$arrForm.creator_id.value}-->
            <td><!--{$arrMembers[$key]}--><input type="hidden" name="creator_id" value="<!--{$arrForm.creator_id.value|h}-->" /></td>
        </tr>
        <!--{/if}-->
        <tr>
            <th>Mã CODE</th>
            <td>
                <!--{assign var=key1 value="order_code"}-->
                <span class="attention"><!--{$arrErr[$key1]}--></span>
                <input type="text" name="<!--{$key1}-->" value="<!--{$arrForm[$key1].value|h}-->" maxlength="<!--{$arrForm[$key1].length}-->" style="<!--{$arrErr[$key1]|sfGetErrorColor}-->" size="30" class="box30" />
            </td>
        </tr>
        <tr>
            <th>Trạng Thái</th>
            <td>
                <!--{assign var=key value="status"}-->
                <span class="attention"><!--{$arrErr[$key]}--></span>
                <select name="<!--{$key}-->" style="<!--{$arrErr[$key]|sfGetErrorColor}-->">
                    <!--{html_options options=$arrORDERSTATUS selected=$arrForm[$key].value}-->
                </select>
            </td>
        </tr>
        <tr>
            <th>Ngày Bay</th>
            <td>
                <!--{assign var=errFly value="`$arrErr.year``$arrErr.month``$arrErr.day`"}-->
                <!--{if $errFly}-->
                    <div class="attention"><!--{$errFly}--></div>
                <!--{/if}-->
                <input id="datepickerorder_edit" type="text" value="" <!--{if $arrErr.year != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> />
                <input type="hidden" name="year" value="<!--{$arrForm.year.value}-->" />
                <input type="hidden" name="month" value="<!--{$arrForm.month.value}-->" />
                <input type="hidden" name="day" value="<!--{$arrForm.day.value}-->" />
            </td>
        </tr>
        <tr>
            <th>Giờ Bay</th>
            <td>
                <!--{assign var=key1 value="fly_hour"}-->
                <!--{assign var=key2 value="fly_minute"}-->
                <span class="attention"><!--{$arrErr[$key1]}--></span>
                <span class="attention"><!--{$arrErr[$key2]}--></span>
                <select name="<!--{$key1}-->" style="<!--{$arrErr[$key]|sfGetErrorColor}-->">
                    <!--{html_options options=$arrHour selected=$arrForm[$key1].value}-->
                </select>
                <span>Giờ</span>
                <select name="<!--{$key2}-->" style="<!--{$arrErr[$key]|sfGetErrorColor}-->">
                    <!--{html_options options=$arrMinutes selected=$arrForm[$key2].value}-->
                </select>
                <span>Phút</span>
            </td>
        </tr>
        <tr>
            <th>Hành Trình</th>
            <td>
                <!--{assign var=key1 value="order_dept"}-->
                <!--{assign var=key2 value="order_arriv"}-->
                <span class="attention"><!--{$arrErr[$key1]}--></span>
                <span class="attention"><!--{$arrErr[$key2]}--></span>
                <span>Xuất Phát</span>
                <input type="text" name="<!--{$key1}-->" value="<!--{$arrForm[$key1].value|h}-->" maxlength="<!--{$arrForm[$key1].length}-->" style="<!--{$arrErr[$key1]|sfGetErrorColor}-->" size="30" class="box30" /><br /><br />
                <span>Điểm Đến</span>
                <input type="text" name="<!--{$key2}-->" value="<!--{$arrForm[$key2].value|h}-->" maxlength="<!--{$arrForm[$key2].length}-->" style="<!--{$arrErr[$key1]|sfGetErrorColor}-->" size="30" class="box30" />
            </td>
        </tr>
        <tr>
            <th>Số Lượng Khách</th>
            <td>
                <!--{assign var=key1 value="number_pax_adult"}-->
                <!--{assign var=key2 value="number_pax_child"}-->
                <!--{assign var=key3 value="number_pax_baby"}-->
                <span>Người Lớn</span>
                <select name="<!--{$key1}-->" style="<!--{$arrErr[$key1]|sfGetErrorColor}-->">
                    <!--{html_options options=$arrPax selected=$arrForm[$key1].value}-->
                </select>
                <span>&nbsp;&nbsp;&nbsp;Trẻ Em</span>
                <select name="<!--{$key2}-->" style="<!--{$arrErr[$key2]|sfGetErrorColor}-->">
                    <!--{html_options options=$arrPax selected=$arrForm[$key2].value}-->
                </select>
                <span>&nbsp;&nbsp;&nbsp;Em Bé</span>
                <select name="<!--{$key3}-->" style="<!--{$arrErr[$key3]|sfGetErrorColor}-->">
                    <!--{html_options options=$arrPax selected=$arrForm[$key3].value}-->
                </select>
            </td>
        </tr>
        <tr>
            <th>Giá NET</th>
            <td>
                <!--{assign var=key1 value="price_net"}-->
                <span class="attention"><!--{$arrErr[$key1]}--></span>
                <input type="text" id="price_net" name="<!--{$key1}-->" value="<!--{$arrForm[$key1].value|h}-->" maxlength="<!--{$arrForm[$key1].length}-->" style="<!--{$arrErr[$key1]|sfGetErrorColor}-->" size="30" class="box30 price_check" /> VND
            </td>
        </tr>
        <tr>
            <th>Giá Bán</th>
            <td>
                <!--{assign var=key1 value="price_sale"}-->
                <span class="attention"><!--{$arrErr[$key1]}--></span>
                <input type="text" id="price_sale" name="<!--{$key1}-->" value="<!--{$arrForm[$key1].value|h}-->" maxlength="<!--{$arrForm[$key1].length}-->" style="<!--{$arrErr[$key1]|sfGetErrorColor}-->" size="30" class="box30 price_check" /> VND
            </td>
        </tr>
        <tr>
            <th>Lãi</th>
            <td>
                <!--{assign var=key1 value="earning"}-->
                <span class="attention"><!--{$arrErr[$key1]}--></span>
                <input type="text" readonly id="earning" name="<!--{$key1}-->" value="<!--{$arrForm[$key1].value|h}-->" maxlength="<!--{$arrForm[$key1].length}-->" style="<!--{$arrErr[$key1]|sfGetErrorColor}-->" size="30" class="box30" /> VND
            </td>
        </tr>
        <tr>
            <th>Phương Pháp Thanh Toán</th>
            <td>
                <!--{assign var=key1 value="payment_status"}-->
                <span class="attention"><!--{$arrErr[$key1]}--></span>
                <select name="<!--{$key1}-->" style="<!--{$arrErr[$key]|sfGetErrorColor}-->">
                    <!--{html_options options=$arrPaymentStatus selected=$arrForm[$key1].value}-->
                </select>
            </td>
        </tr>
        <tr>
            <th>Nợ</th>
            <td>
                <!--{assign var=key1 value="debt_status"}-->
                <span class="attention"><!--{$arrErr[$key1]}--></span>
                <!--{html_radios name='debt_status' options=$arrDebtStatus selected=$arrForm[$key1].value separator='<br />'}-->
            </td>
        </tr>
        <tr>
            <th>Số Tiền Nợ</th>
            <td>
                <!--{assign var=key1 value="debt_amount"}-->
                <span class="attention"><!--{$arrErr[$key1]}--></span>
                <input type="text" name="<!--{$key1}-->" value="<!--{$arrForm[$key1].value|h}-->" maxlength="<!--{$arrForm[$key1].length}-->" style="<!--{$arrErr[$key1]|sfGetErrorColor}-->" size="30" class="box30" /> VND
            </td>
        </tr>
        <tr>
            <th>Thời Hạn Giữ Chỗ</th>
            <td>
                <!--{assign var=key1 value="due_date"}-->
                <!--{assign var=key2 value="due_date_hour"}-->
                <!--{assign var=key3 value="due_date_min"}-->
                <span class="attention"><!--{$arrErr[$key1]}--></span>
                <input type="text" id="due_date_datepicker" name="<!--{$key1}-->" value="<!--{$arrForm[$key1].value|h}-->" maxlength="<!--{$arrForm[$key1].length}-->" style="<!--{$arrErr[$key1]|sfGetErrorColor}-->" size="30" class="box30" />
                <input type="hidden" name="due_date_year" value="<!--{$arrForm.due_date_year.value}-->" />
                <input type="hidden" name="due_date_month" value="<!--{$arrForm.due_date_month.value}-->" />
                <input type="hidden" name="due_date_day" value="<!--{$arrForm.due_date_day.value}-->" />
                <select name="<!--{$key2}-->" style="<!--{$arrErr[$key]|sfGetErrorColor}-->">
                    <!--{html_options options=$arrHour selected=$arrForm[$key2].value}-->
                </select>
                <span>Giờ</span>
                <select name="<!--{$key3}-->" style="<!--{$arrErr[$key]|sfGetErrorColor}-->">
                    <!--{html_options options=$arrMinutes selected=$arrForm[$key3].value}-->
                </select>
                <span>Phút</span><br />
                <label><input type="checkbox" name="is_export" value="1" <!--{if $arrForm.is_export.value == "1"}-->checked<!--{/if}--> onclick="fnCheckIsExport('<!--{$smarty.const.DISABLED_RGB}-->');"/>Xuất Bay Gấp</label>
            </td>
        </tr>
        <tr>
            <th>Ghi Chú</th>
            <td>
                <!--{assign var=key value="memo01"}-->
                <span class="attention"><!--{$arrErr[$key]}--></span>
                <textarea name="<!--{$key}-->" maxlength="<!--{$arrForm[$key].length}-->" cols="80" rows="6" class="area80" style="<!--{$arrErr[$key]|sfGetErrorColor}-->" ><!--{"\n"}--><!--{$arrForm[$key].value|h}--></textarea>
            </td>
        </tr>
        <tr>
            <th>Ghi Chú Danh Sách Hành Khách</th>
            <td>
                <!--{assign var=key value="memo02"}-->
                <span class="attention"><!--{$arrErr[$key]}--></span>
                <textarea name="<!--{$key}-->" maxlength="<!--{$arrForm[$key].length}-->" cols="80" rows="6" class="area80" style="<!--{$arrErr[$key]|sfGetErrorColor}-->" ><!--{"\n"}--><!--{$arrForm[$key].value|h}--></textarea>
            </td>
        </tr>
    </table>

    <h2>Thông Tin Khách Hàng
        <!--{if $tpl_mode == 'add'}-->
            <a class="btn-normal" href="javascript:;" name="address_input" onclick="fnOpenWindow('<!--{$smarty.const.ROOT_URLPATH}--><!--{$smarty.const.ADMIN_DIR}-->customer/search_customer.php','search','600','650'); return false;">Tìm Kiếm</a>
        <!--{/if}-->
    </h2>
    <table class="form">
        <tr>
            <th>Mã Khách Hàng</th>
            <td>
                <!--{if $arrForm.customer_id.value > 0}-->
                    <!--{$arrForm.customer_id.value|h}-->
                    <input type="hidden" name="customer_id" value="<!--{$arrForm.customer_id.value|h}-->" />
                <!--{else}-->
                    (Chưa Chọn)
                <!--{/if}-->
            </td>
        </tr>
        <tr>
            <th>Họ Và Tên</th>
            <td>
                <!--{assign var=key1 value="order_name01"}-->
                <!--{assign var=key2 value="order_name02"}-->
                <span class="attention"><!--{$arrErr[$key1]}--><!--{$arrErr[$key2]}--></span>
                <input type="text" name="<!--{$key1}-->" value="<!--{$arrForm[$key1].value|h}-->" maxlength="<!--{$arrForm[$key1].length}-->" style="<!--{$arrErr[$key1]|sfGetErrorColor}-->" size="15" class="box15" />--
                <input type="text" name="<!--{$key2}-->" value="<!--{$arrForm[$key2].value|h}-->" maxlength="<!--{$arrForm[$key2].length}-->" style="<!--{$arrErr[$key2]|sfGetErrorColor}-->" size="15" class="box15" />
            </td>
        </tr>
        <tr>
            <th>Email</th>
            <td>
                <!--{assign var=key1 value="order_email"}-->
                <span class="attention"><!--{$arrErr[$key1]}--></span>
                <input type="text" name="<!--{$key1}-->" value="<!--{$arrForm[$key1].value|h}-->" maxlength="<!--{$arrForm[$key1].length}-->" style="<!--{$arrErr[$key1]|sfGetErrorColor}-->" size="35" class="box35" />
            </td>
        </tr>
        <tr>
            <th>Số Điện Thoại</th>
            <td>
                <!--{assign var=key1 value="order_tel"}-->
                <span class="attention"><!--{$arrErr[$key1]}--></span>
                <input type="text" name="<!--{$arrForm[$key1].keyname}-->" value="<!--{$arrForm[$key1].value|h}-->" maxlength="<!--{$arrForm[$key1].length}-->" style="<!--{$arrErr[$key1]|sfGetErrorColor}-->" size="35" class="box35" />
            </td>
        </tr>
        <tr>
            <th>Địa chỉ</th>
            <td>
                <!--{assign var=key value="order_addr01"}-->
                <span class="attention"><!--{$arrErr[$key]}--></span>
                <input type="text" name="<!--{$key}-->" value="<!--{$arrForm[$key].value|h}-->" size="60" class="box60 top" maxlength="<!--{$arrForm[$key].length}-->" style="<!--{$arrErr[$key]|sfGetErrorColor}-->" /><br />
                <!--{assign var=key value="order_addr02"}-->
                <span class="attention"><!--{$arrErr[$key]}--></span>
                <input type="text" name="<!--{$key}-->" value="<!--{$arrForm[$key].value|h}-->" size="60" class="box60" maxlength="<!--{$arrForm[$key].length}-->" style="<!--{$arrErr[$key]|sfGetErrorColor}-->" />
            </td>
        </tr>
        <!--{if !$arrForm.order_id.value}-->
        <tr>
            <th>Ghi Chú</th>
            <td><!--{$arrForm.message.value|h|nl2br}--></td>
        </tr>
        <!--{/if}-->
    </table>
    <!--▲お客様情報ここまで-->

    <div class="btn-area">
        <ul>
            <!--{if count($arrSearchHidden) > 0}-->
            <li><a class="btn-action" href="javascript:;" onclick="fnChangeAction('<!--{$smarty.const.ADMIN_ORDER_URLPATH}-->'); fnModeSubmit('search','',''); return false;"><span class="btn-prev">Quay Lại</span></a></li>
            <!--{/if}-->
            <li><a class="btn-action" href="javascript:;" onclick="return fnFormConfirm(); return false;"><span class="btn-next">Lưu</span></a></li>
        </ul>
    </div>
</div>
<div id="multiple"></div>
</form>
