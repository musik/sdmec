CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) DEFAULT NULL,
  `parent_cid` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_parent` tinyint(1) DEFAULT NULL,
  `children_fetched` tinyint(1) DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `lft` int(11) DEFAULT NULL,
  `rgt` int(11) DEFAULT NULL,
  `depth` int(11) DEFAULT NULL,
  `display` tinyint(1) DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `nicename` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `keywords` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `priority` int(11) DEFAULT '5',
  PRIMARY KEY (`id`),
  KEY `index_categories_on_cid` (`cid`),
  KEY `plr` (`parent_id`,`lft`,`rgt`),
  KEY `index_categories_on_slug` (`slug`),
  KEY `display_with_priority` (`display`,`priority`)
) ENGINE=InnoDB AUTO_INCREMENT=29610 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `cats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `oid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `lft` int(11) DEFAULT NULL,
  `rgt` int(11) DEFAULT NULL,
  `depth` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_cats_on_name` (`name`),
  KEY `index_cats_on_slug` (`slug`),
  KEY `index_cats_on_parent_id` (`parent_id`),
  KEY `lft_rgt` (`lft`,`rgt`)
) ENGINE=InnoDB AUTO_INCREMENT=616 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `cities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `use_subdomain` tinyint(1) DEFAULT NULL,
  `zhixiashi` tinyint(1) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=392 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `commentable_id` int(11) DEFAULT '0',
  `commentable_type` varchar(255) DEFAULT '',
  `title` varchar(255) DEFAULT '',
  `body` text,
  `subject` varchar(255) DEFAULT '',
  `user_id` int(11) NOT NULL DEFAULT '0',
  `parent_id` int(11) DEFAULT NULL,
  `lft` int(11) DEFAULT NULL,
  `rgt` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `guest_name` varchar(255) DEFAULT NULL,
  `guest_email` varchar(255) DEFAULT NULL,
  `guest_website` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_comments_on_user_id` (`user_id`),
  KEY `index_comments_on_commentable_id` (`commentable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

CREATE TABLE `cts` (
  `city_id` int(11) DEFAULT NULL,
  `topic_id` int(11) DEFAULT NULL,
  `items_count` int(11) DEFAULT NULL,
  `itemsdata` text COLLATE utf8_unicode_ci,
  `fetched` tinyint(1) DEFAULT NULL,
  `fetched_at` datetime DEFAULT NULL,
  KEY `index_cts_on_city_id_and_topic_id` (`city_id`,`topic_id`),
  KEY `index_cts_on_items_count` (`items_count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `daches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `context_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `context_id` int(11) DEFAULT NULL,
  `value` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_daches_on_context_type_and_context_id` (`context_type`,`context_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `delayed_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `priority` int(11) DEFAULT '0',
  `attempts` int(11) DEFAULT '0',
  `handler` text COLLATE utf8_unicode_ci,
  `last_error` text COLLATE utf8_unicode_ci,
  `run_at` datetime DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `failed_at` datetime DEFAULT NULL,
  `locked_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `queue` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `delayed_jobs_priority` (`priority`,`run_at`)
) ENGINE=InnoDB AUTO_INCREMENT=389372 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `huatis` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `acr` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `acr2` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `published` tinyint(1) DEFAULT NULL,
  `priority` int(11) DEFAULT '0',
  `delta` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `index_huatis_on_slug` (`slug`),
  KEY `index_huatis_on_name` (`name`),
  KEY `index_huatis_on_published` (`published`),
  KEY `index_huatis_on_priority` (`priority`)
) ENGINE=InnoDB AUTO_INCREMENT=40401 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `price` decimal(10,0) DEFAULT NULL,
  `commission` decimal(10,0) DEFAULT NULL,
  `commission_num` int(11) DEFAULT NULL,
  `commission_rate` int(11) DEFAULT NULL,
  `commission_volume` decimal(10,0) DEFAULT NULL,
  `item_location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `nick` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `num_iid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `seller_credit_score` int(11) DEFAULT NULL,
  `volume` int(11) DEFAULT NULL,
  `pic_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `click_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shop_click_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cid` int(11) DEFAULT NULL,
  `delist_time` datetime DEFAULT NULL,
  `desc` text COLLATE utf8_unicode_ci,
  `detail_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location_city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `express_fee` decimal(10,0) DEFAULT NULL,
  `item_imgs` blob,
  `sell_promise` tinyint(1) DEFAULT NULL,
  `detail_updated_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_items_on_num_iid` (`num_iid`),
  KEY `index_items_on_cid` (`cid`),
  KEY `index_items_on_price` (`price`),
  KEY `index_items_on_commission` (`commission`),
  KEY `index_items_on_commission_num` (`commission_num`),
  KEY `index_items_on_commission_rate` (`commission_rate`),
  KEY `index_items_on_commission_volume` (`commission_volume`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` text COLLATE utf8_unicode_ci,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `page_views` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `viewable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `viewable_id` int(11) DEFAULT NULL,
  `user_agent` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `referer` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `visitor_hash` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `viewable` (`viewable_type`,`viewable_id`),
  KEY `created_at` (`created_at`),
  KEY `visitor` (`visitor_hash`)
) ENGINE=InnoDB AUTO_INCREMENT=50141 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `rails_admin_histories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` text,
  `username` varchar(255) DEFAULT NULL,
  `item` int(11) DEFAULT NULL,
  `table` varchar(255) DEFAULT NULL,
  `month` smallint(6) DEFAULT NULL,
  `year` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_rails_admin_histories` (`item`,`table`,`month`,`year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `resource_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_roles_on_name_and_resource_type_and_resource_id` (`name`,`resource_type`,`resource_id`),
  KEY `index_roles_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `stores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `city_id` int(11) DEFAULT NULL,
  `seller_credit` int(11) DEFAULT NULL,
  `shop_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `click_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `commission_rate` decimal(10,0) DEFAULT NULL,
  `total_auction` int(11) DEFAULT NULL,
  `auction_count` int(11) DEFAULT NULL,
  `sid` int(11) DEFAULT NULL,
  `cid` int(11) DEFAULT NULL,
  `nick` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `desc` text COLLATE utf8_unicode_ci,
  `bulletin` text COLLATE utf8_unicode_ci,
  `pic_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `delivery_score` decimal(10,0) DEFAULT NULL,
  `item_score` decimal(10,0) DEFAULT NULL,
  `service_score` decimal(10,0) DEFAULT NULL,
  `taoke_updated_at` datetime DEFAULT NULL,
  `shop_updated_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `buyer_credit` int(11) DEFAULT NULL,
  `hangye` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `seller_rate` decimal(10,0) DEFAULT NULL,
  `extra_data` blob,
  `user_updated_at` datetime DEFAULT NULL,
  `comments_updated_at` datetime DEFAULT NULL,
  `seller_score` int(11) DEFAULT NULL,
  `delta` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_stores_on_city_id` (`city_id`),
  KEY `index_stores_on_cid` (`cid`),
  KEY `index_stores_on_nick` (`nick`),
  KEY `index_stores_on_seller_credit` (`seller_credit`),
  KEY `index_stores_on_commission_rate` (`commission_rate`),
  KEY `index_stores_on_total_auction` (`total_auction`),
  KEY `index_stores_on_taoke_updated_at` (`taoke_updated_at`),
  KEY `index_stores_on_shop_updated_at` (`shop_updated_at`),
  KEY `index_stores_on_user_updated_at` (`user_updated_at`),
  KEY `index_stores_on_comments_updated_at` (`comments_updated_at`),
  KEY `index_stores_on_seller_score` (`seller_score`),
  KEY `index_stores_on_delta` (`delta`)
) ENGINE=InnoDB AUTO_INCREMENT=54711 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `tbpages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tburl` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_fetched_at` datetime DEFAULT NULL,
  `tagid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `tcs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `topic_id` int(11) DEFAULT NULL,
  `city_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_tcs_on_topic_id` (`topic_id`),
  KEY `index_tcs_on_city_id` (`city_id`)
) ENGINE=InnoDB AUTO_INCREMENT=38872 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `topics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `volume` int(11) DEFAULT NULL,
  `acr` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `acr2` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `items_updated_at` datetime DEFAULT NULL,
  `public` tinyint(1) DEFAULT NULL,
  `delta` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `index_topics_on_acr` (`acr`),
  KEY `index_topics_on_acr2` (`acr2`),
  KEY `index_topics_on_volume` (`volume`),
  KEY `index_topics_on_public` (`public`),
  KEY `name` (`name`),
  KEY `slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=114221 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `users_roles` (
  `user_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  KEY `index_users_roles_on_user_id_and_role_id` (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `item_id` int(11) NOT NULL,
  `event` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `whodunnit` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `object` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_versions_on_item_type_and_item_id` (`item_type`,`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('20120506034414');

INSERT INTO schema_migrations (version) VALUES ('20120506034423');

INSERT INTO schema_migrations (version) VALUES ('20120506034428');

INSERT INTO schema_migrations (version) VALUES ('20120506053331');

INSERT INTO schema_migrations (version) VALUES ('20120506054831');

INSERT INTO schema_migrations (version) VALUES ('20120508094847');

INSERT INTO schema_migrations (version) VALUES ('20120509062458');

INSERT INTO schema_migrations (version) VALUES ('20120509081656');

INSERT INTO schema_migrations (version) VALUES ('20120510160542');

INSERT INTO schema_migrations (version) VALUES ('20120511031246');

INSERT INTO schema_migrations (version) VALUES ('20120519060624');

INSERT INTO schema_migrations (version) VALUES ('20120522063605');

INSERT INTO schema_migrations (version) VALUES ('20120525054218');

INSERT INTO schema_migrations (version) VALUES ('20120605085411');

INSERT INTO schema_migrations (version) VALUES ('20120607070432');

INSERT INTO schema_migrations (version) VALUES ('20120608070926');

INSERT INTO schema_migrations (version) VALUES ('20120611171956');

INSERT INTO schema_migrations (version) VALUES ('20120705083525');

INSERT INTO schema_migrations (version) VALUES ('20120715142737');

INSERT INTO schema_migrations (version) VALUES ('20120718041320');

INSERT INTO schema_migrations (version) VALUES ('20120718054938');

INSERT INTO schema_migrations (version) VALUES ('20120718110429');

INSERT INTO schema_migrations (version) VALUES ('20120729082919');

INSERT INTO schema_migrations (version) VALUES ('20120729083122');

INSERT INTO schema_migrations (version) VALUES ('20120801151659');

INSERT INTO schema_migrations (version) VALUES ('20120824055023');

INSERT INTO schema_migrations (version) VALUES ('20120824074704');

INSERT INTO schema_migrations (version) VALUES ('20120927110050');

INSERT INTO schema_migrations (version) VALUES ('20120929135716');

INSERT INTO schema_migrations (version) VALUES ('20121007082224');

INSERT INTO schema_migrations (version) VALUES ('20121009074006');

INSERT INTO schema_migrations (version) VALUES ('20121026124701');

INSERT INTO schema_migrations (version) VALUES ('20121026142713');

INSERT INTO schema_migrations (version) VALUES ('20121027093115');

INSERT INTO schema_migrations (version) VALUES ('20121027134503');

INSERT INTO schema_migrations (version) VALUES ('20121108030548');

INSERT INTO schema_migrations (version) VALUES ('20121113112343');

INSERT INTO schema_migrations (version) VALUES ('20121113150538');