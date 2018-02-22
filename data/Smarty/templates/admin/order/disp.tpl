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
self.moveTo(20,20);self.focus();
//-->
</script>

<!--{include file="`$smarty.const.TEMPLATE_ADMIN_REALDIR`admin_popup_header.tpl"}-->

    <!--▼お客様情報ここから-->
    <table class="form">
        <tr>
            <th>ID</th>
            <td><!--{$arrForm.order_id.value|h}--></td>
            <input type="hidden" name="order_id" value="<!--{$arrForm.order_id.value|h}-->" />
        </tr>
        <tr>
            <th>Ngày Tạo</th>
            <td><!--{$arrForm.create_date.value|sfDispDBDate|h}--></td>
        </tr>
        <tr>
            <th>Người Tạo</th>
            <td><!--{$arrMembers[$arrForm.creator_id.value]|h}--></td>
        </tr>
        <tr>
            <th>CODE</th>
            <td><!--{$arrForm.order_code.value}--></td>
        </tr>
        <tr>
            <th>Trạng Thái</th>
            <td><!--{$arrORDERSTATUS[$arrForm.status.value]|h}--></td>
        </tr>
        <tr>
            <th>Ngày Bay</th>
            <td><!--{$arrForm.start_date.value|sfDispDBDate:false}--> - <!--{$arrForm.start_time.value}--></td>
        </tr>
        <tr>
            <th>Hành Trình</th>
            <td><!--{$arrForm.order_dept.value}--> - <!--{$arrForm.order_arriv.value}--></td>
        </tr>
        <tr>
            <th>Số Lượng Khách</th>
            <td><!--{if $arrForm.number_pax_adult.value > 0}--><!--{$arrForm.number_pax_adult.value}--> Người Lớn <!--{/if}-->
                <!--{if $arrForm.number_pax_child.value > 0}-->, <!--{$arrForm.number_pax_child.value}--> Trẻ Em <!--{/if}-->
                <!--{if $arrForm.number_pax_baby.value > 0}-->, <!--{$arrForm.number_pax_baby.value}--> Em Bé <!--{/if}-->
            </td>
        </tr>
        <tr>
            <th>Giá NET</th>
            <td><!--{$arrForm.price_net.value}--></td>
        </tr>
        <tr>
            <th>Giá Bán</th>
            <td><!--{$arrForm.price_sale.value}--></td>
        </tr>
        <tr>
            <th>Nợ</th>
            <td><!--{$arrDebtStatus[$arrForm.debt_status.value]|h}--></td>
        </tr>
        <tr>
            <th>Thời Hạn Giữ Chỗ</th>
            <td><!--{$arrForm.due_day.value}--></td>
        </tr>
        <tr>
            <th>Ghi Chú</th>
            <td><!--{$arrForm.memo01.value}--></td>
        </tr>
        <tr>
            <th>Ghi Chú Khách Hàng</th>
            <td><!--{$arrForm.memo02.value}--></td>
        </tr>
    </table>

    <h2>Thông Tin Khách Hàng</h2>
    <table class="form">
        <tr>
            <th>ID</th>
            <td>
                <!--{if $arrForm.customer_id.value > 0}-->
                    <!--{$arrForm.customer_id.value|h}-->
                <!--{else}-->
                    <!--{t string="tpl_(Non-member)_01"}-->
                <!--{/if}-->
            </td>
        </tr>
        <tr>
            <th>Tên</th>
            <td><!--{$arrForm.order_name01.value|h}-->&nbsp;<!--{$arrForm.order_name02.value|h}--></td>
        </tr>
        <tr>
            <th>Email</th>
            <td><!--{$arrForm.order_email.value|h}--></td>
        </tr>
        <tr>
            <th>Số Điện Thoại</th>
            <td><!--{$arrForm.order_tel.value|h}--></td>
        </tr>
        <tr>
            <th>Địa Chỉ</th>
            <td>
                <!--{t string="tpl_Postal code mark_01"}-->&nbsp;<!--{$arrForm.order_zipcode.value|h}--><br />
                <!--{$arrPref[$arrForm.order_pref.value]|h}--><!--{$arrForm.order_addr01.value|h}--> <!--{$arrForm.order_addr02.value|h}-->
            </td>
        </tr>
    </table>
    <!--▲お客様情報ここまで-->

        <div class="btn-area">
            <ul>
                <li><a class="btn-action" href="javascript:;" onclick="window.close(); return false;"><span class="btn-next">Đóng</span></a></li>
            </ul>
        </div>

<!--{include file="`$smarty.const.TEMPLATE_ADMIN_REALDIR`admin_popup_footer.tpl"}-->
