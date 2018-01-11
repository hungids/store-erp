ALTER TABLE `dtb_customer`
    CHANGE COLUMN `email` `email` TEXT NULL,
    CHANGE COLUMN `status` `status` SMALLINT(6) NOT NULL DEFAULT '2',
    CHANGE COLUMN `point` `point` DECIMAL(10,0) NULL DEFAULT '0',
    ADD COLUMN `tel` TEXT NULL DEFAULT NULL;
-- Bảng trạng thái thanh toán
CREATE TABLE IF NOT EXISTS `mtb_payments_status` (
  `id` smallint(6) NOT NULL,
  `name` text,
  `rank` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DELETE FROM `mtb_payments_status`;

/*!40000 ALTER TABLE `mtb_order_status` DISABLE KEYS */;

INSERT INTO `mtb_payments_status` (`id`, `name`, `rank`) VALUES

    (1, 'TAIKHOANMOMO', 12),
    (2, 'VPBANKCAT', 1),
    (3, 'VIETTINBANK', 2),
    (4, 'BIDVBANK', 3),
    (5, 'DONGABANK', 4),
    (6, 'TECKCOMBANK', 5),
    (7, 'HDBANKCAT', 6),
    (8, 'SACOMBANK', 7),
    (9, 'AGRBANK', 8),
    (10, 'ACBBANK', 9),
    (11, 'VIETCOMBANK', 10),
    (12, 'TIENMATVP', 11),
    (13, 'Chờ thanh toán', 0),
    (14, 'SẾP DUYỆT CHO NỢ', 13);

-- Bảng vé
ALTER TABLE `dtb_order`
    ADD COLUMN `start_date` DATETIME NULL,
    ADD COLUMN `start_time` TIME NULL DEFAULT NULL,
    ADD COLUMN `order_code` TEXT NULL DEFAULT NULL,
    ADD COLUMN `order_dept` TEXT NULL AFTER `order_code`,
    ADD COLUMN `order_arriv` TEXT NULL AFTER `order_dept`,
    ADD COLUMN `number_pax` TEXT NULL AFTER `order_arriv`,
    ADD COLUMN `price_net` TEXT NULL AFTER `number_pax`,
    ADD COLUMN `price_sale` TEXT NULL AFTER `price_net`,
    ADD COLUMN `earning` TEXT NULL AFTER `price_sale`,
    ADD COLUMN `payment_status` TEXT NULL AFTER `earning`,
    ADD COLUMN `due_day` TEXT NULL AFTER `payment_status`,
    ADD COLUMN `order_tel` TEXT NULL AFTER `due_day`,
    ADD COLUMN `creator_id` INT NULL AFTER `order_tel`,
    ADD COLUMN `debt_status` INT(11) NULL DEFAULT '2' AFTER `creator_id`,
    ADD COLUMN `debt_amount` INT(11) NULL EFAULT '0' AFTER `debt_status`;

-- Bảng member
ALTER TABLE `dtb_member`
    ADD COLUMN `tel` TEXT NULL AFTER `login_date`,
    ADD COLUMN `addr` TEXT NULL AFTER `tel`;

-- Bảng trạng thái nợ
CREATE TABLE IF NOT EXISTS `mtb_debt_status` (
  `id` smallint(6) NOT NULL,
  `name` text,
  `rank` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DELETE FROM `mtb_debt_status`;

/*!40000 ALTER TABLE `mtb_order_status` DISABLE KEYS */;

INSERT INTO `mtb_debt_status` (`id`, `name`, `rank`) VALUES

    (1, 'Còn Nợ', 0),
    (2, 'Thanh Toán Đủ', 1);