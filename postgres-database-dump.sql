-- Database: arkiv1

-- DROP DATABASE arkiv1;

CREATE DATABASE arkiv
    WITH 
    OWNER = postgres
    ENCODING = 'WIN1252'
    LC_COLLATE = 'Norwegian_Norway.1252'
    LC_CTYPE = 'Norwegian_Norway.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

-- Table: public.mappe

-- DROP TABLE public.mappe;

CREATE TABLE public.mappe
(
    mappeid integer NOT NULL DEFAULT nextval('mappe_mappeid_seq'::regclass),
    sup_mappeid integer,
    tittel character varying(50) COLLATE pg_catalog."default" NOT NULL,
    offentligtittel character varying(50) COLLATE pg_catalog."default" NOT NULL,
    dokumentmedium character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT mappe_pkey PRIMARY KEY (mappeid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.mappe
    OWNER to postgres;

-- Index: mappe_idx

-- DROP INDEX public.mappe_idx;

CREATE UNIQUE INDEX mappe_idx
    ON public.mappe USING btree
    (mappeid, sup_mappeid)
    TABLESPACE pg_default;

-- Index: mappe_idx_titel

-- DROP INDEX public.mappe_idx_titel;

CREATE UNIQUE INDEX mappe_idx_titel
    ON public.mappe USING btree
    (tittel COLLATE pg_catalog."default")
    TABLESPACE pg_default;
	
-- Table: public.basisregistrering

-- DROP TABLE public.basisregistrering;

CREATE TABLE public.basisregistrering
(
    registreringsid integer NOT NULL DEFAULT nextval('basisregistrering_registreringsid_seq'::regclass),
    mappeid integer NOT NULL,
    registrerings_tittel character varying(50) COLLATE pg_catalog."default",
    dokumenttype character varying(50) COLLATE pg_catalog."default",
    dokumentstatus character varying(50) COLLATE pg_catalog."default",
    dok_tittel character varying(50) COLLATE pg_catalog."default",
    tilknyttetregistreringsom character varying(50) COLLATE pg_catalog."default",
    dokumentnummer integer,
    CONSTRAINT reg_pkey PRIMARY KEY (registreringsid),
    CONSTRAINT basisregistrering_mappeid_fkey FOREIGN KEY (mappeid)
        REFERENCES public.mappe (mappeid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.basisregistrering
    OWNER to postgres;

-- Index: basisregistrering_idx

-- DROP INDEX public.basisregistrering_idx;

CREATE UNIQUE INDEX basisregistrering_idx
    ON public.basisregistrering USING btree
    (registreringsid, mappeid)
    TABLESPACE pg_default;

-- Index: basisregistrering_idxt

-- DROP INDEX public.basisregistrering_idxt;

CREATE UNIQUE INDEX basisregistrering_idxt
    ON public.basisregistrering USING btree
    (dok_tittel COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: basisregistrering_idxt_tit

-- DROP INDEX public.basisregistrering_idxt_tit;

CREATE UNIQUE INDEX basisregistrering_idxt_tit
    ON public.basisregistrering USING btree
    (registrerings_tittel COLLATE pg_catalog."default")
    TABLESPACE pg_default;
    
-- Table: public.dokumentobjekt

-- DROP TABLE public.dokumentobjekt;

CREATE TABLE public.dokumentobjekt
(
    id integer NOT NULL DEFAULT nextval('dokumentobjekt_id_seq'::regclass),
    versjonsnummer integer NOT NULL,
    variantformat character varying(50) COLLATE pg_catalog."default" NOT NULL,
    format character varying(6) COLLATE pg_catalog."default",
    referansedokumentfil character varying(50) COLLATE pg_catalog."default" NOT NULL,
    sjekksum character varying(100) COLLATE pg_catalog."default" NOT NULL,
    sjekksumalgoritme character varying(10) COLLATE pg_catalog."default" NOT NULL,
    filstoerrelse integer NOT NULL,
    registreringsid integer NOT NULL,
    CONSTRAINT dokumentobjekt_pkey PRIMARY KEY (id),
    CONSTRAINT dokumentobjekt_fk_registreringsid_fkey FOREIGN KEY (registreringsid)
        REFERENCES public.basisregistrering (registreringsid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.dokumentobjekt
    OWNER to postgres;

-- Index: dokumentobjekt_idx

-- DROP INDEX public.dokumentobjekt_idx;

CREATE UNIQUE INDEX dokumentobjekt_idx
    ON public.dokumentobjekt USING btree
    (id, registreringsid)
    TABLESPACE pg_default;

-- Index: dokumentobjekt_idxr

-- DROP INDEX public.dokumentobjekt_idxr;

CREATE UNIQUE INDEX dokumentobjekt_idxr
    ON public.dokumentobjekt USING btree
    (referansedokumentfil COLLATE pg_catalog."default")
    TABLESPACE pg_default;