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
require_once CLASS_EX_REALDIR . 'page_extends/admin/LC_Page_Admin_Ex.php';

/**
 * 受注管理 のページクラス
 *
 * @package Page
 * @author LOCKON CO.,LTD.
 * @version $Id: LC_Page_Admin_Order.php 22509 2013-02-06 12:08:56Z kim $
 */
class LC_Page_Admin_Account_Ex extends LC_Page_Admin_Ex {

    // }}}
    // {{{ functions

    /**
     * Page を初期化する.
     *
     * @return void
     */
    function init() {
        parent::init();
        $this->tpl_mainpage = 'accountant/index.tpl';
        $this->tpl_mainno = 'accountant';
        $this->tpl_subno = 'index';
        $this->tpl_pager = 'pager.tpl';
        $this->tpl_maintitle = t('Kế Toán');
        $this->tpl_subtitle = t('Doanh Thu');

        $masterData = new SC_DB_MasterData_Ex();
        $this->arrORDERSTATUS = $masterData->getMasterData('mtb_order_status');
        $this->arrORDERSTATUS_COLOR = $masterData->getMasterData('mtb_order_status_color');
        $this->arrSex = $masterData->getMasterData('mtb_sex');
        $this->arrPageMax = $masterData->getMasterData('mtb_page_max');
        $this->arrPaymentStatus = $masterData->getMasterData('mtb_payments_status');
        $this->arrDebtStatus = $masterData->getMasterData('mtb_debt_status');
        $this->arrMembers = SC_Helper_DB_Ex::sfGetIDValueList('dtb_member', 'member_id', "name");
        unset($this->arrMembers[2]);

        $objDate = new SC_Date_Ex();
        // 登録・更新日検索用
        $objDate->setStartYear(RELEASE_YEAR);
        $objDate->setEndYear(DATE('Y'));
        $this->arrRegistYear = $objDate->getYear();
        // 生年月日検索用
        $objDate->setStartYear(BIRTH_YEAR);
        $objDate->setEndYear(DATE('Y'));
        $this->arrBirthYear = $objDate->getYear();
        // 月日の設定
        $this->arrMonth = $objDate->getMonth();
        $this->arrDay = $objDate->getDay();
        $this->arrHour = $objDate->getHour(true);
        $this->arrMinutes = $objDate->getMinutes(true);

        // 支払い方法の取得
        $this->arrPayments = SC_Helper_DB_Ex::sfGetIDValueList('dtb_payment', 'payment_id', 'payment_method');

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

        $objFormParam = new SC_FormParam_Ex();
        $this->lfInitParam($objFormParam);
        $objFormParam->setParam($_POST);
        $this->arrHidden = $objFormParam->getSearchArray();
        $this->arrForm = $objFormParam->getFormParamList();
        $this->totalAccounting();

        switch ($this->getMode()) {
            // 削除
            case 'delete':
                $this->doDelete('order_id = ?',
                                array($objFormParam->getValue('order_id')));
                // 削除後に検索結果を表示するため breakしない

            // 検索パラメーター生成後に処理実行するため breakしない
            case 'csv':
            case 'delete_all':

            // 検索パラメーターの生成
            case 'search':
                $objFormParam->convParam();
                $objFormParam->trimParam();
                $this->arrErr = $this->lfCheckError($objFormParam);
                $arrParam = $objFormParam->getHashArray();

                if (count($this->arrErr) == 0) {
                    $where = 'del_flg = 0';
                    $arrWhereVal = array();
                    foreach ($arrParam as $key => $val) {
                        if ($val == '') {
                            continue;
                        }
                        $this->buildQuery($key, $where, $arrWhereVal, $objFormParam);
                    }

                    $order = 'update_date DESC';

                    /* -----------------------------------------------
                     * 処理を実行
                     * ----------------------------------------------- */
                    switch ($this->getMode()) {
                        // CSVを送信する。
                        case 'csv':
                            $this->doOutputCSV($where, $arrWhereVal, $order);

                            SC_Response_Ex::actionExit();
                            break;

                        // 全件削除(ADMIN_MODE)
                        case 'delete_all':
                            $this->doDelete($where, $arrWhereVal);
                            break;

                        // 検索実行
                        default:
                            // 行数の取得
                            $this->tpl_linemax = $this->getNumberOfLines($where, $arrWhereVal);
                            // ページ送りの処理
                            $page_max = SC_Utils_Ex::sfGetSearchPageMax($objFormParam->getValue('search_page_max'));
                            // ページ送りの取得
                            $objNavi = new SC_PageNavi_Ex($this->arrHidden['search_pageno'],
                                                          $this->tpl_linemax, $page_max,
                                                          'fnNaviSearchPage', NAVI_PMAX);
                            $this->arrPagenavi = $objNavi->arrPagenavi;

                            // 検索結果の取得
                            $this->arrResults = $this->findOrders($where, $arrWhereVal,
                                                                  $page_max, $objNavi->start_row, $order);
                            $this->sfCalAccounting($this->arrResults);
                            break;
                    }
                }
                break;
            default:
                break;
        }

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
        $objFormParam->addParam(t('CODE'), 'search_order_code', STEXT_LEN, 'KVa', array('MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('c_Order number 1_01'), 'search_order_id1', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam(t('c_Order number 2_01'), 'search_order_id2', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam(t('Trạng Thái'), 'search_order_status', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam(t('NV Đặt'), 'search_order_member', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam(t('Tên Khách Hàng'), 'search_order_name', STEXT_LEN, 'KVa', array('MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('c_Gender_01'), 'search_order_sex', INT_LEN, 'n', array('MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Email'), 'search_order_email', STEXT_LEN, 'KVa', array('MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Số Điện Thoại'), 'search_order_tel', STEXT_LEN, 'KVa', array('MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('Nợ'), 'search_order_debt', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam(t('Thanh Toán'), 'search_payments_status', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam(t('c_Number of items displayed_01'), 'search_page_max', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'));
        // 生年月日
        $objFormParam->addParam(t('c_Start year_01'), 'search_sbirthyear', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam(t('c_Start month_01'), 'search_sbirthmonth', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam(t('c_Start day_01'), 'search_sbirthday', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam(t('c_Completion year_01'), 'search_ebirthyear', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam(t('c_Completion month_01'), 'search_ebirthmonth', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam(t('c_Completion date_01'), 'search_ebirthday', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'));

        $objFormParam->addParam(t('Giờ bắt đầu'), 'search_shour', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam(t('Phút bắt đầu'), 'search_sminute', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam(t('Giờ kết thúc'), 'search_ehour', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam(t('Phút kết thúc'), 'search_eminute', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'));

        $objFormParam->addParam(t('c_Purchased product_01'),'search_product_name',STEXT_LEN,'KVa',array('MAX_LENGTH_CHECK'));
        $objFormParam->addParam(t('c_Page feed number_01'),'search_pageno', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam(t('c_Order ID_01'), 'order_id', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'));
    }

    /**
     * 入力内容のチェックを行う.
     *
     * @param SC_FormParam $objFormParam SC_FormParam インスタンス
     * @return void
     */
    function lfCheckError(&$objFormParam) {
        $objErr = new SC_CheckError_Ex($objFormParam->getHashArray());
        $objErr->arrErr = $objFormParam->checkError();

        // 相関チェック
        $objErr->doFunc(array(t('c_Order number 1_01'), t('c_Order number 2_01'), 'search_order_id1', 'search_order_id2'), array('GREATER_CHECK'));
        $objErr->doFunc(array(t('c_Age 1_01'), t('c_Age 2_01'), 'search_age1', 'search_age2'), array('GREATER_CHECK'));
        $objErr->doFunc(array(t('c_Purchase amount 1_01'), t('c_Purchase amount 2_01'), 'search_total1', 'search_total2'), array('GREATER_CHECK'));
        // 受注日
        $objErr->doFunc(array(t('c_Start_01'), 'search_sorderyear', 'search_sordermonth', 'search_sorderday'), array('CHECK_DATE'));
        $objErr->doFunc(array(t('c_Complete_01'), 'search_eorderyear', 'search_eordermonth', 'search_eorderday'), array('CHECK_DATE'));
        $objErr->doFunc(array(t('c_Start_01'), t('c_Complete_01'), 'search_sorderyear', 'search_sordermonth', 'search_sorderday', 'search_eorderyear', 'search_eordermonth', 'search_eorderday'), array('CHECK_SET_TERM'));
        // 更新日
        $objErr->doFunc(array(t('c_Start_01'), 'search_supdateyear', 'search_supdatemonth', 'search_supdateday'), array('CHECK_DATE'));
        $objErr->doFunc(array(t('c_Complete_01'), 'search_eupdateyear', 'search_eupdatemonth', 'search_eupdateday'), array('CHECK_DATE'));
        $objErr->doFunc(array(t('c_Start_01'), t('c_Complete_01'), 'search_supdateyear', 'search_supdatemonth', 'search_supdateday', 'search_eupdateyear', 'search_eupdatemonth', 'search_eupdateday'), array('CHECK_SET_TERM'));
        // 生年月日
        $objErr->doFunc(array(t('c_Start_01'), 'search_sbirthyear', 'search_sbirthmonth', 'search_sbirthday'), array('CHECK_DATE'));
        $objErr->doFunc(array(t('c_Complete_01'), 'search_ebirthyear', 'search_ebirthmonth', 'search_ebirthday'), array('CHECK_DATE'));
        $objErr->doFunc(array(t('c_Start_01'), t('c_Complete_01'), 'search_sbirthyear', 'search_sbirthmonth', 'search_sbirthday', 'search_ebirthyear', 'search_ebirthmonth', 'search_ebirthday'), array('CHECK_SET_TERM'));

        return $objErr->arrErr;
    }

    /**
     * クエリを構築する.
     *
     * 検索条件のキーに応じた WHERE 句と, クエリパラメーターを構築する.
     * クエリパラメーターは, SC_FormParam の入力値から取得する.
     *
     * 構築内容は, 引数の $where 及び $arrValues にそれぞれ追加される.
     *
     * @param string $key 検索条件のキー
     * @param string $where 構築する WHERE 句
     * @param array $arrValues 構築するクエリパラメーター
     * @param SC_FormParam $objFormParam SC_FormParam インスタンス
     * @return void
     */
    function buildQuery($key, &$where, &$arrValues, &$objFormParam) {
        $dbFactory = SC_DB_DBFactory_Ex::getInstance();
        switch ($key) {

            case 'search_product_name':
                $where .= ' AND EXISTS (SELECT 1 FROM dtb_order_detail od WHERE od.order_id = dtb_order.order_id AND od.product_name LIKE ?)';
                $arrValues[] = sprintf('%%%s%%', $objFormParam->getValue($key));
                break;
            case 'search_order_name':
                $where .= ' AND ' . $dbFactory->concatColumn(array('order_name01', 'order_name02')) . ' LIKE ?';
                $arrValues[] = sprintf('%%%s%%', $objFormParam->getValue($key));
                break;
            case 'search_order_kana':
                $where .= ' AND ' . $dbFactory->concatColumn(array('order_kana01', 'order_kana02')) . ' LIKE ?';
                $arrValues[] = sprintf('%%%s%%', $objFormParam->getValue($key));
                break;
            case 'search_order_id1':
                $where .= ' AND order_id >= ?';
                $arrValues[] = sprintf('%d', $objFormParam->getValue($key));
                break;
            case 'search_order_id2':
                $where .= ' AND order_id <= ?';
                $arrValues[] = sprintf('%d', $objFormParam->getValue($key));
                break;
            case 'search_order_sex':
                $tmp_where = '';
                foreach ($objFormParam->getValue($key) as $element) {
                    if ($element != '') {
                        if (SC_Utils_Ex::isBlank($tmp_where)) {
                            $tmp_where .= ' AND (order_sex = ?';
                        } else {
                            $tmp_where .= ' OR order_sex = ?';
                        }
                        $arrValues[] = $element;
                    }
                }

                if (!SC_Utils_Ex::isBlank($tmp_where)) {
                    $tmp_where .= ')';
                    $where .= " $tmp_where ";
                }
                break;
            case 'search_order_tel':
                $where .= ' AND (order_tel LIKE ?)';
                $arrValues[] = sprintf('%%%d%%', preg_replace('/[()-]+/','', $objFormParam->getValue($key)));
                break;
            case 'search_order_email':
                $where .= ' AND order_email LIKE ?';
                $arrValues[] = sprintf('%%%s%%', $objFormParam->getValue($key));
                break;
            case 'search_order_code':
                $where .= ' AND order_code LIKE ?';
                $arrValues[] = sprintf('%%%s%%', $objFormParam->getValue($key));
                break;
            case 'search_order_debt':
                $where .= ' AND debt_status = ?';
                $arrValues[] = sprintf('%d', $objFormParam->getValue($key));
                break;
            case 'search_payment_id':
                $tmp_where = '';
                foreach ($objFormParam->getValue($key) as $element) {
                    if ($element != '') {
                        if ($tmp_where == '') {
                            $tmp_where .= ' AND (payment_id = ?';
                        } else {
                            $tmp_where .= ' OR payment_id = ?';
                        }
                        $arrValues[] = $element;
                    }
                }

                if (!SC_Utils_Ex::isBlank($tmp_where)) {
                    $tmp_where .= ')';
                    $where .= " $tmp_where ";
                }
                break;
            case 'search_total1':
                $where .= ' AND total >= ?';
                $arrValues[] = sprintf('%d', $objFormParam->getValue($key));
                break;
            case 'search_total2':
                $where .= ' AND total <= ?';
                $arrValues[] = sprintf('%d', $objFormParam->getValue($key));
                break;
            case 'search_sorderyear':
                $date = SC_Utils_Ex::sfGetTimestamp($objFormParam->getValue('search_sorderyear'),
                                                    $objFormParam->getValue('search_sordermonth'),
                                                    $objFormParam->getValue('search_sorderday'));
                $where.= ' AND create_date >= ?';
                $arrValues[] = $date;
                break;
            case 'search_eorderyear':
                $date = SC_Utils_Ex::sfGetTimestamp($objFormParam->getValue('search_eorderyear'),
                                                    $objFormParam->getValue('search_eordermonth'),
                                                    $objFormParam->getValue('search_eorderday'), true);
                $where.= ' AND create_date <= ?';
                $arrValues[] = $date;
                break;
            case 'search_supdateyear':
                $date = SC_Utils_Ex::sfGetTimestamp($objFormParam->getValue('search_supdateyear'),
                                                    $objFormParam->getValue('search_supdatemonth'),
                                                    $objFormParam->getValue('search_supdateday'));
                $where.= ' AND update_date >= ?';
                $arrValues[] = $date;
                break;
            case 'search_eupdateyear':
                $date = SC_Utils_Ex::sfGetTimestamp($objFormParam->getValue('search_eupdateyear'),
                                                    $objFormParam->getValue('search_eupdatemonth'),
                                                    $objFormParam->getValue('search_eupdateday'), true);
                $where.= ' AND update_date <= ?';
                $arrValues[] = $date;
                break;
            case 'search_sbirthyear':
                $date = SC_Utils_Ex::sfGetTimestamp($objFormParam->getValue('search_sbirthyear'),
                                                    $objFormParam->getValue('search_sbirthmonth'),
                                                    $objFormParam->getValue('search_sbirthday'));
                $where.= ' AND create_date >= ?';
                $arrValues[] = $date;
                break;
            case 'search_ebirthyear':
                $date = SC_Utils_Ex::sfGetTimestamp($objFormParam->getValue('search_ebirthyear'),
                                                    $objFormParam->getValue('search_ebirthmonth'),
                                                    $objFormParam->getValue('search_ebirthday'), true);
                $where.= ' AND create_date <= ?';
                $arrValues[] = $date;
                break;
            case 'search_shour':
                $time = $objFormParam->getValue('search_shour');
                if (!SC_Utils_Ex::isBlank($objFormParam->getValue('search_sminute'))) {
                    $time .= ':' . $objFormParam->getValue('search_sminute') . ':00';
                } else {
                    $time .= ':00:00';
                }
                $where.= ' AND start_time >= ?';
                $arrValues[] = $time;
                break;
            case 'search_ehour':
                $time = $objFormParam->getValue('search_ehour');
                if (!SC_Utils_Ex::isBlank($objFormParam->getValue('search_eminute'))) {
                    $time .= ':' . $objFormParam->getValue('search_eminute') . ':00';
                } else {
                    $time .= ':00:00';
                }
                $where.= ' AND start_time <= ?';
                $arrValues[] = $time;
                break;
            case 'search_order_status':
                $tmp_where = '';
                foreach ($objFormParam->getValue($key) as $element) {
                    if ($element != '') {
                        if ($tmp_where == '') {
                            $tmp_where .= ' AND (status = ?';
                        } else {
                            $tmp_where .= ' OR status = ?';
                        }
                        $arrValues[] = $element;
                    }
                }

                if (!SC_Utils_Ex::isBlank($tmp_where)) {
                    $tmp_where .= ')';
                    $where .= " $tmp_where ";
                }
                break;
            case 'search_order_member':
                $tmp_where = '';
                foreach ($objFormParam->getValue($key) as $element) {
                    if ($element != '') {
                        if ($tmp_where == '') {
                            $tmp_where .= ' AND (creator_id = ?';
                        } else {
                            $tmp_where .= ' OR creator_id = ?';
                        }
                        $arrValues[] = $element;
                    }
                }
                
                if (!SC_Utils_Ex::isBlank($tmp_where)) {
                    $tmp_where .= ')';
                    $where .= " $tmp_where ";
                }
                break;
            case 'search_payments_status':
                $tmp_where = '';
                foreach ($objFormParam->getValue($key) as $element) {
                    if ($element != '') {
                        if ($tmp_where == '') {
                            $tmp_where .= ' AND (payment_status = ?';
                        } else {
                            $tmp_where .= ' OR payment_status = ?';
                        }
                        $arrValues[] = $element;
                    }
                }
                
                if (!SC_Utils_Ex::isBlank($tmp_where)) {
                    $tmp_where .= ')';
                    $where .= " $tmp_where ";
                }
                break;
            default:
                break;
        }
    }

    /**
     * 受注を削除する.
     *
     * @param string $where 削除対象の WHERE 句
     * @param array $arrParam 削除対象の値
     * @return void
     */
    function doDelete($where, $arrParam = array()) {
        $objQuery =& SC_Query_Ex::getSingletonInstance();
        $sqlval['del_flg']     = 1;
        $sqlval['update_date'] = 'CURRENT_TIMESTAMP';
        $objQuery->update('dtb_order', $sqlval, $where, $arrParam);
    }

    /**
     * CSV データを構築して取得する.
     *
     * 構築に成功した場合は, ファイル名と出力内容を配列で返す.
     * 構築に失敗した場合は, false を返す.
     *
     * @param string $where 検索条件の WHERE 句
     * @param array $arrVal 検索条件のパラメーター
     * @param string $order 検索結果の並び順
     * @return void
     */
    function doOutputCSV($where, $arrVal, $order) {
        if ($where != '') {
            $where = " WHERE $where ";
        }

        $objCSV = new SC_Helper_CSV_Ex();
        $objCSV->sfDownloadCsv('3', $where, $arrVal, $order, true);
    }

    /**
     * 検索結果の行数を取得する.
     *
     * @param string $where 検索条件の WHERE 句
     * @param array $arrValues 検索条件のパラメーター
     * @return integer 検索結果の行数
     */
    function getNumberOfLines($where, $arrValues) {
        $objQuery =& SC_Query_Ex::getSingletonInstance();
        return $objQuery->count('dtb_order', $where, $arrValues);
    }

    /**
     * 受注を検索する.
     *
     * @param string $where 検索条件の WHERE 句
     * @param array $arrValues 検索条件のパラメーター
     * @param integer $limit 表示件数
     * @param integer $offset 開始件数
     * @param string $order 検索結果の並び順
     * @return array 受注の検索結果
     */
    function findOrders($where, $arrValues, $limit, $offset, $order) {
        $objQuery =& SC_Query_Ex::getSingletonInstance();
        //$objQuery->setLimitOffset($limit, $offset);
        $objQuery->setOrder($order);
        return $objQuery->select('*', 'dtb_order', $where, $arrValues);
    }

    function totalAccounting() {
        $objQuery =& SC_Query_Ex::getSingletonInstance();
        //検索結果の取得
        $total_income = $objQuery->select('SUM(price_sale) as total_income', 'dtb_order', 'del_flg = 0');
        $this->arrTotalIncome = $total_income[0]['total_income'];
        $total_earn = $objQuery->select('SUM(earning) as total_earning', 'dtb_order', 'del_flg = 0');
        $this->arrTotalEarn = $total_earn[0]['total_earning'];
        $total_debt = $objQuery->select('SUM(debt_amount) as total_debt', 'dtb_order', 'del_flg = 0 AND debt_status = 1');
        $this->arrTotalDebt = $total_debt[0]['total_debt'];
    }

    function sfCalAccounting($arrOrders) {
        $income = 0;
        $earning = 0;
        $debt = 0;
        foreach ($arrOrders as $order) {
            $income += $order['price_sale'];
            $earning += $order['earning'];
            if ($order['debt_status'] == 1) {
                $debt += $order['debt_amount'];
            }
        }
        $this->income = $income;
        $this->earning = $earning;
        $this->debt = $debt;
    }
}
