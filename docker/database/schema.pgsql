--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5 (Debian 10.5-1.pgdg90+1)
-- Dumped by pg_dump version 10.5 (Debian 10.5-1.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: linkedevents
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO linkedevents;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: linkedevents
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO linkedevents;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: linkedevents
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO linkedevents;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: linkedevents
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: account_emailaddress; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.account_emailaddress (
    id integer NOT NULL,
    email character varying(254) NOT NULL,
    verified boolean NOT NULL,
    "primary" boolean NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.account_emailaddress OWNER TO linkedevents;

--
-- Name: account_emailaddress_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.account_emailaddress_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_emailaddress_id_seq OWNER TO linkedevents;

--
-- Name: account_emailaddress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.account_emailaddress_id_seq OWNED BY public.account_emailaddress.id;


--
-- Name: account_emailconfirmation; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.account_emailconfirmation (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    sent timestamp with time zone,
    key character varying(64) NOT NULL,
    email_address_id integer NOT NULL
);


ALTER TABLE public.account_emailconfirmation OWNER TO linkedevents;

--
-- Name: account_emailconfirmation_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.account_emailconfirmation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_emailconfirmation_id_seq OWNER TO linkedevents;

--
-- Name: account_emailconfirmation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.account_emailconfirmation_id_seq OWNED BY public.account_emailconfirmation.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO linkedevents;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO linkedevents;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO linkedevents;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO linkedevents;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO linkedevents;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO linkedevents;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: authtoken_token; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.authtoken_token (
    key character varying(40) NOT NULL,
    created timestamp with time zone NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.authtoken_token OWNER TO linkedevents;

--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO linkedevents;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO linkedevents;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO linkedevents;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO linkedevents;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO linkedevents;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO linkedevents;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_orghierarchy_organization; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.django_orghierarchy_organization (
    id character varying(255) NOT NULL,
    origin_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    founding_date date,
    dissolution_date date,
    created_time timestamp with time zone NOT NULL,
    last_modified_time timestamp with time zone NOT NULL,
    lft integer NOT NULL,
    rght integer NOT NULL,
    tree_id integer NOT NULL,
    level integer NOT NULL,
    classification_id character varying(255),
    created_by_id integer,
    data_source_id character varying(100),
    last_modified_by_id integer,
    parent_id character varying(255),
    replaced_by_id character varying(255),
    internal_type character varying(20) NOT NULL,
    CONSTRAINT django_orghierarchy_organization_level_check CHECK ((level >= 0)),
    CONSTRAINT django_orghierarchy_organization_lft_check CHECK ((lft >= 0)),
    CONSTRAINT django_orghierarchy_organization_rght_check CHECK ((rght >= 0)),
    CONSTRAINT django_orghierarchy_organization_tree_id_check CHECK ((tree_id >= 0))
);


ALTER TABLE public.django_orghierarchy_organization OWNER TO linkedevents;

--
-- Name: django_orghierarchy_organization_admin_users; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.django_orghierarchy_organization_admin_users (
    id integer NOT NULL,
    organization_id character varying(255) NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.django_orghierarchy_organization_admin_users OWNER TO linkedevents;

--
-- Name: django_orghierarchy_organization_admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.django_orghierarchy_organization_admin_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_orghierarchy_organization_admin_users_id_seq OWNER TO linkedevents;

--
-- Name: django_orghierarchy_organization_admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.django_orghierarchy_organization_admin_users_id_seq OWNED BY public.django_orghierarchy_organization_admin_users.id;


--
-- Name: django_orghierarchy_organization_regular_users; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.django_orghierarchy_organization_regular_users (
    id integer NOT NULL,
    organization_id character varying(255) NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.django_orghierarchy_organization_regular_users OWNER TO linkedevents;

--
-- Name: django_orghierarchy_organization_regular_users_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.django_orghierarchy_organization_regular_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_orghierarchy_organization_regular_users_id_seq OWNER TO linkedevents;

--
-- Name: django_orghierarchy_organization_regular_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.django_orghierarchy_organization_regular_users_id_seq OWNED BY public.django_orghierarchy_organization_regular_users.id;


--
-- Name: django_orghierarchy_organizationclass; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.django_orghierarchy_organizationclass (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    created_time timestamp with time zone NOT NULL,
    data_source_id character varying(100),
    last_modified_time timestamp with time zone NOT NULL,
    origin_id character varying(255) NOT NULL
);


ALTER TABLE public.django_orghierarchy_organizationclass OWNER TO linkedevents;

--
-- Name: django_orghierarchy_organizationclass_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.django_orghierarchy_organizationclass_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_orghierarchy_organizationclass_id_seq OWNER TO linkedevents;

--
-- Name: django_orghierarchy_organizationclass_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.django_orghierarchy_organizationclass_id_seq OWNED BY public.django_orghierarchy_organizationclass.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO linkedevents;

--
-- Name: django_site; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.django_site (
    id integer NOT NULL,
    domain character varying(100) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.django_site OWNER TO linkedevents;

--
-- Name: django_site_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.django_site_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_site_id_seq OWNER TO linkedevents;

--
-- Name: django_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.django_site_id_seq OWNED BY public.django_site.id;


--
-- Name: events_apikeyuser; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.events_apikeyuser (
    user_ptr_id integer NOT NULL,
    data_source_id character varying(100) NOT NULL
);


ALTER TABLE public.events_apikeyuser OWNER TO linkedevents;

--
-- Name: events_datasource; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.events_datasource (
    id character varying(100) NOT NULL,
    name character varying(255) NOT NULL,
    api_key character varying(128) NOT NULL,
    owner_id character varying(255),
    user_editable boolean NOT NULL
);


ALTER TABLE public.events_datasource OWNER TO linkedevents;

--
-- Name: events_event; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.events_event (
    id character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    name_fi character varying(255),
    name_sv character varying(255),
    name_en character varying(255),
    origin_id character varying(50),
    created_time timestamp with time zone,
    last_modified_time timestamp with time zone,
    info_url character varying(1000),
    info_url_fi character varying(1000),
    info_url_sv character varying(1000),
    info_url_en character varying(1000),
    description text,
    description_fi text,
    description_sv text,
    description_en text,
    short_description text,
    short_description_fi text,
    short_description_sv text,
    short_description_en text,
    date_published timestamp with time zone,
    headline character varying(255),
    headline_fi character varying(255),
    headline_sv character varying(255),
    headline_en character varying(255),
    secondary_headline character varying(255),
    secondary_headline_fi character varying(255),
    secondary_headline_sv character varying(255),
    secondary_headline_en character varying(255),
    provider character varying(512),
    provider_fi character varying(512),
    provider_sv character varying(512),
    provider_en character varying(512),
    event_status smallint NOT NULL,
    location_extra_info character varying(400),
    location_extra_info_fi character varying(400),
    location_extra_info_sv character varying(400),
    location_extra_info_en character varying(400),
    start_time timestamp with time zone,
    end_time timestamp with time zone,
    has_start_time boolean NOT NULL,
    has_end_time boolean NOT NULL,
    lft integer NOT NULL,
    rght integer NOT NULL,
    tree_id integer NOT NULL,
    level integer NOT NULL,
    created_by_id integer,
    data_source_id character varying(100) NOT NULL,
    last_modified_by_id integer,
    location_id character varying(50),
    publisher_id character varying(255) NOT NULL,
    super_event_id character varying(50),
    custom_data public.hstore,
    publication_status smallint NOT NULL,
    image_id integer,
    deleted boolean NOT NULL,
    super_event_type character varying(255),
    provider_email character varying(254),
    provider_phone character varying(128),
    provider_contact_name character varying(255),
    provider_contact_email character varying(254),
    provider_contact_phone character varying(128),
    provider_link character varying(1000),
    tickets_info character varying(255),
    tickets_info_en character varying(255),
    tickets_info_fi character varying(255),
    tickets_info_sv character varying(255),
    provider_name character varying(512),
    "position" public.geometry(Point,3067),
    CONSTRAINT events_event_level_check CHECK ((level >= 0)),
    CONSTRAINT events_event_lft_check CHECK ((lft >= 0)),
    CONSTRAINT events_event_rght_check CHECK ((rght >= 0)),
    CONSTRAINT events_event_tree_id_check CHECK ((tree_id >= 0))
);


ALTER TABLE public.events_event OWNER TO linkedevents;

--
-- Name: events_event_audience; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.events_event_audience (
    id integer NOT NULL,
    event_id character varying(50) NOT NULL,
    keyword_id character varying(50) NOT NULL
);


ALTER TABLE public.events_event_audience OWNER TO linkedevents;

--
-- Name: events_event_audience_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.events_event_audience_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_event_audience_id_seq OWNER TO linkedevents;

--
-- Name: events_event_audience_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.events_event_audience_id_seq OWNED BY public.events_event_audience.id;


--
-- Name: events_event_in_language; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.events_event_in_language (
    id integer NOT NULL,
    event_id character varying(50) NOT NULL,
    language_id character varying(6) NOT NULL
);


ALTER TABLE public.events_event_in_language OWNER TO linkedevents;

--
-- Name: events_event_in_language_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.events_event_in_language_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_event_in_language_id_seq OWNER TO linkedevents;

--
-- Name: events_event_in_language_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.events_event_in_language_id_seq OWNED BY public.events_event_in_language.id;


--
-- Name: events_event_keywords; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.events_event_keywords (
    id integer NOT NULL,
    event_id character varying(50) NOT NULL,
    keyword_id character varying(50) NOT NULL
);


ALTER TABLE public.events_event_keywords OWNER TO linkedevents;

--
-- Name: events_event_keywords_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.events_event_keywords_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_event_keywords_id_seq OWNER TO linkedevents;

--
-- Name: events_event_keywords_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.events_event_keywords_id_seq OWNED BY public.events_event_keywords.id;


--
-- Name: events_eventaggregate; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.events_eventaggregate (
    id integer NOT NULL,
    super_event_id character varying(50)
);


ALTER TABLE public.events_eventaggregate OWNER TO linkedevents;

--
-- Name: events_eventaggregate_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.events_eventaggregate_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_eventaggregate_id_seq OWNER TO linkedevents;

--
-- Name: events_eventaggregate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.events_eventaggregate_id_seq OWNED BY public.events_eventaggregate.id;


--
-- Name: events_eventaggregatemember; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.events_eventaggregatemember (
    id integer NOT NULL,
    event_id character varying(50) NOT NULL,
    event_aggregate_id integer NOT NULL
);


ALTER TABLE public.events_eventaggregatemember OWNER TO linkedevents;

--
-- Name: events_eventaggregatemember_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.events_eventaggregatemember_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_eventaggregatemember_id_seq OWNER TO linkedevents;

--
-- Name: events_eventaggregatemember_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.events_eventaggregatemember_id_seq OWNED BY public.events_eventaggregatemember.id;


--
-- Name: events_eventlink; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.events_eventlink (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    link character varying(200) NOT NULL,
    event_id character varying(50) NOT NULL,
    language_id character varying(6) NOT NULL
);


ALTER TABLE public.events_eventlink OWNER TO linkedevents;

--
-- Name: events_eventlink_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.events_eventlink_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_eventlink_id_seq OWNER TO linkedevents;

--
-- Name: events_eventlink_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.events_eventlink_id_seq OWNED BY public.events_eventlink.id;


--
-- Name: events_exportinfo; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.events_exportinfo (
    id integer NOT NULL,
    target_id character varying(255),
    target_system character varying(255),
    last_exported_time timestamp with time zone,
    object_id character varying(50) NOT NULL,
    content_type_id integer NOT NULL
);


ALTER TABLE public.events_exportinfo OWNER TO linkedevents;

--
-- Name: events_exportinfo_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.events_exportinfo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_exportinfo_id_seq OWNER TO linkedevents;

--
-- Name: events_exportinfo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.events_exportinfo_id_seq OWNED BY public.events_exportinfo.id;


--
-- Name: events_image; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.events_image (
    id integer NOT NULL,
    created_time timestamp with time zone NOT NULL,
    last_modified_time timestamp with time zone NOT NULL,
    image character varying(100),
    url character varying(400),
    cropping character varying(255) NOT NULL,
    created_by_id integer,
    last_modified_by_id integer,
    publisher_id character varying(255),
    name character varying(255) NOT NULL,
    license_id character varying(50) NOT NULL,
    photographer_name character varying(255),
    data_source_id character varying(100)
);


ALTER TABLE public.events_image OWNER TO linkedevents;

--
-- Name: events_image_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.events_image_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_image_id_seq OWNER TO linkedevents;

--
-- Name: events_image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.events_image_id_seq OWNED BY public.events_image.id;


--
-- Name: events_keyword; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.events_keyword (
    id character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    name_fi character varying(255),
    name_sv character varying(255),
    name_en character varying(255),
    origin_id character varying(50),
    created_time timestamp with time zone,
    last_modified_time timestamp with time zone,
    aggregate boolean NOT NULL,
    created_by_id integer,
    data_source_id character varying(100) NOT NULL,
    last_modified_by_id integer,
    image_id integer,
    deprecated boolean NOT NULL,
    n_events integer NOT NULL,
    n_events_changed boolean NOT NULL,
    publisher_id character varying(255)
);


ALTER TABLE public.events_keyword OWNER TO linkedevents;

--
-- Name: events_keyword_alt_labels; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.events_keyword_alt_labels (
    id integer NOT NULL,
    keyword_id character varying(50) NOT NULL,
    keywordlabel_id integer NOT NULL
);


ALTER TABLE public.events_keyword_alt_labels OWNER TO linkedevents;

--
-- Name: events_keyword_alt_labels_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.events_keyword_alt_labels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_keyword_alt_labels_id_seq OWNER TO linkedevents;

--
-- Name: events_keyword_alt_labels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.events_keyword_alt_labels_id_seq OWNED BY public.events_keyword_alt_labels.id;


--
-- Name: events_keywordlabel; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.events_keywordlabel (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    language_id character varying(6) NOT NULL
);


ALTER TABLE public.events_keywordlabel OWNER TO linkedevents;

--
-- Name: events_keywordlabel_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.events_keywordlabel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_keywordlabel_id_seq OWNER TO linkedevents;

--
-- Name: events_keywordlabel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.events_keywordlabel_id_seq OWNED BY public.events_keywordlabel.id;


--
-- Name: events_keywordset; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.events_keywordset (
    id character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    name_fi character varying(255),
    name_sv character varying(255),
    name_en character varying(255),
    origin_id character varying(50),
    created_time timestamp with time zone,
    last_modified_time timestamp with time zone,
    usage smallint NOT NULL,
    created_by_id integer,
    data_source_id character varying(100) NOT NULL,
    last_modified_by_id integer,
    organization_id character varying(255),
    image_id integer
);


ALTER TABLE public.events_keywordset OWNER TO linkedevents;

--
-- Name: events_keywordset_keywords; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.events_keywordset_keywords (
    id integer NOT NULL,
    keywordset_id character varying(50) NOT NULL,
    keyword_id character varying(50) NOT NULL
);


ALTER TABLE public.events_keywordset_keywords OWNER TO linkedevents;

--
-- Name: events_keywordset_keywords_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.events_keywordset_keywords_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_keywordset_keywords_id_seq OWNER TO linkedevents;

--
-- Name: events_keywordset_keywords_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.events_keywordset_keywords_id_seq OWNED BY public.events_keywordset_keywords.id;


--
-- Name: events_language; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.events_language (
    id character varying(6) NOT NULL,
    name character varying(20) NOT NULL,
    name_fi character varying(20),
    name_sv character varying(20),
    name_en character varying(20)
);


ALTER TABLE public.events_language OWNER TO linkedevents;

--
-- Name: events_license; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.events_license (
    id character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    name_fi character varying(255),
    name_sv character varying(255),
    name_en character varying(255),
    url character varying(200) NOT NULL
);


ALTER TABLE public.events_license OWNER TO linkedevents;

--
-- Name: events_offer; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.events_offer (
    id integer NOT NULL,
    price character varying(1000) NOT NULL,
    price_fi character varying(1000),
    price_sv character varying(1000),
    price_en character varying(1000),
    info_url character varying(1000),
    info_url_fi character varying(1000),
    info_url_sv character varying(1000),
    info_url_en character varying(1000),
    description text,
    description_fi text,
    description_sv text,
    description_en text,
    is_free boolean NOT NULL,
    event_id character varying(50) NOT NULL
);


ALTER TABLE public.events_offer OWNER TO linkedevents;

--
-- Name: events_offer_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.events_offer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_offer_id_seq OWNER TO linkedevents;

--
-- Name: events_offer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.events_offer_id_seq OWNED BY public.events_offer.id;


--
-- Name: events_openinghoursspecification; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.events_openinghoursspecification (
    id integer NOT NULL,
    opens time without time zone,
    closes time without time zone,
    days_of_week smallint,
    valid_from timestamp with time zone,
    valid_through timestamp with time zone,
    place_id character varying(50) NOT NULL
);


ALTER TABLE public.events_openinghoursspecification OWNER TO linkedevents;

--
-- Name: events_openinghoursspecification_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.events_openinghoursspecification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_openinghoursspecification_id_seq OWNER TO linkedevents;

--
-- Name: events_openinghoursspecification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.events_openinghoursspecification_id_seq OWNED BY public.events_openinghoursspecification.id;


--
-- Name: events_place; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.events_place (
    id character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    name_fi character varying(255),
    name_sv character varying(255),
    name_en character varying(255),
    origin_id character varying(50),
    created_time timestamp with time zone,
    last_modified_time timestamp with time zone,
    info_url character varying(1000) NOT NULL,
    info_url_fi character varying(1000),
    info_url_sv character varying(1000),
    info_url_en character varying(1000),
    description text,
    description_fi text,
    description_sv text,
    description_en text,
    "position" public.geometry(Point,3067),
    email character varying(254),
    telephone character varying(128),
    telephone_fi character varying(128),
    telephone_sv character varying(128),
    telephone_en character varying(128),
    contact_type character varying(255),
    street_address character varying(255),
    street_address_fi character varying(255),
    street_address_sv character varying(255),
    street_address_en character varying(255),
    address_locality character varying(255),
    address_locality_fi character varying(255),
    address_locality_sv character varying(255),
    address_locality_en character varying(255),
    address_region character varying(255),
    postal_code character varying(128),
    post_office_box_num character varying(128),
    address_country character varying(2),
    deleted boolean NOT NULL,
    lft integer NOT NULL,
    rght integer NOT NULL,
    tree_id integer NOT NULL,
    level integer NOT NULL,
    created_by_id integer,
    data_source_id character varying(100) NOT NULL,
    last_modified_by_id integer,
    parent_id character varying(50),
    publisher_id character varying(255) NOT NULL,
    custom_data public.hstore,
    image_id integer,
    n_events integer NOT NULL,
    n_events_changed boolean NOT NULL,
    replaced_by_id character varying(50),
    CONSTRAINT events_place_level_check CHECK ((level >= 0)),
    CONSTRAINT events_place_lft_check CHECK ((lft >= 0)),
    CONSTRAINT events_place_rght_check CHECK ((rght >= 0)),
    CONSTRAINT events_place_tree_id_check CHECK ((tree_id >= 0))
);


ALTER TABLE public.events_place OWNER TO linkedevents;

--
-- Name: events_place_divisions; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.events_place_divisions (
    id integer NOT NULL,
    place_id character varying(50) NOT NULL,
    administrativedivision_id integer NOT NULL
);


ALTER TABLE public.events_place_divisions OWNER TO linkedevents;

--
-- Name: events_place_divisions_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.events_place_divisions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_place_divisions_id_seq OWNER TO linkedevents;

--
-- Name: events_place_divisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.events_place_divisions_id_seq OWNED BY public.events_place_divisions.id;


--
-- Name: helevents_user; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.helevents_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(30) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL,
    uuid uuid NOT NULL,
    department_name character varying(50)
);


ALTER TABLE public.helevents_user OWNER TO linkedevents;

--
-- Name: helevents_user_ad_groups; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.helevents_user_ad_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    adgroup_id integer NOT NULL
);


ALTER TABLE public.helevents_user_ad_groups OWNER TO linkedevents;

--
-- Name: helevents_user_ad_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.helevents_user_ad_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.helevents_user_ad_groups_id_seq OWNER TO linkedevents;

--
-- Name: helevents_user_ad_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.helevents_user_ad_groups_id_seq OWNED BY public.helevents_user_ad_groups.id;


--
-- Name: helevents_user_groups; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.helevents_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.helevents_user_groups OWNER TO linkedevents;

--
-- Name: helevents_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.helevents_user_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.helevents_user_groups_id_seq OWNER TO linkedevents;

--
-- Name: helevents_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.helevents_user_groups_id_seq OWNED BY public.helevents_user_groups.id;


--
-- Name: helevents_user_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.helevents_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.helevents_user_id_seq OWNER TO linkedevents;

--
-- Name: helevents_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.helevents_user_id_seq OWNED BY public.helevents_user.id;


--
-- Name: helevents_user_user_permissions; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.helevents_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.helevents_user_user_permissions OWNER TO linkedevents;

--
-- Name: helevents_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.helevents_user_user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.helevents_user_user_permissions_id_seq OWNER TO linkedevents;

--
-- Name: helevents_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.helevents_user_user_permissions_id_seq OWNED BY public.helevents_user_user_permissions.id;


--
-- Name: helusers_adgroup; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.helusers_adgroup (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    display_name character varying(200) NOT NULL
);


ALTER TABLE public.helusers_adgroup OWNER TO linkedevents;

--
-- Name: helusers_adgroup_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.helusers_adgroup_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.helusers_adgroup_id_seq OWNER TO linkedevents;

--
-- Name: helusers_adgroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.helusers_adgroup_id_seq OWNED BY public.helusers_adgroup.id;


--
-- Name: helusers_adgroupmapping; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.helusers_adgroupmapping (
    id integer NOT NULL,
    ad_group_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.helusers_adgroupmapping OWNER TO linkedevents;

--
-- Name: helusers_adgroupmapping_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.helusers_adgroupmapping_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.helusers_adgroupmapping_id_seq OWNER TO linkedevents;

--
-- Name: helusers_adgroupmapping_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.helusers_adgroupmapping_id_seq OWNED BY public.helusers_adgroupmapping.id;


--
-- Name: munigeo_address; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.munigeo_address (
    id integer NOT NULL,
    number character varying(6) NOT NULL,
    number_end character varying(6) NOT NULL,
    letter character varying(2) NOT NULL,
    location public.geometry(Point,3067) NOT NULL,
    street_id integer NOT NULL,
    modified_at timestamp with time zone NOT NULL
);


ALTER TABLE public.munigeo_address OWNER TO linkedevents;

--
-- Name: munigeo_address_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.munigeo_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.munigeo_address_id_seq OWNER TO linkedevents;

--
-- Name: munigeo_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.munigeo_address_id_seq OWNED BY public.munigeo_address.id;


--
-- Name: munigeo_administrativedivision; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.munigeo_administrativedivision (
    id integer NOT NULL,
    name character varying(100),
    name_fi character varying(100),
    name_sv character varying(100),
    name_en character varying(100),
    origin_id character varying(50) NOT NULL,
    ocd_id character varying(200),
    service_point_id character varying(50),
    start date,
    "end" date,
    modified_at timestamp with time zone NOT NULL,
    lft integer NOT NULL,
    rght integer NOT NULL,
    tree_id integer NOT NULL,
    level integer NOT NULL,
    municipality_id character varying(100),
    parent_id integer,
    type_id integer NOT NULL,
    CONSTRAINT munigeo_administrativedivision_level_check CHECK ((level >= 0)),
    CONSTRAINT munigeo_administrativedivision_lft_check CHECK ((lft >= 0)),
    CONSTRAINT munigeo_administrativedivision_rght_check CHECK ((rght >= 0)),
    CONSTRAINT munigeo_administrativedivision_tree_id_check CHECK ((tree_id >= 0))
);


ALTER TABLE public.munigeo_administrativedivision OWNER TO linkedevents;

--
-- Name: munigeo_administrativedivision_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.munigeo_administrativedivision_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.munigeo_administrativedivision_id_seq OWNER TO linkedevents;

--
-- Name: munigeo_administrativedivision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.munigeo_administrativedivision_id_seq OWNED BY public.munigeo_administrativedivision.id;


--
-- Name: munigeo_administrativedivisiongeometry; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.munigeo_administrativedivisiongeometry (
    id integer NOT NULL,
    boundary public.geometry(MultiPolygon,3067) NOT NULL,
    division_id integer NOT NULL
);


ALTER TABLE public.munigeo_administrativedivisiongeometry OWNER TO linkedevents;

--
-- Name: munigeo_administrativedivisiongeometry_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.munigeo_administrativedivisiongeometry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.munigeo_administrativedivisiongeometry_id_seq OWNER TO linkedevents;

--
-- Name: munigeo_administrativedivisiongeometry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.munigeo_administrativedivisiongeometry_id_seq OWNED BY public.munigeo_administrativedivisiongeometry.id;


--
-- Name: munigeo_administrativedivisiontype; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.munigeo_administrativedivisiontype (
    id integer NOT NULL,
    type character varying(60) NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.munigeo_administrativedivisiontype OWNER TO linkedevents;

--
-- Name: munigeo_administrativedivisiontype_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.munigeo_administrativedivisiontype_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.munigeo_administrativedivisiontype_id_seq OWNER TO linkedevents;

--
-- Name: munigeo_administrativedivisiontype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.munigeo_administrativedivisiontype_id_seq OWNED BY public.munigeo_administrativedivisiontype.id;


--
-- Name: munigeo_building; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.munigeo_building (
    id integer NOT NULL,
    origin_id character varying(40) NOT NULL,
    geometry public.geometry(MultiPolygon,3067) NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    municipality_id character varying(100) NOT NULL
);


ALTER TABLE public.munigeo_building OWNER TO linkedevents;

--
-- Name: munigeo_building_addresses; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.munigeo_building_addresses (
    id integer NOT NULL,
    building_id integer NOT NULL,
    address_id integer NOT NULL
);


ALTER TABLE public.munigeo_building_addresses OWNER TO linkedevents;

--
-- Name: munigeo_building_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.munigeo_building_addresses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.munigeo_building_addresses_id_seq OWNER TO linkedevents;

--
-- Name: munigeo_building_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.munigeo_building_addresses_id_seq OWNED BY public.munigeo_building_addresses.id;


--
-- Name: munigeo_building_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.munigeo_building_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.munigeo_building_id_seq OWNER TO linkedevents;

--
-- Name: munigeo_building_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.munigeo_building_id_seq OWNED BY public.munigeo_building.id;


--
-- Name: munigeo_municipality; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.munigeo_municipality (
    id character varying(100) NOT NULL,
    name character varying(100),
    name_fi character varying(100),
    name_sv character varying(100),
    name_en character varying(100),
    division_id integer
);


ALTER TABLE public.munigeo_municipality OWNER TO linkedevents;

--
-- Name: munigeo_plan; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.munigeo_plan (
    id integer NOT NULL,
    geometry public.geometry(MultiPolygon,3067) NOT NULL,
    origin_id character varying(20) NOT NULL,
    in_effect boolean NOT NULL,
    municipality_id character varying(100) NOT NULL
);


ALTER TABLE public.munigeo_plan OWNER TO linkedevents;

--
-- Name: munigeo_plan_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.munigeo_plan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.munigeo_plan_id_seq OWNER TO linkedevents;

--
-- Name: munigeo_plan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.munigeo_plan_id_seq OWNED BY public.munigeo_plan.id;


--
-- Name: munigeo_poi; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.munigeo_poi (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    location public.geometry(Point,3067) NOT NULL,
    street_address character varying(100),
    zip_code character varying(10),
    origin_id character varying(40) NOT NULL,
    category_id integer NOT NULL,
    municipality_id character varying(100) NOT NULL
);


ALTER TABLE public.munigeo_poi OWNER TO linkedevents;

--
-- Name: munigeo_poi_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.munigeo_poi_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.munigeo_poi_id_seq OWNER TO linkedevents;

--
-- Name: munigeo_poi_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.munigeo_poi_id_seq OWNED BY public.munigeo_poi.id;


--
-- Name: munigeo_poicategory; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.munigeo_poicategory (
    id integer NOT NULL,
    type character varying(50) NOT NULL,
    description character varying(100) NOT NULL
);


ALTER TABLE public.munigeo_poicategory OWNER TO linkedevents;

--
-- Name: munigeo_poicategory_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.munigeo_poicategory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.munigeo_poicategory_id_seq OWNER TO linkedevents;

--
-- Name: munigeo_poicategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.munigeo_poicategory_id_seq OWNED BY public.munigeo_poicategory.id;


--
-- Name: munigeo_street; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.munigeo_street (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    name_fi character varying(100),
    name_sv character varying(100),
    name_en character varying(100),
    municipality_id character varying(100) NOT NULL,
    modified_at timestamp with time zone NOT NULL
);


ALTER TABLE public.munigeo_street OWNER TO linkedevents;

--
-- Name: munigeo_street_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.munigeo_street_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.munigeo_street_id_seq OWNER TO linkedevents;

--
-- Name: munigeo_street_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.munigeo_street_id_seq OWNED BY public.munigeo_street.id;


--
-- Name: reversion_revision; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.reversion_revision (
    id integer NOT NULL,
    date_created timestamp with time zone NOT NULL,
    comment text NOT NULL,
    user_id integer
);


ALTER TABLE public.reversion_revision OWNER TO linkedevents;

--
-- Name: reversion_revision_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.reversion_revision_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reversion_revision_id_seq OWNER TO linkedevents;

--
-- Name: reversion_revision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.reversion_revision_id_seq OWNED BY public.reversion_revision.id;


--
-- Name: reversion_version; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.reversion_version (
    id integer NOT NULL,
    object_id character varying(191) NOT NULL,
    format character varying(255) NOT NULL,
    serialized_data text NOT NULL,
    object_repr text NOT NULL,
    content_type_id integer NOT NULL,
    revision_id integer NOT NULL,
    db character varying(191) NOT NULL
);


ALTER TABLE public.reversion_version OWNER TO linkedevents;

--
-- Name: reversion_version_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.reversion_version_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reversion_version_id_seq OWNER TO linkedevents;

--
-- Name: reversion_version_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.reversion_version_id_seq OWNED BY public.reversion_version.id;


--
-- Name: socialaccount_socialaccount; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.socialaccount_socialaccount (
    id integer NOT NULL,
    provider character varying(30) NOT NULL,
    uid character varying(191) NOT NULL,
    last_login timestamp with time zone NOT NULL,
    date_joined timestamp with time zone NOT NULL,
    extra_data text NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.socialaccount_socialaccount OWNER TO linkedevents;

--
-- Name: socialaccount_socialaccount_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.socialaccount_socialaccount_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.socialaccount_socialaccount_id_seq OWNER TO linkedevents;

--
-- Name: socialaccount_socialaccount_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.socialaccount_socialaccount_id_seq OWNED BY public.socialaccount_socialaccount.id;


--
-- Name: socialaccount_socialapp; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.socialaccount_socialapp (
    id integer NOT NULL,
    provider character varying(30) NOT NULL,
    name character varying(40) NOT NULL,
    client_id character varying(191) NOT NULL,
    secret character varying(191) NOT NULL,
    key character varying(191) NOT NULL
);


ALTER TABLE public.socialaccount_socialapp OWNER TO linkedevents;

--
-- Name: socialaccount_socialapp_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.socialaccount_socialapp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.socialaccount_socialapp_id_seq OWNER TO linkedevents;

--
-- Name: socialaccount_socialapp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.socialaccount_socialapp_id_seq OWNED BY public.socialaccount_socialapp.id;


--
-- Name: socialaccount_socialapp_sites; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.socialaccount_socialapp_sites (
    id integer NOT NULL,
    socialapp_id integer NOT NULL,
    site_id integer NOT NULL
);


ALTER TABLE public.socialaccount_socialapp_sites OWNER TO linkedevents;

--
-- Name: socialaccount_socialapp_sites_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.socialaccount_socialapp_sites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.socialaccount_socialapp_sites_id_seq OWNER TO linkedevents;

--
-- Name: socialaccount_socialapp_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.socialaccount_socialapp_sites_id_seq OWNED BY public.socialaccount_socialapp_sites.id;


--
-- Name: socialaccount_socialtoken; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.socialaccount_socialtoken (
    id integer NOT NULL,
    token text NOT NULL,
    token_secret text NOT NULL,
    expires_at timestamp with time zone,
    account_id integer NOT NULL,
    app_id integer NOT NULL
);


ALTER TABLE public.socialaccount_socialtoken OWNER TO linkedevents;

--
-- Name: socialaccount_socialtoken_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.socialaccount_socialtoken_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.socialaccount_socialtoken_id_seq OWNER TO linkedevents;

--
-- Name: socialaccount_socialtoken_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.socialaccount_socialtoken_id_seq OWNED BY public.socialaccount_socialtoken.id;


--
-- Name: user_password_reset; Type: TABLE; Schema: public; Owner: linkedevents
--

CREATE TABLE public.user_password_reset (
    id integer NOT NULL,
    user_id integer NOT NULL,
    reset_key character varying(64) NOT NULL,
    date_expires timestamp without time zone NOT NULL
);


ALTER TABLE public.user_password_reset OWNER TO linkedevents;

--
-- Name: user_password_reset_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedevents
--

CREATE SEQUENCE public.user_password_reset_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_password_reset_id_seq OWNER TO linkedevents;

--
-- Name: user_password_reset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedevents
--

ALTER SEQUENCE public.user_password_reset_id_seq OWNED BY public.user_password_reset.id;


--
-- Name: account_emailaddress id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.account_emailaddress ALTER COLUMN id SET DEFAULT nextval('public.account_emailaddress_id_seq'::regclass);


--
-- Name: account_emailconfirmation id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.account_emailconfirmation ALTER COLUMN id SET DEFAULT nextval('public.account_emailconfirmation_id_seq'::regclass);


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: django_orghierarchy_organization_admin_users id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organization_admin_users ALTER COLUMN id SET DEFAULT nextval('public.django_orghierarchy_organization_admin_users_id_seq'::regclass);


--
-- Name: django_orghierarchy_organization_regular_users id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organization_regular_users ALTER COLUMN id SET DEFAULT nextval('public.django_orghierarchy_organization_regular_users_id_seq'::regclass);


--
-- Name: django_orghierarchy_organizationclass id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organizationclass ALTER COLUMN id SET DEFAULT nextval('public.django_orghierarchy_organizationclass_id_seq'::regclass);


--
-- Name: django_site id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_site ALTER COLUMN id SET DEFAULT nextval('public.django_site_id_seq'::regclass);


--
-- Name: events_event_audience id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event_audience ALTER COLUMN id SET DEFAULT nextval('public.events_event_audience_id_seq'::regclass);


--
-- Name: events_event_in_language id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event_in_language ALTER COLUMN id SET DEFAULT nextval('public.events_event_in_language_id_seq'::regclass);


--
-- Name: events_event_keywords id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event_keywords ALTER COLUMN id SET DEFAULT nextval('public.events_event_keywords_id_seq'::regclass);


--
-- Name: events_eventaggregate id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_eventaggregate ALTER COLUMN id SET DEFAULT nextval('public.events_eventaggregate_id_seq'::regclass);


--
-- Name: events_eventaggregatemember id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_eventaggregatemember ALTER COLUMN id SET DEFAULT nextval('public.events_eventaggregatemember_id_seq'::regclass);


--
-- Name: events_eventlink id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_eventlink ALTER COLUMN id SET DEFAULT nextval('public.events_eventlink_id_seq'::regclass);


--
-- Name: events_exportinfo id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_exportinfo ALTER COLUMN id SET DEFAULT nextval('public.events_exportinfo_id_seq'::regclass);


--
-- Name: events_image id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_image ALTER COLUMN id SET DEFAULT nextval('public.events_image_id_seq'::regclass);


--
-- Name: events_keyword_alt_labels id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keyword_alt_labels ALTER COLUMN id SET DEFAULT nextval('public.events_keyword_alt_labels_id_seq'::regclass);


--
-- Name: events_keywordlabel id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keywordlabel ALTER COLUMN id SET DEFAULT nextval('public.events_keywordlabel_id_seq'::regclass);


--
-- Name: events_keywordset_keywords id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keywordset_keywords ALTER COLUMN id SET DEFAULT nextval('public.events_keywordset_keywords_id_seq'::regclass);


--
-- Name: events_offer id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_offer ALTER COLUMN id SET DEFAULT nextval('public.events_offer_id_seq'::regclass);


--
-- Name: events_openinghoursspecification id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_openinghoursspecification ALTER COLUMN id SET DEFAULT nextval('public.events_openinghoursspecification_id_seq'::regclass);


--
-- Name: events_place_divisions id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_place_divisions ALTER COLUMN id SET DEFAULT nextval('public.events_place_divisions_id_seq'::regclass);


--
-- Name: helevents_user id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helevents_user ALTER COLUMN id SET DEFAULT nextval('public.helevents_user_id_seq'::regclass);


--
-- Name: helevents_user_ad_groups id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helevents_user_ad_groups ALTER COLUMN id SET DEFAULT nextval('public.helevents_user_ad_groups_id_seq'::regclass);


--
-- Name: helevents_user_groups id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helevents_user_groups ALTER COLUMN id SET DEFAULT nextval('public.helevents_user_groups_id_seq'::regclass);


--
-- Name: helevents_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helevents_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.helevents_user_user_permissions_id_seq'::regclass);


--
-- Name: helusers_adgroup id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helusers_adgroup ALTER COLUMN id SET DEFAULT nextval('public.helusers_adgroup_id_seq'::regclass);


--
-- Name: helusers_adgroupmapping id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helusers_adgroupmapping ALTER COLUMN id SET DEFAULT nextval('public.helusers_adgroupmapping_id_seq'::regclass);


--
-- Name: munigeo_address id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_address ALTER COLUMN id SET DEFAULT nextval('public.munigeo_address_id_seq'::regclass);


--
-- Name: munigeo_administrativedivision id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_administrativedivision ALTER COLUMN id SET DEFAULT nextval('public.munigeo_administrativedivision_id_seq'::regclass);


--
-- Name: munigeo_administrativedivisiongeometry id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_administrativedivisiongeometry ALTER COLUMN id SET DEFAULT nextval('public.munigeo_administrativedivisiongeometry_id_seq'::regclass);


--
-- Name: munigeo_administrativedivisiontype id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_administrativedivisiontype ALTER COLUMN id SET DEFAULT nextval('public.munigeo_administrativedivisiontype_id_seq'::regclass);


--
-- Name: munigeo_building id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_building ALTER COLUMN id SET DEFAULT nextval('public.munigeo_building_id_seq'::regclass);


--
-- Name: munigeo_building_addresses id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_building_addresses ALTER COLUMN id SET DEFAULT nextval('public.munigeo_building_addresses_id_seq'::regclass);


--
-- Name: munigeo_plan id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_plan ALTER COLUMN id SET DEFAULT nextval('public.munigeo_plan_id_seq'::regclass);


--
-- Name: munigeo_poi id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_poi ALTER COLUMN id SET DEFAULT nextval('public.munigeo_poi_id_seq'::regclass);


--
-- Name: munigeo_poicategory id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_poicategory ALTER COLUMN id SET DEFAULT nextval('public.munigeo_poicategory_id_seq'::regclass);


--
-- Name: munigeo_street id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_street ALTER COLUMN id SET DEFAULT nextval('public.munigeo_street_id_seq'::regclass);


--
-- Name: reversion_revision id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.reversion_revision ALTER COLUMN id SET DEFAULT nextval('public.reversion_revision_id_seq'::regclass);


--
-- Name: reversion_version id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.reversion_version ALTER COLUMN id SET DEFAULT nextval('public.reversion_version_id_seq'::regclass);


--
-- Name: socialaccount_socialaccount id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.socialaccount_socialaccount ALTER COLUMN id SET DEFAULT nextval('public.socialaccount_socialaccount_id_seq'::regclass);


--
-- Name: socialaccount_socialapp id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.socialaccount_socialapp ALTER COLUMN id SET DEFAULT nextval('public.socialaccount_socialapp_id_seq'::regclass);


--
-- Name: socialaccount_socialapp_sites id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.socialaccount_socialapp_sites ALTER COLUMN id SET DEFAULT nextval('public.socialaccount_socialapp_sites_id_seq'::regclass);


--
-- Name: socialaccount_socialtoken id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.socialaccount_socialtoken ALTER COLUMN id SET DEFAULT nextval('public.socialaccount_socialtoken_id_seq'::regclass);


--
-- Name: user_password_reset id; Type: DEFAULT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.user_password_reset ALTER COLUMN id SET DEFAULT nextval('public.user_password_reset_id_seq'::regclass);


--
-- Name: account_emailaddress account_emailaddress_email_key; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.account_emailaddress
    ADD CONSTRAINT account_emailaddress_email_key UNIQUE (email);


--
-- Name: account_emailaddress account_emailaddress_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.account_emailaddress
    ADD CONSTRAINT account_emailaddress_pkey PRIMARY KEY (id);


--
-- Name: account_emailconfirmation account_emailconfirmation_key_key; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.account_emailconfirmation
    ADD CONSTRAINT account_emailconfirmation_key_key UNIQUE (key);


--
-- Name: account_emailconfirmation account_emailconfirmation_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.account_emailconfirmation
    ADD CONSTRAINT account_emailconfirmation_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: authtoken_token authtoken_token_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_pkey PRIMARY KEY (key);


--
-- Name: authtoken_token authtoken_token_user_id_key; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_user_id_key UNIQUE (user_id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_orghierarchy_organization django_orghierarchy_orga_data_source_id_origin_id_76686fa2_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organization
    ADD CONSTRAINT django_orghierarchy_orga_data_source_id_origin_id_76686fa2_uniq UNIQUE (data_source_id, origin_id);


--
-- Name: django_orghierarchy_organizationclass django_orghierarchy_orga_data_source_id_origin_id_ca6bcc18_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organizationclass
    ADD CONSTRAINT django_orghierarchy_orga_data_source_id_origin_id_ca6bcc18_uniq UNIQUE (data_source_id, origin_id);


--
-- Name: django_orghierarchy_organization_regular_users django_orghierarchy_orga_organization_id_user_id_3d1b6654_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organization_regular_users
    ADD CONSTRAINT django_orghierarchy_orga_organization_id_user_id_3d1b6654_uniq UNIQUE (organization_id, user_id);


--
-- Name: django_orghierarchy_organization_admin_users django_orghierarchy_orga_organization_id_user_id_f14eeec3_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organization_admin_users
    ADD CONSTRAINT django_orghierarchy_orga_organization_id_user_id_f14eeec3_uniq UNIQUE (organization_id, user_id);


--
-- Name: django_orghierarchy_organization_admin_users django_orghierarchy_organization_admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organization_admin_users
    ADD CONSTRAINT django_orghierarchy_organization_admin_users_pkey PRIMARY KEY (id);


--
-- Name: django_orghierarchy_organization django_orghierarchy_organization_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organization
    ADD CONSTRAINT django_orghierarchy_organization_pkey PRIMARY KEY (id);


--
-- Name: django_orghierarchy_organization_regular_users django_orghierarchy_organization_regular_users_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organization_regular_users
    ADD CONSTRAINT django_orghierarchy_organization_regular_users_pkey PRIMARY KEY (id);


--
-- Name: django_orghierarchy_organization django_orghierarchy_organization_replaced_by_id_key; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organization
    ADD CONSTRAINT django_orghierarchy_organization_replaced_by_id_key UNIQUE (replaced_by_id);


--
-- Name: django_orghierarchy_organizationclass django_orghierarchy_organizationclass_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organizationclass
    ADD CONSTRAINT django_orghierarchy_organizationclass_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: django_site django_site_domain_a2e37b91_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_site
    ADD CONSTRAINT django_site_domain_a2e37b91_uniq UNIQUE (domain);


--
-- Name: django_site django_site_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_site
    ADD CONSTRAINT django_site_pkey PRIMARY KEY (id);


--
-- Name: events_apikeyuser events_apikeyuser_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_apikeyuser
    ADD CONSTRAINT events_apikeyuser_pkey PRIMARY KEY (data_source_id);


--
-- Name: events_apikeyuser events_apikeyuser_user_ptr_id_key; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_apikeyuser
    ADD CONSTRAINT events_apikeyuser_user_ptr_id_key UNIQUE (user_ptr_id);


--
-- Name: events_datasource events_datasource_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_datasource
    ADD CONSTRAINT events_datasource_pkey PRIMARY KEY (id);


--
-- Name: events_event_audience events_event_audience_event_id_keyword_id_e4c9753d_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event_audience
    ADD CONSTRAINT events_event_audience_event_id_keyword_id_e4c9753d_uniq UNIQUE (event_id, keyword_id);


--
-- Name: events_event_audience events_event_audience_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event_audience
    ADD CONSTRAINT events_event_audience_pkey PRIMARY KEY (id);


--
-- Name: events_event_in_language events_event_in_language_event_id_language_id_82d4717b_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event_in_language
    ADD CONSTRAINT events_event_in_language_event_id_language_id_82d4717b_uniq UNIQUE (event_id, language_id);


--
-- Name: events_event_in_language events_event_in_language_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event_in_language
    ADD CONSTRAINT events_event_in_language_pkey PRIMARY KEY (id);


--
-- Name: events_event_keywords events_event_keywords_event_id_keyword_id_3d430ea7_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event_keywords
    ADD CONSTRAINT events_event_keywords_event_id_keyword_id_3d430ea7_uniq UNIQUE (event_id, keyword_id);


--
-- Name: events_event_keywords events_event_keywords_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event_keywords
    ADD CONSTRAINT events_event_keywords_pkey PRIMARY KEY (id);


--
-- Name: events_event events_event_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event
    ADD CONSTRAINT events_event_pkey PRIMARY KEY (id);


--
-- Name: events_eventaggregate events_eventaggregate_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_eventaggregate
    ADD CONSTRAINT events_eventaggregate_pkey PRIMARY KEY (id);


--
-- Name: events_eventaggregate events_eventaggregate_super_event_id_key; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_eventaggregate
    ADD CONSTRAINT events_eventaggregate_super_event_id_key UNIQUE (super_event_id);


--
-- Name: events_eventaggregatemember events_eventaggregatemember_event_id_key; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_eventaggregatemember
    ADD CONSTRAINT events_eventaggregatemember_event_id_key UNIQUE (event_id);


--
-- Name: events_eventaggregatemember events_eventaggregatemember_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_eventaggregatemember
    ADD CONSTRAINT events_eventaggregatemember_pkey PRIMARY KEY (id);


--
-- Name: events_eventlink events_eventlink_name_event_id_language_id_link_e828703c_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_eventlink
    ADD CONSTRAINT events_eventlink_name_event_id_language_id_link_e828703c_uniq UNIQUE (name, event_id, language_id, link);


--
-- Name: events_eventlink events_eventlink_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_eventlink
    ADD CONSTRAINT events_eventlink_pkey PRIMARY KEY (id);


--
-- Name: events_exportinfo events_exportinfo_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_exportinfo
    ADD CONSTRAINT events_exportinfo_pkey PRIMARY KEY (id);


--
-- Name: events_exportinfo events_exportinfo_target_system_content_ty_7091f2fd_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_exportinfo
    ADD CONSTRAINT events_exportinfo_target_system_content_ty_7091f2fd_uniq UNIQUE (target_system, content_type_id, object_id);


--
-- Name: events_image events_image_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_image
    ADD CONSTRAINT events_image_pkey PRIMARY KEY (id);


--
-- Name: events_keyword_alt_labels events_keyword_alt_label_keyword_id_keywordlabel__ce5afa9f_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keyword_alt_labels
    ADD CONSTRAINT events_keyword_alt_label_keyword_id_keywordlabel__ce5afa9f_uniq UNIQUE (keyword_id, keywordlabel_id);


--
-- Name: events_keyword_alt_labels events_keyword_alt_labels_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keyword_alt_labels
    ADD CONSTRAINT events_keyword_alt_labels_pkey PRIMARY KEY (id);


--
-- Name: events_keyword events_keyword_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keyword
    ADD CONSTRAINT events_keyword_pkey PRIMARY KEY (id);


--
-- Name: events_keywordlabel events_keywordlabel_name_language_id_4d9990e5_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keywordlabel
    ADD CONSTRAINT events_keywordlabel_name_language_id_4d9990e5_uniq UNIQUE (name, language_id);


--
-- Name: events_keywordlabel events_keywordlabel_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keywordlabel
    ADD CONSTRAINT events_keywordlabel_pkey PRIMARY KEY (id);


--
-- Name: events_keywordset_keywords events_keywordset_keywor_keywordset_id_keyword_id_e3ff2a92_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keywordset_keywords
    ADD CONSTRAINT events_keywordset_keywor_keywordset_id_keyword_id_e3ff2a92_uniq UNIQUE (keywordset_id, keyword_id);


--
-- Name: events_keywordset_keywords events_keywordset_keywords_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keywordset_keywords
    ADD CONSTRAINT events_keywordset_keywords_pkey PRIMARY KEY (id);


--
-- Name: events_keywordset events_keywordset_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keywordset
    ADD CONSTRAINT events_keywordset_pkey PRIMARY KEY (id);


--
-- Name: events_language events_language_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_language
    ADD CONSTRAINT events_language_pkey PRIMARY KEY (id);


--
-- Name: events_license events_license_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_license
    ADD CONSTRAINT events_license_pkey PRIMARY KEY (id);


--
-- Name: events_offer events_offer_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_offer
    ADD CONSTRAINT events_offer_pkey PRIMARY KEY (id);


--
-- Name: events_openinghoursspecification events_openinghoursspecification_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_openinghoursspecification
    ADD CONSTRAINT events_openinghoursspecification_pkey PRIMARY KEY (id);


--
-- Name: events_place events_place_data_source_id_origin_id_7c2d86ca_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_place
    ADD CONSTRAINT events_place_data_source_id_origin_id_7c2d86ca_uniq UNIQUE (data_source_id, origin_id);


--
-- Name: events_place_divisions events_place_divisions_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_place_divisions
    ADD CONSTRAINT events_place_divisions_pkey PRIMARY KEY (id);


--
-- Name: events_place_divisions events_place_divisions_place_id_administratived_a6e4939f_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_place_divisions
    ADD CONSTRAINT events_place_divisions_place_id_administratived_a6e4939f_uniq UNIQUE (place_id, administrativedivision_id);


--
-- Name: events_place events_place_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_place
    ADD CONSTRAINT events_place_pkey PRIMARY KEY (id);


--
-- Name: helevents_user_ad_groups helevents_user_ad_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helevents_user_ad_groups
    ADD CONSTRAINT helevents_user_ad_groups_pkey PRIMARY KEY (id);


--
-- Name: helevents_user_ad_groups helevents_user_ad_groups_user_id_adgroup_id_e976b7ad_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helevents_user_ad_groups
    ADD CONSTRAINT helevents_user_ad_groups_user_id_adgroup_id_e976b7ad_uniq UNIQUE (user_id, adgroup_id);


--
-- Name: helevents_user_groups helevents_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helevents_user_groups
    ADD CONSTRAINT helevents_user_groups_pkey PRIMARY KEY (id);


--
-- Name: helevents_user_groups helevents_user_groups_user_id_group_id_d0e55309_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helevents_user_groups
    ADD CONSTRAINT helevents_user_groups_user_id_group_id_d0e55309_uniq UNIQUE (user_id, group_id);


--
-- Name: helevents_user helevents_user_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helevents_user
    ADD CONSTRAINT helevents_user_pkey PRIMARY KEY (id);


--
-- Name: helevents_user_user_permissions helevents_user_user_perm_user_id_permission_id_120ec695_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helevents_user_user_permissions
    ADD CONSTRAINT helevents_user_user_perm_user_id_permission_id_120ec695_uniq UNIQUE (user_id, permission_id);


--
-- Name: helevents_user_user_permissions helevents_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helevents_user_user_permissions
    ADD CONSTRAINT helevents_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: helevents_user helevents_user_username_key; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helevents_user
    ADD CONSTRAINT helevents_user_username_key UNIQUE (username);


--
-- Name: helevents_user helevents_user_uuid_key; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helevents_user
    ADD CONSTRAINT helevents_user_uuid_key UNIQUE (uuid);


--
-- Name: helusers_adgroup helusers_adgroup_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helusers_adgroup
    ADD CONSTRAINT helusers_adgroup_pkey PRIMARY KEY (id);


--
-- Name: helusers_adgroupmapping helusers_adgroupmapping_group_id_ad_group_id_5c4803af_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helusers_adgroupmapping
    ADD CONSTRAINT helusers_adgroupmapping_group_id_ad_group_id_5c4803af_uniq UNIQUE (group_id, ad_group_id);


--
-- Name: helusers_adgroupmapping helusers_adgroupmapping_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helusers_adgroupmapping
    ADD CONSTRAINT helusers_adgroupmapping_pkey PRIMARY KEY (id);


--
-- Name: munigeo_address munigeo_address_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_address
    ADD CONSTRAINT munigeo_address_pkey PRIMARY KEY (id);


--
-- Name: munigeo_address munigeo_address_street_id_number_number__cc11fa3c_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_address
    ADD CONSTRAINT munigeo_address_street_id_number_number__cc11fa3c_uniq UNIQUE (street_id, number, number_end, letter);


--
-- Name: munigeo_administrativedivision munigeo_administrativedi_origin_id_type_id_parent_f3ca94e9_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_administrativedivision
    ADD CONSTRAINT munigeo_administrativedi_origin_id_type_id_parent_f3ca94e9_uniq UNIQUE (origin_id, type_id, parent_id);


--
-- Name: munigeo_administrativedivision munigeo_administrativedivision_ocd_id_key; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_administrativedivision
    ADD CONSTRAINT munigeo_administrativedivision_ocd_id_key UNIQUE (ocd_id);


--
-- Name: munigeo_administrativedivision munigeo_administrativedivision_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_administrativedivision
    ADD CONSTRAINT munigeo_administrativedivision_pkey PRIMARY KEY (id);


--
-- Name: munigeo_administrativedivisiongeometry munigeo_administrativedivisiongeometry_division_id_key; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_administrativedivisiongeometry
    ADD CONSTRAINT munigeo_administrativedivisiongeometry_division_id_key UNIQUE (division_id);


--
-- Name: munigeo_administrativedivisiongeometry munigeo_administrativedivisiongeometry_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_administrativedivisiongeometry
    ADD CONSTRAINT munigeo_administrativedivisiongeometry_pkey PRIMARY KEY (id);


--
-- Name: munigeo_administrativedivisiontype munigeo_administrativedivisiontype_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_administrativedivisiontype
    ADD CONSTRAINT munigeo_administrativedivisiontype_pkey PRIMARY KEY (id);


--
-- Name: munigeo_administrativedivisiontype munigeo_administrativedivisiontype_type_key; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_administrativedivisiontype
    ADD CONSTRAINT munigeo_administrativedivisiontype_type_key UNIQUE (type);


--
-- Name: munigeo_building_addresses munigeo_building_addresses_building_id_address_id_ace30c93_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_building_addresses
    ADD CONSTRAINT munigeo_building_addresses_building_id_address_id_ace30c93_uniq UNIQUE (building_id, address_id);


--
-- Name: munigeo_building_addresses munigeo_building_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_building_addresses
    ADD CONSTRAINT munigeo_building_addresses_pkey PRIMARY KEY (id);


--
-- Name: munigeo_building munigeo_building_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_building
    ADD CONSTRAINT munigeo_building_pkey PRIMARY KEY (id);


--
-- Name: munigeo_municipality munigeo_municipality_division_id_key; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_municipality
    ADD CONSTRAINT munigeo_municipality_division_id_key UNIQUE (division_id);


--
-- Name: munigeo_municipality munigeo_municipality_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_municipality
    ADD CONSTRAINT munigeo_municipality_pkey PRIMARY KEY (id);


--
-- Name: munigeo_plan munigeo_plan_municipality_id_origin_id_f9599985_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_plan
    ADD CONSTRAINT munigeo_plan_municipality_id_origin_id_f9599985_uniq UNIQUE (municipality_id, origin_id);


--
-- Name: munigeo_plan munigeo_plan_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_plan
    ADD CONSTRAINT munigeo_plan_pkey PRIMARY KEY (id);


--
-- Name: munigeo_poi munigeo_poi_origin_id_key; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_poi
    ADD CONSTRAINT munigeo_poi_origin_id_key UNIQUE (origin_id);


--
-- Name: munigeo_poi munigeo_poi_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_poi
    ADD CONSTRAINT munigeo_poi_pkey PRIMARY KEY (id);


--
-- Name: munigeo_poicategory munigeo_poicategory_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_poicategory
    ADD CONSTRAINT munigeo_poicategory_pkey PRIMARY KEY (id);


--
-- Name: munigeo_street munigeo_street_municipality_id_name_6e998d56_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_street
    ADD CONSTRAINT munigeo_street_municipality_id_name_6e998d56_uniq UNIQUE (municipality_id, name);


--
-- Name: munigeo_street munigeo_street_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_street
    ADD CONSTRAINT munigeo_street_pkey PRIMARY KEY (id);


--
-- Name: user_password_reset pk_user_password_reset; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.user_password_reset
    ADD CONSTRAINT pk_user_password_reset PRIMARY KEY (id);


--
-- Name: reversion_revision reversion_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.reversion_revision
    ADD CONSTRAINT reversion_revision_pkey PRIMARY KEY (id);


--
-- Name: reversion_version reversion_version_db_content_type_id_objec_b2c54f65_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.reversion_version
    ADD CONSTRAINT reversion_version_db_content_type_id_objec_b2c54f65_uniq UNIQUE (db, content_type_id, object_id, revision_id);


--
-- Name: reversion_version reversion_version_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.reversion_version
    ADD CONSTRAINT reversion_version_pkey PRIMARY KEY (id);


--
-- Name: socialaccount_socialaccount socialaccount_socialaccount_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.socialaccount_socialaccount
    ADD CONSTRAINT socialaccount_socialaccount_pkey PRIMARY KEY (id);


--
-- Name: socialaccount_socialaccount socialaccount_socialaccount_provider_uid_fc810c6e_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.socialaccount_socialaccount
    ADD CONSTRAINT socialaccount_socialaccount_provider_uid_fc810c6e_uniq UNIQUE (provider, uid);


--
-- Name: socialaccount_socialapp_sites socialaccount_socialapp__socialapp_id_site_id_71a9a768_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.socialaccount_socialapp_sites
    ADD CONSTRAINT socialaccount_socialapp__socialapp_id_site_id_71a9a768_uniq UNIQUE (socialapp_id, site_id);


--
-- Name: socialaccount_socialapp socialaccount_socialapp_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.socialaccount_socialapp
    ADD CONSTRAINT socialaccount_socialapp_pkey PRIMARY KEY (id);


--
-- Name: socialaccount_socialapp_sites socialaccount_socialapp_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.socialaccount_socialapp_sites
    ADD CONSTRAINT socialaccount_socialapp_sites_pkey PRIMARY KEY (id);


--
-- Name: socialaccount_socialtoken socialaccount_socialtoken_app_id_account_id_fca4e0ac_uniq; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.socialaccount_socialtoken
    ADD CONSTRAINT socialaccount_socialtoken_app_id_account_id_fca4e0ac_uniq UNIQUE (app_id, account_id);


--
-- Name: socialaccount_socialtoken socialaccount_socialtoken_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.socialaccount_socialtoken
    ADD CONSTRAINT socialaccount_socialtoken_pkey PRIMARY KEY (id);


--
-- Name: account_emailaddress_email_03be32b2_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX account_emailaddress_email_03be32b2_like ON public.account_emailaddress USING btree (email varchar_pattern_ops);


--
-- Name: account_emailaddress_user_id_2c513194; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX account_emailaddress_user_id_2c513194 ON public.account_emailaddress USING btree (user_id);


--
-- Name: account_emailconfirmation_email_address_id_5b7f8c58; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX account_emailconfirmation_email_address_id_5b7f8c58 ON public.account_emailconfirmation USING btree (email_address_id);


--
-- Name: account_emailconfirmation_key_f43612bd_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX account_emailconfirmation_key_f43612bd_like ON public.account_emailconfirmation USING btree (key varchar_pattern_ops);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: authtoken_token_key_10f0b77e_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX authtoken_token_key_10f0b77e_like ON public.authtoken_token USING btree (key varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_orghierarchy_orga_data_source_id_b6acf734_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_orghierarchy_orga_data_source_id_b6acf734_like ON public.django_orghierarchy_organizationclass USING btree (data_source_id varchar_pattern_ops);


--
-- Name: django_orghierarchy_orga_organization_id_347a3696_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_orghierarchy_orga_organization_id_347a3696_like ON public.django_orghierarchy_organization_regular_users USING btree (organization_id varchar_pattern_ops);


--
-- Name: django_orghierarchy_orga_organization_id_d10d604e_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_orghierarchy_orga_organization_id_d10d604e_like ON public.django_orghierarchy_organization_admin_users USING btree (organization_id varchar_pattern_ops);


--
-- Name: django_orghierarchy_organi_organization_id_347a3696; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_orghierarchy_organi_organization_id_347a3696 ON public.django_orghierarchy_organization_regular_users USING btree (organization_id);


--
-- Name: django_orghierarchy_organi_organization_id_d10d604e; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_orghierarchy_organi_organization_id_d10d604e ON public.django_orghierarchy_organization_admin_users USING btree (organization_id);


--
-- Name: django_orghierarchy_organization_admin_users_user_id_a2304a74; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_orghierarchy_organization_admin_users_user_id_a2304a74 ON public.django_orghierarchy_organization_admin_users USING btree (user_id);


--
-- Name: django_orghierarchy_organization_classification_id_a219aeef; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_orghierarchy_organization_classification_id_a219aeef ON public.django_orghierarchy_organization USING btree (classification_id);


--
-- Name: django_orghierarchy_organization_created_by_id_ec5b00e5; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_orghierarchy_organization_created_by_id_ec5b00e5 ON public.django_orghierarchy_organization USING btree (created_by_id);


--
-- Name: django_orghierarchy_organization_data_source_id_44bc694f; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_orghierarchy_organization_data_source_id_44bc694f ON public.django_orghierarchy_organization USING btree (data_source_id);


--
-- Name: django_orghierarchy_organization_data_source_id_44bc694f_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_orghierarchy_organization_data_source_id_44bc694f_like ON public.django_orghierarchy_organization USING btree (data_source_id varchar_pattern_ops);


--
-- Name: django_orghierarchy_organization_id_3056a5cd_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_orghierarchy_organization_id_3056a5cd_like ON public.django_orghierarchy_organization USING btree (id varchar_pattern_ops);


--
-- Name: django_orghierarchy_organization_last_modified_by_id_19a6a2c1; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_orghierarchy_organization_last_modified_by_id_19a6a2c1 ON public.django_orghierarchy_organization USING btree (last_modified_by_id);


--
-- Name: django_orghierarchy_organization_level_51a1e277; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_orghierarchy_organization_level_51a1e277 ON public.django_orghierarchy_organization USING btree (level);


--
-- Name: django_orghierarchy_organization_lft_63381942; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_orghierarchy_organization_lft_63381942 ON public.django_orghierarchy_organization USING btree (lft);


--
-- Name: django_orghierarchy_organization_parent_id_66b36338; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_orghierarchy_organization_parent_id_66b36338 ON public.django_orghierarchy_organization USING btree (parent_id);


--
-- Name: django_orghierarchy_organization_parent_id_66b36338_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_orghierarchy_organization_parent_id_66b36338_like ON public.django_orghierarchy_organization USING btree (parent_id varchar_pattern_ops);


--
-- Name: django_orghierarchy_organization_regular_users_user_id_ed0ea805; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_orghierarchy_organization_regular_users_user_id_ed0ea805 ON public.django_orghierarchy_organization_regular_users USING btree (user_id);


--
-- Name: django_orghierarchy_organization_replaced_by_id_9871a94b_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_orghierarchy_organization_replaced_by_id_9871a94b_like ON public.django_orghierarchy_organization USING btree (replaced_by_id varchar_pattern_ops);


--
-- Name: django_orghierarchy_organization_rght_9fb5fe2d; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_orghierarchy_organization_rght_9fb5fe2d ON public.django_orghierarchy_organization USING btree (rght);


--
-- Name: django_orghierarchy_organization_tree_id_91c229be; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_orghierarchy_organization_tree_id_91c229be ON public.django_orghierarchy_organization USING btree (tree_id);


--
-- Name: django_orghierarchy_organizationclass_data_source_id_b6acf734; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_orghierarchy_organizationclass_data_source_id_b6acf734 ON public.django_orghierarchy_organizationclass USING btree (data_source_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: django_site_domain_a2e37b91_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX django_site_domain_a2e37b91_like ON public.django_site USING btree (domain varchar_pattern_ops);


--
-- Name: events_apikeyuser_data_source_id_7cb8e1ec_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_apikeyuser_data_source_id_7cb8e1ec_like ON public.events_apikeyuser USING btree (data_source_id varchar_pattern_ops);


--
-- Name: events_datasource_id_6ffd8f4a_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_datasource_id_6ffd8f4a_like ON public.events_datasource USING btree (id varchar_pattern_ops);


--
-- Name: events_datasource_owner_id_96c3ee51; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_datasource_owner_id_96c3ee51 ON public.events_datasource USING btree (owner_id);


--
-- Name: events_datasource_owner_id_96c3ee51_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_datasource_owner_id_96c3ee51_like ON public.events_datasource USING btree (owner_id varchar_pattern_ops);


--
-- Name: events_event_audience_event_id_94d999bc; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_audience_event_id_94d999bc ON public.events_event_audience USING btree (event_id);


--
-- Name: events_event_audience_event_id_94d999bc_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_audience_event_id_94d999bc_like ON public.events_event_audience USING btree (event_id varchar_pattern_ops);


--
-- Name: events_event_audience_keyword_id_10e8fa18; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_audience_keyword_id_10e8fa18 ON public.events_event_audience USING btree (keyword_id);


--
-- Name: events_event_audience_keyword_id_10e8fa18_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_audience_keyword_id_10e8fa18_like ON public.events_event_audience USING btree (keyword_id varchar_pattern_ops);


--
-- Name: events_event_created_by_id_2c28ea90; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_created_by_id_2c28ea90 ON public.events_event USING btree (created_by_id);


--
-- Name: events_event_data_source_id_064c736d; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_data_source_id_064c736d ON public.events_event USING btree (data_source_id);


--
-- Name: events_event_data_source_id_064c736d_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_data_source_id_064c736d_like ON public.events_event USING btree (data_source_id varchar_pattern_ops);


--
-- Name: events_event_deleted_372cc44e; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_deleted_372cc44e ON public.events_event USING btree (deleted);


--
-- Name: events_event_end_time_3498f0e4; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_end_time_3498f0e4 ON public.events_event USING btree (end_time);


--
-- Name: events_event_headline_8e9b1e69; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_headline_8e9b1e69 ON public.events_event USING btree (headline);


--
-- Name: events_event_headline_8e9b1e69_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_headline_8e9b1e69_like ON public.events_event USING btree (headline varchar_pattern_ops);


--
-- Name: events_event_headline_en_ba3f074e; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_headline_en_ba3f074e ON public.events_event USING btree (headline_en);


--
-- Name: events_event_headline_en_ba3f074e_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_headline_en_ba3f074e_like ON public.events_event USING btree (headline_en varchar_pattern_ops);


--
-- Name: events_event_headline_fi_19ac0c41; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_headline_fi_19ac0c41 ON public.events_event USING btree (headline_fi);


--
-- Name: events_event_headline_fi_19ac0c41_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_headline_fi_19ac0c41_like ON public.events_event USING btree (headline_fi varchar_pattern_ops);


--
-- Name: events_event_headline_sv_df759166; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_headline_sv_df759166 ON public.events_event USING btree (headline_sv);


--
-- Name: events_event_headline_sv_df759166_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_headline_sv_df759166_like ON public.events_event USING btree (headline_sv varchar_pattern_ops);


--
-- Name: events_event_id_75d2cab3_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_id_75d2cab3_like ON public.events_event USING btree (id varchar_pattern_ops);


--
-- Name: events_event_image_id_02ffd242; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_image_id_02ffd242 ON public.events_event USING btree (image_id);


--
-- Name: events_event_in_language_event_id_8dfd0785; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_in_language_event_id_8dfd0785 ON public.events_event_in_language USING btree (event_id);


--
-- Name: events_event_in_language_event_id_8dfd0785_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_in_language_event_id_8dfd0785_like ON public.events_event_in_language USING btree (event_id varchar_pattern_ops);


--
-- Name: events_event_in_language_language_id_a100e380; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_in_language_language_id_a100e380 ON public.events_event_in_language USING btree (language_id);


--
-- Name: events_event_in_language_language_id_a100e380_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_in_language_language_id_a100e380_like ON public.events_event_in_language USING btree (language_id varchar_pattern_ops);


--
-- Name: events_event_keywords_event_id_7d8194be; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_keywords_event_id_7d8194be ON public.events_event_keywords USING btree (event_id);


--
-- Name: events_event_keywords_event_id_7d8194be_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_keywords_event_id_7d8194be_like ON public.events_event_keywords USING btree (event_id varchar_pattern_ops);


--
-- Name: events_event_keywords_keyword_id_00652ea7; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_keywords_keyword_id_00652ea7 ON public.events_event_keywords USING btree (keyword_id);


--
-- Name: events_event_keywords_keyword_id_00652ea7_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_keywords_keyword_id_00652ea7_like ON public.events_event_keywords USING btree (keyword_id varchar_pattern_ops);


--
-- Name: events_event_last_modified_by_id_f4d5285c; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_last_modified_by_id_f4d5285c ON public.events_event USING btree (last_modified_by_id);


--
-- Name: events_event_last_modified_time_bffd533f; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_last_modified_time_bffd533f ON public.events_event USING btree (last_modified_time);


--
-- Name: events_event_level_bcea8f35; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_level_bcea8f35 ON public.events_event USING btree (level);


--
-- Name: events_event_lft_175598f4; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_lft_175598f4 ON public.events_event USING btree (lft);


--
-- Name: events_event_location_id_2fb4171f; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_location_id_2fb4171f ON public.events_event USING btree (location_id);


--
-- Name: events_event_location_id_2fb4171f_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_location_id_2fb4171f_like ON public.events_event USING btree (location_id varchar_pattern_ops);


--
-- Name: events_event_name_5981cc0e; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_name_5981cc0e ON public.events_event USING btree (name);


--
-- Name: events_event_name_5981cc0e_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_name_5981cc0e_like ON public.events_event USING btree (name varchar_pattern_ops);


--
-- Name: events_event_name_en_0f1661f9; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_name_en_0f1661f9 ON public.events_event USING btree (name_en);


--
-- Name: events_event_name_en_0f1661f9_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_name_en_0f1661f9_like ON public.events_event USING btree (name_en varchar_pattern_ops);


--
-- Name: events_event_name_fi_4fb9af1e; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_name_fi_4fb9af1e ON public.events_event USING btree (name_fi);


--
-- Name: events_event_name_fi_4fb9af1e_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_name_fi_4fb9af1e_like ON public.events_event USING btree (name_fi varchar_pattern_ops);


--
-- Name: events_event_name_sv_7fde241d; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_name_sv_7fde241d ON public.events_event USING btree (name_sv);


--
-- Name: events_event_name_sv_7fde241d_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_name_sv_7fde241d_like ON public.events_event USING btree (name_sv varchar_pattern_ops);


--
-- Name: events_event_origin_id_bd836192; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_origin_id_bd836192 ON public.events_event USING btree (origin_id);


--
-- Name: events_event_origin_id_bd836192_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_origin_id_bd836192_like ON public.events_event USING btree (origin_id varchar_pattern_ops);


--
-- Name: events_event_position_id; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_position_id ON public.events_event USING gist ("position");


--
-- Name: events_event_publisher_id_39b67381; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_publisher_id_39b67381 ON public.events_event USING btree (publisher_id);


--
-- Name: events_event_publisher_id_39b67381_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_publisher_id_39b67381_like ON public.events_event USING btree (publisher_id varchar_pattern_ops);


--
-- Name: events_event_rght_96cf8f8e; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_rght_96cf8f8e ON public.events_event USING btree (rght);


--
-- Name: events_event_secondary_headline_2719ad3f; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_secondary_headline_2719ad3f ON public.events_event USING btree (secondary_headline);


--
-- Name: events_event_secondary_headline_2719ad3f_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_secondary_headline_2719ad3f_like ON public.events_event USING btree (secondary_headline varchar_pattern_ops);


--
-- Name: events_event_secondary_headline_en_208f31ba; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_secondary_headline_en_208f31ba ON public.events_event USING btree (secondary_headline_en);


--
-- Name: events_event_secondary_headline_en_208f31ba_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_secondary_headline_en_208f31ba_like ON public.events_event USING btree (secondary_headline_en varchar_pattern_ops);


--
-- Name: events_event_secondary_headline_fi_5a0b69e5; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_secondary_headline_fi_5a0b69e5 ON public.events_event USING btree (secondary_headline_fi);


--
-- Name: events_event_secondary_headline_fi_5a0b69e5_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_secondary_headline_fi_5a0b69e5_like ON public.events_event USING btree (secondary_headline_fi varchar_pattern_ops);


--
-- Name: events_event_secondary_headline_sv_aaf194fa; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_secondary_headline_sv_aaf194fa ON public.events_event USING btree (secondary_headline_sv);


--
-- Name: events_event_secondary_headline_sv_aaf194fa_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_secondary_headline_sv_aaf194fa_like ON public.events_event USING btree (secondary_headline_sv varchar_pattern_ops);


--
-- Name: events_event_start_time_9a12b7cf; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_start_time_9a12b7cf ON public.events_event USING btree (start_time);


--
-- Name: events_event_super_event_id_010443c8; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_super_event_id_010443c8 ON public.events_event USING btree (super_event_id);


--
-- Name: events_event_super_event_id_010443c8_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_super_event_id_010443c8_like ON public.events_event USING btree (super_event_id varchar_pattern_ops);


--
-- Name: events_event_tree_id_a1a70cf3; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_event_tree_id_a1a70cf3 ON public.events_event USING btree (tree_id);


--
-- Name: events_eventaggregate_super_event_id_9289a5a7_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_eventaggregate_super_event_id_9289a5a7_like ON public.events_eventaggregate USING btree (super_event_id varchar_pattern_ops);


--
-- Name: events_eventaggregatemember_event_aggregate_id_97feff63; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_eventaggregatemember_event_aggregate_id_97feff63 ON public.events_eventaggregatemember USING btree (event_aggregate_id);


--
-- Name: events_eventaggregatemember_event_id_8336130a_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_eventaggregatemember_event_id_8336130a_like ON public.events_eventaggregatemember USING btree (event_id varchar_pattern_ops);


--
-- Name: events_eventlink_event_id_ad88499a; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_eventlink_event_id_ad88499a ON public.events_eventlink USING btree (event_id);


--
-- Name: events_eventlink_event_id_ad88499a_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_eventlink_event_id_ad88499a_like ON public.events_eventlink USING btree (event_id varchar_pattern_ops);


--
-- Name: events_eventlink_language_id_f0063e1f; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_eventlink_language_id_f0063e1f ON public.events_eventlink USING btree (language_id);


--
-- Name: events_eventlink_language_id_f0063e1f_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_eventlink_language_id_f0063e1f_like ON public.events_eventlink USING btree (language_id varchar_pattern_ops);


--
-- Name: events_exportinfo_content_type_id_fba87bac; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_exportinfo_content_type_id_fba87bac ON public.events_exportinfo USING btree (content_type_id);


--
-- Name: events_exportinfo_target_id_67af21cc; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_exportinfo_target_id_67af21cc ON public.events_exportinfo USING btree (target_id);


--
-- Name: events_exportinfo_target_id_67af21cc_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_exportinfo_target_id_67af21cc_like ON public.events_exportinfo USING btree (target_id varchar_pattern_ops);


--
-- Name: events_exportinfo_target_system_3800b02c; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_exportinfo_target_system_3800b02c ON public.events_exportinfo USING btree (target_system);


--
-- Name: events_exportinfo_target_system_3800b02c_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_exportinfo_target_system_3800b02c_like ON public.events_exportinfo USING btree (target_system varchar_pattern_ops);


--
-- Name: events_image_created_by_id_fb4db6bf; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_image_created_by_id_fb4db6bf ON public.events_image USING btree (created_by_id);


--
-- Name: events_image_data_source_id_c6636999; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_image_data_source_id_c6636999 ON public.events_image USING btree (data_source_id);


--
-- Name: events_image_data_source_id_c6636999_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_image_data_source_id_c6636999_like ON public.events_image USING btree (data_source_id varchar_pattern_ops);


--
-- Name: events_image_last_modified_by_id_57dea795; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_image_last_modified_by_id_57dea795 ON public.events_image USING btree (last_modified_by_id);


--
-- Name: events_image_license_id_3874eeb6; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_image_license_id_3874eeb6 ON public.events_image USING btree (license_id);


--
-- Name: events_image_license_id_3874eeb6_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_image_license_id_3874eeb6_like ON public.events_image USING btree (license_id varchar_pattern_ops);


--
-- Name: events_image_name_699aadcf; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_image_name_699aadcf ON public.events_image USING btree (name);


--
-- Name: events_image_name_699aadcf_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_image_name_699aadcf_like ON public.events_image USING btree (name varchar_pattern_ops);


--
-- Name: events_image_publisher_id_703963ad; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_image_publisher_id_703963ad ON public.events_image USING btree (publisher_id);


--
-- Name: events_image_publisher_id_703963ad_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_image_publisher_id_703963ad_like ON public.events_image USING btree (publisher_id varchar_pattern_ops);


--
-- Name: events_keyword_alt_labels_keyword_id_dc5f6805; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_alt_labels_keyword_id_dc5f6805 ON public.events_keyword_alt_labels USING btree (keyword_id);


--
-- Name: events_keyword_alt_labels_keyword_id_dc5f6805_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_alt_labels_keyword_id_dc5f6805_like ON public.events_keyword_alt_labels USING btree (keyword_id varchar_pattern_ops);


--
-- Name: events_keyword_alt_labels_keywordlabel_id_1c197b40; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_alt_labels_keywordlabel_id_1c197b40 ON public.events_keyword_alt_labels USING btree (keywordlabel_id);


--
-- Name: events_keyword_created_by_id_5ab6a9c5; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_created_by_id_5ab6a9c5 ON public.events_keyword USING btree (created_by_id);


--
-- Name: events_keyword_data_source_id_4ba7109b; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_data_source_id_4ba7109b ON public.events_keyword USING btree (data_source_id);


--
-- Name: events_keyword_data_source_id_4ba7109b_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_data_source_id_4ba7109b_like ON public.events_keyword USING btree (data_source_id varchar_pattern_ops);


--
-- Name: events_keyword_deprecated_7397f2a9; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_deprecated_7397f2a9 ON public.events_keyword USING btree (deprecated);


--
-- Name: events_keyword_id_415c8e1b_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_id_415c8e1b_like ON public.events_keyword USING btree (id varchar_pattern_ops);


--
-- Name: events_keyword_image_id_a2ffafa5; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_image_id_a2ffafa5 ON public.events_keyword USING btree (image_id);


--
-- Name: events_keyword_last_modified_by_id_e5632600; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_last_modified_by_id_e5632600 ON public.events_keyword USING btree (last_modified_by_id);


--
-- Name: events_keyword_last_modified_time_8e640b80; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_last_modified_time_8e640b80 ON public.events_keyword USING btree (last_modified_time);


--
-- Name: events_keyword_n_events_470f1063; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_n_events_470f1063 ON public.events_keyword USING btree (n_events);


--
-- Name: events_keyword_n_events_changed_7e0ae952; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_n_events_changed_7e0ae952 ON public.events_keyword USING btree (n_events_changed);


--
-- Name: events_keyword_name_eb23f57b; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_name_eb23f57b ON public.events_keyword USING btree (name);


--
-- Name: events_keyword_name_eb23f57b_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_name_eb23f57b_like ON public.events_keyword USING btree (name varchar_pattern_ops);


--
-- Name: events_keyword_name_en_1e57c722; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_name_en_1e57c722 ON public.events_keyword USING btree (name_en);


--
-- Name: events_keyword_name_en_1e57c722_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_name_en_1e57c722_like ON public.events_keyword USING btree (name_en varchar_pattern_ops);


--
-- Name: events_keyword_name_fi_6aeeb8f3; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_name_fi_6aeeb8f3 ON public.events_keyword USING btree (name_fi);


--
-- Name: events_keyword_name_fi_6aeeb8f3_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_name_fi_6aeeb8f3_like ON public.events_keyword USING btree (name_fi varchar_pattern_ops);


--
-- Name: events_keyword_name_sv_06dae119; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_name_sv_06dae119 ON public.events_keyword USING btree (name_sv);


--
-- Name: events_keyword_name_sv_06dae119_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_name_sv_06dae119_like ON public.events_keyword USING btree (name_sv varchar_pattern_ops);


--
-- Name: events_keyword_origin_id_5fc28876; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_origin_id_5fc28876 ON public.events_keyword USING btree (origin_id);


--
-- Name: events_keyword_origin_id_5fc28876_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_origin_id_5fc28876_like ON public.events_keyword USING btree (origin_id varchar_pattern_ops);


--
-- Name: events_keyword_publisher_id_26968fc2; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_publisher_id_26968fc2 ON public.events_keyword USING btree (publisher_id);


--
-- Name: events_keyword_publisher_id_26968fc2_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keyword_publisher_id_26968fc2_like ON public.events_keyword USING btree (publisher_id varchar_pattern_ops);


--
-- Name: events_keywordlabel_language_id_6b1f489e; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordlabel_language_id_6b1f489e ON public.events_keywordlabel USING btree (language_id);


--
-- Name: events_keywordlabel_language_id_6b1f489e_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordlabel_language_id_6b1f489e_like ON public.events_keywordlabel USING btree (language_id varchar_pattern_ops);


--
-- Name: events_keywordlabel_name_dcad1e02; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordlabel_name_dcad1e02 ON public.events_keywordlabel USING btree (name);


--
-- Name: events_keywordlabel_name_dcad1e02_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordlabel_name_dcad1e02_like ON public.events_keywordlabel USING btree (name varchar_pattern_ops);


--
-- Name: events_keywordset_created_by_id_4518f287; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_created_by_id_4518f287 ON public.events_keywordset USING btree (created_by_id);


--
-- Name: events_keywordset_data_source_id_d310b1d2; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_data_source_id_d310b1d2 ON public.events_keywordset USING btree (data_source_id);


--
-- Name: events_keywordset_data_source_id_d310b1d2_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_data_source_id_d310b1d2_like ON public.events_keywordset USING btree (data_source_id varchar_pattern_ops);


--
-- Name: events_keywordset_id_096c7118_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_id_096c7118_like ON public.events_keywordset USING btree (id varchar_pattern_ops);


--
-- Name: events_keywordset_image_id_f9c3e490; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_image_id_f9c3e490 ON public.events_keywordset USING btree (image_id);


--
-- Name: events_keywordset_keywords_keyword_id_16143a75; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_keywords_keyword_id_16143a75 ON public.events_keywordset_keywords USING btree (keyword_id);


--
-- Name: events_keywordset_keywords_keyword_id_16143a75_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_keywords_keyword_id_16143a75_like ON public.events_keywordset_keywords USING btree (keyword_id varchar_pattern_ops);


--
-- Name: events_keywordset_keywords_keywordset_id_c67c87c3; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_keywords_keywordset_id_c67c87c3 ON public.events_keywordset_keywords USING btree (keywordset_id);


--
-- Name: events_keywordset_keywords_keywordset_id_c67c87c3_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_keywords_keywordset_id_c67c87c3_like ON public.events_keywordset_keywords USING btree (keywordset_id varchar_pattern_ops);


--
-- Name: events_keywordset_last_modified_by_id_eb02bbcb; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_last_modified_by_id_eb02bbcb ON public.events_keywordset USING btree (last_modified_by_id);


--
-- Name: events_keywordset_last_modified_time_6e256633; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_last_modified_time_6e256633 ON public.events_keywordset USING btree (last_modified_time);


--
-- Name: events_keywordset_name_76f4b3f4; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_name_76f4b3f4 ON public.events_keywordset USING btree (name);


--
-- Name: events_keywordset_name_76f4b3f4_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_name_76f4b3f4_like ON public.events_keywordset USING btree (name varchar_pattern_ops);


--
-- Name: events_keywordset_name_en_0c8a8d80; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_name_en_0c8a8d80 ON public.events_keywordset USING btree (name_en);


--
-- Name: events_keywordset_name_en_0c8a8d80_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_name_en_0c8a8d80_like ON public.events_keywordset USING btree (name_en varchar_pattern_ops);


--
-- Name: events_keywordset_name_fi_b693230a; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_name_fi_b693230a ON public.events_keywordset USING btree (name_fi);


--
-- Name: events_keywordset_name_fi_b693230a_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_name_fi_b693230a_like ON public.events_keywordset USING btree (name_fi varchar_pattern_ops);


--
-- Name: events_keywordset_name_sv_bf7f627b; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_name_sv_bf7f627b ON public.events_keywordset USING btree (name_sv);


--
-- Name: events_keywordset_name_sv_bf7f627b_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_name_sv_bf7f627b_like ON public.events_keywordset USING btree (name_sv varchar_pattern_ops);


--
-- Name: events_keywordset_organization_id_11b513b8; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_organization_id_11b513b8 ON public.events_keywordset USING btree (organization_id);


--
-- Name: events_keywordset_organization_id_11b513b8_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_organization_id_11b513b8_like ON public.events_keywordset USING btree (organization_id varchar_pattern_ops);


--
-- Name: events_keywordset_origin_id_05f6853d; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_origin_id_05f6853d ON public.events_keywordset USING btree (origin_id);


--
-- Name: events_keywordset_origin_id_05f6853d_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_keywordset_origin_id_05f6853d_like ON public.events_keywordset USING btree (origin_id varchar_pattern_ops);


--
-- Name: events_language_id_fd46bd90_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_language_id_fd46bd90_like ON public.events_language USING btree (id varchar_pattern_ops);


--
-- Name: events_license_id_a2ff417c_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_license_id_a2ff417c_like ON public.events_license USING btree (id varchar_pattern_ops);


--
-- Name: events_offer_event_id_1a22341c; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_offer_event_id_1a22341c ON public.events_offer USING btree (event_id);


--
-- Name: events_offer_event_id_1a22341c_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_offer_event_id_1a22341c_like ON public.events_offer USING btree (event_id varchar_pattern_ops);


--
-- Name: events_openinghoursspecification_place_id_6de4e079; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_openinghoursspecification_place_id_6de4e079 ON public.events_openinghoursspecification USING btree (place_id);


--
-- Name: events_openinghoursspecification_place_id_6de4e079_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_openinghoursspecification_place_id_6de4e079_like ON public.events_openinghoursspecification USING btree (place_id varchar_pattern_ops);


--
-- Name: events_place_created_by_id_a5026653; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_created_by_id_a5026653 ON public.events_place USING btree (created_by_id);


--
-- Name: events_place_data_source_id_9b44a6ac; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_data_source_id_9b44a6ac ON public.events_place USING btree (data_source_id);


--
-- Name: events_place_data_source_id_9b44a6ac_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_data_source_id_9b44a6ac_like ON public.events_place USING btree (data_source_id varchar_pattern_ops);


--
-- Name: events_place_divisions_administrativedivision_id_02bebcdb; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_divisions_administrativedivision_id_02bebcdb ON public.events_place_divisions USING btree (administrativedivision_id);


--
-- Name: events_place_divisions_place_id_065984b7; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_divisions_place_id_065984b7 ON public.events_place_divisions USING btree (place_id);


--
-- Name: events_place_divisions_place_id_065984b7_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_divisions_place_id_065984b7_like ON public.events_place_divisions USING btree (place_id varchar_pattern_ops);


--
-- Name: events_place_id_a6f200aa_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_id_a6f200aa_like ON public.events_place USING btree (id varchar_pattern_ops);


--
-- Name: events_place_image_id_9c4c39cd; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_image_id_9c4c39cd ON public.events_place USING btree (image_id);


--
-- Name: events_place_last_modified_by_id_09bf61ff; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_last_modified_by_id_09bf61ff ON public.events_place USING btree (last_modified_by_id);


--
-- Name: events_place_last_modified_time_5831ff1d; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_last_modified_time_5831ff1d ON public.events_place USING btree (last_modified_time);


--
-- Name: events_place_level_fbc882a0; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_level_fbc882a0 ON public.events_place USING btree (level);


--
-- Name: events_place_lft_4dd84b3a; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_lft_4dd84b3a ON public.events_place USING btree (lft);


--
-- Name: events_place_n_events_72756c75; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_n_events_72756c75 ON public.events_place USING btree (n_events);


--
-- Name: events_place_n_events_changed_efe5c487; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_n_events_changed_efe5c487 ON public.events_place USING btree (n_events_changed);


--
-- Name: events_place_name_3d37efc0; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_name_3d37efc0 ON public.events_place USING btree (name);


--
-- Name: events_place_name_3d37efc0_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_name_3d37efc0_like ON public.events_place USING btree (name varchar_pattern_ops);


--
-- Name: events_place_name_en_04a5b3b3; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_name_en_04a5b3b3 ON public.events_place USING btree (name_en);


--
-- Name: events_place_name_en_04a5b3b3_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_name_en_04a5b3b3_like ON public.events_place USING btree (name_en varchar_pattern_ops);


--
-- Name: events_place_name_fi_3f75d490; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_name_fi_3f75d490 ON public.events_place USING btree (name_fi);


--
-- Name: events_place_name_fi_3f75d490_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_name_fi_3f75d490_like ON public.events_place USING btree (name_fi varchar_pattern_ops);


--
-- Name: events_place_name_sv_8ac5e11f; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_name_sv_8ac5e11f ON public.events_place USING btree (name_sv);


--
-- Name: events_place_name_sv_8ac5e11f_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_name_sv_8ac5e11f_like ON public.events_place USING btree (name_sv varchar_pattern_ops);


--
-- Name: events_place_origin_id_77d08d3c; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_origin_id_77d08d3c ON public.events_place USING btree (origin_id);


--
-- Name: events_place_origin_id_77d08d3c_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_origin_id_77d08d3c_like ON public.events_place USING btree (origin_id varchar_pattern_ops);


--
-- Name: events_place_parent_id_e61d1fff; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_parent_id_e61d1fff ON public.events_place USING btree (parent_id);


--
-- Name: events_place_parent_id_e61d1fff_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_parent_id_e61d1fff_like ON public.events_place USING btree (parent_id varchar_pattern_ops);


--
-- Name: events_place_position_id; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_position_id ON public.events_place USING gist ("position");


--
-- Name: events_place_publisher_id_75aee1d9; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_publisher_id_75aee1d9 ON public.events_place USING btree (publisher_id);


--
-- Name: events_place_publisher_id_75aee1d9_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_publisher_id_75aee1d9_like ON public.events_place USING btree (publisher_id varchar_pattern_ops);


--
-- Name: events_place_replaced_by_id_4553469d; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_replaced_by_id_4553469d ON public.events_place USING btree (replaced_by_id);


--
-- Name: events_place_replaced_by_id_4553469d_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_replaced_by_id_4553469d_like ON public.events_place USING btree (replaced_by_id varchar_pattern_ops);


--
-- Name: events_place_rght_13e89917; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_rght_13e89917 ON public.events_place USING btree (rght);


--
-- Name: events_place_tree_id_c121cf8d; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX events_place_tree_id_c121cf8d ON public.events_place USING btree (tree_id);


--
-- Name: helevents_user_ad_groups_adgroup_id_0a5fd04a; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX helevents_user_ad_groups_adgroup_id_0a5fd04a ON public.helevents_user_ad_groups USING btree (adgroup_id);


--
-- Name: helevents_user_ad_groups_user_id_f7a3e896; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX helevents_user_ad_groups_user_id_f7a3e896 ON public.helevents_user_ad_groups USING btree (user_id);


--
-- Name: helevents_user_groups_group_id_aed60c4f; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX helevents_user_groups_group_id_aed60c4f ON public.helevents_user_groups USING btree (group_id);


--
-- Name: helevents_user_groups_user_id_71614dd9; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX helevents_user_groups_user_id_71614dd9 ON public.helevents_user_groups USING btree (user_id);


--
-- Name: helevents_user_user_permissions_permission_id_f5dae855; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX helevents_user_user_permissions_permission_id_f5dae855 ON public.helevents_user_user_permissions USING btree (permission_id);


--
-- Name: helevents_user_user_permissions_user_id_2a313f21; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX helevents_user_user_permissions_user_id_2a313f21 ON public.helevents_user_user_permissions USING btree (user_id);


--
-- Name: helevents_user_username_e5bd6241_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX helevents_user_username_e5bd6241_like ON public.helevents_user USING btree (username varchar_pattern_ops);


--
-- Name: helusers_adgroup_name_9e89ca21; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX helusers_adgroup_name_9e89ca21 ON public.helusers_adgroup USING btree (name);


--
-- Name: helusers_adgroup_name_9e89ca21_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX helusers_adgroup_name_9e89ca21_like ON public.helusers_adgroup USING btree (name varchar_pattern_ops);


--
-- Name: helusers_adgroupmapping_ad_group_id_51386ad7; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX helusers_adgroupmapping_ad_group_id_51386ad7 ON public.helusers_adgroupmapping USING btree (ad_group_id);


--
-- Name: helusers_adgroupmapping_group_id_bf4c1c7c; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX helusers_adgroupmapping_group_id_bf4c1c7c ON public.helusers_adgroupmapping USING btree (group_id);


--
-- Name: munigeo_address_location_id; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_address_location_id ON public.munigeo_address USING gist (location);


--
-- Name: munigeo_address_street_id_b1d7718d; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_address_street_id_b1d7718d ON public.munigeo_address USING btree (street_id);


--
-- Name: munigeo_administrativedivision_level_4bda7de3; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivision_level_4bda7de3 ON public.munigeo_administrativedivision USING btree (level);


--
-- Name: munigeo_administrativedivision_lft_6ffbc98f; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivision_lft_6ffbc98f ON public.munigeo_administrativedivision USING btree (lft);


--
-- Name: munigeo_administrativedivision_municipality_id_3ff7058c; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivision_municipality_id_3ff7058c ON public.munigeo_administrativedivision USING btree (municipality_id);


--
-- Name: munigeo_administrativedivision_municipality_id_3ff7058c_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivision_municipality_id_3ff7058c_like ON public.munigeo_administrativedivision USING btree (municipality_id varchar_pattern_ops);


--
-- Name: munigeo_administrativedivision_name_7d1d1267; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivision_name_7d1d1267 ON public.munigeo_administrativedivision USING btree (name);


--
-- Name: munigeo_administrativedivision_name_7d1d1267_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivision_name_7d1d1267_like ON public.munigeo_administrativedivision USING btree (name varchar_pattern_ops);


--
-- Name: munigeo_administrativedivision_name_en_2ff14277; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivision_name_en_2ff14277 ON public.munigeo_administrativedivision USING btree (name_en);


--
-- Name: munigeo_administrativedivision_name_en_2ff14277_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivision_name_en_2ff14277_like ON public.munigeo_administrativedivision USING btree (name_en varchar_pattern_ops);


--
-- Name: munigeo_administrativedivision_name_fi_978afaea; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivision_name_fi_978afaea ON public.munigeo_administrativedivision USING btree (name_fi);


--
-- Name: munigeo_administrativedivision_name_fi_978afaea_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivision_name_fi_978afaea_like ON public.munigeo_administrativedivision USING btree (name_fi varchar_pattern_ops);


--
-- Name: munigeo_administrativedivision_name_sv_2749f8ff; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivision_name_sv_2749f8ff ON public.munigeo_administrativedivision USING btree (name_sv);


--
-- Name: munigeo_administrativedivision_name_sv_2749f8ff_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivision_name_sv_2749f8ff_like ON public.munigeo_administrativedivision USING btree (name_sv varchar_pattern_ops);


--
-- Name: munigeo_administrativedivision_ocd_id_8030814a_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivision_ocd_id_8030814a_like ON public.munigeo_administrativedivision USING btree (ocd_id varchar_pattern_ops);


--
-- Name: munigeo_administrativedivision_origin_id_1a28b539; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivision_origin_id_1a28b539 ON public.munigeo_administrativedivision USING btree (origin_id);


--
-- Name: munigeo_administrativedivision_origin_id_1a28b539_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivision_origin_id_1a28b539_like ON public.munigeo_administrativedivision USING btree (origin_id varchar_pattern_ops);


--
-- Name: munigeo_administrativedivision_parent_id_5f9d6073; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivision_parent_id_5f9d6073 ON public.munigeo_administrativedivision USING btree (parent_id);


--
-- Name: munigeo_administrativedivision_rght_77b4ae26; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivision_rght_77b4ae26 ON public.munigeo_administrativedivision USING btree (rght);


--
-- Name: munigeo_administrativedivision_service_point_id_7af499da; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivision_service_point_id_7af499da ON public.munigeo_administrativedivision USING btree (service_point_id);


--
-- Name: munigeo_administrativedivision_service_point_id_7af499da_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivision_service_point_id_7af499da_like ON public.munigeo_administrativedivision USING btree (service_point_id varchar_pattern_ops);


--
-- Name: munigeo_administrativedivision_tree_id_e847f368; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivision_tree_id_e847f368 ON public.munigeo_administrativedivision USING btree (tree_id);


--
-- Name: munigeo_administrativedivision_type_id_6edb8778; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivision_type_id_6edb8778 ON public.munigeo_administrativedivision USING btree (type_id);


--
-- Name: munigeo_administrativedivisiongeometry_boundary_id; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivisiongeometry_boundary_id ON public.munigeo_administrativedivisiongeometry USING gist (boundary);


--
-- Name: munigeo_administrativedivisiontype_type_c68ab4d2_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_administrativedivisiontype_type_c68ab4d2_like ON public.munigeo_administrativedivisiontype USING btree (type varchar_pattern_ops);


--
-- Name: munigeo_building_addresses_address_id_801dc46f; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_building_addresses_address_id_801dc46f ON public.munigeo_building_addresses USING btree (address_id);


--
-- Name: munigeo_building_addresses_building_id_bf18e998; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_building_addresses_building_id_bf18e998 ON public.munigeo_building_addresses USING btree (building_id);


--
-- Name: munigeo_building_geometry_id; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_building_geometry_id ON public.munigeo_building USING gist (geometry);


--
-- Name: munigeo_building_municipality_id_07970ec8; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_building_municipality_id_07970ec8 ON public.munigeo_building USING btree (municipality_id);


--
-- Name: munigeo_building_municipality_id_07970ec8_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_building_municipality_id_07970ec8_like ON public.munigeo_building USING btree (municipality_id varchar_pattern_ops);


--
-- Name: munigeo_building_origin_id_401805bd; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_building_origin_id_401805bd ON public.munigeo_building USING btree (origin_id);


--
-- Name: munigeo_building_origin_id_401805bd_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_building_origin_id_401805bd_like ON public.munigeo_building USING btree (origin_id varchar_pattern_ops);


--
-- Name: munigeo_municipality_id_e558646f_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_municipality_id_e558646f_like ON public.munigeo_municipality USING btree (id varchar_pattern_ops);


--
-- Name: munigeo_municipality_name_e0d41d66; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_municipality_name_e0d41d66 ON public.munigeo_municipality USING btree (name);


--
-- Name: munigeo_municipality_name_e0d41d66_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_municipality_name_e0d41d66_like ON public.munigeo_municipality USING btree (name varchar_pattern_ops);


--
-- Name: munigeo_municipality_name_en_c3a31040; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_municipality_name_en_c3a31040 ON public.munigeo_municipality USING btree (name_en);


--
-- Name: munigeo_municipality_name_en_c3a31040_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_municipality_name_en_c3a31040_like ON public.munigeo_municipality USING btree (name_en varchar_pattern_ops);


--
-- Name: munigeo_municipality_name_fi_f865ba32; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_municipality_name_fi_f865ba32 ON public.munigeo_municipality USING btree (name_fi);


--
-- Name: munigeo_municipality_name_fi_f865ba32_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_municipality_name_fi_f865ba32_like ON public.munigeo_municipality USING btree (name_fi varchar_pattern_ops);


--
-- Name: munigeo_municipality_name_sv_d211d83c; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_municipality_name_sv_d211d83c ON public.munigeo_municipality USING btree (name_sv);


--
-- Name: munigeo_municipality_name_sv_d211d83c_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_municipality_name_sv_d211d83c_like ON public.munigeo_municipality USING btree (name_sv varchar_pattern_ops);


--
-- Name: munigeo_plan_geometry_id; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_plan_geometry_id ON public.munigeo_plan USING gist (geometry);


--
-- Name: munigeo_plan_municipality_id_d01e664f; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_plan_municipality_id_d01e664f ON public.munigeo_plan USING btree (municipality_id);


--
-- Name: munigeo_plan_municipality_id_d01e664f_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_plan_municipality_id_d01e664f_like ON public.munigeo_plan USING btree (municipality_id varchar_pattern_ops);


--
-- Name: munigeo_poi_category_id_5805c26b; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_poi_category_id_5805c26b ON public.munigeo_poi USING btree (category_id);


--
-- Name: munigeo_poi_location_id; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_poi_location_id ON public.munigeo_poi USING gist (location);


--
-- Name: munigeo_poi_municipality_id_ca5c4b23; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_poi_municipality_id_ca5c4b23 ON public.munigeo_poi USING btree (municipality_id);


--
-- Name: munigeo_poi_municipality_id_ca5c4b23_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_poi_municipality_id_ca5c4b23_like ON public.munigeo_poi USING btree (municipality_id varchar_pattern_ops);


--
-- Name: munigeo_poi_origin_id_395b9fcc_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_poi_origin_id_395b9fcc_like ON public.munigeo_poi USING btree (origin_id varchar_pattern_ops);


--
-- Name: munigeo_poicategory_type_5e591178; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_poicategory_type_5e591178 ON public.munigeo_poicategory USING btree (type);


--
-- Name: munigeo_poicategory_type_5e591178_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_poicategory_type_5e591178_like ON public.munigeo_poicategory USING btree (type varchar_pattern_ops);


--
-- Name: munigeo_street_municipality_id_ef6fd93f; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_street_municipality_id_ef6fd93f ON public.munigeo_street USING btree (municipality_id);


--
-- Name: munigeo_street_municipality_id_ef6fd93f_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_street_municipality_id_ef6fd93f_like ON public.munigeo_street USING btree (municipality_id varchar_pattern_ops);


--
-- Name: munigeo_street_name_e58e9400; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_street_name_e58e9400 ON public.munigeo_street USING btree (name);


--
-- Name: munigeo_street_name_e58e9400_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_street_name_e58e9400_like ON public.munigeo_street USING btree (name varchar_pattern_ops);


--
-- Name: munigeo_street_name_en_14f956c6; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_street_name_en_14f956c6 ON public.munigeo_street USING btree (name_en);


--
-- Name: munigeo_street_name_en_14f956c6_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_street_name_en_14f956c6_like ON public.munigeo_street USING btree (name_en varchar_pattern_ops);


--
-- Name: munigeo_street_name_fi_3c43b3b8; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_street_name_fi_3c43b3b8 ON public.munigeo_street USING btree (name_fi);


--
-- Name: munigeo_street_name_fi_3c43b3b8_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_street_name_fi_3c43b3b8_like ON public.munigeo_street USING btree (name_fi varchar_pattern_ops);


--
-- Name: munigeo_street_name_sv_fe3e2a29; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_street_name_sv_fe3e2a29 ON public.munigeo_street USING btree (name_sv);


--
-- Name: munigeo_street_name_sv_fe3e2a29_like; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX munigeo_street_name_sv_fe3e2a29_like ON public.munigeo_street USING btree (name_sv varchar_pattern_ops);


--
-- Name: reversion_revision_date_created_96f7c20c; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX reversion_revision_date_created_96f7c20c ON public.reversion_revision USING btree (date_created);


--
-- Name: reversion_revision_user_id_17095f45; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX reversion_revision_user_id_17095f45 ON public.reversion_revision USING btree (user_id);


--
-- Name: reversion_version_content_type_id_7d0ff25c; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX reversion_version_content_type_id_7d0ff25c ON public.reversion_version USING btree (content_type_id);


--
-- Name: reversion_version_revision_id_af9f6a9d; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX reversion_version_revision_id_af9f6a9d ON public.reversion_version USING btree (revision_id);


--
-- Name: socialaccount_socialaccount_user_id_8146e70c; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX socialaccount_socialaccount_user_id_8146e70c ON public.socialaccount_socialaccount USING btree (user_id);


--
-- Name: socialaccount_socialapp_sites_site_id_2579dee5; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX socialaccount_socialapp_sites_site_id_2579dee5 ON public.socialaccount_socialapp_sites USING btree (site_id);


--
-- Name: socialaccount_socialapp_sites_socialapp_id_97fb6e7d; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX socialaccount_socialapp_sites_socialapp_id_97fb6e7d ON public.socialaccount_socialapp_sites USING btree (socialapp_id);


--
-- Name: socialaccount_socialtoken_account_id_951f210e; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX socialaccount_socialtoken_account_id_951f210e ON public.socialaccount_socialtoken USING btree (account_id);


--
-- Name: socialaccount_socialtoken_app_id_636a42d7; Type: INDEX; Schema: public; Owner: linkedevents
--

CREATE INDEX socialaccount_socialtoken_app_id_636a42d7 ON public.socialaccount_socialtoken USING btree (app_id);


--
-- Name: account_emailaddress account_emailaddress_user_id_2c513194_fk_helevents_user_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.account_emailaddress
    ADD CONSTRAINT account_emailaddress_user_id_2c513194_fk_helevents_user_id FOREIGN KEY (user_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: account_emailconfirmation account_emailconfirmation_email_address_id_5b7f8c58_fk; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.account_emailconfirmation
    ADD CONSTRAINT account_emailconfirmation_email_address_id_5b7f8c58_fk FOREIGN KEY (email_address_id) REFERENCES public.account_emailaddress(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: authtoken_token authtoken_token_user_id_35299eff_fk_helevents_user_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_user_id_35299eff_fk_helevents_user_id FOREIGN KEY (user_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_helevents_user_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_helevents_user_id FOREIGN KEY (user_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_orghierarchy_organization django_orghierarchy__data_source_id_44bc694f_fk_events_da; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organization
    ADD CONSTRAINT django_orghierarchy__data_source_id_44bc694f_fk_events_da FOREIGN KEY (data_source_id) REFERENCES public.events_datasource(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_orghierarchy_organizationclass django_orghierarchy__data_source_id_b6acf734_fk_events_da; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organizationclass
    ADD CONSTRAINT django_orghierarchy__data_source_id_b6acf734_fk_events_da FOREIGN KEY (data_source_id) REFERENCES public.events_datasource(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_orghierarchy_organization_regular_users django_orghierarchy__organization_id_347a3696_fk_django_or; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organization_regular_users
    ADD CONSTRAINT django_orghierarchy__organization_id_347a3696_fk_django_or FOREIGN KEY (organization_id) REFERENCES public.django_orghierarchy_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_orghierarchy_organization_admin_users django_orghierarchy__organization_id_d10d604e_fk_django_or; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organization_admin_users
    ADD CONSTRAINT django_orghierarchy__organization_id_d10d604e_fk_django_or FOREIGN KEY (organization_id) REFERENCES public.django_orghierarchy_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_orghierarchy_organization django_orghierarchy__parent_id_66b36338_fk_django_or; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organization
    ADD CONSTRAINT django_orghierarchy__parent_id_66b36338_fk_django_or FOREIGN KEY (parent_id) REFERENCES public.django_orghierarchy_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_orghierarchy_organization django_orghierarchy__replaced_by_id_9871a94b_fk_django_or; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organization
    ADD CONSTRAINT django_orghierarchy__replaced_by_id_9871a94b_fk_django_or FOREIGN KEY (replaced_by_id) REFERENCES public.django_orghierarchy_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_orghierarchy_organization_admin_users django_orghierarchy__user_id_a2304a74_fk_helevents; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organization_admin_users
    ADD CONSTRAINT django_orghierarchy__user_id_a2304a74_fk_helevents FOREIGN KEY (user_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_orghierarchy_organization_regular_users django_orghierarchy__user_id_ed0ea805_fk_helevents; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organization_regular_users
    ADD CONSTRAINT django_orghierarchy__user_id_ed0ea805_fk_helevents FOREIGN KEY (user_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_orghierarchy_organization django_orghierarchy_organ_last_modified_by_id_19a6a2c1_fk; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organization
    ADD CONSTRAINT django_orghierarchy_organ_last_modified_by_id_19a6a2c1_fk FOREIGN KEY (last_modified_by_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_orghierarchy_organization django_orghierarchy_organization_classification_id_a219aeef_fk; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organization
    ADD CONSTRAINT django_orghierarchy_organization_classification_id_a219aeef_fk FOREIGN KEY (classification_id) REFERENCES public.django_orghierarchy_organizationclass(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_orghierarchy_organization django_orghierarchy_organization_created_by_id_ec5b00e5_fk; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.django_orghierarchy_organization
    ADD CONSTRAINT django_orghierarchy_organization_created_by_id_ec5b00e5_fk FOREIGN KEY (created_by_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_apikeyuser events_apikeyuser_data_source_id_7cb8e1ec_fk_events_da; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_apikeyuser
    ADD CONSTRAINT events_apikeyuser_data_source_id_7cb8e1ec_fk_events_da FOREIGN KEY (data_source_id) REFERENCES public.events_datasource(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_apikeyuser events_apikeyuser_user_ptr_id_59159fee_fk_helevents_user_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_apikeyuser
    ADD CONSTRAINT events_apikeyuser_user_ptr_id_59159fee_fk_helevents_user_id FOREIGN KEY (user_ptr_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_datasource events_datasource_owner_id_96c3ee51_fk_django_or; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_datasource
    ADD CONSTRAINT events_datasource_owner_id_96c3ee51_fk_django_or FOREIGN KEY (owner_id) REFERENCES public.django_orghierarchy_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event_audience events_event_audience_event_id_94d999bc_fk_events_event_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event_audience
    ADD CONSTRAINT events_event_audience_event_id_94d999bc_fk_events_event_id FOREIGN KEY (event_id) REFERENCES public.events_event(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event_audience events_event_audience_keyword_id_10e8fa18_fk_events_keyword_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event_audience
    ADD CONSTRAINT events_event_audience_keyword_id_10e8fa18_fk_events_keyword_id FOREIGN KEY (keyword_id) REFERENCES public.events_keyword(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event events_event_created_by_id_2c28ea90_fk; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event
    ADD CONSTRAINT events_event_created_by_id_2c28ea90_fk FOREIGN KEY (created_by_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event events_event_data_source_id_064c736d_fk_events_datasource_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event
    ADD CONSTRAINT events_event_data_source_id_064c736d_fk_events_datasource_id FOREIGN KEY (data_source_id) REFERENCES public.events_datasource(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event events_event_image_id_02ffd242_fk_events_image_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event
    ADD CONSTRAINT events_event_image_id_02ffd242_fk_events_image_id FOREIGN KEY (image_id) REFERENCES public.events_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event_in_language events_event_in_lang_language_id_a100e380_fk_events_la; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event_in_language
    ADD CONSTRAINT events_event_in_lang_language_id_a100e380_fk_events_la FOREIGN KEY (language_id) REFERENCES public.events_language(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event_in_language events_event_in_language_event_id_8dfd0785_fk_events_event_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event_in_language
    ADD CONSTRAINT events_event_in_language_event_id_8dfd0785_fk_events_event_id FOREIGN KEY (event_id) REFERENCES public.events_event(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event_keywords events_event_keywords_event_id_7d8194be_fk_events_event_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event_keywords
    ADD CONSTRAINT events_event_keywords_event_id_7d8194be_fk_events_event_id FOREIGN KEY (event_id) REFERENCES public.events_event(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event_keywords events_event_keywords_keyword_id_00652ea7_fk_events_keyword_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event_keywords
    ADD CONSTRAINT events_event_keywords_keyword_id_00652ea7_fk_events_keyword_id FOREIGN KEY (keyword_id) REFERENCES public.events_keyword(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event events_event_last_modified_by_id_f4d5285c_fk; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event
    ADD CONSTRAINT events_event_last_modified_by_id_f4d5285c_fk FOREIGN KEY (last_modified_by_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event events_event_location_id_2fb4171f_fk_events_place_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event
    ADD CONSTRAINT events_event_location_id_2fb4171f_fk_events_place_id FOREIGN KEY (location_id) REFERENCES public.events_place(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event events_event_publisher_id_39b67381_fk_django_or; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event
    ADD CONSTRAINT events_event_publisher_id_39b67381_fk_django_or FOREIGN KEY (publisher_id) REFERENCES public.django_orghierarchy_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event events_event_super_event_id_010443c8_fk_events_event_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_event
    ADD CONSTRAINT events_event_super_event_id_010443c8_fk_events_event_id FOREIGN KEY (super_event_id) REFERENCES public.events_event(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventaggregatemember events_eventaggregat_event_aggregate_id_97feff63_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_eventaggregatemember
    ADD CONSTRAINT events_eventaggregat_event_aggregate_id_97feff63_fk_events_ev FOREIGN KEY (event_aggregate_id) REFERENCES public.events_eventaggregate(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventaggregatemember events_eventaggregat_event_id_8336130a_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_eventaggregatemember
    ADD CONSTRAINT events_eventaggregat_event_id_8336130a_fk_events_ev FOREIGN KEY (event_id) REFERENCES public.events_event(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventaggregate events_eventaggregat_super_event_id_9289a5a7_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_eventaggregate
    ADD CONSTRAINT events_eventaggregat_super_event_id_9289a5a7_fk_events_ev FOREIGN KEY (super_event_id) REFERENCES public.events_event(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventlink events_eventlink_event_id_ad88499a_fk_events_event_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_eventlink
    ADD CONSTRAINT events_eventlink_event_id_ad88499a_fk_events_event_id FOREIGN KEY (event_id) REFERENCES public.events_event(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventlink events_eventlink_language_id_f0063e1f_fk_events_language_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_eventlink
    ADD CONSTRAINT events_eventlink_language_id_f0063e1f_fk_events_language_id FOREIGN KEY (language_id) REFERENCES public.events_language(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_exportinfo events_exportinfo_content_type_id_fba87bac_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_exportinfo
    ADD CONSTRAINT events_exportinfo_content_type_id_fba87bac_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_image events_image_created_by_id_fb4db6bf_fk; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_image
    ADD CONSTRAINT events_image_created_by_id_fb4db6bf_fk FOREIGN KEY (created_by_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_image events_image_data_source_id_c6636999_fk_events_datasource_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_image
    ADD CONSTRAINT events_image_data_source_id_c6636999_fk_events_datasource_id FOREIGN KEY (data_source_id) REFERENCES public.events_datasource(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_image events_image_last_modified_by_id_57dea795_fk; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_image
    ADD CONSTRAINT events_image_last_modified_by_id_57dea795_fk FOREIGN KEY (last_modified_by_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_image events_image_license_id_3874eeb6_fk_events_license_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_image
    ADD CONSTRAINT events_image_license_id_3874eeb6_fk_events_license_id FOREIGN KEY (license_id) REFERENCES public.events_license(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_image events_image_publisher_id_703963ad_fk_django_or; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_image
    ADD CONSTRAINT events_image_publisher_id_703963ad_fk_django_or FOREIGN KEY (publisher_id) REFERENCES public.django_orghierarchy_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_keyword_alt_labels events_keyword_alt_l_keyword_id_dc5f6805_fk_events_ke; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keyword_alt_labels
    ADD CONSTRAINT events_keyword_alt_l_keyword_id_dc5f6805_fk_events_ke FOREIGN KEY (keyword_id) REFERENCES public.events_keyword(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_keyword_alt_labels events_keyword_alt_l_keywordlabel_id_1c197b40_fk_events_ke; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keyword_alt_labels
    ADD CONSTRAINT events_keyword_alt_l_keywordlabel_id_1c197b40_fk_events_ke FOREIGN KEY (keywordlabel_id) REFERENCES public.events_keywordlabel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_keyword events_keyword_created_by_id_5ab6a9c5_fk; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keyword
    ADD CONSTRAINT events_keyword_created_by_id_5ab6a9c5_fk FOREIGN KEY (created_by_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_keyword events_keyword_data_source_id_4ba7109b_fk_events_datasource_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keyword
    ADD CONSTRAINT events_keyword_data_source_id_4ba7109b_fk_events_datasource_id FOREIGN KEY (data_source_id) REFERENCES public.events_datasource(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_keyword events_keyword_image_id_a2ffafa5_fk_events_image_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keyword
    ADD CONSTRAINT events_keyword_image_id_a2ffafa5_fk_events_image_id FOREIGN KEY (image_id) REFERENCES public.events_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_keyword events_keyword_last_modified_by_id_e5632600_fk; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keyword
    ADD CONSTRAINT events_keyword_last_modified_by_id_e5632600_fk FOREIGN KEY (last_modified_by_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_keyword events_keyword_publisher_id_26968fc2_fk_django_or; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keyword
    ADD CONSTRAINT events_keyword_publisher_id_26968fc2_fk_django_or FOREIGN KEY (publisher_id) REFERENCES public.django_orghierarchy_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_keywordlabel events_keywordlabel_language_id_6b1f489e_fk_events_language_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keywordlabel
    ADD CONSTRAINT events_keywordlabel_language_id_6b1f489e_fk_events_language_id FOREIGN KEY (language_id) REFERENCES public.events_language(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_keywordset events_keywordset_created_by_id_4518f287_fk; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keywordset
    ADD CONSTRAINT events_keywordset_created_by_id_4518f287_fk FOREIGN KEY (created_by_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_keywordset events_keywordset_data_source_id_d310b1d2_fk_events_da; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keywordset
    ADD CONSTRAINT events_keywordset_data_source_id_d310b1d2_fk_events_da FOREIGN KEY (data_source_id) REFERENCES public.events_datasource(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_keywordset events_keywordset_image_id_f9c3e490_fk_events_image_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keywordset
    ADD CONSTRAINT events_keywordset_image_id_f9c3e490_fk_events_image_id FOREIGN KEY (image_id) REFERENCES public.events_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_keywordset_keywords events_keywordset_ke_keyword_id_16143a75_fk_events_ke; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keywordset_keywords
    ADD CONSTRAINT events_keywordset_ke_keyword_id_16143a75_fk_events_ke FOREIGN KEY (keyword_id) REFERENCES public.events_keyword(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_keywordset_keywords events_keywordset_ke_keywordset_id_c67c87c3_fk_events_ke; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keywordset_keywords
    ADD CONSTRAINT events_keywordset_ke_keywordset_id_c67c87c3_fk_events_ke FOREIGN KEY (keywordset_id) REFERENCES public.events_keywordset(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_keywordset events_keywordset_last_modified_by_id_eb02bbcb_fk; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keywordset
    ADD CONSTRAINT events_keywordset_last_modified_by_id_eb02bbcb_fk FOREIGN KEY (last_modified_by_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_keywordset events_keywordset_organization_id_11b513b8_fk_django_or; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_keywordset
    ADD CONSTRAINT events_keywordset_organization_id_11b513b8_fk_django_or FOREIGN KEY (organization_id) REFERENCES public.django_orghierarchy_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_offer events_offer_event_id_1a22341c_fk_events_event_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_offer
    ADD CONSTRAINT events_offer_event_id_1a22341c_fk_events_event_id FOREIGN KEY (event_id) REFERENCES public.events_event(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_openinghoursspecification events_openinghourss_place_id_6de4e079_fk_events_pl; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_openinghoursspecification
    ADD CONSTRAINT events_openinghourss_place_id_6de4e079_fk_events_pl FOREIGN KEY (place_id) REFERENCES public.events_place(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_place events_place_created_by_id_a5026653_fk; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_place
    ADD CONSTRAINT events_place_created_by_id_a5026653_fk FOREIGN KEY (created_by_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_place events_place_data_source_id_9b44a6ac_fk_events_datasource_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_place
    ADD CONSTRAINT events_place_data_source_id_9b44a6ac_fk_events_datasource_id FOREIGN KEY (data_source_id) REFERENCES public.events_datasource(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_place_divisions events_place_divisio_administrativedivisi_02bebcdb_fk_munigeo_a; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_place_divisions
    ADD CONSTRAINT events_place_divisio_administrativedivisi_02bebcdb_fk_munigeo_a FOREIGN KEY (administrativedivision_id) REFERENCES public.munigeo_administrativedivision(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_place_divisions events_place_divisions_place_id_065984b7_fk_events_place_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_place_divisions
    ADD CONSTRAINT events_place_divisions_place_id_065984b7_fk_events_place_id FOREIGN KEY (place_id) REFERENCES public.events_place(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_place events_place_image_id_9c4c39cd_fk_events_image_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_place
    ADD CONSTRAINT events_place_image_id_9c4c39cd_fk_events_image_id FOREIGN KEY (image_id) REFERENCES public.events_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_place events_place_last_modified_by_id_09bf61ff_fk; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_place
    ADD CONSTRAINT events_place_last_modified_by_id_09bf61ff_fk FOREIGN KEY (last_modified_by_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_place events_place_parent_id_e61d1fff_fk_events_place_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_place
    ADD CONSTRAINT events_place_parent_id_e61d1fff_fk_events_place_id FOREIGN KEY (parent_id) REFERENCES public.events_place(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_place events_place_publisher_id_75aee1d9_fk_django_or; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_place
    ADD CONSTRAINT events_place_publisher_id_75aee1d9_fk_django_or FOREIGN KEY (publisher_id) REFERENCES public.django_orghierarchy_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_place events_place_replaced_by_id_4553469d_fk_events_place_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.events_place
    ADD CONSTRAINT events_place_replaced_by_id_4553469d_fk_events_place_id FOREIGN KEY (replaced_by_id) REFERENCES public.events_place(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: helevents_user_ad_groups helevents_user_ad_gr_adgroup_id_0a5fd04a_fk_helusers_; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helevents_user_ad_groups
    ADD CONSTRAINT helevents_user_ad_gr_adgroup_id_0a5fd04a_fk_helusers_ FOREIGN KEY (adgroup_id) REFERENCES public.helusers_adgroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: helevents_user_ad_groups helevents_user_ad_groups_user_id_f7a3e896_fk_helevents_user_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helevents_user_ad_groups
    ADD CONSTRAINT helevents_user_ad_groups_user_id_f7a3e896_fk_helevents_user_id FOREIGN KEY (user_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: helevents_user_groups helevents_user_groups_group_id_aed60c4f_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helevents_user_groups
    ADD CONSTRAINT helevents_user_groups_group_id_aed60c4f_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: helevents_user_groups helevents_user_groups_user_id_71614dd9_fk_helevents_user_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helevents_user_groups
    ADD CONSTRAINT helevents_user_groups_user_id_71614dd9_fk_helevents_user_id FOREIGN KEY (user_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: helevents_user_user_permissions helevents_user_user__permission_id_f5dae855_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helevents_user_user_permissions
    ADD CONSTRAINT helevents_user_user__permission_id_f5dae855_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: helevents_user_user_permissions helevents_user_user__user_id_2a313f21_fk_helevents; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helevents_user_user_permissions
    ADD CONSTRAINT helevents_user_user__user_id_2a313f21_fk_helevents FOREIGN KEY (user_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: helusers_adgroupmapping helusers_adgroupmapp_ad_group_id_51386ad7_fk_helusers_; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helusers_adgroupmapping
    ADD CONSTRAINT helusers_adgroupmapp_ad_group_id_51386ad7_fk_helusers_ FOREIGN KEY (ad_group_id) REFERENCES public.helusers_adgroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: helusers_adgroupmapping helusers_adgroupmapping_group_id_bf4c1c7c_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.helusers_adgroupmapping
    ADD CONSTRAINT helusers_adgroupmapping_group_id_bf4c1c7c_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: munigeo_address munigeo_address_street_id_b1d7718d_fk_munigeo_street_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_address
    ADD CONSTRAINT munigeo_address_street_id_b1d7718d_fk_munigeo_street_id FOREIGN KEY (street_id) REFERENCES public.munigeo_street(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: munigeo_administrativedivisiongeometry munigeo_administrati_division_id_42f0c8f4_fk_munigeo_a; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_administrativedivisiongeometry
    ADD CONSTRAINT munigeo_administrati_division_id_42f0c8f4_fk_munigeo_a FOREIGN KEY (division_id) REFERENCES public.munigeo_administrativedivision(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: munigeo_administrativedivision munigeo_administrati_municipality_id_3ff7058c_fk_munigeo_m; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_administrativedivision
    ADD CONSTRAINT munigeo_administrati_municipality_id_3ff7058c_fk_munigeo_m FOREIGN KEY (municipality_id) REFERENCES public.munigeo_municipality(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: munigeo_administrativedivision munigeo_administrati_parent_id_5f9d6073_fk_munigeo_a; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_administrativedivision
    ADD CONSTRAINT munigeo_administrati_parent_id_5f9d6073_fk_munigeo_a FOREIGN KEY (parent_id) REFERENCES public.munigeo_administrativedivision(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: munigeo_administrativedivision munigeo_administrati_type_id_6edb8778_fk_munigeo_a; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_administrativedivision
    ADD CONSTRAINT munigeo_administrati_type_id_6edb8778_fk_munigeo_a FOREIGN KEY (type_id) REFERENCES public.munigeo_administrativedivisiontype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: munigeo_building_addresses munigeo_building_add_address_id_801dc46f_fk_munigeo_a; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_building_addresses
    ADD CONSTRAINT munigeo_building_add_address_id_801dc46f_fk_munigeo_a FOREIGN KEY (address_id) REFERENCES public.munigeo_address(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: munigeo_building_addresses munigeo_building_add_building_id_bf18e998_fk_munigeo_b; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_building_addresses
    ADD CONSTRAINT munigeo_building_add_building_id_bf18e998_fk_munigeo_b FOREIGN KEY (building_id) REFERENCES public.munigeo_building(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: munigeo_building munigeo_building_municipality_id_07970ec8_fk_munigeo_m; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_building
    ADD CONSTRAINT munigeo_building_municipality_id_07970ec8_fk_munigeo_m FOREIGN KEY (municipality_id) REFERENCES public.munigeo_municipality(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: munigeo_municipality munigeo_municipality_division_id_666a5b9a_fk_munigeo_a; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_municipality
    ADD CONSTRAINT munigeo_municipality_division_id_666a5b9a_fk_munigeo_a FOREIGN KEY (division_id) REFERENCES public.munigeo_administrativedivision(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: munigeo_plan munigeo_plan_municipality_id_d01e664f_fk_munigeo_m; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_plan
    ADD CONSTRAINT munigeo_plan_municipality_id_d01e664f_fk_munigeo_m FOREIGN KEY (municipality_id) REFERENCES public.munigeo_municipality(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: munigeo_poi munigeo_poi_category_id_5805c26b_fk_munigeo_poicategory_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_poi
    ADD CONSTRAINT munigeo_poi_category_id_5805c26b_fk_munigeo_poicategory_id FOREIGN KEY (category_id) REFERENCES public.munigeo_poicategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: munigeo_poi munigeo_poi_municipality_id_ca5c4b23_fk_munigeo_municipality_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_poi
    ADD CONSTRAINT munigeo_poi_municipality_id_ca5c4b23_fk_munigeo_municipality_id FOREIGN KEY (municipality_id) REFERENCES public.munigeo_municipality(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: munigeo_street munigeo_street_municipality_id_ef6fd93f_fk_munigeo_m; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.munigeo_street
    ADD CONSTRAINT munigeo_street_municipality_id_ef6fd93f_fk_munigeo_m FOREIGN KEY (municipality_id) REFERENCES public.munigeo_municipality(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: reversion_revision reversion_revision_user_id_17095f45_fk_helevents_user_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.reversion_revision
    ADD CONSTRAINT reversion_revision_user_id_17095f45_fk_helevents_user_id FOREIGN KEY (user_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: reversion_version reversion_version_content_type_id_7d0ff25c_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.reversion_version
    ADD CONSTRAINT reversion_version_content_type_id_7d0ff25c_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: reversion_version reversion_version_revision_id_af9f6a9d_fk_reversion_revision_id; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.reversion_version
    ADD CONSTRAINT reversion_version_revision_id_af9f6a9d_fk_reversion_revision_id FOREIGN KEY (revision_id) REFERENCES public.reversion_revision(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: socialaccount_socialtoken socialaccount_social_account_id_951f210e_fk_socialacc; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.socialaccount_socialtoken
    ADD CONSTRAINT socialaccount_social_account_id_951f210e_fk_socialacc FOREIGN KEY (account_id) REFERENCES public.socialaccount_socialaccount(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: socialaccount_socialtoken socialaccount_social_app_id_636a42d7_fk_socialacc; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.socialaccount_socialtoken
    ADD CONSTRAINT socialaccount_social_app_id_636a42d7_fk_socialacc FOREIGN KEY (app_id) REFERENCES public.socialaccount_socialapp(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: socialaccount_socialapp_sites socialaccount_social_site_id_2579dee5_fk_django_si; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.socialaccount_socialapp_sites
    ADD CONSTRAINT socialaccount_social_site_id_2579dee5_fk_django_si FOREIGN KEY (site_id) REFERENCES public.django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: socialaccount_socialapp_sites socialaccount_social_socialapp_id_97fb6e7d_fk_socialacc; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.socialaccount_socialapp_sites
    ADD CONSTRAINT socialaccount_social_socialapp_id_97fb6e7d_fk_socialacc FOREIGN KEY (socialapp_id) REFERENCES public.socialaccount_socialapp(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: socialaccount_socialaccount socialaccount_social_user_id_8146e70c_fk_helevents; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.socialaccount_socialaccount
    ADD CONSTRAINT socialaccount_social_user_id_8146e70c_fk_helevents FOREIGN KEY (user_id) REFERENCES public.helevents_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_password_reset user_password_reset_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: linkedevents
--

ALTER TABLE ONLY public.user_password_reset
    ADD CONSTRAINT user_password_reset_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.helevents_user(id) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

