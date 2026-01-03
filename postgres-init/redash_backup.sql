--
-- PostgreSQL database dump
--

\restrict 34CgBhFepXLHb4J4cPCfDQq0MckPIfwtPDVo6Ebmmmyzk1m2Nzy1nj6TXiPG8RW

-- Dumped from database version 13.23 (Debian 13.23-1.pgdg13+1)
-- Dumped by pg_dump version 13.23 (Debian 13.23-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: queries_search_vector_update(); Type: FUNCTION; Schema: public; Owner: redash
--

CREATE FUNCTION public.queries_search_vector_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
            BEGIN
                NEW.search_vector = ((setweight(to_tsvector('pg_catalog.simple', regexp_replace(coalesce(CAST(NEW.id AS TEXT), ''), '[-@.]', ' ', 'g')), 'B') || setweight(to_tsvector('pg_catalog.simple', regexp_replace(coalesce(NEW.name, ''), '[-@.]', ' ', 'g')), 'A')) || setweight(to_tsvector('pg_catalog.simple', regexp_replace(coalesce(NEW.description, ''), '[-@.]', ' ', 'g')), 'C')) || setweight(to_tsvector('pg_catalog.simple', regexp_replace(coalesce(NEW.query, ''), '[-@.]', ' ', 'g')), 'D');
                RETURN NEW;
            END
            $$;


ALTER FUNCTION public.queries_search_vector_update() OWNER TO redash;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: access_permissions; Type: TABLE; Schema: public; Owner: redash
--

CREATE TABLE public.access_permissions (
    object_type character varying(255) NOT NULL,
    object_id integer NOT NULL,
    id integer NOT NULL,
    access_type character varying(255) NOT NULL,
    grantor_id integer NOT NULL,
    grantee_id integer NOT NULL
);


ALTER TABLE public.access_permissions OWNER TO redash;

--
-- Name: access_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: redash
--

CREATE SEQUENCE public.access_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.access_permissions_id_seq OWNER TO redash;

--
-- Name: access_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: redash
--

ALTER SEQUENCE public.access_permissions_id_seq OWNED BY public.access_permissions.id;


--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: redash
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO redash;

--
-- Name: alert_subscriptions; Type: TABLE; Schema: public; Owner: redash
--

CREATE TABLE public.alert_subscriptions (
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    user_id integer NOT NULL,
    destination_id integer,
    alert_id integer NOT NULL
);


ALTER TABLE public.alert_subscriptions OWNER TO redash;

--
-- Name: alert_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: redash
--

CREATE SEQUENCE public.alert_subscriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.alert_subscriptions_id_seq OWNER TO redash;

--
-- Name: alert_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: redash
--

ALTER SEQUENCE public.alert_subscriptions_id_seq OWNED BY public.alert_subscriptions.id;


--
-- Name: alerts; Type: TABLE; Schema: public; Owner: redash
--

CREATE TABLE public.alerts (
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    query_id integer NOT NULL,
    user_id integer NOT NULL,
    options text NOT NULL,
    state character varying(255) NOT NULL,
    last_triggered_at timestamp with time zone,
    rearm integer
);


ALTER TABLE public.alerts OWNER TO redash;

--
-- Name: alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: redash
--

CREATE SEQUENCE public.alerts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.alerts_id_seq OWNER TO redash;

--
-- Name: alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: redash
--

ALTER SEQUENCE public.alerts_id_seq OWNED BY public.alerts.id;


--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: redash
--

CREATE TABLE public.api_keys (
    object_type character varying(255) NOT NULL,
    object_id integer NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    org_id integer NOT NULL,
    api_key character varying(255) NOT NULL,
    active boolean NOT NULL,
    created_by_id integer
);


ALTER TABLE public.api_keys OWNER TO redash;

--
-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: redash
--

CREATE SEQUENCE public.api_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.api_keys_id_seq OWNER TO redash;

--
-- Name: api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: redash
--

ALTER SEQUENCE public.api_keys_id_seq OWNED BY public.api_keys.id;


--
-- Name: changes; Type: TABLE; Schema: public; Owner: redash
--

CREATE TABLE public.changes (
    object_type character varying(255) NOT NULL,
    object_id integer NOT NULL,
    id integer NOT NULL,
    object_version integer NOT NULL,
    user_id integer NOT NULL,
    change text NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.changes OWNER TO redash;

--
-- Name: changes_id_seq; Type: SEQUENCE; Schema: public; Owner: redash
--

CREATE SEQUENCE public.changes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.changes_id_seq OWNER TO redash;

--
-- Name: changes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: redash
--

ALTER SEQUENCE public.changes_id_seq OWNED BY public.changes.id;


--
-- Name: dashboards; Type: TABLE; Schema: public; Owner: redash
--

CREATE TABLE public.dashboards (
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    version integer NOT NULL,
    org_id integer NOT NULL,
    slug character varying(140) NOT NULL,
    name character varying(100) NOT NULL,
    user_id integer NOT NULL,
    layout text NOT NULL,
    dashboard_filters_enabled boolean NOT NULL,
    is_archived boolean NOT NULL,
    is_draft boolean NOT NULL,
    tags character varying[]
);


ALTER TABLE public.dashboards OWNER TO redash;

--
-- Name: dashboards_id_seq; Type: SEQUENCE; Schema: public; Owner: redash
--

CREATE SEQUENCE public.dashboards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dashboards_id_seq OWNER TO redash;

--
-- Name: dashboards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: redash
--

ALTER SEQUENCE public.dashboards_id_seq OWNED BY public.dashboards.id;


--
-- Name: data_source_groups; Type: TABLE; Schema: public; Owner: redash
--

CREATE TABLE public.data_source_groups (
    id integer NOT NULL,
    data_source_id integer NOT NULL,
    group_id integer NOT NULL,
    view_only boolean NOT NULL
);


ALTER TABLE public.data_source_groups OWNER TO redash;

--
-- Name: data_source_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: redash
--

CREATE SEQUENCE public.data_source_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.data_source_groups_id_seq OWNER TO redash;

--
-- Name: data_source_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: redash
--

ALTER SEQUENCE public.data_source_groups_id_seq OWNED BY public.data_source_groups.id;


--
-- Name: data_sources; Type: TABLE; Schema: public; Owner: redash
--

CREATE TABLE public.data_sources (
    id integer NOT NULL,
    org_id integer NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    encrypted_options bytea NOT NULL,
    queue_name character varying(255) NOT NULL,
    scheduled_queue_name character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.data_sources OWNER TO redash;

--
-- Name: data_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: redash
--

CREATE SEQUENCE public.data_sources_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.data_sources_id_seq OWNER TO redash;

--
-- Name: data_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: redash
--

ALTER SEQUENCE public.data_sources_id_seq OWNED BY public.data_sources.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: redash
--

CREATE TABLE public.events (
    id integer NOT NULL,
    org_id integer NOT NULL,
    user_id integer,
    action character varying(255) NOT NULL,
    object_type character varying(255) NOT NULL,
    object_id character varying(255),
    additional_properties text,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.events OWNER TO redash;

--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: redash
--

CREATE SEQUENCE public.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_id_seq OWNER TO redash;

--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: redash
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: favorites; Type: TABLE; Schema: public; Owner: redash
--

CREATE TABLE public.favorites (
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    org_id integer NOT NULL,
    object_type character varying(255) NOT NULL,
    object_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.favorites OWNER TO redash;

--
-- Name: favorites_id_seq; Type: SEQUENCE; Schema: public; Owner: redash
--

CREATE SEQUENCE public.favorites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.favorites_id_seq OWNER TO redash;

--
-- Name: favorites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: redash
--

ALTER SEQUENCE public.favorites_id_seq OWNED BY public.favorites.id;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: redash
--

CREATE TABLE public.groups (
    id integer NOT NULL,
    org_id integer NOT NULL,
    type character varying(255) NOT NULL,
    name character varying(100) NOT NULL,
    permissions character varying(255)[] NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.groups OWNER TO redash;

--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: redash
--

CREATE SEQUENCE public.groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.groups_id_seq OWNER TO redash;

--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: redash
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- Name: notification_destinations; Type: TABLE; Schema: public; Owner: redash
--

CREATE TABLE public.notification_destinations (
    id integer NOT NULL,
    org_id integer NOT NULL,
    user_id integer NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    options text NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.notification_destinations OWNER TO redash;

--
-- Name: notification_destinations_id_seq; Type: SEQUENCE; Schema: public; Owner: redash
--

CREATE SEQUENCE public.notification_destinations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_destinations_id_seq OWNER TO redash;

--
-- Name: notification_destinations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: redash
--

ALTER SEQUENCE public.notification_destinations_id_seq OWNED BY public.notification_destinations.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: redash
--

CREATE TABLE public.organizations (
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    settings text NOT NULL
);


ALTER TABLE public.organizations OWNER TO redash;

--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: redash
--

CREATE SEQUENCE public.organizations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organizations_id_seq OWNER TO redash;

--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: redash
--

ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;


--
-- Name: queries; Type: TABLE; Schema: public; Owner: redash
--

CREATE TABLE public.queries (
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    version integer NOT NULL,
    org_id integer NOT NULL,
    data_source_id integer,
    latest_query_data_id integer,
    name character varying(255) NOT NULL,
    description character varying(4096),
    query text NOT NULL,
    query_hash character varying(32) NOT NULL,
    api_key character varying(40) NOT NULL,
    user_id integer NOT NULL,
    last_modified_by_id integer,
    is_archived boolean NOT NULL,
    is_draft boolean NOT NULL,
    schedule text,
    schedule_failures integer NOT NULL,
    options text NOT NULL,
    search_vector tsvector,
    tags character varying[]
);


ALTER TABLE public.queries OWNER TO redash;

--
-- Name: queries_id_seq; Type: SEQUENCE; Schema: public; Owner: redash
--

CREATE SEQUENCE public.queries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.queries_id_seq OWNER TO redash;

--
-- Name: queries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: redash
--

ALTER SEQUENCE public.queries_id_seq OWNED BY public.queries.id;


--
-- Name: query_results; Type: TABLE; Schema: public; Owner: redash
--

CREATE TABLE public.query_results (
    id integer NOT NULL,
    org_id integer NOT NULL,
    data_source_id integer NOT NULL,
    query_hash character varying(32) NOT NULL,
    query text NOT NULL,
    data text NOT NULL,
    runtime double precision NOT NULL,
    retrieved_at timestamp with time zone NOT NULL
);


ALTER TABLE public.query_results OWNER TO redash;

--
-- Name: query_results_id_seq; Type: SEQUENCE; Schema: public; Owner: redash
--

CREATE SEQUENCE public.query_results_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.query_results_id_seq OWNER TO redash;

--
-- Name: query_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: redash
--

ALTER SEQUENCE public.query_results_id_seq OWNED BY public.query_results.id;


--
-- Name: query_snippets; Type: TABLE; Schema: public; Owner: redash
--

CREATE TABLE public.query_snippets (
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    org_id integer NOT NULL,
    trigger character varying(255) NOT NULL,
    description text NOT NULL,
    user_id integer NOT NULL,
    snippet text NOT NULL
);


ALTER TABLE public.query_snippets OWNER TO redash;

--
-- Name: query_snippets_id_seq; Type: SEQUENCE; Schema: public; Owner: redash
--

CREATE SEQUENCE public.query_snippets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.query_snippets_id_seq OWNER TO redash;

--
-- Name: query_snippets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: redash
--

ALTER SEQUENCE public.query_snippets_id_seq OWNED BY public.query_snippets.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: redash
--

CREATE TABLE public.users (
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    org_id integer NOT NULL,
    name character varying(320) NOT NULL,
    email character varying(255) NOT NULL,
    profile_image_url character varying(320),
    password_hash character varying(128),
    groups integer[],
    api_key character varying(40) NOT NULL,
    disabled_at timestamp with time zone,
    details json DEFAULT '{}'::json
);


ALTER TABLE public.users OWNER TO redash;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: redash
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO redash;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: redash
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: visualizations; Type: TABLE; Schema: public; Owner: redash
--

CREATE TABLE public.visualizations (
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    type character varying(100) NOT NULL,
    query_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4096),
    options text NOT NULL
);


ALTER TABLE public.visualizations OWNER TO redash;

--
-- Name: visualizations_id_seq; Type: SEQUENCE; Schema: public; Owner: redash
--

CREATE SEQUENCE public.visualizations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.visualizations_id_seq OWNER TO redash;

--
-- Name: visualizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: redash
--

ALTER SEQUENCE public.visualizations_id_seq OWNED BY public.visualizations.id;


--
-- Name: widgets; Type: TABLE; Schema: public; Owner: redash
--

CREATE TABLE public.widgets (
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    visualization_id integer,
    text text,
    width integer NOT NULL,
    options text NOT NULL,
    dashboard_id integer NOT NULL
);


ALTER TABLE public.widgets OWNER TO redash;

--
-- Name: widgets_id_seq; Type: SEQUENCE; Schema: public; Owner: redash
--

CREATE SEQUENCE public.widgets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.widgets_id_seq OWNER TO redash;

--
-- Name: widgets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: redash
--

ALTER SEQUENCE public.widgets_id_seq OWNED BY public.widgets.id;


--
-- Name: access_permissions id; Type: DEFAULT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.access_permissions ALTER COLUMN id SET DEFAULT nextval('public.access_permissions_id_seq'::regclass);


--
-- Name: alert_subscriptions id; Type: DEFAULT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.alert_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.alert_subscriptions_id_seq'::regclass);


--
-- Name: alerts id; Type: DEFAULT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.alerts ALTER COLUMN id SET DEFAULT nextval('public.alerts_id_seq'::regclass);


--
-- Name: api_keys id; Type: DEFAULT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.api_keys ALTER COLUMN id SET DEFAULT nextval('public.api_keys_id_seq'::regclass);


--
-- Name: changes id; Type: DEFAULT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.changes ALTER COLUMN id SET DEFAULT nextval('public.changes_id_seq'::regclass);


--
-- Name: dashboards id; Type: DEFAULT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.dashboards ALTER COLUMN id SET DEFAULT nextval('public.dashboards_id_seq'::regclass);


--
-- Name: data_source_groups id; Type: DEFAULT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.data_source_groups ALTER COLUMN id SET DEFAULT nextval('public.data_source_groups_id_seq'::regclass);


--
-- Name: data_sources id; Type: DEFAULT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.data_sources ALTER COLUMN id SET DEFAULT nextval('public.data_sources_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: favorites id; Type: DEFAULT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.favorites ALTER COLUMN id SET DEFAULT nextval('public.favorites_id_seq'::regclass);


--
-- Name: groups id; Type: DEFAULT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- Name: notification_destinations id; Type: DEFAULT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.notification_destinations ALTER COLUMN id SET DEFAULT nextval('public.notification_destinations_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- Name: queries id; Type: DEFAULT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.queries ALTER COLUMN id SET DEFAULT nextval('public.queries_id_seq'::regclass);


--
-- Name: query_results id; Type: DEFAULT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.query_results ALTER COLUMN id SET DEFAULT nextval('public.query_results_id_seq'::regclass);


--
-- Name: query_snippets id; Type: DEFAULT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.query_snippets ALTER COLUMN id SET DEFAULT nextval('public.query_snippets_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: visualizations id; Type: DEFAULT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.visualizations ALTER COLUMN id SET DEFAULT nextval('public.visualizations_id_seq'::regclass);


--
-- Name: widgets id; Type: DEFAULT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.widgets ALTER COLUMN id SET DEFAULT nextval('public.widgets_id_seq'::regclass);


--
-- Data for Name: access_permissions; Type: TABLE DATA; Schema: public; Owner: redash
--

COPY public.access_permissions (object_type, object_id, id, access_type, grantor_id, grantee_id) FROM stdin;
\.


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: redash
--

COPY public.alembic_version (version_num) FROM stdin;
e5c7a4e2df4d
\.


--
-- Data for Name: alert_subscriptions; Type: TABLE DATA; Schema: public; Owner: redash
--

COPY public.alert_subscriptions (updated_at, created_at, id, user_id, destination_id, alert_id) FROM stdin;
\.


--
-- Data for Name: alerts; Type: TABLE DATA; Schema: public; Owner: redash
--

COPY public.alerts (updated_at, created_at, id, name, query_id, user_id, options, state, last_triggered_at, rearm) FROM stdin;
\.


--
-- Data for Name: api_keys; Type: TABLE DATA; Schema: public; Owner: redash
--

COPY public.api_keys (object_type, object_id, updated_at, created_at, id, org_id, api_key, active, created_by_id) FROM stdin;
\.


--
-- Data for Name: changes; Type: TABLE DATA; Schema: public; Owner: redash
--

COPY public.changes (object_type, object_id, id, object_version, user_id, change, created_at) FROM stdin;
queries	1	1	1	1	{"last_modified_by_id": {"current": 1, "previous": null}, "user_id": {"current": 1, "previous": null}, "description": {"current": null, "previous": null}, "schedule": {"current": null, "previous": null}, "search_vector": {"current": null, "previous": null}, "is_archived": {"current": false, "previous": null}, "tags": {"current": null, "previous": null}, "org_id": {"current": 1, "previous": null}, "schedule_failures": {"current": 0, "previous": 0}, "name": {"current": "New Query", "previous": "New Query"}, "query_hash": {"current": "3e9b8d03e37dbd58656b22dda4064b2f", "previous": "3e9b8d03e37dbd58656b22dda4064b2f"}, "query": {"current": "SELECT\\r\\n                HOUR(ts) AS \\"\\u0427\\u0430\\u0441\\",\\r\\n                activity_type AS \\"\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438\\",\\r\\n                ROUND(COUNT(*) / 60, 1) AS \\"\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b\\"\\r\\n            FROM fitness_data\\r\\n            WHERE ts >= (SELECT MAX(ts) FROM fitness_data) - INTERVAL 24 HOUR\\r\\n            GROUP BY 1, 2\\r\\n            ORDER BY 1 ASC;", "previous": "SELECT\\r\\n                HOUR(ts) AS \\"\\u0427\\u0430\\u0441\\",\\r\\n                activity_type AS \\"\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438\\",\\r\\n                ROUND(COUNT(*) / 60, 1) AS \\"\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b\\"\\r\\n            FROM fitness_data\\r\\n            WHERE ts >= (SELECT MAX(ts) FROM fitness_data) - INTERVAL 24 HOUR\\r\\n            GROUP BY 1, 2\\r\\n            ORDER BY 1 ASC;"}, "api_key": {"current": "hAMc2BV1W1BTpkmh4TdEV3n98Jw8BPTbw281eLf6", "previous": null}, "is_draft": {"current": true, "previous": true}, "options": {"current": {"parameters": []}, "previous": {"parameters": []}}, "data_source_id": {"current": 1, "previous": null}, "latest_query_data_id": {"current": 3, "previous": 3}}	2026-01-03 09:19:17.042707+00
queries	2	2	1	1	{"last_modified_by_id": {"current": 1, "previous": null}, "user_id": {"current": 1, "previous": null}, "description": {"current": null, "previous": null}, "schedule": {"current": null, "previous": null}, "search_vector": {"current": null, "previous": null}, "is_archived": {"current": false, "previous": null}, "tags": {"current": null, "previous": null}, "org_id": {"current": 1, "previous": 1}, "schedule_failures": {"current": 0, "previous": 0}, "name": {"current": "Calories per day", "previous": "Calories per day"}, "query_hash": {"current": "6939ce5afe06e649f904f1f69eb1d9ff", "previous": "6939ce5afe06e649f904f1f69eb1d9ff"}, "query": {"current": "SELECT\\r\\n    DATE(ts) AS day,\\r\\n    ROUND(SUM(calories) / 60, 0) AS calories\\r\\nFROM fitness_data\\r\\nGROUP BY day\\r\\nORDER BY day;", "previous": "SELECT\\r\\n    DATE(ts) AS day,\\r\\n    ROUND(SUM(calories) / 60, 0) AS calories\\r\\nFROM fitness_data\\r\\nGROUP BY day\\r\\nORDER BY day;"}, "api_key": {"current": "nI8r5gPGZvV7bmgDCQ0NASNFNZ7hKjlIigJkUy4O", "previous": null}, "is_draft": {"current": true, "previous": true}, "options": {"current": {"parameters": []}, "previous": {"parameters": []}}, "data_source_id": {"current": 1, "previous": null}, "latest_query_data_id": {"current": 10, "previous": 10}}	2026-01-03 09:22:23.013815+00
queries	3	3	1	1	{"last_modified_by_id": {"current": 1, "previous": null}, "user_id": {"current": 1, "previous": null}, "description": {"current": null, "previous": null}, "schedule": {"current": null, "previous": null}, "search_vector": {"current": null, "previous": null}, "is_archived": {"current": false, "previous": null}, "tags": {"current": null, "previous": null}, "org_id": {"current": 1, "previous": null}, "schedule_failures": {"current": 0, "previous": 0}, "name": {"current": "Reports for the day", "previous": "Reports for the day"}, "query_hash": {"current": "6143211b6c93d493c68644ce464795d5", "previous": "6143211b6c93d493c68644ce464795d5"}, "query": {"current": "SELECT\\r\\n    DATE(ts) AS \\"\\u0414\\u0430\\u0442\\u0430\\",\\r\\n    ROUND(SUM(steps) / 20, 0) AS \\"\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c\\",\\r\\n    ROUND(SUM(calories) / 60, 0) AS \\"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c\\",\\r\\n    ROUND(AVG(heart_rate), 0) AS \\"\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441\\"\\r\\nFROM fitness_data\\r\\nGROUP BY DATE(ts)\\r\\nORDER BY DATE(ts) DESC;", "previous": "SELECT\\r\\n    DATE(ts) AS \\"\\u0414\\u0430\\u0442\\u0430\\",\\r\\n    ROUND(SUM(steps) / 20, 0) AS \\"\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c\\",\\r\\n    ROUND(SUM(calories) / 60, 0) AS \\"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c\\",\\r\\n    ROUND(AVG(heart_rate), 0) AS \\"\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441\\"\\r\\nFROM fitness_data\\r\\nGROUP BY DATE(ts)\\r\\nORDER BY DATE(ts) DESC;"}, "api_key": {"current": "l4BlhdxnFQbzjwzhhNjkALAcEsSJhgK05Ki5t0q6", "previous": null}, "is_draft": {"current": true, "previous": true}, "options": {"current": {"parameters": []}, "previous": {"parameters": []}}, "data_source_id": {"current": 1, "previous": null}, "latest_query_data_id": {"current": 17, "previous": 17}}	2026-01-03 09:25:06.99783+00
queries	4	4	1	1	{"last_modified_by_id": {"current": 1, "previous": null}, "user_id": {"current": 1, "previous": null}, "description": {"current": null, "previous": null}, "schedule": {"current": null, "previous": null}, "search_vector": {"current": null, "previous": null}, "is_archived": {"current": false, "previous": null}, "tags": {"current": null, "previous": null}, "org_id": {"current": 1, "previous": null}, "schedule_failures": {"current": 0, "previous": 0}, "name": {"current": "New Query", "previous": "New Query"}, "query_hash": {"current": "6aeddf1be858a72506bd5c91319f84a9", "previous": "6aeddf1be858a72506bd5c91319f84a9"}, "query": {"current": "SELECT\\r\\n    activity_type AS \\"\\u0410\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u044c\\",\\r\\n    heart_rate AS \\"\\u041f\\u0443\\u043b\\u044c\\u0441\\",\\r\\n    calories AS \\"\\u041a\\u0430\\u043b\\u043e\\u0440\\u0438\\u0438 (\\u0441\\u0435\\u043a)\\",\\r\\n    DATE_FORMAT(ts, '%H:%i:%S') AS \\"\\u0412\\u0440\\u0435\\u043c\\u044f \\u0437\\u0430\\u043c\\u0435\\u0440\\u0430\\"\\r\\nFROM fitness_data\\r\\nORDER BY ts DESC\\r\\nLIMIT 1;", "previous": "SELECT\\r\\n    activity_type AS \\"\\u0410\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u044c\\",\\r\\n    heart_rate AS \\"\\u041f\\u0443\\u043b\\u044c\\u0441\\",\\r\\n    calories AS \\"\\u041a\\u0430\\u043b\\u043e\\u0440\\u0438\\u0438 (\\u0441\\u0435\\u043a)\\",\\r\\n    DATE_FORMAT(ts, '%H:%i:%S') AS \\"\\u0412\\u0440\\u0435\\u043c\\u044f \\u0437\\u0430\\u043c\\u0435\\u0440\\u0430\\"\\r\\nFROM fitness_data\\r\\nORDER BY ts DESC\\r\\nLIMIT 1;"}, "api_key": {"current": "9XOUUCEcWAkAnbvyvFw6KpzvDVsFpKQTzoWyC7Lt", "previous": null}, "is_draft": {"current": true, "previous": true}, "options": {"current": {"parameters": []}, "previous": {"parameters": []}}, "data_source_id": {"current": 1, "previous": null}, "latest_query_data_id": {"current": 21, "previous": 21}}	2026-01-03 09:27:29.414107+00
dashboards	1	5	1	1	{"user_id": {"current": 1, "previous": null}, "name": {"current": "Report", "previous": null}, "tags": {"current": null, "previous": null}, "is_archived": {"current": false, "previous": null}, "org_id": {"current": 1, "previous": null}, "layout": {"current": "[]", "previous": "[]"}, "dashboard_filters_enabled": {"current": false, "previous": null}, "is_draft": {"current": true, "previous": true}, "slug": {"current": "report", "previous": null}}	2026-01-03 09:28:01.685461+00
\.


--
-- Data for Name: dashboards; Type: TABLE DATA; Schema: public; Owner: redash
--

COPY public.dashboards (updated_at, created_at, id, version, org_id, slug, name, user_id, layout, dashboard_filters_enabled, is_archived, is_draft, tags) FROM stdin;
2026-01-03 09:30:00.26677+00	2026-01-03 09:28:01.685461+00	1	2	1	report	Report	1	[]	f	f	f	\N
\.


--
-- Data for Name: data_source_groups; Type: TABLE DATA; Schema: public; Owner: redash
--

COPY public.data_source_groups (id, data_source_id, group_id, view_only) FROM stdin;
1	1	2	f
\.


--
-- Data for Name: data_sources; Type: TABLE DATA; Schema: public; Owner: redash
--

COPY public.data_sources (id, org_id, name, type, encrypted_options, queue_name, scheduled_queue_name, created_at) FROM stdin;
1	1	fitness	mysql	\\x6741414141414270574e37334467583778704148774f425866345f3832644c3277584a7031786c34634457636b3866396573486470304d572d736a3846436e5235344770427979494a41567370632d6c6f2d766330506e59594e464f62593653736463444c356a73384e6b7847766642337a472d6b597a6b6a6b4c66493767384d7663633767733852414145476a4b453276394c52666b514175464b527649555f4b50413059376c6d4c435952474a4f4b4879424a6b576c5433374e536b5956746170364c3375516f613679	queries	scheduled_queries	2026-01-03 09:18:47.329128+00
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: redash
--

COPY public.events (id, org_id, user_id, action, object_type, object_id, additional_properties, created_at) FROM stdin;
1	1	1	login	redash	\N	{"ip": "172.18.0.1", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:18:29+00
2	1	1	load_favorites	query	\N	{"ip": "172.18.0.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "user_name": "student"}	2026-01-03 09:18:30+00
3	1	1	load_favorites	dashboard	\N	{"ip": "172.18.0.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "user_name": "student"}	2026-01-03 09:18:30+00
4	1	1	load_favorites	query	\N	{"ip": "172.18.0.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "user_name": "student"}	2026-01-03 09:18:30+00
5	1	1	load_favorites	dashboard	\N	{"ip": "172.18.0.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "user_name": "student"}	2026-01-03 09:18:30+00
6	1	1	view	page	personal_homepage	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:18:30.063+00
7	1	1	list	datasource	admin/data_sources	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:18:31+00
8	1	1	view	page	data_sources/new	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:18:31.648+00
9	1	1	create	datasource	1	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:18:47+00
10	1	1	list	datasource	admin/data_sources	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:18:47+00
11	1	1	view	datasource	1	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:18:47+00
12	1	1	test	datasource	1	{"ip": "172.18.0.1", "user_name": "student", "result": {"message": "success", "ok": true}, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:18:48+00
13	1	1	list	datasource	admin/data_sources	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:18:51+00
14	1	1	list	query_snippet	\N	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:18:52+00
15	1	1	view_source	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:18:52.031+00
16	1	1	execute_query	data_source	1	{"query_id": "adhoc", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n                HOUR(ts) AS \\"\\u0427\\u0430\\u0441\\",\\r\\n                activity_type AS \\"\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438\\",\\r\\n                ROUND(COUNT(*) / 60, 1) AS \\"\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b\\"\\r\\n            FROM fitness_data\\r\\n            WHERE ts >= (SELECT MAX(ts) FROM fitness_data) - INTERVAL 24 HOUR\\r\\n            GROUP BY 1, 2\\r\\n            ORDER BY 1 ASC;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:19:09+00
17	1	1	execute	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:19:09.882+00
18	1	1	execute_query	data_source	1	{"query_id": "adhoc", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n                HOUR(ts) AS \\"\\u0427\\u0430\\u0441\\",\\r\\n                activity_type AS \\"\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438\\",\\r\\n                ROUND(COUNT(*) / 60, 1) AS \\"\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b\\"\\r\\n            FROM fitness_data\\r\\n            WHERE ts >= (SELECT MAX(ts) FROM fitness_data) - INTERVAL 24 HOUR\\r\\n            GROUP BY 1, 2\\r\\n            ORDER BY 1 ASC;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:19:12+00
19	1	1	execute	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:19:12.49+00
20	1	1	execute_query	data_source	1	{"query_id": "adhoc", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n                HOUR(ts) AS \\"\\u0427\\u0430\\u0441\\",\\r\\n                activity_type AS \\"\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438\\",\\r\\n                ROUND(COUNT(*) / 60, 1) AS \\"\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b\\"\\r\\n            FROM fitness_data\\r\\n            WHERE ts >= (SELECT MAX(ts) FROM fitness_data) - INTERVAL 24 HOUR\\r\\n            GROUP BY 1, 2\\r\\n            ORDER BY 1 ASC;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:19:13+00
21	1	1	execute	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:19:13.594+00
22	1	1	create	query	1	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:19:17+00
23	1	1	view	query	1	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:19:17+00
24	1	1	list	datasource	admin/data_sources	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:19:17+00
25	1	1	list	query_snippet	\N	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:19:17+00
26	1	1	view_source	query	1	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:19:17.193+00
27	1	1	create	visualization	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "type": "CHART", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "user_name": "student"}	2026-01-03 09:19:26.322+00
28	1	1	execute_query	data_source	1	{"query_id": 1, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n                HOUR(ts) AS \\"Hour\\",\\r\\n                activity_type AS \\"Type activity\\",\\r\\n                ROUND(COUNT(*) / 60, 1) AS \\"Minutes\\"\\r\\n            FROM fitness_data\\r\\n            WHERE ts >= (SELECT MAX(ts) FROM fitness_data) - INTERVAL 24 HOUR\\r\\n            GROUP BY 1, 2\\r\\n            ORDER BY 1 ASC;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:20:15+00
29	1	1	execute	query	1	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:20:15.42+00
30	1	1	delete	Visualization	2	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:20:21+00
31	1	1	create	visualization	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "type": "CHART", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "user_name": "student"}	2026-01-03 09:20:32.978+00
32	1	1	edit_name	query	1	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:20:55.637+00
33	1	1	list	datasource	admin/data_sources	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:21:00+00
34	1	1	list	query_snippet	\N	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:21:00+00
35	1	1	view_source	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:21:00.828+00
36	1	1	execute_query	data_source	1	{"query_id": "adhoc", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n              DATE(ts) AS day,\\r\\n              ROUND(SUM(calories) / 60, 0) AS calories\\r\\n            FROM fitness_data\\r\\n            GROUP BY day\\r\\n            ORDER BY day;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:21:09+00
37	1	1	execute	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:21:09.429+00
38	1	1	execute_query	data_source	1	{"query_id": "adhoc", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n              DATE(ts) AS day,\\r\\n              ROUND(SUM(calories) / 60, 0) AS calories\\r\\n            FROM fitness_data\\r\\n            GROUP BY day\\r\\n            ORDER BY day;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:21:11+00
39	1	1	execute	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:21:11.746+00
40	1	1	execute_query	data_source	1	{"query_id": "adhoc", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n              DATE(ts) AS day,\\r\\n              ROUND(SUM(calories) / 60, 0) AS calories\\r\\n            FROM fitness_data\\r\\n            GROUP BY day\\r\\n            ORDER BY day;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:21:12+00
41	1	1	execute	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:21:12.972+00
42	1	1	login	redash	\N	{"ip": "172.18.0.1", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:21:57+00
43	1	1	list	datasource	admin/data_sources	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:21:58+00
44	1	1	load_favorites	query	\N	{"ip": "172.18.0.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "user_name": "student"}	2026-01-03 09:21:58+00
45	1	1	list	query_snippet	\N	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:21:58+00
46	1	1	load_favorites	dashboard	\N	{"ip": "172.18.0.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "user_name": "student"}	2026-01-03 09:21:58+00
47	1	1	view_source	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:21:58.284+00
48	1	1	execute_query	data_source	1	{"query_id": "adhoc", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n    DATE(ts) AS day,\\r\\n    ROUND(SUM(calories) / 60, 0) AS calories\\r\\nFROM fitness_data\\r\\nGROUP BY day\\r\\nORDER BY day;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:22:01+00
49	1	1	execute	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:22:01.303+00
50	1	1	execute_query	data_source	1	{"query_id": "adhoc", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n    DATE(ts) AS day,\\r\\n    ROUND(SUM(calories) / 60, 0) AS calories\\r\\nFROM fitness_data\\r\\nGROUP BY day\\r\\nORDER BY day;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:22:03+00
51	1	1	execute_query	data_source	1	{"query_id": "adhoc", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n    DATE(ts) AS day,\\r\\n    ROUND(SUM(calories) / 60, 0) AS calories\\r\\nFROM fitness_data\\r\\nGROUP BY day\\r\\nORDER BY day;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:22:04+00
52	1	1	execute	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:22:03.398+00
53	1	1	execute	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:22:04.397+00
54	1	1	edit_name	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:22:19.807+00
55	1	1	create	query	2	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:22:23+00
56	1	1	view	query	2	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:22:23+00
57	1	1	list	datasource	admin/data_sources	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:22:23+00
58	1	1	list	query_snippet	\N	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:22:23+00
59	1	1	view_source	query	2	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:22:23.144+00
60	1	1	create	visualization	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "type": "CHART", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "user_name": "student"}	2026-01-03 09:22:34.366+00
61	1	1	toggle_published	query	2	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:23:34.312+00
62	1	1	load_favorites	dashboard	\N	{"ip": "172.18.0.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "user_name": "student"}	2026-01-03 09:23:41+00
63	1	1	load_favorites	query	\N	{"ip": "172.18.0.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "user_name": "student"}	2026-01-03 09:23:41+00
64	1	1	view	page	personal_homepage	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:23:41.75+00
65	1	1	list	query_snippet	\N	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:23:43+00
66	1	1	view_source	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:23:43.217+00
67	1	1	list	datasource	admin/data_sources	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:23:43+00
68	1	1	execute_query	data_source	1	{"query_id": "adhoc", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n    DATE(ts) AS \\"\\u0414\\u0430\\u0442\\u0430\\",\\r\\n    ROUND(SUM(steps) / 10, 0) AS \\"\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c\\",\\r\\n    ROUND(SUM(calories) / 60, 0) AS \\"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c\\",\\r\\n    ROUND(AVG(heart_rate), 0) AS \\"\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441\\"\\r\\nFROM fitness_data\\r\\nGROUP BY DATE(ts)\\r\\nORDER BY DATE(ts) DESC;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:24:07+00
69	1	1	execute_query	data_source	1	{"query_id": "adhoc", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n    DATE(ts) AS \\"\\u0414\\u0430\\u0442\\u0430\\",\\r\\n    ROUND(SUM(steps) / 10, 0) AS \\"\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c\\",\\r\\n    ROUND(SUM(calories) / 60, 0) AS \\"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c\\",\\r\\n    ROUND(AVG(heart_rate), 0) AS \\"\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441\\"\\r\\nFROM fitness_data\\r\\nGROUP BY DATE(ts)\\r\\nORDER BY DATE(ts) DESC;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:24:08+00
70	1	1	execute	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:24:08.134+00
71	1	1	execute	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:24:07.151+00
72	1	1	execute_query	data_source	1	{"query_id": "adhoc", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n    DATE(ts) AS \\"\\u0414\\u0430\\u0442\\u0430\\",\\r\\n    ROUND(SUM(steps) / 10, 0) AS \\"\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c\\",\\r\\n    ROUND(SUM(calories) / 60, 0) AS \\"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c\\",\\r\\n    ROUND(AVG(heart_rate), 0) AS \\"\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441\\"\\r\\nFROM fitness_data\\r\\nGROUP BY DATE(ts)\\r\\nORDER BY DATE(ts) DESC;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:24:09+00
73	1	1	execute	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:24:09.35+00
74	1	1	execute_query	data_source	1	{"query_id": "adhoc", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n    DATE(ts) AS \\"\\u0414\\u0430\\u0442\\u0430\\",\\r\\n    ROUND(SUM(steps) / 60, 0) AS \\"\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c\\",\\r\\n    ROUND(SUM(calories) / 60, 0) AS \\"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c\\",\\r\\n    ROUND(AVG(heart_rate), 0) AS \\"\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441\\"\\r\\nFROM fitness_data\\r\\nGROUP BY DATE(ts)\\r\\nORDER BY DATE(ts) DESC;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:24:19+00
75	1	1	execute	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:24:19.812+00
76	1	1	execute_query	data_source	1	{"query_id": "adhoc", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n    DATE(ts) AS \\"\\u0414\\u0430\\u0442\\u0430\\",\\r\\n    ROUND(SUM(steps) / 10, 0) AS \\"\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c\\",\\r\\n    ROUND(SUM(calories) / 60, 0) AS \\"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c\\",\\r\\n    ROUND(AVG(heart_rate), 0) AS \\"\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441\\"\\r\\nFROM fitness_data\\r\\nGROUP BY DATE(ts)\\r\\nORDER BY DATE(ts) DESC;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:24:25+00
77	1	1	execute	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:24:25.686+00
78	1	1	execute_query	data_source	1	{"query_id": "adhoc", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n    DATE(ts) AS \\"\\u0414\\u0430\\u0442\\u0430\\",\\r\\n    ROUND(SUM(steps) / 20, 0) AS \\"\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c\\",\\r\\n    ROUND(SUM(calories) / 60, 0) AS \\"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c\\",\\r\\n    ROUND(AVG(heart_rate), 0) AS \\"\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441\\"\\r\\nFROM fitness_data\\r\\nGROUP BY DATE(ts)\\r\\nORDER BY DATE(ts) DESC;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:24:39+00
79	1	1	execute	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:24:39.466+00
80	1	1	execute_query	data_source	1	{"query_id": "adhoc", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n    DATE(ts) AS \\"\\u0414\\u0430\\u0442\\u0430\\",\\r\\n    ROUND(SUM(steps) / 20, 0) AS \\"\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c\\",\\r\\n    ROUND(SUM(calories) / 60, 0) AS \\"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c\\",\\r\\n    ROUND(AVG(heart_rate), 0) AS \\"\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441\\"\\r\\nFROM fitness_data\\r\\nGROUP BY DATE(ts)\\r\\nORDER BY DATE(ts) DESC;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:24:46+00
81	1	1	execute	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:24:46.215+00
82	1	1	create	query	3	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:25:07+00
83	1	1	view	query	3	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:25:07+00
84	1	1	list	datasource	admin/data_sources	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:25:07+00
85	1	1	edit_name	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:25:06.911+00
86	1	1	view_source	query	3	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:25:07.146+00
87	1	1	list	query_snippet	\N	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:25:07+00
88	1	1	create	visualization	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "type": "CHART", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "user_name": "student"}	2026-01-03 09:25:15.645+00
89	1	1	execute_query	data_source	1	{"query_id": 3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n    DATE(ts) AS \\"Date\\",\\r\\n    ROUND(SUM(steps) / 20, 0) AS \\"Total steps per day\\",\\r\\n    ROUND(SUM(calories) / 60, 0) AS \\"Total calories per day\\",\\r\\n    ROUND(AVG(heart_rate), 0) AS \\"Average heart rate\\"\\r\\nFROM fitness_data\\r\\nGROUP BY DATE(ts)\\r\\nORDER BY DATE(ts) DESC;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:26:21+00
90	1	1	execute	query	3	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:26:21.113+00
91	1	1	execute_query	data_source	1	{"query_id": 3, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n    DATE(ts) AS \\"Date\\",\\r\\n    ROUND(SUM(steps) / 20, 0) AS \\"Total steps per day\\",\\r\\n    ROUND(SUM(calories) / 60, 0) AS \\"Total calories per day\\",\\r\\n    ROUND(AVG(heart_rate), 0) AS \\"Average heart rate\\"\\r\\nFROM fitness_data\\r\\nGROUP BY DATE(ts)\\r\\nORDER BY DATE(ts) DESC;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:26:23+00
92	1	1	execute	query	3	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:26:23.56+00
93	1	1	delete	Visualization	7	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:26:27+00
94	1	1	create	visualization	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "type": "CHART", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "user_name": "student"}	2026-01-03 09:26:33.766+00
95	1	1	toggle_published	query	3	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:26:44.801+00
96	1	1	load_favorites	dashboard	\N	{"ip": "172.18.0.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "user_name": "student"}	2026-01-03 09:26:46+00
97	1	1	load_favorites	query	\N	{"ip": "172.18.0.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "user_name": "student"}	2026-01-03 09:26:46+00
98	1	1	view	page	personal_homepage	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:26:46.46+00
99	1	1	list	datasource	admin/data_sources	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:26:47+00
100	1	1	list	query_snippet	\N	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:26:47+00
101	1	1	view_source	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:26:47.674+00
102	1	1	execute_query	data_source	1	{"query_id": "adhoc", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n    activity_type AS \\"\\u0410\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u044c\\",\\r\\n    heart_rate AS \\"\\u041f\\u0443\\u043b\\u044c\\u0441\\",\\r\\n    calories AS \\"\\u041a\\u0430\\u043b\\u043e\\u0440\\u0438\\u0438 (\\u0441\\u0435\\u043a)\\",\\r\\n    DATE_FORMAT(ts, '%H:%i:%S') AS \\"\\u0412\\u0440\\u0435\\u043c\\u044f \\u0437\\u0430\\u043c\\u0435\\u0440\\u0430\\"\\r\\nFROM fitness_data\\r\\nORDER BY ts DESC\\r\\nLIMIT 1;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:27:26+00
103	1	1	execute	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:27:26.026+00
104	1	1	execute_query	data_source	1	{"query_id": "adhoc", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n    activity_type AS \\"\\u0410\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u044c\\",\\r\\n    heart_rate AS \\"\\u041f\\u0443\\u043b\\u044c\\u0441\\",\\r\\n    calories AS \\"\\u041a\\u0430\\u043b\\u043e\\u0440\\u0438\\u0438 (\\u0441\\u0435\\u043a)\\",\\r\\n    DATE_FORMAT(ts, '%H:%i:%S') AS \\"\\u0412\\u0440\\u0435\\u043c\\u044f \\u0437\\u0430\\u043c\\u0435\\u0440\\u0430\\"\\r\\nFROM fitness_data\\r\\nORDER BY ts DESC\\r\\nLIMIT 1;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:27:27+00
105	1	1	execute	query	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:27:27.464+00
106	1	1	create	query	4	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:27:29+00
107	1	1	view	query	4	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:27:29+00
108	1	1	list	query_snippet	\N	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:27:29+00
109	1	1	list	datasource	admin/data_sources	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:27:29+00
110	1	1	view_source	query	4	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:27:29.471+00
111	1	1	edit_name	query	4	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:27:45.625+00
112	1	1	list	query	\N	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:27:48+00
113	1	1	load_favorites	dashboard	\N	{"ip": "172.18.0.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "user_name": "student"}	2026-01-03 09:27:50+00
114	1	1	load_favorites	query	\N	{"ip": "172.18.0.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "user_name": "student"}	2026-01-03 09:27:50+00
115	1	1	view	page	personal_homepage	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:27:50.388+00
116	1	1	view	dashboard	1	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:28:01+00
117	1	1	create	dashboard	\N	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:28:01.602+00
118	1	1	view	dashboard	1	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:28:01.726+00
119	1	1	view	query	4	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:28:05+00
120	1	1	view	widget	1	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:28:05.759+00
121	1	1	view	query	4	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "dashboard": true, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:28:05.759+00
122	1	1	view	visualization	9	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "dashboard": true, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:28:05.759+00
123	1	1	load_favorites	query	\N	{"ip": "172.18.0.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "user_name": "student"}	2026-01-03 09:28:09+00
124	1	1	load_favorites	dashboard	\N	{"ip": "172.18.0.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "user_name": "student"}	2026-01-03 09:28:09+00
125	1	1	view	page	personal_homepage	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:28:09.17+00
126	1	1	list	query	\N	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:28:10+00
127	1	1	view	query	4	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:28:11+00
128	1	1	list	datasource	admin/data_sources	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:28:11+00
129	1	1	view	query	4	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:28:13+00
130	1	1	list	datasource	admin/data_sources	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:28:13+00
131	1	1	list	query_snippet	\N	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:28:13+00
132	1	1	view_source	query	4	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:28:13.407+00
133	1	1	execute_query	data_source	1	{"query_id": 4, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n    activity_type AS \\"Type activity\\",\\r\\n    heart_rate AS \\"Pulse\\",\\r\\n    calories AS \\"Calories (sec)\\",\\r\\n    DATE_FORMAT(ts, '%H:%i:%S') AS \\"Measurement time\\"\\r\\nFROM fitness_data\\r\\nORDER BY ts DESC\\r\\nLIMIT 1;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:28:57+00
134	1	1	execute	query	4	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:28:57.139+00
135	1	1	list	dashboard	\N	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:03+00
136	1	1	view	dashboard	1	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:04+00
137	1	1	view	dashboard	1	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:04.623+00
138	1	1	view	widget	1	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:04.626+00
139	1	1	view	visualization	9	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "dashboard": true, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:04.626+00
140	1	1	view	query	4	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "dashboard": true, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:04.626+00
141	1	1	view	query	3	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:11+00
142	1	1	view	widget	2	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:12.839+00
143	1	1	view	visualization	6	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "dashboard": true, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:12.839+00
144	1	1	view	query	3	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "dashboard": true, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:12.839+00
145	1	1	view	query	3	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:15+00
146	1	1	view	widget	3	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:16.533+00
147	1	1	view	query	3	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "dashboard": true, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:16.533+00
148	1	1	view	visualization	8	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "dashboard": true, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:16.533+00
149	1	1	view	query	2	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:20+00
150	1	1	view	query	2	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "dashboard": true, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:21.344+00
151	1	1	view	visualization	4	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "dashboard": true, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:21.344+00
152	1	1	view	widget	4	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:21.344+00
153	1	1	view	query	2	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:28+00
154	1	1	view	widget	5	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:29.74+00
155	1	1	view	query	2	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "dashboard": true, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:29.74+00
156	1	1	view	visualization	5	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "dashboard": true, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:29.74+00
157	1	1	view	query	1	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:32+00
158	1	1	view	widget	6	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:33.532+00
159	1	1	view	query	1	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "dashboard": true, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:33.532+00
160	1	1	view	visualization	1	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "dashboard": true, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:33.532+00
161	1	1	execute_query	data_source	1	{"query_id": "1", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n                HOUR(ts) AS \\"Hour\\",\\r\\n                activity_type AS \\"Type activity\\",\\r\\n                ROUND(COUNT(*) / 60, 1) AS \\"Minutes\\"\\r\\n            FROM fitness_data\\r\\n            WHERE ts >= (SELECT MAX(ts) FROM fitness_data) - INTERVAL 24 HOUR\\r\\n            GROUP BY 1, 2\\r\\n            ORDER BY 1 ASC;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:29:37+00
162	1	1	view	query	1	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:49+00
163	1	1	view	query	1	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "dashboard": true, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:50.153+00
164	1	1	view	visualization	3	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "dashboard": true, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:50.153+00
165	1	1	view	widget	7	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:29:50.153+00
166	1	1	edit	dashboard	1	{"ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:30:00+00
167	1	1	toggle_published	dashboard	1	{"screen_resolution": "1536x864", "ip": "172.18.0.1", "user_name": "student", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0"}	2026-01-03 09:30:00.195+00
168	1	1	execute_query	data_source	1	{"query_id": "4", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n    activity_type AS \\"Type activity\\",\\r\\n    heart_rate AS \\"Pulse\\",\\r\\n    calories AS \\"Calories (sec)\\",\\r\\n    DATE_FORMAT(ts, '%H:%i:%S') AS \\"Measurement time\\"\\r\\nFROM fitness_data\\r\\nORDER BY ts DESC\\r\\nLIMIT 1;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:35:11+00
169	1	1	execute_query	data_source	1	{"query_id": "3", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n    DATE(ts) AS \\"Date\\",\\r\\n    ROUND(SUM(steps) / 20, 0) AS \\"Total steps per day\\",\\r\\n    ROUND(SUM(calories) / 60, 0) AS \\"Total calories per day\\",\\r\\n    ROUND(AVG(heart_rate), 0) AS \\"Average heart rate\\"\\r\\nFROM fitness_data\\r\\nGROUP BY DATE(ts)\\r\\nORDER BY DATE(ts) DESC;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:35:11+00
170	1	1	execute_query	data_source	1	{"query_id": "3", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n    DATE(ts) AS \\"Date\\",\\r\\n    ROUND(SUM(steps) / 20, 0) AS \\"Total steps per day\\",\\r\\n    ROUND(SUM(calories) / 60, 0) AS \\"Total calories per day\\",\\r\\n    ROUND(AVG(heart_rate), 0) AS \\"Average heart rate\\"\\r\\nFROM fitness_data\\r\\nGROUP BY DATE(ts)\\r\\nORDER BY DATE(ts) DESC;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:35:11+00
171	1	1	execute_query	data_source	1	{"query_id": "2", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n    DATE(ts) AS day,\\r\\n    ROUND(SUM(calories) / 60, 0) AS calories\\r\\nFROM fitness_data\\r\\nGROUP BY day\\r\\nORDER BY day;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:35:11+00
172	1	1	execute_query	data_source	1	{"query_id": "1", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n                HOUR(ts) AS \\"Hour\\",\\r\\n                activity_type AS \\"Type activity\\",\\r\\n                ROUND(COUNT(*) / 60, 1) AS \\"Minutes\\"\\r\\n            FROM fitness_data\\r\\n            WHERE ts >= (SELECT MAX(ts) FROM fitness_data) - INTERVAL 24 HOUR\\r\\n            GROUP BY 1, 2\\r\\n            ORDER BY 1 ASC;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:35:11+00
173	1	1	execute_query	data_source	1	{"query_id": "1", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n                HOUR(ts) AS \\"Hour\\",\\r\\n                activity_type AS \\"Type activity\\",\\r\\n                ROUND(COUNT(*) / 60, 1) AS \\"Minutes\\"\\r\\n            FROM fitness_data\\r\\n            WHERE ts >= (SELECT MAX(ts) FROM fitness_data) - INTERVAL 24 HOUR\\r\\n            GROUP BY 1, 2\\r\\n            ORDER BY 1 ASC;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:35:11+00
174	1	1	execute_query	data_source	1	{"query_id": "2", "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0", "parameters": {}, "query": "SELECT\\r\\n    DATE(ts) AS day,\\r\\n    ROUND(SUM(calories) / 60, 0) AS calories\\r\\nFROM fitness_data\\r\\nGROUP BY day\\r\\nORDER BY day;", "ip": "172.18.0.1", "cache": "miss", "user_name": "student"}	2026-01-03 09:35:11+00
\.


--
-- Data for Name: favorites; Type: TABLE DATA; Schema: public; Owner: redash
--

COPY public.favorites (updated_at, created_at, id, org_id, object_type, object_id, user_id) FROM stdin;
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: redash
--

COPY public.groups (id, org_id, type, name, permissions, created_at) FROM stdin;
1	1	builtin	admin	{admin,super_admin}	2026-01-03 09:18:29.701322+00
2	1	builtin	default	{create_dashboard,create_query,edit_dashboard,edit_query,view_query,view_source,execute_query,list_users,schedule_query,list_dashboards,list_alerts,list_data_sources}	2026-01-03 09:18:29.701322+00
\.


--
-- Data for Name: notification_destinations; Type: TABLE DATA; Schema: public; Owner: redash
--

COPY public.notification_destinations (id, org_id, user_id, name, type, options, created_at) FROM stdin;
\.


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: redash
--

COPY public.organizations (updated_at, created_at, id, name, slug, settings) FROM stdin;
2026-01-03 09:28:01.685461+00	2026-01-03 09:18:29.701322+00	1	akk123@gmail.com	default	{}
\.


--
-- Data for Name: queries; Type: TABLE DATA; Schema: public; Owner: redash
--

COPY public.queries (updated_at, created_at, id, version, org_id, data_source_id, latest_query_data_id, name, description, query, query_hash, api_key, user_id, last_modified_by_id, is_archived, is_draft, schedule, schedule_failures, options, search_vector, tags) FROM stdin;
2026-01-03 09:29:01.439872+00	2026-01-03 09:27:29.414107+00	4	1	1	1	25	Current status	\N	SELECT\r\n    activity_type AS "Type activity",\r\n    heart_rate AS "Pulse",\r\n    calories AS "Calories (sec)",\r\n    DATE_FORMAT(ts, '%H:%i:%S') AS "Measurement time"\r\nFROM fitness_data\r\nORDER BY ts DESC\r\nLIMIT 1;	f733f9a75cec4ea4cdcc87cc8a398919	9XOUUCEcWAkAnbvyvFw6KpzvDVsFpKQTzoWyC7Lt	1	1	f	f	\N	0	{"parameters": []}	'1':35 '4':1B 'activity':5,9 'as':7,12,15,24 'by':31 'calories':14,16 'current':2A 'data':29 'date':18 'desc':33 'fitness':28 'format':19 'from':27 'h':21 'heart':10 'i':22 'limit':34 'measurement':25 'order':30 'pulse':13 'rate':11 's':23 'sec':17 'select':4 'status':3A 'time':26 'ts':20,32 'type':6,8	\N
2026-01-03 09:26:44.770701+00	2026-01-03 09:25:06.99783+00	3	1	1	1	26	Reports for the day	\N	SELECT\r\n    DATE(ts) AS "Date",\r\n    ROUND(SUM(steps) / 20, 0) AS "Total steps per day",\r\n    ROUND(SUM(calories) / 60, 0) AS "Total calories per day",\r\n    ROUND(AVG(heart_rate), 0) AS "Average heart rate"\r\nFROM fitness_data\r\nGROUP BY DATE(ts)\r\nORDER BY DATE(ts) DESC;	7598f1f5293206e2d2b656d7e6be2927	l4BlhdxnFQbzjwzhhNjkALAcEsSJhgK05Ki5t0q6	1	1	f	f	\N	0	{"parameters": []}	'0':15,25,35 '20':14 '3':1B '60':24 'as':9,16,26,36 'average':37 'avg':32 'by':44,48 'calories':23,28 'data':42 'date':7,10,45,49 'day':5A,20,30 'desc':51 'fitness':41 'for':3A 'from':40 'group':43 'heart':33,38 'order':47 'per':19,29 'rate':34,39 'reports':2A 'round':11,21,31 'select':6 'steps':13,18 'sum':12,22 'the':4A 'total':17,27 'ts':8,46,50	\N
2026-01-03 09:23:34.323895+00	2026-01-03 09:22:23.013815+00	2	1	1	1	27	Calories per day	\N	SELECT\r\n    DATE(ts) AS day,\r\n    ROUND(SUM(calories) / 60, 0) AS calories\r\nFROM fitness_data\r\nGROUP BY day\r\nORDER BY day;	6939ce5afe06e649f904f1f69eb1d9ff	nI8r5gPGZvV7bmgDCQ0NASNFNZ7hKjlIigJkUy4O	1	1	f	f	\N	0	{"parameters": []}	'0':14 '2':1B '60':13 'as':8,15 'by':21,24 'calories':2A,12,16 'data':19 'date':6 'day':4A,9,22,25 'fitness':18 'from':17 'group':20 'order':23 'per':3A 'round':10 'select':5 'sum':11 'ts':7	\N
2026-01-03 09:20:55.752869+00	2026-01-03 09:19:17.042707+00	1	1	1	1	28	Results for the day	\N	SELECT\r\n                HOUR(ts) AS "Hour",\r\n                activity_type AS "Type activity",\r\n                ROUND(COUNT(*) / 60, 1) AS "Minutes"\r\n            FROM fitness_data\r\n            WHERE ts >= (SELECT MAX(ts) FROM fitness_data) - INTERVAL 24 HOUR\r\n            GROUP BY 1, 2\r\n            ORDER BY 1 ASC;	d4bdb897c92b22832988c87ed9e60d80	hAMc2BV1W1BTpkmh4TdEV3n98Jw8BPTbw281eLf6	1	1	f	f	\N	0	{"parameters": []}	'1':1B,19,38,42 '2':39 '24':34 '60':18 'activity':11,15 'as':9,13,20 'asc':43 'by':37,41 'count':17 'data':24,32 'day':5A 'fitness':23,31 'for':3A 'from':22,30 'group':36 'hour':7,10,35 'interval':33 'max':28 'minutes':21 'order':40 'results':2A 'round':16 'select':6,27 'the':4A 'ts':8,26,29 'type':12,14 'where':25	\N
\.


--
-- Data for Name: query_results; Type: TABLE DATA; Schema: public; Owner: redash
--

COPY public.query_results (id, org_id, data_source_id, query_hash, query, data, runtime, retrieved_at) FROM stdin;
1	1	1	3e9b8d03e37dbd58656b22dda4064b2f	SELECT\r\n                HOUR(ts) AS "Час",\r\n                activity_type AS "Тип активности",\r\n                ROUND(COUNT(*) / 60, 1) AS "Минуты"\r\n            FROM fitness_data\r\n            WHERE ts >= (SELECT MAX(ts) FROM fitness_data) - INTERVAL 24 HOUR\r\n            GROUP BY 1, 2\r\n            ORDER BY 1 ASC;	{"rows": [{"\\u0427\\u0430\\u0441": 0, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 3.9, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 0, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 116.1, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "sleep"}, {"\\u0427\\u0430\\u0441": 1, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "sleep"}, {"\\u0427\\u0430\\u0441": 2, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "sleep"}, {"\\u0427\\u0430\\u0441": 3, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "sleep"}, {"\\u0427\\u0430\\u0441": 4, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "sleep"}, {"\\u0427\\u0430\\u0441": 5, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "sleep"}, {"\\u0427\\u0430\\u0441": 6, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 14.2, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "sleep"}, {"\\u0427\\u0430\\u0441": 6, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 105.8, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 7, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 8, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 9, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 36.2, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 9, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 80.8, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 10, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 41.1, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 10, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 78.9, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 11, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 18.2, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 11, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 101.8, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 12, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 51.4, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 12, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 68.6, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 13, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 51.6, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 13, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 68.4, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 14, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 52.7, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 14, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 67.3, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 15, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 46.9, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 15, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 73.1, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 16, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 19.9, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 16, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 100.1, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 17, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 94.8, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "cycling"}, {"\\u0427\\u0430\\u0441": 17, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 5.4, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 17, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 19.8, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "run"}, {"\\u0427\\u0430\\u0441": 18, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 82.6, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "cycling"}, {"\\u0427\\u0430\\u0441": 18, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 37.5, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "run"}, {"\\u0427\\u0430\\u0441": 19, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 101.6, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "cycling"}, {"\\u0427\\u0430\\u0441": 19, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 18.4, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "run"}, {"\\u0427\\u0430\\u0441": 20, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 7.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "cycling"}, {"\\u0427\\u0430\\u0441": 20, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 113.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 21, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 22, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 23, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}], "columns": [{"type": "integer", "friendly_name": "\\u0427\\u0430\\u0441", "name": "\\u0427\\u0430\\u0441"}, {"type": "string", "friendly_name": "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438", "name": "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438"}, {"type": "float", "friendly_name": "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b", "name": "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b"}]}	0.21848797798156738	2026-01-03 09:19:10.169509+00
2	1	1	3e9b8d03e37dbd58656b22dda4064b2f	SELECT\r\n                HOUR(ts) AS "Час",\r\n                activity_type AS "Тип активности",\r\n                ROUND(COUNT(*) / 60, 1) AS "Минуты"\r\n            FROM fitness_data\r\n            WHERE ts >= (SELECT MAX(ts) FROM fitness_data) - INTERVAL 24 HOUR\r\n            GROUP BY 1, 2\r\n            ORDER BY 1 ASC;	{"rows": [{"\\u0427\\u0430\\u0441": 0, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 3.9, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 0, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 116.1, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "sleep"}, {"\\u0427\\u0430\\u0441": 1, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "sleep"}, {"\\u0427\\u0430\\u0441": 2, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "sleep"}, {"\\u0427\\u0430\\u0441": 3, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "sleep"}, {"\\u0427\\u0430\\u0441": 4, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "sleep"}, {"\\u0427\\u0430\\u0441": 5, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "sleep"}, {"\\u0427\\u0430\\u0441": 6, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 14.2, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "sleep"}, {"\\u0427\\u0430\\u0441": 6, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 105.8, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 7, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 8, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 9, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 36.2, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 9, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 80.8, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 10, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 41.1, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 10, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 78.9, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 11, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 18.2, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 11, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 101.8, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 12, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 51.4, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 12, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 68.6, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 13, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 51.6, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 13, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 68.4, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 14, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 52.7, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 14, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 67.3, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 15, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 46.9, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 15, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 73.1, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 16, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 19.9, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 16, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 100.1, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 17, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 94.8, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "cycling"}, {"\\u0427\\u0430\\u0441": 17, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 5.4, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 17, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 19.8, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "run"}, {"\\u0427\\u0430\\u0441": 18, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 82.6, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "cycling"}, {"\\u0427\\u0430\\u0441": 18, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 37.5, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "run"}, {"\\u0427\\u0430\\u0441": 19, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 101.6, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "cycling"}, {"\\u0427\\u0430\\u0441": 19, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 18.4, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "run"}, {"\\u0427\\u0430\\u0441": 20, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 7.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "cycling"}, {"\\u0427\\u0430\\u0441": 20, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 113.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 21, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 22, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 23, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}], "columns": [{"type": "integer", "friendly_name": "\\u0427\\u0430\\u0441", "name": "\\u0427\\u0430\\u0441"}, {"type": "string", "friendly_name": "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438", "name": "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438"}, {"type": "float", "friendly_name": "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b", "name": "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b"}]}	0.2163839340209961	2026-01-03 09:19:12.688324+00
3	1	1	3e9b8d03e37dbd58656b22dda4064b2f	SELECT\r\n                HOUR(ts) AS "Час",\r\n                activity_type AS "Тип активности",\r\n                ROUND(COUNT(*) / 60, 1) AS "Минуты"\r\n            FROM fitness_data\r\n            WHERE ts >= (SELECT MAX(ts) FROM fitness_data) - INTERVAL 24 HOUR\r\n            GROUP BY 1, 2\r\n            ORDER BY 1 ASC;	{"rows": [{"\\u0427\\u0430\\u0441": 0, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 3.9, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 0, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 116.1, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "sleep"}, {"\\u0427\\u0430\\u0441": 1, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "sleep"}, {"\\u0427\\u0430\\u0441": 2, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "sleep"}, {"\\u0427\\u0430\\u0441": 3, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "sleep"}, {"\\u0427\\u0430\\u0441": 4, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "sleep"}, {"\\u0427\\u0430\\u0441": 5, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "sleep"}, {"\\u0427\\u0430\\u0441": 6, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 14.2, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "sleep"}, {"\\u0427\\u0430\\u0441": 6, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 105.8, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 7, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 8, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 9, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 36.2, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 9, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 80.8, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 10, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 41.1, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 10, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 78.9, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 11, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 18.2, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 11, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 101.8, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 12, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 51.4, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 12, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 68.6, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 13, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 51.6, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 13, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 68.4, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 14, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 52.7, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 14, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 67.3, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 15, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 46.9, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 15, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 73.1, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 16, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 19.9, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 16, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 100.1, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "walk"}, {"\\u0427\\u0430\\u0441": 17, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 94.8, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "cycling"}, {"\\u0427\\u0430\\u0441": 17, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 5.4, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 17, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 19.8, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "run"}, {"\\u0427\\u0430\\u0441": 18, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 82.6, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "cycling"}, {"\\u0427\\u0430\\u0441": 18, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 37.5, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "run"}, {"\\u0427\\u0430\\u0441": 19, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 101.6, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "cycling"}, {"\\u0427\\u0430\\u0441": 19, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 18.4, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "run"}, {"\\u0427\\u0430\\u0441": 20, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 7.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "cycling"}, {"\\u0427\\u0430\\u0441": 20, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 113.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 21, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 22, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}, {"\\u0427\\u0430\\u0441": 23, "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b": 120.0, "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438": "rest"}], "columns": [{"type": "integer", "friendly_name": "\\u0427\\u0430\\u0441", "name": "\\u0427\\u0430\\u0441"}, {"type": "string", "friendly_name": "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438", "name": "\\u0422\\u0438\\u043f \\u0430\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u0438"}, {"type": "float", "friendly_name": "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b", "name": "\\u041c\\u0438\\u043d\\u0443\\u0442\\u044b"}]}	0.16596388816833496	2026-01-03 09:19:13.747123+00
4	1	1	d4bdb897c92b22832988c87ed9e60d80	SELECT\r\n                HOUR(ts) AS "Hour",\r\n                activity_type AS "Type activity",\r\n                ROUND(COUNT(*) / 60, 1) AS "Minutes"\r\n            FROM fitness_data\r\n            WHERE ts >= (SELECT MAX(ts) FROM fitness_data) - INTERVAL 24 HOUR\r\n            GROUP BY 1, 2\r\n            ORDER BY 1 ASC;	{"rows": [{"Type activity": "rest", "Minutes": 3.9, "Hour": 0}, {"Type activity": "sleep", "Minutes": 116.1, "Hour": 0}, {"Type activity": "sleep", "Minutes": 120.0, "Hour": 1}, {"Type activity": "sleep", "Minutes": 120.0, "Hour": 2}, {"Type activity": "sleep", "Minutes": 120.0, "Hour": 3}, {"Type activity": "sleep", "Minutes": 120.0, "Hour": 4}, {"Type activity": "sleep", "Minutes": 120.0, "Hour": 5}, {"Type activity": "sleep", "Minutes": 14.2, "Hour": 6}, {"Type activity": "walk", "Minutes": 105.8, "Hour": 6}, {"Type activity": "walk", "Minutes": 120.0, "Hour": 7}, {"Type activity": "walk", "Minutes": 120.0, "Hour": 8}, {"Type activity": "rest", "Minutes": 36.2, "Hour": 9}, {"Type activity": "walk", "Minutes": 79.7, "Hour": 9}, {"Type activity": "rest", "Minutes": 41.1, "Hour": 10}, {"Type activity": "walk", "Minutes": 78.9, "Hour": 10}, {"Type activity": "rest", "Minutes": 18.2, "Hour": 11}, {"Type activity": "walk", "Minutes": 101.8, "Hour": 11}, {"Type activity": "rest", "Minutes": 51.4, "Hour": 12}, {"Type activity": "walk", "Minutes": 68.6, "Hour": 12}, {"Type activity": "rest", "Minutes": 51.6, "Hour": 13}, {"Type activity": "walk", "Minutes": 68.4, "Hour": 13}, {"Type activity": "rest", "Minutes": 52.7, "Hour": 14}, {"Type activity": "walk", "Minutes": 67.3, "Hour": 14}, {"Type activity": "rest", "Minutes": 46.9, "Hour": 15}, {"Type activity": "walk", "Minutes": 73.1, "Hour": 15}, {"Type activity": "rest", "Minutes": 19.9, "Hour": 16}, {"Type activity": "walk", "Minutes": 100.1, "Hour": 16}, {"Type activity": "cycling", "Minutes": 94.8, "Hour": 17}, {"Type activity": "rest", "Minutes": 5.4, "Hour": 17}, {"Type activity": "run", "Minutes": 19.8, "Hour": 17}, {"Type activity": "cycling", "Minutes": 82.6, "Hour": 18}, {"Type activity": "run", "Minutes": 37.5, "Hour": 18}, {"Type activity": "cycling", "Minutes": 101.6, "Hour": 19}, {"Type activity": "run", "Minutes": 18.4, "Hour": 19}, {"Type activity": "cycling", "Minutes": 7.0, "Hour": 20}, {"Type activity": "rest", "Minutes": 113.0, "Hour": 20}, {"Type activity": "rest", "Minutes": 120.0, "Hour": 21}, {"Type activity": "rest", "Minutes": 120.0, "Hour": 22}, {"Type activity": "rest", "Minutes": 120.0, "Hour": 23}], "columns": [{"type": "integer", "friendly_name": "Hour", "name": "Hour"}, {"type": "string", "friendly_name": "Type activity", "name": "Type activity"}, {"type": "float", "friendly_name": "Minutes", "name": "Minutes"}]}	0.2190079689025879	2026-01-03 09:20:15.707995+00
5	1	1	6939ce5afe06e649f904f1f69eb1d9ff	SELECT\r\n              DATE(ts) AS day,\r\n              ROUND(SUM(calories) / 60, 0) AS calories\r\n            FROM fitness_data\r\n            GROUP BY day\r\n            ORDER BY day;	{"rows": [{"calories": 513.0, "day": "2026-01-01"}, {"calories": 677.0, "day": "2026-01-02"}, {"calories": 178.0, "day": "2026-01-03"}], "columns": [{"type": "date", "friendly_name": "day", "name": "day"}, {"type": "float", "friendly_name": "calories", "name": "calories"}]}	0.11573314666748047	2026-01-03 09:21:09.536867+00
6	1	1	6939ce5afe06e649f904f1f69eb1d9ff	SELECT\r\n              DATE(ts) AS day,\r\n              ROUND(SUM(calories) / 60, 0) AS calories\r\n            FROM fitness_data\r\n            GROUP BY day\r\n            ORDER BY day;	{"rows": [{"calories": 513.0, "day": "2026-01-01"}, {"calories": 677.0, "day": "2026-01-02"}, {"calories": 178.0, "day": "2026-01-03"}], "columns": [{"type": "date", "friendly_name": "day", "name": "day"}, {"type": "float", "friendly_name": "calories", "name": "calories"}]}	0.11529898643493652	2026-01-03 09:21:11.879171+00
7	1	1	6939ce5afe06e649f904f1f69eb1d9ff	SELECT\r\n              DATE(ts) AS day,\r\n              ROUND(SUM(calories) / 60, 0) AS calories\r\n            FROM fitness_data\r\n            GROUP BY day\r\n            ORDER BY day;	{"rows": [{"calories": 513.0, "day": "2026-01-01"}, {"calories": 677.0, "day": "2026-01-02"}, {"calories": 178.0, "day": "2026-01-03"}], "columns": [{"type": "date", "friendly_name": "day", "name": "day"}, {"type": "float", "friendly_name": "calories", "name": "calories"}]}	0.11765909194946289	2026-01-03 09:21:13.167922+00
8	1	1	6939ce5afe06e649f904f1f69eb1d9ff	SELECT\r\n    DATE(ts) AS day,\r\n    ROUND(SUM(calories) / 60, 0) AS calories\r\nFROM fitness_data\r\nGROUP BY day\r\nORDER BY day;	{"rows": [{"calories": 513.0, "day": "2026-01-01"}, {"calories": 677.0, "day": "2026-01-02"}, {"calories": 178.0, "day": "2026-01-03"}], "columns": [{"type": "date", "friendly_name": "day", "name": "day"}, {"type": "float", "friendly_name": "calories", "name": "calories"}]}	0.11812305450439453	2026-01-03 09:22:01.605251+00
9	1	1	6939ce5afe06e649f904f1f69eb1d9ff	SELECT\r\n    DATE(ts) AS day,\r\n    ROUND(SUM(calories) / 60, 0) AS calories\r\nFROM fitness_data\r\nGROUP BY day\r\nORDER BY day;	{"rows": [{"calories": 513.0, "day": "2026-01-01"}, {"calories": 677.0, "day": "2026-01-02"}, {"calories": 178.0, "day": "2026-01-03"}], "columns": [{"type": "date", "friendly_name": "day", "name": "day"}, {"type": "float", "friendly_name": "calories", "name": "calories"}]}	0.11614108085632324	2026-01-03 09:22:03.626523+00
10	1	1	6939ce5afe06e649f904f1f69eb1d9ff	SELECT\r\n    DATE(ts) AS day,\r\n    ROUND(SUM(calories) / 60, 0) AS calories\r\nFROM fitness_data\r\nGROUP BY day\r\nORDER BY day;	{"rows": [{"calories": 513.0, "day": "2026-01-01"}, {"calories": 677.0, "day": "2026-01-02"}, {"calories": 178.0, "day": "2026-01-03"}], "columns": [{"type": "date", "friendly_name": "day", "name": "day"}, {"type": "float", "friendly_name": "calories", "name": "calories"}]}	0.11608004570007324	2026-01-03 09:22:04.543789+00
11	1	1	4b06cfdbffebfe633a16433c13beba4b	SELECT\r\n    DATE(ts) AS "Дата",\r\n    ROUND(SUM(steps) / 10, 0) AS "Всего шагов за день",\r\n    ROUND(SUM(calories) / 60, 0) AS "Всего ккал за день",\r\n    ROUND(AVG(heart_rate), 0) AS "Средний пульс"\r\nFROM fitness_data\r\nGROUP BY DATE(ts)\r\nORDER BY DATE(ts) DESC;	{"rows": [{"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 178.0, "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 3511, "\\u0414\\u0430\\u0442\\u0430": "2026-01-03", "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441": 68}, {"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 677.0, "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 22251, "\\u0414\\u0430\\u0442\\u0430": "2026-01-02", "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441": 82}, {"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 513.0, "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 18694, "\\u0414\\u0430\\u0442\\u0430": "2026-01-01", "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441": 89}], "columns": [{"type": "date", "friendly_name": "\\u0414\\u0430\\u0442\\u0430", "name": "\\u0414\\u0430\\u0442\\u0430"}, {"type": "float", "friendly_name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c", "name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c"}, {"type": "float", "friendly_name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c", "name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c"}, {"type": "float", "friendly_name": "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441", "name": "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441"}]}	0.165985107421875	2026-01-03 09:24:07.31347+00
12	1	1	4b06cfdbffebfe633a16433c13beba4b	SELECT\r\n    DATE(ts) AS "Дата",\r\n    ROUND(SUM(steps) / 10, 0) AS "Всего шагов за день",\r\n    ROUND(SUM(calories) / 60, 0) AS "Всего ккал за день",\r\n    ROUND(AVG(heart_rate), 0) AS "Средний пульс"\r\nFROM fitness_data\r\nGROUP BY DATE(ts)\r\nORDER BY DATE(ts) DESC;	{"rows": [{"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 178.0, "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 3511, "\\u0414\\u0430\\u0442\\u0430": "2026-01-03", "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441": 68}, {"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 677.0, "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 22251, "\\u0414\\u0430\\u0442\\u0430": "2026-01-02", "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441": 82}, {"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 513.0, "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 18694, "\\u0414\\u0430\\u0442\\u0430": "2026-01-01", "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441": 89}], "columns": [{"type": "date", "friendly_name": "\\u0414\\u0430\\u0442\\u0430", "name": "\\u0414\\u0430\\u0442\\u0430"}, {"type": "float", "friendly_name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c", "name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c"}, {"type": "float", "friendly_name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c", "name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c"}, {"type": "float", "friendly_name": "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441", "name": "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441"}]}	0.1659870147705078	2026-01-03 09:24:08.288965+00
13	1	1	4b06cfdbffebfe633a16433c13beba4b	SELECT\r\n    DATE(ts) AS "Дата",\r\n    ROUND(SUM(steps) / 10, 0) AS "Всего шагов за день",\r\n    ROUND(SUM(calories) / 60, 0) AS "Всего ккал за день",\r\n    ROUND(AVG(heart_rate), 0) AS "Средний пульс"\r\nFROM fitness_data\r\nGROUP BY DATE(ts)\r\nORDER BY DATE(ts) DESC;	{"rows": [{"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 178.0, "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 3512, "\\u0414\\u0430\\u0442\\u0430": "2026-01-03", "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441": 68}, {"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 677.0, "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 22251, "\\u0414\\u0430\\u0442\\u0430": "2026-01-02", "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441": 82}, {"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 513.0, "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 18694, "\\u0414\\u0430\\u0442\\u0430": "2026-01-01", "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441": 89}], "columns": [{"type": "date", "friendly_name": "\\u0414\\u0430\\u0442\\u0430", "name": "\\u0414\\u0430\\u0442\\u0430"}, {"type": "float", "friendly_name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c", "name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c"}, {"type": "float", "friendly_name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c", "name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c"}, {"type": "float", "friendly_name": "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441", "name": "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441"}]}	0.16780495643615723	2026-01-03 09:24:12.081187+00
14	1	1	48ea237b2d1a09b7252c019e7b60f503	SELECT\r\n    DATE(ts) AS "Дата",\r\n    ROUND(SUM(steps) / 60, 0) AS "Всего шагов за день",\r\n    ROUND(SUM(calories) / 60, 0) AS "Всего ккал за день",\r\n    ROUND(AVG(heart_rate), 0) AS "Средний пульс"\r\nFROM fitness_data\r\nGROUP BY DATE(ts)\r\nORDER BY DATE(ts) DESC;	{"rows": [{"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 178.0, "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 585, "\\u0414\\u0430\\u0442\\u0430": "2026-01-03", "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441": 68}, {"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 677.0, "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 3709, "\\u0414\\u0430\\u0442\\u0430": "2026-01-02", "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441": 82}, {"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 513.0, "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 3116, "\\u0414\\u0430\\u0442\\u0430": "2026-01-01", "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441": 89}], "columns": [{"type": "date", "friendly_name": "\\u0414\\u0430\\u0442\\u0430", "name": "\\u0414\\u0430\\u0442\\u0430"}, {"type": "float", "friendly_name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c", "name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c"}, {"type": "float", "friendly_name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c", "name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c"}, {"type": "float", "friendly_name": "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441", "name": "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441"}]}	0.1684269905090332	2026-01-03 09:24:20.064625+00
15	1	1	4b06cfdbffebfe633a16433c13beba4b	SELECT\r\n    DATE(ts) AS "Дата",\r\n    ROUND(SUM(steps) / 10, 0) AS "Всего шагов за день",\r\n    ROUND(SUM(calories) / 60, 0) AS "Всего ккал за день",\r\n    ROUND(AVG(heart_rate), 0) AS "Средний пульс"\r\nFROM fitness_data\r\nGROUP BY DATE(ts)\r\nORDER BY DATE(ts) DESC;	{"rows": [{"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 178.0, "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 3514, "\\u0414\\u0430\\u0442\\u0430": "2026-01-03", "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441": 68}, {"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 677.0, "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 22251, "\\u0414\\u0430\\u0442\\u0430": "2026-01-02", "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441": 82}, {"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 513.0, "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 18694, "\\u0414\\u0430\\u0442\\u0430": "2026-01-01", "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441": 89}], "columns": [{"type": "date", "friendly_name": "\\u0414\\u0430\\u0442\\u0430", "name": "\\u0414\\u0430\\u0442\\u0430"}, {"type": "float", "friendly_name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c", "name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c"}, {"type": "float", "friendly_name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c", "name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c"}, {"type": "float", "friendly_name": "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441", "name": "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441"}]}	0.16585206985473633	2026-01-03 09:24:25.901211+00
16	1	1	6143211b6c93d493c68644ce464795d5	SELECT\r\n    DATE(ts) AS "Дата",\r\n    ROUND(SUM(steps) / 20, 0) AS "Всего шагов за день",\r\n    ROUND(SUM(calories) / 60, 0) AS "Всего ккал за день",\r\n    ROUND(AVG(heart_rate), 0) AS "Средний пульс"\r\nFROM fitness_data\r\nGROUP BY DATE(ts)\r\nORDER BY DATE(ts) DESC;	{"rows": [{"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 178.0, "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 1758, "\\u0414\\u0430\\u0442\\u0430": "2026-01-03", "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441": 68}, {"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 677.0, "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 11126, "\\u0414\\u0430\\u0442\\u0430": "2026-01-02", "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441": 82}, {"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 513.0, "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 9347, "\\u0414\\u0430\\u0442\\u0430": "2026-01-01", "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441": 89}], "columns": [{"type": "date", "friendly_name": "\\u0414\\u0430\\u0442\\u0430", "name": "\\u0414\\u0430\\u0442\\u0430"}, {"type": "float", "friendly_name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c", "name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c"}, {"type": "float", "friendly_name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c", "name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c"}, {"type": "float", "friendly_name": "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441", "name": "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441"}]}	0.16803979873657227	2026-01-03 09:24:39.688013+00
17	1	1	6143211b6c93d493c68644ce464795d5	SELECT\r\n    DATE(ts) AS "Дата",\r\n    ROUND(SUM(steps) / 20, 0) AS "Всего шагов за день",\r\n    ROUND(SUM(calories) / 60, 0) AS "Всего ккал за день",\r\n    ROUND(AVG(heart_rate), 0) AS "Средний пульс"\r\nFROM fitness_data\r\nGROUP BY DATE(ts)\r\nORDER BY DATE(ts) DESC;	{"rows": [{"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 178.0, "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 1758, "\\u0414\\u0430\\u0442\\u0430": "2026-01-03", "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441": 68}, {"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 677.0, "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 11126, "\\u0414\\u0430\\u0442\\u0430": "2026-01-02", "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441": 82}, {"\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 513.0, "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c": 9347, "\\u0414\\u0430\\u0442\\u0430": "2026-01-01", "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441": 89}], "columns": [{"type": "date", "friendly_name": "\\u0414\\u0430\\u0442\\u0430", "name": "\\u0414\\u0430\\u0442\\u0430"}, {"type": "float", "friendly_name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c", "name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u0448\\u0430\\u0433\\u043e\\u0432 \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c"}, {"type": "float", "friendly_name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c", "name": "\\u0412\\u0441\\u0435\\u0433\\u043e \\u043a\\u043a\\u0430\\u043b \\u0437\\u0430 \\u0434\\u0435\\u043d\\u044c"}, {"type": "float", "friendly_name": "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441", "name": "\\u0421\\u0440\\u0435\\u0434\\u043d\\u0438\\u0439 \\u043f\\u0443\\u043b\\u044c\\u0441"}]}	0.1663670539855957	2026-01-03 09:24:46.369097+00
18	1	1	7598f1f5293206e2d2b656d7e6be2927	SELECT\r\n    DATE(ts) AS "Date",\r\n    ROUND(SUM(steps) / 20, 0) AS "Total steps per day",\r\n    ROUND(SUM(calories) / 60, 0) AS "Total calories per day",\r\n    ROUND(AVG(heart_rate), 0) AS "Average heart rate"\r\nFROM fitness_data\r\nGROUP BY DATE(ts)\r\nORDER BY DATE(ts) DESC;	{"rows": [{"Date": "2026-01-03", "Average heart rate": 69, "Total steps per day": 1766, "Total calories per day": 178.0}, {"Date": "2026-01-02", "Average heart rate": 82, "Total steps per day": 11126, "Total calories per day": 677.0}, {"Date": "2026-01-01", "Average heart rate": 89, "Total steps per day": 9347, "Total calories per day": 513.0}], "columns": [{"type": "date", "friendly_name": "Date", "name": "Date"}, {"type": "float", "friendly_name": "Total steps per day", "name": "Total steps per day"}, {"type": "float", "friendly_name": "Total calories per day", "name": "Total calories per day"}, {"type": "float", "friendly_name": "Average heart rate", "name": "Average heart rate"}]}	0.1664748191833496	2026-01-03 09:26:21.297288+00
19	1	1	7598f1f5293206e2d2b656d7e6be2927	SELECT\r\n    DATE(ts) AS "Date",\r\n    ROUND(SUM(steps) / 20, 0) AS "Total steps per day",\r\n    ROUND(SUM(calories) / 60, 0) AS "Total calories per day",\r\n    ROUND(AVG(heart_rate), 0) AS "Average heart rate"\r\nFROM fitness_data\r\nGROUP BY DATE(ts)\r\nORDER BY DATE(ts) DESC;	{"rows": [{"Date": "2026-01-03", "Average heart rate": 69, "Total steps per day": 1766, "Total calories per day": 178.0}, {"Date": "2026-01-02", "Average heart rate": 82, "Total steps per day": 11126, "Total calories per day": 677.0}, {"Date": "2026-01-01", "Average heart rate": 89, "Total steps per day": 9347, "Total calories per day": 513.0}], "columns": [{"type": "date", "friendly_name": "Date", "name": "Date"}, {"type": "float", "friendly_name": "Total steps per day", "name": "Total steps per day"}, {"type": "float", "friendly_name": "Total calories per day", "name": "Total calories per day"}, {"type": "float", "friendly_name": "Average heart rate", "name": "Average heart rate"}]}	0.16659903526306152	2026-01-03 09:26:23.758938+00
20	1	1	6aeddf1be858a72506bd5c91319f84a9	SELECT\r\n    activity_type AS "Активность",\r\n    heart_rate AS "Пульс",\r\n    calories AS "Калории (сек)",\r\n    DATE_FORMAT(ts, '%H:%i:%S') AS "Время замера"\r\nFROM fitness_data\r\nORDER BY ts DESC\r\nLIMIT 1;	{"rows": [{"\\u0412\\u0440\\u0435\\u043c\\u044f \\u0437\\u0430\\u043c\\u0435\\u0440\\u0430": "09:27:27", "\\u041f\\u0443\\u043b\\u044c\\u0441": 94, "\\u041a\\u0430\\u043b\\u043e\\u0440\\u0438\\u0438 (\\u0441\\u0435\\u043a)": 0.08, "\\u0410\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u044c": "walk"}], "columns": [{"type": "string", "friendly_name": "\\u0410\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u044c", "name": "\\u0410\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u044c"}, {"type": "integer", "friendly_name": "\\u041f\\u0443\\u043b\\u044c\\u0441", "name": "\\u041f\\u0443\\u043b\\u044c\\u0441"}, {"type": "float", "friendly_name": "\\u041a\\u0430\\u043b\\u043e\\u0440\\u0438\\u0438 (\\u0441\\u0435\\u043a)", "name": "\\u041a\\u0430\\u043b\\u043e\\u0440\\u0438\\u0438 (\\u0441\\u0435\\u043a)"}, {"type": "string", "friendly_name": "\\u0412\\u0440\\u0435\\u043c\\u044f \\u0437\\u0430\\u043c\\u0435\\u0440\\u0430", "name": "\\u0412\\u0440\\u0435\\u043c\\u044f \\u0437\\u0430\\u043c\\u0435\\u0440\\u0430"}]}	0.11634111404418945	2026-01-03 09:27:26.202614+00
21	1	1	6aeddf1be858a72506bd5c91319f84a9	SELECT\r\n    activity_type AS "Активность",\r\n    heart_rate AS "Пульс",\r\n    calories AS "Калории (сек)",\r\n    DATE_FORMAT(ts, '%H:%i:%S') AS "Время замера"\r\nFROM fitness_data\r\nORDER BY ts DESC\r\nLIMIT 1;	{"rows": [{"\\u0412\\u0440\\u0435\\u043c\\u044f \\u0437\\u0430\\u043c\\u0435\\u0440\\u0430": "09:27:28", "\\u041f\\u0443\\u043b\\u044c\\u0441": 93, "\\u041a\\u0430\\u043b\\u043e\\u0440\\u0438\\u0438 (\\u0441\\u0435\\u043a)": 0.04, "\\u0410\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u044c": "walk"}], "columns": [{"type": "string", "friendly_name": "\\u0410\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u044c", "name": "\\u0410\\u043a\\u0442\\u0438\\u0432\\u043d\\u043e\\u0441\\u0442\\u044c"}, {"type": "integer", "friendly_name": "\\u041f\\u0443\\u043b\\u044c\\u0441", "name": "\\u041f\\u0443\\u043b\\u044c\\u0441"}, {"type": "float", "friendly_name": "\\u041a\\u0430\\u043b\\u043e\\u0440\\u0438\\u0438 (\\u0441\\u0435\\u043a)", "name": "\\u041a\\u0430\\u043b\\u043e\\u0440\\u0438\\u0438 (\\u0441\\u0435\\u043a)"}, {"type": "string", "friendly_name": "\\u0412\\u0440\\u0435\\u043c\\u044f \\u0437\\u0430\\u043c\\u0435\\u0440\\u0430", "name": "\\u0412\\u0440\\u0435\\u043c\\u044f \\u0437\\u0430\\u043c\\u0435\\u0440\\u0430"}]}	0.11601710319519043	2026-01-03 09:27:27.650946+00
22	1	1	f733f9a75cec4ea4cdcc87cc8a398919	SELECT\r\n    activity_type AS "Type activity",\r\n    heart_rate AS "Pulse",\r\n    calories AS "Calories (sec)",\r\n    DATE_FORMAT(ts, '%H:%i:%S') AS "Measurement time"\r\nFROM fitness_data\r\nORDER BY ts DESC\r\nLIMIT 1;	{"rows": [{"Type activity": "walk", "Calories (sec)": 0.04, "Pulse": 97, "Measurement time": "09:28:58"}], "columns": [{"type": "string", "friendly_name": "Type activity", "name": "Type activity"}, {"type": "integer", "friendly_name": "Pulse", "name": "Pulse"}, {"type": "float", "friendly_name": "Calories (sec)", "name": "Calories (sec)"}, {"type": "string", "friendly_name": "Measurement time", "name": "Measurement time"}]}	0.11998105049133301	2026-01-03 09:28:57.33094+00
23	1	1	d4bdb897c92b22832988c87ed9e60d80	SELECT\r\n                HOUR(ts) AS "Hour",\r\n                activity_type AS "Type activity",\r\n                ROUND(COUNT(*) / 60, 1) AS "Minutes"\r\n            FROM fitness_data\r\n            WHERE ts >= (SELECT MAX(ts) FROM fitness_data) - INTERVAL 24 HOUR\r\n            GROUP BY 1, 2\r\n            ORDER BY 1 ASC;	{"rows": [{"Type activity": "rest", "Minutes": 3.9, "Hour": 0}, {"Type activity": "sleep", "Minutes": 116.1, "Hour": 0}, {"Type activity": "sleep", "Minutes": 120.0, "Hour": 1}, {"Type activity": "sleep", "Minutes": 120.0, "Hour": 2}, {"Type activity": "sleep", "Minutes": 120.0, "Hour": 3}, {"Type activity": "sleep", "Minutes": 120.0, "Hour": 4}, {"Type activity": "sleep", "Minutes": 120.0, "Hour": 5}, {"Type activity": "sleep", "Minutes": 14.2, "Hour": 6}, {"Type activity": "walk", "Minutes": 105.8, "Hour": 6}, {"Type activity": "walk", "Minutes": 120.0, "Hour": 7}, {"Type activity": "walk", "Minutes": 120.0, "Hour": 8}, {"Type activity": "rest", "Minutes": 36.2, "Hour": 9}, {"Type activity": "walk", "Minutes": 70.4, "Hour": 9}, {"Type activity": "rest", "Minutes": 41.1, "Hour": 10}, {"Type activity": "walk", "Minutes": 78.9, "Hour": 10}, {"Type activity": "rest", "Minutes": 18.2, "Hour": 11}, {"Type activity": "walk", "Minutes": 101.8, "Hour": 11}, {"Type activity": "rest", "Minutes": 51.4, "Hour": 12}, {"Type activity": "walk", "Minutes": 68.6, "Hour": 12}, {"Type activity": "rest", "Minutes": 51.6, "Hour": 13}, {"Type activity": "walk", "Minutes": 68.4, "Hour": 13}, {"Type activity": "rest", "Minutes": 52.7, "Hour": 14}, {"Type activity": "walk", "Minutes": 67.3, "Hour": 14}, {"Type activity": "rest", "Minutes": 46.9, "Hour": 15}, {"Type activity": "walk", "Minutes": 73.1, "Hour": 15}, {"Type activity": "rest", "Minutes": 19.9, "Hour": 16}, {"Type activity": "walk", "Minutes": 100.1, "Hour": 16}, {"Type activity": "cycling", "Minutes": 94.8, "Hour": 17}, {"Type activity": "rest", "Minutes": 5.4, "Hour": 17}, {"Type activity": "run", "Minutes": 19.8, "Hour": 17}, {"Type activity": "cycling", "Minutes": 82.6, "Hour": 18}, {"Type activity": "run", "Minutes": 37.5, "Hour": 18}, {"Type activity": "cycling", "Minutes": 101.6, "Hour": 19}, {"Type activity": "run", "Minutes": 18.4, "Hour": 19}, {"Type activity": "cycling", "Minutes": 7.0, "Hour": 20}, {"Type activity": "rest", "Minutes": 113.0, "Hour": 20}, {"Type activity": "rest", "Minutes": 120.0, "Hour": 21}, {"Type activity": "rest", "Minutes": 120.0, "Hour": 22}, {"Type activity": "rest", "Minutes": 120.0, "Hour": 23}], "columns": [{"type": "integer", "friendly_name": "Hour", "name": "Hour"}, {"type": "string", "friendly_name": "Type activity", "name": "Type activity"}, {"type": "float", "friendly_name": "Minutes", "name": "Minutes"}]}	0.17070698738098145	2026-01-03 09:29:38.171381+00
24	1	1	7598f1f5293206e2d2b656d7e6be2927	SELECT\r\n    DATE(ts) AS "Date",\r\n    ROUND(SUM(steps) / 20, 0) AS "Total steps per day",\r\n    ROUND(SUM(calories) / 60, 0) AS "Total calories per day",\r\n    ROUND(AVG(heart_rate), 0) AS "Average heart rate"\r\nFROM fitness_data\r\nGROUP BY DATE(ts)\r\nORDER BY DATE(ts) DESC;	{"rows": [{"Date": "2026-01-03", "Average heart rate": 69, "Total steps per day": 1806, "Total calories per day": 181.0}, {"Date": "2026-01-02", "Average heart rate": 82, "Total steps per day": 11126, "Total calories per day": 677.0}, {"Date": "2026-01-01", "Average heart rate": 89, "Total steps per day": 9347, "Total calories per day": 513.0}], "columns": [{"type": "date", "friendly_name": "Date", "name": "Date"}, {"type": "float", "friendly_name": "Total steps per day", "name": "Total steps per day"}, {"type": "float", "friendly_name": "Total calories per day", "name": "Total calories per day"}, {"type": "float", "friendly_name": "Average heart rate", "name": "Average heart rate"}]}	0.1736750602722168	2026-01-03 09:35:11.918707+00
25	1	1	f733f9a75cec4ea4cdcc87cc8a398919	SELECT\r\n    activity_type AS "Type activity",\r\n    heart_rate AS "Pulse",\r\n    calories AS "Calories (sec)",\r\n    DATE_FORMAT(ts, '%H:%i:%S') AS "Measurement time"\r\nFROM fitness_data\r\nORDER BY ts DESC\r\nLIMIT 1;	{"rows": [{"Type activity": "rest", "Calories (sec)": 0.5, "Pulse": 66, "Measurement time": "09:35:13"}], "columns": [{"type": "string", "friendly_name": "Type activity", "name": "Type activity"}, {"type": "integer", "friendly_name": "Pulse", "name": "Pulse"}, {"type": "float", "friendly_name": "Calories (sec)", "name": "Calories (sec)"}, {"type": "string", "friendly_name": "Measurement time", "name": "Measurement time"}]}	0.11565685272216797	2026-01-03 09:35:12.113766+00
26	1	1	7598f1f5293206e2d2b656d7e6be2927	SELECT\r\n    DATE(ts) AS "Date",\r\n    ROUND(SUM(steps) / 20, 0) AS "Total steps per day",\r\n    ROUND(SUM(calories) / 60, 0) AS "Total calories per day",\r\n    ROUND(AVG(heart_rate), 0) AS "Average heart rate"\r\nFROM fitness_data\r\nGROUP BY DATE(ts)\r\nORDER BY DATE(ts) DESC;	{"rows": [{"Date": "2026-01-03", "Average heart rate": 69, "Total steps per day": 1806, "Total calories per day": 181.0}, {"Date": "2026-01-02", "Average heart rate": 82, "Total steps per day": 11126, "Total calories per day": 677.0}, {"Date": "2026-01-01", "Average heart rate": 89, "Total steps per day": 9347, "Total calories per day": 513.0}], "columns": [{"type": "date", "friendly_name": "Date", "name": "Date"}, {"type": "float", "friendly_name": "Total steps per day", "name": "Total steps per day"}, {"type": "float", "friendly_name": "Total calories per day", "name": "Total calories per day"}, {"type": "float", "friendly_name": "Average heart rate", "name": "Average heart rate"}]}	0.21587800979614258	2026-01-03 09:35:12.351786+00
27	1	1	6939ce5afe06e649f904f1f69eb1d9ff	SELECT\r\n    DATE(ts) AS day,\r\n    ROUND(SUM(calories) / 60, 0) AS calories\r\nFROM fitness_data\r\nGROUP BY day\r\nORDER BY day;	{"rows": [{"calories": 513.0, "day": "2026-01-01"}, {"calories": 677.0, "day": "2026-01-02"}, {"calories": 181.0, "day": "2026-01-03"}], "columns": [{"type": "date", "friendly_name": "day", "name": "day"}, {"type": "float", "friendly_name": "calories", "name": "calories"}]}	0.1182560920715332	2026-01-03 09:35:12.575711+00
28	1	1	d4bdb897c92b22832988c87ed9e60d80	SELECT\r\n                HOUR(ts) AS "Hour",\r\n                activity_type AS "Type activity",\r\n                ROUND(COUNT(*) / 60, 1) AS "Minutes"\r\n            FROM fitness_data\r\n            WHERE ts >= (SELECT MAX(ts) FROM fitness_data) - INTERVAL 24 HOUR\r\n            GROUP BY 1, 2\r\n            ORDER BY 1 ASC;	{"rows": [{"Type activity": "rest", "Minutes": 3.9, "Hour": 0}, {"Type activity": "sleep", "Minutes": 116.1, "Hour": 0}, {"Type activity": "sleep", "Minutes": 120.0, "Hour": 1}, {"Type activity": "sleep", "Minutes": 120.0, "Hour": 2}, {"Type activity": "sleep", "Minutes": 120.0, "Hour": 3}, {"Type activity": "sleep", "Minutes": 120.0, "Hour": 4}, {"Type activity": "sleep", "Minutes": 120.0, "Hour": 5}, {"Type activity": "sleep", "Minutes": 14.2, "Hour": 6}, {"Type activity": "walk", "Minutes": 105.8, "Hour": 6}, {"Type activity": "walk", "Minutes": 120.0, "Hour": 7}, {"Type activity": "walk", "Minutes": 120.0, "Hour": 8}, {"Type activity": "rest", "Minutes": 39.2, "Hour": 9}, {"Type activity": "walk", "Minutes": 61.8, "Hour": 9}, {"Type activity": "rest", "Minutes": 41.1, "Hour": 10}, {"Type activity": "walk", "Minutes": 78.9, "Hour": 10}, {"Type activity": "rest", "Minutes": 18.2, "Hour": 11}, {"Type activity": "walk", "Minutes": 101.8, "Hour": 11}, {"Type activity": "rest", "Minutes": 51.4, "Hour": 12}, {"Type activity": "walk", "Minutes": 68.6, "Hour": 12}, {"Type activity": "rest", "Minutes": 51.6, "Hour": 13}, {"Type activity": "walk", "Minutes": 68.4, "Hour": 13}, {"Type activity": "rest", "Minutes": 52.7, "Hour": 14}, {"Type activity": "walk", "Minutes": 67.3, "Hour": 14}, {"Type activity": "rest", "Minutes": 46.9, "Hour": 15}, {"Type activity": "walk", "Minutes": 73.1, "Hour": 15}, {"Type activity": "rest", "Minutes": 19.9, "Hour": 16}, {"Type activity": "walk", "Minutes": 100.1, "Hour": 16}, {"Type activity": "cycling", "Minutes": 94.8, "Hour": 17}, {"Type activity": "rest", "Minutes": 5.4, "Hour": 17}, {"Type activity": "run", "Minutes": 19.8, "Hour": 17}, {"Type activity": "cycling", "Minutes": 82.6, "Hour": 18}, {"Type activity": "run", "Minutes": 37.5, "Hour": 18}, {"Type activity": "cycling", "Minutes": 101.6, "Hour": 19}, {"Type activity": "run", "Minutes": 18.4, "Hour": 19}, {"Type activity": "cycling", "Minutes": 7.0, "Hour": 20}, {"Type activity": "rest", "Minutes": 113.0, "Hour": 20}, {"Type activity": "rest", "Minutes": 120.0, "Hour": 21}, {"Type activity": "rest", "Minutes": 120.0, "Hour": 22}, {"Type activity": "rest", "Minutes": 120.0, "Hour": 23}], "columns": [{"type": "integer", "friendly_name": "Hour", "name": "Hour"}, {"type": "string", "friendly_name": "Type activity", "name": "Type activity"}, {"type": "float", "friendly_name": "Minutes", "name": "Minutes"}]}	0.16582989692687988	2026-01-03 09:35:12.779122+00
\.


--
-- Data for Name: query_snippets; Type: TABLE DATA; Schema: public; Owner: redash
--

COPY public.query_snippets (updated_at, created_at, id, org_id, trigger, description, user_id, snippet) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: redash
--

COPY public.users (updated_at, created_at, id, org_id, name, email, profile_image_url, password_hash, groups, api_key, disabled_at, details) FROM stdin;
2026-01-03 09:28:01.685461+00	2026-01-03 09:18:29.756876+00	1	1	student	akk123@gmail.com	\N	$6$rounds=107499$HpJ85ByLR6ubPw6a$GjF8DyXJz1vpadm3G7t65ivs944JfiFMyTZ48yPiIsf7Z4EZP44144FX4PxLhjgX4.AbMoBD5L2Lz/cc6O1ub.	{1,2}	OZdvMExHyz8u6ZCi5qXFA5TbzJutA6FXWSeSQZ25	\N	{}
\.


--
-- Data for Name: visualizations; Type: TABLE DATA; Schema: public; Owner: redash
--

COPY public.visualizations (updated_at, created_at, id, type, query_id, name, description, options) FROM stdin;
2026-01-03 09:28:05.715989+00	2026-01-03 09:27:29.414107+00	9	TABLE	4	Table		{}
2026-01-03 09:29:12.767254+00	2026-01-03 09:25:06.99783+00	6	TABLE	3	Table		{}
2026-01-03 09:29:16.474925+00	2026-01-03 09:26:33.77788+00	8	CHART	3	Chart		{"direction": {"type": "counterclockwise"}, "missingValuesAsZero": true, "error_y": {"visible": true, "type": "data"}, "numberFormat": "0,0[.]00000", "yAxis": [{"type": "linear"}, {"type": "linear", "opposite": true}], "series": {"stacking": null, "error_y": {"visible": true, "type": "data"}}, "globalSeriesType": "column", "percentFormat": "0[.]00%", "sortX": true, "seriesOptions": {"Total steps per day": {"zIndex": 0, "index": 0, "type": "column", "yAxis": 0}, "Total calories per day": {"zIndex": 1, "index": 0, "type": "column", "yAxis": 0}}, "customCode": "// Available variables are x, ys, element, and Plotly\\n// Type console.log(x, ys); for more info about x and ys\\n// To plot your graph call Plotly.plot(element, ...)\\n// Plotly examples and docs: https://plot.ly/javascript/", "valuesOptions": {}, "xAxis": {"labels": {"enabled": true}, "type": "-"}, "dateTimeFormat": "DD/MM/YY HH:mm", "columnMapping": {"Date": "x", "Total steps per day": "y", "Total calories per day": "y"}, "textFormat": "", "showDataLabels": false, "legend": {"enabled": true}}
2026-01-03 09:29:21.314483+00	2026-01-03 09:22:23.013815+00	4	TABLE	2	Table		{}
2026-01-03 09:29:29.777947+00	2026-01-03 09:22:34.37696+00	5	CHART	2	Chart		{"direction": {"type": "counterclockwise"}, "missingValuesAsZero": true, "error_y": {"visible": true, "type": "data"}, "numberFormat": "0,0[.]00000", "yAxis": [{"type": "linear"}, {"type": "linear", "opposite": true}], "series": {"stacking": null, "error_y": {"visible": true, "type": "data"}}, "globalSeriesType": "line", "percentFormat": "0[.]00%", "sortX": true, "seriesOptions": {"calories": {"zIndex": 0, "index": 0, "type": "line", "yAxis": 0}}, "customCode": "// Available variables are x, ys, element, and Plotly\\n// Type console.log(x, ys); for more info about x and ys\\n// To plot your graph call Plotly.plot(element, ...)\\n// Plotly examples and docs: https://plot.ly/javascript/", "valuesOptions": {}, "xAxis": {"labels": {"enabled": true}, "type": "-"}, "dateTimeFormat": "DD/MM/YY HH:mm", "columnMapping": {"calories": "y", "day": "x"}, "textFormat": "", "showDataLabels": false, "legend": {"enabled": true}}
2026-01-03 09:29:33.501682+00	2026-01-03 09:19:17.042707+00	1	TABLE	1	Table		{}
2026-01-03 09:29:50.116264+00	2026-01-03 09:20:33.062257+00	3	CHART	1	Chart		{"direction": {"type": "counterclockwise"}, "missingValuesAsZero": true, "error_y": {"visible": true, "type": "data"}, "numberFormat": "0,0[.]00000", "yAxis": [{"type": "linear"}, {"type": "linear", "opposite": true}], "series": {"stacking": null, "error_y": {"visible": true, "type": "data"}}, "globalSeriesType": "column", "percentFormat": "0[.]00%", "sortX": true, "seriesOptions": {"cycling": {"zIndex": 3, "index": 0, "type": "column", "yAxis": 0}, "run": {"zIndex": 4, "index": 0, "type": "column", "yAxis": 0}, "sleep": {"zIndex": 1, "index": 0, "type": "column", "yAxis": 0}, "rest": {"zIndex": 0, "index": 0, "type": "column", "yAxis": 0}, "walk": {"zIndex": 2, "index": 0, "type": "column", "yAxis": 0}}, "customCode": "// Available variables are x, ys, element, and Plotly\\n// Type console.log(x, ys); for more info about x and ys\\n// To plot your graph call Plotly.plot(element, ...)\\n// Plotly examples and docs: https://plot.ly/javascript/", "valuesOptions": {}, "xAxis": {"labels": {"enabled": true}, "type": "-"}, "dateTimeFormat": "DD/MM/YY HH:mm", "columnMapping": {"Type activity": "series", "Minutes": "y", "Hour": "x"}, "textFormat": "", "showDataLabels": false, "legend": {"enabled": true}}
\.


--
-- Data for Name: widgets; Type: TABLE DATA; Schema: public; Owner: redash
--

COPY public.widgets (updated_at, created_at, id, visualization_id, text, width, options, dashboard_id) FROM stdin;
2026-01-03 09:29:45.218344+00	2026-01-03 09:29:33.501682+00	6	1		1	{"parameterMappings": {}, "isHidden": false, "position": {"autoHeight": false, "sizeX": 2, "sizeY": 8, "maxSizeY": 1000, "maxSizeX": 6, "minSizeY": 1, "minSizeX": 2, "col": 3, "row": 14}}	1
2026-01-03 09:28:09.401665+00	2026-01-03 09:28:05.715989+00	1	9		1	{"parameterMappings": {}, "isHidden": false, "position": {"autoHeight": false, "sizeX": 3, "sizeY": 4, "maxSizeY": 1000, "maxSizeX": 6, "minSizeY": 1, "minSizeX": 2, "col": 0, "row": 0}}	1
2026-01-03 09:29:50.172959+00	2026-01-03 09:29:50.116264+00	7	3		1	{"parameterMappings": {}, "isHidden": false, "position": {"autoHeight": false, "sizeX": 3, "sizeY": 8, "maxSizeY": 1000, "maxSizeX": 6, "minSizeY": 5, "minSizeX": 1, "col": 0, "row": 18}}	1
2026-01-03 09:29:15.017909+00	2026-01-03 09:29:12.767254+00	2	6		1	{"parameterMappings": {}, "isHidden": false, "position": {"autoHeight": true, "sizeX": 3, "sizeY": 6, "maxSizeY": 1000, "maxSizeX": 6, "minSizeY": 1, "minSizeX": 2, "col": 3, "row": 0}}	1
2026-01-03 09:29:20.367895+00	2026-01-03 09:29:16.474925+00	3	8		1	{"parameterMappings": {}, "isHidden": false, "position": {"autoHeight": false, "sizeX": 3, "sizeY": 8, "maxSizeY": 1000, "maxSizeX": 6, "minSizeY": 5, "minSizeX": 1, "col": 3, "row": 6}}	1
2026-01-03 09:29:27.61605+00	2026-01-03 09:29:21.314483+00	4	4		1	{"parameterMappings": {}, "isHidden": false, "position": {"autoHeight": false, "sizeX": 2, "sizeY": 6, "maxSizeY": 1000, "maxSizeX": 6, "minSizeY": 1, "minSizeX": 2, "col": 0, "row": 4}}	1
2026-01-03 09:29:29.958716+00	2026-01-03 09:29:29.777947+00	5	5		1	{"parameterMappings": {}, "isHidden": false, "position": {"autoHeight": false, "sizeX": 3, "sizeY": 8, "maxSizeY": 1000, "maxSizeX": 6, "minSizeY": 5, "minSizeX": 1, "col": 0, "row": 10}}	1
\.


--
-- Name: access_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: redash
--

SELECT pg_catalog.setval('public.access_permissions_id_seq', 1, false);


--
-- Name: alert_subscriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: redash
--

SELECT pg_catalog.setval('public.alert_subscriptions_id_seq', 1, false);


--
-- Name: alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: redash
--

SELECT pg_catalog.setval('public.alerts_id_seq', 1, false);


--
-- Name: api_keys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: redash
--

SELECT pg_catalog.setval('public.api_keys_id_seq', 1, false);


--
-- Name: changes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: redash
--

SELECT pg_catalog.setval('public.changes_id_seq', 5, true);


--
-- Name: dashboards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: redash
--

SELECT pg_catalog.setval('public.dashboards_id_seq', 1, true);


--
-- Name: data_source_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: redash
--

SELECT pg_catalog.setval('public.data_source_groups_id_seq', 1, true);


--
-- Name: data_sources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: redash
--

SELECT pg_catalog.setval('public.data_sources_id_seq', 1, true);


--
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: redash
--

SELECT pg_catalog.setval('public.events_id_seq', 174, true);


--
-- Name: favorites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: redash
--

SELECT pg_catalog.setval('public.favorites_id_seq', 1, false);


--
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: redash
--

SELECT pg_catalog.setval('public.groups_id_seq', 2, true);


--
-- Name: notification_destinations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: redash
--

SELECT pg_catalog.setval('public.notification_destinations_id_seq', 1, false);


--
-- Name: organizations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: redash
--

SELECT pg_catalog.setval('public.organizations_id_seq', 1, true);


--
-- Name: queries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: redash
--

SELECT pg_catalog.setval('public.queries_id_seq', 4, true);


--
-- Name: query_results_id_seq; Type: SEQUENCE SET; Schema: public; Owner: redash
--

SELECT pg_catalog.setval('public.query_results_id_seq', 28, true);


--
-- Name: query_snippets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: redash
--

SELECT pg_catalog.setval('public.query_snippets_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: redash
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: visualizations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: redash
--

SELECT pg_catalog.setval('public.visualizations_id_seq', 9, true);


--
-- Name: widgets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: redash
--

SELECT pg_catalog.setval('public.widgets_id_seq', 7, true);


--
-- Name: access_permissions access_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.access_permissions
    ADD CONSTRAINT access_permissions_pkey PRIMARY KEY (id);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: alert_subscriptions alert_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.alert_subscriptions
    ADD CONSTRAINT alert_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: alerts alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_pkey PRIMARY KEY (id);


--
-- Name: api_keys api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: changes changes_pkey; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.changes
    ADD CONSTRAINT changes_pkey PRIMARY KEY (id);


--
-- Name: dashboards dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.dashboards
    ADD CONSTRAINT dashboards_pkey PRIMARY KEY (id);


--
-- Name: data_source_groups data_source_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.data_source_groups
    ADD CONSTRAINT data_source_groups_pkey PRIMARY KEY (id);


--
-- Name: data_sources data_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.data_sources
    ADD CONSTRAINT data_sources_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: notification_destinations notification_destinations_pkey; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.notification_destinations
    ADD CONSTRAINT notification_destinations_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_slug_key; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_slug_key UNIQUE (slug);


--
-- Name: queries queries_pkey; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.queries
    ADD CONSTRAINT queries_pkey PRIMARY KEY (id);


--
-- Name: query_results query_results_pkey; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.query_results
    ADD CONSTRAINT query_results_pkey PRIMARY KEY (id);


--
-- Name: query_snippets query_snippets_pkey; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.query_snippets
    ADD CONSTRAINT query_snippets_pkey PRIMARY KEY (id);


--
-- Name: query_snippets query_snippets_trigger_key; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.query_snippets
    ADD CONSTRAINT query_snippets_trigger_key UNIQUE (trigger);


--
-- Name: favorites unique_favorite; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT unique_favorite UNIQUE (object_type, object_id, user_id);


--
-- Name: users users_api_key_key; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_api_key_key UNIQUE (api_key);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: visualizations visualizations_pkey; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.visualizations
    ADD CONSTRAINT visualizations_pkey PRIMARY KEY (id);


--
-- Name: widgets widgets_pkey; Type: CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.widgets
    ADD CONSTRAINT widgets_pkey PRIMARY KEY (id);


--
-- Name: alert_subscriptions_destination_id_alert_id; Type: INDEX; Schema: public; Owner: redash
--

CREATE UNIQUE INDEX alert_subscriptions_destination_id_alert_id ON public.alert_subscriptions USING btree (destination_id, alert_id);


--
-- Name: api_keys_object_type_object_id; Type: INDEX; Schema: public; Owner: redash
--

CREATE INDEX api_keys_object_type_object_id ON public.api_keys USING btree (object_type, object_id);


--
-- Name: data_sources_org_id_name; Type: INDEX; Schema: public; Owner: redash
--

CREATE INDEX data_sources_org_id_name ON public.data_sources USING btree (org_id, name);


--
-- Name: ix_api_keys_api_key; Type: INDEX; Schema: public; Owner: redash
--

CREATE INDEX ix_api_keys_api_key ON public.api_keys USING btree (api_key);


--
-- Name: ix_dashboards_is_archived; Type: INDEX; Schema: public; Owner: redash
--

CREATE INDEX ix_dashboards_is_archived ON public.dashboards USING btree (is_archived);


--
-- Name: ix_dashboards_is_draft; Type: INDEX; Schema: public; Owner: redash
--

CREATE INDEX ix_dashboards_is_draft ON public.dashboards USING btree (is_draft);


--
-- Name: ix_dashboards_slug; Type: INDEX; Schema: public; Owner: redash
--

CREATE INDEX ix_dashboards_slug ON public.dashboards USING btree (slug);


--
-- Name: ix_queries_is_archived; Type: INDEX; Schema: public; Owner: redash
--

CREATE INDEX ix_queries_is_archived ON public.queries USING btree (is_archived);


--
-- Name: ix_queries_is_draft; Type: INDEX; Schema: public; Owner: redash
--

CREATE INDEX ix_queries_is_draft ON public.queries USING btree (is_draft);


--
-- Name: ix_queries_search_vector; Type: INDEX; Schema: public; Owner: redash
--

CREATE INDEX ix_queries_search_vector ON public.queries USING gin (search_vector);


--
-- Name: ix_query_results_query_hash; Type: INDEX; Schema: public; Owner: redash
--

CREATE INDEX ix_query_results_query_hash ON public.query_results USING btree (query_hash);


--
-- Name: ix_widgets_dashboard_id; Type: INDEX; Schema: public; Owner: redash
--

CREATE INDEX ix_widgets_dashboard_id ON public.widgets USING btree (dashboard_id);


--
-- Name: notification_destinations_org_id_name; Type: INDEX; Schema: public; Owner: redash
--

CREATE UNIQUE INDEX notification_destinations_org_id_name ON public.notification_destinations USING btree (org_id, name);


--
-- Name: users_org_id_email; Type: INDEX; Schema: public; Owner: redash
--

CREATE UNIQUE INDEX users_org_id_email ON public.users USING btree (org_id, email);


--
-- Name: queries queries_search_vector_trigger; Type: TRIGGER; Schema: public; Owner: redash
--

CREATE TRIGGER queries_search_vector_trigger BEFORE INSERT OR UPDATE ON public.queries FOR EACH ROW EXECUTE FUNCTION public.queries_search_vector_update();


--
-- Name: access_permissions access_permissions_grantee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.access_permissions
    ADD CONSTRAINT access_permissions_grantee_id_fkey FOREIGN KEY (grantee_id) REFERENCES public.users(id);


--
-- Name: access_permissions access_permissions_grantor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.access_permissions
    ADD CONSTRAINT access_permissions_grantor_id_fkey FOREIGN KEY (grantor_id) REFERENCES public.users(id);


--
-- Name: alert_subscriptions alert_subscriptions_alert_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.alert_subscriptions
    ADD CONSTRAINT alert_subscriptions_alert_id_fkey FOREIGN KEY (alert_id) REFERENCES public.alerts(id);


--
-- Name: alert_subscriptions alert_subscriptions_destination_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.alert_subscriptions
    ADD CONSTRAINT alert_subscriptions_destination_id_fkey FOREIGN KEY (destination_id) REFERENCES public.notification_destinations(id);


--
-- Name: alert_subscriptions alert_subscriptions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.alert_subscriptions
    ADD CONSTRAINT alert_subscriptions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: alerts alerts_query_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_query_id_fkey FOREIGN KEY (query_id) REFERENCES public.queries(id);


--
-- Name: alerts alerts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: api_keys api_keys_created_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_created_by_id_fkey FOREIGN KEY (created_by_id) REFERENCES public.users(id);


--
-- Name: api_keys api_keys_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: changes changes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.changes
    ADD CONSTRAINT changes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: dashboards dashboards_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.dashboards
    ADD CONSTRAINT dashboards_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: dashboards dashboards_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.dashboards
    ADD CONSTRAINT dashboards_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: data_source_groups data_source_groups_data_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.data_source_groups
    ADD CONSTRAINT data_source_groups_data_source_id_fkey FOREIGN KEY (data_source_id) REFERENCES public.data_sources(id);


--
-- Name: data_source_groups data_source_groups_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.data_source_groups
    ADD CONSTRAINT data_source_groups_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- Name: data_sources data_sources_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.data_sources
    ADD CONSTRAINT data_sources_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: events events_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: events events_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: favorites favorites_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: favorites favorites_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: groups groups_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: notification_destinations notification_destinations_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.notification_destinations
    ADD CONSTRAINT notification_destinations_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: notification_destinations notification_destinations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.notification_destinations
    ADD CONSTRAINT notification_destinations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: queries queries_data_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.queries
    ADD CONSTRAINT queries_data_source_id_fkey FOREIGN KEY (data_source_id) REFERENCES public.data_sources(id);


--
-- Name: queries queries_last_modified_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.queries
    ADD CONSTRAINT queries_last_modified_by_id_fkey FOREIGN KEY (last_modified_by_id) REFERENCES public.users(id);


--
-- Name: queries queries_latest_query_data_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.queries
    ADD CONSTRAINT queries_latest_query_data_id_fkey FOREIGN KEY (latest_query_data_id) REFERENCES public.query_results(id);


--
-- Name: queries queries_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.queries
    ADD CONSTRAINT queries_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: queries queries_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.queries
    ADD CONSTRAINT queries_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: query_results query_results_data_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.query_results
    ADD CONSTRAINT query_results_data_source_id_fkey FOREIGN KEY (data_source_id) REFERENCES public.data_sources(id);


--
-- Name: query_results query_results_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.query_results
    ADD CONSTRAINT query_results_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: query_snippets query_snippets_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.query_snippets
    ADD CONSTRAINT query_snippets_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: query_snippets query_snippets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.query_snippets
    ADD CONSTRAINT query_snippets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: users users_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: visualizations visualizations_query_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.visualizations
    ADD CONSTRAINT visualizations_query_id_fkey FOREIGN KEY (query_id) REFERENCES public.queries(id);


--
-- Name: widgets widgets_dashboard_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.widgets
    ADD CONSTRAINT widgets_dashboard_id_fkey FOREIGN KEY (dashboard_id) REFERENCES public.dashboards(id);


--
-- Name: widgets widgets_visualization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: redash
--

ALTER TABLE ONLY public.widgets
    ADD CONSTRAINT widgets_visualization_id_fkey FOREIGN KEY (visualization_id) REFERENCES public.visualizations(id);


--
-- PostgreSQL database dump complete
--

\unrestrict 34CgBhFepXLHb4J4cPCfDQq0MckPIfwtPDVo6Ebmmmyzk1m2Nzy1nj6TXiPG8RW

