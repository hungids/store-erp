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

<!--{include file="`$smarty.const.TEMPLATE_ADMIN_REALDIR`admin_popup_header.tpl"}-->

<script type="text/javascript">
<!--
self.moveTo(20,20);self.focus();
//-->
</script>

<form name="form1" id="form1" method="post" action="" onsubmit="return fnRegistMember();">
<input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
<input type="hidden" name="mode" value="<!--{$tpl_mode|h}-->">
<input type="hidden" name="member_id" value="<!--{$tpl_member_id|h}-->">
<input type="hidden" name="pageno" value="<!--{$tpl_pageno|h}-->">
<input type="hidden" name="old_login_id" value="<!--{$tpl_old_login_id|h}-->">

<h2><!--{t string="tpl_Member registration/editing_01"}--></h2>

<table>
    <col width="20%" />
    <col width="80%" />
    <tr>
        <th>Tên</th>
        <td>
            <!--{if $arrErr.name}--><span class="attention"><!--{$arrErr.name}--></span><!--{/if}-->
            <input type="text" name="name" size="30" class="box30" value="<!--{$arrForm.name|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" />
            <span class="attention">* Bắt Buộc</span>
        </td>
    </tr>
    <tr>
        <th>Mã NV</th>
        <td>
            <!--{if $arrErr.department}--><span class="attention"><!--{$arrErr.department}--></span><!--{/if}-->
            <input type="text" name="department" size="30" class="box30" value="<!--{$arrForm.department|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" />
            <span class="attention">* Bắt Buộc</span>
        </td>
    </tr>
    <tr>
        <th>Số Điện Thoại</th>
        <td>
            <!--{if $arrErr.tel}--><span class="attention"><!--{$arrErr.tel}--></span><!--{/if}-->
            <input type="text" name="tel" size="30" class="box30" value="<!--{$arrForm.tel|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" />
        </td>
    </tr>
    <tr>
        <th>Địa Chỉ</th>
        <td>
            <!--{if $arrErr.addr}--><span class="attention"><!--{$arrErr.addr}--></span><!--{/if}-->
            <input type="text" name="addr" size="30" class="box30" value="<!--{$arrForm.addr|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" />
        </td>
    </tr>
    <tr>
        <th>Tài Khoản</th>
        <td>
            <!--{if $arrErr.login_id}--><span class="attention"><!--{$arrErr.login_id}--></span><!--{/if}-->
            <input type="text" name="login_id" size="20" class="box20"    value="<!--{$arrForm.login_id|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->"/>
            <span class="attention">* Bắt Buộc</span><br />
        </td>
    </tr>
    <tr>
        <th>Mật Khẩu</th>
        <td>
            <!--{if $arrErr.password}--><span class="attention"><!--{$arrErr.password}--><!--{$arrErr.password02}--></span><!--{/if}-->
            <input type="password" name="password" size="20" class="box20" value="<!--{$arrForm.password}-->" onfocus="<!--{$tpl_onfocus}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->"/>
            <span class="attention">* Bắt Buộc</span><br />
            <br />
            <input type="password" name="password02" size="20" class="box20" value="<!--{$arrForm.password02}-->" onfocus="<!--{$tpl_onfocus}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->"/>
            <p><span class="attention mini"><!--{t string="tpl_Enter twice for confirmation_01"}--></span></p>
        </td>
    </tr>
    <tr>
        <th>Quyền</th>
        <td>
            <!--{if $arrErr.authority}--><span class="attention"><!--{$arrErr.authority}--></span><!--{/if}-->
            <select name="authority">
                <option value="">Vui Lòng Chọn</option>
                <!--{html_options options=$arrAUTHORITY selected=$arrForm.authority}-->
            </select>
            <span class="attention">* Bắt Buộc</span>
        </td>
    </tr>
    <tr>
        <th><!--{t string="tpl_Operating/Not operating_01"}--></th>
        <td>
            <!--{if $arrErr.work}--><span class="attention"><!--{$arrErr.work}--></span><!--{/if}-->
            <!--{assign var=key value="work"}-->
            <input type="radio" id="<!--{$key}-->_1" name="<!--{$key}-->" value="1" style="<!--{$arrErr.work|sfGetErrorColor}-->" <!--{$arrForm.work|sfGetChecked:1}--> /><label for="<!--{$key}-->_1"><!--{t string="tpl_Operating_01"}--></label>
            <input type="radio" id="<!--{$key}-->_0" name="<!--{$key}-->" value="0" style="<!--{$arrErr.work|sfGetErrorColor}-->" <!--{$arrForm.work|sfGetChecked:0}--> /><label for="<!--{$key}-->_0"><!--{t string="tpl_Not operating_01"}--></label>
            <span class="attention">* Bắt Buộc</span>
        </td>
    </tr>
</table>

<div class="btn-area">
    <ul>
        <li><a class="btn-action" href="javascript:;" onclick="fnFormModeSubmit('form1', '<!--{$tpl_mode|h}-->', '', ''); return false;"><span class="btn-next">Lưu</span></a></li>
    </ul>
</div>
</form>

<!--{include file="`$smarty.const.TEMPLATE_ADMIN_REALDIR`admin_popup_footer.tpl"}-->
