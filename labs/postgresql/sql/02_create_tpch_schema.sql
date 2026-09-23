-- 02_create_tpch_schema.sql
--
-- Створює окрему PostgreSQL schema `tpch` та вісім таблиць
-- для TPC-H dataset.
--
-- Файл створює лише структуру.
-- Завантаження CSV виконаємо окремим скриптом через COPY.


BEGIN;


-- Окремий namespace для всіх TPC-H об'єктів.
CREATE SCHEMA IF NOT EXISTS tpch AUTHORIZATION lab_user;


-- ============================================================
-- 1. REGION
-- ============================================================

CREATE TABLE tpch.region (
                             r_regionkey INTEGER      NOT NULL,
                             r_name      VARCHAR(25)  NOT NULL,
                             r_comment   VARCHAR(152),

                             CONSTRAINT region_pkey
                                 PRIMARY KEY (r_regionkey)
);


-- ============================================================
-- 2. NATION
-- ============================================================

CREATE TABLE tpch.nation (
                             n_nationkey INTEGER      NOT NULL,
                             n_name      VARCHAR(25)  NOT NULL,
                             n_regionkey INTEGER      NOT NULL,
                             n_comment   VARCHAR(152),

                             CONSTRAINT nation_pkey
                                 PRIMARY KEY (n_nationkey),

                             CONSTRAINT nation_region_fk
                                 FOREIGN KEY (n_regionkey)
                                     REFERENCES tpch.region (r_regionkey)
);


-- ============================================================
-- 3. SUPPLIER
-- ============================================================

CREATE TABLE tpch.supplier (
                               s_suppkey   BIGINT         NOT NULL,
                               s_name      VARCHAR(25)    NOT NULL,
                               s_address   VARCHAR(40)    NOT NULL,
                               s_nationkey INTEGER        NOT NULL,
                               s_phone     VARCHAR(15)    NOT NULL,
                               s_acctbal   NUMERIC(15, 2) NOT NULL,
                               s_comment   VARCHAR(101)   NOT NULL,

                               CONSTRAINT supplier_pkey
                                   PRIMARY KEY (s_suppkey),

                               CONSTRAINT supplier_nation_fk
                                   FOREIGN KEY (s_nationkey)
                                       REFERENCES tpch.nation (n_nationkey)
);


-- ============================================================
-- 4. CUSTOMER
-- ============================================================

CREATE TABLE tpch.customer (
                               c_custkey    BIGINT         NOT NULL,
                               c_name       VARCHAR(25)    NOT NULL,
                               c_address    VARCHAR(40)    NOT NULL,
                               c_nationkey  INTEGER        NOT NULL,
                               c_phone      VARCHAR(15)    NOT NULL,
                               c_acctbal    NUMERIC(15, 2) NOT NULL,
                               c_mktsegment VARCHAR(10)    NOT NULL,
                               c_comment    VARCHAR(117)   NOT NULL,

                               CONSTRAINT customer_pkey
                                   PRIMARY KEY (c_custkey),

                               CONSTRAINT customer_nation_fk
                                   FOREIGN KEY (c_nationkey)
                                       REFERENCES tpch.nation (n_nationkey)
);


-- ============================================================
-- 5. PART
-- ============================================================

CREATE TABLE tpch.part (
                           p_partkey     BIGINT         NOT NULL,
                           p_name        VARCHAR(55)    NOT NULL,
                           p_mfgr        VARCHAR(25)    NOT NULL,
                           p_brand       VARCHAR(10)    NOT NULL,
                           p_type        VARCHAR(25)    NOT NULL,
                           p_size        INTEGER        NOT NULL,
                           p_container   VARCHAR(10)    NOT NULL,
                           p_retailprice NUMERIC(15, 2) NOT NULL,
                           p_comment     VARCHAR(23)    NOT NULL,

                           CONSTRAINT part_pkey
                               PRIMARY KEY (p_partkey)
);


-- ============================================================
-- 6. PARTSUPP
-- ============================================================

CREATE TABLE tpch.partsupp (
                               ps_partkey    BIGINT         NOT NULL,
                               ps_suppkey    BIGINT         NOT NULL,
                               ps_availqty   INTEGER        NOT NULL,
                               ps_supplycost NUMERIC(15, 2) NOT NULL,
                               ps_comment    VARCHAR(199)   NOT NULL,

                               CONSTRAINT partsupp_pkey
                                   PRIMARY KEY (ps_partkey, ps_suppkey),

                               CONSTRAINT partsupp_part_fk
                                   FOREIGN KEY (ps_partkey)
                                       REFERENCES tpch.part (p_partkey),

                               CONSTRAINT partsupp_supplier_fk
                                   FOREIGN KEY (ps_suppkey)
                                       REFERENCES tpch.supplier (s_suppkey)
);


-- ============================================================
-- 7. ORDERS
-- ============================================================

CREATE TABLE tpch.orders (
                             o_orderkey      BIGINT         NOT NULL,
                             o_custkey       BIGINT         NOT NULL,
                             o_orderstatus   VARCHAR(1)     NOT NULL,
                             o_totalprice    NUMERIC(15, 2) NOT NULL,
                             o_orderdate     DATE           NOT NULL,
                             o_orderpriority VARCHAR(15)    NOT NULL,
                             o_clerk         VARCHAR(15)    NOT NULL,
                             o_shippriority  INTEGER        NOT NULL,
                             o_comment       VARCHAR(79)    NOT NULL,

                             CONSTRAINT orders_pkey
                                 PRIMARY KEY (o_orderkey),

                             CONSTRAINT orders_customer_fk
                                 FOREIGN KEY (o_custkey)
                                     REFERENCES tpch.customer (c_custkey)
);


-- ============================================================
-- 8. LINEITEM
-- ============================================================

CREATE TABLE tpch.lineitem (
                               l_orderkey      BIGINT         NOT NULL,
                               l_partkey       BIGINT         NOT NULL,
                               l_suppkey       BIGINT         NOT NULL,
                               l_linenumber    INTEGER        NOT NULL,
                               l_quantity      NUMERIC(15, 2) NOT NULL,
                               l_extendedprice NUMERIC(15, 2) NOT NULL,
                               l_discount      NUMERIC(15, 2) NOT NULL,
                               l_tax           NUMERIC(15, 2) NOT NULL,
                               l_returnflag    VARCHAR(1)     NOT NULL,
                               l_linestatus    VARCHAR(1)     NOT NULL,
                               l_shipdate      DATE           NOT NULL,
                               l_commitdate    DATE           NOT NULL,
                               l_receiptdate   DATE           NOT NULL,
                               l_shipinstruct  VARCHAR(25)    NOT NULL,
                               l_shipmode      VARCHAR(10)    NOT NULL,
                               l_comment       VARCHAR(44)    NOT NULL,

                               CONSTRAINT lineitem_pkey
                                   PRIMARY KEY (l_orderkey, l_linenumber),

                               CONSTRAINT lineitem_order_fk
                                   FOREIGN KEY (l_orderkey)
                                       REFERENCES tpch.orders (o_orderkey),

                               CONSTRAINT lineitem_partsupp_fk
                                   FOREIGN KEY (l_partkey, l_suppkey)
                                       REFERENCES tpch.partsupp (ps_partkey, ps_suppkey)
);


COMMIT;