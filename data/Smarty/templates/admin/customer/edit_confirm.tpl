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

function func_return(){
    document.form1.mode.value = "return";
    document.form1.submit();
}

//-->
</script>


<form name="form1" id="form1" method="post" action="?">
    <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
    <input type="hidden" name="mode" value="complete" />

    <!--{foreach from=$arrForm key=key item=item}-->
        <!--{if $key ne "mode" && $key ne "subm" && $key ne $smarty.const.TRANSACTION_ID_NAME}-->
            <input type="hidden" name="<!--{$key|h}-->" value="<!--{$item|h}-->" />
        <!--{/if}-->
    <!--{/foreach}-->

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
            <tr>
                <th>Khách Hàng ID</th>
                <td><!--{$arrForm.customer_id|h}--></td>
            </tr>
            <tr>
                <th>Họ và Tên</th>
                <td><!--{t string="tpl_T_ARG1 T_ARG2_01" T_ARG1=$arrForm.name01|h T_ARG2=$arrForm.name02|h}--></td>
            </tr>
            <tr>
                <th>Địa Chỉ</th>
                <td><!--{$arrPref[$arrForm.pref]|h}--><!--{$arrForm.addr01|h}--> <!--{$arrForm.addr02|h}--></td>
            </tr>
            <tr>
                <th>Email</th>
                <td><!--{$arrForm.email|h}--></td>
            </tr>
            <tr>
                <th>Số điện thoại</th>
                <td><!--{$arrForm.tel|h}--></td>
            </tr>
            <tr>
                <th>Ghi Chú</th>
                <td><!--{$arrForm.note|h|nl2br|default_t:"tpl_Not registered_01"}--></td>
            </tr>
        </table>
        <div class="btn-area">
            <ul>
                <li><a class="btn-action" href="javascript:;" onclick="func_return(); return false;"><span class="btn-prev">Quay Lại</span></a></li>
                <li><a class="btn-action" href="javascript:;" onclick="fnFormModeSubmit('form1', 'complete', '', ''); return false;"><span class="btn-next">Lưu</span></a></li>
            </ul>
        </div>
    </div>
</form>
