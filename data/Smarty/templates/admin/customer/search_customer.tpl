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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.    See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA    02111-1307, USA.
 */
*}-->

<!--{include file="`$smarty.const.TEMPLATE_ADMIN_REALDIR`admin_popup_header.tpl"}-->
<script type="text/javascript">
<!--
self.moveTo(20,20);self.focus();

function func_submit(customer_id){
    var fm = window.opener.document.form1;
    fm.edit_customer_id.value = customer_id;
    fm.mode.value = 'search_customer';
    fm.submit();
    window.close();
    return false;
}
//-->
</script>

<!--▼検索フォーム-->
<form name="form1" id="form1" method="post" action="?">
<input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
<input name="mode" type="hidden" value="search">
<input name="search_pageno" type="hidden" value="">
<input name="customer_id" type="hidden" value="">

<table class="form">
    <col width="20%" />
    <col width="80%" />
    <tr>
        <th class="colmun">Mã Khách Hàng</th>
        <td width="287" colspan="2">
            <!--{assign var=key value="search_customer_id"}-->
            <!--{if $arrErr[$key]}--><span class="attention"><!--{$arrErr[$key]}--></span><br /><!--{/if}-->
            <input type="text" name="<!--{$key}-->" maxlength="<!--{$arrForm[$key].length}-->" value="<!--{$arrForm[$key].value|h}-->" size="30" class="box30" <!--{if $arrErr[$key]}--><!--{sfSetErrorStyle}--><!--{/if}--> />
        </td>
    </tr>
    <tr class="n">
        <th class="colmun">Tên</th>
        <td>
            <!--{assign var=key value="search_name"}-->
            <!--{if $arrErr[$key]}--><span class="attention"><!--{$arrErr[$key]}--></span><br /><!--{/if}-->
            <input type="text" name="<!--{$key}-->" maxlength="<!--{$arrForm[$key].length}-->" value="<!--{$arrForm[$key].value|h}-->" size="30" class="box30" <!--{if $arrErr[$key]}--><!--{sfSetErrorStyle}--><!--{/if}--> />
        </td>
    </tr>
    <tr>
        <th class="colmun">Số Điện Thoại</th>
        <td width="287" colspan="2">
            <!--{assign var=key value="search_tel"}-->
            <!--{if $arrErr[$key]}--><span class="attention"><!--{$arrErr[$key]}--></span><br /><!--{/if}-->
            <input type="text" name="<!--{$key}-->" maxlength="<!--{$arrForm[$key].length}-->" value="<!--{$arrForm[$key].value|h}-->" size="30" class="box30" <!--{if $arrErr[$key]}--><!--{sfSetErrorStyle}--><!--{/if}--> />
        </td>
    </tr>
</table>

<div class="btn-area">
    <ul>
        <li><a class="btn-action" href="javascript:;" onclick="fnFormModeSubmit('form1', 'search', '', ''); return false;" name="subm"><span class="btn-next">Tìm Kiếm</span></a></li>
    </ul>
</div>

<p>
<!--{if $smarty.post.mode == 'search'}-->
    <!--▼検索結果表示-->
        <!--{if $tpl_linemax > 0}-->
        <p><!--{t string="tpl_T_ARG1 items were found._01" T_ARG1=$tpl_linemax}--><!--{$tpl_strnavi}--></p>
        <!--{/if}-->

    <!--▼検索後表示部分-->
    <table class="list">
        <tr>
            <th>Mã Khách Hàng</th>
            <th>Tên</th>
            <th>Số Điện Thoại</th>
            <th>Chọn</th>
        </tr>
        <!--{section name=cnt loop=$arrCustomer}-->
        <!--▼会員<!--{$smarty.section.cnt.iteration}-->-->
        <tr>
            <td>
            <!--{$arrCustomer[cnt].customer_id|h}-->
            </td>
            <td><!--{$arrCustomer[cnt].name01|h}--><!--{$arrCustomer[cnt].name02|h}--></td>
            <td><!--{$arrCustomer[cnt].tel|h}--></td>
            <td align="center"><a href="" onClick="return func_submit(<!--{$arrCustomer[cnt].customer_id|h}-->)">Chọn</a></td>
        </tr>
        <!--▲会員<!--{$smarty.section.cnt.iteration}-->-->
        <!--{sectionelse}-->
        <tr>
            <td colspan="4"><!--{t string="There is no member information."}--></td>
        </tr>
        <!--{/section}-->
    </table>

    <!--▲検索結果表示-->
<!--{/if}-->
</form>
<!--{include file="`$smarty.const.TEMPLATE_ADMIN_REALDIR`admin_popup_footer.tpl"}-->
