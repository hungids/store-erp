<tr>
    <th>Mã khách hàng</th>
    <td colspan="3">
    <!--{assign var=key value="search_customer_id"}-->
    <!--{if $arrErr[$key]}--><span class="attention"><!--{$arrErr[$key]}--></span><br /><!--{/if}-->
    <input type="text" name="<!--{$key}-->" maxlength="<!--{$arrForm[$key].length}-->" value="<!--{$arrForm[$key].value|h}-->" size="60" class="box60" <!--{if $arrErr[$key]}--><!--{sfSetErrorStyle}--><!--{/if}--> /></td>

</tr>
<tr>
    <th>Tên</th>
    <td colspan="3">
            <!--{assign var=key value="search_name"}-->
            <!--{if $arrErr[$key]}--><span class="attention"><!--{$arrErr[$key]}--></span><br /><!--{/if}-->
            <input type="text" name="<!--{$key}-->" maxlength="<!--{$arrForm[$key].length}-->" value="<!--{$arrForm[$key].value|h}-->" size="60" class="box60" <!--{if $arrErr[$key]}--><!--{sfSetErrorStyle}--><!--{/if}--> />
    </td>
</tr>
<!--{* <tr>
    <th><!--{t string="tpl_Birthday_01"}--></th>
    <td colspan="3">
        <!--{if $arrErr.search_b_start_year || $arrErr.search_b_end_year}-->
        <span class="attention"><!--{$arrErr.search_b_start_year}--></span>
        <span class="attention"><!--{$arrErr.search_b_endy_ear}--></span>
        <!--{/if}-->
        <input id="datepickercustomersearch_b_start"
               type="text"
               value="" <!--{if $arrErr.search_b_start_year != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> />
        <input type="hidden" name="search_b_start_year" value="<!--{$arrForm.search_b_start_year.value|h}-->" />
        <input type="hidden" name="search_b_start_month" value="<!--{$arrForm.search_b_start_month.value|h}-->" />
        <input type="hidden" name="search_b_start_day" value="<!--{$arrForm.search_b_start_day.value|h}-->" />
        <!--{t string="-"}-->
        <input id="datepickercustomersearch_b_end"
               type="text"
               value="" <!--{if $arrErr.search_b_end_year != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> />
        <input type="hidden" name="search_b_end_year" value="<!--{$arrForm.search_b_end_year.value|h}-->" />
        <input type="hidden" name="search_b_end_month" value="<!--{$arrForm.search_b_end_month.value|h}-->" />
        <input type="hidden" name="search_b_end_day" value="<!--{$arrForm.search_b_end_day.value|h}-->" />
    </td>
</tr> *}-->
<tr>
    <th>Email</th>
    <td colspan="3">
    <!--{assign var=key value="search_email"}-->
    <!--{if $arrErr[$key]}--><span class="attention"><!--{$arrErr[$key]}--></span><!--{/if}-->
    <input type="text" name="<!--{$key}-->" maxlength="<!--{$arrForm[$key].length}-->" value="<!--{$arrForm[$key].value|h}-->" size="60" class="box60" <!--{if $arrErr[$key]}--><!--{sfSetErrorStyle}--><!--{/if}-->/>
    </td>
</tr>
<tr>
    <th>Số điện thoại</th>
    <td colspan="3">
        <!--{assign var=key value="search_tel"}-->
        <!--{if $arrErr[$key]}--><span class="attention"><!--{$arrErr[$key]}--></span><br /><!--{/if}-->
        <input type="text" name="<!--{$key}-->" maxlength="<!--{$arrForm[$key].length}-->" value="<!--{$arrForm[$key].value|h}-->" size="60" class="box60" /></td>
</tr>
<tr>
    <th>Nợ</th>
    <td colspan="3">
        <!--{assign var=key value="search_debt"}-->
        <span class="attention"><!--{$arrErr[$key]}--></span>
        <!--{html_radios name="$key" options=$arrDebtStatus selected=$arrForm[$key].value separator=' '}-->
    </td>
</tr>
