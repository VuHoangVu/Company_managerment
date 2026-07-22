--
-- PostgreSQL database cluster dump
--

-- Started on 2026-07-22 07:19:53

\restrict aUnGlxSo6oxUGRjcrkhEEvv7ddZHSuGADQIrQWMI731IFspuXnukkgI0FSAQMOo

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:UkMHWoAYvF4Ayl8GuZ/WXQ==$2jCVw1J7ezqrqOA9jLRnUQXFYobyWDSIzcrS4xBUbSc=:rBvM++EdG4++ZcVSjuqGiwCkzJctLT+IzPY2ZWAvFsU=';

--
-- User Configurations
--








\unrestrict aUnGlxSo6oxUGRjcrkhEEvv7ddZHSuGADQIrQWMI731IFspuXnukkgI0FSAQMOo

--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

\restrict Y4xRc5cjMPntlPXM8hvUuiz3eVCJtK9cUjAppRBrztAwC8yAJR6fd0QlfgGMSFs

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-07-22 07:19:53

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2026-07-22 07:19:54

--
-- PostgreSQL database dump complete
--

\unrestrict Y4xRc5cjMPntlPXM8hvUuiz3eVCJtK9cUjAppRBrztAwC8yAJR6fd0QlfgGMSFs

--
-- Database "Account" dump
--

--
-- PostgreSQL database dump
--

\restrict W2T5datvXW8XhKifZNe6nTNI2FYAZSM6Czs2z7anZsFUYCfhYl1eJxKR27aLKMY

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-07-22 07:19:54

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4935 (class 1262 OID 16548)
-- Name: Account; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "Account" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Vietnamese_Vietnam.1258';


ALTER DATABASE "Account" OWNER TO postgres;

\unrestrict W2T5datvXW8XhKifZNe6nTNI2FYAZSM6Czs2z7anZsFUYCfhYl1eJxKR27aLKMY
\connect "Account"
\restrict W2T5datvXW8XhKifZNe6nTNI2FYAZSM6Czs2z7anZsFUYCfhYl1eJxKR27aLKMY

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 225 (class 1259 OID 16603)
-- Name: department; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.department (
    id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.department OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16588)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer CONSTRAINT role_id_not_null NOT NULL,
    name character varying(50) CONSTRAINT role_name_not_null NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16593)
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.role_id_seq OWNER TO postgres;

--
-- TOC entry 4936 (class 0 OID 0)
-- Dependencies: 224
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.role_id_seq OWNED BY public.roles.id;


--
-- TOC entry 219 (class 1259 OID 16549)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer CONSTRAINT user_id_not_null NOT NULL,
    username character varying(50) CONSTRAINT user_username_not_null NOT NULL,
    password_hash text CONSTRAINT user_password_hash_not_null NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    role_id integer,
    approved boolean DEFAULT false,
    reset_requested boolean DEFAULT false,
    department_id integer
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16560)
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_seq OWNER TO postgres;

--
-- TOC entry 4937 (class 0 OID 0)
-- Dependencies: 220
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public.users.id;


--
-- TOC entry 221 (class 1259 OID 16569)
-- Name: user_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_tokens (
    id integer NOT NULL,
    user_id integer,
    token character varying(255),
    created_at timestamp without time zone DEFAULT now(),
    valid boolean DEFAULT true,
    device_id character varying(255)
);


ALTER TABLE public.user_tokens OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16577)
-- Name: user_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_tokens_id_seq OWNER TO postgres;

--
-- TOC entry 4938 (class 0 OID 0)
-- Dependencies: 222
-- Name: user_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_tokens_id_seq OWNED BY public.user_tokens.id;


--
-- TOC entry 4760 (class 2604 OID 16594)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.role_id_seq'::regclass);


--
-- TOC entry 4757 (class 2604 OID 16578)
-- Name: user_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_tokens ALTER COLUMN id SET DEFAULT nextval('public.user_tokens_id_seq'::regclass);


--
-- TOC entry 4753 (class 2604 OID 16568)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- TOC entry 4929 (class 0 OID 16603)
-- Dependencies: 225
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.department (id, name) FROM stdin;
0	Admin
10	Director
20	HCNS
30	PIE
40	QA
50	PD
60	IT
70	FAC
80	KITTING
90	EHS
\.


--
-- TOC entry 4927 (class 0 OID 16588)
-- Dependencies: 223
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name) FROM stdin;
0	Admin
20	CEO
30	Manager
40	Team leader
50	Leader
70	Employee
10	President
60	Staff
\.


--
-- TOC entry 4925 (class 0 OID 16569)
-- Dependencies: 221
-- Data for Name: user_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_tokens (id, user_id, token, created_at, valid, device_id) FROM stdin;
88	14	a2c97a05eca2f99ef15403af6a61dab9	2026-07-12 12:56:21.710813	f	c4343037-73e3-4326-9106-57b5b3869769
89	9	712c170aa1a3051da3bd03fa1028f67b	2026-07-12 12:56:37.526165	f	c4343037-73e3-4326-9106-57b5b3869769
90	9	0dfeecb53fb82dcb7468499c0c11ba23	2026-07-12 13:00:24.376597	f	c4343037-73e3-4326-9106-57b5b3869769
91	9	6e7308042106017b55e46f93c455f0ba	2026-07-12 13:43:04.213122	f	c4343037-73e3-4326-9106-57b5b3869769
92	9	bcf4de56ab85d7d57f59b745a36b6da2	2026-07-12 13:45:42.978996	f	c4343037-73e3-4326-9106-57b5b3869769
93	9	73209b353f499c83ca2fc6077a891b74	2026-07-12 14:00:25.259013	f	c4343037-73e3-4326-9106-57b5b3869769
94	9	4d2ba0e4b63aa57b8cb52180be2b90ee	2026-07-12 23:24:12.279894	f	c4343037-73e3-4326-9106-57b5b3869769
95	9	b5c3b363a6f0c641e142e4d396a34235	2026-07-14 23:38:11.394569	t	c4343037-73e3-4326-9106-57b5b3869769
\.


--
-- TOC entry 4923 (class 0 OID 16549)
-- Dependencies: 219
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, password_hash, created_at, role_id, approved, reset_requested, department_id) FROM stdin;
9	admin	$2b$12$W6GtptlxKhyIbX9RGoQkPeS85iZnWgLrnsAdVIyJ1hNKGGjO3Wxs2	2026-07-11 16:33:55.131041	0	t	f	0
15	B01713	$2b$12$moImEAI2uyfImc.t7JbqfOROOyDcarVjxmVK5T.pQBtxr2efr2kbS	2026-07-12 07:48:02.39003	70	t	f	30
14	B02987	$2b$12$H2zpx4MMh6gwylrCfloDyuEFVRbr5HbLRQGWKzhOPU7Io5IPQgDg2	2026-07-12 07:47:49.612359	50	t	f	30
\.


--
-- TOC entry 4939 (class 0 OID 0)
-- Dependencies: 224
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.role_id_seq', 1, false);


--
-- TOC entry 4940 (class 0 OID 0)
-- Dependencies: 220
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 15, true);


--
-- TOC entry 4941 (class 0 OID 0)
-- Dependencies: 222
-- Name: user_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_tokens_id_seq', 95, true);


--
-- TOC entry 4774 (class 2606 OID 16614)
-- Name: department department_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_pkey PRIMARY KEY (id);


--
-- TOC entry 4770 (class 2606 OID 16596)
-- Name: roles role_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT role_name_key UNIQUE (name);


--
-- TOC entry 4772 (class 2606 OID 16598)
-- Name: roles role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- TOC entry 4762 (class 2606 OID 16563)
-- Name: users user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 4766 (class 2606 OID 16580)
-- Name: user_tokens user_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_tokens
    ADD CONSTRAINT user_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4768 (class 2606 OID 16582)
-- Name: user_tokens user_tokens_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_tokens
    ADD CONSTRAINT user_tokens_token_key UNIQUE (token);


--
-- TOC entry 4764 (class 2606 OID 16565)
-- Name: users user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT user_username_key UNIQUE (username);


--
-- TOC entry 4775 (class 2606 OID 16583)
-- Name: user_tokens user_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_tokens
    ADD CONSTRAINT user_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


-- Completed on 2026-07-22 07:19:54

--
-- PostgreSQL database dump complete
--

\unrestrict W2T5datvXW8XhKifZNe6nTNI2FYAZSM6Czs2z7anZsFUYCfhYl1eJxKR27aLKMY

--
-- Database "EHS" dump
--

--
-- PostgreSQL database dump
--

\restrict xzfOPYACE6lL6sdh4V36zJ9C8HW3F3R55MMJdczR8VmbPDHhYaWtA4fcKCclqFS

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-07-22 07:19:54

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4886 (class 1262 OID 16618)
-- Name: EHS; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "EHS" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Vietnamese_Vietnam.1258';


ALTER DATABASE "EHS" OWNER TO postgres;

\unrestrict xzfOPYACE6lL6sdh4V36zJ9C8HW3F3R55MMJdczR8VmbPDHhYaWtA4fcKCclqFS
\connect "EHS"
\restrict xzfOPYACE6lL6sdh4V36zJ9C8HW3F3R55MMJdczR8VmbPDHhYaWtA4fcKCclqFS

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2026-07-22 07:19:55

--
-- PostgreSQL database dump complete
--

\unrestrict xzfOPYACE6lL6sdh4V36zJ9C8HW3F3R55MMJdczR8VmbPDHhYaWtA4fcKCclqFS

--
-- Database "File_storage" dump
--

--
-- PostgreSQL database dump
--

\restrict DIa0GwH4j0Ene4yM9yBTcgBhlCdhvb8FLUxJA76CD0EcphDHcsdRSpgbLsepmRX

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-07-22 07:19:55

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4897 (class 1262 OID 16601)
-- Name: File_storage; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "File_storage" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Vietnamese_Vietnam.1258';


ALTER DATABASE "File_storage" OWNER TO postgres;

\unrestrict DIa0GwH4j0Ene4yM9yBTcgBhlCdhvb8FLUxJA76CD0EcphDHcsdRSpgbLsepmRX
\connect "File_storage"
\restrict DIa0GwH4j0Ene4yM9yBTcgBhlCdhvb8FLUxJA76CD0EcphDHcsdRSpgbLsepmRX

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16634)
-- Name: file_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.file_metadata (
    id integer NOT NULL,
    file_name character varying(255) NOT NULL,
    file_type character varying(50) NOT NULL,
    file_size bigint,
    uploaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    storage_path text NOT NULL,
    description text
);


ALTER TABLE public.file_metadata OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16633)
-- Name: file_metadata_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.file_metadata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.file_metadata_id_seq OWNER TO postgres;

--
-- TOC entry 4898 (class 0 OID 0)
-- Dependencies: 219
-- Name: file_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.file_metadata_id_seq OWNED BY public.file_metadata.id;


--
-- TOC entry 4739 (class 2604 OID 16637)
-- Name: file_metadata id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_metadata ALTER COLUMN id SET DEFAULT nextval('public.file_metadata_id_seq'::regclass);


--
-- TOC entry 4891 (class 0 OID 16634)
-- Dependencies: 220
-- Data for Name: file_metadata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.file_metadata (id, file_name, file_type, file_size, uploaded_at, storage_path, description) FROM stdin;
\.


--
-- TOC entry 4899 (class 0 OID 0)
-- Dependencies: 219
-- Name: file_metadata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.file_metadata_id_seq', 1, false);


--
-- TOC entry 4742 (class 2606 OID 16646)
-- Name: file_metadata file_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_metadata
    ADD CONSTRAINT file_metadata_pkey PRIMARY KEY (id);


-- Completed on 2026-07-22 07:19:55

--
-- PostgreSQL database dump complete
--

\unrestrict DIa0GwH4j0Ene4yM9yBTcgBhlCdhvb8FLUxJA76CD0EcphDHcsdRSpgbLsepmRX

--
-- Database "HCNS" dump
--

--
-- PostgreSQL database dump
--

\restrict iGJJV8mOAZPfdzetiAunoVLjaB8mQMlRJlXVP7H96qx1uPpujI8qFaCuUEtmnFo

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-07-22 07:19:55

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4886 (class 1262 OID 16600)
-- Name: HCNS; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "HCNS" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Vietnamese_Vietnam.1258';


ALTER DATABASE "HCNS" OWNER TO postgres;

\unrestrict iGJJV8mOAZPfdzetiAunoVLjaB8mQMlRJlXVP7H96qx1uPpujI8qFaCuUEtmnFo
\connect "HCNS"
\restrict iGJJV8mOAZPfdzetiAunoVLjaB8mQMlRJlXVP7H96qx1uPpujI8qFaCuUEtmnFo

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2026-07-22 07:19:56

--
-- PostgreSQL database dump complete
--

\unrestrict iGJJV8mOAZPfdzetiAunoVLjaB8mQMlRJlXVP7H96qx1uPpujI8qFaCuUEtmnFo

--
-- Database "IT" dump
--

--
-- PostgreSQL database dump
--

\restrict 5m2yHB3SYImL2Wz9kd4sUUqq9Zd4Mk1o2CbiKzWONcc8FEYJZw0YLjBzQG7mthe

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-07-22 07:19:56

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4886 (class 1262 OID 16616)
-- Name: IT; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "IT" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Vietnamese_Vietnam.1258';


ALTER DATABASE "IT" OWNER TO postgres;

\unrestrict 5m2yHB3SYImL2Wz9kd4sUUqq9Zd4Mk1o2CbiKzWONcc8FEYJZw0YLjBzQG7mthe
\connect "IT"
\restrict 5m2yHB3SYImL2Wz9kd4sUUqq9Zd4Mk1o2CbiKzWONcc8FEYJZw0YLjBzQG7mthe

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2026-07-22 07:19:56

--
-- PostgreSQL database dump complete
--

\unrestrict 5m2yHB3SYImL2Wz9kd4sUUqq9Zd4Mk1o2CbiKzWONcc8FEYJZw0YLjBzQG7mthe

--
-- Database "KITTING" dump
--

--
-- PostgreSQL database dump
--

\restrict lxJl7yf7RcPzL40k6WhSBMBDharSixz366XleTw9dD7BpLp6PufU8XKrRi7T6Ql

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-07-22 07:19:56

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4886 (class 1262 OID 16617)
-- Name: KITTING; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "KITTING" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Vietnamese_Vietnam.1258';


ALTER DATABASE "KITTING" OWNER TO postgres;

\unrestrict lxJl7yf7RcPzL40k6WhSBMBDharSixz366XleTw9dD7BpLp6PufU8XKrRi7T6Ql
\connect "KITTING"
\restrict lxJl7yf7RcPzL40k6WhSBMBDharSixz366XleTw9dD7BpLp6PufU8XKrRi7T6Ql

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2026-07-22 07:19:56

--
-- PostgreSQL database dump complete
--

\unrestrict lxJl7yf7RcPzL40k6WhSBMBDharSixz366XleTw9dD7BpLp6PufU8XKrRi7T6Ql

--
-- Database "PD" dump
--

--
-- PostgreSQL database dump
--

\restrict VOKyZVgA9TDEhiQc1dQxSXfhaDPcaKkteh8ssRY5pvwUuGBrToQixTUR0CYY0Ai

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-07-22 07:19:56

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4886 (class 1262 OID 16602)
-- Name: PD; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "PD" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Vietnamese_Vietnam.1258';


ALTER DATABASE "PD" OWNER TO postgres;

\unrestrict VOKyZVgA9TDEhiQc1dQxSXfhaDPcaKkteh8ssRY5pvwUuGBrToQixTUR0CYY0Ai
\connect "PD"
\restrict VOKyZVgA9TDEhiQc1dQxSXfhaDPcaKkteh8ssRY5pvwUuGBrToQixTUR0CYY0Ai

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2026-07-22 07:19:57

--
-- PostgreSQL database dump complete
--

\unrestrict VOKyZVgA9TDEhiQc1dQxSXfhaDPcaKkteh8ssRY5pvwUuGBrToQixTUR0CYY0Ai

--
-- Database "PIE" dump
--

--
-- PostgreSQL database dump
--

\restrict pMT47fpBGjKs28RiwALp4soKE8SiqvAP15FWvDlHjfKTeDyf1VwsUqy8gWrtsZa

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-07-22 07:19:57

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4959 (class 1262 OID 16388)
-- Name: PIE; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "PIE" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Vietnamese_Vietnam.1258';


ALTER DATABASE "PIE" OWNER TO postgres;

\unrestrict pMT47fpBGjKs28RiwALp4soKE8SiqvAP15FWvDlHjfKTeDyf1VwsUqy8gWrtsZa
\connect "PIE"
\restrict pMT47fpBGjKs28RiwALp4soKE8SiqvAP15FWvDlHjfKTeDyf1VwsUqy8gWrtsZa

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 231 (class 1255 OID 16546)
-- Name: sp_login(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_login(_username text) RETURNS TABLE(user_id integer, role_id integer, password_hash text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT id, role_id, password_hash
    FROM "user"
    WHERE username = _username AND approved = TRUE;
END;
$$;


ALTER FUNCTION public.sp_login(_username text) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16422)
-- Name: document; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.document (
    id integer NOT NULL,
    filename text,
    filetype text,
    uploaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.document OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16421)
-- Name: document_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.document_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.document_id_seq OWNER TO postgres;

--
-- TOC entry 4960 (class 0 OID 0)
-- Dependencies: 219
-- Name: document_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.document_id_seq OWNED BY public.document.id;


--
-- TOC entry 222 (class 1259 OID 16433)
-- Name: eqplist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.eqplist (
    id integer CONSTRAINT epqlist_id_not_null NOT NULL,
    name text,
    code text,
    quantity integer,
    status text,
    note text,
    image text
);


ALTER TABLE public.eqplist OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16432)
-- Name: epqlist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.epqlist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.epqlist_id_seq OWNER TO postgres;

--
-- TOC entry 4961 (class 0 OID 0)
-- Dependencies: 221
-- Name: epqlist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.epqlist_id_seq OWNED BY public.eqplist.id;


--
-- TOC entry 226 (class 1259 OID 16457)
-- Name: eqpchecksheet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.eqpchecksheet (
    id integer NOT NULL,
    eqp_id integer,
    date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "values" jsonb
);


ALTER TABLE public.eqpchecksheet OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16456)
-- Name: eqpchecksheet_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.eqpchecksheet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.eqpchecksheet_id_seq OWNER TO postgres;

--
-- TOC entry 4962 (class 0 OID 0)
-- Dependencies: 225
-- Name: eqpchecksheet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.eqpchecksheet_id_seq OWNED BY public.eqpchecksheet.id;


--
-- TOC entry 228 (class 1259 OID 16473)
-- Name: eqpmaintenance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.eqpmaintenance (
    id integer NOT NULL,
    eqp_id integer,
    date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    details text
);


ALTER TABLE public.eqpmaintenance OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16472)
-- Name: eqpmaintenance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.eqpmaintenance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.eqpmaintenance_id_seq OWNER TO postgres;

--
-- TOC entry 4963 (class 0 OID 0)
-- Dependencies: 227
-- Name: eqpmaintenance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.eqpmaintenance_id_seq OWNED BY public.eqpmaintenance.id;


--
-- TOC entry 224 (class 1259 OID 16445)
-- Name: toollist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toollist (
    id integer NOT NULL,
    name text,
    code text,
    quantity integer,
    note text
);


ALTER TABLE public.toollist OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16444)
-- Name: toollist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.toollist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.toollist_id_seq OWNER TO postgres;

--
-- TOC entry 4964 (class 0 OID 0)
-- Dependencies: 223
-- Name: toollist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.toollist_id_seq OWNED BY public.toollist.id;


--
-- TOC entry 230 (class 1259 OID 16489)
-- Name: troubleshooting; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.troubleshooting (
    id integer NOT NULL,
    eqp_id integer,
    error text,
    status text DEFAULT 'open'::text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.troubleshooting OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16488)
-- Name: troubleshooting_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.troubleshooting_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.troubleshooting_id_seq OWNER TO postgres;

--
-- TOC entry 4965 (class 0 OID 0)
-- Dependencies: 229
-- Name: troubleshooting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.troubleshooting_id_seq OWNED BY public.troubleshooting.id;


--
-- TOC entry 4765 (class 2604 OID 16425)
-- Name: document id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document ALTER COLUMN id SET DEFAULT nextval('public.document_id_seq'::regclass);


--
-- TOC entry 4769 (class 2604 OID 16460)
-- Name: eqpchecksheet id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eqpchecksheet ALTER COLUMN id SET DEFAULT nextval('public.eqpchecksheet_id_seq'::regclass);


--
-- TOC entry 4767 (class 2604 OID 16436)
-- Name: eqplist id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eqplist ALTER COLUMN id SET DEFAULT nextval('public.epqlist_id_seq'::regclass);


--
-- TOC entry 4771 (class 2604 OID 16476)
-- Name: eqpmaintenance id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eqpmaintenance ALTER COLUMN id SET DEFAULT nextval('public.eqpmaintenance_id_seq'::regclass);


--
-- TOC entry 4768 (class 2604 OID 16448)
-- Name: toollist id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toollist ALTER COLUMN id SET DEFAULT nextval('public.toollist_id_seq'::regclass);


--
-- TOC entry 4773 (class 2604 OID 16492)
-- Name: troubleshooting id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.troubleshooting ALTER COLUMN id SET DEFAULT nextval('public.troubleshooting_id_seq'::regclass);


--
-- TOC entry 4943 (class 0 OID 16422)
-- Dependencies: 220
-- Data for Name: document; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.document (id, filename, filetype, uploaded_at) FROM stdin;
\.


--
-- TOC entry 4949 (class 0 OID 16457)
-- Dependencies: 226
-- Data for Name: eqpchecksheet; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.eqpchecksheet (id, eqp_id, date, "values") FROM stdin;
\.


--
-- TOC entry 4945 (class 0 OID 16433)
-- Dependencies: 222
-- Data for Name: eqplist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.eqplist (id, name, code, quantity, status, note, image) FROM stdin;
6	Máy hút chân không	RMF122	1	Hoạt động	Nợ nhà cung cấp	static/images/VS500.jpg
17	Máy hàn tay	RMF	1	Hoạt động	Đừng hỏi giá	static/images/arc-welding-machine-arc200s-1000x1000.jpg
14	Robot hàn	RMF789	1	Hoạt động	Chưa thanh toán	static/images/Kingree-Welder-6-Axis-Welding-Robot-1024x1024.jpg
5	Lò hồi lưu	RMF123	1	Hoạt động	Mới lấy 24-5	static/images/ibr-boiler-1000x1000.jpg
\.


--
-- TOC entry 4951 (class 0 OID 16473)
-- Dependencies: 228
-- Data for Name: eqpmaintenance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.eqpmaintenance (id, eqp_id, date, details) FROM stdin;
\.


--
-- TOC entry 4947 (class 0 OID 16445)
-- Dependencies: 224
-- Data for Name: toollist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.toollist (id, name, code, quantity, note) FROM stdin;
\.


--
-- TOC entry 4953 (class 0 OID 16489)
-- Dependencies: 230
-- Data for Name: troubleshooting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.troubleshooting (id, eqp_id, error, status, created_at) FROM stdin;
\.


--
-- TOC entry 4966 (class 0 OID 0)
-- Dependencies: 219
-- Name: document_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.document_id_seq', 1, false);


--
-- TOC entry 4967 (class 0 OID 0)
-- Dependencies: 221
-- Name: epqlist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.epqlist_id_seq', 17, true);


--
-- TOC entry 4968 (class 0 OID 0)
-- Dependencies: 225
-- Name: eqpchecksheet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.eqpchecksheet_id_seq', 1, false);


--
-- TOC entry 4969 (class 0 OID 0)
-- Dependencies: 227
-- Name: eqpmaintenance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.eqpmaintenance_id_seq', 1, false);


--
-- TOC entry 4970 (class 0 OID 0)
-- Dependencies: 223
-- Name: toollist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.toollist_id_seq', 1, false);


--
-- TOC entry 4971 (class 0 OID 0)
-- Dependencies: 229
-- Name: troubleshooting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.troubleshooting_id_seq', 1, false);


--
-- TOC entry 4777 (class 2606 OID 16431)
-- Name: document document_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document
    ADD CONSTRAINT document_pkey PRIMARY KEY (id);


--
-- TOC entry 4779 (class 2606 OID 16443)
-- Name: eqplist epqlist_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eqplist
    ADD CONSTRAINT epqlist_code_key UNIQUE (code);


--
-- TOC entry 4781 (class 2606 OID 16441)
-- Name: eqplist epqlist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eqplist
    ADD CONSTRAINT epqlist_pkey PRIMARY KEY (id);


--
-- TOC entry 4787 (class 2606 OID 16466)
-- Name: eqpchecksheet eqpchecksheet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eqpchecksheet
    ADD CONSTRAINT eqpchecksheet_pkey PRIMARY KEY (id);


--
-- TOC entry 4789 (class 2606 OID 16482)
-- Name: eqpmaintenance eqpmaintenance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eqpmaintenance
    ADD CONSTRAINT eqpmaintenance_pkey PRIMARY KEY (id);


--
-- TOC entry 4783 (class 2606 OID 16455)
-- Name: toollist toollist_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toollist
    ADD CONSTRAINT toollist_code_key UNIQUE (code);


--
-- TOC entry 4785 (class 2606 OID 16453)
-- Name: toollist toollist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toollist
    ADD CONSTRAINT toollist_pkey PRIMARY KEY (id);


--
-- TOC entry 4791 (class 2606 OID 16499)
-- Name: troubleshooting troubleshooting_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.troubleshooting
    ADD CONSTRAINT troubleshooting_pkey PRIMARY KEY (id);


--
-- TOC entry 4792 (class 2606 OID 16467)
-- Name: eqpchecksheet eqpchecksheet_eqp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eqpchecksheet
    ADD CONSTRAINT eqpchecksheet_eqp_id_fkey FOREIGN KEY (eqp_id) REFERENCES public.eqplist(id);


--
-- TOC entry 4793 (class 2606 OID 16483)
-- Name: eqpmaintenance eqpmaintenance_eqp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eqpmaintenance
    ADD CONSTRAINT eqpmaintenance_eqp_id_fkey FOREIGN KEY (eqp_id) REFERENCES public.eqplist(id);


--
-- TOC entry 4794 (class 2606 OID 16500)
-- Name: troubleshooting troubleshooting_eqp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.troubleshooting
    ADD CONSTRAINT troubleshooting_eqp_id_fkey FOREIGN KEY (eqp_id) REFERENCES public.eqplist(id);


-- Completed on 2026-07-22 07:19:57

--
-- PostgreSQL database dump complete
--

\unrestrict pMT47fpBGjKs28RiwALp4soKE8SiqvAP15FWvDlHjfKTeDyf1VwsUqy8gWrtsZa

--
-- Database "QA" dump
--

--
-- PostgreSQL database dump
--

\restrict YNwZqCNlTOqUFYuiA5jifgNcDPIgqqtn8sFK3tsrclWoguhLssZL8WOshlZ0N9Z

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-07-22 07:19:57

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4886 (class 1262 OID 16599)
-- Name: QA; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "QA" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Vietnamese_Vietnam.1258';


ALTER DATABASE "QA" OWNER TO postgres;

\unrestrict YNwZqCNlTOqUFYuiA5jifgNcDPIgqqtn8sFK3tsrclWoguhLssZL8WOshlZ0N9Z
\connect "QA"
\restrict YNwZqCNlTOqUFYuiA5jifgNcDPIgqqtn8sFK3tsrclWoguhLssZL8WOshlZ0N9Z

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2026-07-22 07:19:58

--
-- PostgreSQL database dump complete
--

\unrestrict YNwZqCNlTOqUFYuiA5jifgNcDPIgqqtn8sFK3tsrclWoguhLssZL8WOshlZ0N9Z

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict ruhv7TKj5C426I3YGqe7E6dsWPMDKG60cVBu3kxvxcphzaJnePTy4Pu4Q3yiwRz

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-07-22 07:19:58

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2026-07-22 07:19:58

--
-- PostgreSQL database dump complete
--

\unrestrict ruhv7TKj5C426I3YGqe7E6dsWPMDKG60cVBu3kxvxcphzaJnePTy4Pu4Q3yiwRz

-- Completed on 2026-07-22 07:19:58

--
-- PostgreSQL database cluster dump complete
--

