--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: anonymous_contacts; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE anonymous_contacts (
    id integer NOT NULL,
    type character varying(255),
    what_doing text,
    what_wrong text,
    details text,
    source character varying(255),
    page_owner character varying(255),
    user_agent text,
    referrer character varying(2048),
    javascript_enabled boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    personal_information_status character varying(255),
    slug character varying(255),
    service_satisfaction_rating integer,
    user_specified_url text,
    is_actionable boolean DEFAULT true NOT NULL,
    reason_why_not_actionable character varying(255),
    path character varying(2048) NOT NULL,
    content_item_id integer,
    marked_as_spam boolean DEFAULT false NOT NULL,
    reviewed boolean DEFAULT false NOT NULL
);


--
-- Name: anonymous_contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE anonymous_contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: anonymous_contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE anonymous_contacts_id_seq OWNED BY anonymous_contacts.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: archived_service_feedbacks; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE archived_service_feedbacks (
    id integer NOT NULL,
    type character varying,
    slug character varying,
    service_satisfaction_rating integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: archived_service_feedbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE archived_service_feedbacks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: archived_service_feedbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE archived_service_feedbacks_id_seq OWNED BY archived_service_feedbacks.id;


--
-- Name: content_items; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE content_items (
    id integer NOT NULL,
    path character varying(2048) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    document_type character varying
);


--
-- Name: content_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE content_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: content_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE content_items_id_seq OWNED BY content_items.id;


--
-- Name: content_improvement_feedbacks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE content_improvement_feedbacks (
id bigint NOT NULL,
description character varying NOT NULL,
reviewed boolean DEFAULT false NOT NULL,
marked_as_spam boolean DEFAULT false NOT NULL,
personal_information_status character varying
);


--
-- Name: content_improvement_feedbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE content_improvement_feedbacks_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: content_improvement_feedbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE content_improvement_feedbacks_id_seq OWNED BY content_improvement_feedbacks.id;


--
-- Name: content_improvement_feedbacks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY content_improvement_feedbacks ALTER COLUMN id SET DEFAULT nextval('content_improvement_feedbacks_id_seq'::regclass);

--
-- Name: content_improvement_feedbacks content_improvement_feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY content_improvement_feedbacks
ADD CONSTRAINT content_improvement_feedbacks_pkey PRIMARY KEY (id);

--
-- Name: content_items_organisations; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE content_items_organisations (
    content_item_id integer,
    organisation_id integer
);


--
-- Name: feedback_export_requests; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE feedback_export_requests (
    id integer NOT NULL,
    notification_email character varying(255),
    filename character varying(255),
    generated_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    filters text
);


--
-- Name: feedback_export_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE feedback_export_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feedback_export_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE feedback_export_requests_id_seq OWNED BY feedback_export_requests.id;


--
-- Name: organisations; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE organisations (
    id integer NOT NULL,
    slug character varying(255) NOT NULL,
    web_url character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    acronym character varying(255),
    govuk_status character varying(255),
    content_id character varying(255) NOT NULL
);


--
-- Name: organisations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organisations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organisations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organisations_id_seq OWNED BY organisations.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE users (
    id bigint NOT NULL,
    name character varying,
    email character varying,
    uid character varying,
    organisation_slug character varying,
    organisation_content_id character varying,
    permissions character varying[] DEFAULT '{}'::character varying[],
    remotely_signed_out boolean DEFAULT false,
    disabled boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--

ALTER TABLE ONLY anonymous_contacts ALTER COLUMN id SET DEFAULT nextval('anonymous_contacts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY archived_service_feedbacks ALTER COLUMN id SET DEFAULT nextval('archived_service_feedbacks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY content_items ALTER COLUMN id SET DEFAULT nextval('content_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY feedback_export_requests ALTER COLUMN id SET DEFAULT nextval('feedback_export_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organisations ALTER COLUMN id SET DEFAULT nextval('organisations_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: anonymous_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY anonymous_contacts
    ADD CONSTRAINT anonymous_contacts_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: archived_service_feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY archived_service_feedbacks
    ADD CONSTRAINT archived_service_feedbacks_pkey PRIMARY KEY (id);


--
-- Name: content_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY content_items
    ADD CONSTRAINT content_items_pkey PRIMARY KEY (id);


--
-- Name: feedback_export_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY feedback_export_requests
    ADD CONSTRAINT feedback_export_requests_pkey PRIMARY KEY (id);


--
-- Name: organisations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY organisations
    ADD CONSTRAINT organisations_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_anonymous_contacts_on_content_item_id_and_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_anonymous_contacts_on_content_item_id_and_created_at ON anonymous_contacts USING btree (content_item_id, created_at);


--
-- Name: index_anonymous_contacts_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_anonymous_contacts_on_created_at ON anonymous_contacts USING btree (created_at);


--
-- Name: index_anonymous_contacts_on_created_at_and_path; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_anonymous_contacts_on_created_at_and_path ON anonymous_contacts USING btree (created_at DESC, path varchar_pattern_ops);


--
-- Name: index_anonymous_contacts_on_path; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_anonymous_contacts_on_path ON anonymous_contacts USING btree (path varchar_pattern_ops);


--
-- Name: index_content_items_on_document_type; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_content_items_on_document_type ON content_items USING btree (document_type);


--
-- Name: index_content_items_organisations_on_organisation_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_content_items_organisations_on_organisation_id ON content_items_organisations USING btree (organisation_id);


--
-- Name: index_content_items_organisations_unique; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_content_items_organisations_unique ON content_items_organisations USING btree (content_item_id, organisation_id);


--
-- Name: index_organisations_on_content_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_organisations_on_content_id ON organisations USING btree (content_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO "schema_migrations" (version) VALUES
('20140728110134'),
('20141002153042'),
('20141002165103'),
('20141230121133'),
('20150115215320'),
('20150313183713'),
('20150430133750'),
('20150505100000'),
('20150505162618'),
('20150513094727'),
('20150515222831'),
('20150518151221'),
('20150521102732'),
('20150521140644'),
('20150521144116'),
('20150522151256'),
('20150526095541'),
('20150604140707'),
('20150611133227'),
('20150612130729'),
('20150623151655'),
('20150915134640'),
('20151202212408'),
('20151203001139'),
('20160511164547'),
('20160822145924'),
('20160826105129'),
('20171204124407'),
('20171204155340'),
('20180108153838'),
('20180906145408'),
('20181231135850'),
('20190130105818');
