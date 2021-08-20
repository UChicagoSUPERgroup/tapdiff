--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.21
-- Dumped by pg_dump version 9.5.21

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO iftttuser;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO iftttuser;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO iftttuser;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO iftttuser;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO iftttuser;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO iftttuser;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO iftttuser;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO iftttuser;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO iftttuser;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO iftttuser;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO iftttuser;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO iftttuser;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- Name: backend_binparam; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_binparam (
    parameter_ptr_id integer NOT NULL,
    tval text NOT NULL,
    fval text NOT NULL
);


ALTER TABLE public.backend_binparam OWNER TO iftttuser;

--
-- Name: backend_capability; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_capability (
    id integer NOT NULL,
    name character varying(30) NOT NULL,
    readable boolean NOT NULL,
    writeable boolean NOT NULL,
    statelabel text,
    commandlabel text,
    eventlabel text
);


ALTER TABLE public.backend_capability OWNER TO iftttuser;

--
-- Name: backend_capability_channels; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_capability_channels (
    id integer NOT NULL,
    capability_id integer NOT NULL,
    channel_id integer NOT NULL
);


ALTER TABLE public.backend_capability_channels OWNER TO iftttuser;

--
-- Name: backend_capability_channels_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_capability_channels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_capability_channels_id_seq OWNER TO iftttuser;

--
-- Name: backend_capability_channels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_capability_channels_id_seq OWNED BY public.backend_capability_channels.id;


--
-- Name: backend_capability_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_capability_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_capability_id_seq OWNER TO iftttuser;

--
-- Name: backend_capability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_capability_id_seq OWNED BY public.backend_capability.id;


--
-- Name: backend_channel; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_channel (
    id integer NOT NULL,
    name character varying(30) NOT NULL,
    icon text
);


ALTER TABLE public.backend_channel OWNER TO iftttuser;

--
-- Name: backend_channel_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_channel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_channel_id_seq OWNER TO iftttuser;

--
-- Name: backend_channel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_channel_id_seq OWNED BY public.backend_channel.id;


--
-- Name: backend_colorparam; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_colorparam (
    parameter_ptr_id integer NOT NULL,
    mode text NOT NULL
);


ALTER TABLE public.backend_colorparam OWNER TO iftttuser;

--
-- Name: backend_condition; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_condition (
    id integer NOT NULL,
    val text NOT NULL,
    comp text NOT NULL,
    par_id integer NOT NULL,
    trigger_id integer NOT NULL
);


ALTER TABLE public.backend_condition OWNER TO iftttuser;

--
-- Name: backend_condition_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_condition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_condition_id_seq OWNER TO iftttuser;

--
-- Name: backend_condition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_condition_id_seq OWNED BY public.backend_condition.id;


--
-- Name: backend_device; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_device (
    id integer NOT NULL,
    public boolean NOT NULL,
    name character varying(32) NOT NULL,
    icon text,
    owner_id integer NOT NULL
);


ALTER TABLE public.backend_device OWNER TO iftttuser;

--
-- Name: backend_device_caps; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_device_caps (
    id integer NOT NULL,
    device_id integer NOT NULL,
    capability_id integer NOT NULL
);


ALTER TABLE public.backend_device_caps OWNER TO iftttuser;

--
-- Name: backend_device_caps_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_device_caps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_device_caps_id_seq OWNER TO iftttuser;

--
-- Name: backend_device_caps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_device_caps_id_seq OWNED BY public.backend_device_caps.id;


--
-- Name: backend_device_chans; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_device_chans (
    id integer NOT NULL,
    device_id integer NOT NULL,
    channel_id integer NOT NULL
);


ALTER TABLE public.backend_device_chans OWNER TO iftttuser;

--
-- Name: backend_device_chans_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_device_chans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_device_chans_id_seq OWNER TO iftttuser;

--
-- Name: backend_device_chans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_device_chans_id_seq OWNED BY public.backend_device_chans.id;


--
-- Name: backend_device_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_device_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_device_id_seq OWNER TO iftttuser;

--
-- Name: backend_device_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_device_id_seq OWNED BY public.backend_device.id;


--
-- Name: backend_durationparam; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_durationparam (
    parameter_ptr_id integer NOT NULL,
    comp boolean NOT NULL,
    maxhours integer,
    maxmins integer,
    maxsecs integer
);


ALTER TABLE public.backend_durationparam OWNER TO iftttuser;

--
-- Name: backend_esrule; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_esrule (
    rule_ptr_id integer NOT NULL,
    "Etrigger_id" integer NOT NULL,
    action_id integer NOT NULL
);


ALTER TABLE public.backend_esrule OWNER TO iftttuser;

--
-- Name: backend_esrule_Striggers; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public."backend_esrule_Striggers" (
    id integer NOT NULL,
    esrule_id integer NOT NULL,
    trigger_id integer NOT NULL
);


ALTER TABLE public."backend_esrule_Striggers" OWNER TO iftttuser;

--
-- Name: backend_esrule_Striggers_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public."backend_esrule_Striggers_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."backend_esrule_Striggers_id_seq" OWNER TO iftttuser;

--
-- Name: backend_esrule_Striggers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public."backend_esrule_Striggers_id_seq" OWNED BY public."backend_esrule_Striggers".id;


--
-- Name: backend_esrulemeta; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_esrulemeta (
    id integer NOT NULL,
    is_template boolean NOT NULL,
    rule_id integer NOT NULL,
    tapset_id integer NOT NULL
);


ALTER TABLE public.backend_esrulemeta OWNER TO iftttuser;

--
-- Name: backend_esrulemeta_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_esrulemeta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_esrulemeta_id_seq OWNER TO iftttuser;

--
-- Name: backend_esrulemeta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_esrulemeta_id_seq OWNED BY public.backend_esrulemeta.id;


--
-- Name: backend_inputparam; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_inputparam (
    parameter_ptr_id integer NOT NULL,
    inputtype text NOT NULL
);


ALTER TABLE public.backend_inputparam OWNER TO iftttuser;

--
-- Name: backend_metaparam; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_metaparam (
    parameter_ptr_id integer NOT NULL,
    is_event boolean NOT NULL
);


ALTER TABLE public.backend_metaparam OWNER TO iftttuser;

--
-- Name: backend_parameter; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_parameter (
    id integer NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    cap_id integer NOT NULL
);


ALTER TABLE public.backend_parameter OWNER TO iftttuser;

--
-- Name: backend_parameter_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_parameter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_parameter_id_seq OWNER TO iftttuser;

--
-- Name: backend_parameter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_parameter_id_seq OWNED BY public.backend_parameter.id;


--
-- Name: backend_parval; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_parval (
    id integer NOT NULL,
    val text NOT NULL,
    par_id integer NOT NULL,
    state_id integer NOT NULL
);


ALTER TABLE public.backend_parval OWNER TO iftttuser;

--
-- Name: backend_parval_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_parval_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_parval_id_seq OWNER TO iftttuser;

--
-- Name: backend_parval_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_parval_id_seq OWNED BY public.backend_parval.id;


--
-- Name: backend_rangeparam; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_rangeparam (
    parameter_ptr_id integer NOT NULL,
    min integer NOT NULL,
    max integer NOT NULL,
    "interval" double precision NOT NULL
);


ALTER TABLE public.backend_rangeparam OWNER TO iftttuser;

--
-- Name: backend_rule; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_rule (
    id integer NOT NULL,
    task integer NOT NULL,
    version integer NOT NULL,
    lastedit timestamp with time zone NOT NULL,
    type character varying(3) NOT NULL,
    owner_id integer NOT NULL
);


ALTER TABLE public.backend_rule OWNER TO iftttuser;

--
-- Name: backend_rule_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_rule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_rule_id_seq OWNER TO iftttuser;

--
-- Name: backend_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_rule_id_seq OWNED BY public.backend_rule.id;


--
-- Name: backend_safetyprop; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_safetyprop (
    id integer NOT NULL,
    task integer NOT NULL,
    lastedit timestamp with time zone NOT NULL,
    type integer NOT NULL,
    always boolean NOT NULL,
    owner_id integer NOT NULL
);


ALTER TABLE public.backend_safetyprop OWNER TO iftttuser;

--
-- Name: backend_safetyprop_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_safetyprop_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_safetyprop_id_seq OWNER TO iftttuser;

--
-- Name: backend_safetyprop_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_safetyprop_id_seq OWNED BY public.backend_safetyprop.id;


--
-- Name: backend_setparam; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_setparam (
    parameter_ptr_id integer NOT NULL,
    numopts integer NOT NULL
);


ALTER TABLE public.backend_setparam OWNER TO iftttuser;

--
-- Name: backend_setparamopt; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_setparamopt (
    id integer NOT NULL,
    value text NOT NULL,
    param_id integer NOT NULL
);


ALTER TABLE public.backend_setparamopt OWNER TO iftttuser;

--
-- Name: backend_setparamopt_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_setparamopt_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_setparamopt_id_seq OWNER TO iftttuser;

--
-- Name: backend_setparamopt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_setparamopt_id_seq OWNED BY public.backend_setparamopt.id;


--
-- Name: backend_sp1; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_sp1 (
    safetyprop_ptr_id integer NOT NULL
);


ALTER TABLE public.backend_sp1 OWNER TO iftttuser;

--
-- Name: backend_sp1_triggers; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_sp1_triggers (
    id integer NOT NULL,
    sp1_id integer NOT NULL,
    trigger_id integer NOT NULL
);


ALTER TABLE public.backend_sp1_triggers OWNER TO iftttuser;

--
-- Name: backend_sp1_triggers_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_sp1_triggers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_sp1_triggers_id_seq OWNER TO iftttuser;

--
-- Name: backend_sp1_triggers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_sp1_triggers_id_seq OWNED BY public.backend_sp1_triggers.id;


--
-- Name: backend_sp2; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_sp2 (
    safetyprop_ptr_id integer NOT NULL,
    comp text,
    "time" integer,
    state_id integer NOT NULL
);


ALTER TABLE public.backend_sp2 OWNER TO iftttuser;

--
-- Name: backend_sp2_conds; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_sp2_conds (
    id integer NOT NULL,
    sp2_id integer NOT NULL,
    trigger_id integer NOT NULL
);


ALTER TABLE public.backend_sp2_conds OWNER TO iftttuser;

--
-- Name: backend_sp2_conds_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_sp2_conds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_sp2_conds_id_seq OWNER TO iftttuser;

--
-- Name: backend_sp2_conds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_sp2_conds_id_seq OWNED BY public.backend_sp2_conds.id;


--
-- Name: backend_sp3; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_sp3 (
    safetyprop_ptr_id integer NOT NULL,
    comp text,
    occurrences integer,
    "time" integer,
    timecomp text,
    event_id integer NOT NULL
);


ALTER TABLE public.backend_sp3 OWNER TO iftttuser;

--
-- Name: backend_sp3_conds; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_sp3_conds (
    id integer NOT NULL,
    sp3_id integer NOT NULL,
    trigger_id integer NOT NULL
);


ALTER TABLE public.backend_sp3_conds OWNER TO iftttuser;

--
-- Name: backend_sp3_conds_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_sp3_conds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_sp3_conds_id_seq OWNER TO iftttuser;

--
-- Name: backend_sp3_conds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_sp3_conds_id_seq OWNED BY public.backend_sp3_conds.id;


--
-- Name: backend_ssrule; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_ssrule (
    rule_ptr_id integer NOT NULL,
    priority integer NOT NULL,
    action_id integer NOT NULL
);


ALTER TABLE public.backend_ssrule OWNER TO iftttuser;

--
-- Name: backend_ssrule_triggers; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_ssrule_triggers (
    id integer NOT NULL,
    ssrule_id integer NOT NULL,
    trigger_id integer NOT NULL
);


ALTER TABLE public.backend_ssrule_triggers OWNER TO iftttuser;

--
-- Name: backend_ssrule_triggers_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_ssrule_triggers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_ssrule_triggers_id_seq OWNER TO iftttuser;

--
-- Name: backend_ssrule_triggers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_ssrule_triggers_id_seq OWNED BY public.backend_ssrule_triggers.id;


--
-- Name: backend_state; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_state (
    id integer NOT NULL,
    action boolean NOT NULL,
    text text,
    cap_id integer NOT NULL,
    chan_id integer,
    dev_id integer NOT NULL
);


ALTER TABLE public.backend_state OWNER TO iftttuser;

--
-- Name: backend_state_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_state_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_state_id_seq OWNER TO iftttuser;

--
-- Name: backend_state_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_state_id_seq OWNED BY public.backend_state.id;


--
-- Name: backend_statelog; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_statelog (
    id integer NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    is_current boolean NOT NULL,
    value text NOT NULL,
    cap_id integer NOT NULL,
    dev_id integer NOT NULL,
    param_id integer NOT NULL
);


ALTER TABLE public.backend_statelog OWNER TO iftttuser;

--
-- Name: backend_statelog_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_statelog_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_statelog_id_seq OWNER TO iftttuser;

--
-- Name: backend_statelog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_statelog_id_seq OWNED BY public.backend_statelog.id;


--
-- Name: backend_timeparam; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_timeparam (
    parameter_ptr_id integer NOT NULL,
    mode text NOT NULL
);


ALTER TABLE public.backend_timeparam OWNER TO iftttuser;

--
-- Name: backend_trigger; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_trigger (
    id integer NOT NULL,
    pos integer,
    text text,
    cap_id integer NOT NULL,
    chan_id integer,
    dev_id integer NOT NULL
);


ALTER TABLE public.backend_trigger OWNER TO iftttuser;

--
-- Name: backend_trigger_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_trigger_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_trigger_id_seq OWNER TO iftttuser;

--
-- Name: backend_trigger_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_trigger_id_seq OWNED BY public.backend_trigger.id;


--
-- Name: backend_user; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_user (
    id integer NOT NULL,
    name character varying(30),
    code text NOT NULL,
    mode character varying(5) NOT NULL
);


ALTER TABLE public.backend_user OWNER TO iftttuser;

--
-- Name: backend_user_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_user_id_seq OWNER TO iftttuser;

--
-- Name: backend_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_user_id_seq OWNED BY public.backend_user.id;


--
-- Name: backend_userselection; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_userselection (
    id integer NOT NULL,
    task integer NOT NULL,
    selection integer[] NOT NULL,
    owner_id integer NOT NULL,
    time_elapsed integer
);


ALTER TABLE public.backend_userselection OWNER TO iftttuser;

--
-- Name: backend_userselection_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_userselection_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_userselection_id_seq OWNER TO iftttuser;

--
-- Name: backend_userselection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_userselection_id_seq OWNED BY public.backend_userselection.id;


--
-- Name: backend_userstudytapset; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_userstudytapset (
    id integer NOT NULL,
    taskset integer NOT NULL,
    scenario integer NOT NULL,
    condition integer NOT NULL,
    task_id integer NOT NULL,
    disabled boolean NOT NULL
);


ALTER TABLE public.backend_userstudytapset OWNER TO iftttuser;

--
-- Name: backend_userstudytapset_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_userstudytapset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_userstudytapset_id_seq OWNER TO iftttuser;

--
-- Name: backend_userstudytapset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_userstudytapset_id_seq OWNED BY public.backend_userstudytapset.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: iftttuser
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


ALTER TABLE public.django_admin_log OWNER TO iftttuser;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO iftttuser;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO iftttuser;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO iftttuser;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO iftttuser;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO iftttuser;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO iftttuser;

--
-- Name: rule_management_abstractcharecteristic; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.rule_management_abstractcharecteristic (
    id integer NOT NULL,
    characteristic_name character varying(200) NOT NULL
);


ALTER TABLE public.rule_management_abstractcharecteristic OWNER TO iftttuser;

--
-- Name: rule_management_abstractcharecteristic_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.rule_management_abstractcharecteristic_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rule_management_abstractcharecteristic_id_seq OWNER TO iftttuser;

--
-- Name: rule_management_abstractcharecteristic_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.rule_management_abstractcharecteristic_id_seq OWNED BY public.rule_management_abstractcharecteristic.id;


--
-- Name: rule_management_device; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.rule_management_device (
    id integer NOT NULL,
    device_name character varying(200) NOT NULL
);


ALTER TABLE public.rule_management_device OWNER TO iftttuser;

--
-- Name: rule_management_device_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.rule_management_device_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rule_management_device_id_seq OWNER TO iftttuser;

--
-- Name: rule_management_device_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.rule_management_device_id_seq OWNED BY public.rule_management_device.id;


--
-- Name: rule_management_device_users; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.rule_management_device_users (
    id integer NOT NULL,
    device_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.rule_management_device_users OWNER TO iftttuser;

--
-- Name: rule_management_device_users_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.rule_management_device_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rule_management_device_users_id_seq OWNER TO iftttuser;

--
-- Name: rule_management_device_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.rule_management_device_users_id_seq OWNED BY public.rule_management_device_users.id;


--
-- Name: rule_management_devicecharecteristic; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.rule_management_devicecharecteristic (
    id integer NOT NULL,
    abstract_charecteristic_id integer NOT NULL,
    device_id integer NOT NULL
);


ALTER TABLE public.rule_management_devicecharecteristic OWNER TO iftttuser;

--
-- Name: rule_management_devicecharecteristic_affected_rules; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.rule_management_devicecharecteristic_affected_rules (
    id integer NOT NULL,
    devicecharecteristic_id integer NOT NULL,
    rule_id integer NOT NULL
);


ALTER TABLE public.rule_management_devicecharecteristic_affected_rules OWNER TO iftttuser;

--
-- Name: rule_management_devicecharecteristic_affected_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.rule_management_devicecharecteristic_affected_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rule_management_devicecharecteristic_affected_rules_id_seq OWNER TO iftttuser;

--
-- Name: rule_management_devicecharecteristic_affected_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.rule_management_devicecharecteristic_affected_rules_id_seq OWNED BY public.rule_management_devicecharecteristic_affected_rules.id;


--
-- Name: rule_management_devicecharecteristic_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.rule_management_devicecharecteristic_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rule_management_devicecharecteristic_id_seq OWNER TO iftttuser;

--
-- Name: rule_management_devicecharecteristic_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.rule_management_devicecharecteristic_id_seq OWNED BY public.rule_management_devicecharecteristic.id;


--
-- Name: rule_management_rule; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.rule_management_rule (
    id integer NOT NULL,
    rule_name character varying(200) NOT NULL
);


ALTER TABLE public.rule_management_rule OWNER TO iftttuser;

--
-- Name: rule_management_rule_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.rule_management_rule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rule_management_rule_id_seq OWNER TO iftttuser;

--
-- Name: rule_management_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.rule_management_rule_id_seq OWNED BY public.rule_management_rule.id;


--
-- Name: st_end_device; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.st_end_device (
    id integer NOT NULL,
    device_id character varying(40) NOT NULL,
    device_name character varying(80) NOT NULL,
    device_label character varying(80) NOT NULL
);


ALTER TABLE public.st_end_device OWNER TO iftttuser;

--
-- Name: st_end_device_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.st_end_device_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.st_end_device_id_seq OWNER TO iftttuser;

--
-- Name: st_end_device_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.st_end_device_id_seq OWNED BY public.st_end_device.id;


--
-- Name: st_end_stapp; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.st_end_stapp (
    id integer NOT NULL,
    st_installed_app_id character varying(40) NOT NULL,
    refresh_token character varying(40) NOT NULL
);


ALTER TABLE public.st_end_stapp OWNER TO iftttuser;

--
-- Name: st_end_stapp_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.st_end_stapp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.st_end_stapp_id_seq OWNER TO iftttuser;

--
-- Name: st_end_stapp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.st_end_stapp_id_seq OWNED BY public.st_end_stapp.id;


--
-- Name: user_auth_usermetadata; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.user_auth_usermetadata (
    id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.user_auth_usermetadata OWNER TO iftttuser;

--
-- Name: user_auth_usermetadata_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.user_auth_usermetadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_auth_usermetadata_id_seq OWNER TO iftttuser;

--
-- Name: user_auth_usermetadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.user_auth_usermetadata_id_seq OWNED BY public.user_auth_usermetadata.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_capability ALTER COLUMN id SET DEFAULT nextval('public.backend_capability_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_capability_channels ALTER COLUMN id SET DEFAULT nextval('public.backend_capability_channels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_channel ALTER COLUMN id SET DEFAULT nextval('public.backend_channel_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_condition ALTER COLUMN id SET DEFAULT nextval('public.backend_condition_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device ALTER COLUMN id SET DEFAULT nextval('public.backend_device_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_caps ALTER COLUMN id SET DEFAULT nextval('public.backend_device_caps_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_chans ALTER COLUMN id SET DEFAULT nextval('public.backend_device_chans_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public."backend_esrule_Striggers" ALTER COLUMN id SET DEFAULT nextval('public."backend_esrule_Striggers_id_seq"'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_esrulemeta ALTER COLUMN id SET DEFAULT nextval('public.backend_esrulemeta_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_parameter ALTER COLUMN id SET DEFAULT nextval('public.backend_parameter_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_parval ALTER COLUMN id SET DEFAULT nextval('public.backend_parval_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_rule ALTER COLUMN id SET DEFAULT nextval('public.backend_rule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_safetyprop ALTER COLUMN id SET DEFAULT nextval('public.backend_safetyprop_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_setparamopt ALTER COLUMN id SET DEFAULT nextval('public.backend_setparamopt_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp1_triggers ALTER COLUMN id SET DEFAULT nextval('public.backend_sp1_triggers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp2_conds ALTER COLUMN id SET DEFAULT nextval('public.backend_sp2_conds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp3_conds ALTER COLUMN id SET DEFAULT nextval('public.backend_sp3_conds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_ssrule_triggers ALTER COLUMN id SET DEFAULT nextval('public.backend_ssrule_triggers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_state ALTER COLUMN id SET DEFAULT nextval('public.backend_state_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_statelog ALTER COLUMN id SET DEFAULT nextval('public.backend_statelog_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_trigger ALTER COLUMN id SET DEFAULT nextval('public.backend_trigger_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_user ALTER COLUMN id SET DEFAULT nextval('public.backend_user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_userselection ALTER COLUMN id SET DEFAULT nextval('public.backend_userselection_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_userstudytapset ALTER COLUMN id SET DEFAULT nextval('public.backend_userstudytapset_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.rule_management_abstractcharecteristic ALTER COLUMN id SET DEFAULT nextval('public.rule_management_abstractcharecteristic_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.rule_management_device ALTER COLUMN id SET DEFAULT nextval('public.rule_management_device_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.rule_management_device_users ALTER COLUMN id SET DEFAULT nextval('public.rule_management_device_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.rule_management_devicecharecteristic ALTER COLUMN id SET DEFAULT nextval('public.rule_management_devicecharecteristic_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.rule_management_devicecharecteristic_affected_rules ALTER COLUMN id SET DEFAULT nextval('public.rule_management_devicecharecteristic_affected_rules_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.rule_management_rule ALTER COLUMN id SET DEFAULT nextval('public.rule_management_rule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.st_end_device ALTER COLUMN id SET DEFAULT nextval('public.st_end_device_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.st_end_stapp ALTER COLUMN id SET DEFAULT nextval('public.st_end_stapp_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.user_auth_usermetadata ALTER COLUMN id SET DEFAULT nextval('public.user_auth_usermetadata_id_seq'::regclass);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can add group	2	add_group
5	Can change group	2	change_group
6	Can delete group	2	delete_group
7	Can add user	3	add_user
8	Can change user	3	change_user
9	Can delete user	3	delete_user
10	Can add permission	4	add_permission
11	Can change permission	4	change_permission
12	Can delete permission	4	delete_permission
13	Can add content type	5	add_contenttype
14	Can change content type	5	change_contenttype
15	Can delete content type	5	delete_contenttype
16	Can add session	6	add_session
17	Can change session	6	change_session
18	Can delete session	6	delete_session
19	Can add user metadata	7	add_usermetadata
20	Can change user metadata	7	change_usermetadata
21	Can delete user metadata	7	delete_usermetadata
22	Can add rule	8	add_rule
23	Can change rule	8	change_rule
24	Can delete rule	8	delete_rule
25	Can add abstract charecteristic	9	add_abstractcharecteristic
26	Can change abstract charecteristic	9	change_abstractcharecteristic
27	Can delete abstract charecteristic	9	delete_abstractcharecteristic
28	Can add device charecteristic	10	add_devicecharecteristic
29	Can change device charecteristic	10	change_devicecharecteristic
30	Can delete device charecteristic	10	delete_devicecharecteristic
31	Can add device	11	add_device
32	Can change device	11	change_device
33	Can delete device	11	delete_device
34	Can add rule	12	add_rule
35	Can change rule	12	change_rule
36	Can delete rule	12	delete_rule
37	Can add user	13	add_user
38	Can change user	13	change_user
39	Can delete user	13	delete_user
40	Can add device	14	add_device
41	Can change device	14	change_device
42	Can delete device	14	delete_device
43	Can add state log	15	add_statelog
44	Can change state log	15	change_statelog
45	Can delete state log	15	delete_statelog
46	Can add safety prop	16	add_safetyprop
47	Can change safety prop	16	change_safetyprop
48	Can delete safety prop	16	delete_safetyprop
49	Can add set param opt	17	add_setparamopt
50	Can change set param opt	17	change_setparamopt
51	Can delete set param opt	17	delete_setparamopt
52	Can add state	18	add_state
53	Can change state	18	change_state
54	Can delete state	18	delete_state
55	Can add par val	19	add_parval
56	Can change par val	19	change_parval
57	Can delete par val	19	delete_parval
58	Can add condition	20	add_condition
59	Can change condition	20	change_condition
60	Can delete condition	20	delete_condition
61	Can add parameter	21	add_parameter
62	Can change parameter	21	change_parameter
63	Can delete parameter	21	delete_parameter
64	Can add capability	22	add_capability
65	Can change capability	22	change_capability
66	Can delete capability	22	delete_capability
67	Can add channel	23	add_channel
68	Can change channel	23	change_channel
69	Can delete channel	23	delete_channel
70	Can add meta param	24	add_metaparam
71	Can change meta param	24	change_metaparam
72	Can delete meta param	24	delete_metaparam
73	Can add es rule	25	add_esrule
74	Can change es rule	25	change_esrule
75	Can delete es rule	25	delete_esrule
76	Can add input param	26	add_inputparam
77	Can change input param	26	change_inputparam
78	Can delete input param	26	delete_inputparam
79	Can add trigger	27	add_trigger
80	Can change trigger	27	change_trigger
81	Can delete trigger	27	delete_trigger
82	Can add s p1	28	add_sp1
83	Can change s p1	28	change_sp1
84	Can delete s p1	28	delete_sp1
85	Can add time param	29	add_timeparam
86	Can change time param	29	change_timeparam
87	Can delete time param	29	delete_timeparam
88	Can add color param	30	add_colorparam
89	Can change color param	30	change_colorparam
90	Can delete color param	30	delete_colorparam
91	Can add ss rule	31	add_ssrule
92	Can change ss rule	31	change_ssrule
93	Can delete ss rule	31	delete_ssrule
94	Can add s p2	32	add_sp2
95	Can change s p2	32	change_sp2
96	Can delete s p2	32	delete_sp2
97	Can add s p3	33	add_sp3
98	Can change s p3	33	change_sp3
99	Can delete s p3	33	delete_sp3
100	Can add set param	34	add_setparam
101	Can change set param	34	change_setparam
102	Can delete set param	34	delete_setparam
103	Can add bin param	35	add_binparam
104	Can change bin param	35	change_binparam
105	Can delete bin param	35	delete_binparam
106	Can add range param	36	add_rangeparam
107	Can change range param	36	change_rangeparam
108	Can delete range param	36	delete_rangeparam
109	Can add duration param	37	add_durationparam
110	Can change duration param	37	change_durationparam
111	Can delete duration param	37	delete_durationparam
112	Can add st app	38	add_stapp
113	Can change st app	38	change_stapp
114	Can delete st app	38	delete_stapp
115	Can add device	39	add_device
116	Can change device	39	change_device
117	Can delete device	39	delete_device
118	Can add es rule meta	40	add_esrulemeta
119	Can change es rule meta	40	change_esrulemeta
120	Can delete es rule meta	40	delete_esrulemeta
121	Can add user study tap set	41	add_userstudytapset
122	Can change user study tap set	41	change_userstudytapset
123	Can delete user study tap set	41	delete_userstudytapset
124	Can add user selection	42	add_userselection
125	Can change user selection	42	change_userselection
126	Can delete user selection	42	delete_userselection
\.


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 126, true);


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
3	pbkdf2_sha256$100000$TUfYcZxL89mF$+JZsIuas1kGW7bZnI8hpLF0fr4v+8fZqBfyV6L3PFdE=	2020-08-14 18:45:45.373968+00	t	admin			zlfben17@gmail.com	t	t	2020-08-11 16:22:53.226008+00
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 3, true);


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Data for Name: backend_binparam; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_binparam (parameter_ptr_id, tval, fval) FROM stdin;
1	On	Off
12	Locked	Unlocked
13	Open	Closed
14	Motion	No Motion
20	Raining	Not Raining
25	Yes	No
26	On	Off
40	On	Off
62	Day	Night
64	On	Off
65	Open	Closed
66	Smoke Detected	No Smoke Detected
67	Open	Closed
68	Awake	Asleep
72	On	Off
78	On	Off
\.


--
-- Data for Name: backend_capability; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_capability (id, name, readable, writeable, statelabel, commandlabel, eventlabel) FROM stdin;
28	Record	t	t	{DEVICE} is{value/F| not} recording	({DEVICE}) {value/T|start}{value/F|stop} recording	{DEVICE} {value/T|starts}{value/F|stops} recording
36	Channel	t	t	{DEVICE} is {channel/=|tuned to}{channel/!=|not tuned to}{channel/>|tuned above}{channel/<|tuned below} Channel {channel}	Tune {DEVICE} to Channel {channel}	{DEVICE} {channel/=|becomes tuned to}{channel/!=|becomes tuned to something other than}{channel/>|becomes tuned above}{channel/<|becomes tuned below} {channel}
65	Oven Temperature	t	t	{DEVICE}'s temperature {temperature/=|is}{temperature/!=|is not}{temperature/>|is above}{temperature/<|is below} {temperature} degrees	Set {DEVICE}'s temperature to {temperature}	{DEVICE}'s temperature {temperature/=|becomes}{temperature/!=|changes from}{temperature/>|goes above}{temperature/<|falls below} {temperature} degrees
27	Alarm Ringing	t	t	{DEVICE}'s Alarm is{value/F| not} going off	{value/T|Set off}{value/F|Turn off} {DEVICE}'s alarm	{DEVICE}'s Alarm {value/T|Starts}{value/F|Stops} going off
38	How Much Coffee Is There?	t	f	({DEVICE}) There are {cups/=|exactly}{cups/!=|not exactly}{cups/>|more than}{cups/<|fewer than} {cups} cups of coffee brewed	\N	({DEVICE}) The number of cups of coffee {cups/=|becomes}{cups/!=|changes from}{cups/>|becomes larger than}{cups/<|falls below} {cups}
18	Weather Sensor	t	f	({DEVICE}) The weather is{weather/!=| not} {weather}	\N	({DEVICE}) The weather {weather/=|becomes}{weather/!=|stops being} {weather}
62	Heart Rate Sensor	t	f	({DEVICE}) My heart rate is {BPM/=|exactly}{BPM/!=|not}{BPM/>|above}{BPM/<|below} {BPM}BPM	\N	({DEVICE}) My heart rate {BPM/=|becomes}{BPM/!=|changes from}{BPM/>|goes above}{BPM/<|falls below} {BPM}BPM
32	Track Package	t	f	({DEVICE}) Package #{trackingid} is{distance/!=| not} {distance/<|<}{distance/>|>}{distance} miles away	\N	({DEVICE}) Package #{trackingid} {distance/=|becomes}{distance/!=|stops being}{distance/>|becomes farther than}{distance/<|becomes closer than} {distance} miles away
12	FM Tuner	t	t	{DEVICE} {frequency/=|is tuned to}{frequency/!=|is not tuned to}{frequency/>|is tuned above}{frequency/<|is tuned below} {frequency}FM	Tune {DEVICE} to {frequency}FM	{DEVICE} {frequency/=|becomes tuned to}{frequency/!=|stops being tuned to}{frequency/>|becomes tuned above}{frequency/<|becomes tuned below} {frequency}FM
33	What's On My Shopping List?	t	f	({DEVICE}) {item} is{item/!=| not} on my Shopping List	\N	({DEVICE}) {item} {item/=|gets added to}{item/!=|gets removed from} my Shopping List
37	What Show is On?	t	f	{name} is{name/!=| not} playing on {DEVICE}	\N	{name} {name/=|starts}{name/!=|stops} playing on {DEVICE}
29	Take Photo	f	t	\N	({DEVICE}) Take a photo	
30	Order (Amazon)	f	t	\N	({DEVICE}) Order {quantity} {item} on Amazon	
31	Order Pizza	f	t	\N	({DEVICE}) Order {quantity} {size} Pizza(s) with {topping}	
40	Siren	t	t	{DEVICE}'s Siren is {value}	Turn {DEVICE}'s Siren {value}	{DEVICE}'s Siren turns {value}
39	Brew Coffee	f	t	\N	({DEVICE}) Brew {cups} cup(s) of coffee	
64	Water On/Off	t	t	{DEVICE}'s water is {setting/F|not }running	Turn {setting} {DEVICE}'s water	{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}
6	Light Color	t	t	{DEVICE}'s Color {color/=|is}{color/!=|is not} {color}	Set {DEVICE}'s Color to {color}	{DEVICE}'s color {color/=|becomes}{color/!=|changes from} {color}
26	Set Alarm	t	t	{DEVICE}'s Alarm is {time/=|set for}{time/!=|not set for}{time/>|set for later than}{time/<|set for earlier than} {time}	({DEVICE}) Set an Alarm for {time}	{DEVICE}'s Alarm {time/=|gets set for}{time/!=|gets set for something other than}{time/>|gets set for later than}{time/<|gets set for earlier than} {time}
19	Current Temperature	t	f	({DEVICE}) The temperature {temperature/=|is}{temperature/!=|is not}{temperature/>|is above}{temperature/<|is below} {temperature} degrees	\N	({DEVICE}) The temperature {temperature/=|becomes}{temperature/!=|changes from}{temperature/>|goes above}{temperature/<|falls below} {temperature} degrees
50	Event Frequency	t	f	"{$trigger$}" has {occurrences/=|occurred exactly}{occurrences/!=|not occurred exactly}{occurrences/>|occurred more than}{occurrences/<|occurred fewer than} {occurrences} times in the last {time}	\N	It becomes true that "{$trigger$}" has {occurrences/!=|not occurred}{occurrences/=|occurred}{occurrences/>|occurred more than}{occurrences/<|occurred fewer than} {occurrences} times in the last {time}
9	Genre	t	t	{DEVICE} is{genre/!=| not} playing {genre}	Start playing {genre} on {DEVICE}	{DEVICE} {genre/=|starts}{genre/!=|stops} playing {genre}
13	Lock/Unlock	t	t	{DEVICE} is {setting}	{setting/T|Lock}{setting/F|Unlock} {DEVICE}	{DEVICE} {setting/T|Locks}{setting/F|Unlocks}
14	Open/Close Window	t	t	{DEVICE} is {position}	{position/T|Open}{position/F|Close} {DEVICE}	{DEVICE} {position/T|Opens}{position/F|Closes}
15	Detect Motion	t	f	{DEVICE} {status/T|detects}{status/F|does not detect} motion	\N	{DEVICE} {status/T|Starts}{status/F|Stops} Detecting Motion
20	Is it Raining?	t	f	It is {condition}	\N	It {condition/T|starts}{condition/F|stops} raining
35	Play Music	t	t	{name} is {name/!=|not }playing on {DEVICE}	Start playing {name} on {DEVICE}	{name} {name/=|starts}{name/!=|stops} playing on {DEVICE}
49	Previous State	t	f	"{$trigger$}" was active {time} ago	\N	It becomes true that "{$trigger$}" was active {time} ago
51	Time Since State	t	f	"{$trigger$}" was last in effect {time/>|more than}{time/<|less than}{time/=|exactly} {time} ago	\N	It becomes true that "{$trigger$}" was last in effect {time/>|more than}{time/<|less than}{time/=|exactly} {time} ago
52	Time Since Event	t	f	"{$trigger$}" last happened {time/>|more than}{time/<|less than}{time/=|exactly} {time} ago	\N	It becomes true that "{$trigger$}" last happened {time/>|more than}{time/<|less than}{time/=|exactly} {time} ago
55	Is it Daytime?	t	f	It is {time}time	\N	It becomes {time}time
56	Stop Music	f	t	\N	Stop playing music on {DEVICE}	
57	AC On/Off	t	t	The AC is {setting}	Turn {setting} the AC	The AC turns {setting}
58	Open/Close Curtains	t	t	{DEVICE}'s curtains are {position}	{position/T|Open}{position/F|Close} {DEVICE}'s Curtains	{DEVICE}'s curtains {position/T|Open}{position/F|Close}
59	Smoke Detection	t	f	({DEVICE}) {condition/F|No }Smoke is Detected	\N	{DEVICE} {condition/T|Starts}{condition/F|Stops} detecting smoke
60	Open/Close Door	t	t	{DEVICE}'s door is {position}	{position/T|Open}{position/F|Close} {DEVICE}'s Door	{DEVICE}'s door {position/T|Opens}{position/F|Closes}
61	Sleep Sensor	t	f	({DEVICE}) I am {status}	\N	({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}
63	Detect Presence	t	f	{who/!=|Someone other than }{who} is {location/!=|not }in {location}	\N	{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}
21	Thermostat	t	t	{DEVICE} is {temperature/!=|not set to}{temperature/=|set to}{temperature/>|set above}{temperature/<|set below} {temperature} degrees	Set {DEVICE} to {temperature}	{DEVICE}'s temperature {temperature/=|becomes set to}{temperature/!=|changes from being set to}{temperature/>|becomes set above}{temperature/<|becomes set below} {temperature} degrees
3	Brightness	t	t	{DEVICE}'s Brightness {level/=|is}{level/!=|is not}{level/>|is above}{level/<|is below} {level}	Set {DEVICE}'s Brightness to {level}	{DEVICE}'s brightness {level/=|becomes}{level/!=|stops being}{level/>|goes above}{level/<|falls below} {level}
8	Volume	t	t	{DEVICE}'s Volume {level/=|is}{level/!=|is not}{level/>|is above}{level/<|is below} {level}	Set {DEVICE}'s Volume to {level}	{DEVICE}'s Volume {level/=|becomes}{level/!=|changes from}{level/>|goes above}{level/<|falls below} {level}
25	Clock	t	f	({DEVICE}) The time {time/=|is}{time/!=|is not}{time/>|is after}{time/<|is before} {time}	\N	({DEVICE}) The time {time/=|becomes}{time/!=|changes from}{time/>|becomes later than}{time/<|becomes earlier than} {time}
2	Power On/Off	t	t	{DEVICE} is {setting}	Turn {DEVICE} {setting}	{DEVICE} turns {setting}
66	Temperature Control	t	t	{DEVICE}'s temperature is {temperature/=|set to}{temperature/!=|not set to}{temperature/>|set above}{temperature/<|set below} {temperature} degrees	Set {DEVICE}'s temperature to {temperature}	{DEVICE}'s temperature {temperature/=|becomes set to}{temperature/!=|becomes set to something other than}{temperature/>|becomes set above}{temperature/<|becomes set below} {temperature} degrees
68	Illuminance	t	f	({DEVICE}) The illuminance {illuminance/=|is}{illuminance/!=|is not}{illuminance/>|is above}{illuminance/<|is below} {illuminance} lux	({DEVICE}) Set the illuminance level to {illuminance} lux	({DEVICE}) The illuminance {illuminance/=|becomes}{illuminance/!=|changes from}{illuminance/>|goes above}{illuminance/<|falls below} {illuminance} lux
69	Heater On/Off	t	t	The heater is {setting}	Turn {setting} the heater	The heater turns {setting}
70	Detect Presence Set	t	f	{who/!=|Someone other than }{who} is {location/!=|not }in {location}	NA	{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}
\.


--
-- Data for Name: backend_capability_channels; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_capability_channels (id, capability_id, channel_id) FROM stdin;
9	2	1
11	3	2
12	6	2
14	8	3
15	9	3
16	12	3
17	13	4
18	14	5
19	8	12
20	15	6
23	18	6
24	18	7
25	19	8
26	19	6
27	20	7
28	21	8
30	25	9
31	26	9
32	27	9
33	28	10
34	29	10
35	30	11
36	31	11
37	31	13
38	32	11
39	33	11
40	35	3
41	36	12
42	37	12
43	38	13
44	39	13
45	40	4
50	49	14
51	50	14
52	51	14
53	52	14
56	55	9
57	56	3
58	21	13
59	57	8
60	58	5
61	59	6
62	2	2
63	2	3
64	2	12
65	2	13
66	60	13
67	60	5
68	61	16
69	61	6
70	62	16
71	62	6
72	63	6
73	63	15
74	64	17
75	64	13
76	65	13
77	19	13
78	66	8
79	66	13
80	2	18
81	13	13
82	13	5
83	68	2
84	68	6
85	69	8
86	70	6
87	70	15
\.


--
-- Name: backend_capability_channels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_capability_channels_id_seq', 87, true);


--
-- Name: backend_capability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_capability_id_seq', 70, true);


--
-- Data for Name: backend_channel; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_channel (id, name, icon) FROM stdin;
6	Sensors	visibility
7	Weather	filter_drama
8	Temperature	ac_unit
9	Time	access_time
11	Shopping	shopping_cart
12	Television	tv
1	Power	power_settings_new
2	Lights	wb_incandescent
3	Music	library_music
4	Security	lock
15	Location	room
14	History	hourglass_empty
17	Water & Plumbing	local_drink
5	Windows & Doors	meeting_room
16	Health	favorite_border
10	Camera	photo_camera
13	Food & Cooking	fastfood
18	Cleaning	build
\.


--
-- Name: backend_channel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_channel_id_seq', 18, true);


--
-- Data for Name: backend_colorparam; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_colorparam (parameter_ptr_id, mode) FROM stdin;
\.


--
-- Data for Name: backend_condition; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_condition (id, val, comp, par_id, trigger_id) FROM stdin;
1	Asleep	=	68	1
2	Off	=	26	2
3	Unlocked	=	12	3
4	Off	=	26	4
5	Living Room	=	70	5
6	Bobbie	=	71	5
7	 	=	26	6
8	Off	=	26	7
9	Asleep	=	68	8
10	Off	=	26	9
11	Unlocked	=	12	10
12	On	=	26	11
13	Living Room	 	70	12
14	Bobbie	=	71	12
15	Asleep	=	68	13
16	Unlocked	=	12	14
17	Unlocked	=	12	15
18	Off	=	26	16
19	Asleep	=	68	17
20	Off	=	26	18
21	Asleep	=	68	19
22	Asleep	=	68	20
23	Locked	=	12	21
24	Off	=	26	22
25	Off	=	26	23
26	Unlocked	=	12	24
27	Asleep	=	68	25
28	Off	=	26	26
29	Asleep	=	68	27
30	Locked	=	12	28
31	Unlocked	=	12	29
33	Off	=	26	31
35	Off	=	26	33
37	Asleep	=	68	35
39	Asleep	=	68	37
41	Asleep	=	68	39
43	Asleep	=	68	41
45	Unlocked	=	12	43
47	On	=	1	45
49	Unlocked	=	12	47
51	Off	=	26	49
52	Asleep	=	68	50
54	Asleep	=	68	52
55	On	=	1	53
57	Asleep	=	68	55
59	Locked	=	12	57
60	Off	=	26	58
62	Awake	=	68	60
63	Off	=	26	61
64	Unlocked	=	12	62
65	Asleep	=	68	63
66	Off	=	1	64
67	Off	=	26	65
68	Locked	=	12	66
69	Off	=	26	67
70	Asleep	=	68	68
71	Locked	=	12	69
74	Unlocked	=	12	72
75	Awake	=	68	73
76	Off	=	26	74
77	Awake	=	68	75
78	Locked	=	12	76
79	Off	=	26	77
80	Asleep	=	68	78
81	Locked	=	12	79
83	Asleep	=	68	81
84	Unlocked	=	12	82
86	Locked	=	12	84
88	Unlocked	=	12	86
90	Off	=	26	88
91	Asleep	=	68	89
93	Asleep	=	68	91
94	On	=	1	92
96	Asleep	=	68	94
98	Locked	=	12	96
99	Off	=	26	97
101	Awake	=	68	99
103	Unlocked	=	12	101
104	Awake	=	68	102
105	On	=	26	103
106	Locked	=	12	104
108	Asleep	=	68	106
109	Unlocked	=	12	107
112	Unlocked	=	12	110
114	Off	=	26	112
115	Asleep	=	68	113
117	Asleep	=	68	115
118	On	=	1	116
120	Asleep	=	68	118
122	Locked	=	12	120
123	Off	=	26	121
125	Awake	=	68	123
127	Unlocked	=	12	125
128	Awake	=	68	126
129	On	=	26	127
130	Locked	=	12	128
132	Asleep	=	68	130
133	Unlocked	=	12	131
136	Unlocked	=	12	134
138	Unlocked	=	12	136
140	On	=	1	138
141	Locked	=	12	139
142	Closed	=	13	140
143	Closed	=	13	141
144	Closed	=	13	142
145	Closed	=	13	143
146	Closed	=	13	144
147	Closed	=	13	145
148	Closed	=	13	146
149	Closed	=	13	147
150	Closed	=	13	148
151	Open	=	13	149
152	Open	=	13	150
153	Closed	=	13	151
154	Open	=	13	152
155	Open	=	13	153
156	Closed	=	13	154
157	Open	=	13	155
158	Open	=	13	156
159	Closed	=	13	157
160	Closed	=	13	158
161	Closed	=	13	159
162	Closed	=	13	160
163	Closed	=	13	161
164	Closed	=	13	162
165	Closed	=	13	163
166	Closed	=	13	164
167	Closed	=	13	165
168	Closed	=	13	166
169	Open	=	13	167
170	Open	=	13	168
171	Closed	=	13	169
172	Open	=	13	170
173	Open	=	13	171
174	Closed	=	13	172
175	Open	=	13	173
176	Open	=	13	174
177	Closed	=	13	175
179	Closed	=	13	177
180	Closed	=	13	178
182	Closed	=	13	180
183	Closed	=	13	181
185	Closed	=	13	183
186	Closed	=	13	184
188	Open	=	13	186
189	Closed	=	13	187
191	Open	=	13	189
192	Closed	=	13	190
194	Open	=	13	192
195	Closed	=	13	193
196	Closed	=	13	194
197	Closed	=	13	195
198	Closed	=	13	196
199	Open	=	13	197
200	Closed	=	13	198
201	Open	=	13	199
202	Open	=	13	200
203	Closed	=	13	201
204	Open	=	13	202
205	Open	=	13	203
206	Open	=	13	204
207	Closed	=	13	205
208	Closed	=	13	206
209	Closed	=	13	207
210	Closed	=	13	208
211	Closed	=	13	209
212	Closed	=	13	210
213	Closed	=	13	211
214	Open	=	13	212
215	Open	=	13	213
216	Closed	=	13	214
217	Open	=	13	215
218	Open	=	13	216
219	Closed	=	13	217
220	Open	=	13	218
221	Open	=	13	219
222	Closed	=	13	220
223	Closed	=	13	221
224	Closed	=	13	222
225	Closed	=	13	223
226	Open	=	13	224
227	Closed	=	13	225
228	Open	=	13	226
229	Open	=	13	227
230	Closed	=	13	228
231	Open	=	13	229
232	Open	=	13	230
233	Open	=	13	231
234	Closed	=	13	232
235	Closed	=	13	233
236	Closed	=	13	234
237	Closed	=	13	235
238	Closed	=	13	236
239	Closed	=	13	237
240	Closed	=	13	238
241	Open	=	13	239
242	Open	=	13	240
243	Closed	=	13	241
244	Open	=	13	242
245	Open	=	13	243
246	Closed	=	13	244
247	Open	=	13	245
248	Open	=	13	246
249	Closed	=	13	247
250	Closed	=	13	248
251	Closed	=	13	249
252	Closed	=	13	250
254	Closed	=	13	252
255	Open	=	13	253
257	Closed	=	13	255
258	Open	=	13	256
260	Open	=	13	258
261	Closed	=	13	259
262	Closed	=	13	260
263	Closed	=	13	261
264	Open	=	13	262
265	Open	=	13	263
266	Closed	=	13	264
267	Open	=	13	265
268	Open	=	13	266
269	Closed	=	13	267
270	Open	=	13	268
271	Open	=	13	269
272	Closed	=	13	270
273	Open	=	13	271
274	Open	=	13	272
275	Closed	=	13	273
276	Open	=	13	274
277	Closed	=	13	275
278	Closed	=	13	276
279	Open	=	13	277
280	Closed	=	13	278
281	Closed	=	13	279
282	Open	=	13	280
283	Closed	=	13	281
284	Closed	=	13	282
285	Orange	=	3	283
286	Night	=	62	284
287	Living Room	=	70	285
288	Alice	=	71	285
289	On	=	1	286
290	Off	=	1	287
291	Off	=	1	288
292	On	=	1	289
293	Open	=	13	290
294	On	=	1	291
295	Open	=	13	292
296	On	=	1	293
297	On	=	1	294
298	On	=	1	295
299	Open	=	13	296
300	On	=	1	297
301	On	=	1	298
302	On	=	1	299
303	On	=	1	300
304	Open	=	13	301
305	Open	=	13	302
306	Open	=	13	303
307	On	=	1	305
308	On	=	1	304
309	Open	=	13	306
310	On	=	1	307
311	On	=	1	308
312	On	=	1	309
313	On	=	1	310
314	On	=	1	311
315	On	=	1	312
316	Open	=	13	313
317	Open	=	13	314
318	On	=	1	315
319	On	=	1	316
320	Open	=	13	317
321	On	=	1	318
322	Open	=	13	319
323	On	=	1	320
324	On	=	1	322
325	On	=	1	321
326	On	=	1	323
327	On	=	1	324
332	Open	=	13	329
328	Open	=	13	325
329	Open	=	13	326
334	On	=	1	331
335	On	=	1	332
330	On	=	1	327
333	Open	=	13	330
331	On	=	1	328
336	On	=	1	333
337	On	=	1	334
338	Open	=	13	335
339	On	=	1	336
340	On	=	1	337
341	Open	=	13	338
342	On	=	1	339
343	On	=	1	340
344	On	=	1	341
345	On	=	1	342
346	Open	=	13	343
347	Open	=	13	344
348	On	=	1	345
349	On	=	1	346
350	Open	=	13	347
351	Open	=	13	348
352	On	=	1	349
353	On	=	1	350
354	Open	=	13	351
355	On	=	1	352
356	On	=	1	353
357	On	=	1	355
358	On	=	1	354
359	On	=	1	356
360	On	=	1	357
361	On	=	1	358
362	Open	=	13	360
363	Open	=	13	359
364	On	=	1	361
365	Open	=	13	362
366	On	=	1	363
367	On	=	1	364
368	Open	=	13	365
369	On	=	1	366
370	On	=	1	367
371	On	=	1	369
372	On	=	1	368
373	Open	=	13	370
374	Open	=	13	371
375	On	=	1	372
376	On	=	1	373
377	Open	=	13	374
378	Open	=	13	375
379	On	=	1	376
380	On	=	1	377
381	On	=	1	378
382	On	=	1	379
383	Open	=	13	380
384	On	=	1	381
385	On	=	1	382
386	On	=	1	383
387	On	=	1	384
388	Open	=	13	385
389	On	=	1	386
390	Open	=	13	388
391	On	=	1	387
392	On	=	1	389
393	Open	=	13	391
394	On	=	1	390
395	Open	=	13	392
396	Open	=	13	393
397	On	=	1	394
398	On	=	1	395
399	On	=	1	396
400	Open	=	13	397
401	On	=	1	398
402	On	=	1	399
403	On	=	1	400
404	On	=	1	401
405	Open	=	13	402
406	On	=	1	403
407	Open	=	13	404
408	On	=	1	405
409	On	=	1	406
410	Open	=	13	407
411	On	=	1	408
412	Open	=	13	409
413	On	=	1	410
414	On	=	1	412
415	Open	=	13	413
416	On	=	1	411
417	On	=	1	414
418	On	=	1	415
419	Open	=	13	416
420	On	=	1	417
421	On	=	1	418
422	On	=	1	419
423	Open	=	13	420
424	On	=	1	422
425	Open	=	13	421
426	On	=	1	423
427	On	=	1	424
428	Open	=	13	425
429	On	=	1	426
430	On	=	1	427
431	On	=	1	428
432	On	=	1	430
433	On	=	1	429
434	Open	=	13	431
435	On	=	1	433
436	On	=	1	432
437	On	=	1	434
438	Open	=	13	435
439	Open	=	13	436
440	Open	=	13	437
441	Open	=	13	438
442	On	=	1	439
443	On	=	1	440
444	On	=	1	441
445	Open	=	13	442
446	On	=	1	443
447	On	=	1	444
448	On	=	1	446
449	On	=	1	445
450	On	=	1	447
451	Open	=	13	449
452	On	=	1	450
453	Open	=	13	448
454	On	=	1	451
455	On	=	1	452
456	Open	=	13	453
457	Open	=	13	455
458	On	=	1	454
459	On	=	1	457
460	Open	=	13	456
461	On	=	1	458
462	Open	=	13	459
463	On	=	1	461
464	On	=	1	460
465	On	=	1	462
466	On	=	1	464
467	On	=	1	463
468	Open	=	13	465
469	On	=	1	467
470	On	=	1	466
471	Open	=	13	468
472	On	=	1	469
473	On	=	1	470
474	On	=	1	471
475	Open	=	13	472
476	Open	=	13	473
477	Open	=	13	474
478	On	=	1	475
479	On	=	1	476
480	On	=	1	477
481	Open	=	13	478
482	On	=	1	479
483	On	=	1	480
484	On	=	1	481
485	Open	=	13	483
486	On	=	1	482
487	On	=	1	484
488	On	=	1	485
489	On	=	1	486
490	Open	=	13	487
491	On	=	1	488
492	On	=	1	489
493	Open	=	13	490
494	Open	=	13	491
495	Open	=	13	492
496	On	=	1	493
497	On	=	1	494
498	On	=	1	495
499	Open	=	13	496
500	On	=	1	497
501	On	=	1	498
502	On	=	1	500
503	On	=	1	499
504	Open	=	13	501
505	On	=	1	503
506	On	=	1	504
507	On	=	1	502
508	On	=	1	505
509	Open	=	13	506
510	On	=	1	507
511	Open	=	13	508
512	Open	=	13	509
513	Open	=	13	510
514	On	=	1	511
515	On	=	1	512
516	On	=	1	513
517	On	=	1	514
518	On	=	1	515
519	Open	=	13	516
520	On	=	1	517
521	Open	=	13	518
522	On	=	1	519
523	On	=	1	520
524	On	=	1	522
525	On	=	1	521
526	Open	=	13	523
527	Open	=	13	524
528	On	=	1	525
529	On	=	1	526
530	Open	=	13	528
531	Open	=	13	527
532	On	=	1	529
533	On	=	1	530
534	On	=	1	531
535	On	=	1	532
536	Open	=	13	533
537	Closed	=	65	534
538	On	=	1	535
539	On	=	1	536
540	On	=	1	537
541	Living Room	 	70	538
542	Bobbie	 	71	538
543	On	=	1	539
544	On	=	1	541
545	Open	=	65	543
546	On	=	1	540
547	Living Room	=	70	542
548	Bobbie	=	71	542
549	On	=	1	544
550	On	=	1	546
551	Living Room	=	70	545
552	Bobbie	=	71	545
553	On	=	1	547
554	On	=	1	548
555	On	=	1	549
556	On	=	1	550
557	Living Room	=	70	551
558	Living Room	=	70	552
559	Open	=	65	553
560	Bobbie	=	71	551
561	Bobbie	=	71	552
562	On	=	1	555
563	On	=	1	554
564	On	=	1	556
565	On	=	1	557
566	On	=	1	558
567	On	=	1	559
568	Living Room	!=	70	560
569	Alice	=	71	560
573	On	=	1	563
574	Living Room	=	70	564
575	Alice	=	71	564
576	Night	=	62	565
577	On	=	1	566
578	Living Room	=	70	567
579	Alice	=	71	567
580	Off	=	1	568
581	Night	=	62	569
582	Off	=	1	570
583	Living Room	=	70	571
584	Alice	=	71	571
585	Open	=	65	572
586	Day	=	62	573
587	Off	=	1	574
592	Open	=	13	577
593	Living Room	=	70	578
594	A Guest	=	71	578
595	Bathroom	=	70	579
596	A Guest	=	71	579
597	Open	=	13	580
602	Open	=	13	583
604	Bedroom	=	70	585
605	A Guest	=	71	585
610	Closed	=	13	588
611	Living Room	=	70	589
612	A Guest	=	71	589
613	Bathroom	=	70	590
614	A Guest	=	71	590
615	Open	=	13	591
616	Day	=	62	592
617	Bedroom	=	70	593
618	A Guest	=	71	593
621	Bathroom	!=	70	595
622	A Guest	=	71	595
623	Closed	=	13	596
626	Kitchen	!=	70	598
627	Alice	=	71	598
630	Off	=	1	600
631	Day	=	62	601
632	Bedroom	=	70	602
633	A Guest	=	71	602
636	Bathroom	!=	70	604
637	A Guest	=	71	604
638	Closed	=	13	605
639	Living Room	=	70	606
640	A Guest	=	71	606
641	Bathroom	=	70	607
642	A Guest	=	71	607
643	Open	=	13	608
644	Kitchen	=	70	609
645	A Guest	=	71	609
646	Kitchen	!=	70	610
647	Alice	=	71	610
650	Off	=	1	612
651	Day	=	62	613
652	Bedroom	=	70	614
653	A Guest	=	71	614
656	Bathroom	!=	70	616
657	A Guest	=	71	616
658	Closed	=	13	617
659	Bathroom	!=	70	618
660	A Guest	=	71	618
661	Closed	=	13	619
662	Asleep	=	68	620
663	Off	=	26	621
664	Unlocked	=	12	622
665	Off	=	26	623
666	Off	=	26	624
667	Asleep	=	68	625
668	Off	=	26	626
669	Unlocked	=	12	627
670	On	=	26	628
671	On	=	1	629
672	Asleep	=	68	630
673	Unlocked	=	12	631
674	Unlocked	=	12	632
675	Off	=	26	633
676	Asleep	=	68	634
677	On	=	26	635
678	Asleep	=	68	636
679	On	=	1	637
680	Off	=	26	638
681	Asleep	=	68	639
682	Asleep	=	68	640
683	Locked	=	12	641
684	Off	=	26	642
685	On	=	26	643
686	Awake	=	68	644
688	Off	=	26	646
689	Unlocked	=	12	647
690	Awake	=	68	648
692	Asleep	=	68	650
693	Unlocked	=	12	651
694	On	=	26	652
695	Locked	=	12	653
696	Off	=	26	654
697	Asleep	=	68	655
698	Unlocked	=	12	656
699	Unlocked	=	12	657
701	Unlocked	=	12	659
703	Off	=	26	661
704	Asleep	=	68	662
706	Asleep	=	68	664
707	On	=	1	665
709	Asleep	=	68	667
711	Locked	=	12	669
712	Off	=	26	670
714	Asleep	=	68	672
715	Unlocked	=	12	673
718	Unlocked	=	12	676
719	Asleep	=	68	677
720	Unlocked	=	12	678
721	Unlocked	=	12	679
722	Off	=	26	680
723	Asleep	=	68	681
724	On	=	26	682
725	Asleep	=	68	683
726	On	=	1	684
727	Off	=	26	685
728	Asleep	=	68	686
729	Asleep	=	68	687
730	Locked	=	12	688
731	Off	=	26	689
732	Off	=	26	690
733	Asleep	=	68	691
734	Unlocked	=	12	692
735	Unlocked	=	12	693
736	On	=	26	694
737	Unlocked	=	12	695
738	Asleep	=	68	696
739	Unlocked	=	12	697
740	Off	=	26	698
741	Asleep	=	68	699
742	Asleep	=	68	700
743	Locked	=	12	701
744	Off	=	26	702
745	Off	=	26	703
746	Unlocked	=	12	704
747	Awake	=	68	705
748	Off	=	26	706
749	Asleep	=	68	707
750	Unlocked	=	12	708
751	Unlocked	=	12	709
752	On	=	26	710
753	Unlocked	=	12	711
754	On	=	26	712
755	On	=	1	713
756	Locked	=	12	714
757	Asleep	=	68	715
758	Unlocked	=	12	716
759	Unlocked	=	12	717
760	Off	=	26	718
761	Asleep	=	68	719
762	On	=	26	720
763	Asleep	=	68	721
764	On	=	1	722
765	Off	=	26	723
766	Asleep	=	68	724
767	Asleep	=	68	725
768	Locked	=	12	726
769	Off	=	26	727
770	On	=	26	728
771	Awake	=	68	729
772	Off	=	26	730
773	Unlocked	=	12	731
774	Awake	=	68	732
775	On	=	26	733
776	Locked	=	12	734
777	Off	=	26	735
778	Asleep	=	68	736
779	Unlocked	=	12	737
780	Unlocked	=	12	738
781	Asleep	=	68	739
782	Unlocked	=	12	740
783	Unlocked	=	12	741
784	Off	=	26	742
785	Asleep	=	68	743
786	On	=	26	744
787	Asleep	=	68	745
788	On	=	1	746
789	Off	=	26	747
790	Asleep	=	68	748
791	Asleep	=	68	749
792	Locked	=	12	750
793	Off	=	26	751
794	Off	=	26	752
795	Asleep	=	68	753
796	Unlocked	=	12	754
797	Unlocked	=	12	755
798	On	=	26	756
799	Unlocked	=	12	757
800	Asleep	=	68	758
801	Unlocked	=	12	759
802	Off	=	26	760
803	Asleep	=	68	761
804	Asleep	=	68	762
805	Locked	=	12	763
806	Off	=	26	764
807	Off	=	26	765
808	Unlocked	=	12	766
809	Awake	=	68	767
810	Off	=	26	768
811	Asleep	=	68	769
812	Unlocked	=	12	770
813	Unlocked	=	12	771
814	On	=	26	772
815	Unlocked	=	12	773
816	On	=	26	774
817	On	=	1	775
818	Locked	=	12	776
819	Raining	=	20	777
820	Not Raining	=	20	778
821	Closed	=	13	779
822	Day	=	62	780
823	Off	=	1	781
824	Closed	=	65	782
825	Day	=	62	783
826	Night	=	62	784
827	Closed	=	65	785
828	Night	=	62	786
830	Night	=	62	788
831	Open	=	65	789
832	Raining	=	20	790
833	Not Raining	=	20	791
834	Open	=	13	792
835	Night	=	62	793
836	Night	=	62	794
837	Closed	=	65	795
838	Off	=	1	796
839	Closed	=	65	797
840	Night	=	62	798
841	Off	=	1	799
842	Open	=	65	800
843	Night	=	62	801
844	Open	=	13	802
845	Closed	=	65	803
846	Off	=	1	804
847	Off	=	1	805
848	Night	=	62	806
849	Raining	=	20	807
850	Not Raining	=	20	808
851	Open	=	13	809
852	Night	=	62	810
853	Night	=	62	811
854	Closed	=	65	812
855	Off	=	1	813
856	Closed	=	65	814
857	Night	=	62	815
858	Off	=	1	816
859	Open	=	65	817
860	Night	=	62	818
861	Open	=	13	819
862	Closed	=	65	820
863	Off	=	1	821
864	Off	=	1	822
865	Night	=	62	823
866	Not Raining	=	20	824
867	Day	=	62	825
869	Night	=	62	827
870	Open	=	65	828
871	Day	=	62	829
872	Living Room	=	70	830
873	Alice	=	71	830
874	Off	=	1	831
875	Living Room	=	70	832
876	Closed	=	65	833
877	Off	=	1	834
878	Alice	=	71	832
879	Day	=	62	835
880	Closed	=	65	836
881	Closed	=	65	837
882	Living Room	=	70	838
883	Day	=	62	839
884	Day	=	62	840
885	Alice	=	71	838
886	Off	=	1	841
887	Living Room	=	70	842
888	Off	=	1	843
889	Alice	=	71	842
890	Day	=	62	844
891	Living Room	=	70	845
892	Closed	=	65	846
893	Alice	=	71	845
894	Closed	=	65	847
895	Day	=	62	848
896	Closed	=	65	849
897	Living Room	=	70	850
898	Alice	=	71	850
899	Living Room	=	70	851
900	Day	=	62	852
901	Alice	=	71	851
902	Off	=	1	853
903	Off	=	1	854
904	Off	=	1	855
905	Off	=	1	856
906	Day	=	62	857
907	Living Room	=	70	858
908	Alice	=	71	858
909	Closed	=	65	859
910	Closed	=	65	860
911	Day	=	62	861
912	Living Room	=	70	862
913	Alice	=	71	862
914	Closed	=	65	863
915	Living Room	=	70	864
916	Alice	=	71	864
917	Off	=	1	865
918	Day	=	62	866
919	Off	=	1	867
920	Closed	=	65	868
921	Off	=	1	869
922	Day	=	62	870
923	Day	=	62	871
924	Closed	=	65	872
925	Closed	=	65	873
926	Living Room	=	70	874
927	Day	=	62	875
928	Alice	=	71	874
929	Living Room	=	70	876
930	Alice	=	71	876
931	Living Room	=	70	877
932	Alice	=	71	877
933	Off	=	1	878
934	Off	=	1	879
935	Living Room	=	70	880
936	Alice	=	71	880
937	Closed	=	65	881
938	Off	=	1	882
939	Day	=	62	884
940	Closed	=	65	883
941	Closed	=	65	885
942	Living Room	=	70	886
943	Day	=	62	887
944	Alice	=	71	886
945	Day	=	62	888
946	Off	=	1	889
947	Off	=	1	890
948	Living Room	=	70	891
949	Alice	=	71	891
950	Day	=	62	892
951	Living Room	=	70	893
952	Alice	=	71	893
953	Closed	=	65	895
954	Closed	=	65	894
955	Closed	=	65	896
956	Living Room	=	70	897
957	Alice	=	71	897
958	Day	=	62	898
959	Day	=	62	899
960	Off	=	1	900
961	Off	=	1	901
962	Living Room	=	70	902
963	Alice	=	71	902
964	Off	=	1	903
965	Off	=	1	904
966	Day	=	62	905
967	Closed	=	65	906
968	Living Room	=	70	907
969	Alice	=	71	907
970	Day	=	62	908
971	Closed	=	65	909
972	Living Room	=	70	910
973	Alice	=	71	910
974	Closed	=	65	911
977	Day	=	62	913
979	Off	=	1	915
975	Living Room	=	70	912
976	Alice	=	71	912
978	Off	=	1	914
980	Closed	=	65	916
981	Off	=	1	917
982	Day	=	62	919
983	Day	=	62	918
984	Closed	=	65	920
985	Living Room	=	70	921
986	Day	=	62	922
987	Alice	=	71	921
988	Closed	=	65	923
989	Living Room	=	70	924
990	Off	=	1	925
991	Alice	=	71	924
992	Living Room	=	70	926
993	Alice	=	71	926
994	Off	=	1	927
995	Living Room	=	70	928
996	Alice	=	71	928
997	Closed	=	65	929
998	Off	=	1	930
999	Day	=	62	932
1000	Closed	=	65	931
1001	Living Room	=	70	933
1002	Alice	=	71	933
1003	Day	=	62	934
1004	Closed	=	65	935
1005	Off	=	1	936
1006	Day	=	62	937
1007	Living Room	=	70	938
1008	Off	=	1	939
1009	Alice	=	71	938
1010	Closed	=	65	940
1011	Day	=	62	941
1012	Closed	=	65	942
1013	Living Room	=	70	943
1014	Closed	=	65	944
1015	Alice	=	71	943
1016	Day	=	62	945
1017	Day	=	62	947
1018	Living Room	=	70	946
1019	Alice	=	71	946
1020	Living Room	=	70	948
1021	Off	=	1	949
1022	Alice	=	71	948
1023	Off	=	1	950
1024	Day	=	62	951
1025	Off	=	1	952
1026	Off	=	1	953
1027	Closed	=	65	954
1028	Closed	=	65	955
1029	Day	=	62	956
1030	Living Room	=	70	957
1031	Alice	=	71	957
1032	Living Room	=	70	959
1033	Living Room	=	70	958
1034	Closed	=	65	960
1035	Alice	=	71	959
1036	Alice	=	71	958
1037	Closed	=	65	961
1038	Off	=	1	962
1039	Off	=	1	963
1040	Day	=	62	965
1041	Day	=	62	966
1042	Day	=	62	964
1043	Off	=	1	967
1044	Living Room	=	70	969
1045	Closed	=	65	968
1046	Alice	=	71	969
1047	Closed	=	65	970
1048	Day	=	62	971
1049	Off	=	1	972
1050	Living Room	=	70	973
1051	Alice	=	71	973
1052	Living Room	=	70	974
1053	Alice	=	71	974
1054	Living Room	=	70	975
1055	Alice	=	71	975
1056	Off	=	1	976
1057	Closed	=	65	978
1058	Closed	=	65	977
1059	Off	=	1	979
1060	Day	=	62	980
1061	Day	=	62	981
1062	Off	=	1	982
1063	Living Room	=	70	983
1064	Alice	=	71	983
1065	Closed	=	65	984
1066	Day	=	62	985
1067	Living Room	=	70	986
1068	Alice	=	71	986
1069	Off	=	1	987
1070	Day	=	62	988
1071	Closed	=	65	990
1072	Closed	=	65	989
1073	Closed	=	65	991
1074	Living Room	=	70	992
1075	Alice	=	71	992
1076	Living Room	=	70	993
1077	Alice	=	71	993
1078	Day	=	62	994
1079	Day	=	62	995
1080	Off	=	1	996
1081	Off	=	1	998
1082	Off	=	1	997
1083	Day	=	62	999
1084	Living Room	=	70	1000
1085	Alice	=	71	1000
1086	Closed	=	65	1001
1087	Closed	=	65	1002
1088	Off	=	1	1003
1089	Day	=	62	1004
1090	Living Room	=	70	1005
1091	Living Room	=	70	1006
1092	Alice	=	71	1005
1093	Closed	=	65	1008
1094	Alice	=	71	1006
1095	Living Room	=	70	1007
1096	Alice	=	71	1007
1097	Off	=	1	1009
1098	Off	=	1	1010
1099	Day	=	62	1012
1100	Closed	=	65	1011
1101	Living Room	=	70	1013
1102	Closed	=	65	1014
1103	Day	=	62	1015
1104	Alice	=	71	1013
1105	Day	=	62	1016
1106	Day	=	62	1017
1107	Off	=	1	1018
1108	Off	=	1	1019
1109	Living Room	=	70	1020
1110	Alice	=	71	1020
1111	Living Room	=	70	1021
1112	Closed	=	65	1022
1113	Alice	=	71	1021
1114	Closed	=	65	1023
1115	Living Room	=	70	1024
1116	Alice	=	71	1024
1117	Closed	=	65	1025
1118	Day	=	62	1026
1119	Off	=	1	1027
1120	Day	=	62	1028
1121	Living Room	=	70	1029
1122	Alice	=	71	1029
1123	Off	=	1	1030
1124	Off	=	1	1031
1125	Off	=	1	1032
1126	Living Room	=	70	1033
1127	Day	=	62	1034
1128	Alice	=	71	1033
1129	Closed	=	65	1035
1134	Day	=	62	1040
1143	Living Room	=	70	1048
1145	Alice	=	71	1048
1151	Off	=	1	1054
1130	Closed	=	65	1036
1131	Off	=	1	1037
1136	Day	=	62	1042
1142	Closed	=	65	1047
1144	Living Room	=	70	1046
1146	Alice	=	71	1046
1150	Day	=	62	1052
1154	Living Room	=	70	1056
1157	Alice	=	71	1056
1132	Closed	=	65	1038
1137	Living Room	=	70	1044
1141	Alice	=	71	1044
1149	Off	=	1	1051
1133	Closed	=	65	1039
1135	Day	=	62	1041
1138	Living Room	=	70	1043
1139	Day	=	62	1045
1140	Alice	=	71	1043
1147	Closed	=	65	1049
1148	Off	=	1	1050
1152	Closed	=	65	1053
1153	Living Room	=	70	1055
1155	Alice	=	71	1055
1156	Day	=	62	1057
1158	Off	=	1	1058
1159	Off	=	1	1059
1160	Closed	=	65	1060
1161	Off	=	1	1061
1162	Day	=	62	1062
1163	Living Room	=	70	1063
1164	Closed	=	65	1064
1165	Alice	=	71	1063
1166	Day	=	62	1065
1167	Off	=	1	1066
1168	Closed	=	65	1067
1169	Closed	=	65	1068
1170	Day	=	62	1069
1171	Living Room	=	70	1070
1172	Day	=	62	1071
1173	Alice	=	71	1070
1174	Closed	=	65	1072
1175	Day	=	62	1074
1176	Living Room	=	70	1073
1177	Closed	=	65	1075
1178	Alice	=	71	1073
1179	Living Room	=	70	1076
1180	Day	=	62	1079
1181	Off	=	1	1078
1182	Closed	=	65	1080
1183	Day	=	62	1082
1184	Living Room	=	70	1077
1185	Alice	=	71	1076
1186	Off	=	1	1081
1187	Alice	=	71	1077
1188	Off	=	1	1083
1189	Off	=	1	1085
1190	Living Room	=	70	1086
1191	Living Room	=	70	1084
1192	Alice	=	71	1086
1193	Alice	=	71	1084
1194	Off	=	1	1087
1195	On	=	1	1088
1196	On	=	1	1089
1197	Open	=	13	1090
1198	Open	=	13	1091
1199	On	=	1	1092
1200	On	=	1	1093
1201	On	=	1	1094
1202	On	=	1	1095
1203	Open	=	13	1096
1204	On	=	1	1097
1205	On	=	1	1098
1206	Open	=	13	1099
1207	Open	=	13	1100
1208	On	=	1	1101
1209	On	=	1	1102
1210	On	=	1	1103
1211	On	=	1	1104
1212	Open	=	13	1105
1213	On	=	1	1106
1214	On	=	1	1107
1215	Open	=	13	1108
1216	Open	=	13	1109
1217	On	=	1	1110
1218	On	=	1	1111
1219	On	=	1	1112
1220	On	=	1	1113
1221	Open	=	13	1114
1222	On	=	1	1115
1223	On	=	1	1116
1224	Open	=	13	1117
1225	Open	=	13	1118
1226	On	=	1	1119
1227	On	=	1	1120
1228	On	=	1	1121
1229	On	=	1	1122
1230	Open	=	13	1123
1231	On	=	1	1124
1232	On	=	1	1125
1233	Open	=	13	1126
1234	Open	=	13	1127
1235	On	=	1	1128
1236	On	=	1	1129
1237	On	=	1	1130
1238	On	=	1	1131
1239	Open	=	13	1132
1240	On	=	1	1133
1241	On	=	1	1134
1242	Open	=	13	1135
1243	Open	=	13	1136
1244	On	=	1	1137
1245	On	=	1	1138
1246	On	=	1	1139
1247	On	=	1	1140
1248	Open	=	13	1141
1249	On	=	1	1142
1250	On	=	1	1143
1251	Open	=	13	1144
1252	Open	=	13	1145
1253	On	=	1	1146
1254	On	=	1	1147
1255	On	=	1	1148
1256	On	=	1	1149
1257	Open	=	13	1150
1258	On	=	1	1151
1259	On	=	1	1152
1260	Open	=	13	1153
1261	Open	=	13	1154
1262	On	=	1	1155
1263	On	=	1	1156
1264	On	=	1	1157
1265	On	=	1	1158
1266	Open	=	13	1159
1267	On	=	1	1160
1268	On	=	1	1161
1269	Open	=	13	1162
1270	On	=	1	1163
1271	On	=	1	1164
1272	Open	=	13	1165
1273	Open	=	13	1166
1274	On	=	1	1167
1275	On	=	1	1168
1276	On	=	1	1169
1277	On	=	1	1170
1278	Open	=	13	1171
1279	Open	=	13	1172
1280	On	=	1	1173
1281	On	=	1	1174
1282	On	=	1	1175
1283	On	=	1	1176
1284	Open	=	13	1177
1285	On	=	1	1178
1286	On	=	1	1179
1287	Open	=	13	1180
1288	Open	=	13	1181
1289	On	=	1	1182
1290	On	=	1	1183
1291	On	=	1	1184
1292	On	=	1	1185
1293	Open	=	13	1186
1294	On	=	1	1187
1295	On	=	1	1188
1296	Open	=	13	1189
1297	Open	=	13	1190
1298	On	=	1	1191
1299	On	=	1	1192
1300	On	=	1	1193
1301	On	=	1	1194
1302	Open	=	13	1195
1303	On	=	1	1196
1304	On	=	1	1197
1305	Open	=	13	1198
1306	Open	=	13	1199
1307	On	=	1	1200
1308	On	=	1	1201
1309	On	=	1	1202
1310	On	=	1	1203
1311	Open	=	13	1204
1312	On	=	1	1205
1313	On	=	1	1206
1314	Open	=	13	1207
1315	Open	=	13	1208
1316	On	=	1	1209
1317	On	=	1	1210
1318	On	=	1	1211
1319	On	=	1	1212
1320	Open	=	13	1213
1321	Open	=	13	1214
1322	On	=	1	1215
1323	On	=	1	1216
1324	On	=	1	1217
1325	On	=	1	1218
1326	Open	=	13	1219
1327	On	=	1	1220
1328	On	=	1	1221
1329	Open	=	13	1222
1330	On	=	1	1223
1331	On	=	1	1224
1332	Open	=	13	1225
1333	Open	=	13	1226
1334	On	=	1	1227
1335	On	=	1	1228
1336	On	=	1	1229
1337	On	=	1	1230
1338	Open	=	13	1231
1339	On	=	1	1232
1340	On	=	1	1233
1341	Open	=	13	1234
1342	Open	=	13	1235
1343	On	=	1	1236
1344	On	=	1	1237
1345	On	=	1	1238
1346	On	=	1	1239
1347	Open	=	13	1240
1348	On	=	1	1241
1349	On	=	1	1242
1350	Open	=	13	1243
1351	Open	=	13	1244
1352	On	=	1	1245
1353	On	=	1	1246
1354	On	=	1	1247
1355	On	=	1	1248
1356	Open	=	13	1249
1357	On	=	1	1250
1358	On	=	1	1251
1359	Open	=	13	1252
1360	On	=	1	1253
1361	On	=	1	1254
1362	Open	=	13	1255
1363	Open	=	13	1256
1364	On	=	1	1257
1365	On	=	1	1258
1366	On	=	1	1259
1367	On	=	1	1260
1368	Open	=	13	1261
1369	Open	=	13	1262
1370	On	=	1	1263
1371	On	=	1	1264
1372	On	=	1	1265
1373	On	=	1	1266
1374	Open	=	13	1267
1375	On	=	1	1268
1376	On	=	1	1269
1377	Open	=	13	1270
1378	Open	=	13	1271
1379	On	=	1	1272
1380	On	=	1	1273
1381	On	=	1	1274
1382	On	=	1	1275
1383	Open	=	13	1276
1384	On	=	1	1277
1385	On	=	1	1278
1386	Open	=	13	1279
1387	Open	=	13	1280
1388	On	=	1	1281
1389	On	=	1	1282
1390	On	=	1	1283
1391	On	=	1	1284
1392	Open	=	13	1285
1393	On	=	1	1286
1394	On	=	1	1287
1395	Open	=	13	1288
1396	Open	=	13	1289
1397	On	=	1	1290
1398	On	=	1	1291
1399	On	=	1	1292
1400	On	=	1	1293
1401	Open	=	13	1294
1402	Open	=	13	1295
1403	On	=	1	1296
1404	On	=	1	1297
1405	On	=	1	1298
1406	On	=	1	1299
1407	Open	=	13	1300
1408	On	=	1	1301
1409	On	=	1	1302
1410	Open	=	13	1303
1411	On	=	1	1304
1412	On	=	1	1305
1413	Open	=	13	1306
1414	Open	=	13	1307
1415	On	=	1	1308
1416	On	=	1	1309
1417	On	=	1	1310
1418	On	=	1	1311
1419	Open	=	13	1312
1420	On	=	1	1313
1421	On	=	1	1314
1422	Open	=	13	1315
1423	Open	=	13	1316
1424	On	=	1	1317
1425	On	=	1	1318
1426	On	=	1	1319
1427	On	=	1	1320
1428	Open	=	13	1321
1429	On	=	1	1322
1430	On	=	1	1323
1431	Open	=	13	1324
1432	Open	=	13	1325
1433	On	=	1	1326
1434	On	=	1	1327
1435	On	=	1	1328
1436	On	=	1	1329
1437	Open	=	13	1330
1438	Bathroom	!=	70	1331
1439	Alice	=	71	1331
1440	5	<	18	1332
1441	75	>	18	1333
1442	Bedroom	=	70	1334
1443	Alice	=	71	1334
1444	60	<	18	1335
1445	70	<	18	1336
1446	60	<	18	1337
1447	Home	!=	70	1338
1448	Alice	=	71	1338
1449	Bathroom	!=	70	1339
1450	Alice	=	71	1339
1451	5	<	18	1340
1452	75	>	18	1341
1453	Bedroom	=	70	1342
1454	Alice	=	71	1342
1455	60	<	18	1343
1458	Home	!=	70	1346
1459	Alice	=	71	1346
1460	70	>	18	1347
1461	Open	=	13	1348
1463	Home	!=	70	1350
1464	Alice	=	71	1350
1465	70	<	18	1351
1466	60	<	18	1352
1467	Home	!=	70	1353
1468	Alice	=	71	1353
1469	75	<	18	1354
1470	On	=	64	1355
1473	5	<	18	1357
1474	75	>	18	1358
1477	60	<	18	1360
1479	Open	=	13	1362
1482	Home	!=	70	1365
1483	Alice	=	71	1365
1485	On	=	64	1367
1486	70	<	18	1368
1487	Bathroom	!=	70	1369
1488	Alice	=	71	1369
1489	5	<	18	1370
1490	75	>	18	1371
1491	Open	=	13	1372
1492	60	<	18	1373
1493	Home	!=	70	1374
1494	Alice	=	71	1374
1495	70	<	18	1375
1496	On	=	64	1376
1497	Bedroom	=	70	1377
1498	Alice	=	71	1377
1499	60	<	18	1378
1500	Open	=	13	1379
1501	Closed	=	13	1380
1502	Open	=	13	1381
1503	Open	=	13	1382
1504	Open	=	13	1383
1505	Closed	=	13	1384
1506	Open	=	13	1385
1507	Closed	=	13	1386
1508	Open	=	13	1387
1509	Closed	=	13	1388
1510	Closed	=	13	1389
1511	Closed	=	13	1390
1512	Closed	=	13	1391
1513	Closed	=	13	1392
1514	Closed	=	13	1393
1516	Closed	=	13	1395
1517	Closed	=	13	1396
1518	Open	=	13	1397
1519	Open	=	13	1398
1520	Closed	=	13	1399
1521	Open	=	13	1400
1522	Open	=	13	1401
1523	Closed	=	13	1402
1524	Open	=	13	1403
1525	Open	=	13	1404
1526	Closed	=	13	1405
1527	Closed	=	13	1406
1528	Closed	=	13	1407
1529	Closed	=	13	1408
1530	Closed	=	13	1409
1531	Closed	=	13	1410
1532	Closed	=	13	1411
1533	Open	=	13	1412
1534	Open	=	13	1413
1535	Closed	=	13	1414
1536	Open	=	13	1415
1537	Open	=	13	1416
1538	Closed	=	13	1417
1539	Open	=	13	1418
1540	Open	=	13	1419
1541	Closed	=	13	1420
1542	Closed	=	13	1421
1543	Closed	=	13	1422
1544	Closed	=	13	1423
1546	Closed	=	13	1425
1547	Open	=	13	1426
1549	Closed	=	13	1428
1550	Open	=	13	1429
1552	Open	=	13	1431
1553	Closed	=	13	1432
1554	Closed	=	13	1433
1555	Closed	=	13	1434
1556	Closed	=	13	1435
1557	Closed	=	13	1436
1558	Closed	=	13	1437
1559	Closed	=	13	1438
1560	Closed	=	13	1439
1561	Closed	=	13	1440
1562	Open	=	13	1441
1563	Open	=	13	1442
1564	Closed	=	13	1443
1565	Open	=	13	1444
1566	Open	=	13	1445
1567	Closed	=	13	1446
1568	Open	=	13	1447
1569	Open	=	13	1448
1570	Closed	=	13	1449
1571	Open	=	13	1450
1572	Closed	=	13	1451
1573	Open	=	13	1452
1574	Open	=	13	1453
1575	Open	=	13	1454
1576	Closed	=	13	1455
1577	Open	=	13	1456
1578	Closed	=	13	1457
1579	Open	=	13	1458
1580	Open	=	13	1459
1581	Open	=	13	1460
1582	Closed	=	13	1461
1583	Open	=	13	1462
1584	Open	=	13	1463
1585	Closed	=	13	1464
1586	Open	=	13	1465
1587	Open	=	13	1466
1588	Closed	=	13	1467
1589	Raining	=	20	1468
1590	Open	=	13	1469
1591	Home	!=	70	1470
1592	Alice	=	71	1470
1593	On	=	64	1471
1594	Smoke Detected	=	66	1472
1595	Home	=	70	1473
1596	Anyone	=	71	1473
1597	On	=	64	1474
1598	Home	=	70	1475
1599	Alice	=	71	1475
1601	Day	=	62	1477
1602	On	=	1	1478
1603	On	=	1	1479
1604	Raining	=	20	1480
1605	Open	=	13	1481
1606	Home	!=	70	1482
1607	Alice	=	71	1482
1608	On	=	64	1483
1610	Home	=	70	1485
1611	Alice	=	71	1485
1613	Day	=	62	1487
1615	On	=	1	1489
1618	On	=	64	1491
1620	Open	=	13	1493
1623	On	=	64	1495
1625	Home	=	70	1497
1626	Alice	=	71	1497
1628	Day	=	62	1499
1630	On	=	1	1501
1633	On	=	64	1503
1634	Raining	=	20	1504
1635	Open	=	13	1505
1636	Home	!=	70	1506
1637	Alice	=	71	1506
1638	On	=	64	1507
1640	Home	=	70	1509
1641	Alice	=	71	1509
1643	Day	=	62	1511
1645	On	=	1	1513
1648	On	=	64	1515
1649	On	=	64	1516
1650	Home	!=	70	1517
1651	Alice	=	71	1517
1652	On	=	64	1518
1653	Home	!=	70	1519
1654	Alice	=	71	1519
1655	Home	!=	70	1520
1656	Bobbie	=	71	1520
1657	On	=	1	1521
1658	On	=	1	1522
1659	Home	!=	70	1523
1660	Bobbie	=	71	1523
1661	On	=	64	1524
1662	Home	!=	70	1525
1663	Alice	=	71	1525
1664	On	=	64	1526
1665	Home	!=	70	1527
1666	Alice	=	71	1527
1667	Home	!=	70	1528
1668	Bobbie	=	71	1528
1669	On	=	1	1529
1670	On	=	1	1530
1671	Home	!=	70	1531
1672	Bobbie	=	71	1531
1673	On	=	64	1532
1676	Kitchen	!=	70	1534
1677	Alice	=	71	1534
1678	52	>	18	1535
1679	On	=	64	1536
1680	52	>	18	1537
1681	52	>	18	1538
1682	On	=	64	1539
1683	52	>	18	1540
1684	52	<	18	1541
1685	On	=	64	1542
1686	52	<	18	1543
1687	Orange	=	3	1544
1688	On	=	26	1545
1689	Orange	=	3	1546
1690	Orange	=	3	1547
1691	On	=	26	1548
1692	Orange	=	3	1549
1693	Green	=	3	1550
1694	On	=	26	1551
1695	Green	=	3	1552
1696	52	>	18	1553
1697	On	=	64	1554
1698	52	>	18	1555
1699	52	<	18	1556
1700	On	=	64	1557
1701	52	<	18	1558
1702	Raining	=	20	1559
1703	On	=	64	1560
1704	Raining	=	20	1561
1705	Not Raining	=	20	1562
1706	On	=	64	1563
1707	Not Raining	=	20	1564
1708	Home	!=	70	1565
1709	Alice	=	71	1565
1710	On	=	64	1566
1711	Home	!=	70	1567
1712	Bobbie	=	71	1567
1713	Night	=	62	1568
1714	Raining	=	20	1569
1715	Open	=	13	1570
1717	75	>	18	1572
1718	Not Raining	=	20	1573
1719	Closed	=	13	1574
1721	Raining	=	20	1576
1722	Open	=	13	1577
1724	75	>	18	1579
1726	Closed	=	13	1581
1728	Raining	=	20	1583
1729	Open	=	13	1584
1731	75	>	18	1586
1732	Raining	=	20	1587
1733	Closed	=	13	1588
1735	Closed	=	13	1590
1736	On	=	1	1591
1737	Day	=	62	1592
1738	On	=	64	1593
1739	Open	=	13	1594
1741	Day	=	62	1596
1742	On	=	64	1597
1743	Open	=	13	1598
1744	Closed	=	65	1599
1745	Day	=	62	1600
1746	Off	=	1	1601
1747	Closed	=	65	1602
1748	Night	=	62	1603
1750	Day	=	62	1605
1751	Off	=	1	1606
1752	Night	=	62	1607
1753	Open	=	65	1608
1754	Off	=	1	1609
1755	Day	=	62	1610
1758	5	<	18	1612
1761	60	<	18	1614
1763	Alice	 	79	1616
1764	Home	!=	80	1616
1767	5	<	18	1618
1770	60	<	18	1620
1772	Alice	 	79	1622
1773	Home	!=	80	1622
1776	5	<	18	1624
1778	Alice	 	79	1626
1779	Home	!=	80	1626
1782	60	<	18	1628
1783	Raining	=	20	1629
1784	Closed	=	13	1630
1785	Not Raining	=	20	1631
1786	Closed	=	13	1632
1787	Night	=	62	1633
1788	Not Raining	=	20	1634
1789	Closed	=	13	1635
1790	Raining	=	20	1636
1791	Closed	=	13	1637
1792	Kitchen	=	70	1638
1793	A Guest	=	71	1638
1794	Kitchen	!=	70	1639
1795	Alice	=	71	1639
1796	Raining	=	20	1640
1797	Open	=	13	1641
1798	Night	=	62	1642
1799	Not Raining	=	20	1643
1800	Closed	=	13	1644
1801	Raining	=	20	1645
1802	Closed	=	13	1646
1803	Orange	=	3	1647
1804	Green	=	3	1648
1805	Raining	=	20	1649
1806	Open	=	13	1650
1807	Raining	=	20	1651
1808	Open	=	13	1652
1809	Raining	=	20	1653
1810	Closed	=	13	1654
1811	On	=	64	1655
1812	Open	=	13	1656
1813	Open	=	13	1657
1814	On	=	64	1658
1816	Open	=	13	1660
1817	On	=	64	1661
1818	Open	=	13	1662
1819	70	<	18	1663
1820	On	=	64	1664
1821	Open	=	13	1665
1822	70	>	18	1666
1823	On	=	78	1667
1824	70	<	18	1668
1825	70	<	18	1669
1826	75	>	18	1670
1827	On	=	78	1671
1828	On	=	64	1672
1829	On	=	78	1673
1830	On	=	78	1674
1831	On	=	64	1675
1833	On	=	64	1677
1834	Open	=	67	1678
1835	Kitchen	=	70	1679
1836	Nobody	=	71	1679
1837	Open	=	67	1680
1838	Kitchen	=	70	1681
1839	Nobody	=	71	1681
1840	On	=	1	1682
1841	Smoke Detected	=	66	1683
1842	Smoke Detected	=	66	1684
1843	Open	=	67	1685
1844	Kitchen	!=	70	1686
1845	Alice	=	71	1686
1846	Open	=	67	1687
1847	Kitchen	!=	70	1688
1848	Alice	=	71	1688
1849	Open	=	67	1689
1850	Kitchen	!=	70	1690
1851	Alice	=	71	1690
1852	Kitchen	!=	70	1691
1853	Bobbie	=	71	1691
1854	Open	=	67	1692
1855	Kitchen	!=	70	1693
1856	Alice	=	71	1693
1857	Kitchen	!=	70	1694
1858	Bobbie	=	71	1694
1865	Closed	=	13	1701
1866	Home	=	70	1702
1867	Alice	=	71	1702
1868	 	=	66	1703
1869	Closed	=	13	1704
1870	Home	=	70	1705
1871	Alice	=	71	1705
1872	Smoke Detected	=	66	1706
1873	Smoke Detected	=	66	1707
1874	Closed	=	13	1708
1875	Home	=	70	1709
1876	Closed	=	13	1710
1877	Alice	=	71	1709
1878	Smoke Detected	=	66	1711
1879	Home	=	70	1712
1880	Alice	=	71	1712
1882	 	=	66	1714
1883	Home	=	70	1715
1884	Alice	=	71	1715
1885	Home	=	70	1716
1886	Alice	=	71	1716
1887	Closed	=	13	1717
1888	 	=	66	1718
1889	Home	=	70	1719
1890	Alice	=	71	1719
1891	Closed	=	13	1720
1892	Smoke Detected	=	66	1721
1894	Smoke Detected	=	66	1723
1895	Home	=	70	1724
1896	Alice	=	71	1724
1897	Smoke Detected	=	66	1725
1898	Closed	=	13	1726
1899	Home	=	70	1727
1900	Alice	=	71	1727
1901	Smoke Detected	=	66	1728
1902	Closed	=	13	1729
1903	Home	=	70	1730
1904	Alice	=	71	1730
1905	Home	=	70	1731
1906	Alice	=	71	1731
1907	Closed	=	13	1732
1908	Smoke Detected	=	66	1733
1909	Open	=	13	1734
1910	Raining	=	20	1735
1911	Home	=	70	1736
1912	Alice	=	71	1736
1913	Night	=	62	1737
1914	Off	=	1	1738
1915	Home	=	70	1739
1916	Alice	=	71	1739
1917	Night	=	62	1740
1918	Off	=	1	1741
1919	On	=	1	1742
1920	Home	=	70	1743
1921	Alice	=	71	1743
1922	Night	=	62	1744
1923	Off	=	1	1745
1924	On	=	1	1746
1925	Home	=	70	1747
1926	Alice	=	71	1747
1927	Night	=	62	1748
1928	Off	=	1	1749
1929	Raining	=	20	1750
1930	Home	=	70	1751
1931	Alice	=	71	1751
1932	Night	=	62	1752
1933	Raining	=	20	1753
1935	On	=	1	1755
1936	Home	=	70	1756
1937	Alice	=	71	1756
1938	Night	=	62	1757
1939	Off	=	1	1758
1940	Home	=	70	1759
1941	Alice	=	71	1759
1942	Night	=	62	1760
1943	Off	=	1	1761
1944	On	=	1	1762
1945	On	=	1	1763
1946	Home	=	70	1764
1947	Alice	=	71	1764
1948	Off	=	1	1765
1949	Night	=	62	1766
1952	Day	=	62	1768
1953	On	=	1	1769
1954	Home	=	70	1770
1955	Alice	=	71	1770
1956	Night	=	62	1771
1957	Off	=	1	1772
1958	On	=	1	1773
1959	Home	=	70	1774
1960	Alice	=	71	1774
1961	Night	=	62	1775
1962	On	=	1	1776
1963	On	=	1	1777
1964	Home	=	70	1778
1965	Night	=	62	1780
1966	Off	=	1	1779
1967	Alice	=	71	1778
1968	Home	=	70	1781
1969	Night	=	62	1783
1970	Home	=	70	1782
1971	Alice	=	71	1781
1972	Alice	=	71	1782
1973	Off	=	1	1784
1974	Off	=	1	1785
1975	Night	=	62	1786
1976	On	=	1	1787
1977	Off	=	1	1788
1978	Home	=	70	1789
1979	Alice	=	71	1789
1980	On	=	1	1790
1981	Home	=	70	1791
1982	Alice	=	71	1791
1983	Night	=	62	1792
1984	Night	=	62	1793
1985	Off	=	1	1794
1986	Night	=	62	1795
1987	On	=	1	1796
1988	Home	=	70	1797
1989	Alice	=	71	1797
1990	On	=	1	1798
1991	Off	=	1	1799
1992	Home	=	70	1800
1993	Alice	=	71	1800
1994	Night	=	62	1801
1995	Night	=	62	1802
1996	Home	=	70	1803
1997	Alice	=	71	1803
1998	Off	=	1	1804
1999	Night	=	62	1805
2000	Home	=	70	1806
2001	Alice	=	71	1806
2002	Home	=	70	1807
2003	Alice	=	71	1807
2004	Off	=	1	1808
2005	On	=	1	1809
2006	On	=	1	1810
2007	Kitchen	!=	70	1811
2008	Alice	=	71	1811
2009	 	=	72	1812
2010	Raining	=	20	1813
2011	Open	=	13	1814
2012	Raining	=	20	1815
2013	Open	=	13	1816
2014	Raining	=	20	1817
2015	Open	=	13	1818
2016	Raining	=	20	1819
2017	Open	=	13	1820
2018	Raining	=	20	1821
2019	Open	=	13	1822
2020	Raining	=	20	1823
2021	Open	=	13	1824
2022	Raining	=	20	1825
2023	Open	=	13	1826
2024	Raining	=	20	1827
2025	Open	=	13	1828
2026	Raining	=	20	1829
2027	Open	=	13	1830
2028	Bathroom	!=	70	1831
2029	Alice	=	71	1831
2030	 	=	72	1832
2031	On	=	26	1833
2032	Asleep	=	68	1834
2033	Locked	=	12	1835
2034	Unlocked	=	12	1836
2035	Off	=	26	1837
2036	Asleep	=	68	1838
2037	On	=	26	1839
2038	Awake	=	68	1840
2039	Off	=	26	1841
2040	Asleep	=	68	1842
2041	Unlocked	=	12	1843
2042	Unlocked	=	12	1844
2043	Asleep	=	68	1845
2044	Unlocked	=	12	1846
2045	Awake	=	68	1847
2046	Bathroom	!=	70	1848
2047	Alice	=	71	1848
2048	 	=	72	1849
2049	Bathroom	!=	70	1850
2050	Alice	=	71	1850
2051	 	=	72	1851
2052	Home	=	70	1852
2053	Alice	=	71	1852
2054	Night	=	62	1853
2055	Off	=	1	1854
2056	Home	=	70	1855
2057	Alice	=	71	1855
2058	Off	=	1	1856
2059	Home	=	70	1857
2060	Alice	=	71	1857
2061	Off	=	1	1858
2062	On	=	1	1859
2063	On	=	1	1860
2064	Home	=	70	1861
2065	Alice	=	71	1861
2066	Night	=	62	1862
2067	Off	=	1	1863
2068	On	=	1	1864
2069	On	=	1	1865
2070	Raining	=	20	1866
2071	On	=	1	1867
2072	On	=	1	1868
2073	Home	=	70	1869
2074	Alice	=	71	1869
2075	Off	=	1	1870
2076	Off	=	1	1871
2077	On	=	1	1872
2078	On	=	1	1873
2079	Home	=	70	1874
2080	Alice	=	71	1874
2081	Night	=	62	1875
2082	Off	=	1	1876
2083	On	=	1	1877
2084	On	=	1	1878
2085	Home	=	70	1879
2086	Alice	=	71	1879
2087	Off	=	1	1880
2088	Off	=	1	1881
2089	On	=	1	1882
2090	On	=	1	1883
2091	Closed	=	13	1884
2092	Closed	=	13	1885
2093	Closed	=	13	1886
2094	Open	=	13	1887
2095	Open	=	13	1888
2096	Closed	=	13	1889
2097	Open	=	13	1890
2098	Open	=	13	1891
2099	Open	=	13	1892
2100	Closed	=	13	1893
2101	Open	=	13	1894
2102	Open	=	13	1895
2103	Open	=	13	1896
2104	Open	=	13	1897
2105	Closed	=	13	1898
2106	Closed	=	13	1899
2107	Closed	=	13	1900
2108	Closed	=	13	1901
2113	On	=	64	1906
2114	On	=	1	1907
2115	On	=	64	1908
2116	On	=	1	1909
2117	On	=	64	1910
2118	On	=	1	1911
2119	On	=	1	1913
2120	On	=	1	1912
2121	On	=	64	1914
2122	On	=	64	1915
2123	On	=	1	1916
2124	On	=	64	1917
2125	On	=	64	1918
2126	On	=	1	1919
2127	On	=	64	1920
2128	On	=	1	1921
2129	On	=	1	1922
2130	On	=	64	1923
2131	On	=	64	1924
2132	On	=	78	1925
2133	On	=	64	1927
2134	On	=	78	1926
2135	On	=	64	1928
2136	On	=	78	1929
2137	On	=	78	1930
2138	On	=	64	1931
2139	On	=	78	1932
2140	On	=	64	1933
2141	On	=	64	1934
2142	On	=	78	1935
2143	On	=	64	1936
2144	On	=	78	1937
2145	On	=	78	1938
2146	On	=	64	1939
2147	On	=	78	1940
2148	On	=	64	1941
2149	On	=	64	1942
2150	On	=	1	1943
2151	On	=	1	1944
2152	On	=	1	1945
2153	On	=	1	1946
2154	On	=	1	1947
2155	On	=	64	1948
2156	On	=	1	1949
2157	On	=	1	1950
2158	On	=	1	1951
2159	On	=	1	1952
2160	On	=	1	1953
2161	On	=	1	1954
2162	On	=	64	1955
2163	On	=	1	1956
2164	On	=	1	1957
2165	On	=	1	1958
2166	On	=	1	1959
2167	On	=	1	1960
2168	On	=	64	1961
2169	On	=	1	1962
2170	On	=	1	1963
2171	On	=	1	1964
2172	On	=	1	1965
2173	On	=	1	1966
2174	On	=	64	1967
2175	On	=	1	1968
2176	On	=	1	1969
2177	On	=	1	1970
2178	On	=	1	1971
2179	On	=	1	1972
2180	On	=	64	1973
2181	On	=	1	1974
2182	On	=	1	1975
2183	On	=	1	1976
2184	On	=	1	1977
2185	On	=	1	1978
2186	On	=	64	1979
2187	On	=	1	1980
2188	On	=	1	1981
2189	On	=	1	1982
2190	On	=	1	1983
2191	On	=	1	1984
2192	On	=	1	1985
2193	On	=	1	1986
2194	On	=	1	1987
2195	On	=	64	1988
2196	On	=	1	1989
2197	On	=	1	1990
2198	On	=	1	1991
2199	On	=	64	1992
2200	On	=	1	1993
2201	On	=	1	1994
2202	On	=	64	1995
2203	On	=	1	1996
2204	On	=	1	1997
2205	On	=	1	1998
2206	On	=	1	1999
2207	On	=	1	2000
2208	On	=	1	2001
2209	On	=	1	2002
2210	On	=	1	2003
2211	On	=	1	2004
2212	On	=	64	2005
2213	On	=	1	2006
2214	On	=	1	2007
2215	On	=	1	2008
2216	On	=	1	2009
2217	On	=	1	2010
2218	On	=	1	2011
2219	On	=	1	2012
2220	On	=	1	2013
2221	On	=	1	2014
2222	On	=	1	2015
2223	On	=	64	2016
2224	On	=	1	2017
2225	On	=	1	2018
2226	On	=	1	2019
2227	On	=	64	2020
2228	On	=	1	2021
2229	On	=	64	2022
2230	On	=	1	2023
2231	On	=	1	2024
2232	On	=	1	2025
2233	On	=	1	2026
2234	On	=	1	2027
2235	On	=	1	2028
2236	On	=	1	2029
2237	Off	=	1	2030
2238	On	=	64	2031
2239	On	=	1	2032
2240	On	=	1	2033
2241	On	=	1	2034
2242	On	=	64	2035
2243	On	=	1	2036
2244	Off	=	64	2037
2245	On	=	1	2038
2246	On	=	1	2039
2247	On	=	1	2040
2248	On	=	1	2041
2249	On	=	1	2042
2250	On	=	1	2043
2251	On	=	1	2044
2252	On	=	1	2045
2253	On	=	1	2046
2254	On	=	1	2047
2255	On	=	1	2048
2256	On	=	1	2049
2257	On	=	1	2050
2258	On	=	1	2051
2259	On	=	1	2052
2260	On	=	1	2053
2261	On	=	1	2054
2262	Day	=	62	2055
2263	On	=	64	2056
2264	Off	=	1	2057
2265	On	=	1	2058
2266	On	=	1	2059
2267	On	=	1	2060
2268	On	=	1	2061
2269	On	=	1	2062
2270	Night	=	62	2063
2271	On	=	64	2064
2272	Off	=	1	2065
2273	On	=	1	2066
2274	On	=	1	2067
2275	On	=	1	2068
2276	On	=	1	2069
2277	On	=	1	2070
2278	Day	=	62	2071
2279	On	=	64	2072
2280	On	=	1	2073
2281	Off	=	1	2074
2282	On	=	1	2075
2283	On	=	1	2076
2284	On	=	1	2077
2285	On	=	1	2078
2286	Night	=	62	2079
2287	On	=	64	2080
2288	On	=	1	2081
2289	Off	=	1	2082
2290	On	=	1	2083
2291	On	=	1	2084
2292	On	=	1	2085
2293	On	=	1	2086
2294	Home	=	70	2087
2295	Alice	=	71	2087
2296	On	=	64	2088
2297	On	=	1	2089
2298	On	=	1	2090
2299	Off	=	1	2091
2300	On	=	1	2092
2301	On	=	1	2093
2302	On	=	1	2094
2303	Home	!=	70	2095
2304	Alice	=	71	2095
2305	On	=	64	2096
2306	On	=	1	2097
2307	On	=	1	2098
2308	Off	=	1	2099
2309	On	=	1	2100
2310	On	=	1	2101
2311	On	=	1	2102
2312	Home	=	70	2103
2313	Alice	=	71	2103
2314	On	=	64	2104
2315	On	=	1	2105
2316	On	=	1	2106
2317	On	=	1	2107
2318	Off	=	1	2108
2319	On	=	1	2109
2320	On	=	1	2110
2321	Home	!=	70	2111
2322	Alice	=	71	2111
2323	On	=	64	2112
2324	On	=	1	2113
2325	On	=	1	2114
2326	Off	=	1	2115
2327	On	=	1	2116
2328	On	=	1	2117
2329	On	=	1	2118
2330	Home	=	70	2119
2331	Alice	=	71	2119
2332	On	=	64	2120
2333	On	=	1	2121
2334	On	=	1	2122
2335	On	=	1	2123
2336	On	=	1	2124
2337	On	=	1	2125
2338	On	=	1	2126
2339	Home	!=	70	2127
2340	Alice	=	71	2127
2341	On	=	64	2128
2342	On	=	1	2129
2343	On	=	1	2130
2344	On	=	1	2131
2345	On	=	1	2132
2346	On	=	1	2133
2347	On	=	64	2134
2348	On	=	64	2135
2349	On	=	1	2136
2350	On	=	1	2137
2351	On	=	1	2138
2352	On	=	1	2139
2353	On	=	1	2140
2354	On	=	1	2141
2355	On	=	1	2142
2356	On	=	1	2143
2357	On	=	1	2144
2358	On	=	1	2145
2359	On	=	64	2146
2360	Day	=	62	2147
2361	Off	=	64	2148
2362	On	=	1	2149
2363	On	=	1	2150
2364	On	=	1	2151
2365	On	=	1	2152
2366	On	=	1	2153
2367	On	=	64	2154
2368	Night	=	62	2155
2369	Off	=	64	2156
2370	On	=	1	2157
2371	On	=	1	2158
2372	On	=	1	2159
2373	On	=	1	2160
2374	On	=	1	2161
2375	On	=	1	2162
2376	Day	=	62	2163
2377	On	=	64	2164
2378	Off	=	1	2165
2379	On	=	1	2166
2380	On	=	1	2167
2381	On	=	1	2168
2382	On	=	1	2169
2383	On	=	1	2170
2384	Night	=	62	2171
2385	On	=	64	2172
2386	Off	=	1	2173
2387	On	=	1	2174
2388	On	=	1	2175
2389	On	=	1	2176
2390	On	=	1	2177
2391	On	=	1	2178
2392	Day	=	62	2179
2393	On	=	64	2180
2394	On	=	1	2181
2395	Off	=	1	2182
2396	On	=	1	2183
2397	On	=	1	2184
2398	On	=	1	2185
2399	On	=	1	2186
2400	Night	=	62	2187
2401	On	=	64	2188
2402	On	=	1	2189
2403	Off	=	1	2190
2404	On	=	1	2191
2405	On	=	1	2192
2406	On	=	1	2193
2407	On	=	1	2194
2408	Home	=	70	2195
2409	Alice	=	71	2195
2410	On	=	64	2196
2411	On	=	1	2197
2412	On	=	1	2198
2413	Off	=	1	2199
2414	On	=	1	2200
2415	On	=	1	2201
2416	On	=	1	2202
2417	Home	!=	70	2203
2418	Alice	=	71	2203
2419	On	=	64	2204
2420	On	=	1	2205
2421	On	=	1	2206
2422	Off	=	1	2207
2423	On	=	1	2208
2424	On	=	1	2209
2425	On	=	1	2210
2426	Home	=	70	2211
2427	Alice	=	71	2211
2428	On	=	64	2212
2429	On	=	1	2213
2430	On	=	1	2214
2431	On	=	1	2215
2432	Off	=	1	2216
2433	On	=	1	2217
2434	On	=	1	2218
2435	Home	!=	70	2219
2436	Alice	=	71	2219
2437	On	=	64	2220
2438	On	=	1	2221
2439	On	=	1	2222
2440	Off	=	1	2223
2441	On	=	1	2224
2442	On	=	1	2225
2443	On	=	1	2226
2444	Home	=	70	2227
2445	Alice	=	71	2227
2446	On	=	64	2228
2447	On	=	1	2229
2448	On	=	1	2230
2449	On	=	1	2231
2450	On	=	1	2232
2451	Off	=	1	2233
2452	On	=	1	2234
2453	Home	!=	70	2235
2454	Alice	=	71	2235
2455	On	=	64	2236
2456	On	=	1	2237
2457	On	=	1	2238
2458	On	=	1	2239
2459	On	=	1	2240
2460	Off	=	1	2241
2461	On	=	1	2242
2462	Home	=	70	2243
2463	Alice	=	71	2243
2464	On	=	64	2244
2465	On	=	1	2245
2466	On	=	1	2246
2467	On	=	1	2247
2468	On	=	1	2248
2469	Off	=	1	2249
2470	On	=	1	2250
2471	Home	!=	70	2251
2472	Alice	=	71	2251
2473	On	=	64	2252
2474	On	=	1	2253
2475	On	=	1	2254
2476	On	=	1	2255
2477	On	=	1	2256
2478	Off	=	1	2257
2479	On	=	64	2258
2480	On	=	64	2259
2481	On	=	1	2260
2482	On	=	1	2261
2483	On	=	1	2262
2484	On	=	1	2263
2485	On	=	1	2264
2486	On	=	1	2265
2487	On	=	1	2266
2488	On	=	1	2267
2489	On	=	1	2268
2490	On	=	1	2269
2491	On	=	64	2270
2492	Home	=	70	2271
2493	Alice	=	71	2271
2494	Off	=	64	2272
2495	On	=	1	2273
2496	On	=	1	2274
2497	On	=	1	2275
2498	On	=	1	2276
2499	On	=	1	2277
2500	On	=	64	2278
2501	Home	!=	70	2279
2502	Alice	=	71	2279
2503	Off	=	64	2280
2504	On	=	1	2281
2505	On	=	1	2282
2506	On	=	1	2283
2507	On	=	1	2284
2508	On	=	1	2285
2509	On	=	1	2286
2510	Home	=	70	2287
2511	Alice	=	71	2287
2512	On	=	64	2288
2513	Off	=	1	2289
2514	On	=	1	2290
2515	On	=	1	2291
2516	On	=	1	2292
2517	On	=	1	2293
2518	On	=	1	2294
2519	Home	!=	70	2295
2520	Alice	=	71	2295
2521	On	=	64	2296
2522	Off	=	1	2297
2523	On	=	1	2298
2524	On	=	1	2299
2525	On	=	1	2300
2526	On	=	1	2301
2527	On	=	1	2302
2528	Home	=	70	2303
2529	Alice	=	71	2303
2530	On	=	64	2304
2531	On	=	1	2305
2532	Off	=	1	2306
2533	On	=	1	2307
2534	On	=	1	2308
2535	On	=	1	2309
2536	On	=	1	2310
2537	Home	!=	70	2311
2538	Alice	=	71	2311
2539	On	=	64	2312
2540	On	=	1	2313
2541	Off	=	1	2314
2542	On	=	1	2315
2543	On	=	1	2316
2544	On	=	1	2317
2545	On	=	1	2318
2546	Day	=	62	2319
2547	On	=	64	2320
2548	On	=	1	2321
2549	On	=	1	2322
2550	Off	=	1	2323
2551	On	=	1	2324
2552	On	=	1	2325
2553	On	=	1	2326
2554	Night	=	62	2327
2555	On	=	64	2328
2556	On	=	1	2329
2557	On	=	1	2330
2558	Off	=	1	2331
2559	On	=	1	2332
2560	On	=	1	2333
2561	On	=	1	2334
2562	Day	=	62	2335
2563	On	=	64	2336
2564	On	=	1	2337
2565	On	=	1	2338
2566	On	=	1	2339
2567	Off	=	1	2340
2568	On	=	1	2341
2569	On	=	1	2342
2570	Night	=	62	2343
2571	On	=	64	2344
2572	On	=	1	2345
2573	On	=	1	2346
2574	On	=	1	2347
2575	Off	=	1	2348
2576	Off	=	1	2349
2577	On	=	1	2350
2578	Day	=	62	2351
2579	On	=	64	2352
2580	On	=	1	2353
2581	On	=	1	2354
2582	On	=	1	2355
2583	On	=	1	2356
2584	Off	=	1	2357
2585	On	=	1	2358
2586	Night	=	62	2359
2587	On	=	64	2360
2588	On	=	1	2361
2589	On	=	1	2362
2590	On	=	1	2363
2591	On	=	1	2364
2592	Off	=	1	2365
2593	On	=	1	2366
2594	Night	=	62	2367
2595	On	=	64	2368
2596	On	=	1	2369
2597	On	=	1	2370
2598	On	=	1	2371
2599	Off	=	1	2372
2600	Off	=	1	2373
2601	On	=	1	2374
2602	Night	=	62	2375
2603	On	=	64	2376
2604	On	=	1	2377
2605	On	=	1	2378
2606	On	=	1	2379
2607	Off	=	1	2380
2608	On	=	1	2381
\.


--
-- Name: backend_condition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_condition_id_seq', 2608, true);


--
-- Data for Name: backend_device; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_device (id, public, name, icon, owner_id) FROM stdin;
7	t	Speakers	speaker	1
5	t	Smart TV	tv	1
21	t	FitBit	watch	1
9	t	Coffee Pot	local_cafe	1
10	t	Security Camera	videocam	1
11	t	Device Tracker	history	1
6	t	Smart Plug	power	1
1	t	Roomba	room_service	1
18	t	Weather Sensor	wb_cloudy	1
19	t	Smoke Detector	disc_full	1
3	t	Amazon Echo	assistant	1
17	t	Clock	access_alarm	1
22	t	Smart Faucet	waves	1
4	t	HUE Lights	highlight	1
23	t	Smart Oven	\N	1
24	t	Bathroom Window	\N	1
25	t	Living Room Window	\N	1
14	t	Bedroom Window	crop_original	1
13	t	Front Door Lock	lock	1
20	f	Power Main	power	1
8	t	Smart Refrigerator	kitchen	1
27	t	Brightness Sensor	brightness_high	1
2	t	Thermostat	brightness_medium	1
12	t	Location Sensor	pin_drop	1
28	t	Location Sensor Set	pin_drop	1
\.


--
-- Data for Name: backend_device_caps; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_device_caps (id, device_id, capability_id) FROM stdin;
7	1	2
8	2	19
9	2	21
10	3	32
11	3	33
13	3	35
14	3	8
15	3	9
16	3	12
23	3	30
24	3	31
26	4	2
27	4	3
28	4	6
29	5	8
30	5	2
31	5	36
32	5	37
33	6	2
34	7	8
35	7	9
36	7	2
37	7	35
38	7	12
39	8	33
41	9	2
42	9	38
43	9	39
44	10	28
45	10	29
46	10	15
47	10	40
52	11	49
53	11	50
54	11	51
55	11	52
57	13	13
58	14	13
59	14	14
60	17	25
61	17	26
62	17	27
63	17	55
64	3	56
65	7	56
66	10	2
67	18	18
68	18	19
69	18	20
70	2	57
71	14	58
72	19	59
73	20	2
74	8	60
75	21	61
76	21	62
77	12	63
78	22	64
79	23	2
80	23	60
81	23	65
82	8	19
83	8	66
84	24	58
85	24	14
86	25	58
87	25	14
88	23	13
1	8	13
3	27	68
4	2	69
6	28	70
\.


--
-- Name: backend_device_caps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_device_caps_id_seq', 6, true);


--
-- Data for Name: backend_device_chans; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_device_chans (id, device_id, channel_id) FROM stdin;
1	1	1
2	2	8
3	3	1
4	3	3
5	3	6
6	3	7
7	3	8
8	3	9
9	3	11
10	3	13
11	4	1
12	4	2
13	5	1
14	5	12
15	6	1
16	7	1
17	7	3
18	8	13
19	8	11
20	9	13
21	10	4
22	10	1
23	10	10
24	10	6
25	12	6
26	13	4
27	14	4
28	14	5
29	11	14
30	17	9
31	9	1
32	12	15
33	18	8
34	18	6
35	18	7
36	19	6
37	20	1
38	21	16
39	21	6
40	22	17
41	22	13
42	23	13
43	1	18
44	24	5
45	25	5
46	13	5
49	27	2
50	27	6
51	28	6
52	28	15
\.


--
-- Name: backend_device_chans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_device_chans_id_seq', 52, true);


--
-- Name: backend_device_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_device_id_seq', 28, true);


--
-- Data for Name: backend_durationparam; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_durationparam (parameter_ptr_id, comp, maxhours, maxmins, maxsecs) FROM stdin;
51	f	23	59	59
53	f	23	59	59
56	t	23	59	59
58	t	23	59	59
\.


--
-- Data for Name: backend_esrule; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_esrule (rule_ptr_id, "Etrigger_id", action_id) FROM stdin;
1	1	1
2	3	2
3	5	3
4	7	4
5	9	5
6	11	6
7	13	7
8	15	8
9	18	9
10	20	10
11	23	11
12	26	12
13	29	13
53	140	60
54	143	61
55	146	62
56	149	63
57	152	64
58	155	65
59	158	66
60	161	67
62	167	69
63	170	70
64	173	71
61	194	78
71	197	79
72	200	80
73	203	81
74	206	82
75	209	83
76	212	84
77	215	85
78	218	86
79	221	87
80	224	88
81	227	89
82	230	90
83	233	91
84	236	92
85	260	100
87	265	102
88	268	103
86	271	104
92	291	105
93	292	106
94	297	107
95	298	108
96	303	109
97	305	110
98	304	111
99	306	112
100	310	113
101	318	114
102	319	115
103	320	116
104	321	117
105	326	118
106	333	119
107	334	120
108	335	121
109	336	122
110	340	123
111	348	124
112	349	125
113	350	126
114	351	127
115	352	128
116	363	129
117	364	130
118	365	131
119	366	132
120	370	133
121	378	134
122	379	135
123	380	136
124	381	137
125	386	138
126	393	139
127	394	140
128	396	141
129	397	142
130	398	143
131	408	144
132	409	145
133	410	146
135	411	148
134	413	147
136	423	149
138	425	151
137	424	150
140	427	152
139	426	153
141	438	154
142	439	155
143	440	156
144	442	157
145	444	158
146	443	159
148	456	161
147	457	160
149	458	162
150	459	163
151	464	164
152	463	165
153	474	166
154	475	167
155	477	168
156	478	169
157	480	170
158	482	171
159	492	172
160	493	173
161	496	175
162	495	174
163	498	176
164	499	177
165	510	178
166	511	179
167	513	180
168	516	181
169	517	182
170	520	183
171	528	184
172	529	185
174	540	189
175	541	188
173	539	186
176	543	187
177	542	190
178	548	191
179	549	192
180	551	193
181	550	195
182	553	194
209	620	223
210	622	224
211	624	225
212	626	226
213	628	227
214	630	228
215	632	229
216	635	230
217	638	231
218	640	232
219	643	233
221	646	235
223	652	237
224	654	238
225	657	239
234	677	248
235	679	249
236	682	250
237	685	251
238	687	252
239	690	253
240	693	254
241	694	255
242	696	256
243	698	257
244	700	258
245	703	259
246	706	260
247	709	261
248	710	262
249	712	263
250	715	264
251	717	265
252	720	266
253	723	267
254	725	268
255	728	269
256	730	270
257	733	271
258	735	272
259	738	273
260	739	274
261	741	275
263	747	277
264	749	278
265	752	279
267	756	281
266	1836	693
276	777	290
277	778	291
280	784	294
281	785	295
283	790	297
284	791	298
285	792	299
286	794	300
287	796	301
288	798	302
289	801	303
290	803	304
291	805	305
301	833	317
302	832	319
303	834	318
304	844	320
305	846	321
306	845	322
307	856	323
308	857	324
309	858	325
310	868	326
311	869	327
312	870	328
313	880	329
314	881	330
315	882	331
316	892	332
317	893	333
318	894	334
319	904	335
320	905	336
321	907	337
322	916	338
323	917	339
324	918	340
325	928	341
326	929	342
327	930	343
328	937	344
329	938	345
330	940	346
331	950	347
332	951	348
333	957	349
334	960	350
335	962	351
336	964	352
337	975	353
338	977	354
339	979	355
340	986	356
341	985	357
342	991	358
343	996	359
344	999	360
345	1006	361
346	1008	362
347	1010	363
348	1016	364
349	1021	365
350	1023	366
351	1032	367
352	1034	368
353	1033	369
354	1035	370
355	1037	371
356	1041	372
357	1043	373
358	1060	374
360	1062	376
359	1061	375
361	1064	377
362	1063	378
363	1066	379
364	1069	380
365	1088	381
366	1091	382
367	1094	383
368	1097	384
369	1100	385
370	1103	386
371	1106	387
372	1109	388
373	1112	389
374	1115	390
375	1118	391
376	1121	392
377	1124	393
378	1127	394
379	1130	395
380	1133	396
381	1136	397
382	1139	398
383	1142	399
384	1145	400
385	1148	401
386	1151	402
387	1154	403
388	1157	404
389	1160	405
390	1163	406
391	1166	407
392	1169	408
393	1172	409
394	1175	410
395	1178	411
396	1181	412
397	1184	413
398	1187	414
399	1190	415
400	1193	416
401	1196	417
402	1199	418
403	1202	419
404	1205	420
405	1208	421
406	1211	422
407	1214	423
408	1217	424
409	1220	425
410	1223	426
411	1226	427
412	1229	428
413	1232	429
414	1235	430
415	1238	431
416	1241	432
417	1244	433
418	1247	434
419	1250	435
420	1253	436
421	1256	437
422	1259	438
423	1262	439
424	1265	440
425	1268	441
426	1271	442
427	1274	443
428	1277	444
429	1280	445
430	1283	446
431	1286	447
432	1289	448
433	1292	449
434	1295	450
435	1298	451
436	1301	452
437	1304	453
438	1307	454
439	1310	455
440	1313	456
441	1316	457
442	1319	458
443	1322	459
444	1325	460
445	1328	461
447	1333	463
452	1341	468
460	1354	476
462	1358	478
472	1375	488
456	1666	625
458	1668	626
468	1669	627
470	1670	628
474	1379	490
475	1382	491
476	1385	492
477	1388	493
478	1391	494
480	1397	496
481	1400	497
482	1403	498
483	1406	499
484	1409	500
485	1412	501
486	1415	502
487	1418	503
492	1433	508
493	1436	509
494	1439	510
488	1899	721
498	1450	514
499	1453	515
500	1456	516
495	1459	517
496	1462	518
497	1465	519
501	1468	520
502	1470	521
505	1478	525
506	1480	526
507	1482	527
518	1504	538
504	1516	544
524	1518	545
525	1521	546
526	1523	547
527	1526	548
528	1529	549
529	1531	550
531	1535	552
532	1536	553
533	1541	556
534	1542	557
536	1545	559
538	1551	563
539	1559	568
540	1560	569
541	1562	570
542	1563	571
519	1565	572
192	1568	573
543	1591	586
544	1593	587
546	1597	589
278	1599	590
279	1601	591
548	1606	593
549	1609	594
551	1633	606
535	1647	614
537	1648	615
449	1663	623
558	1672	629
559	1674	630
552	1815	683
553	1817	684
193	1819	685
196	1821	686
550	1823	687
805	1682	634
806	1683	635
807	1684	636
804	1689	639
803	1692	640
812	1716	645
810	1725	648
813	1728	649
809	1731	650
814	1734	651
815	1736	652
816	1739	653
817	1742	654
820	1747	657
821	1750	658
822	1753	660
824	1756	662
826	1762	664
827	1764	665
819	1859	703
829	1879	712
1068	1779	668
1069	1780	669
1070	1778	670
1072	1788	672
1074	1795	674
1073	1869	708
1076	1800	676
1077	1802	677
1078	1804	678
1080	1809	680
186	1813	682
262	1833	692
2295	1839	694
2296	1841	695
2543	1844	696
2544	1846	697
554	1850	699
1079	1852	700
825	1855	701
818	1857	702
4272	1861	704
4273	1864	705
4274	1866	706
1071	1867	707
1075	1872	709
4523	1874	710
4524	1877	711
4525	1882	713
4801	1884	714
4802	1888	716
4803	1892	718
4804	1896	720
5081	1910	724
5080	1908	722
5082	1909	723
5083	1911	725
5084	1916	726
5085	1917	727
5086	1918	728
5087	1919	729
5088	1926	730
5089	1927	731
5090	1928	732
5091	1929	733
5092	1934	734
5093	1935	735
5094	1936	736
5095	1937	737
5096	1948	744
5097	1954	745
5098	1960	746
5099	1966	747
5100	1972	748
5101	1978	749
5102	1990	756
5103	1999	757
5104	2007	758
5105	2013	759
5107	2028	761
5708	1468	520
5709	1470	521
5710	1478	525
5711	1480	526
5712	1482	527
5713	1504	538
5714	1516	544
5715	1518	545
5716	1521	546
5717	1523	547
5718	1526	548
5719	1529	549
5720	1531	550
5721	1565	572
5722	1779	668
5723	1780	669
5724	1778	670
5725	1867	707
5726	1788	672
5727	1869	708
5728	1795	674
5729	1872	709
5730	1800	676
5731	1802	677
5732	1804	678
5733	1736	652
5734	1739	653
5735	1742	654
5736	777	290
5737	778	291
5738	784	294
5739	785	295
5740	790	297
5741	791	298
5742	792	299
5743	794	300
5744	796	301
5745	798	302
5746	801	303
5747	803	304
5748	805	305
5749	1599	590
5750	1601	591
5751	1606	593
5752	1609	594
5753	1764	665
5754	1879	712
5755	1882	713
5756	1877	711
5757	1874	710
5758	1747	657
5759	1750	658
5760	1753	660
5761	1859	703
5762	1857	702
5763	1861	704
5764	1864	705
5765	1866	706
5766	1948	744
5767	1954	745
5768	1960	746
5769	1966	747
5770	1972	748
5771	1978	749
5772	1990	756
5773	1999	757
5774	2007	758
5775	2013	759
5776	2020	760
5777	2028	761
5778	1756	662
5779	1855	701
5780	1762	664
5781	1852	700
5782	1809	680
5783	1908	722
5784	1910	724
5785	1909	723
5786	1911	725
5787	1916	726
5788	1917	727
5789	1918	728
5790	1919	729
5791	1926	730
5792	1927	731
5793	1928	732
5794	1929	733
5795	1934	734
5796	1935	735
5797	1936	736
5798	1937	737
5799	1568	573
5800	1821	686
5801	1823	687
5802	1633	606
5803	1815	683
5804	1817	684
5805	1850	699
5806	1819	685
5807	1813	682
5808	1388	493
5809	1391	494
5810	1397	496
5811	1400	497
5812	1403	498
5813	1406	499
5814	1409	500
5815	1412	501
5816	1415	502
5817	1418	503
5818	1899	721
5819	1433	508
5820	1436	509
5821	1439	510
5822	1450	514
5823	1453	515
5824	1456	516
5825	1459	517
5826	1462	518
5827	1465	519
5828	1884	714
5829	1888	716
5830	1892	718
5831	1896	720
5832	1333	463
5833	1341	468
5834	1354	476
5835	1358	478
5836	1375	488
5837	1666	625
5838	1668	626
5839	1670	628
5840	1663	623
5841	1669	627
5842	1672	629
5843	1674	630
5844	833	317
5845	832	319
5846	834	318
5847	844	320
5848	846	321
5849	845	322
5850	856	323
5851	857	324
5852	858	325
5853	868	326
5854	869	327
5855	870	328
5856	880	329
5857	881	330
5858	882	331
5859	892	332
5860	893	333
5861	894	334
5862	904	335
5863	905	336
5864	907	337
5865	916	338
5866	917	339
5867	918	340
5868	928	341
5869	929	342
5870	930	343
5871	937	344
5872	938	345
5873	940	346
5874	950	347
5875	951	348
5876	957	349
5877	960	350
5878	962	351
5879	964	352
5880	975	353
5881	977	354
5882	979	355
5883	986	356
5884	985	357
5885	991	358
5886	996	359
5887	999	360
5888	1006	361
5889	1008	362
5890	1010	363
5891	1016	364
5892	1021	365
5893	1023	366
5894	1032	367
5895	1034	368
5896	1033	369
5897	1035	370
5898	1037	371
5899	1041	372
5900	1043	373
5901	1060	374
5902	1061	375
5903	1062	376
5904	1064	377
5905	1063	378
5906	1066	379
5907	1069	380
5908	715	264
5909	717	265
5910	720	266
5911	723	267
5912	725	268
5913	728	269
5914	730	270
5915	733	271
5916	735	272
5917	738	273
5918	739	274
5919	741	275
5920	1833	692
5921	747	277
5922	749	278
5923	752	279
5924	1836	693
5925	756	281
5926	1841	695
5927	1839	694
5928	1846	697
5929	1844	696
5930	1088	381
5931	1091	382
5932	1094	383
5933	1097	384
5934	1100	385
5935	1103	386
5936	1106	387
5937	1109	388
5938	1112	389
5939	1115	390
5940	1118	391
5941	1121	392
5942	1124	393
5943	1127	394
5944	1130	395
5945	1133	396
5946	1136	397
5947	1139	398
5948	1142	399
5949	1145	400
5950	1148	401
5951	1151	402
5952	1154	403
5953	1157	404
5954	1160	405
5955	1163	406
5956	1166	407
5957	1169	408
5958	1172	409
5959	1175	410
5960	1178	411
5961	1181	412
5962	1184	413
5963	1187	414
5964	1190	415
5965	1193	416
5966	1196	417
5967	1199	418
5968	1202	419
5969	1205	420
5970	1208	421
5971	1211	422
5972	1214	423
5973	1217	424
5974	1220	425
5975	1223	426
5976	1226	427
5977	1229	428
5978	1232	429
5979	1235	430
5980	1238	431
5981	1241	432
5982	1244	433
5983	1247	434
5984	1250	435
5985	1253	436
5986	1256	437
5987	1259	438
5988	1262	439
5989	1265	440
5990	1268	441
5991	1271	442
5992	1274	443
5993	1277	444
5994	1280	445
5995	1283	446
5996	1286	447
5997	1289	448
5998	1292	449
5999	1295	450
6000	1298	451
6001	1301	452
6002	1304	453
6003	1307	454
6004	1310	455
6005	1313	456
6006	1316	457
6007	1319	458
6008	1322	459
6009	1325	460
6010	1328	461
6011	777	290
6012	778	291
6013	784	294
6014	785	295
6015	1599	590
6016	1601	591
6017	1606	593
6018	1609	594
6019	1948	744
6020	1954	745
6021	1960	746
6022	1966	747
6023	1972	748
6024	1978	749
6025	1568	573
6026	1821	686
6027	1823	687
6028	1819	685
6029	715	264
6030	717	265
6031	720	266
6032	723	267
6033	725	268
6034	728	269
6035	730	270
6036	733	271
6037	735	272
6038	738	273
5106	2035	762
12633	2054	774
12634	2062	775
12635	2070	776
12636	2078	777
12637	2086	778
12638	2094	779
12639	2102	780
12640	2110	781
12643	2146	796
12644	2154	797
12645	2162	798
12646	2170	799
12647	2178	800
12648	2186	801
12649	2194	802
12650	2202	803
12651	2210	804
12652	2218	805
12653	2226	806
12654	2234	807
12641	2242	808
12642	2250	809
12655	2270	822
12656	2278	823
12657	2286	824
12658	2294	825
12659	2302	826
12660	2310	827
12661	2318	828
12662	2326	829
12663	2334	830
12665	2350	832
12666	2358	833
12664	2374	835
\.


--
-- Data for Name: backend_esrule_Striggers; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public."backend_esrule_Striggers" (id, esrule_id, trigger_id) FROM stdin;
1	1	2
2	2	4
3	3	6
4	4	8
5	5	10
6	6	12
7	7	14
8	8	16
9	8	17
10	9	19
11	10	21
12	10	22
13	11	24
14	11	25
15	12	27
16	12	28
81	53	141
82	53	142
83	54	144
84	54	145
85	55	147
86	55	148
87	56	150
88	56	151
89	57	153
90	57	154
91	58	156
92	58	157
93	59	159
94	59	160
95	60	162
96	60	163
99	62	168
100	62	169
101	63	171
102	63	172
103	64	174
104	64	175
117	61	195
118	61	196
119	71	198
120	71	199
121	72	201
122	72	202
123	73	204
124	73	205
125	74	207
126	74	208
127	75	210
128	75	211
129	76	213
130	76	214
131	77	216
132	77	217
133	78	219
134	78	220
135	79	222
136	79	223
137	80	225
138	80	226
139	81	228
140	81	229
141	82	231
142	82	232
143	83	234
144	83	235
145	84	237
146	84	238
161	85	261
164	87	266
165	87	267
166	88	269
167	88	270
168	86	272
169	86	273
170	93	293
171	92	294
172	93	295
173	92	296
174	94	299
175	95	300
176	94	301
177	95	302
178	97	308
179	96	307
180	98	309
181	99	311
182	96	312
183	97	313
184	98	314
185	99	315
186	100	316
187	100	317
188	101	322
189	102	323
190	103	324
191	101	325
192	104	327
193	102	328
194	103	329
195	104	330
196	105	331
197	105	332
198	106	337
199	106	338
200	107	339
201	109	341
202	108	342
203	107	343
204	109	344
205	108	345
206	110	346
207	110	347
208	111	353
209	112	354
210	113	355
211	114	356
212	115	358
213	111	357
214	113	360
215	112	359
216	114	361
217	115	362
218	116	367
219	118	369
220	117	368
221	116	371
222	118	373
223	119	372
224	117	374
225	119	375
226	120	376
227	120	377
228	121	382
229	122	383
230	121	385
231	123	384
232	122	388
233	124	387
235	124	391
234	123	389
236	125	390
237	125	392
238	126	395
239	126	399
240	127	400
241	128	401
242	127	402
243	129	403
244	128	404
245	130	405
246	129	406
247	130	407
248	132	412
249	131	414
250	132	415
251	133	417
252	131	416
253	135	419
254	134	418
255	133	420
256	135	421
257	134	422
258	136	428
259	138	430
260	137	429
261	136	431
262	140	433
263	139	432
264	138	434
265	140	436
266	137	435
267	139	437
268	141	441
269	142	445
270	143	446
271	141	447
272	142	449
273	143	448
274	145	450
275	144	451
276	146	452
277	145	453
278	146	455
279	144	454
280	149	461
281	148	460
282	147	462
283	148	467
284	149	465
285	150	466
286	147	468
287	151	469
288	150	470
289	152	471
290	151	472
291	152	473
292	153	476
293	154	479
294	153	481
295	154	483
296	155	484
297	156	485
298	157	486
299	155	487
300	158	488
301	157	490
302	156	489
303	158	491
304	159	494
305	160	497
306	159	500
307	160	501
308	163	504
309	161	502
310	162	503
311	164	505
312	163	506
313	161	507
314	162	508
315	164	509
316	165	512
317	166	514
318	165	515
319	166	518
320	167	519
321	169	522
322	168	521
323	167	523
324	169	524
325	168	525
326	170	526
327	170	527
328	171	530
329	172	531
330	171	532
331	172	533
332	175	544
333	174	546
334	173	545
335	177	547
336	178	552
337	180	555
338	179	554
339	181	556
358	209	621
359	210	623
360	211	625
361	212	627
362	213	629
363	214	631
364	215	633
365	215	634
366	216	636
367	216	637
368	217	639
369	218	641
370	218	642
371	219	644
372	221	647
373	221	648
376	223	653
377	224	655
378	224	656
390	234	678
391	235	680
392	235	681
393	236	683
394	236	684
395	237	686
396	238	688
397	238	689
398	239	691
399	239	692
400	241	695
401	242	697
402	243	699
403	244	701
404	244	702
405	245	704
406	245	705
407	246	707
408	246	708
409	248	711
410	249	713
411	249	714
412	250	716
413	251	718
414	251	719
415	252	721
416	252	722
417	253	724
418	254	726
419	254	727
420	255	729
421	256	731
422	256	732
423	257	734
424	258	736
425	258	737
426	260	740
427	261	742
428	261	743
431	263	748
432	264	750
433	264	751
434	265	753
435	265	754
436	267	757
451	281	786
454	285	793
455	286	795
456	287	797
457	288	799
458	288	800
459	289	802
460	290	804
461	291	806
472	301	835
473	302	836
474	303	837
475	302	839
476	303	840
477	301	838
478	302	841
479	301	843
480	303	842
481	304	847
482	305	848
483	306	849
484	304	850
485	306	852
486	305	851
487	304	853
488	306	854
489	305	855
490	307	859
491	308	860
492	307	861
493	308	862
494	309	863
495	307	864
496	308	865
497	309	866
498	309	867
499	310	871
500	311	872
501	312	873
502	311	875
503	310	874
504	312	876
505	311	877
506	310	878
507	312	879
508	314	884
509	313	883
510	315	885
511	313	887
512	314	886
513	315	888
514	313	889
515	314	890
516	315	891
517	316	895
518	317	896
519	316	897
520	317	898
521	318	899
522	316	900
523	317	901
524	318	902
525	318	903
526	319	906
527	319	908
528	320	909
529	321	911
530	319	910
531	320	912
532	321	913
533	320	914
534	321	915
535	322	919
536	323	920
537	323	922
538	322	921
539	324	923
540	322	925
541	323	924
542	324	926
543	324	927
544	326	932
545	325	931
546	326	933
547	325	934
548	327	935
549	326	936
550	325	939
551	327	941
552	328	942
553	329	944
554	327	943
555	330	945
556	329	947
557	328	946
558	329	949
559	330	948
560	328	952
561	330	953
562	331	954
563	332	955
564	331	956
565	331	959
566	332	958
567	333	961
568	332	963
569	333	965
570	334	966
571	333	967
572	335	968
573	334	969
574	335	971
575	336	970
576	334	972
577	335	973
578	336	974
579	336	976
580	337	978
581	337	980
582	338	981
583	337	982
584	338	983
585	339	984
586	338	987
587	339	988
588	340	989
589	341	990
590	339	992
591	341	993
592	340	994
593	342	995
594	341	998
595	340	997
596	342	1000
597	343	1001
598	344	1002
599	342	1003
600	343	1004
601	344	1005
602	343	1007
603	344	1009
604	346	1012
605	345	1011
606	347	1014
607	345	1015
608	346	1013
609	347	1017
610	345	1018
611	346	1019
612	347	1020
613	348	1022
614	348	1024
615	349	1025
616	350	1026
617	348	1027
618	349	1028
619	350	1029
620	349	1030
621	350	1031
622	351	1036
623	353	1039
624	352	1038
625	351	1042
626	354	1040
627	353	1045
628	352	1044
629	355	1047
630	354	1048
631	356	1049
632	351	1046
633	353	1050
634	355	1052
635	352	1051
636	354	1054
637	357	1053
638	356	1055
639	355	1056
640	357	1057
641	357	1058
642	356	1059
643	358	1065
644	360	1067
645	359	1068
646	361	1071
647	358	1070
648	362	1072
649	359	1074
650	363	1075
651	360	1073
652	358	1078
653	361	1076
654	362	1079
655	363	1082
656	360	1081
657	364	1080
658	359	1077
659	361	1083
660	362	1085
661	364	1086
662	363	1084
663	364	1087
664	365	1089
665	365	1090
666	366	1092
667	366	1093
668	367	1095
669	367	1096
670	368	1098
671	368	1099
672	369	1101
673	369	1102
674	370	1104
675	370	1105
676	371	1107
677	371	1108
678	372	1110
679	372	1111
680	373	1113
681	373	1114
682	374	1116
683	374	1117
684	375	1119
685	375	1120
686	376	1122
687	376	1123
688	377	1125
689	377	1126
690	378	1128
691	378	1129
692	379	1131
693	379	1132
694	380	1134
695	380	1135
696	381	1137
697	381	1138
698	382	1140
699	382	1141
700	383	1143
701	383	1144
702	384	1146
703	384	1147
704	385	1149
705	385	1150
706	386	1152
707	386	1153
708	387	1155
709	387	1156
710	388	1158
711	388	1159
712	389	1161
713	389	1162
714	390	1164
715	390	1165
716	391	1167
717	391	1168
718	392	1170
719	392	1171
720	393	1173
721	393	1174
722	394	1176
723	394	1177
724	395	1179
725	395	1180
726	396	1182
727	396	1183
728	397	1185
729	397	1186
730	398	1188
731	398	1189
732	399	1191
733	399	1192
734	400	1194
735	400	1195
736	401	1197
737	401	1198
738	402	1200
739	402	1201
740	403	1203
741	403	1204
742	404	1206
743	404	1207
744	405	1209
745	405	1210
746	406	1212
747	406	1213
748	407	1215
749	407	1216
750	408	1218
751	408	1219
752	409	1221
753	409	1222
754	410	1224
755	410	1225
756	411	1227
757	411	1228
758	412	1230
759	412	1231
760	413	1233
761	413	1234
762	414	1236
763	414	1237
764	415	1239
765	415	1240
766	416	1242
767	416	1243
768	417	1245
769	417	1246
770	418	1248
771	418	1249
772	419	1251
773	419	1252
774	420	1254
775	420	1255
776	421	1257
777	421	1258
778	422	1260
779	422	1261
780	423	1263
781	423	1264
782	424	1266
783	424	1267
784	425	1269
785	425	1270
786	426	1272
787	426	1273
788	427	1275
789	427	1276
790	428	1278
791	428	1279
792	429	1281
793	429	1282
794	430	1284
795	430	1285
796	431	1287
797	431	1288
798	432	1290
799	432	1291
800	433	1293
801	433	1294
802	434	1296
803	434	1297
804	435	1299
805	435	1300
806	436	1302
807	436	1303
808	437	1305
809	437	1306
810	438	1308
811	438	1309
812	439	1311
813	439	1312
814	440	1314
815	440	1315
816	441	1317
817	441	1318
818	442	1320
819	442	1321
820	443	1323
821	443	1324
822	444	1326
823	444	1327
824	445	1329
825	445	1330
835	460	1355
844	472	1376
846	474	1380
847	474	1381
848	475	1383
849	475	1384
850	476	1386
851	476	1387
852	477	1389
853	477	1390
854	478	1392
855	478	1393
858	480	1398
859	480	1399
860	481	1401
861	481	1402
862	482	1404
863	482	1405
864	483	1407
865	483	1408
866	484	1410
867	484	1411
868	485	1413
869	485	1414
870	486	1416
871	486	1417
872	487	1419
873	487	1420
882	492	1434
883	492	1435
884	493	1437
885	493	1438
886	494	1440
893	498	1451
894	498	1452
895	499	1454
896	499	1455
897	500	1457
898	500	1458
899	495	1460
900	495	1461
901	496	1463
902	496	1464
903	497	1466
904	497	1467
905	501	1469
906	502	1471
910	505	1479
911	506	1481
912	507	1483
923	518	1505
929	504	1517
930	524	1519
931	524	1520
932	525	1522
933	526	1524
934	526	1525
935	527	1527
936	527	1528
937	528	1530
938	529	1532
940	532	1537
942	534	1543
943	536	1546
945	538	1552
948	540	1561
949	542	1564
950	519	1566
951	519	1567
962	543	1592
963	544	1594
965	546	1598
966	278	1600
967	279	1602
968	279	1603
970	548	1607
971	548	1608
972	549	1610
998	456	1667
999	470	1671
1000	558	1673
1001	559	1675
1481	804	1690
1482	804	1691
1483	803	1693
1484	803	1694
1493	812	1717
1494	812	1718
1499	810	1726
1500	810	1727
1501	813	1729
1502	813	1730
1503	809	1732
1504	809	1733
1505	814	1735
1506	815	1737
1507	815	1738
1508	816	1740
1509	816	1741
1512	820	1748
1513	820	1749
1516	824	1757
1517	824	1758
1520	826	1763
1521	827	1765
1522	827	1766
1999	1070	1783
2000	1069	1782
2001	1068	1781
2002	1070	1784
2003	1069	1785
2004	1068	1786
2006	1072	1791
2008	1072	1793
2010	1074	1797
2012	1074	1799
2013	1076	1801
2014	1077	1803
2015	1078	1805
2016	1078	1806
2018	1080	1810
2971	186	1814
2972	552	1816
2973	553	1818
2974	193	1820
2975	196	1822
2976	550	1824
4418	262	1834
4419	262	1835
4420	266	1837
4421	266	1838
4422	2295	1840
4423	2296	1842
4424	2296	1843
4909	2543	1845
4910	2544	1847
7814	554	1851
7815	1079	1853
7816	1079	1854
7817	825	1856
8304	818	1858
8305	819	1860
8306	4272	1862
8307	4272	1863
8308	4273	1865
8795	1071	1868
8796	1073	1870
8797	1073	1871
8798	1075	1873
8799	4523	1875
8800	4523	1876
8801	4524	1878
8802	829	1880
8803	829	1881
8804	4525	1883
9328	4801	1885
9329	4801	1886
9330	4802	1889
9331	4802	1890
9332	4803	1893
9333	4803	1894
9334	4804	1897
9335	4804	1898
9336	488	1900
9337	488	1901
9861	5081	1913
9862	5080	1912
9863	5082	1914
9864	5083	1915
9865	5084	1920
9866	5085	1921
9867	5087	1923
9868	5086	1922
9869	5089	1930
9870	5088	1931
9871	5090	1932
9872	5091	1933
9873	5092	1938
9874	5093	1939
9875	5094	1940
9876	5095	1941
9877	5096	1949
9878	5096	1950
9879	5096	1951
9880	5096	1952
9881	5096	1953
9882	5097	1955
9883	5097	1956
9884	5097	1957
9885	5097	1958
9886	5097	1959
9887	5098	1961
9888	5098	1962
9889	5098	1963
9890	5098	1964
9891	5098	1965
9892	5099	1967
9893	5099	1968
9894	5099	1969
9895	5099	1970
9896	5099	1971
9897	5100	1973
9898	5100	1974
9899	5100	1975
9900	5100	1976
9901	5100	1977
9902	5101	1979
9903	5101	1980
9904	5101	1981
9905	5101	1982
9906	5101	1983
9907	5102	1991
9908	5102	1992
9909	5102	1993
9910	5102	1994
9911	5102	1995
9912	5102	1996
9913	5102	1997
9914	5102	1998
9915	5103	2000
9916	5103	2001
9917	5103	2002
9918	5103	2003
9919	5103	2004
9920	5103	2005
9921	5103	2006
9922	5104	2008
9923	5104	2009
9924	5104	2010
9925	5104	2011
9926	5104	2012
9927	5105	2014
9928	5105	2015
9929	5105	2016
9930	5105	2017
9931	5105	2018
9932	5105	2019
9940	5107	2029
9941	5107	2030
9942	5107	2031
9943	5107	2032
9944	5107	2033
9945	5107	2034
11123	5708	1469
11124	5709	1471
11125	5710	1479
11126	5711	1481
11127	5712	1483
11128	5713	1505
11129	5714	1517
11130	5715	1520
11131	5715	1519
11132	5716	1522
11133	5717	1524
11134	5717	1525
11135	5718	1528
11136	5718	1527
11137	5719	1530
11138	5720	1532
11139	5721	1566
11140	5721	1567
11141	5722	1786
11142	5722	1781
11143	5723	1785
11144	5723	1782
11145	5724	1784
11146	5724	1783
11147	5725	1868
11148	5726	1793
11149	5726	1791
11150	5727	1870
11151	5727	1871
11152	5728	1797
11153	5728	1799
11154	5729	1873
11155	5730	1801
11156	5731	1803
11157	5732	1805
11158	5732	1806
11159	5733	1737
11160	5733	1738
11161	5734	1740
11162	5734	1741
11163	5739	786
11164	5742	793
11165	5743	795
11166	5744	797
11167	5745	800
11168	5745	799
11169	5746	802
11170	5747	804
11171	5748	806
11172	5749	1600
11173	5750	1602
11174	5750	1603
11175	5751	1608
11176	5751	1607
11177	5752	1610
11178	5753	1765
11179	5753	1766
11180	5754	1880
11181	5754	1881
11182	5755	1883
11183	5756	1878
11184	5757	1875
11185	5757	1876
11186	5758	1748
11187	5758	1749
11188	5761	1860
11189	5762	1858
11190	5763	1862
11191	5763	1863
11192	5764	1865
11193	5766	1952
11194	5766	1953
11195	5766	1949
11196	5766	1950
11197	5766	1951
11198	5767	1955
11199	5767	1956
11200	5767	1957
11201	5767	1958
11202	5767	1959
11203	5768	1961
11204	5768	1962
11205	5768	1963
11206	5768	1964
11207	5768	1965
11208	5769	1968
11209	5769	1969
11210	5769	1970
11211	5769	1971
11212	5769	1967
11213	5770	1976
11214	5770	1977
11215	5770	1973
11216	5770	1974
11217	5770	1975
11218	5771	1979
11219	5771	1980
11220	5771	1981
11221	5771	1982
11222	5771	1983
11223	5772	1991
11224	5772	1992
11225	5772	1993
11226	5772	1994
11227	5772	1995
11228	5772	1996
11229	5772	1997
11230	5772	1998
11231	5773	2000
11232	5773	2001
11233	5773	2002
11234	5773	2003
11235	5773	2004
11236	5773	2005
11237	5773	2006
11238	5774	2008
11239	5774	2009
11240	5774	2010
11241	5774	2011
11242	5774	2012
11243	5775	2016
11244	5775	2017
11245	5775	2018
11246	5775	2019
11247	5775	2014
11248	5775	2015
11249	5776	2021
11250	5776	2022
11251	5776	2023
11252	5776	2024
11253	5776	2025
11254	5776	2026
11255	5776	2027
11256	5777	2029
11257	5777	2030
11258	5777	2031
11259	5777	2032
11260	5777	2033
11261	5777	2034
11262	5778	1757
11263	5778	1758
11264	5779	1856
11265	5780	1763
11266	5781	1853
11267	5781	1854
11268	5782	1810
11269	5783	1912
11270	5784	1913
11271	5785	1914
11272	5786	1915
11273	5787	1920
11274	5788	1921
11275	5789	1922
11276	5790	1923
11277	5791	1931
11278	5792	1930
11279	5793	1932
11280	5794	1933
11281	5795	1938
11282	5796	1939
11283	5797	1940
11284	5798	1941
11285	5800	1822
11286	5801	1824
11287	5803	1816
11288	5804	1818
11289	5805	1851
11290	5806	1820
11291	5807	1814
11292	5808	1389
11293	5808	1390
11294	5809	1392
11295	5809	1393
11296	5810	1398
11297	5810	1399
11298	5811	1401
11299	5811	1402
11300	5812	1404
11301	5812	1405
11302	5813	1408
11303	5813	1407
11304	5814	1410
11305	5814	1411
11306	5815	1413
11307	5815	1414
11308	5816	1416
11309	5816	1417
11310	5817	1419
11311	5817	1420
11312	5818	1900
11313	5818	1901
11314	5819	1434
11315	5819	1435
11316	5820	1437
11317	5820	1438
11318	5821	1440
11319	5822	1451
11320	5822	1452
11321	5823	1454
11322	5823	1455
11323	5824	1457
11324	5824	1458
11325	5825	1460
11326	5825	1461
11327	5826	1464
11328	5826	1463
11329	5827	1466
11330	5827	1467
11331	5828	1885
11332	5828	1886
11333	5829	1889
11334	5829	1890
11335	5830	1893
11336	5830	1894
11337	5831	1897
11338	5831	1898
11339	5834	1355
11340	5836	1376
11341	5837	1667
11342	5839	1671
11343	5842	1673
11344	5843	1675
11345	5844	843
11346	5844	835
11347	5844	838
11348	5845	841
11349	5845	836
11350	5845	839
11351	5846	840
11352	5846	842
11353	5846	837
11354	5847	850
11355	5847	853
11356	5847	847
11357	5848	848
11358	5848	851
11359	5848	855
11360	5849	849
11361	5849	852
11362	5849	854
11363	5850	864
11364	5850	859
11365	5850	861
11366	5851	865
11367	5851	860
11368	5851	862
11369	5852	866
11370	5852	867
11371	5852	863
11372	5853	874
11373	5853	878
11374	5853	871
11375	5854	872
11376	5854	875
11377	5854	877
11378	5855	873
11379	5855	876
11380	5855	879
11381	5856	889
11382	5856	883
11383	5856	887
11384	5857	890
11385	5857	884
11386	5857	886
11387	5858	888
11388	5858	891
11389	5858	885
11390	5859	897
11391	5859	900
11392	5859	895
11393	5860	896
11394	5860	898
11395	5860	901
11396	5861	899
11397	5861	902
11398	5861	903
11399	5862	906
11400	5862	908
11401	5862	910
11402	5863	912
11403	5863	914
11404	5863	909
11405	5864	913
11406	5864	915
11407	5864	911
11408	5865	921
11409	5865	925
11410	5865	919
11411	5866	920
11412	5866	922
11413	5866	924
11414	5867	923
11415	5867	926
11416	5867	927
11417	5868	931
11418	5868	939
11419	5868	934
11420	5869	936
11421	5869	932
11422	5869	933
11423	5870	943
11424	5870	941
11425	5870	935
11426	5871	952
11427	5871	946
11428	5871	942
11429	5872	944
11430	5872	947
11431	5872	949
11432	5873	945
11433	5873	953
11434	5873	948
11435	5874	954
11436	5874	956
11437	5874	959
11438	5875	955
11439	5875	958
11440	5875	963
11441	5876	961
11442	5876	965
11443	5876	967
11444	5877	969
11445	5877	972
11446	5877	966
11447	5878	968
11448	5878	971
11449	5878	973
11450	5879	976
11451	5879	970
11452	5879	974
11453	5880	978
11454	5880	980
11455	5880	982
11456	5881	987
11457	5881	981
11458	5881	983
11459	5882	984
11460	5882	992
11461	5882	988
11462	5883	997
11463	5883	994
11464	5883	989
11465	5884	993
11466	5884	990
11467	5884	998
11468	5885	1000
11469	5885	995
11470	5885	1003
11471	5886	1001
11472	5886	1004
11473	5886	1007
11474	5887	1009
11475	5887	1002
11476	5887	1005
11477	5888	1018
11478	5888	1011
11479	5888	1015
11480	5889	1019
11481	5889	1012
11482	5889	1013
11483	5890	1017
11484	5890	1020
11485	5890	1014
11486	5891	1024
11487	5891	1027
11488	5891	1022
11489	5892	1025
11490	5892	1028
11491	5892	1030
11492	5893	1026
11493	5893	1029
11494	5893	1031
11495	5894	1042
11496	5894	1036
11497	5894	1046
11498	5895	1051
11499	5895	1044
11500	5895	1038
11501	5896	1050
11502	5896	1045
11503	5896	1039
11504	5897	1040
11505	5897	1048
11506	5897	1054
11507	5898	1056
11508	5898	1052
11509	5898	1047
11510	5899	1049
11511	5899	1059
11512	5899	1055
11513	5900	1057
11514	5900	1058
11515	5900	1053
11516	5901	1078
11517	5901	1065
11518	5901	1070
11519	5902	1074
11520	5902	1068
11521	5902	1077
11522	5903	1073
11523	5903	1067
11524	5903	1081
11525	5904	1083
11526	5904	1076
11527	5904	1071
11528	5905	1072
11529	5905	1085
11530	5905	1079
11531	5906	1082
11532	5906	1075
11533	5906	1084
11534	5907	1080
11535	5907	1086
11536	5907	1087
11537	5908	716
11538	5909	718
11539	5909	719
11540	5910	721
11541	5910	722
11542	5911	724
11543	5912	726
11544	5912	727
11545	5913	729
11546	5914	731
11547	5914	732
11548	5915	734
11549	5916	736
11550	5916	737
11551	5918	740
11552	5919	742
11553	5919	743
11554	5920	1834
11555	5920	1835
11556	5921	748
11557	5922	750
11558	5922	751
11559	5923	753
11560	5923	754
11561	5924	1837
11562	5924	1838
11563	5925	757
11564	5926	1842
11565	5926	1843
11566	5927	1840
11567	5928	1847
11568	5929	1845
11569	5930	1089
11570	5930	1090
11571	5931	1092
11572	5931	1093
11573	5932	1096
11574	5932	1095
11575	5933	1098
11576	5933	1099
11577	5934	1101
11578	5934	1102
11579	5935	1104
11580	5935	1105
11581	5936	1107
11582	5936	1108
11583	5937	1110
11584	5937	1111
11585	5938	1113
11586	5938	1114
11587	5939	1116
11588	5939	1117
11589	5940	1120
11590	5940	1119
11591	5941	1122
11592	5941	1123
11593	5942	1125
11594	5942	1126
11595	5943	1128
11596	5943	1129
11597	5944	1131
11598	5944	1132
11599	5945	1134
11600	5945	1135
11601	5946	1137
11602	5946	1138
11603	5947	1140
11604	5947	1141
11605	5948	1144
11606	5948	1143
11607	5949	1146
11608	5949	1147
11609	5950	1149
11610	5950	1150
11611	5951	1152
11612	5951	1153
11613	5952	1155
11614	5952	1156
11615	5953	1158
11616	5953	1159
11617	5954	1161
11618	5954	1162
11619	5955	1164
11620	5955	1165
11621	5956	1168
11622	5956	1167
11623	5957	1170
11624	5957	1171
11625	5958	1173
11626	5958	1174
11627	5959	1176
11628	5959	1177
11629	5960	1179
11630	5960	1180
11631	5961	1182
11632	5961	1183
11633	5962	1185
11634	5962	1186
11635	5963	1188
11636	5963	1189
11637	5964	1192
11638	5964	1191
11639	5965	1194
11640	5965	1195
11641	5966	1197
11642	5966	1198
11643	5967	1200
11644	5967	1201
11645	5968	1203
11646	5968	1204
11647	5969	1206
11648	5969	1207
11649	5970	1209
11650	5970	1210
11651	5971	1212
11652	5971	1213
11653	5972	1216
11654	5972	1215
11655	5973	1218
11656	5973	1219
11657	5974	1221
11658	5974	1222
11659	5975	1224
11660	5975	1225
11661	5976	1227
11662	5976	1228
11663	5977	1230
11664	5977	1231
11665	5978	1233
11666	5978	1234
11667	5979	1236
11668	5979	1237
11669	5980	1240
11670	5980	1239
11671	5981	1242
11672	5981	1243
11673	5982	1245
11674	5982	1246
11675	5983	1248
11676	5983	1249
11677	5984	1251
11678	5984	1252
11679	5985	1254
11680	5985	1255
11681	5986	1257
11682	5986	1258
11683	5987	1260
11684	5987	1261
11685	5988	1264
11686	5988	1263
11687	5989	1266
11688	5989	1267
11689	5990	1269
11690	5990	1270
11691	5991	1272
11692	5991	1273
11693	5992	1275
11694	5992	1276
11695	5993	1278
11696	5993	1279
11697	5994	1281
11698	5994	1282
11699	5995	1284
11700	5995	1285
11701	5996	1288
11702	5996	1287
11703	5997	1290
11704	5997	1291
11705	5998	1293
11706	5998	1294
11707	5999	1296
11708	5999	1297
11709	6000	1299
11710	6000	1300
11711	6001	1302
11712	6001	1303
11713	6002	1305
11714	6002	1306
11715	6003	1308
11716	6003	1309
11717	6004	1312
11718	6004	1311
11719	6005	1314
11720	6005	1315
11721	6006	1317
11722	6006	1318
11723	6007	1320
11724	6007	1321
11725	6008	1323
11726	6008	1324
11727	6009	1326
11728	6009	1327
11729	6010	1329
11730	6010	1330
11731	6014	786
11732	6015	1600
11733	6016	1602
11734	6016	1603
11735	6017	1608
11736	6017	1607
11737	6018	1610
11738	6019	1952
11739	6019	1953
11740	6019	1949
11741	6019	1950
11742	6019	1951
11743	6020	1955
11744	6020	1956
11745	6020	1957
11746	6020	1958
11747	6020	1959
11748	6021	1961
11749	6021	1962
11750	6021	1963
11751	6021	1964
11752	6021	1965
11753	6022	1968
11754	6022	1969
11755	6022	1970
11756	6022	1971
11757	6022	1967
11758	6023	1976
11759	6023	1977
11760	6023	1973
11761	6023	1974
11762	6023	1975
11763	6024	1979
11764	6024	1980
11765	6024	1981
11766	6024	1982
11767	6024	1983
11768	6026	1822
11769	6027	1824
11770	6028	1820
11771	6029	716
11772	6030	718
11773	6030	719
11774	6031	721
11775	6031	722
11776	6032	724
11777	6033	726
11778	6033	727
11779	6034	729
11780	6035	731
11781	6035	732
11782	6036	734
11783	6037	736
11784	6037	737
11785	5106	2036
11786	5106	2037
11787	5106	2038
11788	5106	2039
11789	5106	2040
11790	5106	2041
11791	5106	2042
24700	12633	2055
24701	12633	2056
24702	12633	2057
24703	12633	2058
24704	12633	2059
24705	12633	2060
24706	12633	2061
24707	12634	2063
24708	12634	2064
24709	12634	2065
24710	12634	2066
24711	12634	2067
24712	12634	2068
24713	12634	2069
24714	12635	2071
24715	12635	2072
24716	12635	2073
24717	12635	2074
24718	12635	2075
24719	12635	2076
24720	12635	2077
24721	12636	2079
24722	12636	2080
24723	12636	2081
24724	12636	2082
24725	12636	2083
24726	12636	2084
24727	12636	2085
24728	12637	2087
24729	12637	2088
24730	12637	2089
24731	12637	2090
24732	12637	2091
24733	12637	2092
24734	12637	2093
24735	12638	2095
24736	12638	2096
24737	12638	2097
24738	12638	2098
24739	12638	2099
24740	12638	2100
24741	12638	2101
24742	12639	2103
24743	12639	2104
24744	12639	2105
24745	12639	2106
24746	12639	2107
24747	12639	2108
24748	12639	2109
24749	12640	2111
24750	12640	2112
24751	12640	2113
24752	12640	2114
24753	12640	2115
24754	12640	2116
24755	12640	2117
24770	12643	2147
24771	12643	2148
24772	12643	2149
24773	12643	2150
24774	12643	2151
24775	12643	2152
24776	12643	2153
24777	12644	2155
24778	12644	2156
24779	12644	2157
24780	12644	2158
24781	12644	2159
24782	12644	2160
24783	12644	2161
24784	12645	2163
24785	12645	2164
24786	12645	2165
24787	12645	2166
24788	12645	2167
24789	12645	2168
24790	12645	2169
24791	12646	2171
24792	12646	2172
24793	12646	2173
24794	12646	2174
24795	12646	2175
24796	12646	2176
24797	12646	2177
24798	12647	2179
24799	12647	2180
24800	12647	2181
24801	12647	2182
24802	12647	2183
24803	12647	2184
24804	12647	2185
24805	12648	2187
24806	12648	2188
24807	12648	2189
24808	12648	2190
24809	12648	2191
24810	12648	2192
24811	12648	2193
24812	12649	2195
24813	12649	2196
24814	12649	2197
24815	12649	2198
24816	12649	2199
24817	12649	2200
24818	12649	2201
24819	12650	2203
24820	12650	2204
24821	12650	2205
24822	12650	2206
24823	12650	2207
24824	12650	2208
24825	12650	2209
24826	12651	2211
24827	12651	2212
24828	12651	2213
24829	12651	2214
24830	12651	2215
24831	12651	2216
24832	12651	2217
24833	12652	2219
24834	12652	2220
24835	12652	2221
24836	12652	2222
24837	12652	2223
24838	12652	2224
24839	12652	2225
24840	12653	2227
24841	12653	2228
24842	12653	2229
24843	12653	2230
24844	12653	2231
24845	12653	2232
24846	12653	2233
24847	12654	2235
24848	12654	2236
24849	12654	2237
24850	12654	2238
24851	12654	2239
24852	12654	2240
24853	12654	2241
24854	12641	2243
24855	12641	2244
24856	12641	2245
24857	12641	2246
24858	12641	2247
24859	12641	2248
24860	12641	2249
24861	12642	2251
24862	12642	2252
24863	12642	2253
24864	12642	2254
24865	12642	2255
24866	12642	2256
24867	12642	2257
24868	12655	2271
24869	12655	2272
24870	12655	2273
24871	12655	2274
24872	12655	2275
24873	12655	2276
24874	12655	2277
24875	12656	2279
24876	12656	2280
24877	12656	2281
24878	12656	2282
24879	12656	2283
24880	12656	2284
24881	12656	2285
24882	12657	2287
24883	12657	2288
24884	12657	2289
24885	12657	2290
24886	12657	2291
24887	12657	2292
24888	12657	2293
24889	12658	2295
24890	12658	2296
24891	12658	2297
24892	12658	2298
24893	12658	2299
24894	12658	2300
24895	12658	2301
24896	12659	2303
24897	12659	2304
24898	12659	2305
24899	12659	2306
24900	12659	2307
24901	12659	2308
24902	12659	2309
24903	12660	2311
24904	12660	2312
24905	12660	2313
24906	12660	2314
24907	12660	2315
24908	12660	2316
24909	12660	2317
24910	12661	2319
24911	12661	2320
24912	12661	2321
24913	12661	2322
24914	12661	2323
24915	12661	2324
24916	12661	2325
24917	12662	2327
24918	12662	2328
24919	12662	2329
24920	12662	2330
24921	12662	2331
24922	12662	2332
24923	12662	2333
24924	12663	2335
24925	12663	2336
24926	12663	2337
24927	12663	2338
24928	12663	2339
24929	12663	2340
24930	12663	2341
24938	12665	2351
24939	12665	2352
24940	12665	2353
24941	12665	2354
24942	12665	2355
24943	12665	2356
24944	12665	2357
24945	12666	2359
24946	12666	2360
24947	12666	2361
24948	12666	2362
24949	12666	2363
24950	12666	2364
24951	12666	2365
24959	12664	2375
24960	12664	2376
24961	12664	2377
24962	12664	2378
24963	12664	2379
24964	12664	2380
24965	12664	2381
\.


--
-- Name: backend_esrule_Striggers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public."backend_esrule_Striggers_id_seq"', 24965, true);


--
-- Data for Name: backend_esrulemeta; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_esrulemeta (id, is_template, rule_id, tapset_id) FROM stdin;
287	t	501	12
288	t	502	12
289	t	505	12
290	t	506	12
291	t	507	12
292	t	518	12
293	t	504	12
294	t	524	12
295	t	525	12
296	t	526	12
297	t	527	12
298	t	528	12
299	t	529	12
300	t	519	12
301	t	477	13
302	t	478	13
304	t	480	13
305	t	481	13
306	t	482	13
307	t	483	13
308	t	484	13
309	t	485	13
310	t	486	13
311	t	487	13
312	t	488	13
316	t	492	13
317	t	493	13
318	t	494	13
319	t	498	13
320	t	499	13
321	t	500	13
322	t	495	13
323	t	496	13
324	t	497	13
325	t	447	14
326	t	452	14
327	t	460	14
328	t	462	14
329	t	472	14
330	t	456	14
331	t	458	14
332	t	470	14
334	t	449	14
335	t	468	14
336	t	558	14
337	t	559	14
339	t	365	15
340	t	366	15
341	t	367	15
342	t	368	15
343	t	369	15
344	t	370	15
345	t	371	15
346	t	372	15
347	t	373	15
348	t	374	15
349	t	375	15
350	t	376	15
351	t	377	15
352	t	378	15
353	t	379	15
354	t	380	15
355	t	381	15
356	t	382	15
357	t	383	15
358	t	384	15
359	t	385	15
360	t	386	15
361	t	387	15
362	t	388	15
363	t	389	15
364	t	390	15
365	t	391	15
366	t	392	15
367	t	393	15
368	t	394	15
369	t	395	15
370	t	396	15
371	t	397	15
372	t	398	15
373	t	399	15
374	t	400	15
375	t	401	15
376	t	402	15
377	t	403	15
378	t	404	15
379	t	405	15
380	t	406	15
381	t	407	15
382	t	408	15
383	t	409	15
384	t	410	15
385	t	411	15
386	t	412	15
387	t	413	15
388	t	414	15
389	t	415	15
390	t	416	15
391	t	417	15
392	t	418	15
393	t	419	15
394	t	420	15
395	t	421	15
396	t	422	15
397	t	423	15
398	t	424	15
399	t	425	15
400	t	426	15
401	t	427	15
402	t	428	15
403	t	429	15
404	t	430	15
405	t	431	15
406	t	432	15
407	t	433	15
408	t	434	15
409	t	435	15
410	t	436	15
411	t	437	15
412	t	438	15
413	t	439	15
414	t	440	15
415	t	441	15
416	t	442	15
417	t	443	15
418	t	444	15
419	t	445	15
420	t	301	16
421	t	302	16
422	t	303	16
423	t	304	16
424	t	305	16
425	t	306	16
426	t	307	16
427	t	308	16
428	t	309	16
429	t	310	16
430	t	311	16
431	t	312	16
432	t	313	16
433	t	314	16
434	t	315	16
435	t	316	16
436	t	317	16
437	t	318	16
438	t	319	16
439	t	320	16
440	t	321	16
441	t	322	16
442	t	323	16
443	t	324	16
444	t	325	16
445	t	326	16
446	t	327	16
447	t	328	16
448	t	329	16
449	t	330	16
450	t	331	16
451	t	332	16
452	t	333	16
453	t	334	16
454	t	335	16
455	t	336	16
456	t	337	16
457	t	338	16
458	t	339	16
459	t	340	16
460	t	341	16
461	t	342	16
462	t	343	16
463	t	344	16
464	t	345	16
465	t	346	16
466	t	347	16
467	t	348	16
468	t	349	16
469	t	350	16
470	t	351	16
471	t	352	16
472	t	353	16
473	t	354	16
474	t	355	16
475	t	356	16
476	t	357	16
477	t	358	16
478	t	359	16
479	t	360	16
480	t	361	16
481	t	362	16
482	t	363	16
483	t	364	16
486	t	192	17
487	t	192	18
488	t	196	17
489	t	196	18
490	t	550	17
491	t	550	18
492	t	551	17
493	t	552	17
494	t	553	17
495	t	554	17
498	t	193	17
499	t	193	18
500	t	186	17
502	t	250	19
503	t	250	20
504	t	251	19
505	t	251	20
506	t	252	19
507	t	252	20
508	t	253	19
509	t	253	20
510	t	254	19
511	t	254	20
512	t	255	19
513	t	255	20
514	t	256	19
515	t	256	20
516	t	257	19
517	t	257	20
518	t	258	19
519	t	258	20
520	t	259	19
521	t	259	20
522	t	260	19
523	t	261	19
524	t	262	19
525	t	263	19
526	t	264	19
527	t	265	19
528	t	266	19
529	t	267	19
538	t	276	21
539	t	276	22
540	t	277	21
541	t	277	22
542	t	280	21
543	t	280	22
544	t	281	21
545	t	281	22
546	t	283	21
547	t	284	21
548	t	285	21
549	t	286	21
550	t	287	21
551	t	288	21
552	t	289	21
553	t	290	21
554	t	291	21
563	t	278	21
564	t	278	22
565	t	279	21
566	t	279	22
567	t	548	21
568	t	548	22
569	t	549	21
570	t	549	22
1289	t	824	23
1290	t	825	23
1291	t	826	23
1292	t	1079	23
1293	t	1080	23
2269	t	2296	19
2270	t	2295	19
2517	t	2544	19
2518	t	2543	19
4494	t	1068	24
4495	t	1069	24
4496	t	1070	24
4497	t	1071	24
4498	t	1072	24
4499	t	1073	24
4500	t	1074	24
4501	t	1075	24
4502	t	1076	24
4503	t	1077	24
4504	t	1078	24
4505	t	827	25
4507	t	829	25
4508	t	815	26
4509	t	816	26
4510	t	817	26
4511	t	820	27
4512	t	821	27
4513	t	822	27
4514	t	819	27
4515	t	818	27
4516	t	4272	27
4517	t	4273	27
4518	t	4274	27
4519	t	4525	25
4520	t	4524	25
4521	t	4523	25
4797	t	4801	13
4798	t	4802	13
4799	t	4803	13
4800	t	4804	13
5076	t	5080	28
5077	t	5081	28
5078	t	5082	28
5079	t	5083	28
5080	t	5084	28
5081	t	5085	28
5082	t	5086	28
5083	t	5087	28
5084	t	5088	29
5085	t	5089	29
5086	t	5090	29
5087	t	5091	29
5088	t	5092	29
5089	t	5093	29
5090	t	5094	29
5091	t	5095	29
5092	t	5096	30
5093	t	5096	31
5094	t	5097	30
5095	t	5097	31
5096	t	5098	30
5097	t	5098	31
5098	t	5099	30
5099	t	5099	31
5100	t	5100	30
5101	t	5100	31
5102	t	5101	30
5103	t	5101	31
5104	t	5102	30
5105	t	5103	30
5106	t	5104	30
5107	t	5105	30
5108	t	5106	30
5109	t	5107	30
5710	f	5708	12
5711	f	5709	12
5712	f	5710	12
5713	f	5711	12
5714	f	5712	12
5715	f	5713	12
5716	f	5714	12
5717	f	5715	12
5718	f	5716	12
5719	f	5717	12
5720	f	5718	12
5721	f	5719	12
5722	f	5720	12
5723	f	5721	12
5724	f	5722	24
5725	f	5723	24
5726	f	5724	24
5727	f	5725	24
5728	f	5726	24
5729	f	5727	24
5730	f	5728	24
5731	f	5729	24
5732	f	5730	24
5733	f	5731	24
5734	f	5732	24
5735	f	5733	26
5736	f	5734	26
5737	f	5735	26
5738	f	5736	21
5739	f	5737	21
5740	f	5738	21
5741	f	5739	21
5742	f	5740	21
5743	f	5741	21
5744	f	5742	21
5745	f	5743	21
5746	f	5744	21
5747	f	5745	21
5748	f	5746	21
5749	f	5747	21
5750	f	5748	21
5751	f	5749	21
5752	f	5750	21
5753	f	5751	21
5754	f	5752	21
5755	f	5753	25
5756	f	5754	25
5757	f	5755	25
5758	f	5756	25
5759	f	5757	25
5760	f	5758	27
5761	f	5759	27
5762	f	5760	27
5763	f	5761	27
5764	f	5762	27
5765	f	5763	27
5766	f	5764	27
5767	f	5765	27
5768	f	5766	30
5769	f	5767	30
5770	f	5768	30
5771	f	5769	30
5772	f	5770	30
5773	f	5771	30
5774	f	5772	30
5775	f	5773	30
5776	f	5774	30
5777	f	5775	30
5778	f	5776	30
5779	f	5777	30
5780	f	5778	23
5781	f	5779	23
5782	f	5780	23
5783	f	5781	23
5784	f	5782	23
5785	f	5783	28
5786	f	5784	28
5787	f	5785	28
5788	f	5786	28
5789	f	5787	28
5790	f	5788	28
5791	f	5789	28
5792	f	5790	28
5793	f	5791	29
5794	f	5792	29
5795	f	5793	29
5796	f	5794	29
5797	f	5795	29
5798	f	5796	29
5799	f	5797	29
5800	f	5798	29
5801	f	5799	17
5802	f	5800	17
5803	f	5801	17
5804	f	5802	17
5805	f	5803	17
5806	f	5804	17
5807	f	5805	17
5808	f	5806	17
5809	f	5807	17
5810	f	5808	13
5811	f	5809	13
5812	f	5810	13
5813	f	5811	13
5814	f	5812	13
5815	f	5813	13
5816	f	5814	13
5817	f	5815	13
5818	f	5816	13
5819	f	5817	13
5820	f	5818	13
5821	f	5819	13
5822	f	5820	13
5823	f	5821	13
5824	f	5822	13
5825	f	5823	13
5826	f	5824	13
5827	f	5825	13
5828	f	5826	13
5829	f	5827	13
5830	f	5828	13
5831	f	5829	13
5832	f	5830	13
5833	f	5831	13
5834	f	5832	14
5835	f	5833	14
5836	f	5834	14
5837	f	5835	14
5838	f	5836	14
5839	f	5837	14
5840	f	5838	14
5841	f	5839	14
5842	f	5840	14
5843	f	5841	14
5844	f	5842	14
5845	f	5843	14
5846	f	5844	16
5847	f	5845	16
5848	f	5846	16
5849	f	5847	16
5850	f	5848	16
5851	f	5849	16
5852	f	5850	16
5853	f	5851	16
5854	f	5852	16
5855	f	5853	16
5856	f	5854	16
5857	f	5855	16
5858	f	5856	16
5859	f	5857	16
5860	f	5858	16
5861	f	5859	16
5862	f	5860	16
5863	f	5861	16
5864	f	5862	16
5865	f	5863	16
5866	f	5864	16
5867	f	5865	16
5868	f	5866	16
5869	f	5867	16
5870	f	5868	16
5871	f	5869	16
5872	f	5870	16
5873	f	5871	16
5874	f	5872	16
5875	f	5873	16
5876	f	5874	16
5877	f	5875	16
5878	f	5876	16
5879	f	5877	16
5880	f	5878	16
5881	f	5879	16
5882	f	5880	16
5883	f	5881	16
5884	f	5882	16
5885	f	5883	16
5886	f	5884	16
5887	f	5885	16
5888	f	5886	16
5889	f	5887	16
5890	f	5888	16
5891	f	5889	16
5892	f	5890	16
5893	f	5891	16
5894	f	5892	16
5895	f	5893	16
5896	f	5894	16
5897	f	5895	16
5898	f	5896	16
5899	f	5897	16
5900	f	5898	16
5901	f	5899	16
5902	f	5900	16
5903	f	5901	16
5904	f	5902	16
5905	f	5903	16
5906	f	5904	16
5907	f	5905	16
5908	f	5906	16
5909	f	5907	16
5910	f	5908	19
5911	f	5909	19
5912	f	5910	19
5913	f	5911	19
5914	f	5912	19
5915	f	5913	19
5916	f	5914	19
5917	f	5915	19
5918	f	5916	19
5919	f	5917	19
5920	f	5918	19
5921	f	5919	19
5922	f	5920	19
5923	f	5921	19
5924	f	5922	19
5925	f	5923	19
5926	f	5924	19
5927	f	5925	19
5928	f	5926	19
5929	f	5927	19
5930	f	5928	19
5931	f	5929	19
5932	f	5930	15
5933	f	5931	15
5934	f	5932	15
5935	f	5933	15
5936	f	5934	15
5937	f	5935	15
5938	f	5936	15
5939	f	5937	15
5940	f	5938	15
5941	f	5939	15
5942	f	5940	15
5943	f	5941	15
5944	f	5942	15
5945	f	5943	15
5946	f	5944	15
5947	f	5945	15
5948	f	5946	15
5949	f	5947	15
5950	f	5948	15
5951	f	5949	15
5952	f	5950	15
5953	f	5951	15
5954	f	5952	15
5955	f	5953	15
5956	f	5954	15
5957	f	5955	15
5958	f	5956	15
5959	f	5957	15
5960	f	5958	15
5961	f	5959	15
5962	f	5960	15
5963	f	5961	15
5964	f	5962	15
5965	f	5963	15
5966	f	5964	15
5967	f	5965	15
5968	f	5966	15
5969	f	5967	15
5970	f	5968	15
5971	f	5969	15
5972	f	5970	15
5973	f	5971	15
5974	f	5972	15
5975	f	5973	15
5976	f	5974	15
5977	f	5975	15
5978	f	5976	15
5979	f	5977	15
5980	f	5978	15
5981	f	5979	15
5982	f	5980	15
5983	f	5981	15
5984	f	5982	15
5985	f	5983	15
5986	f	5984	15
5987	f	5985	15
5988	f	5986	15
5989	f	5987	15
5990	f	5988	15
5991	f	5989	15
5992	f	5990	15
5993	f	5991	15
5994	f	5992	15
5995	f	5993	15
5996	f	5994	15
5997	f	5995	15
5998	f	5996	15
5999	f	5997	15
6000	f	5998	15
6001	f	5999	15
6002	f	6000	15
6003	f	6001	15
6004	f	6002	15
6005	f	6003	15
6006	f	6004	15
6007	f	6005	15
6008	f	6006	15
6009	f	6007	15
6010	f	6008	15
6011	f	6009	15
6012	f	6010	15
6013	f	6011	22
6014	f	6012	22
6015	f	6013	22
6016	f	6014	22
6017	f	6015	22
6018	f	6016	22
6019	f	6017	22
6020	f	6018	22
6021	f	6019	31
6022	f	6020	31
6023	f	6021	31
6024	f	6022	31
6025	f	6023	31
6026	f	6024	31
6027	f	6025	18
6028	f	6026	18
6029	f	6027	18
6030	f	6028	18
6031	f	6029	20
6032	f	6030	20
6033	f	6031	20
6034	f	6032	20
6035	f	6033	20
6036	f	6034	20
6037	f	6035	20
6038	f	6036	20
6039	f	6037	20
6040	f	6038	20
12635	t	12633	32
12636	t	12634	32
12637	t	12635	32
12638	t	12636	32
12639	t	12637	32
12640	t	12638	32
12641	t	12639	32
12642	t	12640	32
12643	t	12643	32
12644	t	12644	32
12645	t	12645	32
12646	t	12646	32
12647	t	12647	32
12648	t	12648	32
12649	t	12649	32
12650	t	12650	32
12651	t	12651	32
12652	t	12652	32
12653	t	12653	32
12654	t	12654	32
12655	t	12641	32
12656	t	12642	32
12657	t	12655	32
12658	t	12656	32
12659	t	12657	32
12660	t	12658	32
12661	t	12659	32
12662	t	12660	32
12663	t	12661	32
12664	t	12662	32
12665	t	12663	32
12666	t	12665	32
12667	t	12666	32
12668	t	12664	32
\.


--
-- Name: backend_esrulemeta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_esrulemeta_id_seq', 12668, true);


--
-- Data for Name: backend_inputparam; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_inputparam (parameter_ptr_id, inputtype) FROM stdin;
27	stxt
28	int
31	int
32	stxt
34	stxt
35	stxt
37	stxt
\.


--
-- Data for Name: backend_metaparam; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_metaparam (parameter_ptr_id, is_event) FROM stdin;
50	f
52	t
55	f
57	t
\.


--
-- Data for Name: backend_parameter; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_parameter (id, name, type, cap_id) FROM stdin;
3	color	set	6
17	weather	set	18
11	frequency	range	12
24	time	time	26
25	value	bin	27
26	value	bin	28
28	quantity	input	30
30	topping	set	31
31	quantity	input	31
33	distance	range	32
34	item	input	33
35	name	input	35
36	channel	range	36
37	name	input	37
39	cups	range	39
40	value	bin	40
50	trigger	meta	49
51	time	duration	49
52	trigger	meta	50
53	time	duration	50
54	occurrences	range	50
55	trigger	meta	51
56	time	duration	51
57	trigger	meta	52
58	time	duration	52
69	BPM	range	62
71	who	set	63
27	item	input	30
73	cups	range	38
74	temperature	range	65
18	temperature	range	19
21	temperature	range	21
29	size	set	31
75	temperature	range	66
70	location	set	63
32	trackingid	input	32
1	setting	bin	2
2	level	range	3
7	level	range	8
8	genre	set	9
12	setting	bin	13
13	position	bin	14
20	condition	bin	20
23	time	time	25
14	status	bin	15
62	time	bin	55
64	setting	bin	57
65	position	bin	58
66	condition	bin	59
67	position	bin	60
68	status	bin	61
72	setting	bin	64
77	illuminance	range	68
78	setting	bin	69
79	who	set	70
80	location	set	70
\.


--
-- Name: backend_parameter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_parameter_id_seq', 80, true);


--
-- Data for Name: backend_parval; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_parval (id, val, par_id, state_id) FROM stdin;
\.


--
-- Name: backend_parval_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_parval_id_seq', 1, false);


--
-- Data for Name: backend_rangeparam; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_rangeparam (parameter_ptr_id, min, max, "interval") FROM stdin;
2	1	5	1
7	0	100	1
11	88	108	0.100000000000000006
18	-50	120	1
21	60	90	1
33	1	250	1
36	0	2000	1
39	1	5	1
54	0	25	1
69	40	220	5
73	0	5	1
74	0	600	5
75	20	60	1
77	0	500	1
\.


--
-- Data for Name: backend_rule; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_rule (id, task, version, lastedit, type, owner_id) FROM stdin;
1	7404506	0	2020-01-12 00:54:26.7671+00	es	240
2	7404506	0	2020-01-12 00:56:54.557789+00	es	240
3	7404506	0	2020-01-12 00:59:24.023861+00	es	240
4	7404506	0	2020-01-12 00:59:50.962637+00	es	240
5	7404506	0	2020-01-12 01:00:25.206277+00	es	240
6	7404506	0	2020-01-12 01:01:29.514627+00	es	240
7	7404506	1	2020-01-12 01:04:21.176997+00	es	240
8	7404506	1	2020-01-12 01:04:57.941598+00	es	240
9	7404506	1	2020-01-12 01:05:26.60268+00	es	240
10	7404506	1	2020-01-12 01:05:57.42748+00	es	240
11	7404506	1	2020-01-12 01:06:35.819481+00	es	240
12	7404506	1	2020-01-12 01:07:21.041224+00	es	240
13	7404506	1	2020-01-12 01:07:41.489444+00	es	240
53	628	0	2020-01-12 22:02:17.9901+00	es	240
54	628	0	2020-01-12 22:02:58.343199+00	es	240
55	628	0	2020-01-12 22:03:40.002679+00	es	240
56	628	0	2020-01-12 22:04:37.14722+00	es	240
57	628	0	2020-01-12 22:05:15.759649+00	es	240
58	628	0	2020-01-12 22:05:52.716849+00	es	240
59	628	1	2020-01-12 22:08:12.446348+00	es	240
60	628	1	2020-01-12 22:08:12.54855+00	es	240
62	628	1	2020-01-12 22:08:12.686876+00	es	240
63	628	1	2020-01-12 22:08:12.762285+00	es	240
64	628	1	2020-01-12 22:08:12.842254+00	es	240
61	628	1	2020-01-12 22:09:58.091462+00	es	240
71	628	1	2020-01-12 22:10:32.616315+00	es	240
72	628	1	2020-01-12 22:19:52.235869+00	es	240
73	628	1	2020-01-12 22:20:31.121139+00	es	240
74	628	3	2020-01-12 22:23:51.416814+00	es	240
75	628	3	2020-01-12 22:23:51.484559+00	es	240
76	628	3	2020-01-12 22:23:51.555899+00	es	240
77	628	3	2020-01-12 22:23:51.61965+00	es	240
78	628	3	2020-01-12 22:23:51.689488+00	es	240
79	628	3	2020-01-12 22:23:51.782769+00	es	240
80	628	3	2020-01-12 22:23:51.870757+00	es	240
81	628	3	2020-01-12 22:23:51.980068+00	es	240
82	628	3	2020-01-12 22:23:52.063838+00	es	240
83	628	2	2020-01-12 22:24:41.219254+00	es	240
84	628	2	2020-01-12 22:24:41.281525+00	es	240
85	628	2	2020-01-12 22:28:54.26751+00	es	240
87	628	2	2020-01-12 22:32:08.644637+00	es	240
88	628	2	2020-01-12 22:33:01.138804+00	es	240
86	628	2	2020-01-12 22:33:39.755244+00	es	240
92	573	1	2020-01-13 19:09:35.691592+00	es	240
93	573	1	2020-01-13 19:09:35.692293+00	es	240
94	573	1	2020-01-13 19:09:35.803981+00	es	240
95	573	2	2020-01-13 19:09:35.807912+00	es	240
96	573	2	2020-01-13 19:09:35.901192+00	es	240
97	573	3	2020-01-13 19:09:35.903333+00	es	240
98	573	2	2020-01-13 19:09:35.90686+00	es	240
99	573	3	2020-01-13 19:09:35.92403+00	es	240
100	573	3	2020-01-13 19:09:35.957035+00	es	240
101	573	4	2020-01-13 19:09:36.09499+00	es	240
102	573	4	2020-01-13 19:09:36.113736+00	es	240
103	573	4	2020-01-13 19:09:36.121288+00	es	240
104	573	5	2020-01-13 19:09:36.140815+00	es	240
105	573	5	2020-01-13 19:09:36.185387+00	es	240
106	573	5	2020-01-13 19:09:36.2977+00	es	240
107	573	6	2020-01-13 19:09:36.331642+00	es	240
108	573	6	2020-01-13 19:09:36.335965+00	es	240
109	573	6	2020-01-13 19:09:36.338145+00	es	240
110	573	7	2020-01-13 19:09:36.378591+00	es	240
111	573	7	2020-01-13 19:09:36.524983+00	es	240
112	573	7	2020-01-13 19:09:36.534802+00	es	240
113	573	8	2020-01-13 19:09:36.53882+00	es	240
114	573	8	2020-01-13 19:09:36.542809+00	es	240
115	573	8	2020-01-13 19:09:36.560044+00	es	240
116	573	9	2020-01-13 19:09:36.739987+00	es	240
117	573	9	2020-01-13 19:09:36.745875+00	es	240
118	573	9	2020-01-13 19:09:36.746449+00	es	240
119	573	10	2020-01-13 19:09:36.76414+00	es	240
120	573	10	2020-01-13 19:09:36.791317+00	es	240
121	573	10	2020-01-13 19:09:36.947963+00	es	240
122	573	11	2020-01-13 19:09:36.956464+00	es	240
123	573	11	2020-01-13 19:09:36.983616+00	es	240
124	573	11	2020-01-13 19:09:37.005756+00	es	240
125	573	12	2020-01-13 19:09:37.037219+00	es	240
126	573	12	2020-01-13 19:09:37.179941+00	es	240
127	573	12	2020-01-13 19:09:37.218987+00	es	240
128	573	13	2020-01-13 19:09:37.230533+00	es	240
129	573	13	2020-01-13 19:09:37.252734+00	es	240
130	573	13	2020-01-13 19:09:37.264295+00	es	240
131	573	14	2020-01-13 19:09:37.435779+00	es	240
132	573	14	2020-01-13 19:09:37.438646+00	es	240
133	573	14	2020-01-13 19:09:37.463749+00	es	240
134	573	15	2020-01-13 19:09:37.473958+00	es	240
135	573	15	2020-01-13 19:09:37.475632+00	es	240
136	573	15	2020-01-13 19:09:37.642886+00	es	240
137	573	16	2020-01-13 19:09:37.66777+00	es	240
138	573	16	2020-01-13 19:09:37.668346+00	es	240
139	573	16	2020-01-13 19:09:37.680969+00	es	240
140	573	17	2020-01-13 19:09:37.681444+00	es	240
141	573	17	2020-01-13 19:09:37.861563+00	es	240
142	573	17	2020-01-13 19:09:37.869821+00	es	240
143	573	18	2020-01-13 19:09:37.888232+00	es	240
144	573	18	2020-01-13 19:09:37.919285+00	es	240
145	573	19	2020-01-13 19:09:37.92155+00	es	240
146	573	18	2020-01-13 19:09:37.925772+00	es	240
147	573	19	2020-01-13 19:09:38.139905+00	es	240
148	573	19	2020-01-13 19:09:38.140515+00	es	240
149	573	20	2020-01-13 19:09:38.149241+00	es	240
150	573	20	2020-01-13 19:09:38.166555+00	es	240
151	573	21	2020-01-13 19:09:38.203401+00	es	240
152	573	20	2020-01-13 19:09:38.222331+00	es	240
153	573	21	2020-01-13 19:09:38.352933+00	es	240
154	573	21	2020-01-13 19:09:38.381159+00	es	240
155	573	22	2020-01-13 19:09:38.426019+00	es	240
156	573	22	2020-01-13 19:09:38.438486+00	es	240
157	573	22	2020-01-13 19:09:38.450532+00	es	240
158	573	23	2020-01-13 19:09:38.472651+00	es	240
159	573	23	2020-01-13 19:09:38.622649+00	es	240
160	573	23	2020-01-13 19:09:38.642097+00	es	240
161	573	24	2020-01-13 19:09:38.691251+00	es	240
162	573	24	2020-01-13 19:09:38.692367+00	es	240
163	573	24	2020-01-13 19:09:38.696519+00	es	240
164	573	25	2020-01-13 19:09:38.712042+00	es	240
165	573	25	2020-01-13 19:09:38.856518+00	es	240
166	573	25	2020-01-13 19:09:38.880085+00	es	240
167	573	26	2020-01-13 19:09:38.926375+00	es	240
168	573	26	2020-01-13 19:09:38.943474+00	es	240
169	573	26	2020-01-13 19:09:38.955284+00	es	240
170	573	27	2020-01-13 19:09:39.007438+00	es	240
171	573	27	2020-01-13 19:09:39.113583+00	es	240
172	573	27	2020-01-13 19:09:39.146482+00	es	240
173	400	1	2020-01-14 00:09:00.047212+00	es	240
174	400	1	2020-01-14 00:09:00.049466+00	es	240
175	400	1	2020-01-14 00:09:00.049979+00	es	240
176	400	1	2020-01-14 00:09:00.050494+00	es	240
177	400	1	2020-01-14 00:09:00.061343+00	es	240
178	400	2	2020-01-14 00:09:00.284253+00	es	240
179	400	2	2020-01-14 00:09:00.322893+00	es	240
180	400	2	2020-01-14 00:09:00.327719+00	es	240
181	400	2	2020-01-14 00:09:00.329218+00	es	240
182	400	2	2020-01-14 00:09:00.334298+00	es	240
209	123	7	2020-02-01 18:51:46.817525+00	es	240
210	123	7	2020-02-01 18:51:46.871079+00	es	240
211	123	7	2020-02-01 18:51:46.944178+00	es	240
212	123	7	2020-02-01 18:51:47.003883+00	es	240
213	123	7	2020-02-01 18:51:47.064824+00	es	240
214	123	0	2020-02-01 18:54:13.482729+00	es	240
215	123	0	2020-02-01 18:54:13.578519+00	es	240
216	123	0	2020-02-01 18:54:13.67165+00	es	240
217	123	0	2020-02-01 18:54:13.727665+00	es	240
218	123	0	2020-02-01 18:54:13.790474+00	es	240
219	123	0	2020-02-01 18:54:13.880799+00	es	240
221	123	0	2020-02-01 18:54:14.074247+00	es	240
223	123	0	2020-02-01 18:54:14.277381+00	es	240
224	123	0	2020-02-01 18:57:44.931097+00	es	240
225	123	0	2020-02-01 18:58:01.538817+00	es	240
234	123	1	2020-02-01 19:03:17.997171+00	es	240
235	123	1	2020-02-01 19:03:18.071991+00	es	240
236	123	1	2020-02-01 19:03:18.139975+00	es	240
237	123	1	2020-02-01 19:03:18.214836+00	es	240
238	123	1	2020-02-01 19:03:18.274311+00	es	240
239	123	1	2020-02-01 19:03:18.35606+00	es	240
240	123	1	2020-02-01 19:03:18.434705+00	es	240
241	123	1	2020-02-01 19:03:18.5015+00	es	240
242	123	2	2020-02-01 19:07:40.719466+00	es	240
243	123	2	2020-02-01 19:07:40.776301+00	es	240
244	123	2	2020-02-01 19:07:40.839307+00	es	240
245	123	2	2020-02-01 19:07:40.921301+00	es	240
246	123	2	2020-02-01 19:07:41.002002+00	es	240
247	123	2	2020-02-01 19:07:41.065598+00	es	240
248	123	2	2020-02-01 19:07:41.123893+00	es	240
249	123	2	2020-02-01 19:07:41.198952+00	es	240
250	3	0	2020-02-01 19:10:46.607744+00	es	240
251	3	0	2020-02-01 19:10:46.660689+00	es	240
252	3	0	2020-02-01 19:10:46.740502+00	es	240
253	3	0	2020-02-01 19:10:46.803724+00	es	240
254	3	0	2020-02-01 19:10:46.86639+00	es	240
255	3	0	2020-02-01 19:10:46.928545+00	es	240
256	3	0	2020-02-01 19:10:46.993958+00	es	240
257	3	0	2020-02-01 19:10:47.070653+00	es	240
258	3	0	2020-02-01 19:10:47.150469+00	es	240
259	3	0	2020-02-01 19:10:47.240804+00	es	240
260	3	1	2020-02-01 19:10:48.338329+00	es	240
261	3	1	2020-02-01 19:10:48.392346+00	es	240
263	3	1	2020-02-01 19:10:48.577908+00	es	240
264	3	1	2020-02-01 19:10:48.65253+00	es	240
265	3	1	2020-02-01 19:10:48.726433+00	es	240
267	3	1	2020-02-01 19:10:48.862531+00	es	240
276	6	0	2020-02-01 19:45:59.399298+00	es	240
277	6	0	2020-02-01 19:46:14.890308+00	es	240
280	6	0	2020-02-01 19:49:56.858226+00	es	240
281	6	0	2020-02-01 19:50:26.436856+00	es	240
283	6	1	2020-02-01 19:53:19.410469+00	es	240
284	6	1	2020-02-01 19:53:38.036352+00	es	240
285	6	1	2020-02-01 19:54:01.939475+00	es	240
286	6	1	2020-02-01 19:54:35.349264+00	es	240
287	6	1	2020-02-01 19:55:13.781615+00	es	240
288	6	1	2020-02-01 19:55:47.024939+00	es	240
289	6	1	2020-02-01 19:56:11.237463+00	es	240
290	6	1	2020-02-01 19:56:47.965031+00	es	240
291	6	1	2020-02-01 19:57:10.490137+00	es	240
301	8	1	2020-02-01 20:11:01.188959+00	es	240
302	8	1	2020-02-01 20:11:01.192535+00	es	240
303	8	1	2020-02-01 20:11:01.19321+00	es	240
304	8	1	2020-02-01 20:11:01.363876+00	es	240
305	8	2	2020-02-01 20:11:01.372075+00	es	240
306	8	2	2020-02-01 20:11:01.37526+00	es	240
307	8	2	2020-02-01 20:11:01.521712+00	es	240
308	8	2	2020-02-01 20:11:01.528685+00	es	240
309	8	3	2020-02-01 20:11:01.549558+00	es	240
310	8	3	2020-02-01 20:11:01.690549+00	es	240
311	8	3	2020-02-01 20:11:01.69491+00	es	240
312	8	3	2020-02-01 20:11:01.697827+00	es	240
313	8	4	2020-02-01 20:11:01.865908+00	es	240
314	8	4	2020-02-01 20:11:01.868011+00	es	240
315	8	4	2020-02-01 20:11:01.878322+00	es	240
316	8	4	2020-02-01 20:11:02.012437+00	es	240
317	8	5	2020-02-01 20:11:02.019831+00	es	240
318	8	5	2020-02-01 20:11:02.037599+00	es	240
319	8	5	2020-02-01 20:11:02.143312+00	es	240
320	8	5	2020-02-01 20:11:02.162413+00	es	240
321	8	6	2020-02-01 20:11:02.175012+00	es	240
322	8	6	2020-02-01 20:11:02.300092+00	es	240
323	8	6	2020-02-01 20:11:02.30188+00	es	240
324	8	6	2020-02-01 20:11:02.324593+00	es	240
325	8	7	2020-02-01 20:11:02.468549+00	es	240
326	8	7	2020-02-01 20:11:02.46914+00	es	240
327	8	7	2020-02-01 20:11:02.497454+00	es	240
328	8	7	2020-02-01 20:11:02.564822+00	es	240
329	8	8	2020-02-01 20:11:02.580871+00	es	240
330	8	8	2020-02-01 20:11:02.589526+00	es	240
331	8	8	2020-02-01 20:11:02.712155+00	es	240
332	8	8	2020-02-01 20:11:02.722052+00	es	240
333	8	9	2020-02-01 20:11:02.830955+00	es	240
334	8	9	2020-02-01 20:11:02.863084+00	es	240
335	8	9	2020-02-01 20:11:02.906116+00	es	240
336	8	9	2020-02-01 20:11:02.937643+00	es	240
337	8	10	2020-02-01 20:11:03.080016+00	es	240
338	8	10	2020-02-01 20:11:03.139653+00	es	240
339	8	10	2020-02-01 20:11:03.173752+00	es	240
340	8	11	2020-02-01 20:11:03.274194+00	es	240
341	8	10	2020-02-01 20:11:03.278957+00	es	240
342	8	11	2020-02-01 20:11:03.337939+00	es	240
343	8	11	2020-02-01 20:11:03.416748+00	es	240
344	8	11	2020-02-01 20:11:03.443922+00	es	240
345	8	12	2020-02-01 20:11:03.565844+00	es	240
346	8	12	2020-02-01 20:11:03.575589+00	es	240
347	8	12	2020-02-01 20:11:03.600145+00	es	240
348	8	12	2020-02-01 20:11:03.715302+00	es	240
349	8	13	2020-02-01 20:11:03.783745+00	es	240
350	8	13	2020-02-01 20:11:03.807657+00	es	240
351	8	13	2020-02-01 20:11:03.975678+00	es	240
352	8	13	2020-02-01 20:11:03.992809+00	es	240
353	8	14	2020-02-01 20:11:04.005175+00	es	240
354	8	14	2020-02-01 20:11:04.017674+00	es	240
355	8	14	2020-02-01 20:11:04.067114+00	es	240
356	8	14	2020-02-01 20:11:04.081041+00	es	240
357	8	15	2020-02-01 20:11:04.107675+00	es	240
358	8	15	2020-02-01 20:11:04.402516+00	es	240
359	8	15	2020-02-01 20:11:04.425919+00	es	240
360	8	15	2020-02-01 20:11:04.428224+00	es	240
266	3	1	2020-07-10 14:18:31.701871+00	es	240
361	8	16	2020-02-01 20:11:04.443399+00	es	240
362	8	16	2020-02-01 20:11:04.454846+00	es	240
363	8	16	2020-02-01 20:11:04.465168+00	es	240
364	8	16	2020-02-01 20:11:04.496843+00	es	240
365	7	1	2020-02-01 20:15:18.708866+00	es	240
366	7	1	2020-02-01 20:15:18.792212+00	es	240
367	7	1	2020-02-01 20:15:18.878543+00	es	240
368	7	2	2020-02-01 20:15:18.98842+00	es	240
369	7	2	2020-02-01 20:15:19.083192+00	es	240
370	7	2	2020-02-01 20:15:19.144377+00	es	240
371	7	3	2020-02-01 20:15:19.232816+00	es	240
372	7	3	2020-02-01 20:15:19.293546+00	es	240
373	7	3	2020-02-01 20:15:19.375307+00	es	240
374	7	4	2020-02-01 20:15:19.46798+00	es	240
375	7	4	2020-02-01 20:15:19.529031+00	es	240
376	7	4	2020-02-01 20:15:19.586497+00	es	240
377	7	5	2020-02-01 20:15:19.679175+00	es	240
378	7	5	2020-02-01 20:15:19.774342+00	es	240
379	7	5	2020-02-01 20:15:19.842199+00	es	240
380	7	6	2020-02-01 20:16:15.597473+00	es	240
381	7	6	2020-02-01 20:16:15.657955+00	es	240
382	7	6	2020-02-01 20:16:15.718187+00	es	240
383	7	7	2020-02-01 20:16:15.810551+00	es	240
384	7	7	2020-02-01 20:16:15.871753+00	es	240
385	7	7	2020-02-01 20:16:15.927346+00	es	240
386	7	8	2020-02-01 20:16:16.015583+00	es	240
387	7	8	2020-02-01 20:16:16.078011+00	es	240
388	7	8	2020-02-01 20:16:16.167148+00	es	240
389	7	9	2020-02-01 20:16:16.26147+00	es	240
390	7	9	2020-02-01 20:16:16.323979+00	es	240
391	7	9	2020-02-01 20:16:16.382216+00	es	240
392	7	10	2020-02-01 20:16:16.474028+00	es	240
393	7	10	2020-02-01 20:16:16.549036+00	es	240
394	7	10	2020-02-01 20:16:16.609733+00	es	240
395	7	11	2020-02-01 20:16:43.738702+00	es	240
396	7	11	2020-02-01 20:16:43.802952+00	es	240
397	7	11	2020-02-01 20:16:43.869227+00	es	240
398	7	12	2020-02-01 20:16:43.974544+00	es	240
399	7	12	2020-02-01 20:16:44.035454+00	es	240
400	7	12	2020-02-01 20:16:44.096479+00	es	240
401	7	13	2020-02-01 20:16:44.192431+00	es	240
402	7	13	2020-02-01 20:16:44.257863+00	es	240
403	7	13	2020-02-01 20:16:44.324974+00	es	240
404	7	14	2020-02-01 20:16:44.423779+00	es	240
405	7	14	2020-02-01 20:16:44.486869+00	es	240
406	7	14	2020-02-01 20:16:44.54633+00	es	240
407	7	15	2020-02-01 20:16:44.655992+00	es	240
408	7	15	2020-02-01 20:16:44.7316+00	es	240
409	7	15	2020-02-01 20:16:44.828072+00	es	240
410	7	16	2020-02-01 20:16:44.920801+00	es	240
411	7	16	2020-02-01 20:16:45.011492+00	es	240
412	7	16	2020-02-01 20:16:45.068779+00	es	240
413	7	17	2020-02-01 20:16:45.30772+00	es	240
414	7	17	2020-02-01 20:16:45.364285+00	es	240
415	7	17	2020-02-01 20:16:45.455843+00	es	240
416	7	18	2020-02-01 20:16:45.552821+00	es	240
417	7	18	2020-02-01 20:16:45.615621+00	es	240
418	7	18	2020-02-01 20:16:45.691171+00	es	240
419	7	19	2020-02-01 20:16:45.814558+00	es	240
420	7	19	2020-02-01 20:16:45.883656+00	es	240
421	7	19	2020-02-01 20:16:45.953464+00	es	240
422	7	20	2020-02-01 20:16:46.074557+00	es	240
423	7	20	2020-02-01 20:16:46.154573+00	es	240
424	7	20	2020-02-01 20:16:46.262157+00	es	240
425	7	21	2020-02-01 20:17:12.367307+00	es	240
426	7	21	2020-02-01 20:17:12.493019+00	es	240
427	7	21	2020-02-01 20:17:12.551568+00	es	240
428	7	22	2020-02-01 20:17:12.659613+00	es	240
429	7	22	2020-02-01 20:17:12.724545+00	es	240
430	7	22	2020-02-01 20:17:12.786458+00	es	240
431	7	23	2020-02-01 20:17:12.877892+00	es	240
432	7	23	2020-02-01 20:17:12.961392+00	es	240
433	7	23	2020-02-01 20:17:13.018775+00	es	240
434	7	24	2020-02-01 20:17:13.111139+00	es	240
435	7	24	2020-02-01 20:17:13.173291+00	es	240
436	7	24	2020-02-01 20:17:13.244097+00	es	240
437	7	25	2020-02-01 20:17:13.344099+00	es	240
438	7	25	2020-02-01 20:17:13.405175+00	es	240
439	7	25	2020-02-01 20:17:13.48712+00	es	240
440	7	26	2020-02-01 20:17:13.578884+00	es	240
441	7	26	2020-02-01 20:17:13.687392+00	es	240
442	7	26	2020-02-01 20:17:13.767219+00	es	240
443	7	27	2020-02-01 20:17:13.874239+00	es	240
444	7	27	2020-02-01 20:17:13.933006+00	es	240
445	7	27	2020-02-01 20:17:14.018916+00	es	240
447	5	0	2020-02-02 00:55:11.125817+00	es	240
452	5	1	2020-02-02 00:59:42.827961+00	es	240
460	5	1	2020-02-02 01:09:56.298223+00	es	240
462	5	2	2020-02-02 01:14:49.532572+00	es	240
472	5	2	2020-02-02 01:26:11.045505+00	es	240
474	628	2	2020-02-02 03:36:31.04278+00	es	240
475	628	2	2020-02-02 03:37:04.97237+00	es	240
476	628	2	2020-02-02 03:37:46.008034+00	es	240
477	4	0	2020-02-02 03:38:41.057816+00	es	240
478	4	0	2020-02-02 03:38:41.136444+00	es	240
480	4	0	2020-02-02 03:38:41.264653+00	es	240
481	4	0	2020-02-02 03:38:41.342248+00	es	240
482	4	0	2020-02-02 03:38:41.418113+00	es	240
483	4	1	2020-02-02 03:38:41.527707+00	es	240
484	4	1	2020-02-02 03:38:41.612706+00	es	240
485	4	1	2020-02-02 03:38:41.671052+00	es	240
486	4	1	2020-02-02 03:38:41.73604+00	es	240
487	4	1	2020-02-02 03:38:41.811341+00	es	240
492	4	2	2020-02-02 03:38:42.286451+00	es	240
493	4	2	2020-02-02 03:38:42.374828+00	es	240
494	4	2	2020-02-02 03:38:42.434196+00	es	240
498	4	2	2020-02-02 03:38:42.726498+00	es	240
499	4	2	2020-02-02 03:38:42.810044+00	es	240
500	4	2	2020-02-02 03:38:42.963217+00	es	240
495	4	2	2020-02-02 03:44:36.067801+00	es	240
496	4	2	2020-02-02 03:45:16.260792+00	es	240
497	4	2	2020-02-02 03:45:57.972859+00	es	240
501	2	0	2020-02-02 22:42:47.012048+00	es	240
502	2	0	2020-02-02 22:43:41.479182+00	es	240
505	2	0	2020-02-02 22:45:44.667394+00	es	240
506	2	2	2020-02-02 22:46:33.971765+00	es	240
507	2	2	2020-02-02 22:46:34.071291+00	es	240
518	2	1	2020-02-02 22:50:19.460635+00	es	240
504	2	0	2020-02-02 22:51:14.1165+00	es	240
524	2	1	2020-02-02 22:53:28.652121+00	es	240
525	2	1	2020-02-02 22:53:53.663037+00	es	240
526	2	1	2020-02-02 22:54:29.923156+00	es	240
527	2	2	2020-02-02 22:56:20.996538+00	es	240
528	2	2	2020-02-02 22:57:29.689124+00	es	240
456	5	1	2020-04-14 22:44:17.317231+00	es	240
458	5	1	2020-04-14 22:44:29.216135+00	es	240
470	5	2	2020-04-14 22:45:08.160626+00	es	240
529	2	2	2020-02-02 22:58:04.385026+00	es	240
531	555	0	2020-02-24 18:28:03.091932+00	es	240
532	555	0	2020-02-24 18:28:45.795318+00	es	240
533	555	1	2020-02-24 18:29:54.964294+00	es	240
534	555	1	2020-02-24 18:30:10.041832+00	es	240
536	556	0	2020-02-24 22:07:56.38259+00	es	240
538	556	1	2020-02-24 22:10:12.142288+00	es	240
539	666	0	2020-02-25 03:36:30.142094+00	es	240
540	666	0	2020-02-25 03:36:40.15118+00	es	240
541	666	1	2020-02-25 03:37:03.272722+00	es	240
542	666	1	2020-02-25 03:37:12.78199+00	es	240
519	2	1	2020-02-28 21:30:43.939967+00	es	240
192	1	0	2020-03-10 20:00:46.456084+00	es	240
543	456	0	2020-03-18 04:42:25.125118+00	es	240
544	456	0	2020-03-18 04:43:30.376462+00	es	240
546	456	1	2020-03-18 04:44:56.133399+00	es	240
278	6	0	2020-03-19 21:57:02.738114+00	es	240
279	6	0	2020-03-20 21:30:17.316542+00	es	240
548	6	0	2020-03-20 21:58:12.875918+00	es	240
549	6	0	2020-03-20 21:58:42.321202+00	es	240
551	1	1	2020-03-25 03:19:31.674594+00	es	240
488	4	1	2020-07-28 20:17:57.834042+00	es	240
535	556	0	2020-03-26 18:31:30.267293+00	es	240
537	556	1	2020-03-26 18:31:55.066757+00	es	240
449	5	0	2020-04-14 22:43:38.561165+00	es	240
468	5	2	2020-04-14 22:44:53.45341+00	es	240
558	5	0	2020-04-14 22:48:03.895225+00	es	240
559	5	0	2020-04-14 22:48:18.850464+00	es	240
186	1	1	2020-07-10 04:34:01.123537+00	es	240
552	1	1	2020-07-10 04:34:28.65736+00	es	240
193	1	0	2020-07-10 04:41:00.616141+00	es	240
196	1	0	2020-07-10 04:41:20.585375+00	es	240
550	1	0	2020-07-10 04:41:45.241293+00	es	240
805	0	0	2020-04-17 17:09:44.167485+00	es	240
806	0	1	2020-04-17 17:10:24.477611+00	es	240
807	0	0	2020-04-17 17:16:52.968513+00	es	240
804	0	1	2020-04-17 19:11:36.406493+00	es	240
803	0	0	2020-04-17 19:12:44.693465+00	es	240
812	777	0	2020-05-02 01:50:23.285669+00	es	240
810	777	1	2020-05-02 01:51:23.669987+00	es	240
813	777	0	2020-05-02 01:52:42.442708+00	es	240
809	777	1	2020-05-02 02:17:08.025643+00	es	240
814	777	1	2020-05-02 02:17:46.880482+00	es	240
815	888	0	2020-05-02 22:38:26.058437+00	es	240
816	888	1	2020-05-02 22:39:34.167001+00	es	240
817	888	1	2020-05-02 22:39:59.324395+00	es	240
820	889	0	2020-05-02 22:42:52.742839+00	es	240
821	889	0	2020-05-02 22:43:40.201289+00	es	240
822	889	1	2020-05-02 23:25:06.955334+00	es	240
824	887	0	2020-05-03 03:33:35.212052+00	es	240
826	887	1	2020-05-03 03:35:39.294867+00	es	240
827	886	0	2020-05-03 04:59:43.43387+00	es	240
819	889	1	2020-07-19 20:26:09.486599+00	es	240
829	886	1	2020-07-25 18:19:25.729543+00	es	240
1068	885	1	2020-05-05 19:20:23.466592+00	es	240
1069	885	1	2020-05-05 19:20:23.468293+00	es	240
1070	885	1	2020-05-05 19:20:23.47031+00	es	240
1072	885	2	2020-05-05 19:20:23.630027+00	es	240
1074	885	2	2020-05-05 19:20:23.745772+00	es	240
1076	885	0	2020-05-05 19:24:45.404116+00	es	240
1077	885	0	2020-05-05 19:25:08.082517+00	es	240
1078	885	0	2020-05-05 19:25:38.612517+00	es	240
1080	887	2	2020-07-09 16:09:02.883493+00	es	240
1073	885	2	2020-07-25 16:36:44.226721+00	es	240
1075	885	2	2020-07-25 16:41:07.127637+00	es	240
553	1	1	2020-07-10 04:34:52.337336+00	es	240
262	3	1	2020-07-10 14:17:28.11955+00	es	240
2295	3	1	2020-07-10 14:19:29.85135+00	es	240
2296	3	1	2020-07-10 14:20:22.877833+00	es	240
2543	3	1	2020-07-10 14:30:29.207887+00	es	240
2544	3	1	2020-07-10 14:31:08.377557+00	es	240
554	1	1	2020-07-12 01:42:03.444549+00	es	240
1079	887	2	2020-07-12 01:43:29.643324+00	es	240
825	887	1	2020-07-12 01:44:01.885165+00	es	240
818	889	1	2020-07-19 20:25:44.937475+00	es	240
4272	889	2	2020-07-19 20:27:53.619524+00	es	240
4273	889	2	2020-07-19 20:28:30.938383+00	es	240
4274	889	2	2020-07-19 20:28:50.486628+00	es	240
1071	885	1	2020-07-25 16:35:55.952583+00	es	240
4523	886	2	2020-07-25 18:18:47.53345+00	es	240
4524	886	2	2020-07-25 18:19:12.680954+00	es	240
4525	886	1	2020-07-25 18:20:01.945089+00	es	240
4801	4	0	2020-07-28 20:12:46.289206+00	es	240
4802	4	0	2020-07-28 20:13:39.527587+00	es	240
4803	4	0	2020-07-28 20:14:32.635367+00	es	240
4804	4	0	2020-07-28 20:15:26.349153+00	es	240
5080	880	1	2020-08-03 02:58:29.833049+00	es	240
5081	880	2	2020-08-03 02:58:29.836192+00	es	240
5082	880	1	2020-08-03 02:58:29.837444+00	es	240
5083	880	2	2020-08-03 02:58:29.838859+00	es	240
5084	880	3	2020-08-03 02:58:30.023354+00	es	240
5085	880	3	2020-08-03 02:58:30.029139+00	es	240
5086	880	4	2020-08-03 02:58:30.029977+00	es	240
5087	880	4	2020-08-03 02:58:30.033934+00	es	240
5088	881	1	2020-08-03 03:14:11.963594+00	es	240
5089	881	1	2020-08-03 03:14:11.965321+00	es	240
5090	881	2	2020-08-03 03:14:11.975087+00	es	240
5091	881	2	2020-08-03 03:14:11.979997+00	es	240
5092	881	3	2020-08-03 03:14:12.122513+00	es	240
5093	881	3	2020-08-03 03:14:12.128145+00	es	240
5094	881	4	2020-08-03 03:14:12.138738+00	es	240
5095	881	4	2020-08-03 03:14:12.142321+00	es	240
5096	9	0	2020-08-10 18:25:40.371643+00	es	240
5097	9	0	2020-08-10 18:26:49.278928+00	es	240
5098	9	0	2020-08-10 18:27:46.178465+00	es	240
5099	9	0	2020-08-10 18:28:43.569885+00	es	240
5100	9	0	2020-08-10 18:29:37.473465+00	es	240
5101	9	0	2020-08-10 18:30:45.232455+00	es	240
5102	9	1	2020-08-10 18:36:44.792004+00	es	240
5103	9	1	2020-08-10 18:38:26.346429+00	es	240
5104	9	1	2020-08-10 18:39:35.43109+00	es	240
5105	9	1	2020-08-10 18:42:33.726023+00	es	240
5107	9	1	2020-08-10 18:45:22.831671+00	es	240
5708	2	0	2020-08-10 19:20:37.57064+00	es	279
5709	2	0	2020-08-10 19:20:37.586499+00	es	279
5710	2	0	2020-08-10 19:20:37.598696+00	es	279
5711	2	2	2020-08-10 19:20:37.610523+00	es	279
5712	2	2	2020-08-10 19:20:37.621998+00	es	279
5713	2	1	2020-08-10 19:20:37.63357+00	es	279
5714	2	0	2020-08-10 19:20:37.644856+00	es	279
5715	2	1	2020-08-10 19:20:37.66359+00	es	279
5716	2	1	2020-08-10 19:20:37.699164+00	es	279
5717	2	1	2020-08-10 19:20:37.732577+00	es	279
5718	2	2	2020-08-10 19:20:37.750247+00	es	279
5719	2	2	2020-08-10 19:20:37.772438+00	es	279
5720	2	2	2020-08-10 19:20:37.806906+00	es	279
5721	2	1	2020-08-10 19:20:37.831409+00	es	279
5722	885	1	2020-08-10 19:20:37.849753+00	es	279
5723	885	1	2020-08-10 19:20:37.866481+00	es	279
5724	885	1	2020-08-10 19:20:37.883943+00	es	279
5725	885	1	2020-08-10 19:20:37.898346+00	es	279
5726	885	2	2020-08-10 19:20:37.911004+00	es	279
5727	885	2	2020-08-10 19:20:37.922985+00	es	279
5728	885	2	2020-08-10 19:20:37.934424+00	es	279
5729	885	2	2020-08-10 19:20:37.954127+00	es	279
5730	885	0	2020-08-10 19:20:37.987644+00	es	279
5731	885	0	2020-08-10 19:20:38.01086+00	es	279
5732	885	0	2020-08-10 19:20:38.043154+00	es	279
5733	888	0	2020-08-10 19:20:38.088332+00	es	279
5734	888	1	2020-08-10 19:20:38.114761+00	es	279
5735	888	1	2020-08-10 19:20:38.12792+00	es	279
5736	6	0	2020-08-10 19:20:38.141166+00	es	279
5737	6	0	2020-08-10 19:20:38.15066+00	es	279
5738	6	0	2020-08-10 19:20:38.160342+00	es	279
5739	6	0	2020-08-10 19:20:38.170437+00	es	279
5740	6	1	2020-08-10 19:20:38.182682+00	es	279
5741	6	1	2020-08-10 19:20:38.19215+00	es	279
5742	6	1	2020-08-10 19:20:38.201814+00	es	279
5743	6	1	2020-08-10 19:20:38.213983+00	es	279
5744	6	1	2020-08-10 19:20:38.226368+00	es	279
5745	6	1	2020-08-10 19:20:38.238814+00	es	279
5746	6	1	2020-08-10 19:20:38.258941+00	es	279
5747	6	1	2020-08-10 19:20:38.283457+00	es	279
5748	6	1	2020-08-10 19:20:38.309188+00	es	279
5749	6	0	2020-08-10 19:20:38.3339+00	es	279
5750	6	0	2020-08-10 19:20:38.358294+00	es	279
5751	6	0	2020-08-10 19:20:38.383176+00	es	279
5752	6	0	2020-08-10 19:20:38.407629+00	es	279
5753	886	0	2020-08-10 19:20:38.435795+00	es	279
5754	886	1	2020-08-10 19:20:38.450417+00	es	279
5755	886	1	2020-08-10 19:20:38.461596+00	es	279
5756	886	2	2020-08-10 19:20:38.472665+00	es	279
5757	886	2	2020-08-10 19:20:38.483906+00	es	279
5758	889	0	2020-08-10 19:20:38.518382+00	es	279
5759	889	0	2020-08-10 19:20:38.538872+00	es	279
5760	889	1	2020-08-10 19:20:38.548994+00	es	279
5761	889	1	2020-08-10 19:20:38.55814+00	es	279
5762	889	1	2020-08-10 19:20:38.56931+00	es	279
5763	889	2	2020-08-10 19:20:38.580679+00	es	279
5764	889	2	2020-08-10 19:20:38.591843+00	es	279
5765	889	2	2020-08-10 19:20:38.603076+00	es	279
5766	9	0	2020-08-10 19:20:38.613501+00	es	279
5767	9	0	2020-08-10 19:20:38.625125+00	es	279
5768	9	0	2020-08-10 19:20:38.635988+00	es	279
5769	9	0	2020-08-10 19:20:38.659653+00	es	279
5770	9	0	2020-08-10 19:20:38.675517+00	es	279
5771	9	0	2020-08-10 19:20:38.691655+00	es	279
5772	9	1	2020-08-10 19:20:38.710278+00	es	279
5773	9	1	2020-08-10 19:20:38.729246+00	es	279
5774	9	1	2020-08-10 19:20:38.748669+00	es	279
5775	9	1	2020-08-10 19:20:38.766531+00	es	279
5776	9	1	2020-08-10 19:20:38.791998+00	es	279
5777	9	1	2020-08-10 19:20:38.817829+00	es	279
5778	887	0	2020-08-10 19:20:38.846809+00	es	279
5779	887	1	2020-08-10 19:20:38.871169+00	es	279
5780	887	1	2020-08-10 19:20:38.891092+00	es	279
5781	887	2	2020-08-10 19:20:38.903711+00	es	279
5782	887	2	2020-08-10 19:20:38.914753+00	es	279
5783	880	1	2020-08-10 19:20:38.926799+00	es	279
5784	880	2	2020-08-10 19:20:38.937236+00	es	279
5785	880	1	2020-08-10 19:20:38.948274+00	es	279
5786	880	2	2020-08-10 19:20:38.959227+00	es	279
5787	880	3	2020-08-10 19:20:38.96959+00	es	279
5788	880	3	2020-08-10 19:20:38.980188+00	es	279
5789	880	4	2020-08-10 19:20:38.992024+00	es	279
5790	880	4	2020-08-10 19:20:39.00356+00	es	279
5791	881	1	2020-08-10 19:20:39.017043+00	es	279
5792	881	1	2020-08-10 19:20:39.028464+00	es	279
5793	881	2	2020-08-10 19:20:39.04029+00	es	279
5794	881	2	2020-08-10 19:20:39.051705+00	es	279
5795	881	3	2020-08-10 19:20:39.063079+00	es	279
5796	881	3	2020-08-10 19:20:39.074357+00	es	279
5797	881	4	2020-08-10 19:20:39.093532+00	es	279
5798	881	4	2020-08-10 19:20:39.126348+00	es	279
5799	1	0	2020-08-10 19:20:39.167836+00	es	279
5800	1	0	2020-08-10 19:20:39.196037+00	es	279
5801	1	0	2020-08-10 19:20:39.22852+00	es	279
5802	1	1	2020-08-10 19:20:39.245864+00	es	279
5803	1	1	2020-08-10 19:20:39.254803+00	es	279
5804	1	1	2020-08-10 19:20:39.264781+00	es	279
5805	1	1	2020-08-10 19:20:39.27515+00	es	279
5806	1	0	2020-08-10 19:20:39.295322+00	es	279
5807	1	1	2020-08-10 19:20:39.331631+00	es	279
5808	4	0	2020-08-10 19:20:39.35018+00	es	279
5809	4	0	2020-08-10 19:20:39.361793+00	es	279
5810	4	0	2020-08-10 19:20:39.372579+00	es	279
5811	4	0	2020-08-10 19:20:39.384265+00	es	279
5812	4	0	2020-08-10 19:20:39.395803+00	es	279
5813	4	1	2020-08-10 19:20:39.405642+00	es	279
5814	4	1	2020-08-10 19:20:39.415267+00	es	279
5815	4	1	2020-08-10 19:20:39.425412+00	es	279
5816	4	1	2020-08-10 19:20:39.434625+00	es	279
5817	4	1	2020-08-10 19:20:39.443549+00	es	279
5818	4	1	2020-08-10 19:20:39.45225+00	es	279
5819	4	2	2020-08-10 19:20:39.461584+00	es	279
5820	4	2	2020-08-10 19:20:39.470834+00	es	279
5821	4	2	2020-08-10 19:20:39.479688+00	es	279
5822	4	2	2020-08-10 19:20:39.488413+00	es	279
5823	4	2	2020-08-10 19:20:39.497426+00	es	279
5824	4	2	2020-08-10 19:20:39.514427+00	es	279
5825	4	2	2020-08-10 19:20:39.529303+00	es	279
5826	4	2	2020-08-10 19:20:39.54057+00	es	279
5827	4	2	2020-08-10 19:20:39.551315+00	es	279
5828	4	0	2020-08-10 19:20:39.563364+00	es	279
5829	4	0	2020-08-10 19:20:39.574274+00	es	279
5830	4	0	2020-08-10 19:20:39.58641+00	es	279
5831	4	0	2020-08-10 19:20:39.598201+00	es	279
5832	5	0	2020-08-10 19:20:39.611991+00	es	279
5833	5	1	2020-08-10 19:20:39.621212+00	es	279
5834	5	1	2020-08-10 19:20:39.629406+00	es	279
5835	5	2	2020-08-10 19:20:39.640652+00	es	279
5836	5	2	2020-08-10 19:20:39.649891+00	es	279
5837	5	1	2020-08-10 19:20:39.661399+00	es	279
5838	5	1	2020-08-10 19:20:39.673057+00	es	279
5839	5	2	2020-08-10 19:20:39.681667+00	es	279
5840	5	0	2020-08-10 19:20:39.692431+00	es	279
5841	5	2	2020-08-10 19:20:39.700538+00	es	279
5842	5	0	2020-08-10 19:20:39.70899+00	es	279
5843	5	0	2020-08-10 19:20:39.719495+00	es	279
5844	8	1	2020-08-10 19:20:39.735095+00	es	279
5845	8	1	2020-08-10 19:20:39.759103+00	es	279
5846	8	1	2020-08-10 19:20:39.799697+00	es	279
5847	8	1	2020-08-10 19:20:39.838019+00	es	279
5848	8	2	2020-08-10 19:20:39.858424+00	es	279
5849	8	2	2020-08-10 19:20:39.88476+00	es	279
5850	8	2	2020-08-10 19:20:39.924802+00	es	279
5851	8	2	2020-08-10 19:20:39.95131+00	es	279
5852	8	3	2020-08-10 19:20:39.964935+00	es	279
5853	8	3	2020-08-10 19:20:39.977033+00	es	279
5854	8	3	2020-08-10 19:20:39.989109+00	es	279
5855	8	3	2020-08-10 19:20:40.000664+00	es	279
5856	8	4	2020-08-10 19:20:40.025494+00	es	279
5857	8	4	2020-08-10 19:20:40.063928+00	es	279
5858	8	4	2020-08-10 19:20:40.079644+00	es	279
5859	8	4	2020-08-10 19:20:40.09204+00	es	279
5860	8	5	2020-08-10 19:20:40.104252+00	es	279
5861	8	5	2020-08-10 19:20:40.115104+00	es	279
5862	8	5	2020-08-10 19:20:40.127483+00	es	279
5863	8	5	2020-08-10 19:20:40.139735+00	es	279
5864	8	6	2020-08-10 19:20:40.151779+00	es	279
5865	8	6	2020-08-10 19:20:40.164193+00	es	279
5866	8	6	2020-08-10 19:20:40.185576+00	es	279
5867	8	6	2020-08-10 19:20:40.204924+00	es	279
5868	8	7	2020-08-10 19:20:40.21706+00	es	279
5869	8	7	2020-08-10 19:20:40.227918+00	es	279
5870	8	7	2020-08-10 19:20:40.238977+00	es	279
5871	8	7	2020-08-10 19:20:40.249092+00	es	279
5872	8	8	2020-08-10 19:20:40.2592+00	es	279
5873	8	8	2020-08-10 19:20:40.270233+00	es	279
5874	8	8	2020-08-10 19:20:40.280367+00	es	279
5875	8	8	2020-08-10 19:20:40.291352+00	es	279
5876	8	9	2020-08-10 19:20:40.301579+00	es	279
5877	8	9	2020-08-10 19:20:40.323579+00	es	279
5878	8	9	2020-08-10 19:20:40.364299+00	es	279
5879	8	9	2020-08-10 19:20:40.393878+00	es	279
5880	8	10	2020-08-10 19:20:40.408095+00	es	279
5881	8	10	2020-08-10 19:20:40.421003+00	es	279
5882	8	10	2020-08-10 19:20:40.433482+00	es	279
5883	8	11	2020-08-10 19:20:40.454917+00	es	279
5884	8	10	2020-08-10 19:20:40.48268+00	es	279
5885	8	11	2020-08-10 19:20:40.499002+00	es	279
5886	8	11	2020-08-10 19:20:40.514992+00	es	279
5887	8	11	2020-08-10 19:20:40.531199+00	es	279
5888	8	12	2020-08-10 19:20:40.547581+00	es	279
5889	8	12	2020-08-10 19:20:40.564044+00	es	279
5890	8	12	2020-08-10 19:20:40.579295+00	es	279
5891	8	12	2020-08-10 19:20:40.599654+00	es	279
5892	8	13	2020-08-10 19:20:40.622815+00	es	279
5893	8	13	2020-08-10 19:20:40.635334+00	es	279
5894	8	13	2020-08-10 19:20:40.646197+00	es	279
5895	8	13	2020-08-10 19:20:40.670478+00	es	279
5896	8	14	2020-08-10 19:20:40.683751+00	es	279
5897	8	14	2020-08-10 19:20:40.695376+00	es	279
5898	8	14	2020-08-10 19:20:40.706688+00	es	279
5899	8	14	2020-08-10 19:20:40.717871+00	es	279
5900	8	15	2020-08-10 19:20:40.728779+00	es	279
5901	8	15	2020-08-10 19:20:40.739983+00	es	279
5902	8	15	2020-08-10 19:20:40.751034+00	es	279
5903	8	15	2020-08-10 19:20:40.761548+00	es	279
5904	8	16	2020-08-10 19:20:40.773112+00	es	279
5905	8	16	2020-08-10 19:20:40.784381+00	es	279
5906	8	16	2020-08-10 19:20:40.796582+00	es	279
5907	8	16	2020-08-10 19:20:40.809173+00	es	279
5908	3	0	2020-08-10 19:20:40.823193+00	es	279
5909	3	0	2020-08-10 19:20:40.833211+00	es	279
5910	3	0	2020-08-10 19:20:40.843808+00	es	279
5911	3	0	2020-08-10 19:20:40.854939+00	es	279
5912	3	0	2020-08-10 19:20:40.865355+00	es	279
5913	3	0	2020-08-10 19:20:40.874831+00	es	279
5914	3	0	2020-08-10 19:20:40.884509+00	es	279
5915	3	0	2020-08-10 19:20:40.894577+00	es	279
5916	3	0	2020-08-10 19:20:40.904867+00	es	279
5917	3	0	2020-08-10 19:20:40.914475+00	es	279
5918	3	1	2020-08-10 19:20:40.921668+00	es	279
5919	3	1	2020-08-10 19:20:40.930805+00	es	279
5920	3	1	2020-08-10 19:20:40.940192+00	es	279
5921	3	1	2020-08-10 19:20:40.949714+00	es	279
5922	3	1	2020-08-10 19:20:40.960872+00	es	279
5923	3	1	2020-08-10 19:20:40.994915+00	es	279
5924	3	1	2020-08-10 19:20:41.010132+00	es	279
5925	3	1	2020-08-10 19:20:41.02214+00	es	279
5926	3	1	2020-08-10 19:20:41.033719+00	es	279
5927	3	1	2020-08-10 19:20:41.045091+00	es	279
5928	3	1	2020-08-10 19:20:41.056171+00	es	279
5929	3	1	2020-08-10 19:20:41.076924+00	es	279
5930	7	1	2020-08-10 19:20:41.09441+00	es	279
5931	7	1	2020-08-10 19:20:41.108102+00	es	279
5932	7	1	2020-08-10 19:20:41.122028+00	es	279
5933	7	2	2020-08-10 19:20:41.135535+00	es	279
5934	7	2	2020-08-10 19:20:41.149244+00	es	279
5935	7	2	2020-08-10 19:20:41.163224+00	es	279
5936	7	3	2020-08-10 19:20:41.177545+00	es	279
5937	7	3	2020-08-10 19:20:41.190287+00	es	279
5938	7	3	2020-08-10 19:20:41.203187+00	es	279
5939	7	4	2020-08-10 19:20:41.213414+00	es	279
5940	7	4	2020-08-10 19:20:41.222397+00	es	279
5941	7	4	2020-08-10 19:20:41.231418+00	es	279
5942	7	5	2020-08-10 19:20:41.240483+00	es	279
5943	7	5	2020-08-10 19:20:41.250008+00	es	279
5944	7	5	2020-08-10 19:20:41.259744+00	es	279
5945	7	6	2020-08-10 19:20:41.270938+00	es	279
5946	7	6	2020-08-10 19:20:41.282088+00	es	279
5947	7	6	2020-08-10 19:20:41.29312+00	es	279
5948	7	7	2020-08-10 19:20:41.304451+00	es	279
5949	7	7	2020-08-10 19:20:41.31573+00	es	279
5950	7	7	2020-08-10 19:20:41.326937+00	es	279
5951	7	8	2020-08-10 19:20:41.338538+00	es	279
5952	7	8	2020-08-10 19:20:41.349735+00	es	279
5953	7	8	2020-08-10 19:20:41.360503+00	es	279
5954	7	9	2020-08-10 19:20:41.372146+00	es	279
5955	7	9	2020-08-10 19:20:41.383177+00	es	279
5956	7	9	2020-08-10 19:20:41.394598+00	es	279
5957	7	10	2020-08-10 19:20:41.406024+00	es	279
5958	7	10	2020-08-10 19:20:41.43084+00	es	279
5959	7	10	2020-08-10 19:20:41.443741+00	es	279
5960	7	11	2020-08-10 19:20:41.454668+00	es	279
5961	7	11	2020-08-10 19:20:41.465713+00	es	279
5962	7	11	2020-08-10 19:20:41.476494+00	es	279
5963	7	12	2020-08-10 19:20:41.487439+00	es	279
5964	7	12	2020-08-10 19:20:41.498328+00	es	279
5965	7	12	2020-08-10 19:20:41.509198+00	es	279
5966	7	13	2020-08-10 19:20:41.519961+00	es	279
5967	7	13	2020-08-10 19:20:41.530365+00	es	279
5968	7	13	2020-08-10 19:20:41.54218+00	es	279
5969	7	14	2020-08-10 19:20:41.555191+00	es	279
5970	7	14	2020-08-10 19:20:41.566889+00	es	279
5971	7	14	2020-08-10 19:20:41.578205+00	es	279
5972	7	15	2020-08-10 19:20:41.589988+00	es	279
5973	7	15	2020-08-10 19:20:41.602017+00	es	279
5974	7	15	2020-08-10 19:20:41.613914+00	es	279
5975	7	16	2020-08-10 19:20:41.626047+00	es	279
5976	7	16	2020-08-10 19:20:41.637199+00	es	279
5977	7	16	2020-08-10 19:20:41.648739+00	es	279
5978	7	17	2020-08-10 19:20:41.660207+00	es	279
5979	7	17	2020-08-10 19:20:41.672069+00	es	279
5980	7	17	2020-08-10 19:20:41.686417+00	es	279
5981	7	18	2020-08-10 19:20:41.700628+00	es	279
5982	7	18	2020-08-10 19:20:41.729722+00	es	279
5983	7	18	2020-08-10 19:20:41.745071+00	es	279
5984	7	19	2020-08-10 19:20:41.756898+00	es	279
5985	7	19	2020-08-10 19:20:41.76847+00	es	279
5986	7	19	2020-08-10 19:20:41.779653+00	es	279
5987	7	20	2020-08-10 19:20:41.801501+00	es	279
5988	7	20	2020-08-10 19:20:41.843038+00	es	279
5989	7	20	2020-08-10 19:20:41.872139+00	es	279
5990	7	21	2020-08-10 19:20:41.885957+00	es	279
5991	7	21	2020-08-10 19:20:41.89917+00	es	279
5992	7	21	2020-08-10 19:20:41.911923+00	es	279
5993	7	22	2020-08-10 19:20:41.924597+00	es	279
5994	7	22	2020-08-10 19:20:41.936879+00	es	279
5995	7	22	2020-08-10 19:20:41.949578+00	es	279
5996	7	23	2020-08-10 19:20:41.962611+00	es	279
5997	7	23	2020-08-10 19:20:41.975302+00	es	279
5998	7	23	2020-08-10 19:20:42.000088+00	es	279
5999	7	24	2020-08-10 19:20:42.033479+00	es	279
6000	7	24	2020-08-10 19:20:42.046655+00	es	279
6001	7	24	2020-08-10 19:20:42.058604+00	es	279
6002	7	25	2020-08-10 19:20:42.070398+00	es	279
6003	7	25	2020-08-10 19:20:42.082342+00	es	279
6004	7	25	2020-08-10 19:20:42.094968+00	es	279
6005	7	26	2020-08-10 19:20:42.119639+00	es	279
6006	7	26	2020-08-10 19:20:42.139027+00	es	279
6007	7	26	2020-08-10 19:20:42.155799+00	es	279
6008	7	27	2020-08-10 19:20:42.171856+00	es	279
6009	7	27	2020-08-10 19:20:42.187546+00	es	279
6010	7	27	2020-08-10 19:20:42.204229+00	es	279
6011	6	0	2020-08-10 19:20:48.043531+00	es	280
6012	6	0	2020-08-10 19:20:48.053076+00	es	280
6013	6	0	2020-08-10 19:20:48.06151+00	es	280
6014	6	0	2020-08-10 19:20:48.06901+00	es	280
6015	6	0	2020-08-10 19:20:48.079076+00	es	280
6016	6	0	2020-08-10 19:20:48.105505+00	es	280
6017	6	0	2020-08-10 19:20:48.127611+00	es	280
6018	6	0	2020-08-10 19:20:48.146197+00	es	280
6019	9	0	2020-08-10 19:20:48.170778+00	es	280
6020	9	0	2020-08-10 19:20:48.185029+00	es	280
6021	9	0	2020-08-10 19:20:48.197208+00	es	280
6022	9	0	2020-08-10 19:20:48.208503+00	es	280
6023	9	0	2020-08-10 19:20:48.219798+00	es	280
6024	9	0	2020-08-10 19:20:48.238402+00	es	280
6025	1	0	2020-08-10 19:20:48.263226+00	es	280
6026	1	0	2020-08-10 19:20:48.274599+00	es	280
6027	1	0	2020-08-10 19:20:48.289464+00	es	280
6028	1	0	2020-08-10 19:20:48.30488+00	es	280
6029	3	0	2020-08-10 19:20:48.327208+00	es	280
6030	3	0	2020-08-10 19:20:48.343099+00	es	280
6031	3	0	2020-08-10 19:20:48.358446+00	es	280
6032	3	0	2020-08-10 19:20:48.383557+00	es	280
6033	3	0	2020-08-10 19:20:48.400969+00	es	280
6034	3	0	2020-08-10 19:20:48.414253+00	es	280
6035	3	0	2020-08-10 19:20:48.427917+00	es	280
6036	3	0	2020-08-10 19:20:48.441232+00	es	280
6037	3	0	2020-08-10 19:20:48.455561+00	es	280
6038	3	0	2020-08-10 19:20:48.466198+00	es	280
5106	9	1	2020-08-10 19:25:33.042253+00	es	240
12633	12	0	2020-08-14 18:31:11.65722+00	es	240
12634	12	0	2020-08-14 18:32:33.08131+00	es	240
12635	12	0	2020-08-14 18:33:37.806757+00	es	240
12636	12	0	2020-08-14 18:34:53.060582+00	es	240
12637	12	0	2020-08-14 18:36:15.260191+00	es	240
12638	12	0	2020-08-14 18:39:59.794957+00	es	240
12639	12	0	2020-08-14 18:41:34.092712+00	es	240
12640	12	0	2020-08-14 18:42:49.925425+00	es	240
12643	12	2	2020-08-14 20:07:02.629724+00	es	240
12644	12	2	2020-08-14 20:08:08.789652+00	es	240
12645	12	2	2020-08-14 20:09:06.917538+00	es	240
12646	12	2	2020-08-14 20:09:55.120605+00	es	240
12647	12	2	2020-08-14 20:10:53.94494+00	es	240
12648	12	2	2020-08-14 20:12:16.195669+00	es	240
12649	12	2	2020-08-14 20:13:05.917949+00	es	240
12650	12	2	2020-08-14 20:14:02.818578+00	es	240
12651	12	2	2020-08-14 20:15:00.253064+00	es	240
12652	12	2	2020-08-14 20:15:58.45912+00	es	240
12653	12	2	2020-08-14 20:17:02.472485+00	es	240
12654	12	2	2020-08-14 20:17:53.187799+00	es	240
12641	12	0	2020-08-14 20:19:20.049965+00	es	240
12642	12	0	2020-08-14 20:19:34.033052+00	es	240
12655	12	1	2020-08-14 20:47:25.956076+00	es	240
12656	12	1	2020-08-14 20:48:22.023467+00	es	240
12657	12	1	2020-08-14 20:56:07.094393+00	es	240
12658	12	1	2020-08-14 20:57:07.214382+00	es	240
12659	12	1	2020-08-14 20:57:53.933696+00	es	240
12660	12	1	2020-08-14 20:58:59.494421+00	es	240
12661	12	1	2020-08-14 20:59:50.262856+00	es	240
12662	12	1	2020-08-14 21:01:21.644959+00	es	240
12663	12	1	2020-08-14 21:06:48.28205+00	es	240
12665	12	1	2020-08-14 21:09:35.211164+00	es	240
12666	12	1	2020-08-14 21:10:29.331305+00	es	240
12664	12	1	2020-08-14 21:50:46.157187+00	es	240
\.


--
-- Name: backend_rule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_rule_id_seq', 12666, true);


--
-- Data for Name: backend_safetyprop; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_safetyprop (id, task, lastedit, type, always, owner_id) FROM stdin;
1	629	2020-01-13 16:12:44.069844+00	2	t	241
2	629	2020-01-13 16:13:11.792393+00	2	t	241
3	629	2020-01-13 16:13:37.435085+00	2	t	241
4	932	2020-01-13 16:25:01.303129+00	2	t	241
5	573	2020-01-13 19:09:25.283474+00	2	t	241
6	400	2020-01-14 00:04:23.584643+00	2	t	241
7	400	2020-01-14 00:05:32.214871+00	2	f	241
8	400	2020-01-14 00:07:37.534943+00	2	f	241
9	401	2020-01-14 00:20:09.049553+00	1	f	241
10	401	2020-01-14 00:21:06.134905+00	1	f	241
12	934	2020-01-27 17:36:53.280952+00	2	t	241
14	935	2020-01-27 18:22:47.120278+00	2	f	241
13	935	2020-01-27 18:23:55.989411+00	2	f	241
15	937	2020-01-27 19:29:40.977989+00	2	t	241
16	8	2020-02-01 20:10:45.235275+00	2	t	241
19	777	2020-05-02 01:46:32.975903+00	1	f	241
20	885	2020-05-05 19:17:36.853825+00	2	t	241
21	885	2020-05-05 19:19:20.806663+00	3	f	241
24	880	2020-08-03 02:58:00.077308+00	1	f	241
25	881	2020-08-03 03:14:07.232794+00	1	f	241
\.


--
-- Name: backend_safetyprop_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_safetyprop_id_seq', 25, true);


--
-- Data for Name: backend_setparam; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_setparam (parameter_ptr_id, numopts) FROM stdin;
3	6
8	7
17	8
29	3
30	8
70	5
71	3
79	3
80	5
\.


--
-- Data for Name: backend_setparamopt; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_setparamopt (id, value, param_id) FROM stdin;
1	Red	3
2	Orange	3
3	Yellow	3
4	Green	3
5	Blue	3
6	Violet	3
7	Pop	8
8	Jazz	8
9	R&B	8
10	Hip-Hop	8
11	Rap	8
12	Country	8
13	News	8
14	Sunny	17
15	Cloudy	17
16	Partly Cloudy	17
17	Raining	17
18	Thunderstorms	17
19	Snowing	17
20	Hailing	17
21	Clear	17
24	Small	29
25	Medium	29
26	Large	29
27	No Toppings	30
28	Pepperoni	30
29	Vegetables	30
30	Sausage	30
31	Mushrooms	30
32	Ham & Pineapple	30
33	Extra Cheese	30
34	Anchovies	30
35	Home	70
36	Kitchen	70
37	Bedroom	70
38	Bathroom	70
39	Living Room	70
40	Anyone	71
41	Alice	71
42	Bobbie	71
44	A Family Member	71
43	A Guest	71
45	Nobody	71
46	Nobody	79
47	A Family Member	79
48	A Guest	79
49	Bobbie	79
50	Alice	79
51	Anyone	79
52	Living Room	80
53	Bathroom	80
54	Bedroom	80
55	Kitchen	80
56	Home	80
\.


--
-- Name: backend_setparamopt_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_setparamopt_id_seq', 56, true);


--
-- Data for Name: backend_sp1; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_sp1 (safetyprop_ptr_id) FROM stdin;
9
10
19
24
25
\.


--
-- Data for Name: backend_sp1_triggers; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_sp1_triggers (id, sp1_id, trigger_id) FROM stdin;
1	9	557
2	9	558
3	10	559
4	10	560
13	19	1701
14	19	1702
15	19	1703
20	24	1906
21	24	1907
22	25	1924
23	25	1925
\.


--
-- Name: backend_sp1_triggers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_sp1_triggers_id_seq', 23, true);


--
-- Data for Name: backend_sp2; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_sp2 (safetyprop_ptr_id, comp, "time", state_id) FROM stdin;
1	\N	\N	274
2	\N	\N	277
3	\N	\N	280
4	\N	\N	283
5	\N	\N	288
6	\N	\N	534
7	\N	\N	535
8	\N	\N	537
12	\N	\N	563
14	\N	\N	568
13	\N	\N	570
15	\N	\N	572
16	\N	\N	828
20	\N	\N	1773
\.


--
-- Data for Name: backend_sp2_conds; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_sp2_conds (id, sp2_id, trigger_id) FROM stdin;
1	1	275
2	1	276
3	2	278
4	2	279
5	3	281
6	3	282
7	4	284
8	4	285
9	4	286
10	4	287
11	5	289
12	5	290
13	7	536
14	8	538
15	12	564
16	12	565
18	14	569
19	13	571
20	15	573
21	15	574
22	16	829
23	16	830
24	16	831
25	20	1774
26	20	1775
\.


--
-- Name: backend_sp2_conds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_sp2_conds_id_seq', 26, true);


--
-- Data for Name: backend_sp3; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_sp3 (safetyprop_ptr_id, comp, occurrences, "time", timecomp, event_id) FROM stdin;
21	\N	\N	\N	\N	1776
\.


--
-- Data for Name: backend_sp3_conds; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_sp3_conds (id, sp3_id, trigger_id) FROM stdin;
1	21	1777
\.


--
-- Name: backend_sp3_conds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_sp3_conds_id_seq', 1, true);


--
-- Data for Name: backend_ssrule; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_ssrule (rule_ptr_id, priority, action_id) FROM stdin;
\.


--
-- Data for Name: backend_ssrule_triggers; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_ssrule_triggers (id, ssrule_id, trigger_id) FROM stdin;
\.


--
-- Name: backend_ssrule_triggers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_ssrule_triggers_id_seq', 1, false);


--
-- Data for Name: backend_state; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_state (id, action, text, cap_id, chan_id, dev_id) FROM stdin;
1	t	(Security Camera) start recording	28	10	10
2	t	(Security Camera) start recording	28	10	10
3	t	(Security Camera) stop recording	28	10	10
4	t	(Security Camera) start recording	28	10	10
5	t	(Security Camera) start recording	28	10	10
6	t	(Security Camera) stop recording	28	10	10
7	t	(Security Camera) start recording	28	10	10
8	t	(Security Camera) start recording	28	10	10
9	t	(Security Camera) start recording	28	10	10
10	t	(Security Camera) start recording	28	10	10
11	t	(Security Camera) start recording	28	10	10
12	t	(Security Camera) start recording	28	10	10
13	t	(Security Camera) start recording	28	10	10
28	t	(Security Camera) start recording	28	10	10
29	t	Turn Roomba Off	2	18	1
30	t	(Security Camera) start recording	28	10	10
33	t	(Security Camera) start recording	28	10	10
34	t	(Security Camera) start recording	28	10	10
44	t	Turn Roomba Off	2	18	1
54	t	Turn Roomba Off	2	18	1
60	t	Open Bedroom Window	14	5	14
61	t	Open Living Room Window	14	5	25
62	t	Open Living Room Window	14	5	25
63	t	Close Bedroom Window	14	5	14
64	t	Close Living Room Window	14	5	25
65	t	Close Bathroom Window	14	5	24
66	t	Open Bedroom Window	14	5	14
67	t	Open Living Room Window	14	5	25
68	t	Open Living Room Window	14	5	25
69	t	Close Bedroom Window	14	5	14
70	t	Close Living Room Window	14	5	25
71	t	Close Bathroom Window	14	5	24
78	t	Open Living Room Window	14	5	25
79	t	Close Living Room Window	14	5	25
80	t	Close Bathroom Window	14	5	24
81	t	Close Bedroom Window	14	5	14
82	t	Open Bedroom Window	14	5	14
83	t	Open Living Room Window	14	5	25
84	t	Close Bedroom Window	14	5	14
85	t	Close Living Room Window	14	5	25
86	t	Close Bathroom Window	14	5	24
87	t	Open Living Room Window	14	5	25
88	t	Close Living Room Window	14	5	25
89	t	Close Bathroom Window	14	5	24
90	t	Close Bedroom Window	14	5	14
91	t	Open Bedroom Window	14	5	14
92	t	Open Living Room Window	14	5	25
93	t	Close Bedroom Window	14	5	14
94	t	Close Living Room Window	14	5	25
95	t	Close Bathroom Window	14	5	24
96	t	Open Living Room Window	14	5	25
100	t	Open Bathroom Window	14	5	24
101	t	Close Bedroom Window	14	5	14
102	t	Close Living Room Window	14	5	25
103	t	Close Bathroom Window	14	5	24
104	t	Close Bedroom Window	14	5	14
105	t	Close Living Room Window	14	5	25
106	t	Close Living Room Window	14	5	25
107	t	Close Living Room Window	14	5	25
108	t	Close Living Room Window	14	5	25
109	t	Close Living Room Window	14	5	25
110	t	Close Living Room Window	14	5	25
111	t	Turn Roomba Off	2	1	1
112	t	Close Living Room Window	14	5	25
113	t	Turn Smart TV Off	2	1	5
114	t	Close Living Room Window	14	5	25
115	t	Turn Roomba Off	2	1	1
116	t	Close Living Room Window	14	5	25
117	t	Close Living Room Window	14	5	25
118	t	Turn Roomba Off	2	1	1
119	t	Turn Roomba Off	2	1	1
120	t	Close Living Room Window	14	5	25
121	t	Turn Roomba Off	2	1	1
122	t	Turn Smart TV Off	2	1	5
123	t	Close Living Room Window	14	5	25
124	t	Turn Smart TV Off	2	1	5
125	t	Close Living Room Window	14	5	25
126	t	Close Living Room Window	14	5	25
127	t	Turn Smart TV Off	2	1	5
128	t	Turn Roomba Off	2	1	1
129	t	Close Living Room Window	14	5	25
130	t	Turn Smart TV Off	2	1	5
131	t	Turn Smart TV Off	2	1	5
132	t	Turn Roomba Off	2	1	1
133	t	Close Living Room Window	14	5	25
134	t	Close Living Room Window	14	5	25
135	t	Turn Roomba Off	2	1	1
136	t	Close Living Room Window	14	5	25
137	t	Turn Roomba Off	2	1	1
138	t	Turn Roomba Off	2	1	1
139	t	Close Living Room Window	14	5	25
140	t	Turn Smart TV Off	2	1	5
141	t	Turn Roomba Off	2	1	1
142	t	Turn Roomba Off	2	1	1
143	t	Close Living Room Window	14	5	25
144	t	Turn Roomba Off	2	1	1
145	t	Turn Roomba Off	2	1	1
146	t	Turn Roomba Off	2	1	1
147	t	Turn Roomba Off	2	1	1
148	t	Turn Roomba Off	2	1	1
149	t	Turn Smart TV Off	2	1	5
150	t	Turn Roomba Off	2	1	1
151	t	Turn Smart TV Off	2	1	5
152	t	Turn Roomba Off	2	1	1
153	t	Close Living Room Window	14	5	25
154	t	Turn Smart TV Off	2	1	5
155	t	Turn Roomba Off	2	1	1
156	t	Turn Roomba Off	2	1	1
157	t	Turn Smart TV Off	2	1	5
158	t	Turn Smart TV Off	2	1	5
159	t	Turn Smart TV Off	2	1	5
160	t	Close Living Room Window	14	5	25
161	t	Close Living Room Window	14	5	25
162	t	Turn Smart TV Off	2	1	5
163	t	Close Living Room Window	14	5	25
164	t	Turn Smart TV Off	2	1	5
165	t	Turn Roomba Off	2	1	1
166	t	Close Living Room Window	14	5	25
167	t	Turn Smart TV Off	2	1	5
168	t	Turn Smart TV Off	2	1	5
169	t	Turn Roomba Off	2	1	1
170	t	Close Living Room Window	14	5	25
171	t	Turn Smart TV Off	2	1	5
172	t	Turn Roomba Off	2	1	1
173	t	Turn Roomba Off	2	1	1
174	t	Turn Smart TV Off	2	1	5
175	t	Turn Roomba Off	2	1	1
176	t	Turn Smart TV Off	2	1	5
177	t	Turn Smart TV Off	2	1	5
178	t	Turn Smart TV Off	2	1	5
179	t	Close Living Room Window	14	5	25
180	t	Turn Smart TV Off	2	1	5
181	t	Turn Smart TV Off	2	1	5
182	t	Turn Roomba Off	2	1	1
183	t	Turn Smart TV Off	2	1	5
184	t	Turn Smart TV Off	2	1	5
185	t	Turn Smart TV Off	2	1	5
186	t	Turn Smart TV Off	2	1	5
187	t	Close Bathroom Window's Curtains	58	5	24
188	t	Turn Speakers Off	2	1	7
189	t	Turn Smart TV Off	2	1	5
190	t	Turn Smart TV Off	2	1	5
191	t	Turn Smart TV Off	2	1	5
192	t	Turn Smart TV Off	2	1	5
193	t	Turn Smart TV Off	2	1	5
194	t	Close Bathroom Window's Curtains	58	5	24
195	t	Turn Smart TV Off	2	1	5
198	t	Turn HUE Lights On	2	2	4
199	t	Close Bathroom Window	14	5	24
205	t	Turn HUE Lights On	2	2	4
206	t	Close Bathroom Window	14	5	24
207	t	Open Bedroom Window	14	5	14
209	t	Open Bathroom Window	14	5	24
212	t	Open Bedroom Window	14	5	14
214	t	Open Bathroom Window	14	5	24
215	t	Turn HUE Lights On	2	2	4
216	t	Close Bathroom Window	14	5	24
217	t	Unlock Smart Refrigerator	13	13	8
219	t	Open Bedroom Window	14	5	14
221	t	Open Bathroom Window	14	5	24
222	t	Open Bathroom Window	14	5	24
223	t	(Security Camera) start recording	28	10	10
224	t	(Security Camera) start recording	28	10	10
225	t	(Security Camera) start recording	28	10	10
226	t	(Security Camera) start recording	28	10	10
227	t	Turn Roomba Off	2	18	1
228	t	(Security Camera) start recording	28	10	10
229	t	(Security Camera) start recording	28	10	10
230	t	Turn Roomba Off	2	18	1
231	t	(Security Camera) start recording	28	10	10
232	t	(Security Camera) start recording	28	10	10
233	t	Turn Roomba Off	2	18	1
235	t	(Security Camera) start recording	28	10	10
237	t	Turn Roomba Off	2	18	1
238	t	(Security Camera) start recording	28	10	10
239	t	(Security Camera) start recording	28	10	10
248	t	(Security Camera) start recording	28	10	10
249	t	(Security Camera) start recording	28	10	10
250	t	Turn Roomba Off	2	18	1
251	t	(Security Camera) start recording	28	10	10
252	t	(Security Camera) start recording	28	10	10
253	t	(Security Camera) start recording	28	10	10
254	t	(Security Camera) start recording	28	10	10
255	t	Turn Roomba Off	2	18	1
256	t	(Security Camera) start recording	28	10	10
257	t	(Security Camera) start recording	28	10	10
258	t	(Security Camera) start recording	28	10	10
259	t	(Security Camera) start recording	28	10	10
260	t	(Security Camera) start recording	28	10	10
261	t	(Security Camera) start recording	28	10	10
262	t	Turn Roomba Off	2	18	1
263	t	Turn Roomba Off	2	18	1
264	t	(Security Camera) start recording	28	10	10
265	t	(Security Camera) start recording	28	10	10
266	t	Turn Roomba Off	2	18	1
267	t	(Security Camera) start recording	28	10	10
268	t	(Security Camera) start recording	28	10	10
269	t	Turn Roomba Off	2	18	1
270	t	(Security Camera) start recording	28	10	10
271	t	Turn Roomba Off	2	18	1
272	t	(Security Camera) start recording	28	10	10
273	t	(Security Camera) start recording	28	10	10
274	t	(Security Camera) start recording	28	10	10
275	t	(Security Camera) start recording	28	10	10
276	t	Turn Roomba Off	2	18	1
277	t	(Security Camera) start recording	28	10	10
278	t	(Security Camera) start recording	28	10	10
279	t	(Security Camera) start recording	28	10	10
280	t	(Security Camera) start recording	28	10	10
281	t	Turn Roomba Off	2	18	1
282	t	(Security Camera) start recording	28	10	10
283	t	(Security Camera) start recording	28	10	10
284	t	(Security Camera) start recording	28	10	10
285	t	(Security Camera) start recording	28	10	10
286	t	(Security Camera) start recording	28	10	10
287	t	(Security Camera) start recording	28	10	10
288	t	Turn Roomba Off	2	18	1
289	t	Turn Roomba Off	2	18	1
290	t	Close Bedroom Window	14	5	14
291	t	Open Bedroom Window	14	5	14
292	t	Turn HUE Lights On	2	2	4
293	t	Turn HUE Lights On	2	2	4
294	t	Turn HUE Lights On	2	2	4
295	t	Turn HUE Lights On	2	2	4
297	t	Close Bedroom Window	14	5	14
298	t	Open Bedroom Window	14	5	14
299	t	Close Bedroom Window	14	5	14
300	t	Turn HUE Lights On	2	2	4
301	t	Turn HUE Lights On	2	2	4
302	t	Turn HUE Lights On	2	2	4
303	t	Close Bedroom Window	14	5	14
304	t	Turn HUE Lights On	2	2	4
305	t	Turn HUE Lights On	2	2	4
306	t	Close Bedroom Window	14	5	14
307	t	Open Bedroom Window	14	5	14
308	t	Close Bedroom Window	14	5	14
309	t	Turn HUE Lights On	2	2	4
310	t	Turn HUE Lights On	2	2	4
311	t	Turn HUE Lights On	2	2	4
312	t	Close Bedroom Window	14	5	14
313	t	Turn HUE Lights On	2	2	4
314	t	Turn HUE Lights On	2	2	4
315	t	Open Bedroom Window	14	5	14
317	t	Turn HUE Lights On	2	1	4
318	t	Turn HUE Lights On	2	1	4
319	t	Turn HUE Lights On	2	1	4
320	t	Turn HUE Lights On	2	1	4
321	t	Turn HUE Lights On	2	1	4
322	t	Turn HUE Lights On	2	1	4
323	t	Turn HUE Lights On	2	1	4
324	t	Open Living Room Window's Curtains	58	5	25
325	t	Turn HUE Lights On	2	1	4
326	t	Turn HUE Lights On	2	1	4
327	t	Open Living Room Window's Curtains	58	5	25
328	t	Turn HUE Lights On	2	1	4
329	t	Turn HUE Lights On	2	1	4
330	t	Turn HUE Lights On	2	1	4
331	t	Open Living Room Window's Curtains	58	5	25
332	t	Open Living Room Window's Curtains	58	5	25
333	t	Turn HUE Lights On	2	1	4
334	t	Open Living Room Window's Curtains	58	5	25
335	t	Turn HUE Lights On	2	1	4
336	t	Turn HUE Lights On	2	1	4
337	t	Turn HUE Lights On	2	1	4
338	t	Open Living Room Window's Curtains	58	5	25
339	t	Turn HUE Lights On	2	1	4
340	t	Open Living Room Window's Curtains	58	5	25
341	t	Turn HUE Lights On	2	1	4
342	t	Open Living Room Window's Curtains	58	5	25
343	t	Open Living Room Window's Curtains	58	5	25
344	t	Turn HUE Lights On	2	1	4
345	t	Turn HUE Lights On	2	1	4
346	t	Open Living Room Window's Curtains	58	5	25
347	t	Open Living Room Window's Curtains	58	5	25
348	t	Open Living Room Window's Curtains	58	5	25
349	t	Open Living Room Window's Curtains	58	5	25
350	t	Turn HUE Lights On	2	1	4
351	t	Turn HUE Lights On	2	1	4
352	t	Turn HUE Lights On	2	1	4
353	t	Open Living Room Window's Curtains	58	5	25
354	t	Turn HUE Lights On	2	1	4
355	t	Turn HUE Lights On	2	1	4
356	t	Open Living Room Window's Curtains	58	5	25
357	t	Open Living Room Window's Curtains	58	5	25
358	t	Turn HUE Lights On	2	1	4
359	t	Open Living Room Window's Curtains	58	5	25
360	t	Turn HUE Lights On	2	1	4
361	t	Open Living Room Window's Curtains	58	5	25
362	t	Turn HUE Lights On	2	1	4
363	t	Open Living Room Window's Curtains	58	5	25
364	t	Open Living Room Window's Curtains	58	5	25
365	t	Open Living Room Window's Curtains	58	5	25
366	t	Open Living Room Window's Curtains	58	5	25
367	t	Turn HUE Lights On	2	1	4
368	t	Turn HUE Lights On	2	1	4
369	t	Open Living Room Window's Curtains	58	5	25
370	t	Open Living Room Window's Curtains	58	5	25
371	t	Turn HUE Lights On	2	1	4
372	t	Open Living Room Window's Curtains	58	5	25
373	t	Open Living Room Window's Curtains	58	5	25
374	t	Open Living Room Window's Curtains	58	5	25
375	t	Open Living Room Window's Curtains	58	5	25
376	t	Turn HUE Lights On	2	1	4
377	t	Open Living Room Window's Curtains	58	5	25
378	t	Open Living Room Window's Curtains	58	5	25
379	t	Open Living Room Window's Curtains	58	5	25
380	t	Open Living Room Window's Curtains	58	5	25
381	t	Close Living Room Window	14	5	25
382	t	Close Living Room Window	14	5	25
383	t	Close Living Room Window	14	5	25
384	t	Close Living Room Window	14	5	25
385	t	Close Living Room Window	14	5	25
386	t	Turn Roomba Off	2	1	1
387	t	Close Living Room Window	14	5	25
388	t	Close Living Room Window	14	5	25
389	t	Turn Smart TV Off	2	1	5
390	t	Close Living Room Window	14	5	25
391	t	Turn Roomba Off	2	1	1
392	t	Close Living Room Window	14	5	25
393	t	Close Living Room Window	14	5	25
394	t	Turn Roomba Off	2	1	1
395	t	Turn Roomba Off	2	1	1
396	t	Close Living Room Window	14	5	25
397	t	Turn Roomba Off	2	1	1
398	t	Turn Smart TV Off	2	1	5
399	t	Close Living Room Window	14	5	25
400	t	Turn Smart TV Off	2	1	5
401	t	Close Living Room Window	14	5	25
538	t	Close Bedroom Window	14	5	14
539	t	Turn Off the AC	57	8	2
402	t	Close Living Room Window	14	5	25
403	t	Turn Smart TV Off	2	1	5
404	t	Turn Roomba Off	2	1	1
405	t	Close Living Room Window	14	5	25
406	t	Turn Smart TV Off	2	1	5
407	t	Turn Smart TV Off	2	1	5
408	t	Turn Roomba Off	2	1	1
409	t	Close Living Room Window	14	5	25
410	t	Close Living Room Window	14	5	25
411	t	Turn Roomba Off	2	1	1
412	t	Close Living Room Window	14	5	25
413	t	Turn Roomba Off	2	1	1
414	t	Turn Roomba Off	2	1	1
415	t	Close Living Room Window	14	5	25
416	t	Turn Smart TV Off	2	1	5
417	t	Turn Roomba Off	2	1	1
418	t	Turn Roomba Off	2	1	1
419	t	Close Living Room Window	14	5	25
420	t	Turn Roomba Off	2	1	1
421	t	Turn Roomba Off	2	1	1
422	t	Turn Roomba Off	2	1	1
423	t	Turn Roomba Off	2	1	1
424	t	Turn Roomba Off	2	1	1
425	t	Turn Smart TV Off	2	1	5
426	t	Turn Roomba Off	2	1	1
427	t	Turn Smart TV Off	2	1	5
428	t	Close Living Room Window	14	5	25
429	t	Turn Roomba Off	2	1	1
430	t	Turn Smart TV Off	2	1	5
431	t	Turn Roomba Off	2	1	1
432	t	Turn Roomba Off	2	1	1
433	t	Turn Smart TV Off	2	1	5
434	t	Turn Smart TV Off	2	1	5
435	t	Turn Smart TV Off	2	1	5
436	t	Close Living Room Window	14	5	25
437	t	Close Living Room Window	14	5	25
438	t	Turn Smart TV Off	2	1	5
439	t	Close Living Room Window	14	5	25
440	t	Turn Roomba Off	2	1	1
441	t	Turn Smart TV Off	2	1	5
442	t	Close Living Room Window	14	5	25
443	t	Turn Smart TV Off	2	1	5
444	t	Turn Smart TV Off	2	1	5
445	t	Turn Roomba Off	2	1	1
446	t	Close Living Room Window	14	5	25
447	t	Turn Smart TV Off	2	1	5
448	t	Turn Roomba Off	2	1	1
449	t	Turn Roomba Off	2	1	1
450	t	Turn Roomba Off	2	1	1
451	t	Turn Smart TV Off	2	1	5
452	t	Turn Smart TV Off	2	1	5
453	t	Turn Smart TV Off	2	1	5
454	t	Turn Smart TV Off	2	1	5
455	t	Close Living Room Window	14	5	25
456	t	Turn Smart TV Off	2	1	5
457	t	Turn Smart TV Off	2	1	5
458	t	Turn Roomba Off	2	1	1
459	t	Turn Smart TV Off	2	1	5
460	t	Turn Smart TV Off	2	1	5
461	t	Turn Smart TV Off	2	1	5
462	t	Turn Off Smart Faucet's water	64	17	22
463	t	Turn On the AC	57	8	2
464	t	Turn Speakers On	2	1	7
465	t	Open Living Room Window	14	5	25
466	t	Turn Off Smart Faucet's water	64	17	22
467	t	Turn Off Smart Faucet's water	64	17	22
468	t	Turn On the AC	57	8	2
469	t	Turn Speakers On	2	1	7
472	t	Close Living Room Window	14	5	25
474	t	Open Living Room Window	14	5	25
475	t	Turn Off Smart Faucet's water	64	17	22
476	t	Turn Off the AC	57	8	2
478	t	Turn On the AC	57	8	2
484	t	Open Living Room Window	14	5	25
485	t	Turn Off Smart Faucet's water	64	17	22
486	t	Close Living Room Window	14	5	25
487	t	Turn Off Smart Faucet's water	64	17	22
488	t	Turn Off the AC	57	8	2
489	t	Turn Speakers On	2	3	7
490	t	Close Bedroom Window	14	5	14
491	t	Close Living Room Window	14	5	25
492	t	Close Bedroom Window	14	5	14
493	t	Open Bedroom Window	14	5	14
494	t	Open Living Room Window	14	5	25
496	t	Close Bedroom Window	14	5	14
497	t	Close Living Room Window	14	5	25
498	t	Close Bathroom Window	14	5	24
499	t	Open Bedroom Window	14	5	14
500	t	Open Living Room Window	14	5	25
501	t	Close Bedroom Window	14	5	14
502	t	Close Living Room Window	14	5	25
503	t	Close Bathroom Window	14	5	24
504	t	Open Living Room Window	14	5	25
508	t	Open Bedroom Window	14	5	14
509	t	Open Living Room Window	14	5	25
510	t	Open Bathroom Window	14	5	24
511	t	Close Living Room Window	14	5	25
512	t	Close Bathroom Window	14	5	24
513	t	Close Bedroom Window	14	5	14
514	t	Close Bedroom Window	14	5	14
515	t	Close Living Room Window	14	5	25
516	t	Close Bedroom Window	14	5	14
517	t	Close Bedroom Window	14	5	14
518	t	Close Living Room Window	14	5	25
519	t	Close Bathroom Window	14	5	24
520	t	Close Bedroom Window	14	5	14
521	t	Turn Off the AC	57	8	2
522	t	Unlock Front Door Lock	13	5	13
523	t	Turn Off the AC	57	8	2
525	t	Turn Roomba Off	2	18	1
526	t	Close Bedroom Window	14	5	14
527	t	Turn Off the AC	57	8	2
544	t	Turn Off the AC	57	8	2
545	t	Turn Off the AC	57	8	2
546	t	Turn Roomba Off	2	18	1
547	t	Turn Off the AC	57	8	2
548	t	Turn Off the AC	57	8	2
549	t	Turn Roomba Off	2	18	1
550	t	Turn Off the AC	57	8	2
552	t	Turn Off the AC	57	8	2
553	t	Turn Off the AC	57	8	2
554	t	Turn Off the AC	57	8	2
555	t	Turn Off the AC	57	8	2
556	t	Turn Off the AC	57	8	2
557	t	Turn Off the AC	57	8	2
558	t	(Security Camera) start recording	28	10	10
559	t	Set HUE Lights's Color to Red	6	2	4
560	t	(Security Camera) start recording	28	10	10
561	t	Set HUE Lights's Color to Red	6	2	4
562	t	(Security Camera) start recording	28	10	10
563	t	Set HUE Lights's Color to Red	6	2	4
564	t	Turn Off the AC	57	8	2
565	t	Turn Off the AC	57	8	2
566	t	Turn Off the AC	57	8	2
567	t	Turn Off the AC	57	8	2
568	t	Turn Off the AC	57	8	2
569	t	Turn Off the AC	57	8	2
570	t	Turn Off the AC	57	8	2
571	t	Turn Off the AC	57	8	2
572	t	Turn Off the AC	57	8	2
573	t	Turn HUE Lights On	2	2	4
574	t	Close Bathroom Window	14	5	24
576	t	Open Bathroom Window	14	5	24
578	t	Close Bathroom Window	14	5	24
582	t	Close Bathroom Window	14	5	24
584	t	Open Bathroom Window	14	5	24
586	t	Turn HUE Lights Off	2	2	4
587	t	Turn Off the AC	57	8	2
589	t	Turn Off the AC	57	8	2
590	t	Turn HUE Lights On	2	2	4
591	t	Turn HUE Lights On	2	2	4
593	t	Turn HUE Lights On	2	2	4
594	t	Open Living Room Window's Curtains	58	5	25
604	t	Open Bathroom Window	14	5	24
605	t	Open Bedroom Window	14	5	14
606	t	Turn HUE Lights On	2	2	4
607	t	Open Bedroom Window	14	5	14
608	t	Open Bathroom Window	14	5	24
609	t	Unlock Smart Refrigerator	13	13	8
610	t	Close Bathroom Window	14	5	24
611	t	Turn HUE Lights On	2	2	4
612	t	Open Bedroom Window	14	5	14
613	t	Open Bathroom Window	14	5	24
614	t	(Security Camera) stop recording	28	10	10
615	t	(Security Camera) stop recording	28	10	10
616	t	Close Bedroom Window	14	5	14
617	t	Close Bedroom Window	14	5	14
618	t	Close Bathroom Window	14	5	24
619	t	Close Living Room Window	14	5	25
620	t	Turn Off the AC	57	8	2
622	t	Turn Off the AC	57	8	2
623	t	Turn On the heater	69	8	2
624	t	Turn Off the heater	69	8	2
625	t	Turn Off the heater	69	8	2
626	t	Turn On the heater	69	8	2
627	t	Turn On the heater	69	8	2
628	t	Turn Off the heater	69	8	2
629	t	Turn Off the heater	69	8	2
630	t	Turn Off the AC	57	8	2
632	t	Turn Off Smart Faucet's water	64	17	22
633	t	Close Smart Oven's Door	60	13	23
634	t	Turn Speakers Off	2	3	7
635	t	Open Living Room Window	14	5	25
636	t	Open Living Room Window	14	5	25
637	t	Turn Off Smart Faucet's water	64	17	22
638	t	Close Smart Oven's Door	60	13	23
639	t	Close Smart Oven's Door	60	13	23
640	t	Turn Off Smart Faucet's water	64	17	22
641	t	Open Living Room Window	14	5	25
642	t	Open Living Room Window	14	5	25
643	t	Open Living Room Window	14	5	25
645	t	Open Living Room Window	14	5	25
646	t	Open Living Room Window	14	5	25
648	t	Open Living Room Window	14	5	25
649	t	Open Living Room Window	14	5	25
650	t	Close Living Room Window	14	5	25
651	t	Close Living Room Window	14	5	25
652	t	Turn HUE Lights On	2	2	4
653	t	Turn HUE Lights On	2	2	4
654	t	Turn Speakers Off	2	3	7
655	t	Turn HUE Lights Off	2	2	4
656	t	Turn Speakers Off	2	3	7
657	t	Turn HUE Lights On	2	2	4
658	t	Close Living Room Window	14	5	25
659	t	Turn HUE Lights On	2	2	4
660	t	Close Living Room Window	14	5	25
662	t	Turn HUE Lights On	2	2	4
663	t	Turn HUE Lights On	2	2	4
664	t	Turn Speakers Off	2	3	7
665	t	Turn HUE Lights On	2	2	4
667	t	Turn HUE Lights On	2	2	4
668	t	Turn HUE Lights On	2	1	4
669	t	Turn HUE Lights On	2	1	4
670	t	Turn HUE Lights On	2	1	4
671	t	Turn Smart TV Off	2	1	5
672	t	Turn HUE Lights On	2	1	4
673	t	Turn HUE Lights On	2	1	4
674	t	Turn HUE Lights On	2	1	4
675	t	Turn Speakers Off	2	1	7
676	t	Turn HUE Lights On	2	2	4
677	t	Turn HUE Lights On	2	2	4
678	t	Turn HUE Lights On	2	2	4
679	t	Turn HUE Lights On	2	2	4
680	t	Turn Speakers Off	2	3	7
681	t	Turn Off Smart Faucet's water	64	17	22
682	t	Close Bathroom Window	14	5	24
683	t	Close Living Room Window	14	5	25
684	t	Close Bedroom Window	14	5	14
685	t	Close Bathroom Window	14	5	24
686	t	Close Bedroom Window	14	5	14
687	t	Close Living Room Window	14	5	25
688	t	Close Bedroom Window	14	5	14
689	t	Close Bathroom Window	14	5	24
690	t	Close Living Room Window	14	5	25
691	t	Turn Off Smart Faucet's water	64	17	22
692	t	Turn Roomba Off	2	18	1
693	t	(Security Camera) start recording	28	10	10
694	t	Turn Roomba Off	2	18	1
695	t	(Security Camera) start recording	28	10	10
696	t	(Security Camera) start recording	28	10	10
697	t	(Security Camera) start recording	28	10	10
698	t	Turn Off Smart Faucet's water	64	17	22
699	t	Turn Off Smart Faucet's water	64	17	22
700	t	Turn HUE Lights On	2	2	4
701	t	Turn HUE Lights On	2	2	4
702	t	Turn HUE Lights On	2	2	4
703	t	Turn Speakers Off	2	3	7
704	t	Turn HUE Lights On	2	2	4
705	t	Turn Speakers Off	2	3	7
706	t	Close Living Room Window	14	5	25
707	t	Turn Speakers Off	2	3	7
708	t	Turn HUE Lights On	2	1	4
709	t	Turn Smart TV Off	2	12	5
710	t	Turn HUE Lights On	2	2	4
711	t	Turn Speakers Off	2	1	7
712	t	Turn HUE Lights On	2	2	4
713	t	Turn Speakers Off	2	3	7
714	t	Open Living Room Window	14	5	25
715	t	Close Living Room Window	14	5	25
716	t	Close Living Room Window	14	5	25
717	t	Close Bathroom Window	14	5	24
718	t	Close Bathroom Window	14	5	24
719	t	Close Bedroom Window	14	5	14
720	t	Close Bedroom Window	14	5	14
721	t	Open Living Room Window	14	5	25
722	t	Turn Off the AC	57	8	2
723	t	Turn Off the AC	57	8	2
724	t	Turn Off the AC	57	8	2
725	t	Turn Smart TV Off	2	1	5
726	t	Turn Off the AC	57	8	2
727	t	Turn Smart TV Off	2	1	5
728	t	Turn Smart TV Off	2	1	5
729	t	Turn Smart TV Off	2	1	5
730	t	Turn Off the AC	57	8	2
731	t	Turn Off the AC	57	8	2
732	t	Turn Off the AC	57	8	2
733	t	Turn Off the heater	69	8	2
734	t	Turn Off the heater	69	8	2
735	t	Turn Off the AC	57	8	2
736	t	Turn Off the heater	69	8	2
737	t	Turn Off the heater	69	8	2
738	t	Turn Smart TV Off	2	12	5
739	t	Turn HUE Lights Off	2	2	4
740	t	Turn Speakers Off	2	3	7
741	t	Turn Coffee Pot Off	2	1	9
742	t	Turn HUE Lights Off	2	2	4
743	t	Turn Roomba Off	2	1	1
744	t	Turn Smart TV Off	2	12	5
745	t	Turn HUE Lights Off	2	2	4
746	t	Turn Speakers Off	2	3	7
747	t	Turn Coffee Pot Off	2	1	9
748	t	Turn HUE Lights Off	2	2	4
749	t	Turn Roomba Off	2	1	1
750	t	Turn Off the AC	57	8	2
751	t	Turn Off the AC	57	8	2
752	t	Turn Coffee Pot Off	2	13	9
753	t	Turn Roomba Off	2	1	1
754	t	Turn Coffee Pot Off	2	13	9
755	t	Turn Roomba Off	2	1	1
756	t	Turn Off the AC	57	8	2
757	t	Turn Off the AC	57	8	2
758	t	Turn Coffee Pot Off	2	13	9
759	t	Turn Roomba Off	2	1	1
760	t	Turn Coffee Pot Off	2	13	9
761	t	Turn Roomba Off	2	1	1
762	t	Turn Coffee Pot Off	2	13	9
763	t	Turn HUE Lights Off	2	2	4
764	t	Turn Roomba Off	2	18	1
765	t	Turn Roomba Off	2	18	1
766	t	Turn Roomba Off	2	18	1
767	t	Turn Coffee Pot Off	2	13	9
768	t	Turn Coffee Pot Off	2	13	9
769	t	Turn Smart TV Off	2	12	5
770	t	Turn Roomba Off	2	18	1
771	t	Turn HUE Lights Off	2	2	4
772	t	Turn Smart TV Off	2	12	5
773	t	Turn Roomba Off	2	18	1
774	t	Turn HUE Lights Off	2	2	4
775	t	Turn Roomba Off	2	18	1
776	t	Turn Coffee Pot Off	2	13	9
777	t	Turn Roomba Off	2	18	1
778	t	Turn Coffee Pot Off	2	13	9
779	t	Turn Smart TV Off	2	12	5
780	t	Turn Roomba Off	2	18	1
781	t	Turn HUE Lights Off	2	2	4
782	t	Turn Smart TV Off	2	12	5
783	t	Turn Roomba Off	2	18	1
784	t	Turn Roomba Off	2	18	1
785	t	Turn Coffee Pot Off	2	13	9
786	t	Turn HUE Lights Off	2	2	4
787	t	Turn Roomba Off	2	18	1
788	t	Turn Coffee Pot Off	2	13	9
789	t	Turn Roomba Off	2	18	1
790	t	Turn Coffee Pot Off	2	13	9
791	t	Turn Smart TV Off	2	12	5
792	t	Turn Roomba Off	2	18	1
793	t	Turn HUE Lights Off	2	2	4
794	t	Turn Smart TV Off	2	12	5
795	t	Turn Roomba Off	2	18	1
796	t	Turn Roomba Off	2	18	1
797	t	Turn Coffee Pot Off	2	13	9
798	t	Turn HUE Lights Off	2	2	4
799	t	Turn Roomba Off	2	18	1
800	t	Turn Coffee Pot Off	2	13	9
801	t	Turn Roomba Off	2	18	1
802	t	Turn Coffee Pot Off	2	13	9
803	t	Turn Smart TV Off	2	12	5
804	t	Turn Roomba Off	2	18	1
805	t	Turn HUE Lights Off	2	2	4
806	t	Turn Smart TV Off	2	12	5
807	t	Turn Roomba Off	2	18	1
808	t	Turn Smart TV Off	2	12	5
809	t	Turn Roomba Off	2	18	1
810	t	Turn Roomba Off	2	18	1
811	t	Turn Coffee Pot Off	2	13	9
812	t	Turn Roomba Off	2	18	1
813	t	Turn HUE Lights Off	2	2	4
814	t	Turn Speakers Off	2	1	7
815	t	Turn Smart TV Off	2	12	5
816	t	Turn Off the AC	57	8	2
817	t	Turn Speakers Off	2	1	7
818	t	Turn Speakers Off	2	1	7
819	t	Turn Roomba Off	2	18	1
820	t	Turn Roomba Off	2	18	1
821	t	Turn Coffee Pot Off	2	13	9
822	t	Turn Roomba Off	2	18	1
823	t	Turn Coffee Pot Off	2	13	9
824	t	Turn Roomba Off	2	18	1
825	t	Turn HUE Lights Off	2	2	4
826	t	Turn Speakers Off	2	1	7
827	t	Turn Smart TV Off	2	12	5
828	t	Turn Off the AC	57	8	2
829	t	Turn Speakers Off	2	1	7
830	t	Turn Speakers Off	2	1	7
831	t	Turn Roomba Off	2	18	1
832	t	Turn Roomba Off	2	18	1
833	t	Turn Coffee Pot Off	2	13	9
834	t	Turn Coffee Pot Off	2	13	9
835	t	Turn Coffee Pot Off	2	13	9
\.


--
-- Name: backend_state_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_state_id_seq', 835, true);


--
-- Data for Name: backend_statelog; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_statelog (id, "timestamp", is_current, value, cap_id, dev_id, param_id) FROM stdin;
\.


--
-- Name: backend_statelog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_statelog_id_seq', 1, false);


--
-- Data for Name: backend_timeparam; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_timeparam (parameter_ptr_id, mode) FROM stdin;
23	12
24	24
\.


--
-- Data for Name: backend_trigger; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_trigger (id, pos, text, cap_id, chan_id, dev_id) FROM stdin;
1	0	(FitBit) I Fall Asleep	61	16	21
2	1	Security Camera is not recording	28	10	10
3	0	Front Door Lock Unlocks	13	5	13
4	1	Security Camera is not recording	28	10	10
5	0	Bobbie Enters Living Room	63	15	12
6	1	Security Camera is recording	28	10	10
7	0	Security Camera stops recording	28	10	10
8	1	(FitBit) I am Asleep	61	16	21
9	0	Security Camera stops recording	28	10	10
10	1	Front Door Lock is Unlocked	13	5	13
11	0	Security Camera starts recording	28	10	10
12	1	Bobbie is in Living Room	63	15	12
13	0	(FitBit) I Fall Asleep	61	16	21
14	1	Front Door Lock is Unlocked	13	5	13
15	0	Front Door Lock Unlocks	13	5	13
16	1	Security Camera is not recording	28	10	10
17	2	(FitBit) I am Asleep	61	16	21
18	0	Security Camera stops recording	28	10	10
19	1	(FitBit) I am Asleep	61	16	21
20	0	(FitBit) I Fall Asleep	61	16	21
21	1	Front Door Lock is Locked	13	5	13
22	2	Security Camera is not recording	28	10	10
23	0	Security Camera stops recording	28	10	10
24	1	Front Door Lock is Unlocked	13	5	13
25	2	(FitBit) I am Asleep	61	16	21
26	0	Security Camera stops recording	28	10	10
27	1	(FitBit) I am Asleep	61	16	21
28	2	Front Door Lock is Locked	13	5	13
29	0	Front Door Lock Unlocks	13	5	13
31	1	Security Camera is not recording	28	10	10
33	1	Security Camera is not recording	28	10	10
35	1	(FitBit) I am Asleep	61	16	21
37	1	(FitBit) I am Asleep	61	16	21
39	1	(FitBit) I am Asleep	61	16	21
41	1	(FitBit) I am Asleep	61	16	21
43	1	Front Door Lock is Unlocked	13	5	13
45	1	Roomba is On	2	18	1
47	1	Front Door Lock is Unlocked	13	5	13
49	1	Security Camera is not recording	28	10	10
50	2	(FitBit) I am Asleep	61	16	21
52	1	(FitBit) I am Asleep	61	16	21
53	2	Roomba is On	2	18	1
55	1	(FitBit) I am Asleep	61	16	21
57	1	Front Door Lock is Locked	13	5	13
58	2	Security Camera is not recording	28	10	10
60	1	(FitBit) I am Awake	61	16	21
61	0	Security Camera stops recording	28	10	10
62	1	Front Door Lock is Unlocked	13	5	13
63	2	(FitBit) I am Asleep	61	16	21
64	3	Roomba is Off	2	18	1
65	0	Security Camera stops recording	28	10	10
66	1	Front Door Lock is Locked	13	5	13
67	0	Security Camera stops recording	28	10	10
68	1	(FitBit) I am Asleep	61	16	21
69	2	Front Door Lock is Locked	13	5	13
72	1	Front Door Lock is Unlocked	13	5	13
73	2	(FitBit) I am Awake	61	16	21
74	0	Security Camera stops recording	28	10	10
75	1	(FitBit) I am Awake	61	16	21
76	2	Front Door Lock is Locked	13	5	13
77	0	Security Camera stops recording	28	10	10
78	1	(FitBit) I am Asleep	61	16	21
79	2	Front Door Lock is Locked	13	5	13
81	1	(FitBit) I am Asleep	61	16	21
82	2	Front Door Lock is Unlocked	13	5	13
84	1	Front Door Lock is Locked	13	5	13
86	1	Front Door Lock is Unlocked	13	5	13
88	1	Security Camera is not recording	28	10	10
89	2	(FitBit) I am Asleep	61	16	21
91	1	(FitBit) I am Asleep	61	16	21
92	2	Roomba is On	2	18	1
94	1	(FitBit) I am Asleep	61	16	21
96	1	Front Door Lock is Locked	13	5	13
97	2	Security Camera is not recording	28	10	10
99	1	(FitBit) I am Awake	61	16	21
101	1	Front Door Lock is Unlocked	13	5	13
102	2	(FitBit) I am Awake	61	16	21
103	0	Security Camera starts recording	28	10	10
104	1	Front Door Lock is Locked	13	5	13
106	1	(FitBit) I am Asleep	61	16	21
107	2	Front Door Lock is Unlocked	13	5	13
110	1	Front Door Lock is Unlocked	13	5	13
112	1	Security Camera is not recording	28	10	10
113	2	(FitBit) I am Asleep	61	16	21
115	1	(FitBit) I am Asleep	61	16	21
116	2	Roomba is On	2	18	1
118	1	(FitBit) I am Asleep	61	16	21
120	1	Front Door Lock is Locked	13	5	13
121	2	Security Camera is not recording	28	10	10
123	1	(FitBit) I am Awake	61	16	21
125	1	Front Door Lock is Unlocked	13	5	13
126	2	(FitBit) I am Awake	61	16	21
127	0	Security Camera starts recording	28	10	10
128	1	Front Door Lock is Locked	13	5	13
130	1	(FitBit) I am Asleep	61	16	21
131	2	Front Door Lock is Unlocked	13	5	13
134	1	Front Door Lock is Unlocked	13	5	13
136	1	Front Door Lock is Unlocked	13	5	13
138	1	Roomba is On	2	18	1
139	2	Front Door Lock is Locked	13	5	13
140	0	Bathroom Window Closes	14	5	24
141	1	Bedroom Window is Closed	14	5	14
142	2	Living Room Window is Closed	14	5	25
143	0	Bedroom Window Closes	14	5	14
144	1	Living Room Window is Closed	14	5	25
372	1	Roomba is On	2	1	1
145	2	Bathroom Window is Closed	14	5	24
146	0	Living Room Window Closes	14	5	25
147	1	Bathroom Window is Closed	14	5	24
148	2	Bathroom Window is Closed	14	5	24
149	0	Bathroom Window Opens	14	5	24
150	1	Bedroom Window is Open	14	5	14
151	2	Living Room Window is Closed	14	5	25
152	0	Bedroom Window Opens	14	5	14
153	1	Living Room Window is Open	14	5	25
154	2	Bathroom Window is Closed	14	5	24
155	0	Living Room Window Opens	14	5	25
156	1	Bathroom Window is Open	14	5	24
157	2	Bedroom Window is Closed	14	5	14
158	0	Bathroom Window Closes	14	5	24
159	1	Bedroom Window is Closed	14	5	14
160	2	Living Room Window is Closed	14	5	25
161	0	Bedroom Window Closes	14	5	14
162	1	Living Room Window is Closed	14	5	25
163	2	Bathroom Window is Closed	14	5	24
164	0	Living Room Window Closes	14	5	25
165	1	Bathroom Window is Closed	14	5	24
166	2	Bathroom Window is Closed	14	5	24
167	0	Bathroom Window Opens	14	5	24
168	1	Bedroom Window is Open	14	5	14
169	2	Living Room Window is Closed	14	5	25
170	0	Bedroom Window Opens	14	5	14
171	1	Living Room Window is Open	14	5	25
172	2	Bathroom Window is Closed	14	5	24
173	0	Living Room Window Opens	14	5	25
174	1	Bathroom Window is Open	14	5	24
175	2	Bedroom Window is Closed	14	5	14
177	1	Bedroom Window is Closed	14	5	14
178	2	Living Room Window is Closed	14	5	25
180	1	Living Room Window is Closed	14	5	25
181	2	Bathroom Window is Closed	14	5	24
183	1	Bathroom Window is Closed	14	5	24
184	2	Bathroom Window is Closed	14	5	24
186	1	Bedroom Window is Open	14	5	14
187	2	Living Room Window is Closed	14	5	25
189	1	Living Room Window is Open	14	5	25
190	2	Bathroom Window is Closed	14	5	24
192	1	Bathroom Window is Open	14	5	24
193	2	Bedroom Window is Closed	14	5	14
194	0	Living Room Window Closes	14	5	25
195	1	Bathroom Window is Closed	14	5	24
196	2	Bedroom Window is Closed	14	5	14
197	0	Bathroom Window Opens	14	5	24
198	1	Bedroom Window is Closed	14	5	14
199	2	Living Room Window is Open	14	5	25
200	0	Bedroom Window Opens	14	5	14
201	1	Living Room Window is Closed	14	5	25
202	2	Bathroom Window is Open	14	5	24
203	0	Living Room Window Opens	14	5	25
204	1	Bedroom Window is Open	14	5	14
205	2	Bathroom Window is Closed	14	5	24
206	0	Bathroom Window Closes	14	5	24
207	1	Bedroom Window is Closed	14	5	14
208	2	Living Room Window is Closed	14	5	25
209	0	Bedroom Window Closes	14	5	14
210	1	Living Room Window is Closed	14	5	25
211	2	Bathroom Window is Closed	14	5	24
212	0	Bathroom Window Opens	14	5	24
213	1	Bedroom Window is Open	14	5	14
214	2	Living Room Window is Closed	14	5	25
215	0	Bedroom Window Opens	14	5	14
216	1	Living Room Window is Open	14	5	25
217	2	Bathroom Window is Closed	14	5	24
218	0	Living Room Window Opens	14	5	25
219	1	Bathroom Window is Open	14	5	24
220	2	Bedroom Window is Closed	14	5	14
221	0	Living Room Window Closes	14	5	25
222	1	Bathroom Window is Closed	14	5	24
223	2	Bedroom Window is Closed	14	5	14
224	0	Bathroom Window Opens	14	5	24
225	1	Bedroom Window is Closed	14	5	14
226	2	Living Room Window is Open	14	5	25
227	0	Bedroom Window Opens	14	5	14
228	1	Living Room Window is Closed	14	5	25
229	2	Bathroom Window is Open	14	5	24
230	0	Living Room Window Opens	14	5	25
231	1	Bedroom Window is Open	14	5	14
232	2	Bathroom Window is Closed	14	5	24
233	0	Bathroom Window Closes	14	5	24
234	1	Bedroom Window is Closed	14	5	14
235	2	Living Room Window is Closed	14	5	25
236	0	Bedroom Window Closes	14	5	14
237	1	Living Room Window is Closed	14	5	25
238	2	Bathroom Window is Closed	14	5	24
239	0	Bathroom Window Opens	14	5	24
240	1	Bedroom Window is Open	14	5	14
241	2	Living Room Window is Closed	14	5	25
242	0	Bedroom Window Opens	14	5	14
243	1	Living Room Window is Open	14	5	25
244	2	Bathroom Window is Closed	14	5	24
245	0	Living Room Window Opens	14	5	25
246	1	Bathroom Window is Open	14	5	24
247	2	Bedroom Window is Closed	14	5	14
248	0	Living Room Window Closes	14	5	25
249	1	Bathroom Window is Closed	14	5	24
250	2	Bedroom Window is Closed	14	5	14
252	1	Bedroom Window is Closed	14	5	14
253	2	Living Room Window is Open	14	5	25
255	1	Living Room Window is Closed	14	5	25
256	2	Bathroom Window is Open	14	5	24
258	1	Bedroom Window is Open	14	5	14
259	2	Bathroom Window is Closed	14	5	24
260	0	Living Room Window Closes	14	5	25
261	1	Bathroom Window is Closed	14	5	24
262	0	Bedroom Window Opens	14	5	14
263	1	Bedroom Window is Open	14	5	14
264	2	Living Room Window is Closed	14	5	25
265	0	Bedroom Window Opens	14	5	14
266	1	Living Room Window is Open	14	5	25
267	2	Bathroom Window is Closed	14	5	24
268	0	Living Room Window Opens	14	5	25
269	1	Bathroom Window is Open	14	5	24
270	2	Bedroom Window is Closed	14	5	14
271	0	Bathroom Window Opens	14	5	24
272	1	Bedroom Window is Open	14	5	14
273	2	Living Room Window is Closed	14	5	25
274	0	Bathroom Window is Open	14	5	24
275	0	Bedroom Window is Closed	14	5	14
276	0	Living Room Window is Closed	14	5	25
277	0	Bedroom Window is Open	14	5	14
278	0	Bathroom Window is Closed	14	5	24
279	0	Living Room Window is Closed	14	5	25
280	0	Living Room Window is Open	14	5	25
281	0	Bathroom Window is Closed	14	5	24
282	0	Bedroom Window is Closed	14	5	14
283	0	HUE Lights's Color is Orange	6	2	4
284	0	It is Nighttime	55	9	17
285	0	Alice is in Living Room	63	15	12
286	0	Speakers is On	2	1	7
287	0	Smart TV is Off	2	12	5
288	0	Roomba is Off	2	18	1
289	0	Smart TV is On	2	12	5
290	0	Living Room Window is Open	14	5	25
291	0	Smart TV turns On	2	1	5
292	0	Living Room Window Opens	14	5	25
293	1	Roomba is On	2	1	1
294	1	Roomba is On	2	1	1
295	2	Smart TV is On	2	1	5
296	2	Living Room Window is Open	14	5	25
297	0	Roomba turns On	2	1	1
298	0	Smart TV turns On	2	1	5
299	1	Smart TV is On	2	1	5
300	1	Roomba is On	2	1	1
301	2	Living Room Window is Open	14	5	25
302	2	Living Room Window is Open	14	5	25
303	0	Living Room Window Opens	14	5	25
304	0	Roomba turns On	2	1	1
305	0	Smart TV turns On	2	1	5
306	0	Living Room Window Opens	14	5	25
307	1	Roomba is On	2	1	1
308	1	Roomba is On	2	1	1
309	1	Smart TV is On	2	1	5
310	0	Roomba turns On	2	1	1
311	1	Roomba is On	2	1	1
312	2	Smart TV is On	2	1	5
313	2	Living Room Window is Open	14	5	25
314	2	Living Room Window is Open	14	5	25
315	2	Smart TV is On	2	1	5
316	1	Smart TV is On	2	1	5
317	2	Living Room Window is Open	14	5	25
318	0	Smart TV turns On	2	1	5
319	0	Living Room Window Opens	14	5	25
320	0	Roomba turns On	2	1	1
321	0	Smart TV turns On	2	1	5
322	1	Roomba is On	2	1	1
323	1	Roomba is On	2	1	1
324	1	Smart TV is On	2	1	5
325	2	Living Room Window is Open	14	5	25
326	0	Living Room Window Opens	14	5	25
327	1	Roomba is On	2	1	1
328	2	Smart TV is On	2	1	5
329	2	Living Room Window is Open	14	5	25
330	2	Living Room Window is Open	14	5	25
331	1	Roomba is On	2	1	1
332	2	Smart TV is On	2	1	5
333	0	Roomba turns On	2	1	1
334	0	Smart TV turns On	2	1	5
335	0	Living Room Window Opens	14	5	25
336	0	Roomba turns On	2	1	1
339	1	Roomba is On	2	1	1
341	1	Smart TV is On	2	1	5
342	1	Roomba is On	2	1	1
343	2	Living Room Window is Open	14	5	25
344	2	Living Room Window is Open	14	5	25
345	2	Smart TV is On	2	1	5
337	1	Smart TV is On	2	1	5
338	2	Living Room Window is Open	14	5	25
340	0	Smart TV turns On	2	1	5
346	1	Roomba is On	2	1	1
347	2	Living Room Window is Open	14	5	25
348	0	Living Room Window Opens	14	5	25
349	0	Roomba turns On	2	1	1
350	0	Smart TV turns On	2	1	5
351	0	Living Room Window Opens	14	5	25
352	0	Roomba turns On	2	1	1
353	1	Roomba is On	2	1	1
354	1	Smart TV is On	2	1	5
355	1	Roomba is On	2	1	1
356	1	Roomba is On	2	1	1
357	2	Smart TV is On	2	1	5
358	1	Smart TV is On	2	1	5
359	2	Living Room Window is Open	14	5	25
360	2	Living Room Window is Open	14	5	25
361	2	Smart TV is On	2	1	5
362	2	Living Room Window is Open	14	5	25
363	0	Smart TV turns On	2	1	5
364	0	Roomba turns On	2	1	1
365	0	Living Room Window Opens	14	5	25
366	0	Smart TV turns On	2	1	5
367	1	Roomba is On	2	1	1
368	1	Smart TV is On	2	1	5
369	1	Roomba is On	2	1	1
370	0	Living Room Window Opens	14	5	25
371	2	Living Room Window is Open	14	5	25
373	2	Smart TV is On	2	1	5
374	2	Living Room Window is Open	14	5	25
375	2	Living Room Window is Open	14	5	25
376	1	Roomba is On	2	1	1
377	2	Smart TV is On	2	1	5
378	0	Roomba turns On	2	1	1
379	0	Smart TV turns On	2	1	5
380	0	Living Room Window Opens	14	5	25
381	0	Roomba turns On	2	1	1
382	1	Smart TV is On	2	1	5
383	1	Roomba is On	2	1	1
384	1	Roomba is On	2	1	1
385	2	Living Room Window is Open	14	5	25
386	0	Smart TV turns On	2	1	5
387	1	Smart TV is On	2	1	5
388	2	Living Room Window is Open	14	5	25
389	2	Smart TV is On	2	1	5
390	1	Roomba is On	2	1	1
391	2	Living Room Window is Open	14	5	25
392	2	Living Room Window is Open	14	5	25
393	0	Living Room Window Opens	14	5	25
394	0	Roomba turns On	2	1	1
395	1	Roomba is On	2	1	1
396	0	Smart TV turns On	2	1	5
397	0	Living Room Window Opens	14	5	25
398	0	Roomba turns On	2	1	1
399	2	Smart TV is On	2	1	5
400	1	Smart TV is On	2	1	5
401	1	Roomba is On	2	1	1
402	2	Living Room Window is Open	14	5	25
403	1	Roomba is On	2	1	1
404	2	Living Room Window is Open	14	5	25
405	1	Smart TV is On	2	1	5
406	2	Smart TV is On	2	1	5
407	2	Living Room Window is Open	14	5	25
408	0	Smart TV turns On	2	1	5
409	0	Living Room Window Opens	14	5	25
410	0	Roomba turns On	2	1	1
411	0	Smart TV turns On	2	1	5
412	1	Roomba is On	2	1	1
413	0	Living Room Window Opens	14	5	25
414	1	Roomba is On	2	1	1
415	2	Smart TV is On	2	1	5
416	2	Living Room Window is Open	14	5	25
417	1	Smart TV is On	2	1	5
418	1	Roomba is On	2	1	1
419	1	Roomba is On	2	1	1
420	2	Living Room Window is Open	14	5	25
421	2	Living Room Window is Open	14	5	25
422	2	Smart TV is On	2	1	5
423	0	Roomba turns On	2	1	1
424	0	Smart TV turns On	2	1	5
425	0	Living Room Window Opens	14	5	25
426	0	Roomba turns On	2	1	1
427	0	Smart TV turns On	2	1	5
428	1	Smart TV is On	2	1	5
429	1	Roomba is On	2	1	1
430	1	Roomba is On	2	1	1
431	2	Living Room Window is Open	14	5	25
432	1	Smart TV is On	2	1	5
433	1	Roomba is On	2	1	1
434	2	Smart TV is On	2	1	5
435	2	Living Room Window is Open	14	5	25
436	2	Living Room Window is Open	14	5	25
437	2	Living Room Window is Open	14	5	25
438	0	Living Room Window Opens	14	5	25
439	0	Roomba turns On	2	1	1
440	0	Smart TV turns On	2	1	5
441	1	Roomba is On	2	1	1
442	0	Living Room Window Opens	14	5	25
443	0	Roomba turns On	2	1	1
444	0	Smart TV turns On	2	1	5
445	1	Smart TV is On	2	1	5
446	1	Roomba is On	2	1	1
447	2	Smart TV is On	2	1	5
448	2	Living Room Window is Open	14	5	25
449	2	Living Room Window is Open	14	5	25
450	1	Roomba is On	2	1	1
451	1	Roomba is On	2	1	1
452	1	Smart TV is On	2	1	5
453	2	Living Room Window is Open	14	5	25
454	2	Smart TV is On	2	1	5
455	2	Living Room Window is Open	14	5	25
456	0	Living Room Window Opens	14	5	25
457	0	Roomba turns On	2	1	1
458	0	Smart TV turns On	2	1	5
459	0	Living Room Window Opens	14	5	25
461	1	Roomba is On	2	1	1
465	2	Living Room Window is Open	14	5	25
466	1	Roomba is On	2	1	1
470	2	Smart TV is On	2	1	5
460	1	Roomba is On	2	1	1
467	2	Smart TV is On	2	1	5
462	1	Smart TV is On	2	1	5
463	0	Roomba turns On	2	1	1
464	0	Smart TV turns On	2	1	5
468	2	Living Room Window is Open	14	5	25
469	1	Roomba is On	2	1	1
471	1	Smart TV is On	2	1	5
472	2	Living Room Window is Open	14	5	25
473	2	Living Room Window is Open	14	5	25
474	0	Living Room Window Opens	14	5	25
475	0	Roomba turns On	2	1	1
476	1	Roomba is On	2	1	1
477	0	Smart TV turns On	2	1	5
478	0	Living Room Window Opens	14	5	25
479	1	Smart TV is On	2	1	5
480	0	Roomba turns On	2	1	1
481	2	Smart TV is On	2	1	5
482	0	Smart TV turns On	2	1	5
483	2	Living Room Window is Open	14	5	25
484	1	Roomba is On	2	1	1
485	1	Roomba is On	2	1	1
486	1	Smart TV is On	2	1	5
487	2	Living Room Window is Open	14	5	25
488	1	Roomba is On	2	1	1
489	2	Smart TV is On	2	1	5
490	2	Living Room Window is Open	14	5	25
491	2	Living Room Window is Open	14	5	25
492	0	Living Room Window Opens	14	5	25
493	0	Roomba turns On	2	1	1
494	1	Roomba is On	2	1	1
495	0	Smart TV turns On	2	1	5
496	0	Living Room Window Opens	14	5	25
497	1	Smart TV is On	2	1	5
498	0	Roomba turns On	2	1	1
499	0	Smart TV turns On	2	1	5
500	2	Smart TV is On	2	1	5
501	2	Living Room Window is Open	14	5	25
502	1	Roomba is On	2	1	1
503	1	Roomba is On	2	1	1
504	1	Smart TV is On	2	1	5
505	1	Roomba is On	2	1	1
506	2	Living Room Window is Open	14	5	25
507	2	Smart TV is On	2	1	5
508	2	Living Room Window is Open	14	5	25
509	2	Living Room Window is Open	14	5	25
510	0	Living Room Window Opens	14	5	25
511	0	Roomba turns On	2	1	1
512	1	Roomba is On	2	1	1
513	0	Smart TV turns On	2	1	5
514	1	Smart TV is On	2	1	5
515	2	Smart TV is On	2	1	5
516	0	Living Room Window Opens	14	5	25
517	0	Roomba turns On	2	1	1
518	2	Living Room Window is Open	14	5	25
519	1	Roomba is On	2	1	1
520	0	Smart TV turns On	2	1	5
521	1	Roomba is On	2	1	1
522	1	Smart TV is On	2	1	5
523	2	Living Room Window is Open	14	5	25
524	2	Living Room Window is Open	14	5	25
525	2	Smart TV is On	2	1	5
526	1	Roomba is On	2	1	1
527	2	Living Room Window is Open	14	5	25
528	0	Living Room Window Opens	14	5	25
529	0	Roomba turns On	2	1	1
530	1	Roomba is On	2	1	1
531	1	Smart TV is On	2	1	5
532	2	Smart TV is On	2	1	5
533	2	Living Room Window is Open	14	5	25
534	0	Bathroom Window's curtains are Closed	58	5	24
535	0	Speakers is On	2	3	7
536	0	Smart TV is On	2	12	5
537	0	Smart TV is On	2	12	5
538	0	Bobbie is in Living Room	63	15	12
539	0	Smart TV turns On	2	1	5
540	0	Smart TV turns On	2	1	5
541	0	Speakers turns On	2	1	7
542	0	Bobbie Enters Living Room	63	6	12
543	0	Bathroom Window's curtains Open	58	5	24
544	1	Smart TV is On	2	1	5
545	1	Bobbie is in Living Room	63	6	12
546	1	Speakers is On	2	1	7
547	1	Smart TV is On	2	1	5
548	0	Smart TV turns On	2	1	5
549	0	Smart TV turns On	2	1	5
550	0	Speakers turns On	2	1	7
551	0	Bobbie Enters Living Room	63	6	12
552	1	Bobbie is in Living Room	63	6	12
553	0	Bathroom Window's curtains Open	58	5	24
554	1	Speakers is On	2	1	7
555	1	Smart TV is On	2	1	5
556	1	Smart TV is On	2	1	5
557	0	Smart TV is On	2	12	5
558	0	Speakers is On	2	3	7
559	0	Smart TV is On	2	12	5
560	0	Alice is not in Living Room	63	15	12
563	0	HUE Lights is On	2	2	4
564	0	Alice is in Living Room	63	15	12
565	0	It is Nighttime	55	9	17
566	0	HUE Lights is On	2	2	4
567	0	Alice is in Living Room	63	15	12
568	0	HUE Lights is Off	2	2	4
569	0	It is Nighttime	55	9	17
570	0	HUE Lights is Off	2	2	4
571	0	Alice is in Living Room	63	15	12
572	0	Living Room Window's curtains are Open	58	5	25
573	0	It is Daytime	55	9	17
574	0	HUE Lights is Off	2	2	4
577	1	Bathroom Window is Open	14	5	24
578	0	A Guest Enters Living Room	63	15	12
579	0	A Guest Enters Bathroom	63	15	12
580	1	Bathroom Window is Open	14	5	24
583	1	Bathroom Window is Open	14	5	24
585	1	A Guest is in Bedroom	63	15	12
588	1	Bathroom Window is Closed	14	5	24
589	0	A Guest Enters Living Room	63	15	12
590	0	A Guest Enters Bathroom	63	15	12
591	1	Bathroom Window is Open	14	5	24
592	0	It becomes Daytime	55	9	17
593	1	A Guest is in Bedroom	63	15	12
595	0	A Guest Exits Bathroom	63	15	12
596	1	Bathroom Window is Closed	14	5	24
598	1	Alice is not in Kitchen	63	15	12
600	1	Smart Plug is Off	2	1	6
601	0	It becomes Daytime	55	9	17
602	1	A Guest is in Bedroom	63	15	12
604	0	A Guest Exits Bathroom	63	15	12
605	1	Bathroom Window is Closed	14	5	24
606	0	A Guest Enters Living Room	63	15	12
607	0	A Guest Enters Bathroom	63	15	12
608	1	Bathroom Window is Open	14	5	24
609	0	A Guest Enters Kitchen	63	15	12
610	1	Alice is not in Kitchen	63	15	12
612	1	Smart Plug is Off	2	1	6
613	0	It becomes Daytime	55	9	17
614	1	A Guest is in Bedroom	63	15	12
616	0	A Guest Exits Bathroom	63	15	12
617	1	Bathroom Window is Closed	14	5	24
618	0	A Guest Exits Bathroom	63	15	12
619	1	Bedroom Window is Closed	14	5	14
620	0	(FitBit) I Fall Asleep	61	16	21
621	1	Security Camera is not recording	28	10	10
622	0	Front Door Lock Unlocks	13	5	13
623	1	Security Camera is not recording	28	10	10
624	0	Security Camera stops recording	28	10	10
625	1	(FitBit) I am Asleep	61	16	21
626	0	Security Camera stops recording	28	10	10
627	1	Front Door Lock is Unlocked	13	5	13
628	0	Security Camera starts recording	28	10	10
629	1	Roomba is On	2	18	1
630	0	(FitBit) I Fall Asleep	61	16	21
631	1	Front Door Lock is Unlocked	13	5	13
632	0	Front Door Lock Unlocks	13	5	13
633	1	Security Camera is not recording	28	10	10
634	2	(FitBit) I am Asleep	61	16	21
635	0	Security Camera starts recording	28	10	10
636	1	(FitBit) I am Asleep	61	16	21
637	2	Roomba is On	2	18	1
638	0	Security Camera stops recording	28	10	10
639	1	(FitBit) I am Asleep	61	16	21
640	0	(FitBit) I Fall Asleep	61	16	21
641	1	Front Door Lock is Locked	13	5	13
642	2	Security Camera is not recording	28	10	10
643	0	Security Camera starts recording	28	10	10
644	1	(FitBit) I am Awake	61	16	21
646	0	Security Camera stops recording	28	10	10
647	1	Front Door Lock is Unlocked	13	5	13
648	2	(FitBit) I am Awake	61	16	21
650	1	(FitBit) I am Asleep	61	16	21
651	2	Front Door Lock is Unlocked	13	5	13
652	0	Security Camera starts recording	28	10	10
653	1	Front Door Lock is Locked	13	5	13
654	0	Security Camera stops recording	28	10	10
655	1	(FitBit) I am Asleep	61	16	21
656	2	Front Door Lock is Unlocked	13	5	13
657	0	Front Door Lock Unlocks	13	5	13
659	1	Front Door Lock is Unlocked	13	5	13
661	1	Security Camera is not recording	28	10	10
662	2	(FitBit) I am Asleep	61	16	21
664	1	(FitBit) I am Asleep	61	16	21
665	2	Roomba is On	2	18	1
667	1	(FitBit) I am Asleep	61	16	21
669	1	Front Door Lock is Locked	13	5	13
670	2	Security Camera is not recording	28	10	10
672	1	(FitBit) I am Asleep	61	16	21
673	2	Front Door Lock is Unlocked	13	5	13
676	1	Front Door Lock is Unlocked	13	5	13
677	0	(FitBit) I Fall Asleep	61	16	21
678	1	Front Door Lock is Unlocked	13	5	13
679	0	Front Door Lock Unlocks	13	5	13
680	1	Security Camera is not recording	28	10	10
681	2	(FitBit) I am Asleep	61	16	21
682	0	Security Camera starts recording	28	10	10
683	1	(FitBit) I am Asleep	61	16	21
684	2	Roomba is On	2	18	1
685	0	Security Camera stops recording	28	10	10
686	1	(FitBit) I am Asleep	61	16	21
687	0	(FitBit) I Fall Asleep	61	16	21
688	1	Front Door Lock is Locked	13	5	13
689	2	Security Camera is not recording	28	10	10
690	0	Security Camera stops recording	28	10	10
691	1	(FitBit) I am Asleep	61	16	21
692	2	Front Door Lock is Unlocked	13	5	13
693	0	Front Door Lock Unlocks	13	5	13
694	0	Security Camera starts recording	28	10	10
695	1	Front Door Lock is Unlocked	13	5	13
696	0	(FitBit) I Fall Asleep	61	16	21
697	1	Front Door Lock is Unlocked	13	5	13
698	0	Security Camera stops recording	28	10	10
699	1	(FitBit) I am Asleep	61	16	21
700	0	(FitBit) I Fall Asleep	61	16	21
701	1	Front Door Lock is Locked	13	5	13
702	2	Security Camera is not recording	28	10	10
703	0	Security Camera stops recording	28	10	10
704	1	Front Door Lock is Unlocked	13	5	13
705	2	(FitBit) I am Awake	61	16	21
706	0	Security Camera stops recording	28	10	10
707	1	(FitBit) I am Asleep	61	16	21
708	2	Front Door Lock is Unlocked	13	5	13
709	0	Front Door Lock Unlocks	13	5	13
710	0	Security Camera starts recording	28	10	10
711	1	Front Door Lock is Unlocked	13	5	13
712	0	Security Camera starts recording	28	10	10
713	1	Roomba is On	2	18	1
714	2	Front Door Lock is Locked	13	5	13
715	0	(FitBit) I Fall Asleep	61	16	21
716	1	Front Door Lock is Unlocked	13	5	13
717	0	Front Door Lock Unlocks	13	5	13
718	1	Security Camera is not recording	28	10	10
719	2	(FitBit) I am Asleep	61	16	21
720	0	Security Camera starts recording	28	10	10
721	1	(FitBit) I am Asleep	61	16	21
722	2	Roomba is On	2	18	1
723	0	Security Camera stops recording	28	10	10
724	1	(FitBit) I am Asleep	61	16	21
725	0	(FitBit) I Fall Asleep	61	16	21
726	1	Front Door Lock is Locked	13	5	13
727	2	Security Camera is not recording	28	10	10
728	0	Security Camera starts recording	28	10	10
729	1	(FitBit) I am Awake	61	16	21
730	0	Security Camera stops recording	28	10	10
731	1	Front Door Lock is Unlocked	13	5	13
732	2	(FitBit) I am Awake	61	16	21
733	0	Security Camera starts recording	28	10	10
734	1	Front Door Lock is Locked	13	5	13
735	0	Security Camera stops recording	28	10	10
736	1	(FitBit) I am Asleep	61	16	21
737	2	Front Door Lock is Unlocked	13	5	13
738	0	Front Door Lock Unlocks	13	5	13
739	0	(FitBit) I Fall Asleep	61	16	21
740	1	Front Door Lock is Unlocked	13	5	13
741	0	Front Door Lock Unlocks	13	5	13
742	1	Security Camera is not recording	28	10	10
743	2	(FitBit) I am Asleep	61	16	21
744	0	Security Camera starts recording	28	10	10
745	1	(FitBit) I am Asleep	61	16	21
746	2	Roomba is On	2	18	1
747	0	Security Camera stops recording	28	10	10
748	1	(FitBit) I am Asleep	61	16	21
749	0	(FitBit) I Fall Asleep	61	16	21
750	1	Front Door Lock is Locked	13	5	13
751	2	Security Camera is not recording	28	10	10
752	0	Security Camera stops recording	28	10	10
753	1	(FitBit) I am Asleep	61	16	21
754	2	Front Door Lock is Unlocked	13	5	13
755	0	Front Door Lock Unlocks	13	5	13
756	0	Security Camera starts recording	28	10	10
757	1	Front Door Lock is Unlocked	13	5	13
758	0	(FitBit) I Fall Asleep	61	16	21
759	1	Front Door Lock is Unlocked	13	5	13
760	0	Security Camera stops recording	28	10	10
761	1	(FitBit) I am Asleep	61	16	21
762	0	(FitBit) I Fall Asleep	61	16	21
763	1	Front Door Lock is Locked	13	5	13
764	2	Security Camera is not recording	28	10	10
765	0	Security Camera stops recording	28	10	10
766	1	Front Door Lock is Unlocked	13	5	13
767	2	(FitBit) I am Awake	61	16	21
768	0	Security Camera stops recording	28	10	10
769	1	(FitBit) I am Asleep	61	16	21
770	2	Front Door Lock is Unlocked	13	5	13
771	0	Front Door Lock Unlocks	13	5	13
772	0	Security Camera starts recording	28	10	10
773	1	Front Door Lock is Unlocked	13	5	13
774	0	Security Camera starts recording	28	10	10
775	1	Roomba is On	2	18	1
776	2	Front Door Lock is Locked	13	5	13
777	0	It starts raining	20	7	18
778	0	It stops raining	20	7	18
779	0	Living Room Window Closes	14	5	25
780	1	It is Daytime	55	9	17
781	0	HUE Lights turns Off	2	2	4
782	1	Living Room Window's curtains are Closed	58	5	25
783	2	It is Daytime	55	9	17
784	0	It becomes Nighttime	55	9	17
785	0	Living Room Window's curtains Close	58	5	25
786	1	It is Nighttime	55	9	17
788	1	It is Nighttime	55	9	17
789	2	Living Room Window's curtains are Open	58	5	25
790	0	It starts raining	20	7	18
791	0	It stops raining	20	7	18
792	0	Bedroom Window Opens	14	5	14
793	1	It is Nighttime	55	9	17
794	0	It becomes Nighttime	55	9	17
795	1	Living Room Window's curtains are Closed	58	5	25
796	0	HUE Lights turns Off	2	2	4
797	1	Living Room Window's curtains are Closed	58	5	25
798	0	It becomes Nighttime	55	9	17
799	1	HUE Lights is Off	2	2	4
800	2	Living Room Window's curtains are Open	58	5	25
801	0	It becomes Nighttime	55	9	17
802	1	Bedroom Window is Open	14	5	14
803	0	Living Room Window's curtains Close	58	5	25
804	1	HUE Lights is Off	2	2	4
805	0	HUE Lights turns Off	2	2	4
806	1	It is Nighttime	55	9	17
807	0	It starts raining	20	7	18
808	0	It stops raining	20	7	18
809	0	Bedroom Window Opens	14	5	14
810	1	It is Nighttime	55	9	17
811	0	It becomes Nighttime	55	9	17
812	1	Living Room Window's curtains are Closed	58	5	25
813	0	HUE Lights turns Off	2	2	4
814	1	Living Room Window's curtains are Closed	58	5	25
815	0	It becomes Nighttime	55	9	17
816	1	HUE Lights is Off	2	2	4
817	2	Living Room Window's curtains are Open	58	5	25
818	0	It becomes Nighttime	55	9	17
819	1	Bedroom Window is Open	14	5	14
820	0	Living Room Window's curtains Close	58	5	25
821	1	HUE Lights is Off	2	2	4
822	0	HUE Lights turns Off	2	2	4
823	1	It is Nighttime	55	9	17
824	0	It stops raining	20	7	18
825	1	It is Daytime	55	9	17
827	1	It is Nighttime	55	9	17
828	0	Living Room Window's curtains are Open	58	5	25
829	0	It is Daytime	55	9	17
830	0	Alice is in Living Room	63	15	12
831	0	HUE Lights is Off	2	2	4
832	0	Alice Enters Living Room	63	6	12
833	0	Living Room Window's curtains Close	58	5	25
834	0	HUE Lights turns Off	2	1	4
835	1	It is Daytime	55	9	17
836	1	Living Room Window's curtains are Closed	58	5	25
837	1	Living Room Window's curtains are Closed	58	5	25
838	2	Alice is in Living Room	63	6	12
839	2	It is Daytime	55	9	17
840	2	It is Daytime	55	9	17
841	3	HUE Lights is Off	2	1	4
842	3	Alice is in Living Room	63	6	12
843	3	HUE Lights is Off	2	1	4
844	0	It becomes Daytime	55	9	17
845	0	Alice Enters Living Room	63	6	12
846	0	Living Room Window's curtains Close	58	5	25
847	1	Living Room Window's curtains are Closed	58	5	25
848	1	It is Daytime	55	9	17
849	1	Living Room Window's curtains are Closed	58	5	25
850	2	Alice is in Living Room	63	6	12
851	2	Alice is in Living Room	63	6	12
852	2	It is Daytime	55	9	17
853	3	HUE Lights is Off	2	1	4
854	3	HUE Lights is Off	2	1	4
855	3	HUE Lights is Off	2	1	4
856	0	HUE Lights turns Off	2	1	4
857	0	It becomes Daytime	55	9	17
858	0	Alice Enters Living Room	63	6	12
859	1	Living Room Window's curtains are Closed	58	5	25
860	1	Living Room Window's curtains are Closed	58	5	25
861	2	It is Daytime	55	9	17
862	2	Alice is in Living Room	63	6	12
863	1	Living Room Window's curtains are Closed	58	5	25
864	3	Alice is in Living Room	63	6	12
865	3	HUE Lights is Off	2	1	4
866	2	It is Daytime	55	9	17
867	3	HUE Lights is Off	2	1	4
868	0	Living Room Window's curtains Close	58	5	25
869	0	HUE Lights turns Off	2	1	4
870	0	It becomes Daytime	55	9	17
871	1	It is Daytime	55	9	17
872	1	Living Room Window's curtains are Closed	58	5	25
873	1	Living Room Window's curtains are Closed	58	5	25
874	2	Alice is in Living Room	63	6	12
875	2	It is Daytime	55	9	17
876	2	Alice is in Living Room	63	6	12
877	3	Alice is in Living Room	63	6	12
878	3	HUE Lights is Off	2	1	4
879	3	HUE Lights is Off	2	1	4
880	0	Alice Enters Living Room	63	6	12
881	0	Living Room Window's curtains Close	58	5	25
882	0	HUE Lights turns Off	2	1	4
883	1	Living Room Window's curtains are Closed	58	5	25
884	1	It is Daytime	55	9	17
885	1	Living Room Window's curtains are Closed	58	5	25
886	2	Alice is in Living Room	63	6	12
887	2	It is Daytime	55	9	17
888	2	It is Daytime	55	9	17
889	3	HUE Lights is Off	2	1	4
890	3	HUE Lights is Off	2	1	4
891	3	Alice is in Living Room	63	6	12
892	0	It becomes Daytime	55	9	17
893	0	Alice Enters Living Room	63	6	12
894	0	Living Room Window's curtains Close	58	5	25
895	1	Living Room Window's curtains are Closed	58	5	25
896	1	Living Room Window's curtains are Closed	58	5	25
897	2	Alice is in Living Room	63	6	12
898	2	It is Daytime	55	9	17
899	1	It is Daytime	55	9	17
900	3	HUE Lights is Off	2	1	4
901	3	HUE Lights is Off	2	1	4
902	2	Alice is in Living Room	63	6	12
903	3	HUE Lights is Off	2	1	4
904	0	HUE Lights turns Off	2	1	4
905	0	It becomes Daytime	55	9	17
906	1	Living Room Window's curtains are Closed	58	5	25
907	0	Alice Enters Living Room	63	6	12
908	2	It is Daytime	55	9	17
909	1	Living Room Window's curtains are Closed	58	5	25
910	3	Alice is in Living Room	63	6	12
911	1	Living Room Window's curtains are Closed	58	5	25
912	2	Alice is in Living Room	63	6	12
913	2	It is Daytime	55	9	17
914	3	HUE Lights is Off	2	1	4
915	3	HUE Lights is Off	2	1	4
916	0	Living Room Window's curtains Close	58	5	25
917	0	HUE Lights turns Off	2	1	4
918	0	It becomes Daytime	55	9	17
919	1	It is Daytime	55	9	17
920	1	Living Room Window's curtains are Closed	58	5	25
921	2	Alice is in Living Room	63	6	12
922	2	It is Daytime	55	9	17
923	1	Living Room Window's curtains are Closed	58	5	25
924	3	Alice is in Living Room	63	6	12
925	3	HUE Lights is Off	2	1	4
926	2	Alice is in Living Room	63	6	12
927	3	HUE Lights is Off	2	1	4
928	0	Alice Enters Living Room	63	6	12
929	0	Living Room Window's curtains Close	58	5	25
930	0	HUE Lights turns Off	2	1	4
931	1	Living Room Window's curtains are Closed	58	5	25
932	1	It is Daytime	55	9	17
933	2	Alice is in Living Room	63	6	12
934	2	It is Daytime	55	9	17
935	1	Living Room Window's curtains are Closed	58	5	25
936	3	HUE Lights is Off	2	1	4
937	0	It becomes Daytime	55	9	17
938	0	Alice Enters Living Room	63	6	12
939	3	HUE Lights is Off	2	1	4
940	0	Living Room Window's curtains Close	58	5	25
941	2	It is Daytime	55	9	17
942	1	Living Room Window's curtains are Closed	58	5	25
943	3	Alice is in Living Room	63	6	12
944	1	Living Room Window's curtains are Closed	58	5	25
945	1	It is Daytime	55	9	17
946	2	Alice is in Living Room	63	6	12
947	2	It is Daytime	55	9	17
948	2	Alice is in Living Room	63	6	12
949	3	HUE Lights is Off	2	1	4
950	0	HUE Lights turns Off	2	1	4
951	0	It becomes Daytime	55	9	17
952	3	HUE Lights is Off	2	1	4
953	3	HUE Lights is Off	2	1	4
954	1	Living Room Window's curtains are Closed	58	5	25
955	1	Living Room Window's curtains are Closed	58	5	25
956	2	It is Daytime	55	9	17
957	0	Alice Enters Living Room	63	6	12
958	2	Alice is in Living Room	63	6	12
959	3	Alice is in Living Room	63	6	12
960	0	Living Room Window's curtains Close	58	5	25
961	1	Living Room Window's curtains are Closed	58	5	25
962	0	HUE Lights turns Off	2	1	4
963	3	HUE Lights is Off	2	1	4
964	0	It becomes Daytime	55	9	17
965	2	It is Daytime	55	9	17
966	1	It is Daytime	55	9	17
967	3	HUE Lights is Off	2	1	4
968	1	Living Room Window's curtains are Closed	58	5	25
969	2	Alice is in Living Room	63	6	12
970	1	Living Room Window's curtains are Closed	58	5	25
971	2	It is Daytime	55	9	17
972	3	HUE Lights is Off	2	1	4
973	3	Alice is in Living Room	63	6	12
974	2	Alice is in Living Room	63	6	12
975	0	Alice Enters Living Room	63	6	12
976	3	HUE Lights is Off	2	1	4
977	0	Living Room Window's curtains Close	58	5	25
978	1	Living Room Window's curtains are Closed	58	5	25
979	0	HUE Lights turns Off	2	1	4
980	2	It is Daytime	55	9	17
981	1	It is Daytime	55	9	17
982	3	HUE Lights is Off	2	1	4
983	2	Alice is in Living Room	63	6	12
984	1	Living Room Window's curtains are Closed	58	5	25
985	0	It becomes Daytime	55	9	17
986	0	Alice Enters Living Room	63	6	12
987	3	HUE Lights is Off	2	1	4
988	2	It is Daytime	55	9	17
989	1	Living Room Window's curtains are Closed	58	5	25
990	1	Living Room Window's curtains are Closed	58	5	25
991	0	Living Room Window's curtains Close	58	5	25
992	3	Alice is in Living Room	63	6	12
993	2	Alice is in Living Room	63	6	12
994	2	It is Daytime	55	9	17
995	1	It is Daytime	55	9	17
996	0	HUE Lights turns Off	2	1	4
997	3	HUE Lights is Off	2	1	4
998	3	HUE Lights is Off	2	1	4
999	0	It becomes Daytime	55	9	17
1000	2	Alice is in Living Room	63	6	12
1001	1	Living Room Window's curtains are Closed	58	5	25
1002	1	Living Room Window's curtains are Closed	58	5	25
1003	3	HUE Lights is Off	2	1	4
1004	2	It is Daytime	55	9	17
1005	2	Alice is in Living Room	63	6	12
1006	0	Alice Enters Living Room	63	6	12
1007	3	Alice is in Living Room	63	6	12
1008	0	Living Room Window's curtains Close	58	5	25
1009	3	HUE Lights is Off	2	1	4
1010	0	HUE Lights turns Off	2	1	4
1014	1	Living Room Window's curtains are Closed	58	5	25
1017	2	It is Daytime	55	9	17
1020	3	Alice is in Living Room	63	6	12
1011	1	Living Room Window's curtains are Closed	58	5	25
1015	2	It is Daytime	55	9	17
1018	3	HUE Lights is Off	2	1	4
1012	1	It is Daytime	55	9	17
1013	2	Alice is in Living Room	63	6	12
1016	0	It becomes Daytime	55	9	17
1019	3	HUE Lights is Off	2	1	4
1021	0	Alice Enters Living Room	63	6	12
1022	1	Living Room Window's curtains are Closed	58	5	25
1023	0	Living Room Window's curtains Close	58	5	25
1024	2	Alice is in Living Room	63	6	12
1025	1	Living Room Window's curtains are Closed	58	5	25
1026	1	It is Daytime	55	9	17
1027	3	HUE Lights is Off	2	1	4
1028	2	It is Daytime	55	9	17
1029	2	Alice is in Living Room	63	6	12
1030	3	HUE Lights is Off	2	1	4
1031	3	HUE Lights is Off	2	1	4
1032	0	HUE Lights turns Off	2	1	4
1033	0	Alice Enters Living Room	63	6	12
1034	0	It becomes Daytime	55	9	17
1035	0	Living Room Window's curtains Close	58	5	25
1036	1	Living Room Window's curtains are Closed	58	5	25
1037	0	HUE Lights turns Off	2	1	4
1038	1	Living Room Window's curtains are Closed	58	5	25
1039	1	Living Room Window's curtains are Closed	58	5	25
1040	1	It is Daytime	55	9	17
1041	0	It becomes Daytime	55	9	17
1042	2	It is Daytime	55	9	17
1043	0	Alice Enters Living Room	63	6	12
1044	2	Alice is in Living Room	63	6	12
1045	2	It is Daytime	55	9	17
1046	3	Alice is in Living Room	63	6	12
1047	1	Living Room Window's curtains are Closed	58	5	25
1048	2	Alice is in Living Room	63	6	12
1049	1	Living Room Window's curtains are Closed	58	5	25
1050	3	HUE Lights is Off	2	1	4
1051	3	HUE Lights is Off	2	1	4
1052	2	It is Daytime	55	9	17
1053	1	Living Room Window's curtains are Closed	58	5	25
1054	3	HUE Lights is Off	2	1	4
1055	2	Alice is in Living Room	63	6	12
1056	3	Alice is in Living Room	63	6	12
1057	2	It is Daytime	55	9	17
1058	3	HUE Lights is Off	2	1	4
1059	3	HUE Lights is Off	2	1	4
1060	0	Living Room Window's curtains Close	58	5	25
1061	0	HUE Lights turns Off	2	1	4
1062	0	It becomes Daytime	55	9	17
1063	0	Alice Enters Living Room	63	6	12
1064	0	Living Room Window's curtains Close	58	5	25
1065	1	It is Daytime	55	9	17
1066	0	HUE Lights turns Off	2	1	4
1067	1	Living Room Window's curtains are Closed	58	5	25
1068	1	Living Room Window's curtains are Closed	58	5	25
1069	0	It becomes Daytime	55	9	17
1070	2	Alice is in Living Room	63	6	12
1071	1	It is Daytime	55	9	17
1072	1	Living Room Window's curtains are Closed	58	5	25
1073	2	Alice is in Living Room	63	6	12
1074	2	It is Daytime	55	9	17
1075	1	Living Room Window's curtains are Closed	58	5	25
1076	2	Alice is in Living Room	63	6	12
1077	3	Alice is in Living Room	63	6	12
1078	3	HUE Lights is Off	2	1	4
1079	2	It is Daytime	55	9	17
1080	1	Living Room Window's curtains are Closed	58	5	25
1081	3	HUE Lights is Off	2	1	4
1082	2	It is Daytime	55	9	17
1083	3	HUE Lights is Off	2	1	4
1084	3	Alice is in Living Room	63	6	12
1085	3	HUE Lights is Off	2	1	4
1086	2	Alice is in Living Room	63	6	12
1087	3	HUE Lights is Off	2	1	4
1088	0	Smart TV turns On	2	1	5
1089	1	Roomba is On	2	1	1
1090	2	Living Room Window is Open	14	5	25
1091	0	Living Room Window Opens	14	5	25
1092	1	Roomba is On	2	1	1
1093	2	Smart TV is On	2	1	5
1094	0	Roomba turns On	2	1	1
1095	1	Smart TV is On	2	1	5
1096	2	Living Room Window is Open	14	5	25
1097	0	Smart TV turns On	2	1	5
1098	1	Roomba is On	2	1	1
1099	2	Living Room Window is Open	14	5	25
1100	0	Living Room Window Opens	14	5	25
1101	1	Roomba is On	2	1	1
1102	2	Smart TV is On	2	1	5
1103	0	Roomba turns On	2	1	1
1104	1	Smart TV is On	2	1	5
1105	2	Living Room Window is Open	14	5	25
1106	0	Smart TV turns On	2	1	5
1107	1	Roomba is On	2	1	1
1108	2	Living Room Window is Open	14	5	25
1109	0	Living Room Window Opens	14	5	25
1110	1	Roomba is On	2	1	1
1111	2	Smart TV is On	2	1	5
1112	0	Roomba turns On	2	1	1
1113	1	Smart TV is On	2	1	5
1114	2	Living Room Window is Open	14	5	25
1115	0	Smart TV turns On	2	1	5
1116	1	Roomba is On	2	1	1
1117	2	Living Room Window is Open	14	5	25
1118	0	Living Room Window Opens	14	5	25
1119	1	Roomba is On	2	1	1
1120	2	Smart TV is On	2	1	5
1121	0	Roomba turns On	2	1	1
1122	1	Smart TV is On	2	1	5
1123	2	Living Room Window is Open	14	5	25
1124	0	Smart TV turns On	2	1	5
1125	1	Roomba is On	2	1	1
1126	2	Living Room Window is Open	14	5	25
1127	0	Living Room Window Opens	14	5	25
1128	1	Roomba is On	2	1	1
1129	2	Smart TV is On	2	1	5
1130	0	Roomba turns On	2	1	1
1131	1	Smart TV is On	2	1	5
1132	2	Living Room Window is Open	14	5	25
1133	0	Smart TV turns On	2	1	5
1134	1	Roomba is On	2	1	1
1135	2	Living Room Window is Open	14	5	25
1136	0	Living Room Window Opens	14	5	25
1137	1	Roomba is On	2	1	1
1138	2	Smart TV is On	2	1	5
1139	0	Roomba turns On	2	1	1
1140	1	Smart TV is On	2	1	5
1141	2	Living Room Window is Open	14	5	25
1142	0	Smart TV turns On	2	1	5
1143	1	Roomba is On	2	1	1
1144	2	Living Room Window is Open	14	5	25
1145	0	Living Room Window Opens	14	5	25
1146	1	Roomba is On	2	1	1
1147	2	Smart TV is On	2	1	5
1148	0	Roomba turns On	2	1	1
1149	1	Smart TV is On	2	1	5
1150	2	Living Room Window is Open	14	5	25
1151	0	Smart TV turns On	2	1	5
1152	1	Roomba is On	2	1	1
1153	2	Living Room Window is Open	14	5	25
1154	0	Living Room Window Opens	14	5	25
1155	1	Roomba is On	2	1	1
1156	2	Smart TV is On	2	1	5
1157	0	Roomba turns On	2	1	1
1158	1	Smart TV is On	2	1	5
1159	2	Living Room Window is Open	14	5	25
1160	0	Smart TV turns On	2	1	5
1161	1	Roomba is On	2	1	1
1162	2	Living Room Window is Open	14	5	25
1163	0	Roomba turns On	2	1	1
1164	1	Smart TV is On	2	1	5
1165	2	Living Room Window is Open	14	5	25
1166	0	Living Room Window Opens	14	5	25
1167	1	Roomba is On	2	1	1
1168	2	Smart TV is On	2	1	5
1169	0	Smart TV turns On	2	1	5
1170	1	Roomba is On	2	1	1
1171	2	Living Room Window is Open	14	5	25
1172	0	Living Room Window Opens	14	5	25
1173	1	Roomba is On	2	1	1
1174	2	Smart TV is On	2	1	5
1175	0	Roomba turns On	2	1	1
1176	1	Smart TV is On	2	1	5
1177	2	Living Room Window is Open	14	5	25
1178	0	Smart TV turns On	2	1	5
1179	1	Roomba is On	2	1	1
1180	2	Living Room Window is Open	14	5	25
1181	0	Living Room Window Opens	14	5	25
1182	1	Roomba is On	2	1	1
1183	2	Smart TV is On	2	1	5
1184	0	Roomba turns On	2	1	1
1185	1	Smart TV is On	2	1	5
1186	2	Living Room Window is Open	14	5	25
1187	0	Smart TV turns On	2	1	5
1188	1	Roomba is On	2	1	1
1189	2	Living Room Window is Open	14	5	25
1190	0	Living Room Window Opens	14	5	25
1191	1	Roomba is On	2	1	1
1192	2	Smart TV is On	2	1	5
1193	0	Roomba turns On	2	1	1
1194	1	Smart TV is On	2	1	5
1195	2	Living Room Window is Open	14	5	25
1196	0	Smart TV turns On	2	1	5
1197	1	Roomba is On	2	1	1
1198	2	Living Room Window is Open	14	5	25
1199	0	Living Room Window Opens	14	5	25
1200	1	Roomba is On	2	1	1
1201	2	Smart TV is On	2	1	5
1202	0	Roomba turns On	2	1	1
1203	1	Smart TV is On	2	1	5
1204	2	Living Room Window is Open	14	5	25
1205	0	Smart TV turns On	2	1	5
1206	1	Roomba is On	2	1	1
1207	2	Living Room Window is Open	14	5	25
1208	0	Living Room Window Opens	14	5	25
1209	1	Roomba is On	2	1	1
1210	2	Smart TV is On	2	1	5
1211	0	Roomba turns On	2	1	1
1212	1	Smart TV is On	2	1	5
1213	2	Living Room Window is Open	14	5	25
1214	0	Living Room Window Opens	14	5	25
1215	1	Roomba is On	2	1	1
1216	2	Smart TV is On	2	1	5
1217	0	Smart TV turns On	2	1	5
1218	1	Roomba is On	2	1	1
1219	2	Living Room Window is Open	14	5	25
1220	0	Roomba turns On	2	1	1
1221	1	Smart TV is On	2	1	5
1222	2	Living Room Window is Open	14	5	25
1223	0	Smart TV turns On	2	1	5
1224	1	Roomba is On	2	1	1
1225	2	Living Room Window is Open	14	5	25
1226	0	Living Room Window Opens	14	5	25
1227	1	Roomba is On	2	1	1
1228	2	Smart TV is On	2	1	5
1229	0	Roomba turns On	2	1	1
1230	1	Smart TV is On	2	1	5
1231	2	Living Room Window is Open	14	5	25
1232	0	Smart TV turns On	2	1	5
1233	1	Roomba is On	2	1	1
1234	2	Living Room Window is Open	14	5	25
1235	0	Living Room Window Opens	14	5	25
1236	1	Roomba is On	2	1	1
1237	2	Smart TV is On	2	1	5
1238	0	Roomba turns On	2	1	1
1239	1	Smart TV is On	2	1	5
1240	2	Living Room Window is Open	14	5	25
1241	0	Smart TV turns On	2	1	5
1242	1	Roomba is On	2	1	1
1243	2	Living Room Window is Open	14	5	25
1244	0	Living Room Window Opens	14	5	25
1245	1	Roomba is On	2	1	1
1246	2	Smart TV is On	2	1	5
1247	0	Roomba turns On	2	1	1
1248	1	Smart TV is On	2	1	5
1249	2	Living Room Window is Open	14	5	25
1250	0	Smart TV turns On	2	1	5
1251	1	Roomba is On	2	1	1
1252	2	Living Room Window is Open	14	5	25
1253	0	Roomba turns On	2	1	1
1254	1	Smart TV is On	2	1	5
1255	2	Living Room Window is Open	14	5	25
1256	0	Living Room Window Opens	14	5	25
1257	1	Roomba is On	2	1	1
1258	2	Smart TV is On	2	1	5
1259	0	Smart TV turns On	2	1	5
1260	1	Roomba is On	2	1	1
1261	2	Living Room Window is Open	14	5	25
1262	0	Living Room Window Opens	14	5	25
1263	1	Roomba is On	2	1	1
1264	2	Smart TV is On	2	1	5
1265	0	Roomba turns On	2	1	1
1266	1	Smart TV is On	2	1	5
1267	2	Living Room Window is Open	14	5	25
1268	0	Smart TV turns On	2	1	5
1269	1	Roomba is On	2	1	1
1270	2	Living Room Window is Open	14	5	25
1271	0	Living Room Window Opens	14	5	25
1272	1	Roomba is On	2	1	1
1273	2	Smart TV is On	2	1	5
1274	0	Roomba turns On	2	1	1
1275	1	Smart TV is On	2	1	5
1276	2	Living Room Window is Open	14	5	25
1277	0	Smart TV turns On	2	1	5
1278	1	Roomba is On	2	1	1
1279	2	Living Room Window is Open	14	5	25
1280	0	Living Room Window Opens	14	5	25
1281	1	Roomba is On	2	1	1
1282	2	Smart TV is On	2	1	5
1283	0	Roomba turns On	2	1	1
1284	1	Smart TV is On	2	1	5
1285	2	Living Room Window is Open	14	5	25
1286	0	Smart TV turns On	2	1	5
1287	1	Roomba is On	2	1	1
1288	2	Living Room Window is Open	14	5	25
1289	0	Living Room Window Opens	14	5	25
1290	1	Roomba is On	2	1	1
1291	2	Smart TV is On	2	1	5
1292	0	Roomba turns On	2	1	1
1293	1	Smart TV is On	2	1	5
1294	2	Living Room Window is Open	14	5	25
1295	0	Living Room Window Opens	14	5	25
1296	1	Roomba is On	2	1	1
1297	2	Smart TV is On	2	1	5
1298	0	Smart TV turns On	2	1	5
1299	1	Roomba is On	2	1	1
1300	2	Living Room Window is Open	14	5	25
1301	0	Roomba turns On	2	1	1
1302	1	Smart TV is On	2	1	5
1303	2	Living Room Window is Open	14	5	25
1304	0	Smart TV turns On	2	1	5
1305	1	Roomba is On	2	1	1
1306	2	Living Room Window is Open	14	5	25
1307	0	Living Room Window Opens	14	5	25
1308	1	Roomba is On	2	1	1
1309	2	Smart TV is On	2	1	5
1310	0	Roomba turns On	2	1	1
1311	1	Smart TV is On	2	1	5
1312	2	Living Room Window is Open	14	5	25
1313	0	Smart TV turns On	2	1	5
1314	1	Roomba is On	2	1	1
1315	2	Living Room Window is Open	14	5	25
1316	0	Living Room Window Opens	14	5	25
1317	1	Roomba is On	2	1	1
1318	2	Smart TV is On	2	1	5
1319	0	Roomba turns On	2	1	1
1320	1	Smart TV is On	2	1	5
1321	2	Living Room Window is Open	14	5	25
1322	0	Smart TV turns On	2	1	5
1323	1	Roomba is On	2	1	1
1324	2	Living Room Window is Open	14	5	25
1325	0	Living Room Window Opens	14	5	25
1326	1	Roomba is On	2	1	1
1327	2	Smart TV is On	2	1	5
1328	0	Roomba turns On	2	1	1
1329	1	Smart TV is On	2	1	5
1330	2	Living Room Window is Open	14	5	25
1331	0	Alice Exits Bathroom	63	15	12
1332	1	(Thermostat) The temperature is below 5 degrees	19	8	2
1333	0	(Thermostat) The temperature goes above 75 degrees	19	8	2
1334	0	Alice Enters Bedroom	63	15	12
1335	1	(Thermostat) The temperature is below 60 degrees	19	8	2
1336	0	(Thermostat) The temperature falls below 70 degrees	19	8	2
1337	0	(Thermostat) The temperature falls below 60 degrees	19	8	2
1338	1	Alice is not in Home	63	15	12
1339	0	Alice Exits Bathroom	63	15	12
1340	1	(Thermostat) The temperature is below 5 degrees	19	8	2
1341	0	(Thermostat) The temperature goes above 75 degrees	19	8	2
1342	0	Alice Enters Bedroom	63	15	12
1343	1	(Thermostat) The temperature is below 60 degrees	19	8	2
1346	1	Alice is not in Home	63	15	12
1347	0	(Thermostat) The temperature goes above 70 degrees	19	8	2
1348	1	Living Room Window is Open	14	5	25
1350	1	Alice is not in Home	63	15	12
1351	0	(Thermostat) The temperature falls below 70 degrees	19	8	2
1352	0	(Thermostat) The temperature falls below 60 degrees	19	8	2
1353	1	Alice is not in Home	63	15	12
1354	0	(Thermostat) The temperature falls below 75 degrees	19	8	2
1355	1	The AC is On	57	8	2
1357	1	(Thermostat) The temperature is below 5 degrees	19	8	2
1358	0	(Thermostat) The temperature goes above 75 degrees	19	8	2
1360	1	(Thermostat) The temperature is below 60 degrees	19	8	2
1362	1	Living Room Window is Open	14	5	25
1365	1	Alice is not in Home	63	15	12
1367	1	The AC is On	57	8	2
1368	0	(Thermostat) The temperature falls below 70 degrees	19	8	2
1369	0	Alice Exits Bathroom	63	15	12
1370	1	(Thermostat) The temperature is below 5 degrees	19	8	2
1371	0	(Thermostat) The temperature goes above 75 degrees	19	8	2
1372	1	Living Room Window is Open	14	5	25
1373	0	(Thermostat) The temperature falls below 60 degrees	19	8	2
1374	1	Alice is not in Home	63	15	12
1375	0	(Thermostat) The temperature falls below 70 degrees	19	8	2
1376	1	The AC is On	57	8	2
1377	0	Alice Enters Bedroom	63	15	12
1378	1	(Thermostat) The temperature is below 60 degrees	19	8	2
1379	0	Living Room Window Opens	14	5	25
1380	1	Bathroom Window is Closed	14	5	24
1381	2	Bedroom Window is Open	14	5	14
1382	0	Bathroom Window Opens	14	5	24
1383	1	Living Room Window is Open	14	5	25
1384	2	Bedroom Window is Closed	14	5	14
1385	0	Bedroom Window Opens	14	5	14
1386	1	Living Room Window is Closed	14	5	25
1387	2	Bathroom Window is Open	14	5	24
1388	0	Bathroom Window Closes	14	5	24
1389	1	Bedroom Window is Closed	14	5	14
1390	2	Living Room Window is Closed	14	5	25
1391	0	Bedroom Window Closes	14	5	14
1392	1	Living Room Window is Closed	14	5	25
1393	2	Bathroom Window is Closed	14	5	24
1395	1	Bathroom Window is Closed	14	5	24
1396	2	Bathroom Window is Closed	14	5	24
1397	0	Bathroom Window Opens	14	5	24
1398	1	Bedroom Window is Open	14	5	14
1399	2	Living Room Window is Closed	14	5	25
1400	0	Bedroom Window Opens	14	5	14
1401	1	Living Room Window is Open	14	5	25
1402	2	Bathroom Window is Closed	14	5	24
1403	0	Living Room Window Opens	14	5	25
1404	1	Bathroom Window is Open	14	5	24
1405	2	Bedroom Window is Closed	14	5	14
1406	0	Bathroom Window Closes	14	5	24
1407	1	Bedroom Window is Closed	14	5	14
1408	2	Living Room Window is Closed	14	5	25
1409	0	Bedroom Window Closes	14	5	14
1410	1	Living Room Window is Closed	14	5	25
1411	2	Bathroom Window is Closed	14	5	24
1412	0	Bathroom Window Opens	14	5	24
1413	1	Bedroom Window is Open	14	5	14
1414	2	Living Room Window is Closed	14	5	25
1415	0	Bedroom Window Opens	14	5	14
1416	1	Living Room Window is Open	14	5	25
1417	2	Bathroom Window is Closed	14	5	24
1418	0	Living Room Window Opens	14	5	25
1419	1	Bathroom Window is Open	14	5	24
1420	2	Bedroom Window is Closed	14	5	14
1421	0	Living Room Window Closes	14	5	25
1422	1	Bathroom Window is Closed	14	5	24
1423	2	Bedroom Window is Closed	14	5	14
1425	1	Bedroom Window is Closed	14	5	14
1426	2	Living Room Window is Open	14	5	25
1428	1	Living Room Window is Closed	14	5	25
1429	2	Bathroom Window is Open	14	5	24
1431	1	Bedroom Window is Open	14	5	14
1432	2	Bathroom Window is Closed	14	5	24
1433	0	Bathroom Window Closes	14	5	24
1434	1	Bedroom Window is Closed	14	5	14
1435	2	Living Room Window is Closed	14	5	25
1436	0	Bedroom Window Closes	14	5	14
1437	1	Living Room Window is Closed	14	5	25
1438	2	Bathroom Window is Closed	14	5	24
1439	0	Living Room Window Closes	14	5	25
1440	1	Bathroom Window is Closed	14	5	24
1441	0	Bedroom Window Opens	14	5	14
1442	1	Living Room Window is Open	14	5	25
1443	2	Bathroom Window is Closed	14	5	24
1444	0	Living Room Window Opens	14	5	25
1445	1	Bathroom Window is Open	14	5	24
1446	2	Bedroom Window is Closed	14	5	14
1447	0	Bathroom Window Opens	14	5	24
1448	1	Bedroom Window is Open	14	5	14
1449	2	Living Room Window is Closed	14	5	25
1450	0	Living Room Window Opens	14	5	25
1451	1	Bathroom Window is Closed	14	5	24
1452	2	Bedroom Window is Open	14	5	14
1453	0	Bathroom Window Opens	14	5	24
1454	1	Living Room Window is Open	14	5	25
1455	2	Bedroom Window is Closed	14	5	14
1456	0	Bedroom Window Opens	14	5	14
1457	1	Living Room Window is Closed	14	5	25
1458	2	Bathroom Window is Open	14	5	24
1459	0	Bathroom Window Opens	14	5	24
1460	1	Bedroom Window is Open	14	5	14
1461	2	Living Room Window is Closed	14	5	25
1462	0	Bedroom Window Opens	14	5	14
1463	1	Living Room Window is Open	14	5	25
1464	2	Bathroom Window is Closed	14	5	24
1465	0	Living Room Window Opens	14	5	25
1466	1	Bathroom Window is Open	14	5	24
1467	2	Bedroom Window is Closed	14	5	14
1468	0	It starts raining	20	7	18
1469	1	Bedroom Window is Open	14	5	14
1470	0	Alice Exits Home	63	15	12
1471	1	The AC is On	57	8	2
1472	0	Smoke Detector Starts detecting smoke	59	6	19
1473	1	Anyone is in Home	63	15	12
1474	0	The AC turns On	57	8	2
1475	1	Alice is in Home	63	15	12
1477	1	It is Daytime	55	9	17
1478	0	Smart TV turns On	2	12	5
1479	1	Roomba is On	2	18	1
1480	0	It starts raining	20	7	18
1481	1	Bedroom Window is Open	14	5	14
1482	0	Alice Exits Home	63	15	12
1483	1	The AC is On	57	8	2
1485	1	Alice is in Home	63	15	12
1487	1	It is Daytime	55	9	17
1489	1	Roomba is On	2	18	1
1491	1	The AC is On	57	8	2
1493	1	Bedroom Window is Open	14	5	14
1495	1	The AC is On	57	8	2
1497	1	Alice is in Home	63	15	12
1499	1	It is Daytime	55	9	17
1501	1	Roomba is On	2	18	1
1503	1	The AC is On	57	8	2
1504	0	It starts raining	20	7	18
1505	1	Bedroom Window is Open	14	5	14
1506	0	Alice Exits Home	63	15	12
1507	1	The AC is On	57	8	2
1509	1	Alice is in Home	63	15	12
1511	1	It is Daytime	55	9	17
1513	1	Roomba is On	2	18	1
1515	1	The AC is On	57	8	2
1516	0	The AC turns On	57	8	2
1517	1	Alice is not in Home	63	15	12
1518	0	The AC turns On	57	8	2
1519	1	Alice is not in Home	63	15	12
1520	2	Bobbie is not in Home	63	15	12
1521	0	Smart TV turns On	2	12	5
1522	1	Roomba is On	2	18	1
1523	0	Bobbie Exits Home	63	15	12
1524	1	The AC is On	57	8	2
1525	2	Alice is not in Home	63	15	12
1526	0	The AC turns On	57	8	2
1527	1	Alice is not in Home	63	15	12
1528	2	Bobbie is not in Home	63	15	12
1529	0	Smart TV turns On	2	12	5
1530	1	Roomba is On	2	18	1
1531	0	Bobbie Exits Home	63	15	12
1532	1	The AC is On	57	8	2
1534	1	Alice is not in Kitchen	63	15	12
1535	0	(Thermostat) The temperature goes above 52 degrees	19	8	2
1536	0	The AC turns On	57	8	2
1537	1	(Thermostat) The temperature is above 52 degrees	19	8	2
1538	0	(Thermostat) The temperature goes above 52 degrees	19	8	2
1539	0	The AC turns On	57	8	2
1540	1	(Thermostat) The temperature is above 52 degrees	19	8	2
1541	0	(Thermostat) The temperature falls below 52 degrees	19	8	2
1542	0	The AC turns On	57	8	2
1543	1	(Thermostat) The temperature is below 52 degrees	19	8	2
1544	0	HUE Lights's color becomes Orange	6	2	4
1545	0	Security Camera starts recording	28	10	10
1546	1	HUE Lights's Color is Orange	6	2	4
1547	0	HUE Lights's color becomes Orange	6	2	4
1548	0	Security Camera starts recording	28	10	10
1549	1	HUE Lights's Color is Orange	6	2	4
1550	0	HUE Lights's color becomes Green	6	2	4
1551	0	Security Camera starts recording	28	10	10
1552	1	HUE Lights's Color is Green	6	2	4
1553	0	(Thermostat) The temperature goes above 52 degrees	19	8	2
1554	0	The AC turns On	57	8	2
1555	1	(Thermostat) The temperature is above 52 degrees	19	8	2
1556	0	(Thermostat) The temperature falls below 52 degrees	19	8	2
1557	0	The AC turns On	57	8	2
1558	1	(Thermostat) The temperature is below 52 degrees	19	8	2
1559	0	It starts raining	20	7	18
1560	0	The AC turns On	57	8	2
1561	1	It is Raining	20	7	18
1562	0	It stops raining	20	7	18
1563	0	The AC turns On	57	8	2
1564	1	It is Not Raining	20	7	18
1565	0	Alice Exits Home	63	15	12
1566	1	The AC is On	57	8	2
1567	2	Bobbie is not in Home	63	15	12
1568	0	It becomes Nighttime	55	9	17
1569	0	It starts raining	20	7	18
1570	1	Bathroom Window is Open	14	5	24
1572	1	(Thermostat) The temperature is above 75 degrees	19	8	2
1573	0	It stops raining	20	7	18
1574	1	Bathroom Window is Closed	14	5	24
1576	0	It starts raining	20	7	18
1577	1	Bathroom Window is Open	14	5	24
1579	1	(Thermostat) The temperature is above 75 degrees	19	8	2
1581	1	Bathroom Window is Closed	14	5	24
1583	0	It starts raining	20	7	18
1584	1	Bathroom Window is Open	14	5	24
1586	1	(Thermostat) The temperature is above 75 degrees	19	8	2
1587	0	It starts raining	20	7	18
1588	1	Bedroom Window is Closed	14	5	14
1590	1	Bedroom Window is Closed	14	5	14
1591	0	HUE Lights turns On	2	2	4
1592	1	It is Daytime	55	9	17
1593	0	The AC turns On	57	8	2
1594	1	Bathroom Window is Open	14	5	24
1596	1	It is Daytime	55	9	17
1597	0	The AC turns On	57	8	2
1598	1	Bathroom Window is Open	14	5	24
1599	0	Living Room Window's curtains Close	58	5	25
1600	1	It is Daytime	55	9	17
1601	0	HUE Lights turns Off	2	2	4
1602	1	Living Room Window's curtains are Closed	58	5	25
1603	2	It is Nighttime	55	9	17
1605	1	It is Daytime	55	9	17
1606	0	HUE Lights turns Off	2	2	4
1607	1	It is Nighttime	55	9	17
1608	2	Living Room Window's curtains are Open	58	5	25
1609	0	HUE Lights turns Off	2	2	4
1610	1	It is Daytime	55	9	17
1612	1	(Thermostat) The temperature is below 5 degrees	19	8	2
1614	1	(Thermostat) The temperature is below 60 degrees	19	8	2
1616	1	Alice is not in Home	70	15	28
1618	1	(Thermostat) The temperature is below 5 degrees	19	8	2
1620	1	(Thermostat) The temperature is below 60 degrees	19	8	2
1622	1	Alice is not in Home	70	15	28
1624	1	(Thermostat) The temperature is below 5 degrees	19	8	2
1626	1	Alice is not in Home	70	15	28
1628	1	(Thermostat) The temperature is below 60 degrees	19	8	2
1629	0	It starts raining	20	7	18
1630	1	Bedroom Window is Closed	14	5	14
1631	0	It stops raining	20	7	18
1632	1	Bathroom Window is Closed	14	5	24
1633	0	It becomes Nighttime	55	9	17
1634	0	It stops raining	20	7	18
1635	1	Bathroom Window is Closed	14	5	24
1636	0	It starts raining	20	7	18
1637	1	Bedroom Window is Closed	14	5	14
1638	0	A Guest Enters Kitchen	63	6	12
1639	1	Alice is not in Kitchen	63	6	12
1640	0	It starts raining	20	7	18
1641	1	Bedroom Window is Open	14	5	14
1642	0	It becomes Nighttime	55	9	17
1643	0	It stops raining	20	7	18
1644	1	Bathroom Window is Closed	14	5	24
1645	0	It starts raining	20	7	18
1646	1	Bedroom Window is Closed	14	5	14
1647	0	HUE Lights's color becomes Orange	6	2	4
1648	0	HUE Lights's color becomes Green	6	2	4
1649	0	It starts raining	20	7	18
1650	1	Bathroom Window is Open	14	5	24
1651	0	It starts raining	20	7	18
1652	1	Bathroom Window is Open	14	5	24
1653	0	It starts raining	20	7	18
1654	1	Bedroom Window is Closed	14	5	14
1655	0	The AC turns On	57	8	2
1656	1	Living Room Window is Open	14	5	25
1657	0	Living Room Window Opens	14	5	25
1658	1	The AC is On	57	8	2
1660	1	Living Room Window is Open	14	5	25
1661	0	The AC turns On	57	8	2
1662	1	Living Room Window is Open	14	5	25
1663	0	(Thermostat) The temperature falls below 70 degrees	19	8	2
1664	0	The AC turns On	57	8	2
1665	1	Living Room Window is Open	14	5	25
1666	0	(Thermostat) The temperature goes above 70 degrees	19	8	2
1667	1	The heater is On	69	8	2
1668	0	(Thermostat) The temperature falls below 70 degrees	19	8	2
1669	0	(Thermostat) The temperature falls below 70 degrees	19	8	2
1670	0	(Thermostat) The temperature goes above 75 degrees	19	8	2
1671	1	The heater is On	69	8	2
1672	0	The AC turns On	57	8	2
1673	1	The heater is On	69	8	2
1674	0	The heater turns On	69	8	2
1675	1	The AC is On	57	8	2
1677	1	The AC is On	57	8	2
1678	0	Smart Oven's door Opens	60	13	23
1679	1	Nobody is in Kitchen	63	15	12
1680	0	Smart Oven's door Opens	60	13	23
1681	1	Nobody is in Kitchen	63	15	12
1682	0	Smart TV turns On	2	12	5
1683	0	Smoke Detector Starts detecting smoke	59	6	19
1684	0	Smoke Detector Starts detecting smoke	59	6	19
1685	0	Smart Oven's door Opens	60	13	23
1686	1	Alice is not in Kitchen	63	15	12
1687	0	Smart Oven's door Opens	60	13	23
1688	1	Alice is not in Kitchen	63	15	12
1689	0	Smart Oven's door Opens	60	13	23
1690	1	Alice is not in Kitchen	63	15	12
1691	2	Bobbie is not in Kitchen	63	15	12
1692	0	Smart Oven's door Opens	60	13	23
1693	1	Alice is not in Kitchen	63	15	12
1694	2	Bobbie is not in Kitchen	63	15	12
1701	0	Living Room Window is Closed	14	5	25
1702	0	Alice is in Home	63	15	12
1703	0	(Smoke Detector) Smoke is Detected	59	6	19
1704	0	Living Room Window Closes	14	5	25
1705	0	Alice Enters Home	63	6	12
1706	0	Smoke Detector Starts detecting smoke	59	6	19
1707	1	(Smoke Detector) Smoke is Detected	59	6	19
1708	1	Living Room Window is Closed	14	5	25
1709	2	Alice is in Home	63	6	12
1710	1	Living Room Window is Closed	14	5	25
1711	2	(Smoke Detector) Smoke is Detected	59	6	19
1712	2	Alice is in Home	63	6	12
1714	1	(Smoke Detector) Smoke is Detected	59	6	19
1715	2	Alice is in Home	63	15	12
1716	0	Alice Enters Home	63	15	12
1717	1	Living Room Window is Closed	14	5	25
1718	2	(Smoke Detector) Smoke is Detected	59	6	19
1719	0	Alice Enters Home	63	15	12
1720	1	Living Room Window is Closed	14	5	25
1721	2	(Smoke Detector) Smoke is Detected	59	6	19
1723	1	(Smoke Detector) Smoke is Detected	59	6	19
1724	2	Alice is in Home	63	15	12
1725	0	Smoke Detector Starts detecting smoke	59	6	19
1726	1	Living Room Window is Closed	14	5	25
1727	2	Alice is in Home	63	15	12
1728	0	Smoke Detector Starts detecting smoke	59	6	19
1729	1	Living Room Window is Closed	14	5	25
1730	2	Alice is in Home	63	15	12
1731	0	Alice Enters Home	63	15	12
1732	1	Living Room Window is Closed	14	5	25
1733	2	(Smoke Detector) Smoke is Detected	59	6	19
1734	0	Living Room Window Opens	14	5	25
1735	1	It is Raining	20	7	18
1736	0	Alice Enters Home	63	15	12
1737	1	It is Nighttime	55	9	17
1738	2	HUE Lights is Off	2	2	4
1739	0	Alice Enters Home	63	15	12
1740	1	It is Nighttime	55	9	17
1741	2	HUE Lights is Off	2	2	4
1742	0	Smart TV turns On	2	12	5
1743	0	Alice Enters Home	63	15	12
1744	1	It is Nighttime	55	9	17
1745	2	HUE Lights is Off	2	2	4
1746	0	Smart TV turns On	2	12	5
1747	0	Alice Enters Home	63	15	12
1748	1	It is Nighttime	55	9	17
1749	2	HUE Lights is Off	2	2	4
1750	0	It starts raining	20	7	18
1751	0	Alice Enters Home	63	15	12
1752	1	It is Nighttime	55	9	17
1753	0	It starts raining	20	7	18
1755	1	Speakers is On	2	3	7
1756	0	Alice Enters Home	63	15	12
1757	1	It is Nighttime	55	9	17
1758	2	HUE Lights is Off	2	2	4
1759	0	Alice Enters Home	63	15	12
1760	1	It is Nighttime	55	9	17
1761	2	HUE Lights is Off	2	2	4
1762	0	Smart TV turns On	2	12	5
1763	1	Speakers is On	2	3	7
1764	0	Alice Enters Home	63	15	12
1765	1	HUE Lights is Off	2	2	4
1766	2	It is Nighttime	55	9	17
1768	1	It is Daytime	55	9	17
1769	2	HUE Lights is On	2	2	4
1770	0	Alice Enters Home	63	15	12
1771	1	It is Nighttime	55	9	17
1772	2	HUE Lights is Off	2	2	4
1773	0	HUE Lights is On	2	2	4
1774	0	Alice is in Home	63	15	12
1775	0	It is Nighttime	55	9	17
1776	0	Speakers turns On	2	3	7
1777	0	Smart TV is On	2	12	5
1778	0	Alice Enters Home	63	6	12
1779	0	HUE Lights turns Off	2	1	4
1780	0	It becomes Nighttime	55	9	17
1781	1	Alice is in Home	63	6	12
1782	1	Alice is in Home	63	6	12
1783	1	It is Nighttime	55	9	17
1784	2	HUE Lights is Off	2	1	4
1785	2	HUE Lights is Off	2	1	4
1786	2	It is Nighttime	55	9	17
1787	0	Speakers turns On	2	1	7
1788	0	HUE Lights turns Off	2	1	4
1789	0	Alice Enters Home	63	6	12
1790	1	Smart TV is On	2	1	5
1791	1	Alice is in Home	63	6	12
1792	1	It is Nighttime	55	9	17
1793	2	It is Nighttime	55	9	17
1794	2	HUE Lights is Off	2	1	4
1795	0	It becomes Nighttime	55	9	17
1796	0	Speakers turns On	2	1	7
1797	1	Alice is in Home	63	6	12
1798	1	Smart TV is On	2	1	5
1799	2	HUE Lights is Off	2	1	4
1800	0	Alice Enters Home	63	15	12
1801	1	It is Nighttime	55	9	17
1802	0	It becomes Nighttime	55	9	17
1803	1	Alice is in Home	63	15	12
1804	0	HUE Lights turns Off	2	2	4
1805	1	It is Nighttime	55	9	17
1806	2	Alice is in Home	63	15	12
1807	0	Alice Enters Home	63	15	12
1808	1	HUE Lights is Off	2	2	4
1809	0	Smart TV turns On	2	12	5
1810	1	Speakers is On	2	3	7
1811	0	Alice Exits Kitchen	63	15	12
1812	1	Smart Faucet's water is running	64	17	22
1813	0	It starts raining	20	7	18
1814	1	Bathroom Window is Open	14	5	24
1815	0	It starts raining	20	7	18
1816	1	Living Room Window is Open	14	5	25
1817	0	It starts raining	20	7	18
1818	1	Bedroom Window is Open	14	5	14
1819	0	It starts raining	20	7	18
1820	1	Bathroom Window is Open	14	5	24
1821	0	It starts raining	20	7	18
1822	1	Bedroom Window is Open	14	5	14
1823	0	It starts raining	20	7	18
1824	1	Living Room Window is Open	14	5	25
1825	0	It starts raining	20	7	18
1826	1	Bedroom Window is Open	14	5	14
1827	0	It starts raining	20	7	18
1828	1	Bathroom Window is Open	14	5	24
1829	0	It starts raining	20	7	18
1830	1	Living Room Window is Open	14	5	25
1831	0	Alice Exits Bathroom	63	15	12
1832	1	Smart Faucet's water is running	64	17	22
1833	0	Security Camera starts recording	28	10	10
1834	1	(FitBit) I am Asleep	61	16	21
1835	2	Front Door Lock is Locked	13	5	13
1836	0	Front Door Lock Unlocks	13	5	13
1837	1	Security Camera is not recording	28	10	10
1838	2	(FitBit) I am Asleep	61	16	21
1839	0	Security Camera starts recording	28	10	10
1840	1	(FitBit) I am Awake	61	16	21
1841	0	Security Camera stops recording	28	10	10
1842	1	(FitBit) I am Asleep	61	16	21
1843	2	Front Door Lock is Unlocked	13	5	13
1844	0	Front Door Lock Unlocks	13	5	13
1845	1	(FitBit) I am Asleep	61	16	21
1846	0	Front Door Lock Unlocks	13	5	13
1847	1	(FitBit) I am Awake	61	16	21
1848	0	Alice Exits Bathroom	63	15	12
1849	1	Smart Faucet's water is running	64	17	22
1850	0	Alice Exits Bathroom	63	15	12
1851	1	Smart Faucet's water is running	64	17	22
1852	0	Alice Enters Home	63	15	12
1853	1	It is Nighttime	55	9	17
1854	2	HUE Lights is Off	2	2	4
1855	0	Alice Enters Home	63	15	12
1856	1	HUE Lights is Off	2	2	4
1857	0	Alice Enters Home	63	15	12
1858	1	HUE Lights is Off	2	2	4
1859	0	Smart TV turns On	2	12	5
1860	1	Speakers is On	2	1	7
1861	0	Alice Enters Home	63	15	12
1862	1	It is Nighttime	55	9	17
1863	2	HUE Lights is Off	2	2	4
1864	0	Smart TV turns On	2	12	5
1865	1	Speakers is On	2	3	7
1866	0	It starts raining	20	7	18
1867	0	Speakers turns On	2	1	7
1868	1	Smart TV is On	2	1	5
1869	0	Alice Enters Home	63	6	12
1870	1	HUE Lights is Off	2	2	4
1871	2	HUE Lights is Off	2	1	4
1872	0	Speakers turns On	2	1	7
1873	1	Smart TV is On	2	1	5
1874	0	Alice Enters Home	63	15	12
1875	1	It is Nighttime	55	9	17
1876	2	HUE Lights is Off	2	2	4
1877	0	Speakers turns On	2	3	7
1878	1	Smart TV is On	2	12	5
1879	0	Alice Enters Home	63	15	12
1880	1	HUE Lights is Off	2	2	4
1881	2	HUE Lights is Off	2	2	4
1882	0	Speakers turns On	2	3	7
1883	1	Smart TV is On	2	12	5
1884	0	Living Room Window Closes	14	5	25
1885	1	Bathroom Window is Closed	14	5	24
1886	2	Bedroom Window is Closed	14	5	14
1887	0	Bathroom Window Opens	14	5	24
1888	0	Bathroom Window Opens	14	5	24
1889	1	Bedroom Window is Closed	14	5	14
1890	2	Living Room Window is Open	14	5	25
1891	0	Bedroom Window Opens	14	5	14
1892	0	Bedroom Window Opens	14	5	14
1893	1	Living Room Window is Closed	14	5	25
1894	2	Bathroom Window is Open	14	5	24
1895	0	Living Room Window Opens	14	5	25
1896	0	Living Room Window Opens	14	5	25
1897	1	Bedroom Window is Open	14	5	14
1898	2	Bathroom Window is Closed	14	5	24
1899	0	Living Room Window Closes	14	5	25
1900	1	Bathroom Window is Closed	14	5	24
1901	2	Bathroom Window is Closed	14	5	24
1906	0	The AC is On	57	8	2
1907	0	Smart TV is On	2	12	5
1908	0	The AC turns On	57	8	2
1909	0	Smart TV turns On	2	1	5
1910	0	The AC turns On	57	8	2
1911	0	Smart TV turns On	2	1	5
1912	1	Smart TV is On	2	1	5
1913	1	Smart TV is On	2	1	5
1914	1	The AC is On	57	8	2
1915	1	The AC is On	57	8	2
1916	0	Smart TV turns On	2	1	5
1917	0	The AC turns On	57	8	2
1918	0	The AC turns On	57	8	2
1919	0	Smart TV turns On	2	1	5
1920	1	The AC is On	57	8	2
1921	1	Smart TV is On	2	1	5
1922	1	Smart TV is On	2	1	5
1923	1	The AC is On	57	8	2
1924	0	The AC is On	57	8	2
1925	0	The heater is On	69	8	2
1926	0	The heater turns On	69	8	2
1927	0	The AC turns On	57	8	2
1928	0	The AC turns On	57	8	2
1929	0	The heater turns On	69	8	2
1930	1	The heater is On	69	8	2
1931	1	The AC is On	57	8	2
1932	1	The heater is On	69	8	2
1933	1	The AC is On	57	8	2
1934	0	The AC turns On	57	8	2
1935	0	The heater turns On	69	8	2
1936	0	The AC turns On	57	8	2
1937	0	The heater turns On	69	8	2
1938	1	The heater is On	69	8	2
1939	1	The AC is On	57	8	2
1940	1	The heater is On	69	8	2
1941	1	The AC is On	57	8	2
1942	0	The AC turns On	57	8	2
1943	0	Coffee Pot turns On	2	13	9
1944	0	HUE Lights turns On	2	2	4
1945	0	Roomba turns On	2	1	1
1946	0	Smart TV turns On	2	12	5
1947	0	Speakers turns On	2	1	7
1948	0	The AC turns On	57	8	2
1949	1	Coffee Pot is On	2	13	9
1950	2	HUE Lights is On	2	2	4
1951	3	Roomba is On	2	1	1
1952	4	Smart TV is On	2	12	5
1953	5	Speakers is On	2	1	7
1954	0	Coffee Pot turns On	2	13	9
1955	1	The AC is On	57	8	2
1956	2	HUE Lights is On	2	2	4
1957	3	Roomba is On	2	18	1
1958	4	Smart TV is On	2	12	5
1959	5	Speakers is On	2	1	7
1960	0	HUE Lights turns On	2	2	4
1961	1	The AC is On	57	8	2
1962	2	Coffee Pot is On	2	13	9
1963	3	Roomba is On	2	1	1
1964	4	Smart TV is On	2	1	5
1965	5	Speakers is On	2	1	7
1966	0	Roomba turns On	2	1	1
1967	1	The AC is On	57	8	2
1968	2	Coffee Pot is On	2	1	9
1969	3	HUE Lights is On	2	2	4
1970	4	Smart TV is On	2	12	5
1971	5	Speakers is On	2	1	7
1972	0	Smart TV turns On	2	12	5
1973	1	The AC is On	57	8	2
1974	2	Coffee Pot is On	2	13	9
1975	3	HUE Lights is On	2	2	4
1976	4	Roomba is On	2	1	1
1977	5	Speakers is On	2	1	7
1978	0	Speakers turns On	2	1	7
1979	1	The AC is On	57	8	2
1980	2	Coffee Pot is On	2	13	9
1981	3	HUE Lights is On	2	2	4
1982	4	Roomba is On	2	1	1
1983	5	Smart TV is On	2	12	5
1984	0	Roomba turns On	2	1	1
1985	0	Smart TV turns On	2	12	5
1986	0	Speakers turns On	2	1	7
1987	0	HUE Lights turns On	2	2	4
1988	0	The AC turns On	57	8	2
1989	0	Coffee Pot turns On	2	13	9
1990	0	Roomba turns On	2	1	1
1991	1	Speakers is On	2	1	7
1992	2	The AC is On	57	8	2
1993	3	Speakers is On	2	1	7
1994	4	HUE Lights is On	2	2	4
1995	5	The AC is On	57	8	2
1996	6	HUE Lights is On	2	2	4
1997	7	Coffee Pot is On	2	13	9
1998	8	Smart TV is On	2	12	5
1999	0	Smart TV turns On	2	12	5
2000	1	Roomba is On	2	1	1
2001	2	HUE Lights is On	2	2	4
2002	3	Speakers is On	2	1	7
2003	4	Coffee Pot is On	2	13	9
2004	5	HUE Lights is On	2	2	4
2005	6	The AC is On	57	8	2
2006	7	Speakers is On	2	1	7
2007	0	Speakers turns On	2	1	7
2008	1	HUE Lights is On	2	2	4
2009	2	Smart TV is On	2	12	5
2010	3	Coffee Pot is On	2	13	9
2011	4	Roomba is On	2	1	1
2012	5	Coffee Pot is On	2	13	9
2013	0	HUE Lights turns On	2	2	4
2014	1	Smart TV is On	2	12	5
2015	2	Coffee Pot is On	2	13	9
2016	3	The AC is On	57	8	2
2017	4	Smart TV is On	2	12	5
2018	5	Speakers is On	2	1	7
2019	6	Roomba is On	2	1	1
2020	0	The AC turns On	57	8	2
2021	1	Roomba is On	2	1	1
2022	2	The AC is On	57	8	2
2023	3	HUE Lights is On	2	2	4
2024	4	Smart TV is On	2	12	5
2025	5	Speakers is On	2	1	7
2026	6	Coffee Pot is On	2	13	9
2027	7	Smart TV is On	2	12	5
2028	0	Coffee Pot turns On	2	13	9
2029	1	Smart TV is On	2	12	5
2030	2	Coffee Pot is Off	2	13	9
2031	3	The AC is On	57	8	2
2032	4	Roomba is On	2	1	1
2033	5	Speakers is On	2	1	7
2034	6	HUE Lights is On	2	2	4
2035	0	The AC turns On	57	8	2
2036	1	Roomba is On	2	1	1
2037	2	The AC is Off	57	8	2
2038	3	HUE Lights is On	2	2	4
2039	4	Smart TV is On	2	12	5
2040	5	Speakers is On	2	1	7
2041	6	Coffee Pot is On	2	13	9
2042	7	Smart TV is On	2	12	5
2043	0	Coffee Pot turns On	2	13	9
2044	0	Coffee Pot turns On	2	13	9
2045	0	HUE Lights turns On	2	2	4
2046	0	HUE Lights turns On	2	2	4
2047	0	HUE Lights turns On	2	2	4
2048	0	Roomba turns On	2	18	1
2049	0	Roomba turns On	2	18	1
2050	0	Smart TV turns On	2	12	5
2051	0	Smart TV turns On	2	12	5
2052	0	Speakers turns On	2	1	7
2053	0	Speakers turns On	2	1	7
2054	0	Coffee Pot turns On	2	13	9
2055	1	It is Daytime	55	9	17
2056	2	The AC is On	57	8	2
2057	3	Coffee Pot is Off	2	13	9
2058	4	HUE Lights is On	2	2	4
2059	5	Roomba is On	2	18	1
2060	6	Smart TV is On	2	12	5
2061	7	Speakers is On	2	3	7
2062	0	Coffee Pot turns On	2	13	9
2063	1	It is Nighttime	55	9	17
2064	2	The AC is On	57	8	2
2065	3	Coffee Pot is Off	2	13	9
2066	4	HUE Lights is On	2	2	4
2067	5	Roomba is On	2	18	1
2068	6	Smart TV is On	2	12	5
2069	7	Speakers is On	2	1	7
2070	0	HUE Lights turns On	2	2	4
2071	1	It is Daytime	55	9	17
2072	2	The AC is On	57	8	2
2073	3	Coffee Pot is On	2	13	9
2074	4	HUE Lights is Off	2	2	4
2075	5	Roomba is On	2	18	1
2076	6	Smart TV is On	2	12	5
2077	7	Speakers is On	2	1	7
2078	0	HUE Lights turns On	2	2	4
2079	1	It is Nighttime	55	9	17
2080	2	The AC is On	57	8	2
2081	3	Coffee Pot is On	2	13	9
2082	4	HUE Lights is Off	2	2	4
2083	5	Roomba is On	2	18	1
2084	6	Smart TV is On	2	12	5
2085	7	Speakers is On	2	3	7
2086	0	Roomba turns On	2	18	1
2087	1	Alice is in Home	63	15	12
2088	2	The AC is On	57	8	2
2089	3	Coffee Pot is On	2	13	9
2090	4	HUE Lights is On	2	2	4
2091	5	Roomba is Off	2	18	1
2092	6	Smart TV is On	2	12	5
2093	7	Speakers is On	2	1	7
2094	0	Roomba turns On	2	18	1
2095	1	Alice is not in Home	63	15	12
2096	2	The AC is On	57	8	2
2097	3	Coffee Pot is On	2	13	9
2098	4	HUE Lights is On	2	2	4
2099	5	Roomba is Off	2	18	1
2100	6	Smart TV is On	2	12	5
2101	7	Speakers is On	2	3	7
2102	0	Smart TV turns On	2	12	5
2103	1	Alice is in Home	63	15	12
2104	2	The AC is On	57	8	2
2105	3	Coffee Pot is On	2	13	9
2106	4	HUE Lights is On	2	2	4
2107	5	Roomba is On	2	18	1
2108	6	Smart TV is Off	2	12	5
2109	7	Speakers is On	2	3	7
2110	0	Smart TV turns On	2	12	5
2111	1	Alice is not in Home	63	15	12
2112	2	The AC is On	57	8	2
2113	3	Coffee Pot is On	2	13	9
2114	4	HUE Lights is On	2	2	4
2115	5	Roomba is Off	2	18	1
2116	6	Smart TV is On	2	12	5
2117	7	Speakers is On	2	3	7
2118	0	Speakers turns On	2	1	7
2119	1	Alice is in Home	63	15	12
2120	2	The AC is On	57	8	2
2121	3	Coffee Pot is On	2	13	9
2122	4	HUE Lights is On	2	2	4
2123	5	Roomba is On	2	18	1
2124	6	Smart TV is On	2	12	5
2125	7	Speakers is On	2	3	7
2126	0	Speakers turns On	2	1	7
2127	1	Alice is not in Home	63	15	12
2128	2	The AC is On	57	8	2
2129	3	Coffee Pot is On	2	13	9
2130	4	HUE Lights is On	2	2	4
2131	5	Roomba is On	2	18	1
2132	6	Smart TV is On	2	12	5
2133	7	Speakers is On	2	3	7
2134	0	The AC turns On	57	8	2
2135	0	The AC turns On	57	8	2
2136	0	Coffee Pot turns On	2	13	9
2137	0	Coffee Pot turns On	2	13	9
2138	0	HUE Lights turns On	2	2	4
2139	0	HUE Lights turns On	2	2	4
2140	0	Roomba turns On	2	18	1
2141	0	Roomba turns On	2	18	1
2142	0	Smart TV turns On	2	12	5
2143	0	Smart TV turns On	2	12	5
2144	0	Speakers turns On	2	1	7
2145	0	Speakers turns On	2	1	7
2146	0	The AC turns On	57	8	2
2147	1	It is Daytime	55	9	17
2148	2	The AC is Off	57	8	2
2149	3	Coffee Pot is On	2	13	9
2150	4	HUE Lights is On	2	2	4
2151	5	Roomba is On	2	18	1
2152	6	Smart TV is On	2	12	5
2153	7	Speakers is On	2	1	7
2154	0	The AC turns On	57	8	2
2155	1	It is Nighttime	55	9	17
2156	2	The AC is Off	57	8	2
2157	3	Coffee Pot is On	2	13	9
2158	4	HUE Lights is On	2	2	4
2159	5	Roomba is On	2	18	1
2160	6	Smart TV is On	2	12	5
2161	7	Speakers is On	2	1	7
2162	0	Coffee Pot turns On	2	13	9
2163	1	It is Daytime	55	9	17
2164	2	The AC is On	57	8	2
2165	3	Coffee Pot is Off	2	13	9
2166	4	HUE Lights is On	2	2	4
2167	5	Roomba is On	2	18	1
2168	6	Smart TV is On	2	12	5
2169	7	Speakers is On	2	1	7
2170	0	Coffee Pot turns On	2	13	9
2171	1	It is Nighttime	55	9	17
2172	2	The AC is On	57	8	2
2173	3	Coffee Pot is Off	2	13	9
2174	4	HUE Lights is On	2	2	4
2175	5	Roomba is On	2	18	1
2176	6	Smart TV is On	2	12	5
2177	7	Speakers is On	2	1	7
2178	0	HUE Lights turns On	2	2	4
2179	1	It is Daytime	55	9	17
2180	2	The AC is On	57	8	2
2181	3	Coffee Pot is On	2	13	9
2182	4	HUE Lights is Off	2	2	4
2183	5	Roomba is On	2	18	1
2184	6	Smart TV is On	2	12	5
2185	7	Speakers is On	2	1	7
2186	0	HUE Lights turns On	2	2	4
2187	1	It is Nighttime	55	9	17
2188	2	The AC is On	57	8	2
2189	3	Coffee Pot is On	2	13	9
2190	4	HUE Lights is Off	2	2	4
2191	5	Roomba is On	2	18	1
2192	6	Smart TV is On	2	12	5
2193	7	Speakers is On	2	1	7
2194	0	Roomba turns On	2	18	1
2195	1	Alice is in Home	63	15	12
2196	2	The AC is On	57	8	2
2197	3	Coffee Pot is On	2	13	9
2198	4	HUE Lights is On	2	2	4
2199	5	Roomba is Off	2	18	1
2200	6	Smart TV is On	2	12	5
2201	7	Speakers is On	2	1	7
2202	0	Roomba turns On	2	18	1
2203	1	Alice is not in Home	63	15	12
2204	2	The AC is On	57	8	2
2205	3	Coffee Pot is On	2	13	9
2206	4	HUE Lights is On	2	2	4
2207	5	Roomba is Off	2	18	1
2208	6	Smart TV is On	2	12	5
2209	7	Speakers is On	2	1	7
2210	0	Smart TV turns On	2	12	5
2211	1	Alice is in Home	63	15	12
2212	2	The AC is On	57	8	2
2213	3	Coffee Pot is On	2	13	9
2214	4	HUE Lights is On	2	2	4
2215	5	Roomba is On	2	18	1
2216	6	Smart TV is Off	2	12	5
2217	7	Speakers is On	2	1	7
2218	0	Smart TV turns On	2	12	5
2219	1	Alice is not in Home	63	15	12
2220	2	The AC is On	57	8	2
2221	3	Coffee Pot is On	2	13	9
2222	4	HUE Lights is On	2	2	4
2223	5	Roomba is Off	2	18	1
2224	6	Smart TV is On	2	12	5
2225	7	Speakers is On	2	1	7
2226	0	Speakers turns On	2	1	7
2227	1	Alice is in Home	63	15	12
2228	2	The AC is On	57	8	2
2229	3	Coffee Pot is On	2	13	9
2230	4	HUE Lights is On	2	2	4
2231	5	Roomba is On	2	18	1
2232	6	Smart TV is On	2	12	5
2233	7	Speakers is Off	2	1	7
2234	0	Speakers turns On	2	1	7
2235	1	Alice is not in Home	63	15	12
2236	2	The AC is On	57	8	2
2237	3	Coffee Pot is On	2	13	9
2238	4	HUE Lights is On	2	2	4
2239	5	Roomba is On	2	18	1
2240	6	Smart TV is On	2	12	5
2241	7	Speakers is Off	2	1	7
2242	0	Speakers turns On	2	1	7
2243	1	Alice is in Home	63	15	12
2244	2	The AC is On	57	8	2
2245	3	Coffee Pot is On	2	13	9
2246	4	HUE Lights is On	2	2	4
2247	5	Roomba is On	2	18	1
2248	6	Smart TV is On	2	12	5
2249	7	Speakers is Off	2	1	7
2250	0	Speakers turns On	2	1	7
2251	1	Alice is not in Home	63	15	12
2252	2	The AC is On	57	8	2
2253	3	Coffee Pot is On	2	13	9
2254	4	HUE Lights is On	2	2	4
2255	5	Roomba is On	2	18	1
2256	6	Smart TV is On	2	12	5
2257	7	Speakers is Off	2	1	7
2258	0	The AC turns On	57	8	2
2259	0	The AC turns On	57	8	2
2260	0	Coffee Pot turns On	2	13	9
2261	0	Coffee Pot turns On	2	13	9
2262	0	HUE Lights turns On	2	2	4
2263	0	HUE Lights turns On	2	2	4
2264	0	Roomba turns On	2	18	1
2265	0	Roomba turns On	2	18	1
2266	0	Smart TV turns On	2	12	5
2267	0	Smart TV turns On	2	12	5
2268	0	Speakers turns On	2	1	7
2269	0	Speakers turns On	2	1	7
2270	0	The AC turns On	57	8	2
2271	1	Alice is in Home	63	15	12
2272	2	The AC is Off	57	8	2
2273	3	Coffee Pot is On	2	13	9
2274	4	HUE Lights is On	2	2	4
2275	5	Roomba is On	2	18	1
2276	6	Smart TV is On	2	12	5
2277	7	Speakers is On	2	1	7
2278	0	The AC turns On	57	8	2
2279	1	Alice is not in Home	63	15	12
2280	2	The AC is Off	57	8	2
2281	3	Coffee Pot is On	2	13	9
2282	4	HUE Lights is On	2	2	4
2283	5	Roomba is On	2	18	1
2284	6	Smart TV is On	2	12	5
2285	7	Speakers is On	2	1	7
2286	0	Coffee Pot turns On	2	13	9
2287	1	Alice is in Home	63	15	12
2288	2	The AC is On	57	8	2
2289	3	Coffee Pot is Off	2	13	9
2290	4	HUE Lights is On	2	2	4
2291	5	Roomba is On	2	18	1
2292	6	Smart TV is On	2	12	5
2293	7	Speakers is On	2	1	7
2294	0	Coffee Pot turns On	2	13	9
2295	1	Alice is not in Home	63	15	12
2296	2	The AC is On	57	8	2
2297	3	Coffee Pot is Off	2	13	9
2298	4	HUE Lights is On	2	2	4
2299	5	Roomba is On	2	18	1
2300	6	Smart TV is On	2	12	5
2301	7	Speakers is On	2	1	7
2302	0	HUE Lights turns On	2	2	4
2303	1	Alice is in Home	63	15	12
2304	2	The AC is On	57	8	2
2305	3	Coffee Pot is On	2	13	9
2306	4	HUE Lights is Off	2	2	4
2307	5	Roomba is On	2	18	1
2308	6	Smart TV is On	2	12	5
2309	7	Speakers is On	2	1	7
2310	0	HUE Lights turns On	2	2	4
2311	1	Alice is not in Home	63	15	12
2312	2	The AC is On	57	8	2
2313	3	Coffee Pot is On	2	13	9
2314	4	HUE Lights is Off	2	2	4
2315	5	Roomba is On	2	18	1
2316	6	Smart TV is On	2	12	5
2317	7	Speakers is On	2	1	7
2318	0	Roomba turns On	2	18	1
2319	1	It is Daytime	55	9	17
2320	2	The AC is On	57	8	2
2321	3	Coffee Pot is On	2	13	9
2322	4	HUE Lights is On	2	2	4
2323	5	Roomba is Off	2	18	1
2324	6	Smart TV is On	2	12	5
2325	7	Speakers is On	2	1	7
2326	0	Roomba turns On	2	18	1
2327	1	It is Nighttime	55	9	17
2328	2	The AC is On	57	8	2
2329	3	Coffee Pot is On	2	13	9
2330	4	HUE Lights is On	2	2	4
2331	5	Roomba is Off	2	18	1
2332	6	Smart TV is On	2	12	5
2333	7	Speakers is On	2	1	7
2334	0	Smart TV turns On	2	12	5
2335	1	It is Daytime	55	9	17
2336	2	The AC is On	57	8	2
2337	3	Coffee Pot is On	2	13	9
2338	4	HUE Lights is On	2	2	4
2339	5	Roomba is On	2	18	1
2340	6	Smart TV is Off	2	12	5
2341	7	Speakers is On	2	1	7
2342	0	Smart TV turns On	2	12	5
2343	1	It is Nighttime	55	9	17
2344	2	The AC is On	57	8	2
2345	3	Coffee Pot is On	2	13	9
2346	4	HUE Lights is On	2	2	4
2347	5	Roomba is On	2	18	1
2348	6	Smart TV is Off	2	12	5
2349	7	Speakers is Off	2	1	7
2350	0	Speakers turns On	2	1	7
2351	1	It is Daytime	55	9	17
2352	2	The AC is On	57	8	2
2353	3	Coffee Pot is On	2	13	9
2354	4	HUE Lights is On	2	2	4
2355	5	Roomba is On	2	18	1
2356	6	Smart TV is On	2	12	5
2357	7	Speakers is Off	2	1	7
2358	0	Speakers turns On	2	1	7
2359	1	It is Nighttime	55	9	17
2360	2	The AC is On	57	8	2
2361	3	Coffee Pot is On	2	13	9
2362	4	HUE Lights is On	2	2	4
2363	5	Roomba is On	2	18	1
2364	6	Smart TV is On	2	12	5
2365	7	Speakers is Off	2	1	7
2366	0	Smart TV turns On	2	12	5
2367	1	It is Nighttime	55	9	17
2368	2	The AC is On	57	8	2
2369	3	Coffee Pot is On	2	13	9
2370	4	HUE Lights is On	2	2	4
2371	5	Roomba is On	2	18	1
2372	6	Smart TV is Off	2	12	5
2373	7	Speakers is Off	2	1	7
2374	0	Smart TV turns On	2	12	5
2375	1	It is Nighttime	55	9	17
2376	2	The AC is On	57	8	2
2377	3	Coffee Pot is On	2	13	9
2378	4	HUE Lights is On	2	2	4
2379	5	Roomba is On	2	18	1
2380	6	Smart TV is Off	2	12	5
2381	7	Speakers is On	2	1	7
\.


--
-- Name: backend_trigger_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_trigger_id_seq', 2381, true);


--
-- Data for Name: backend_user; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_user (id, name, code, mode) FROM stdin;
1	admin	admin	rules
240	\N	user	rules
241	\N	user	sp
279	\N	usercond1	rules
280	\N	usercond2	rules
303	\N	admin	sp
\.


--
-- Name: backend_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_user_id_seq', 303, true);


--
-- Data for Name: backend_userselection; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_userselection (id, task, selection, owner_id, time_elapsed) FROM stdin;
1	887	{1}	240	67873
2	885	{1,2}	240	3055
\.


--
-- Name: backend_userselection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_userselection_id_seq', 129, true);


--
-- Data for Name: backend_userstudytapset; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_userstudytapset (id, taskset, scenario, condition, task_id, disabled) FROM stdin;
12	1	2	1	2	f
13	1	4	1	4	f
14	1	5	1	5	f
15	1	7	1	7	f
16	1	8	1	8	f
17	2	1	1	1	f
19	2	3	1	3	f
21	2	6	1	6	f
23	1	887	1	887	f
18	2	1	2	1	t
20	2	3	2	3	t
22	2	6	2	6	t
24	1	885	1	885	f
25	1	886	1	886	f
26	1	888	1	888	f
27	1	889	1	889	f
28	1	880	1	880	f
29	1	881	1	881	f
30	2	9	1	9	f
31	2	9	2	9	t
32	1	12	1	12	f
\.


--
-- Name: backend_userstudytapset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_userstudytapset_id_seq', 32, true);


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
10	2020-03-22 22:05:32.141542+00	70	Capability object (70)	1	[{"added": {}}]	22	2
11	2020-03-22 22:06:48.712131+00	12	Location Sensor	2	[{"changed": {"fields": ["caps"]}}]	14	2
12	2020-03-22 22:08:44.399695+00	79	who	1	[{"added": {}}]	34	2
13	2020-03-22 22:09:34.374573+00	80	location, 80	1	[{"added": {}}]	34	2
14	2020-03-22 22:11:09.650183+00	46	Nobody, who, 79	1	[{"added": {}}]	17	2
15	2020-03-22 22:11:28.035669+00	47	A Family Member, who, 79	1	[{"added": {}}]	17	2
16	2020-03-22 22:11:39.739178+00	48	A Guest, who, 79	1	[{"added": {}}]	17	2
17	2020-03-22 22:11:47.655364+00	49	Bobbie, who, 79	1	[{"added": {}}]	17	2
18	2020-03-22 22:11:55.985875+00	50	Alice, who, 79	1	[{"added": {}}]	17	2
19	2020-03-22 22:12:04.804281+00	51	Anyone, who, 79	1	[{"added": {}}]	17	2
20	2020-03-22 22:12:30.99673+00	52	Living Room, location, 80	1	[{"added": {}}]	17	2
21	2020-03-22 22:12:40.014719+00	53	Bathroom, location, 80	1	[{"added": {}}]	17	2
22	2020-03-22 22:12:49.360622+00	54	Bedroom, location, 80	1	[{"added": {}}]	17	2
23	2020-03-22 22:12:58.05365+00	55	Kitchen, location, 80	1	[{"added": {}}]	17	2
24	2020-03-22 22:13:09.100789+00	56	Home, location, 80	1	[{"added": {}}]	17	2
25	2020-03-22 22:16:30.782087+00	70	Capability object (70)	2	[{"changed": {"fields": ["channels"]}}]	22	2
26	2020-03-22 22:16:51.933318+00	70	Capability object (70)	2	[{"changed": {"fields": ["name"]}}]	22	2
27	2020-03-22 22:17:02.791108+00	70	Capability object (70)	2	[{"changed": {"fields": ["name"]}}]	22	2
28	2020-03-22 22:17:34.85011+00	70	Capability object (70)	2	[{"changed": {"fields": ["name"]}}]	22	2
29	2020-03-22 22:26:29.301326+00	12	Location Sensor	2	[{"changed": {"fields": ["caps"]}}]	14	2
30	2020-03-22 22:26:59.197499+00	28	Location Sensor Set	1	[{"added": {}}]	14	2
31	2020-03-22 22:38:12.613588+00	11	taskset: 2, scenario: 6, condition: 2, task_id: 6	3		41	2
32	2020-03-22 22:38:12.617234+00	10	taskset: 2, scenario: 6, condition: 1, task_id: 6	3		41	2
33	2020-03-22 22:38:12.618652+00	9	taskset: 2, scenario: 3, condition: 2, task_id: 3	3		41	2
34	2020-03-22 22:38:12.619881+00	8	taskset: 2, scenario: 3, condition: 1, task_id: 3	3		41	2
35	2020-03-22 22:38:12.6211+00	7	taskset: 2, scenario: 1, condition: 2, task_id: 1	3		41	2
36	2020-03-22 22:38:12.62234+00	6	taskset: 2, scenario: 1, condition: 1, task_id: 1	3		41	2
37	2020-03-22 22:38:12.62364+00	5	taskset: 1, scenario: 8, condition: 1, task_id: 8	3		41	2
38	2020-03-22 22:38:12.624901+00	4	taskset: 1, scenario: 7, condition: 1, task_id: 7	3		41	2
39	2020-03-22 22:38:12.626035+00	3	taskset: 1, scenario: 5, condition: 1, task_id: 5	3		41	2
40	2020-03-22 22:38:12.627325+00	2	taskset: 1, scenario: 4, condition: 1, task_id: 4	3		41	2
41	2020-03-22 22:38:12.628652+00	1	taskset: 1, scenario: 2, condition: 1, task_id: 2	3		41	2
42	2020-07-10 15:23:54.504639+00	18	taskset: 2, scenario: 1, condition: 2, task_id: 1	2	[{"changed": {"fields": ["disabled"]}}]	41	2
43	2020-07-10 15:24:01.248807+00	20	taskset: 2, scenario: 3, condition: 2, task_id: 3	2	[{"changed": {"fields": ["disabled"]}}]	41	2
44	2020-07-10 15:24:05.348335+00	22	taskset: 2, scenario: 6, condition: 2, task_id: 6	2	[{"changed": {"fields": ["disabled"]}}]	41	2
45	2020-07-25 18:28:57.238436+00	274	usernewwwww2	3		13	2
46	2020-07-25 18:28:57.321919+00	273	usernewwwww2	3		13	2
47	2020-07-25 18:28:57.326897+00	272	usernewwwww	3		13	2
48	2020-07-25 18:28:57.330937+00	271	usernewwwww	3		13	2
49	2020-07-25 18:28:57.334957+00	270	user62	3		13	2
50	2020-07-25 18:28:57.339031+00	269	user68	3		13	2
51	2020-07-25 18:28:57.343433+00	268	user68	3		13	2
52	2020-07-25 18:28:57.34735+00	267	user5	3		13	2
53	2020-07-25 18:28:57.350959+00	266	user3	3		13	2
54	2020-07-25 18:28:57.354846+00	265	newnewppl2	3		13	2
55	2020-07-25 18:28:57.359416+00	264	newnewppl	3		13	2
56	2020-07-25 18:28:57.363366+00	263	newpppl2	3		13	2
57	2020-07-25 18:28:57.367706+00	262	newpppl	3		13	2
58	2020-07-25 18:28:57.37158+00	261	news	3		13	2
59	2020-07-25 18:28:57.376087+00	260	usernewnew	3		13	2
60	2020-07-25 18:28:57.380049+00	259	user235	3		13	2
61	2020-07-25 18:28:57.383719+00	258	user2user3	3		13	2
62	2020-07-25 18:28:57.387135+00	257	user2user	3		13	2
63	2020-07-25 18:28:57.39054+00	256	userres1	3		13	2
64	2020-07-25 18:28:57.39397+00	255	userres	3		13	2
65	2020-07-25 18:28:57.397648+00	254	user023	3		13	2
66	2020-07-25 18:28:57.40133+00	253	user2	3		13	2
67	2020-07-25 18:28:57.404999+00	252	aprfifteen2	3		13	2
68	2020-07-25 18:28:57.409002+00	251	aprfourteen2	3		13	2
69	2020-07-25 18:28:57.413374+00	250	aprfourteen	3		13	2
70	2020-07-25 18:28:57.416944+00	249	abc	3		13	2
71	2020-07-25 18:28:57.420594+00	248	someone4	3		13	2
72	2020-07-25 18:28:57.425584+00	247	someone3	3		13	2
73	2020-07-25 18:28:57.43007+00	246	someone2	3		13	2
74	2020-07-25 18:28:57.433953+00	245	someonenew	3		13	2
75	2020-07-25 18:28:57.437832+00	244	someone	3		13	2
76	2020-07-25 18:28:57.442499+00	243	123	3		13	2
77	2020-07-25 18:28:57.446204+00	242	undefined	3		13	2
78	2020-08-11 16:24:04.149402+00	31	taskset: 2, scenario: 9, condition: 2, task_id: 9	2	[{"changed": {"fields": ["disabled"]}}]	41	3
79	2020-08-11 18:11:57.367627+00	302	newq4	3		13	3
80	2020-08-11 18:11:57.375668+00	301	tententen	3		13	3
81	2020-08-11 18:11:57.380713+00	300	ten	3		13	3
82	2020-08-11 18:11:57.384242+00	299	q	3		13	3
83	2020-08-11 18:11:57.386394+00	298	5c2b4b959f18a9000179a141	3		13	3
84	2020-08-11 18:11:57.388494+00	297	5ed79e7540f13a06856a0fca	3		13	3
85	2020-08-11 18:11:57.390506+00	296	5f2beb80cab8eb0199656a93	3		13	3
86	2020-08-11 18:11:57.392565+00	295	5f22b8209e18f00343b3b14c	3		13	3
87	2020-08-11 18:11:57.394508+00	294	5f026114e2b9843f5d762969	3		13	3
88	2020-08-11 18:11:57.396541+00	293	5effa5905e7e8b09807ebb50	3		13	3
89	2020-08-11 18:11:57.39862+00	292	5f1f0bbb50ee5409d4107dcb	3		13	3
90	2020-08-11 18:11:57.400841+00	291	5ec67f07f9688305a4ef19da	3		13	3
91	2020-08-11 18:11:57.403075+00	290	5f25fdbc64fcbe2efa857a55	3		13	3
92	2020-08-11 18:11:57.405296+00	289	5ef005948c610f5171f1a3aa	3		13	3
93	2020-08-11 18:11:57.407524+00	288	5cf591fd639b150016eb878d	3		13	3
94	2020-08-11 18:11:57.409707+00	287	5f08789b2aceae078db2b8bf	3		13	3
95	2020-08-11 18:11:57.412583+00	286	5ef8c97c7d12750402b08ba4	3		13	3
96	2020-08-11 18:11:57.415131+00	285	5ee6706034f12e3d82d952aa	3		13	3
97	2020-08-11 18:11:57.417478+00	284	5f180b942103211d36c447a1	3		13	3
98	2020-08-11 18:11:57.419722+00	283	5edf222d1b8bce1bdd61cd2d	3		13	3
99	2020-08-11 18:11:57.422034+00	282	5e1d0bdfdc1a170a132a6980	3		13	3
100	2020-08-11 18:11:57.42572+00	281	ten3	3		13	3
101	2020-08-11 18:11:57.430413+00	278	user2new	3		13	3
102	2020-08-11 18:11:57.434235+00	277	user2	3		13	3
103	2020-08-11 18:11:57.437478+00	276	tiago	3		13	3
104	2020-08-11 18:11:57.440755+00	275	hi	3		13	3
\.


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 104, true);


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	group
3	auth	user
4	auth	permission
5	contenttypes	contenttype
6	sessions	session
7	user_auth	usermetadata
8	rule_management	rule
9	rule_management	abstractcharecteristic
10	rule_management	devicecharecteristic
11	rule_management	device
12	backend	rule
13	backend	user
14	backend	device
15	backend	statelog
16	backend	safetyprop
17	backend	setparamopt
18	backend	state
19	backend	parval
20	backend	condition
21	backend	parameter
22	backend	capability
23	backend	channel
24	backend	metaparam
25	backend	esrule
26	backend	inputparam
27	backend	trigger
28	backend	sp1
29	backend	timeparam
30	backend	colorparam
31	backend	ssrule
32	backend	sp2
33	backend	sp3
34	backend	setparam
35	backend	binparam
36	backend	rangeparam
37	backend	durationparam
38	st_end	stapp
39	st_end	device
40	backend	esrulemeta
41	backend	userstudytapset
42	backend	userselection
\.


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 42, true);


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
39	contenttypes	0001_initial	2019-09-06 16:44:41.382477+00
40	auth	0001_initial	2019-09-06 16:44:41.400336+00
41	admin	0001_initial	2019-09-06 16:44:41.407909+00
42	admin	0002_logentry_remove_auto_add	2019-09-06 16:44:41.41763+00
43	contenttypes	0002_remove_content_type_name	2019-09-06 16:44:41.425745+00
44	auth	0002_alter_permission_name_max_length	2019-09-06 16:44:41.434313+00
45	auth	0003_alter_user_email_max_length	2019-09-06 16:44:41.442384+00
46	auth	0004_alter_user_username_opts	2019-09-06 16:44:41.449463+00
47	auth	0005_alter_user_last_login_null	2019-09-06 16:44:41.458237+00
48	auth	0006_require_contenttypes_0002	2019-09-06 16:44:41.467217+00
49	auth	0007_alter_validators_add_error_messages	2019-09-06 16:44:41.475303+00
50	auth	0008_alter_user_username_max_length	2019-09-06 16:44:41.484442+00
51	auth	0009_alter_user_last_name_max_length	2019-09-06 16:44:41.492582+00
52	sessions	0001_initial	2019-09-06 16:44:41.501181+00
53	backend	0001_initial	2019-09-06 16:47:19.224061+00
54	rule_management	0001_initial	2019-09-06 16:47:19.266447+00
55	st_end	0001_initial	2019-09-06 16:47:19.277416+00
56	user_auth	0001_initial	2019-09-06 16:47:19.305415+00
57	backend	0002_auto_20200329_2100	2020-03-29 21:06:43.886863+00
58	backend	0003_userstudytapset_disabled	2020-07-10 04:23:57.723278+00
\.


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 58, true);


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
iovsxn4k3qnqtc4zdd8zdjwml15i32tp	YjYxNWZjZGNmMWM5NmE3MGQ2MDc3ODUwMzk4NGU0ZDEyZDc2Y2EzMTp7Il9hdXRoX3VzZXJfaWQiOiIyIiwiX2F1dGhfdXNlcl9oYXNoIjoiM2Y4MWYyZjIwZDE2YWJmZDU4NzZhMDRjYzI1ZGQzMGFjYmU4NmVlZCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIn0=	2020-04-05 22:00:40.292452+00
qcaw93huqd76dx2btwoily9co72gjt8s	N2YzOThjZmM4MzJiMDFjMDAyYzExYTg3OTBiM2I2YTAyYWVlNGMxZTp7Il9hdXRoX3VzZXJfaWQiOiIyIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIzZjgxZjJmMjBkMTZhYmZkNTg3NmEwNGNjMjVkZDMwYWNiZTg2ZWVkIn0=	2020-04-28 23:49:53.217397+00
kf25g9blspiwbc0fzayxjegettbz4rfz	YmYxMjJlMWE4NmVlMWE5NmEzOTY4NWY3YjRiMDIyNTY3NjFiODY4Mjp7Il9hdXRoX3VzZXJfaGFzaCI6IjNmODFmMmYyMGQxNmFiZmQ1ODc2YTA0Y2MyNWRkMzBhY2JlODZlZWQiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIyIn0=	2020-07-24 03:39:31.695487+00
51qcem1ufe4lqa4z6d8rpeiwjeezj4ok	OTVmNmU4NTY0OWI2NzQzNmQ2YzI2MWZiMThiZDA3OWI5ODM4YWM0OTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiNDY2ZGU0NmNiYzg2ZDQ2YmY4YzFhY2M1ODc2MTRjN2ZkMmIxNThlNyIsIl9hdXRoX3VzZXJfaWQiOiIyIn0=	2020-07-24 15:22:57.367902+00
jjscd1tx1to3rjilw51t6k26ow5n65yg	YjljYWRkZTNjMWJlYWQyNzQ1MDY2YTkxMDNiYzhlZDY2YWE1YmFlMDp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6IjIiLCJfYXV0aF91c2VyX2hhc2giOiIzZjgxZjJmMjBkMTZhYmZkNTg3NmEwNGNjMjVkZDMwYWNiZTg2ZWVkIn0=	2020-08-02 21:49:47.901712+00
9cppyofk94a5g7gwk3ijbhhqt31m2g44	NmQ3MDA2YTYzZDk0MWU1Yjc2NDkxNzMxOGUyMjc0MjY4MjhkOTg5Nzp7Il9hdXRoX3VzZXJfaGFzaCI6IjNmODFmMmYyMGQxNmFiZmQ1ODc2YTA0Y2MyNWRkMzBhY2JlODZlZWQiLCJfYXV0aF91c2VyX2lkIjoiMiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIn0=	2020-08-08 18:26:15.020461+00
7vbfc03d4hd1lf6pr1v1myjbcroak5iy	MTViYjNmYzRhZDQ2ZGZlMjQ2N2U3N2U0NmEzZTMyMWU3ZWViNzlmYjp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiM2Y4MWYyZjIwZDE2YWJmZDU4NzZhMDRjYzI1ZGQzMGFjYmU4NmVlZCIsIl9hdXRoX3VzZXJfaWQiOiIyIn0=	2020-08-11 20:07:36.414974+00
yiutiycqwiwukhhh4l31thko864u3ft5	NDM1OWU5MDdmOTE3YTFjNWYzZGFlNWVhMzdiNmY1ZGY0OTM4MDgwNDp7Il9hdXRoX3VzZXJfaGFzaCI6ImIzNDA2MTA5NzEzMjVmZGZhZjBiYWJjN2Q5NmEwMThjNzg2ZDQzMmQiLCJfYXV0aF91c2VyX2lkIjoiMyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIn0=	2020-08-25 16:23:24.758566+00
viyqp6oa493pb05l4zozej9vifmpik9c	ZDJhODYxODVlMTIwYzM3MmMxNTQyYmUzMWM5NWJkZTNmZjg2ZWE2MTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiYjc5ZTllMzZmOTI3OWJmYzI0YzE5MGM3ZjQyNWM5NGI2Y2M1M2ZkYiIsIl9hdXRoX3VzZXJfaWQiOiIzIn0=	2020-08-25 18:07:12.606096+00
n7vzicgblaqbk1ruedppjli6bmtcgtck	YjlmZjhhOGU4NDMwMDAzNDFhYWUyYzVmOTBiN2ExNGNhYTViNjExNjp7Il9hdXRoX3VzZXJfaGFzaCI6ImI3OWU5ZTM2ZjkyNzliZmMyNGMxOTBjN2Y0MjVjOTRiNmNjNTNmZGIiLCJfYXV0aF91c2VyX2lkIjoiMyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIn0=	2020-08-28 18:45:45.377217+00
\.


--
-- Data for Name: rule_management_abstractcharecteristic; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.rule_management_abstractcharecteristic (id, characteristic_name) FROM stdin;
\.


--
-- Name: rule_management_abstractcharecteristic_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.rule_management_abstractcharecteristic_id_seq', 1, false);


--
-- Data for Name: rule_management_device; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.rule_management_device (id, device_name) FROM stdin;
\.


--
-- Name: rule_management_device_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.rule_management_device_id_seq', 1, false);


--
-- Data for Name: rule_management_device_users; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.rule_management_device_users (id, device_id, user_id) FROM stdin;
\.


--
-- Name: rule_management_device_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.rule_management_device_users_id_seq', 1, false);


--
-- Data for Name: rule_management_devicecharecteristic; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.rule_management_devicecharecteristic (id, abstract_charecteristic_id, device_id) FROM stdin;
\.


--
-- Data for Name: rule_management_devicecharecteristic_affected_rules; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.rule_management_devicecharecteristic_affected_rules (id, devicecharecteristic_id, rule_id) FROM stdin;
\.


--
-- Name: rule_management_devicecharecteristic_affected_rules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.rule_management_devicecharecteristic_affected_rules_id_seq', 1, false);


--
-- Name: rule_management_devicecharecteristic_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.rule_management_devicecharecteristic_id_seq', 1, false);


--
-- Data for Name: rule_management_rule; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.rule_management_rule (id, rule_name) FROM stdin;
\.


--
-- Name: rule_management_rule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.rule_management_rule_id_seq', 1, false);


--
-- Data for Name: st_end_device; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.st_end_device (id, device_id, device_name, device_label) FROM stdin;
\.


--
-- Name: st_end_device_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.st_end_device_id_seq', 1, false);


--
-- Data for Name: st_end_stapp; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.st_end_stapp (id, st_installed_app_id, refresh_token) FROM stdin;
\.


--
-- Name: st_end_stapp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.st_end_stapp_id_seq', 1, false);


--
-- Data for Name: user_auth_usermetadata; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.user_auth_usermetadata (id, user_id) FROM stdin;
\.


--
-- Name: user_auth_usermetadata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.user_auth_usermetadata_id_seq', 1, false);


--
-- Name: auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: backend_binparam_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_binparam
    ADD CONSTRAINT backend_binparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_capability_chann_capability_id_channel_id_131031e1_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_capability_channels
    ADD CONSTRAINT backend_capability_chann_capability_id_channel_id_131031e1_uniq UNIQUE (capability_id, channel_id);


--
-- Name: backend_capability_channels_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_capability_channels
    ADD CONSTRAINT backend_capability_channels_pkey PRIMARY KEY (id);


--
-- Name: backend_capability_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_capability
    ADD CONSTRAINT backend_capability_pkey PRIMARY KEY (id);


--
-- Name: backend_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_channel
    ADD CONSTRAINT backend_channel_pkey PRIMARY KEY (id);


--
-- Name: backend_colorparam_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_colorparam
    ADD CONSTRAINT backend_colorparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_condition_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_condition
    ADD CONSTRAINT backend_condition_pkey PRIMARY KEY (id);


--
-- Name: backend_device_caps_device_id_capability_id_e4bb98c0_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_caps
    ADD CONSTRAINT backend_device_caps_device_id_capability_id_e4bb98c0_uniq UNIQUE (device_id, capability_id);


--
-- Name: backend_device_caps_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_caps
    ADD CONSTRAINT backend_device_caps_pkey PRIMARY KEY (id);


--
-- Name: backend_device_chans_device_id_channel_id_d581e087_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_chans
    ADD CONSTRAINT backend_device_chans_device_id_channel_id_d581e087_uniq UNIQUE (device_id, channel_id);


--
-- Name: backend_device_chans_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_chans
    ADD CONSTRAINT backend_device_chans_pkey PRIMARY KEY (id);


--
-- Name: backend_device_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device
    ADD CONSTRAINT backend_device_pkey PRIMARY KEY (id);


--
-- Name: backend_durationparam_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_durationparam
    ADD CONSTRAINT backend_durationparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_esrule_Striggers_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public."backend_esrule_Striggers"
    ADD CONSTRAINT "backend_esrule_Striggers_pkey" PRIMARY KEY (id);


--
-- Name: backend_esrule_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_esrule
    ADD CONSTRAINT backend_esrule_pkey PRIMARY KEY (rule_ptr_id);


--
-- Name: backend_esrule_striggers_esrule_id_trigger_id_ea5826a3_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public."backend_esrule_Striggers"
    ADD CONSTRAINT backend_esrule_striggers_esrule_id_trigger_id_ea5826a3_uniq UNIQUE (esrule_id, trigger_id);


--
-- Name: backend_esrulemeta_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_esrulemeta
    ADD CONSTRAINT backend_esrulemeta_pkey PRIMARY KEY (id);


--
-- Name: backend_inputparam_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_inputparam
    ADD CONSTRAINT backend_inputparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_metaparam_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_metaparam
    ADD CONSTRAINT backend_metaparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_parameter_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_parameter
    ADD CONSTRAINT backend_parameter_pkey PRIMARY KEY (id);


--
-- Name: backend_parval_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_parval
    ADD CONSTRAINT backend_parval_pkey PRIMARY KEY (id);


--
-- Name: backend_rangeparam_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_rangeparam
    ADD CONSTRAINT backend_rangeparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_rule
    ADD CONSTRAINT backend_rule_pkey PRIMARY KEY (id);


--
-- Name: backend_safetyprop_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_safetyprop
    ADD CONSTRAINT backend_safetyprop_pkey PRIMARY KEY (id);


--
-- Name: backend_setparam_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_setparam
    ADD CONSTRAINT backend_setparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_setparamopt_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_setparamopt
    ADD CONSTRAINT backend_setparamopt_pkey PRIMARY KEY (id);


--
-- Name: backend_sp1_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp1
    ADD CONSTRAINT backend_sp1_pkey PRIMARY KEY (safetyprop_ptr_id);


--
-- Name: backend_sp1_triggers_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp1_triggers
    ADD CONSTRAINT backend_sp1_triggers_pkey PRIMARY KEY (id);


--
-- Name: backend_sp1_triggers_sp1_id_trigger_id_8b45f99b_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp1_triggers
    ADD CONSTRAINT backend_sp1_triggers_sp1_id_trigger_id_8b45f99b_uniq UNIQUE (sp1_id, trigger_id);


--
-- Name: backend_sp2_conds_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp2_conds
    ADD CONSTRAINT backend_sp2_conds_pkey PRIMARY KEY (id);


--
-- Name: backend_sp2_conds_sp2_id_trigger_id_8df7a647_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp2_conds
    ADD CONSTRAINT backend_sp2_conds_sp2_id_trigger_id_8df7a647_uniq UNIQUE (sp2_id, trigger_id);


--
-- Name: backend_sp2_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp2
    ADD CONSTRAINT backend_sp2_pkey PRIMARY KEY (safetyprop_ptr_id);


--
-- Name: backend_sp3_conds_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp3_conds
    ADD CONSTRAINT backend_sp3_conds_pkey PRIMARY KEY (id);


--
-- Name: backend_sp3_conds_sp3_id_trigger_id_472a7be0_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp3_conds
    ADD CONSTRAINT backend_sp3_conds_sp3_id_trigger_id_472a7be0_uniq UNIQUE (sp3_id, trigger_id);


--
-- Name: backend_sp3_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp3
    ADD CONSTRAINT backend_sp3_pkey PRIMARY KEY (safetyprop_ptr_id);


--
-- Name: backend_ssrule_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_ssrule
    ADD CONSTRAINT backend_ssrule_pkey PRIMARY KEY (rule_ptr_id);


--
-- Name: backend_ssrule_triggers_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_ssrule_triggers
    ADD CONSTRAINT backend_ssrule_triggers_pkey PRIMARY KEY (id);


--
-- Name: backend_ssrule_triggers_ssrule_id_trigger_id_133318d9_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_ssrule_triggers
    ADD CONSTRAINT backend_ssrule_triggers_ssrule_id_trigger_id_133318d9_uniq UNIQUE (ssrule_id, trigger_id);


--
-- Name: backend_state_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_state
    ADD CONSTRAINT backend_state_pkey PRIMARY KEY (id);


--
-- Name: backend_statelog_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_statelog
    ADD CONSTRAINT backend_statelog_pkey PRIMARY KEY (id);


--
-- Name: backend_timeparam_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_timeparam
    ADD CONSTRAINT backend_timeparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_trigger_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_trigger
    ADD CONSTRAINT backend_trigger_pkey PRIMARY KEY (id);


--
-- Name: backend_user_name_key; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_user
    ADD CONSTRAINT backend_user_name_key UNIQUE (name);


--
-- Name: backend_user_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_user
    ADD CONSTRAINT backend_user_pkey PRIMARY KEY (id);


--
-- Name: backend_userselection_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_userselection
    ADD CONSTRAINT backend_userselection_pkey PRIMARY KEY (id);


--
-- Name: backend_userstudytapset_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_userstudytapset
    ADD CONSTRAINT backend_userstudytapset_pkey PRIMARY KEY (id);


--
-- Name: django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: rule_management_abstractcharecteristic_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.rule_management_abstractcharecteristic
    ADD CONSTRAINT rule_management_abstractcharecteristic_pkey PRIMARY KEY (id);


--
-- Name: rule_management_device_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.rule_management_device
    ADD CONSTRAINT rule_management_device_pkey PRIMARY KEY (id);


--
-- Name: rule_management_device_users_device_id_user_id_cfae06ea_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.rule_management_device_users
    ADD CONSTRAINT rule_management_device_users_device_id_user_id_cfae06ea_uniq UNIQUE (device_id, user_id);


--
-- Name: rule_management_device_users_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.rule_management_device_users
    ADD CONSTRAINT rule_management_device_users_pkey PRIMARY KEY (id);


--
-- Name: rule_management_devicech_devicecharecteristic_id__d946f497_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.rule_management_devicecharecteristic_affected_rules
    ADD CONSTRAINT rule_management_devicech_devicecharecteristic_id__d946f497_uniq UNIQUE (devicecharecteristic_id, rule_id);


--
-- Name: rule_management_devicecharecteristic_affected_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.rule_management_devicecharecteristic_affected_rules
    ADD CONSTRAINT rule_management_devicecharecteristic_affected_rules_pkey PRIMARY KEY (id);


--
-- Name: rule_management_devicecharecteristic_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.rule_management_devicecharecteristic
    ADD CONSTRAINT rule_management_devicecharecteristic_pkey PRIMARY KEY (id);


--
-- Name: rule_management_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.rule_management_rule
    ADD CONSTRAINT rule_management_rule_pkey PRIMARY KEY (id);


--
-- Name: st_end_device_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.st_end_device
    ADD CONSTRAINT st_end_device_pkey PRIMARY KEY (id);


--
-- Name: st_end_stapp_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.st_end_stapp
    ADD CONSTRAINT st_end_stapp_pkey PRIMARY KEY (id);


--
-- Name: user_auth_usermetadata_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.user_auth_usermetadata
    ADD CONSTRAINT user_auth_usermetadata_pkey PRIMARY KEY (id);


--
-- Name: user_auth_usermetadata_user_id_key; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.user_auth_usermetadata
    ADD CONSTRAINT user_auth_usermetadata_user_id_key UNIQUE (user_id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: backend_capability_channels_capability_id_1bccd6c0; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_capability_channels_capability_id_1bccd6c0 ON public.backend_capability_channels USING btree (capability_id);


--
-- Name: backend_capability_channels_channel_id_84c47a3a; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_capability_channels_channel_id_84c47a3a ON public.backend_capability_channels USING btree (channel_id);


--
-- Name: backend_condition_par_id_bddbc67e; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_condition_par_id_bddbc67e ON public.backend_condition USING btree (par_id);


--
-- Name: backend_condition_trigger_id_5a7be7ee; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_condition_trigger_id_5a7be7ee ON public.backend_condition USING btree (trigger_id);


--
-- Name: backend_device_caps_capability_id_6d681664; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_device_caps_capability_id_6d681664 ON public.backend_device_caps USING btree (capability_id);


--
-- Name: backend_device_caps_device_id_582e64dc; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_device_caps_device_id_582e64dc ON public.backend_device_caps USING btree (device_id);


--
-- Name: backend_device_chans_channel_id_d5e05cbd; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_device_chans_channel_id_d5e05cbd ON public.backend_device_chans USING btree (channel_id);


--
-- Name: backend_device_chans_device_id_7eaeaa06; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_device_chans_device_id_7eaeaa06 ON public.backend_device_chans USING btree (device_id);


--
-- Name: backend_device_owner_id_a248fd8b; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_device_owner_id_a248fd8b ON public.backend_device USING btree (owner_id);


--
-- Name: backend_esrule_Etrigger_id_7440ebf1; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX "backend_esrule_Etrigger_id_7440ebf1" ON public.backend_esrule USING btree ("Etrigger_id");


--
-- Name: backend_esrule_Striggers_esrule_id_dea8f5db; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX "backend_esrule_Striggers_esrule_id_dea8f5db" ON public."backend_esrule_Striggers" USING btree (esrule_id);


--
-- Name: backend_esrule_Striggers_trigger_id_5c3c8add; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX "backend_esrule_Striggers_trigger_id_5c3c8add" ON public."backend_esrule_Striggers" USING btree (trigger_id);


--
-- Name: backend_esrule_action_id_722dc031; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_esrule_action_id_722dc031 ON public.backend_esrule USING btree (action_id);


--
-- Name: backend_esrulemeta_rule_id_0c047c9b; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_esrulemeta_rule_id_0c047c9b ON public.backend_esrulemeta USING btree (rule_id);


--
-- Name: backend_esrulemeta_tapset_id_2e387507; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_esrulemeta_tapset_id_2e387507 ON public.backend_esrulemeta USING btree (tapset_id);


--
-- Name: backend_parameter_cap_id_b4de2acb; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_parameter_cap_id_b4de2acb ON public.backend_parameter USING btree (cap_id);


--
-- Name: backend_parval_par_id_049e0be4; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_parval_par_id_049e0be4 ON public.backend_parval USING btree (par_id);


--
-- Name: backend_parval_state_id_cde26674; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_parval_state_id_cde26674 ON public.backend_parval USING btree (state_id);


--
-- Name: backend_rule_owner_id_32585cc6; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_rule_owner_id_32585cc6 ON public.backend_rule USING btree (owner_id);


--
-- Name: backend_safetyprop_owner_id_0b165fad; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_safetyprop_owner_id_0b165fad ON public.backend_safetyprop USING btree (owner_id);


--
-- Name: backend_setparamopt_param_id_07e0f502; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_setparamopt_param_id_07e0f502 ON public.backend_setparamopt USING btree (param_id);


--
-- Name: backend_sp1_triggers_sp1_id_c4c1aca5; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_sp1_triggers_sp1_id_c4c1aca5 ON public.backend_sp1_triggers USING btree (sp1_id);


--
-- Name: backend_sp1_triggers_trigger_id_83a751db; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_sp1_triggers_trigger_id_83a751db ON public.backend_sp1_triggers USING btree (trigger_id);


--
-- Name: backend_sp2_conds_sp2_id_1fb0191a; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_sp2_conds_sp2_id_1fb0191a ON public.backend_sp2_conds USING btree (sp2_id);


--
-- Name: backend_sp2_conds_trigger_id_b90c6fa9; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_sp2_conds_trigger_id_b90c6fa9 ON public.backend_sp2_conds USING btree (trigger_id);


--
-- Name: backend_sp2_state_id_01caf21d; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_sp2_state_id_01caf21d ON public.backend_sp2 USING btree (state_id);


--
-- Name: backend_sp3_conds_sp3_id_f2c1fec5; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_sp3_conds_sp3_id_f2c1fec5 ON public.backend_sp3_conds USING btree (sp3_id);


--
-- Name: backend_sp3_conds_trigger_id_4aa9489f; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_sp3_conds_trigger_id_4aa9489f ON public.backend_sp3_conds USING btree (trigger_id);


--
-- Name: backend_sp3_event_id_b133fd92; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_sp3_event_id_b133fd92 ON public.backend_sp3 USING btree (event_id);


--
-- Name: backend_ssrule_action_id_6626b087; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_ssrule_action_id_6626b087 ON public.backend_ssrule USING btree (action_id);


--
-- Name: backend_ssrule_triggers_ssrule_id_c5913b93; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_ssrule_triggers_ssrule_id_c5913b93 ON public.backend_ssrule_triggers USING btree (ssrule_id);


--
-- Name: backend_ssrule_triggers_trigger_id_d0a0f6b6; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_ssrule_triggers_trigger_id_d0a0f6b6 ON public.backend_ssrule_triggers USING btree (trigger_id);


--
-- Name: backend_state_cap_id_25727ebe; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_state_cap_id_25727ebe ON public.backend_state USING btree (cap_id);


--
-- Name: backend_state_chan_id_b9d0a0d4; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_state_chan_id_b9d0a0d4 ON public.backend_state USING btree (chan_id);


--
-- Name: backend_state_dev_id_a376fae0; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_state_dev_id_a376fae0 ON public.backend_state USING btree (dev_id);


--
-- Name: backend_statelog_cap_id_a554767b; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_statelog_cap_id_a554767b ON public.backend_statelog USING btree (cap_id);


--
-- Name: backend_statelog_dev_id_63f7e345; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_statelog_dev_id_63f7e345 ON public.backend_statelog USING btree (dev_id);


--
-- Name: backend_statelog_param_id_ab9f8aa5; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_statelog_param_id_ab9f8aa5 ON public.backend_statelog USING btree (param_id);


--
-- Name: backend_trigger_cap_id_c28ac690; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_trigger_cap_id_c28ac690 ON public.backend_trigger USING btree (cap_id);


--
-- Name: backend_trigger_chan_id_bbc8de39; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_trigger_chan_id_bbc8de39 ON public.backend_trigger USING btree (chan_id);


--
-- Name: backend_trigger_dev_id_4a2e1853; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_trigger_dev_id_4a2e1853 ON public.backend_trigger USING btree (dev_id);


--
-- Name: backend_user_name_58ad4df8_like; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_user_name_58ad4df8_like ON public.backend_user USING btree (name varchar_pattern_ops);


--
-- Name: backend_userselection_owner_id_0a5b8480; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_userselection_owner_id_0a5b8480 ON public.backend_userselection USING btree (owner_id);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: rule_management_device_users_device_id_d457f89d; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX rule_management_device_users_device_id_d457f89d ON public.rule_management_device_users USING btree (device_id);


--
-- Name: rule_management_device_users_user_id_71361e1a; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX rule_management_device_users_user_id_71361e1a ON public.rule_management_device_users USING btree (user_id);


--
-- Name: rule_management_devicechar_abstract_charecteristic_id_a55f6ccb; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX rule_management_devicechar_abstract_charecteristic_id_a55f6ccb ON public.rule_management_devicecharecteristic USING btree (abstract_charecteristic_id);


--
-- Name: rule_management_devicechar_devicecharecteristic_id_62d7357a; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX rule_management_devicechar_devicecharecteristic_id_62d7357a ON public.rule_management_devicecharecteristic_affected_rules USING btree (devicecharecteristic_id);


--
-- Name: rule_management_devicechar_rule_id_07fbc410; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX rule_management_devicechar_rule_id_07fbc410 ON public.rule_management_devicecharecteristic_affected_rules USING btree (rule_id);


--
-- Name: rule_management_devicecharecteristic_device_id_2fc7b33f; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX rule_management_devicecharecteristic_device_id_2fc7b33f ON public.rule_management_devicecharecteristic USING btree (device_id);


--
-- Name: auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_binparam_parameter_ptr_id_4fc53892_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_binparam
    ADD CONSTRAINT backend_binparam_parameter_ptr_id_4fc53892_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_capability_c_capability_id_1bccd6c0_fk_backend_c; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_capability_channels
    ADD CONSTRAINT backend_capability_c_capability_id_1bccd6c0_fk_backend_c FOREIGN KEY (capability_id) REFERENCES public.backend_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_capability_c_channel_id_84c47a3a_fk_backend_c; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_capability_channels
    ADD CONSTRAINT backend_capability_c_channel_id_84c47a3a_fk_backend_c FOREIGN KEY (channel_id) REFERENCES public.backend_channel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_colorparam_parameter_ptr_id_2a10b1b1_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_colorparam
    ADD CONSTRAINT backend_colorparam_parameter_ptr_id_2a10b1b1_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_condition_par_id_bddbc67e_fk_backend_parameter_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_condition
    ADD CONSTRAINT backend_condition_par_id_bddbc67e_fk_backend_parameter_id FOREIGN KEY (par_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_condition_trigger_id_5a7be7ee_fk_backend_trigger_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_condition
    ADD CONSTRAINT backend_condition_trigger_id_5a7be7ee_fk_backend_trigger_id FOREIGN KEY (trigger_id) REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_device_caps_capability_id_6d681664_fk_backend_c; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_caps
    ADD CONSTRAINT backend_device_caps_capability_id_6d681664_fk_backend_c FOREIGN KEY (capability_id) REFERENCES public.backend_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_device_caps_device_id_582e64dc_fk_backend_device_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_caps
    ADD CONSTRAINT backend_device_caps_device_id_582e64dc_fk_backend_device_id FOREIGN KEY (device_id) REFERENCES public.backend_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_device_chans_channel_id_d5e05cbd_fk_backend_channel_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_chans
    ADD CONSTRAINT backend_device_chans_channel_id_d5e05cbd_fk_backend_channel_id FOREIGN KEY (channel_id) REFERENCES public.backend_channel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_device_chans_device_id_7eaeaa06_fk_backend_device_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_chans
    ADD CONSTRAINT backend_device_chans_device_id_7eaeaa06_fk_backend_device_id FOREIGN KEY (device_id) REFERENCES public.backend_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_device_owner_id_a248fd8b_fk_backend_user_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device
    ADD CONSTRAINT backend_device_owner_id_a248fd8b_fk_backend_user_id FOREIGN KEY (owner_id) REFERENCES public.backend_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_durationpara_parameter_ptr_id_06b460c1_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_durationparam
    ADD CONSTRAINT backend_durationpara_parameter_ptr_id_06b460c1_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_esrule_Etrigger_id_7440ebf1_fk_backend_trigger_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_esrule
    ADD CONSTRAINT "backend_esrule_Etrigger_id_7440ebf1_fk_backend_trigger_id" FOREIGN KEY ("Etrigger_id") REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_esrule_Strig_esrule_id_dea8f5db_fk_backend_e; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public."backend_esrule_Striggers"
    ADD CONSTRAINT "backend_esrule_Strig_esrule_id_dea8f5db_fk_backend_e" FOREIGN KEY (esrule_id) REFERENCES public.backend_esrule(rule_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_esrule_Strig_trigger_id_5c3c8add_fk_backend_t; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public."backend_esrule_Striggers"
    ADD CONSTRAINT "backend_esrule_Strig_trigger_id_5c3c8add_fk_backend_t" FOREIGN KEY (trigger_id) REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_esrule_action_id_722dc031_fk_backend_state_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_esrule
    ADD CONSTRAINT backend_esrule_action_id_722dc031_fk_backend_state_id FOREIGN KEY (action_id) REFERENCES public.backend_state(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_esrule_rule_ptr_id_f8f656ef_fk_backend_rule_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_esrule
    ADD CONSTRAINT backend_esrule_rule_ptr_id_f8f656ef_fk_backend_rule_id FOREIGN KEY (rule_ptr_id) REFERENCES public.backend_rule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_esrulemeta_rule_id_0c047c9b_fk_backend_e; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_esrulemeta
    ADD CONSTRAINT backend_esrulemeta_rule_id_0c047c9b_fk_backend_e FOREIGN KEY (rule_id) REFERENCES public.backend_esrule(rule_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_esrulemeta_tapset_id_2e387507_fk_backend_u; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_esrulemeta
    ADD CONSTRAINT backend_esrulemeta_tapset_id_2e387507_fk_backend_u FOREIGN KEY (tapset_id) REFERENCES public.backend_userstudytapset(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_inputparam_parameter_ptr_id_7d2d6fe8_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_inputparam
    ADD CONSTRAINT backend_inputparam_parameter_ptr_id_7d2d6fe8_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_metaparam_parameter_ptr_id_56ce872d_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_metaparam
    ADD CONSTRAINT backend_metaparam_parameter_ptr_id_56ce872d_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_parameter_cap_id_b4de2acb_fk_backend_capability_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_parameter
    ADD CONSTRAINT backend_parameter_cap_id_b4de2acb_fk_backend_capability_id FOREIGN KEY (cap_id) REFERENCES public.backend_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_parval_par_id_049e0be4_fk_backend_parameter_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_parval
    ADD CONSTRAINT backend_parval_par_id_049e0be4_fk_backend_parameter_id FOREIGN KEY (par_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_parval_state_id_cde26674_fk_backend_state_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_parval
    ADD CONSTRAINT backend_parval_state_id_cde26674_fk_backend_state_id FOREIGN KEY (state_id) REFERENCES public.backend_state(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_rangeparam_parameter_ptr_id_9a607db7_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_rangeparam
    ADD CONSTRAINT backend_rangeparam_parameter_ptr_id_9a607db7_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_rule_owner_id_32585cc6_fk_backend_user_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_rule
    ADD CONSTRAINT backend_rule_owner_id_32585cc6_fk_backend_user_id FOREIGN KEY (owner_id) REFERENCES public.backend_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_safetyprop_owner_id_0b165fad_fk_backend_user_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_safetyprop
    ADD CONSTRAINT backend_safetyprop_owner_id_0b165fad_fk_backend_user_id FOREIGN KEY (owner_id) REFERENCES public.backend_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_setparam_parameter_ptr_id_18bfc60c_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_setparam
    ADD CONSTRAINT backend_setparam_parameter_ptr_id_18bfc60c_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_setparamopt_param_id_07e0f502_fk_backend_s; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_setparamopt
    ADD CONSTRAINT backend_setparamopt_param_id_07e0f502_fk_backend_s FOREIGN KEY (param_id) REFERENCES public.backend_setparam(parameter_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp1_safetyprop_ptr_id_d29a5f23_fk_backend_safetyprop_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp1
    ADD CONSTRAINT backend_sp1_safetyprop_ptr_id_d29a5f23_fk_backend_safetyprop_id FOREIGN KEY (safetyprop_ptr_id) REFERENCES public.backend_safetyprop(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp1_triggers_sp1_id_c4c1aca5_fk_backend_s; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp1_triggers
    ADD CONSTRAINT backend_sp1_triggers_sp1_id_c4c1aca5_fk_backend_s FOREIGN KEY (sp1_id) REFERENCES public.backend_sp1(safetyprop_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp1_triggers_trigger_id_83a751db_fk_backend_trigger_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp1_triggers
    ADD CONSTRAINT backend_sp1_triggers_trigger_id_83a751db_fk_backend_trigger_id FOREIGN KEY (trigger_id) REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp2_conds_sp2_id_1fb0191a_fk_backend_s; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp2_conds
    ADD CONSTRAINT backend_sp2_conds_sp2_id_1fb0191a_fk_backend_s FOREIGN KEY (sp2_id) REFERENCES public.backend_sp2(safetyprop_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp2_conds_trigger_id_b90c6fa9_fk_backend_trigger_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp2_conds
    ADD CONSTRAINT backend_sp2_conds_trigger_id_b90c6fa9_fk_backend_trigger_id FOREIGN KEY (trigger_id) REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp2_safetyprop_ptr_id_6057ecb9_fk_backend_safetyprop_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp2
    ADD CONSTRAINT backend_sp2_safetyprop_ptr_id_6057ecb9_fk_backend_safetyprop_id FOREIGN KEY (safetyprop_ptr_id) REFERENCES public.backend_safetyprop(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp2_state_id_01caf21d_fk_backend_trigger_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp2
    ADD CONSTRAINT backend_sp2_state_id_01caf21d_fk_backend_trigger_id FOREIGN KEY (state_id) REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp3_conds_sp3_id_f2c1fec5_fk_backend_s; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp3_conds
    ADD CONSTRAINT backend_sp3_conds_sp3_id_f2c1fec5_fk_backend_s FOREIGN KEY (sp3_id) REFERENCES public.backend_sp3(safetyprop_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp3_conds_trigger_id_4aa9489f_fk_backend_trigger_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp3_conds
    ADD CONSTRAINT backend_sp3_conds_trigger_id_4aa9489f_fk_backend_trigger_id FOREIGN KEY (trigger_id) REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp3_event_id_b133fd92_fk_backend_trigger_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp3
    ADD CONSTRAINT backend_sp3_event_id_b133fd92_fk_backend_trigger_id FOREIGN KEY (event_id) REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp3_safetyprop_ptr_id_ac7404ea_fk_backend_safetyprop_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp3
    ADD CONSTRAINT backend_sp3_safetyprop_ptr_id_ac7404ea_fk_backend_safetyprop_id FOREIGN KEY (safetyprop_ptr_id) REFERENCES public.backend_safetyprop(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_ssrule_action_id_6626b087_fk_backend_state_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_ssrule
    ADD CONSTRAINT backend_ssrule_action_id_6626b087_fk_backend_state_id FOREIGN KEY (action_id) REFERENCES public.backend_state(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_ssrule_rule_ptr_id_bb3cd0da_fk_backend_rule_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_ssrule
    ADD CONSTRAINT backend_ssrule_rule_ptr_id_bb3cd0da_fk_backend_rule_id FOREIGN KEY (rule_ptr_id) REFERENCES public.backend_rule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_ssrule_trigg_ssrule_id_c5913b93_fk_backend_s; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_ssrule_triggers
    ADD CONSTRAINT backend_ssrule_trigg_ssrule_id_c5913b93_fk_backend_s FOREIGN KEY (ssrule_id) REFERENCES public.backend_ssrule(rule_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_ssrule_trigg_trigger_id_d0a0f6b6_fk_backend_t; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_ssrule_triggers
    ADD CONSTRAINT backend_ssrule_trigg_trigger_id_d0a0f6b6_fk_backend_t FOREIGN KEY (trigger_id) REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_state_cap_id_25727ebe_fk_backend_capability_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_state
    ADD CONSTRAINT backend_state_cap_id_25727ebe_fk_backend_capability_id FOREIGN KEY (cap_id) REFERENCES public.backend_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_state_chan_id_b9d0a0d4_fk_backend_channel_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_state
    ADD CONSTRAINT backend_state_chan_id_b9d0a0d4_fk_backend_channel_id FOREIGN KEY (chan_id) REFERENCES public.backend_channel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_state_dev_id_a376fae0_fk_backend_device_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_state
    ADD CONSTRAINT backend_state_dev_id_a376fae0_fk_backend_device_id FOREIGN KEY (dev_id) REFERENCES public.backend_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_statelog_cap_id_a554767b_fk_backend_capability_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_statelog
    ADD CONSTRAINT backend_statelog_cap_id_a554767b_fk_backend_capability_id FOREIGN KEY (cap_id) REFERENCES public.backend_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_statelog_dev_id_63f7e345_fk_backend_device_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_statelog
    ADD CONSTRAINT backend_statelog_dev_id_63f7e345_fk_backend_device_id FOREIGN KEY (dev_id) REFERENCES public.backend_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_statelog_param_id_ab9f8aa5_fk_backend_parameter_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_statelog
    ADD CONSTRAINT backend_statelog_param_id_ab9f8aa5_fk_backend_parameter_id FOREIGN KEY (param_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_timeparam_parameter_ptr_id_fc36e993_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_timeparam
    ADD CONSTRAINT backend_timeparam_parameter_ptr_id_fc36e993_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_trigger_cap_id_c28ac690_fk_backend_capability_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_trigger
    ADD CONSTRAINT backend_trigger_cap_id_c28ac690_fk_backend_capability_id FOREIGN KEY (cap_id) REFERENCES public.backend_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_trigger_chan_id_bbc8de39_fk_backend_channel_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_trigger
    ADD CONSTRAINT backend_trigger_chan_id_bbc8de39_fk_backend_channel_id FOREIGN KEY (chan_id) REFERENCES public.backend_channel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_trigger_dev_id_4a2e1853_fk_backend_device_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_trigger
    ADD CONSTRAINT backend_trigger_dev_id_4a2e1853_fk_backend_device_id FOREIGN KEY (dev_id) REFERENCES public.backend_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_userselection_owner_id_0a5b8480_fk_backend_user_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_userselection
    ADD CONSTRAINT backend_userselection_owner_id_0a5b8480_fk_backend_user_id FOREIGN KEY (owner_id) REFERENCES public.backend_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rule_management_devi_abstract_charecteris_a55f6ccb_fk_rule_mana; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.rule_management_devicecharecteristic
    ADD CONSTRAINT rule_management_devi_abstract_charecteris_a55f6ccb_fk_rule_mana FOREIGN KEY (abstract_charecteristic_id) REFERENCES public.rule_management_abstractcharecteristic(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rule_management_devi_device_id_2fc7b33f_fk_rule_mana; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.rule_management_devicecharecteristic
    ADD CONSTRAINT rule_management_devi_device_id_2fc7b33f_fk_rule_mana FOREIGN KEY (device_id) REFERENCES public.rule_management_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rule_management_devi_device_id_d457f89d_fk_rule_mana; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.rule_management_device_users
    ADD CONSTRAINT rule_management_devi_device_id_d457f89d_fk_rule_mana FOREIGN KEY (device_id) REFERENCES public.rule_management_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rule_management_devi_devicecharecteristic_62d7357a_fk_rule_mana; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.rule_management_devicecharecteristic_affected_rules
    ADD CONSTRAINT rule_management_devi_devicecharecteristic_62d7357a_fk_rule_mana FOREIGN KEY (devicecharecteristic_id) REFERENCES public.rule_management_devicecharecteristic(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rule_management_devi_rule_id_07fbc410_fk_rule_mana; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.rule_management_devicecharecteristic_affected_rules
    ADD CONSTRAINT rule_management_devi_rule_id_07fbc410_fk_rule_mana FOREIGN KEY (rule_id) REFERENCES public.rule_management_rule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rule_management_device_users_user_id_71361e1a_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.rule_management_device_users
    ADD CONSTRAINT rule_management_device_users_user_id_71361e1a_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_auth_usermetadata_user_id_26767ead_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.user_auth_usermetadata
    ADD CONSTRAINT user_auth_usermetadata_user_id_26767ead_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

