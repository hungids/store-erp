<?php
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

// {{{ requires
require_once CLASS_EX_REALDIR . 'page_extends/admin/order/LC_Page_Admin_Order_Ex.php';

/**
 * 受注修正 のページクラス.
 *
 * @package Page
 * @author LOCKON CO.,LTD.
 * @version $Id: LC_Page_Admin_Order_Edit.php 22509 2013-02-06 12:08:56Z kim $
 */
class LC_Page_Admin_Order_Edit extends LC_Page_Admin_Order_Ex {

    var $arrShippingKeys = array(
        'shipping_id',
        'shipping_name01',
        'shipping_name02',
        'shipping_kana01',
        'shipping_kana02',
        'shipping_tel01',
        'shipping_tel02',
        'shipping_tel03',
        'shipping_fax01',
        'shipping_fax02',
        'shipping_fax03',
        'shipping_pref',
//        'shipping_zip01',
//        'shipping_zip02',
        'shipping_zipcode',
        'shipping_addr01',
        'shipping_addr02',
        'shipping_date_year',
        'shipping_date_month',
        'shipping_date_day',
        'time_id',
    );

    var $arrShipmentItemKeys = array(
        'shipment_product_class_id',
        'shipment_product_code',
        'shipment_product_name',
        'shipment_classcategory_name1',
        'shipment_classcategory_name2',
        'shipment_price',
        'shipment_quantity',
    );

    // }}}
    // {{{ functions

    /**
     * Page を初期化する.
     *
     * @return void
     */
    function init() {
        parent::init();
        $this->tpl_mainpage = 'order/edit.tpl';
        $this->tpl_mainno = 'order';
        $this->tpl_maintitle = t('Vé');
        $this->tpl_subtitle = t('Đăng Kí Vé');

        $masterData = new SC_DB_MasterData_Ex();
        $this->arrPref = $masterData->getMasterData('mtb_pref');
        $this->arrORDERSTATUS = $masterData->getMasterData('mtb_order_status');
        $this->arrDeviceType = $masterData->getMasterData('mtb_device_type');
        $this->arrPaymentStatus = $masterData->getMasterData('mtb_payments_status');
        $this->arrDebtStatus = $masterData->getMasterData('mtb_debt_status');
        $this->arrMembers = SC_Helper_DB_Ex::sfGetIDValueList('dtb_member', 'member_id', "name");

        $objDate = new SC_Date_Ex(RELEASE_YEAR);
        $this->arrYearShippingDate = $objDate->getYear('', date('Y'), '');
        $this->arrMonthShippingDate = $objDate->getMonth(true);
        $this->arrDayShippingDate = $objDate->getDay(true);
        $this->arrHour = $objDate->getHour(true);
        $this->arrMinutes = $objDate->getMinutes(true);
        $this->arrPax = array(0,1,2,3,4,5,6,7,8,9,10);

        // 支払い方法の取得
        $this->arrPayment = SC_Helper_DB_Ex::sfGetIDValueList('dtb_payment', 'payment_id', 'payment_method');

        // 配送業者の取得
        $this->arrDeliv = SC_Helper_DB_Ex::sfGetIDValueList('dtb_deliv', 'deliv_id', 'name');

        $this->httpCacheControl('nocache');
    }

    /**
     * Page のプロセス.
     *
     * @return void
     */
    function process() {
        $this->action();
        $this->sendResponse();
    }

    /**
     * Page のアクション.
     *
     * @return void
     */
    function action() {

        $objPurchase = new SC_Helper_Purchase_Ex();
        $objFormParam = new SC_FormParam_Ex();

        // パラメーター情報の初期化
        $this->lfInitParam($objFormParam);
        $objFormParam->setParam($_REQUEST);
        $objFormParam->convParam();
        $order_id = $objFormParam->getValue('order_id');
        $arrValuesBefore = array();

        // DBから受注情報を読み込む
        if (!SC_Utils_Ex::isBlank($order_id)) {
            $this->setOrderToFormParam($objFormParam, $order_id);
            $this->tpl_subno = 'index';
            $arrValuesBefore['payment_id'] = $objFormParam->getValue('payment_id');
            $arrValuesBefore['payment_method'] = $objFormParam->getValue('payment_method');
        } else {
            $this->tpl_subno = 'add';
            $this->tpl_mode = 'add';
            $arrValuesBefore['payment_id'] = NULL;
            $arrValuesBefore['payment_method'] = NULL;
            // お届け先情報を空情報で表示
            $arrShippingIds[] = null;
            $objFormParam->setValue('shipping_id', $arrShippingIds);

            // 新規受注登録で入力エラーがあった場合の画面表示用に、会員の現在ポイントを取得
            if (!SC_Utils_Ex::isBlank($objFormParam->getValue('customer_id'))) {
                $customer_id = $objFormParam->getValue('customer_id');
                $arrCustomer = SC_Helper_Customer_Ex::sfGetCustomerDataFromId($customer_id);
                $objFormParam->setValue('customer_point', $arrCustomer['point']);

                // 新規受注登録で、ポイント利用できるように現在ポイントを設定
                $objFormParam->setValue('point', $arrCustomer['point']);
            }
        }

        $this->arrSearchHidden = $objFormParam->getSearchArray();

        switch ($this->getMode()) {
            case 'pre_edit':
            case 'order_id':
                break;
            case 'customer_book':
                $this->setCustomerTo($objFormParam->getValue('edit_customer_id'),
                    $objFormParam);
                break;

            case 'edit':
                $_POST['is_export'] = $_POST['is_export'] ? 1 : 0;
                $objFormParam->setParam($_POST);
                $objFormParam->convParam();
                $this->arrErr = $this->lfCheckError($objFormParam);
                if (SC_Utils_Ex::isBlank($this->arrErr)) {
                    $message = t('Thành Công');
                    $order_id = $this->doRegister($order_id, $objPurchase, $objFormParam, $message, $arrValuesBefore);
                    if ($order_id >= 0) {
                        $this->setOrderToFormParam($objFormParam, $order_id);
                    }
                    $this->tpl_onload = "window.alert('" . $message . "');";
                }
                break;

            case 'add':
                if ($_SERVER['REQUEST_METHOD'] == 'POST') {
                    $objFormParam->setParam($_POST);
                    $objFormParam->convParam();
                    $this->arrErr = $this->lfCheckError($objFormParam);
                    if (SC_Utils_Ex::isBlank($this->arrErr)) {
                        $message = t('Đăng Kí Thành Công');
                        $order_id = $this->doRegister(null, $objPurchase, $objFormParam, $message, $arrValuesBefore);
                        if ($order_id >= 0) {
                            $this->tpl_mode = 'edit';
                            $objFormParam->setValue('order_id', $order_id);
                            $this->setOrderToFormParam($objFormParam, $order_id);
                        }
                        $this->tpl_onload = "window.alert('" . $message . "');";
                    }
                }

                break;

            // 再計算
            case 'recalculate':
            //支払い方法の選択
            case 'payment':
            // 配送業者の選択
            case 'deliv':
                $objFormParam->setParam($_POST);
                $objFormParam->convParam();
                $this->arrErr = $this->lfCheckError($objFormParam);
                break;

            // 商品削除
            case 'delete_product':
                $objFormParam->setParam($_POST);
                $objFormParam->convParam();
                $delete_no = $objFormParam->getValue('delete_no');
                $this->doDeleteProduct($delete_no, $objFormParam);
                $this->arrErr = $this->lfCheckError($objFormParam);
                break;

            // 商品追加ポップアップより商品選択
            case 'select_product_detail':
                $objFormParam->setParam($_POST);
                $objFormParam->convParam();
                $this->doRegisterProduct($objFormParam);
                $this->arrErr = $this->lfCheckError($objFormParam);
                break;

            // 会員検索ポップアップより会員指定
            case 'search_customer':
                $objFormParam->setParam($_POST);
                $objFormParam->convParam();
                $this->setCustomerTo($objFormParam->getValue('edit_customer_id'),
                                     $objFormParam);
                $this->arrErr = $this->lfCheckError($objFormParam);
                break;

            // 複数配送設定表示
            case 'multiple':
                $objFormParam->setParam($_POST);
                $objFormParam->convParam();
                $this->arrErr = $this->lfCheckError($objFormParam);
                break;

            // 複数配送設定を反映
            case 'multiple_set_to':
                $this->lfInitMultipleParam($objFormParam);
                $objFormParam->setParam($_POST);
                $objFormParam->convParam();
                $this->setMultipleItemTo($objFormParam);
                break;

            // お届け先の追加
            case 'append_shipping':
                $objFormParam->setParam($_POST);
                $objFormParam->convParam();
                $this->addShipping($objFormParam);
                break;

            default:
                break;
        }

        $this->arrForm = $objFormParam->getFormParamList();
        $this->arrAllShipping = $objFormParam->getSwapArray(array_merge($this->arrShippingKeys, $this->arrShipmentItemKeys));
        $this->arrDelivTime = $objPurchase->getDelivTime($objFormParam->getValue('deliv_id'));
        $this->tpl_onload .= $this->getAnchorKey($objFormParam);
        $this->arrInfo = SC_Helper_DB_Ex::sfGetBasisData();
        if ($arrValuesBefore['payment_id'])
            $this->arrPayment[$arrValuesBefore['payment_id']] = $arrValuesBefore['payment_method'];

    }

    /**
     * デストラクタ.
     *
     * @return void
     */
    function destroy() {
        parent::destroy();
    }

    /**
     * パラメーター情報の初期化を行う.
     *
     * @param SC_FormParam $objFormParam SC_FormParam インスタンス
     * @return void
     */
    function lfInitParam(&$objFormParam) {
        // 検索条件のパラメーターを初期化
        parent::lfInitParam($objFormParam);

        // Khách đặt
        $objFormParam->addParam('KH ID', 'customer_id', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'), '0');
        $objFormParam->addParam('会員ID', 'edit_customer_id', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'), '0');
        $objFormParam->addParam(t('Tên 1'), 'order_name01', STEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Tên 2'), 'order_name02', STEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Email'), 'order_email', null, 'KVCa', array('NO_SPTAB', 'EMAIL_CHECK', 'EMAIL_CHAR_CHECK'));
        $objFormParam->addParam(t('Địa Chỉ 1'), 'order_addr01', MTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Địa Chỉ 2'), 'order_addr02', MTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Số Điện Thoại'), 'order_tel', STEXT_LEN, 'n', array('MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Ghi Chú'), 'message', LLTEXT_LEN, 'n', array('MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Ngày Tạo'), 'create_date', STEXT_LEN, 'n', array('MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Người Tạo'), 'creator_id', INT_LEN, 'n', array('MAX_LENGTH_CHECK'));
        // Ngày Bay
        $objFormParam->addParam(t('Năm'), 'year', STEXT_LEN, 'n', array('EXIST_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Tháng'), 'month', STEXT_LEN, 'n', array('MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Ngày'), 'day', STEXT_LEN, 'n', array('MAX_LENGTH_CHECK'));
        // Giờ Bay
        $objFormParam->addParam(t('Giờ'), 'fly_hour', STEXT_LEN, 'n', array('MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Phút'), 'fly_minute', STEXT_LEN, 'n', array('MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('c_Anchor key_01'), 'anchor_key', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        // Thông tin vé
        $objFormParam->addParam(t('Mã CODE'), 'order_code', STEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Trạng Thái'), 'status', INT_LEN, 'n', array('EXIST_CHECK', 'MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam(t('Xuất Phát'), 'order_dept', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Điểm Đến'), 'order_arriv', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Số Lượng Khách'), 'number_pax', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Số Lượng Khách Người Lớn'), 'number_pax_adult', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam(t('Số Lượng Khách Trẻ Em'), 'number_pax_child', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam(t('Số Lượng Khách Em Bé'), 'number_pax_baby', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam(t('Giá NET'), 'price_net', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Giá Bán'), 'price_sale', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Lãi'), 'earning', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Tình Trạng Thanh Toán'), 'payment_status', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Nợ'), 'debt_status', STEXT_LEN, 'n', array('MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Số Tiền Nợ'), 'debt_amount', STEXT_LEN, 'n', array('MAX_LENGTH_CHECK'));
        // Thời hạn giữ chỗ
        $objFormParam->addParam(t('Năm'), 'due_date_year', STEXT_LEN, 'n', array('MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Tháng'), 'due_date_month', STEXT_LEN, 'n', array('MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Ngày'), 'due_date_day', STEXT_LEN, 'n', array('MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Giờ'), 'due_date_hour', STEXT_LEN, 'n', array('MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Phút'), 'due_date_min', STEXT_LEN, 'n', array('MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Xuất ngay'), 'is_export', INT_LEN, 'n', array('MAX_LENGTH_CHECK'));

        $objFormParam->addParam(t('Ghi Chú'), 'memo01', LLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Ghi Chú Khách Hàng'), 'memo02', LLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
    }

    /**
     * 複数配送用フォームの初期化を行う.
     *
     * @param SC_FormParam $objFormParam SC_FormParam インスタンス
     * @return void
     */
    function lfInitMultipleParam(&$objFormParam) {
        $objFormParam->addParam(t('c_Product specification ID_01'), 'multiple_product_class_id', INT_LEN, 'n', array('EXIST_CHECK', 'MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam(t('c_Product code_01'), 'multiple_product_code', INT_LEN, 'n', array('EXIST_CHECK', 'MAX_LENGTH_CHECK', 'NUM_CHECK'), 1);
        $objFormParam->addParam(t('c_Product name_01'), 'multiple_product_name', INT_LEN, 'n', array('EXIST_CHECK', 'MAX_LENGTH_CHECK', 'NUM_CHECK'), 1);
        $objFormParam->addParam(t('c_Standard 1_01'), 'multiple_classcategory_name1', INT_LEN, 'n', array('EXIST_CHECK', 'MAX_LENGTH_CHECK', 'NUM_CHECK'), 1);
        $objFormParam->addParam(t('c_Standard 2_01'), 'multiple_classcategory_name2', INT_LEN, 'n', array('EXIST_CHECK', 'MAX_LENGTH_CHECK', 'NUM_CHECK'), 1);
        $objFormParam->addParam(t('c_Unit price_01'), 'multiple_price', INT_LEN, 'n', array('EXIST_CHECK', 'MAX_LENGTH_CHECK', 'NUM_CHECK'), 1);
        $objFormParam->addParam(t('c_Quantity_01'), 'multiple_quantity', INT_LEN, 'n', array('EXIST_CHECK', 'MAX_LENGTH_CHECK', 'NUM_CHECK'), 1);
        $objFormParam->addParam(t('c_Delivery destination_01'), 'multiple_shipping_id', INT_LEN, 'n', array('EXIST_CHECK', 'MAX_LENGTH_CHECK', 'NUM_CHECK'));
    }

    /**
     * 複数配送入力フォームで入力された値を SC_FormParam へ設定する.
     *
     * @param SC_FormParam $objFormParam SC_FormParam インスタンス
     * @return void
     */
    function setMultipleItemTo(&$objFormParam) {
        $arrMultipleKey = array('multiple_shipping_id',
                                'multiple_product_class_id',
                                'multiple_product_name',
                                'multiple_product_code',
                                'multiple_classcategory_name1',
                                'multiple_classcategory_name2',
                                'multiple_price',
                                'multiple_quantity');
        $arrMultipleParams = $objFormParam->getSwapArray($arrMultipleKey);

        /*
         * 複数配送フォームの入力値を shipping_id ごとにマージ
         *
         * $arrShipmentItem[お届け先ID][商品規格ID]['shipment_(key)'] = 値
         */
        $arrShipmentItem = array();
        foreach ($arrMultipleParams as $arrMultiple) {
            $shipping_id = $arrMultiple['multiple_shipping_id'];
            $product_class_id = $arrMultiple['multiple_product_class_id'];
            foreach ($arrMultiple as $key => $val) {
                if ($key == 'multiple_quantity') {
                    $arrShipmentItem[$shipping_id][$product_class_id][str_replace('multiple', 'shipment', $key)] += $val;
                } else {
                    $arrShipmentItem[$shipping_id][$product_class_id][str_replace('multiple', 'shipment', $key)] = $val;
                }
            }
        }

        /*
         * フォームのお届け先ごとの配列を生成
         *
         * $arrShipmentForm['(key)'][$shipping_id][$item_index] = 値
         * $arrProductQuantity[$shipping_id] = お届け先ごとの配送商品数量
         */
        $arrShipmentForm = array();
        $arrProductQuantity = array();
        $arrShippingIds = $objFormParam->getValue('shipping_id');
        foreach ($arrShippingIds as $shipping_id) {
            $item_index = 0;
            foreach ($arrShipmentItem[$shipping_id] as $product_class_id => $shipment_item) {
                foreach ($shipment_item as $key => $val) {
                    $arrShipmentForm[$key][$shipping_id][$item_index] = $val;
                }
                // 受注商品の数量を設定
                $arrQuantity[$product_class_id] += $shipment_item['shipment_quantity'];
                $item_index++;
            }
            // お届け先ごとの配送商品数量を設定
            $arrProductQuantity[$shipping_id] = count($arrShipmentItem[$shipping_id]);
        }

        $objFormParam->setParam($arrShipmentForm);
        $objFormParam->setValue('shipping_product_quantity', $arrProductQuantity);

        // 受注商品の数量を変更
        $arrDest = array();
        foreach ($objFormParam->getValue('product_class_id') as $n => $order_product_class_id) {
            $arrDest['quantity'][$n] = 0;
        }
        foreach ($arrQuantity as $product_class_id => $quantity) {
            foreach ($objFormParam->getValue('product_class_id') as $n => $order_product_class_id) {
                if ($product_class_id == $order_product_class_id) {
                    $arrDest['quantity'][$n] = $quantity;
                }
            }
        }
        $objFormParam->setParam($arrDest);
    }

    /**
     * 受注データを取得して, SC_FormParam へ設定する.
     *
     * @param SC_FormParam $objFormParam SC_FormParam インスタンス
     * @param integer $order_id 取得元の受注ID
     * @return void
     */
    function setOrderToFormParam(&$objFormParam, $order_id) {
        $objPurchase = new SC_Helper_Purchase_Ex();

        // 受注詳細を設定
        $arrOrderDetail = $objPurchase->getOrderDetail($order_id, false);
        $objFormParam->setParam(SC_Utils_Ex::sfSwapArray($arrOrderDetail));

        $arrShippingsTmp = $objPurchase->getShippings($order_id);
        $arrShippings = array();
        foreach ($arrShippingsTmp as $row) {
            // お届け日の処理
            if (!SC_Utils_Ex::isBlank($row['shipping_date'])) {
                $ts = strtotime($row['shipping_date']);
                $row['shipping_date_year'] = date('Y', $ts);
                $row['shipping_date_month'] = date('n', $ts);
                $row['shipping_date_day'] = date('j', $ts);
            }
            $arrShippings[$row['shipping_id']] = $row;
        }
        $objFormParam->setValue('shipping_quantity', count($arrShippings));
        $objFormParam->setParam(SC_Utils_Ex::sfSwapArray($arrShippings));

        /*
         * 配送商品を設定
         *
         * $arrShipmentItem['shipment_(key)'][$shipping_id][$item_index] = 値
         * $arrProductQuantity[$shipping_id] = お届け先ごとの配送商品数量
         */
        $arrProductQuantity = array();
        $arrShipmentItem = array();
        foreach ($arrShippings as $shipping_id => $arrShipping) {
            $arrProductQuantity[$shipping_id] = count($arrShipping['shipment_item']);
            foreach ($arrShipping['shipment_item'] as $item_index => $arrItem) {
                foreach ($arrItem as $item_key => $item_val) {
                    $arrShipmentItem['shipment_' . $item_key][$shipping_id][$item_index] = $item_val;
                }
            }
        }
        $objFormParam->setValue('shipping_product_quantity', $arrProductQuantity);
        $objFormParam->setParam($arrShipmentItem);

        /*
         * 受注情報を設定
         * $arrOrderDetail と項目が重複しており, $arrOrderDetail は連想配列の値
         * が渡ってくるため, $arrOrder で上書きする.
         */
        $arrOrder = $objPurchase->getOrder($order_id);

        if (isset($arrOrder['start_date'])) {
            $start_date = explode(' ', $arrOrder['start_date']);
            list($arrOrder['year'], $arrOrder['month'], $arrOrder['day']) = explode('-',$start_date[0]);
        }
        if (isset($arrOrder['start_time'])) {
            list($arrOrder['fly_hour'], $arrOrder['fly_minute'], $arrOrder['fly_second']) = explode(':',$arrOrder['start_time']);
        }

        // Thời hạn giữ chỗ
        if (isset($arrOrder['due_date'])) {
            $start_date = explode(' ', $arrOrder['due_date']);
            list($arrOrder['due_date_year'], $arrOrder['due_date_month'], $arrOrder['due_date_day']) = explode('-',$start_date[0]);
        }
        if (isset($arrOrder['due_time'])) {
            list($arrOrder['due_date_hour'], $arrOrder['due_date_min'], $arrOrder['due_date_second']) = explode(':',$arrOrder['due_time']);
        }

        $objFormParam->setParam($arrOrder);

        // ポイントを設定
        list($db_point, $rollback_point) = SC_Helper_DB_Ex::sfGetRollbackPoint(
            $order_id, $arrOrder['use_point'], $arrOrder['add_point'], $arrOrder['status']
        );
        $objFormParam->setValue('total_point', $db_point);
        $objFormParam->setValue('point', $rollback_point);

        if (!SC_Utils_Ex::isBlank($objFormParam->getValue('customer_id'))) {
            $arrCustomer = SC_Helper_Customer_Ex::sfGetCustomerDataFromId($objFormParam->getValue('customer_id'));
            $objFormParam->setValue('customer_point', $arrCustomer['point']);
        }
    }

    /**
     * 入力内容のチェックを行う.
     *
     * @param SC_FormParam $objFormParam SC_FormParam インスタンス
     * @return array エラーメッセージの配列
     */
    function lfCheckError(&$objFormParam) {
        $objProduct = new SC_Product_Ex();

        $arrErr = $objFormParam->checkError();

        if (!SC_Utils_Ex::isBlank($objErr->arrErr)) {
            return $arrErr;
        }

        $arrValues = $objFormParam->getHashArray();

        // 商品の種類数
        $max = count($arrValues['quantity']);
        $subtotal = 0;
        $totalpoint = 0;
        $totaltax = 0;
        for ($i = 0; $i < $max; $i++) {
            // 小計の計算
            $subtotal += SC_Helper_DB_Ex::sfCalcIncTax($arrValues['price'][$i]) * $arrValues['quantity'][$i];
            // 小計の計算
            $totaltax += SC_Helper_DB_Ex::sfTax($arrValues['price'][$i]) * $arrValues['quantity'][$i];
            // 加算ポイントの計算
            $totalpoint += SC_Utils_Ex::sfPrePoint($arrValues['price'][$i], $arrValues['point_rate'][$i]) * $arrValues['quantity'][$i];

            // 在庫数のチェック
            $arrProduct = $objProduct->getDetailAndProductsClass($arrValues['product_class_id'][$i]);

            // 編集前の値と比較するため受注詳細を取得
            $objPurchase = new SC_Helper_Purchase_Ex();
            $arrOrderDetail = SC_Utils_Ex::sfSwapArray($objPurchase->getOrderDetail($objFormParam->getValue('order_id'), false));

            if ($arrProduct['stock_unlimited'] != '1'
                && $arrProduct['stock'] < $arrValues['quantity'][$i] - $arrOrderDetail['quantity'][$i]) {
                $class_name1 = $arrValues['classcategory_name1'][$i];
                $class_name1 = SC_Utils_Ex::isBlank($class_name1) ? t('c_None_01') : $class_name1;
                $class_name2 = $arrValues['classcategory_name2'][$i];
                $class_name2 = SC_Utils_Ex::isBlank($class_name2) ? t('c_None_01') : $class_name2;                
                $arrErr['quantity'][$i] .= t('c_There is an inventory shortage for T_ARG1/(T_ARG2)/(T_ARG3). Up to T_ARG4 can be set for the quantity.<br />_1', array('T_ARG1' => $arrValues['product_name'][$i], 'T_ARG2' => $class_name1,'T_ARG3' => $class_name2, 'T_ARG4' => ($arrOrderDetail['quantity'][$i] + $arrProduct['stock'])));
            }
        }

        // 消費税
        $arrValues['tax'] = $totaltax;
        // 小計
        $arrValues['subtotal'] = $subtotal;
        // 合計
        $arrValues['total'] = $subtotal - $arrValues['discount'] + $arrValues['deliv_fee'] + $arrValues['charge'];
        // お支払い合計
        $arrValues['payment_total'] = $arrValues['total'] - ($arrValues['use_point'] * POINT_VALUE);

        // 加算ポイント
        $arrValues['add_point'] = SC_Helper_DB_Ex::sfGetAddPoint($totalpoint, $arrValues['use_point']);

        // 最終保持ポイント
        $arrValues['total_point'] = $objFormParam->getValue('point') - $arrValues['use_point'];

        if ($arrValues['total'] < 0) {
            $arrErr['total'] = t('c_Adjust so that the total amount is not a negative number.<br />_01');
        }

        if ($arrValues['payment_total'] < 0) {
            $arrErr['payment_total'] = t('c_Adjust so that a negative number is not displayed for the payment total.<br />_01');
        }

        if ($arrValues['total_point'] < 0) {
            $arrErr['use_point'] = t('c_Adjust the final number of points registered so that it does not become a negative number.<br />_01');
        }

        $objFormParam->setParam($arrValues);
        return $arrErr;
    }

    /**
     * DB更新処理
     *
     * @param integer $order_id 受注ID
     * @param SC_Helper_Purchase $objPurchase SC_Helper_Purchase インスタンス
     * @param SC_FormParam $objFormParam SC_FormParam インスタンス
     * @param string $message 通知メッセージ
     * @param array $arrValuesBefore 更新前の受注情報
     * @return integer $order_id 受注ID
     *
     * エラー発生時は負数を返す。
     */
    function doRegister($order_id, &$objPurchase, &$objFormParam, &$message, &$arrValuesBefore) {

        $objQuery =& SC_Query_Ex::getSingletonInstance();
        $arrValues = $objFormParam->getDbArray();

        if (!SC_Utils_Ex::isBlank($objFormParam->getValue('year'))) {
            $arrValues['start_date'] = $objFormParam->getValue('year') . '/'
                . $objFormParam->getValue('month') . '/'
                    . $objFormParam->getValue('day')
                    . ' 00:00:00';
        }

        if (!SC_Utils_Ex::isBlank($objFormParam->getValue('fly_hour'))) {
            $arrValues['start_time'] = $objFormParam->getValue('fly_hour') . ':'
                . $objFormParam->getValue('fly_minute') . ':00';
        }

        if (!SC_Utils_Ex::isBlank($objFormParam->getValue('due_date_year'))) {
            $arrValues['due_date'] = $objFormParam->getValue('due_date_year') . '/'
                . $objFormParam->getValue('due_date_month') . '/'
                    . $objFormParam->getValue('due_date_day')
                    . ' 00:00:00';
        }

        if (!SC_Utils_Ex::isBlank($objFormParam->getValue('due_date_hour'))) {
            $arrValues['due_time'] = $objFormParam->getValue('due_date_hour') . ':'
                . $objFormParam->getValue('due_date_min') . ':00';
        }

        $where = 'order_id = ?';

        $objQuery->begin();

        // 支払い方法が変更されたら、支払い方法名称も更新
        if ($arrValues['payment_id'] != $arrValuesBefore['payment_id']) {
            $arrValues['payment_method'] = $this->arrPayment[$arrValues['payment_id']];
            $arrValuesBefore['payment_id'] = NULL;
        }

        // 受注テーブルの更新
        $order_id = $objPurchase->registerOrder($order_id, $arrValues);
        $objQuery->commit();
        return $order_id;
    }

    /**
     * 受注商品の追加/更新を行う.
     *
     * 小画面で選択した受注商品をフォームに反映させる.
     *
     * @param SC_FormParam $objFormParam SC_FormParam インスタンス
     * @return void
     */
    function doRegisterProduct(&$objFormParam) {
        $product_class_id = $objFormParam->getValue('add_product_class_id');
        if (SC_Utils_Ex::isBlank($product_class_id)) {
            $product_class_id = $objFormParam->getValue('edit_product_class_id');
            $changed_no = $objFormParam->getValue('no');
        }
        // FXIME バリデーションを通さず $objFormParam の値で DB 問い合わせしている。(管理機能ため、さほど問題は無いと思うものの…)

        // 商品規格IDが指定されていない場合、例外エラーを発生
        if (strlen($product_class_id) === 0) {
            trigger_error('商品規格指定なし', E_USER_ERROR);
        }

        // 選択済みの商品であれば数量を1増やす
        $exists = false;
        $arrExistsProductClassIds = $objFormParam->getValue('product_class_id');
        foreach ($arrExistsProductClassIds as $key => $value) {
            $exists_product_class_id = $arrExistsProductClassIds[$key];
            if ($exists_product_class_id == $product_class_id) {
                $exists = true;
                $exists_no = $key;
                $arrExistsQuantity = $objFormParam->getValue('quantity');
                $arrExistsQuantity[$key]++;
                $objFormParam->setValue('quantity', $arrExistsQuantity);
            }
        }

        // 新しく商品を追加した場合はフォームに登録
        // 商品を変更した場合は、該当行を変更
        if (!$exists) {
            $objProduct = new SC_Product_Ex();
            $arrProduct = $objProduct->getDetailAndProductsClass($product_class_id);

            // 一致する商品規格がない場合、例外エラーを発生
            if (empty($arrProduct)) {
                trigger_error('商品規格一致なし', E_USER_ERROR);
            }

            $arrProduct['quantity'] = 1;
            $arrProduct['price'] = $arrProduct['price02'];
            $arrProduct['product_name'] = $arrProduct['name'];

            $arrUpdateKeys = array(
                'product_id', 'product_class_id', 'product_type_id', 'point_rate',
                'product_code', 'product_name', 'classcategory_name1', 'classcategory_name2',
                'quantity', 'price',
            );
            foreach ($arrUpdateKeys as $key) {
                $arrValues = $objFormParam->getValue($key);
                // FIXME getValueで文字列が返る場合があるので配列であるかをチェック
                if (!is_array($arrValues)) {
                    $arrValues = array();
                }

                if (isset($changed_no)) {
                    $arrValues[$changed_no] = $arrProduct[$key];
                } else {
                    $added_no = 0;
                    if (is_array($arrExistsProductClassIds)) {
                        $added_no = count($arrExistsProductClassIds);
                    }
                    $arrValues[$added_no] = $arrProduct[$key];
                }
                $objFormParam->setValue($key, $arrValues);
            }
        } elseif (isset($changed_no) && $exists_no != $changed_no) {
            // 変更したが、選択済みの商品だった場合は、変更対象行を削除。
            $this->doDeleteProduct($changed_no, $objFormParam);
        }
    }

    /**
     * 受注商品を削除する.
     *
     * @param integer $delete_no 削除する受注商品の項番
     * @param SC_FormParam $objFormParam SC_FormParam インスタンス
     * @return void
     */
    function doDeleteProduct($delete_no, &$objFormParam) {
        $arrDeleteKeys = array(
            'product_id', 'product_class_id', 'product_type_id', 'point_rate',
            'product_code', 'product_name', 'classcategory_name1', 'classcategory_name2',
            'quantity', 'price',
        );
        foreach ($arrDeleteKeys as $key) {
            $arrNewValues = array();
            $arrValues = $objFormParam->getValue($key);
            foreach ($arrValues as $index => $val) {
                if ($index != $delete_no) {
                    $arrNewValues[] = $val;
                }
            }
            $objFormParam->setValue($key, $arrNewValues);
        }
    }

    /**
     * お届け先を追加する.
     *
     * @param SC_FormParam $objFormParam SC_FormParam インスタンス
     * @return void
     */
    function addShipping(&$objFormParam) {
        $objFormParam->setValue('shipping_quantity',
                                $objFormParam->getValue('shipping_quantity') + 1);
        $arrShippingIds = $objFormParam->getValue('shipping_id');
        $arrShippingIds[] = max($arrShippingIds) + 1;
        $objFormParam->setValue('shipping_id', $arrShippingIds);
    }

    /**
     * 会員情報をフォームに設定する.
     *
     * @param integer $customer_id 会員ID
     * @param SC_FormParam $objFormParam SC_FormParam インスタンス
     * @return void
     */
    function setCustomerTo($customer_id, &$objFormParam) {
        $arrCustomer = SC_Helper_Customer_Ex::sfGetCustomerDataFromId($customer_id);
        foreach ($arrCustomer as $key => $val) {
            $objFormParam->setValue('order_' . $key, $val);
        }
        $objFormParam->setValue('customer_id', $customer_id);
        $objFormParam->setValue('message', $arrCustomer['note']);
    }

    /**
     * アンカーキーを取得する.
     *
     * @param SC_FormParam $objFormParam SC_FormParam インスタンス
     * @return アンカーキーの文字列
     */
    function getAnchorKey(&$objFormParam) {
        $ancor_key = $objFormParam->getValue('anchor_key');
        $is_export = $objFormParam->getValue('is_export');
        if (!SC_Utils_Ex::isBlank($ancor_key)) {
            return "location.hash='#" . htmlentities(urlencode($ancor_key), ENT_QUOTES) . "'";
        }
        if ($is_export) {
            return "fnCheckIsExport('" . DISABLED_RGB . "');";
        }
        return "";
    }
}
