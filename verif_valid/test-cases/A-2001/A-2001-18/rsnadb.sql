PGDMP     
    -                u           rsnadb    8.4.22    8.4.22 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     )   SET standard_conforming_strings = 'off';
                       false            �           1262    16386    rsnadb    DATABASE     x   CREATE DATABASE rsnadb WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
    DROP DATABASE rsnadb;
             edge    false            �           1262    16386    rsnadb    COMMENT     u  COMMENT ON DATABASE rsnadb IS 'RSNA Edge Device Database
Authors: Wendy Zhu (Univ of Chicago) and Steve G Langer (Mayo Clinic)

Copyright (c) 2010, Radiological Society of North America
  All rights reserved.
  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
  Neither the name of the RSNA nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
  CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
  PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
  USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
  USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
  OF SUCH DAMAGE.';
                  edge    false    2037                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    6            �           0    0    public    ACL     �   REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
                  postgres    false    6            ;           2612    16389    plpgsql    PROCEDURAL LANGUAGE     $   CREATE PROCEDURAL LANGUAGE plpgsql;
 "   DROP PROCEDURAL LANGUAGE plpgsql;
             postgres    false            �            1259    16390    configurations    TABLE     �   CREATE TABLE configurations (
    key character varying NOT NULL,
    value character varying NOT NULL,
    modified_date timestamp with time zone DEFAULT now()
);
 "   DROP TABLE public.configurations;
       public         edge    false    1907    6            �           0    0    TABLE configurations    COMMENT     �  COMMENT ON TABLE configurations IS 'This table is used to store applications specific config data as key/value pairs and takes the place of java properties files (rather then having it all aly about in plain text files);

a) paths to key things (ie dicom studies)
b) site prefix for generating RSNA ID''s
c) site delay for applying to report finalize before available to send to CH
d) Clearing House connection data
e) etc';
            public       edge    false    140            �            1259    16397    devices    TABLE     �   CREATE TABLE devices (
    device_id integer NOT NULL,
    ae_title character varying(256) NOT NULL,
    host character varying(256) NOT NULL,
    port_number character varying(10) NOT NULL,
    modified_date timestamp with time zone DEFAULT now()
);
    DROP TABLE public.devices;
       public         edge    false    1908    6            �           0    0    TABLE devices    COMMENT     �   COMMENT ON TABLE devices IS 'Used to store DICOM connection info for mage sources, and possibly others

a) the DICOM triplet (for remote DICOM study sources)
b) ?

';
            public       edge    false    141            �            1259    16404    devices_device_id_seq    SEQUENCE     w   CREATE SEQUENCE devices_device_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.devices_device_id_seq;
       public       edge    false    141    6            �           0    0    devices_device_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE devices_device_id_seq OWNED BY devices.device_id;
            public       edge    false    142            �           0    0    devices_device_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('devices_device_id_seq', 1, true);
            public       edge    false    142            �            1259    16406    email_configurations    TABLE     �   CREATE TABLE email_configurations (
    key character varying NOT NULL,
    value character varying NOT NULL,
    modified_date timestamp with time zone DEFAULT now()
);
 (   DROP TABLE public.email_configurations;
       public         edge    false    1910    6            �           0    0    TABLE email_configurations    COMMENT     o   COMMENT ON TABLE email_configurations IS 'This table is used to store email configuration as key/value pairs';
            public       edge    false    143            �            1259    16413 
   email_jobs    TABLE     y  CREATE TABLE email_jobs (
    email_job_id integer NOT NULL,
    recipient character varying NOT NULL,
    subject character varying,
    body text,
    sent boolean DEFAULT false NOT NULL,
    failed boolean DEFAULT false NOT NULL,
    comments character varying,
    created_date timestamp with time zone NOT NULL,
    modified_date timestamp with time zone DEFAULT now()
);
    DROP TABLE public.email_jobs;
       public         edge    false    1911    1912    1913    6            �           0    0    TABLE email_jobs    COMMENT     �   COMMENT ON TABLE email_jobs IS 'This table is used to store queued emails. Jobs within the queue will be handled by a worker thread which is responsible for handling any send failures and retrying failed jobs';
            public       edge    false    144            �            1259    16422    email_jobs_email_job_id_seq    SEQUENCE     }   CREATE SEQUENCE email_jobs_email_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
 2   DROP SEQUENCE public.email_jobs_email_job_id_seq;
       public       edge    false    144    6            �           0    0    email_jobs_email_job_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE email_jobs_email_job_id_seq OWNED BY email_jobs.email_job_id;
            public       edge    false    145                        0    0    email_jobs_email_job_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('email_jobs_email_job_id_seq', 1, false);
            public       edge    false    145            �            1259    16424    exams    TABLE     �   CREATE TABLE exams (
    exam_id integer NOT NULL,
    accession_number character varying(50) NOT NULL,
    patient_id integer NOT NULL,
    exam_description character varying(256),
    modified_date timestamp with time zone DEFAULT now()
);
    DROP TABLE public.exams;
       public         edge    false    1915    6                       0    0    TABLE exams    COMMENT        COMMENT ON TABLE exams IS 'A listing of all ordered DICOM exams the system knows about. The report status is not stored here';
            public       edge    false    146            �            1259    16428    exams_exam_id_seq    SEQUENCE     s   CREATE SEQUENCE exams_exam_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
 (   DROP SEQUENCE public.exams_exam_id_seq;
       public       edge    false    6    146                       0    0    exams_exam_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE exams_exam_id_seq OWNED BY exams.exam_id;
            public       edge    false    147                       0    0    exams_exam_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('exams_exam_id_seq', 107, true);
            public       edge    false    147            �            1259    16430    hipaa_audit_accession_numbers    TABLE     �   CREATE TABLE hipaa_audit_accession_numbers (
    id integer NOT NULL,
    view_id integer,
    accession_number character varying(100),
    modified_date timestamp with time zone DEFAULT now()
);
 1   DROP TABLE public.hipaa_audit_accession_numbers;
       public         edge    false    1917    6                       0    0 #   TABLE hipaa_audit_accession_numbers    COMMENT     �   COMMENT ON TABLE hipaa_audit_accession_numbers IS 'Part of the HIPAA tracking for edge device auditing. This table and  "audit_mrns" report up to table HIPAA_views
';
            public       edge    false    148            �            1259    16434 $   hipaa_audit_accession_numbers_id_seq    SEQUENCE     �   CREATE SEQUENCE hipaa_audit_accession_numbers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
 ;   DROP SEQUENCE public.hipaa_audit_accession_numbers_id_seq;
       public       edge    false    6    148                       0    0 $   hipaa_audit_accession_numbers_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE hipaa_audit_accession_numbers_id_seq OWNED BY hipaa_audit_accession_numbers.id;
            public       edge    false    149                       0    0 $   hipaa_audit_accession_numbers_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('hipaa_audit_accession_numbers_id_seq', 388, true);
            public       edge    false    149            �            1259    16436    hipaa_audit_mrns    TABLE     �   CREATE TABLE hipaa_audit_mrns (
    id integer NOT NULL,
    view_id integer,
    mrn character varying(100),
    modified_date timestamp with time zone DEFAULT now()
);
 $   DROP TABLE public.hipaa_audit_mrns;
       public         edge    false    1919    6                       0    0    TABLE hipaa_audit_mrns    COMMENT     �   COMMENT ON TABLE hipaa_audit_mrns IS 'Part of the HIPAA tracking for edge device auditing. This table and  "audit_acessions" report up to table HIPAA_views
';
            public       edge    false    150            �            1259    16440    hipaa_audit_mrns_id_seq    SEQUENCE     y   CREATE SEQUENCE hipaa_audit_mrns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
 .   DROP SEQUENCE public.hipaa_audit_mrns_id_seq;
       public       edge    false    150    6                       0    0    hipaa_audit_mrns_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE hipaa_audit_mrns_id_seq OWNED BY hipaa_audit_mrns.id;
            public       edge    false    151            	           0    0    hipaa_audit_mrns_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('hipaa_audit_mrns_id_seq', 2220, true);
            public       edge    false    151            �            1259    16442    hipaa_audit_views    TABLE     �   CREATE TABLE hipaa_audit_views (
    id integer NOT NULL,
    requesting_ip character varying(15),
    requesting_username character varying(100),
    requesting_uri text,
    modified_date timestamp with time zone DEFAULT now()
);
 %   DROP TABLE public.hipaa_audit_views;
       public         edge    false    1921    6            
           0    0    TABLE hipaa_audit_views    COMMENT     �   COMMENT ON TABLE hipaa_audit_views IS 'Part of the HIPAA tracking for edge device auditing. This is the top level table that tracks who asked for what from where. The HIPAA tables "audfit_accession" and "audit_mrns" report up to this table';
            public       edge    false    152            �            1259    16449    hipaa_audit_views_id_seq    SEQUENCE     z   CREATE SEQUENCE hipaa_audit_views_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
 /   DROP SEQUENCE public.hipaa_audit_views_id_seq;
       public       edge    false    6    152                       0    0    hipaa_audit_views_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE hipaa_audit_views_id_seq OWNED BY hipaa_audit_views.id;
            public       edge    false    153                       0    0    hipaa_audit_views_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('hipaa_audit_views_id_seq', 1663, true);
            public       edge    false    153            �            1259    16451    job_sets    TABLE     �  CREATE TABLE job_sets (
    job_set_id integer NOT NULL,
    patient_id integer NOT NULL,
    user_id integer NOT NULL,
    email_address character varying(255),
    modified_date timestamp with time zone DEFAULT now(),
    delay_in_hrs integer DEFAULT 72,
    single_use_patient_id character varying(64) NOT NULL,
    send_on_complete boolean DEFAULT false NOT NULL,
    access_code character varying(64),
    send_to_site boolean DEFAULT false NOT NULL
);
    DROP TABLE public.job_sets;
       public         edge    false    1923    1924    1925    1926    6                       0    0    TABLE job_sets    COMMENT     �   COMMENT ON TABLE job_sets IS 'This is one of a pair of tables that bind a patient to a edge device job, consisting of one or more exam accessions descrbing DICOM exams to send to the CH. The other table is JOBS
';
            public       edge    false    154            �            1259    16458    job_sets_job_set_id_seq    SEQUENCE     y   CREATE SEQUENCE job_sets_job_set_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
 .   DROP SEQUENCE public.job_sets_job_set_id_seq;
       public       edge    false    154    6                       0    0    job_sets_job_set_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE job_sets_job_set_id_seq OWNED BY job_sets.job_set_id;
            public       edge    false    155                       0    0    job_sets_job_set_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('job_sets_job_set_id_seq', 112, true);
            public       edge    false    155            �            1259    16460    jobs    TABLE       CREATE TABLE jobs (
    job_id integer NOT NULL,
    job_set_id integer NOT NULL,
    exam_id integer NOT NULL,
    report_id integer,
    document_id character varying(100),
    remaining_retries integer NOT NULL,
    modified_date timestamp with time zone DEFAULT now()
);
    DROP TABLE public.jobs;
       public         edge    false    1928    6                       0    0 
   TABLE jobs    COMMENT     �   COMMENT ON TABLE jobs IS 'This is one of a pair of tables that bind a patient to a edge device job, consisting of one or more exam accessions descrbing DICOM exams to send to the CH. The other table is JOB_SETS
';
            public       edge    false    156            �            1259    16464    jobs_job_id_seq    SEQUENCE     q   CREATE SEQUENCE jobs_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
 &   DROP SEQUENCE public.jobs_job_id_seq;
       public       edge    false    156    6                       0    0    jobs_job_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE jobs_job_id_seq OWNED BY jobs.job_id;
            public       edge    false    157                       0    0    jobs_job_id_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('jobs_job_id_seq', 114, true);
            public       edge    false    157            �            1259    16466    patient_merge_events    TABLE     H  CREATE TABLE patient_merge_events (
    event_id integer NOT NULL,
    old_mrn character varying(50) NOT NULL,
    new_mrn character varying(50) NOT NULL,
    old_patient_id integer NOT NULL,
    new_patient_id integer NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    modified_date timestamp with time zone DEFAULT now()
);
 (   DROP TABLE public.patient_merge_events;
       public         edge    false    1930    1931    6                       0    0    TABLE patient_merge_events    COMMENT     �   COMMENT ON TABLE patient_merge_events IS 'When it''s required to swap a patient to a new ID (say a john doe) this tracks the old and new MRN for rollback/auditing
';
            public       edge    false    158            �            1259    16471 !   patient_merge_events_event_id_seq    SEQUENCE     �   CREATE SEQUENCE patient_merge_events_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
 8   DROP SEQUENCE public.patient_merge_events_event_id_seq;
       public       edge    false    6    158                       0    0 !   patient_merge_events_event_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE patient_merge_events_event_id_seq OWNED BY patient_merge_events.event_id;
            public       edge    false    159                       0    0 !   patient_merge_events_event_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('patient_merge_events_event_id_seq', 1, false);
            public       edge    false    159            �            1259    16473    patients    TABLE     �  CREATE TABLE patients (
    patient_id integer NOT NULL,
    mrn character varying(50) NOT NULL,
    patient_name character varying,
    dob date,
    sex character(1),
    street character varying,
    city character varying(50),
    state character varying(30),
    zip_code character varying(30),
    email_address character varying(255),
    rsna_id character varying(64),
    modified_date timestamp with time zone DEFAULT now(),
    consent_timestamp timestamp with time zone
);
    DROP TABLE public.patients;
       public         edge    false    1933    6                       0    0    TABLE patients    COMMENT     [   COMMENT ON TABLE patients IS 'a list of all patient demog sent via the HL7 MIRTH channel';
            public       edge    false    160                       0    0    COLUMN patients.patient_id    COMMENT     O   COMMENT ON COLUMN patients.patient_id IS 'just the dbase created primary key';
            public       edge    false    160                       0    0    COLUMN patients.mrn    COMMENT     ^   COMMENT ON COLUMN patients.mrn IS 'the actual medical recrod number from the medical center';
            public       edge    false    160            �            1259    16480    patients_patient_id_seq    SEQUENCE     y   CREATE SEQUENCE patients_patient_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
 .   DROP SEQUENCE public.patients_patient_id_seq;
       public       edge    false    6    160                       0    0    patients_patient_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE patients_patient_id_seq OWNED BY patients.patient_id;
            public       edge    false    161                       0    0    patients_patient_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('patients_patient_id_seq', 95, true);
            public       edge    false    161            �            1259    16482    reports    TABLE     �  CREATE TABLE reports (
    report_id integer NOT NULL,
    exam_id integer NOT NULL,
    proc_code character varying,
    status character varying NOT NULL,
    status_timestamp timestamp with time zone NOT NULL,
    report_text text,
    signer character varying,
    dictator character varying,
    transcriber character varying,
    modified_date timestamp with time zone DEFAULT now()
);
    DROP TABLE public.reports;
       public         edge    false    1935    6                       0    0    TABLE reports    COMMENT     �   COMMENT ON TABLE reports IS 'This table contains exam report and exam status as sent from teh MIRTH HL7 channel. Combined with the Exams table, this provides all info needed to determine exam staus and location to create a job to send to the CH';
            public       edge    false    162            �            1259    16489    reports_report_id_seq    SEQUENCE     w   CREATE SEQUENCE reports_report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.reports_report_id_seq;
       public       edge    false    162    6                       0    0    reports_report_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE reports_report_id_seq OWNED BY reports.report_id;
            public       edge    false    163                       0    0    reports_report_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('reports_report_id_seq', 198, true);
            public       edge    false    163            �            1259    16491    roles    TABLE     �   CREATE TABLE roles (
    role_id integer NOT NULL,
    role_description character varying(50) NOT NULL,
    modified_date time with time zone DEFAULT now()
);
    DROP TABLE public.roles;
       public         edge    false    1937    6                       0    0    TABLE roles    COMMENT     a   COMMENT ON TABLE roles IS 'Combined with table Users, this table defines a user''s privelages
';
            public       edge    false    164            �            1259    16495    schema_version    TABLE     �   CREATE TABLE schema_version (
    id integer NOT NULL,
    version character varying,
    modified_date timestamp with time zone DEFAULT now()
);
 "   DROP TABLE public.schema_version;
       public         edge    false    1938    6                       0    0    TABLE schema_version    COMMENT     D   COMMENT ON TABLE schema_version IS 'Store database schema version';
            public       edge    false    165            �            1259    16502    schema_version_id_seq    SEQUENCE     w   CREATE SEQUENCE schema_version_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.schema_version_id_seq;
       public       edge    false    6    165                        0    0    schema_version_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE schema_version_id_seq OWNED BY schema_version.id;
            public       edge    false    166            !           0    0    schema_version_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('schema_version_id_seq', 1, false);
            public       edge    false    166            �            1259    16504    status_codes    TABLE     �   CREATE TABLE status_codes (
    status_code integer NOT NULL,
    description character varying(255),
    modified_date timestamp with time zone DEFAULT now()
);
     DROP TABLE public.status_codes;
       public         edge    false    1940    6            "           0    0    TABLE status_codes    COMMENT     �   COMMENT ON TABLE status_codes IS 'Maps a job status number to a human readable format.

Values in the 20s are owned by the COntent-prep app

Values in the 30s are owned by the Content-send app';
            public       edge    false    167            �            1259    16508    studies    TABLE       CREATE TABLE studies (
    study_id integer NOT NULL,
    study_uid character varying(255) NOT NULL,
    exam_id integer NOT NULL,
    study_description character varying(255),
    study_date timestamp without time zone,
    modified_date timestamp with time zone DEFAULT now()
);
    DROP TABLE public.studies;
       public         edge    false    1941    6            #           0    0    TABLE studies    COMMENT     [   COMMENT ON TABLE studies IS 'DICOM uid info for exams listed by accession in table Exams';
            public       edge    false    168            �            1259    16515    studies_study_id_seq    SEQUENCE     v   CREATE SEQUENCE studies_study_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
 +   DROP SEQUENCE public.studies_study_id_seq;
       public       edge    false    6    168            $           0    0    studies_study_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE studies_study_id_seq OWNED BY studies.study_id;
            public       edge    false    169            %           0    0    studies_study_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('studies_study_id_seq', 236, true);
            public       edge    false    169            �            1259    16517    transactions    TABLE     �   CREATE TABLE transactions (
    transaction_id integer NOT NULL,
    job_id integer NOT NULL,
    status_code integer NOT NULL,
    comments character varying,
    modified_date timestamp with time zone DEFAULT now()
);
     DROP TABLE public.transactions;
       public         edge    false    1943    6            &           0    0    TABLE transactions    COMMENT     �   COMMENT ON TABLE transactions IS 'status logging/auditing for jobs defined in table Jobs. The java apps come here to determine their work by looking at the value status';
            public       edge    false    170            '           0    0    COLUMN transactions.status_code    COMMENT       COMMENT ON COLUMN transactions.status_code IS 'WHen a job is created by the GUI Token app, the row is created with value 1

Prepare Content looks for value of one and promites status to 2 on exit

Content transfer looks for status 2 and promotes to 3 on exit

 ';
            public       edge    false    170            �            1259    16524    transactions_transaction_id_seq    SEQUENCE     �   CREATE SEQUENCE transactions_transaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
 6   DROP SEQUENCE public.transactions_transaction_id_seq;
       public       edge    false    6    170            (           0    0    transactions_transaction_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE transactions_transaction_id_seq OWNED BY transactions.transaction_id;
            public       edge    false    171            )           0    0    transactions_transaction_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('transactions_transaction_id_seq', 16078, true);
            public       edge    false    171            �            1259    16526    users    TABLE     �  CREATE TABLE users (
    user_id integer NOT NULL,
    user_login character varying(40) DEFAULT NULL::character varying,
    user_name character varying(100) DEFAULT ''::character varying,
    email character varying(100) DEFAULT NULL::character varying,
    crypted_password character varying(40) DEFAULT NULL::character varying,
    salt character varying(40) DEFAULT NULL::character varying,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    remember_token character varying(40) DEFAULT NULL::character varying,
    remember_token_expires_at timestamp with time zone,
    role_id integer NOT NULL,
    modified_date timestamp with time zone DEFAULT now(),
    active boolean DEFAULT true
);
    DROP TABLE public.users;
       public         edge    false    1945    1946    1947    1948    1949    1950    1951    1952    6            *           0    0    TABLE users    COMMENT     y   COMMENT ON TABLE users IS 'Combined with table Roles, this table defines who can do what on the Edge appliacne Web GUI';
            public       edge    false    172            �            1259    16537    users_user_id_seq    SEQUENCE     s   CREATE SEQUENCE users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
 (   DROP SEQUENCE public.users_user_id_seq;
       public       edge    false    6    172            +           0    0    users_user_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE users_user_id_seq OWNED BY users.user_id;
            public       edge    false    173            ,           0    0    users_user_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('users_user_id_seq', 10, true);
            public       edge    false    173            �            1259    16549    v_consented    VIEW     Z  CREATE VIEW v_consented AS
    SELECT patients.patient_id, patients.mrn, patients.patient_name, patients.dob, patients.sex, patients.street, patients.city, patients.state, patients.zip_code, patients.email_address, patients.rsna_id, patients.modified_date, patients.consent_timestamp FROM patients WHERE (patients.consent_timestamp IS NOT NULL);
    DROP VIEW public.v_consented;
       public       edge    false    1713    6            �            1259    16539    v_exam_status    VIEW     �  CREATE VIEW v_exam_status AS
    SELECT p.patient_id, p.mrn, p.patient_name, p.dob, p.sex, p.street, p.city, p.state, p.zip_code, p.email_address, e.exam_id, e.accession_number, e.exam_description, r.report_id, r.status, r.status_timestamp, r.report_text, r.dictator, r.transcriber, r.signer FROM ((patients p JOIN exams e ON ((p.patient_id = e.patient_id))) JOIN (SELECT r1.report_id, r1.exam_id, r1.proc_code, r1.status, r1.status_timestamp, r1.report_text, r1.signer, r1.dictator, r1.transcriber, r1.modified_date FROM reports r1 WHERE (r1.report_id = (SELECT r2.report_id FROM reports r2 WHERE (r2.exam_id = r1.exam_id) ORDER BY r2.status_timestamp DESC, r2.modified_date DESC LIMIT 1))) r ON ((e.exam_id = r.exam_id)));
     DROP VIEW public.v_exam_status;
       public       edge    false    1711    6            �            1259    16553    v_exams_sent    VIEW     �   CREATE VIEW v_exams_sent AS
    SELECT transactions.transaction_id, transactions.job_id, transactions.status_code, transactions.comments, transactions.modified_date FROM transactions WHERE (transactions.status_code = 40);
    DROP VIEW public.v_exams_sent;
       public       edge    false    1714    6            �            1259    16544    v_job_status    VIEW     �  CREATE VIEW v_job_status AS
    SELECT js.job_set_id, j.job_id, j.exam_id, js.delay_in_hrs, t.status, t.status_message, t.modified_date AS last_transaction_timestamp, js.single_use_patient_id, js.email_address, t.comments, js.send_on_complete, j.remaining_retries, js.send_to_site FROM ((jobs j JOIN job_sets js ON ((j.job_set_id = js.job_set_id))) JOIN (SELECT t1.job_id, t1.status_code AS status, sc.description AS status_message, t1.comments, t1.modified_date FROM (transactions t1 JOIN status_codes sc ON ((t1.status_code = sc.status_code))) WHERE (t1.modified_date = (SELECT max(t2.modified_date) AS max FROM transactions t2 WHERE (t2.job_id = t1.job_id)))) t ON ((j.job_id = t.job_id)));
    DROP VIEW public.v_job_status;
       public       edge    false    1712    6            �            1259    16557    v_patients_sent    VIEW     �   CREATE VIEW v_patients_sent AS
    SELECT DISTINCT job_sets.patient_id FROM transactions, jobs, job_sets WHERE (((transactions.status_code = 40) AND (transactions.job_id = jobs.job_id)) AND (jobs.job_set_id = job_sets.job_set_id));
 "   DROP VIEW public.v_patients_sent;
       public       edge    false    1715    6            u           2604    16561 	   device_id    DEFAULT     h   ALTER TABLE ONLY devices ALTER COLUMN device_id SET DEFAULT nextval('devices_device_id_seq'::regclass);
 @   ALTER TABLE public.devices ALTER COLUMN device_id DROP DEFAULT;
       public       edge    false    142    141            z           2604    16562    email_job_id    DEFAULT     t   ALTER TABLE ONLY email_jobs ALTER COLUMN email_job_id SET DEFAULT nextval('email_jobs_email_job_id_seq'::regclass);
 F   ALTER TABLE public.email_jobs ALTER COLUMN email_job_id DROP DEFAULT;
       public       edge    false    145    144            |           2604    16563    exam_id    DEFAULT     `   ALTER TABLE ONLY exams ALTER COLUMN exam_id SET DEFAULT nextval('exams_exam_id_seq'::regclass);
 <   ALTER TABLE public.exams ALTER COLUMN exam_id DROP DEFAULT;
       public       edge    false    147    146            ~           2604    16564    id    DEFAULT     �   ALTER TABLE ONLY hipaa_audit_accession_numbers ALTER COLUMN id SET DEFAULT nextval('hipaa_audit_accession_numbers_id_seq'::regclass);
 O   ALTER TABLE public.hipaa_audit_accession_numbers ALTER COLUMN id DROP DEFAULT;
       public       edge    false    149    148            �           2604    16565    id    DEFAULT     l   ALTER TABLE ONLY hipaa_audit_mrns ALTER COLUMN id SET DEFAULT nextval('hipaa_audit_mrns_id_seq'::regclass);
 B   ALTER TABLE public.hipaa_audit_mrns ALTER COLUMN id DROP DEFAULT;
       public       edge    false    151    150            �           2604    16566    id    DEFAULT     n   ALTER TABLE ONLY hipaa_audit_views ALTER COLUMN id SET DEFAULT nextval('hipaa_audit_views_id_seq'::regclass);
 C   ALTER TABLE public.hipaa_audit_views ALTER COLUMN id DROP DEFAULT;
       public       edge    false    153    152            �           2604    16567 
   job_set_id    DEFAULT     l   ALTER TABLE ONLY job_sets ALTER COLUMN job_set_id SET DEFAULT nextval('job_sets_job_set_id_seq'::regclass);
 B   ALTER TABLE public.job_sets ALTER COLUMN job_set_id DROP DEFAULT;
       public       edge    false    155    154            �           2604    16568    job_id    DEFAULT     \   ALTER TABLE ONLY jobs ALTER COLUMN job_id SET DEFAULT nextval('jobs_job_id_seq'::regclass);
 :   ALTER TABLE public.jobs ALTER COLUMN job_id DROP DEFAULT;
       public       edge    false    157    156            �           2604    16569    event_id    DEFAULT     �   ALTER TABLE ONLY patient_merge_events ALTER COLUMN event_id SET DEFAULT nextval('patient_merge_events_event_id_seq'::regclass);
 L   ALTER TABLE public.patient_merge_events ALTER COLUMN event_id DROP DEFAULT;
       public       edge    false    159    158            �           2604    16570 
   patient_id    DEFAULT     l   ALTER TABLE ONLY patients ALTER COLUMN patient_id SET DEFAULT nextval('patients_patient_id_seq'::regclass);
 B   ALTER TABLE public.patients ALTER COLUMN patient_id DROP DEFAULT;
       public       edge    false    161    160            �           2604    16571 	   report_id    DEFAULT     h   ALTER TABLE ONLY reports ALTER COLUMN report_id SET DEFAULT nextval('reports_report_id_seq'::regclass);
 @   ALTER TABLE public.reports ALTER COLUMN report_id DROP DEFAULT;
       public       edge    false    163    162            �           2604    16572    id    DEFAULT     h   ALTER TABLE ONLY schema_version ALTER COLUMN id SET DEFAULT nextval('schema_version_id_seq'::regclass);
 @   ALTER TABLE public.schema_version ALTER COLUMN id DROP DEFAULT;
       public       edge    false    166    165            �           2604    16573    study_id    DEFAULT     f   ALTER TABLE ONLY studies ALTER COLUMN study_id SET DEFAULT nextval('studies_study_id_seq'::regclass);
 ?   ALTER TABLE public.studies ALTER COLUMN study_id DROP DEFAULT;
       public       edge    false    169    168            �           2604    16574    transaction_id    DEFAULT     |   ALTER TABLE ONLY transactions ALTER COLUMN transaction_id SET DEFAULT nextval('transactions_transaction_id_seq'::regclass);
 J   ALTER TABLE public.transactions ALTER COLUMN transaction_id DROP DEFAULT;
       public       edge    false    171    170            �           2604    16575    user_id    DEFAULT     `   ALTER TABLE ONLY users ALTER COLUMN user_id SET DEFAULT nextval('users_user_id_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
       public       edge    false    173    172            �          0    16390    configurations 
   TABLE DATA               <   COPY configurations (key, value, modified_date) FROM stdin;
    public       edge    false    140   �       �          0    16397    devices 
   TABLE DATA               Q   COPY devices (device_id, ae_title, host, port_number, modified_date) FROM stdin;
    public       edge    false    141   ��       �          0    16406    email_configurations 
   TABLE DATA               B   COPY email_configurations (key, value, modified_date) FROM stdin;
    public       edge    false    143   ��       �          0    16413 
   email_jobs 
   TABLE DATA               z   COPY email_jobs (email_job_id, recipient, subject, body, sent, failed, comments, created_date, modified_date) FROM stdin;
    public       edge    false    144   ��       �          0    16424    exams 
   TABLE DATA               `   COPY exams (exam_id, accession_number, patient_id, exam_description, modified_date) FROM stdin;
    public       edge    false    146   ��       �          0    16430    hipaa_audit_accession_numbers 
   TABLE DATA               ^   COPY hipaa_audit_accession_numbers (id, view_id, accession_number, modified_date) FROM stdin;
    public       edge    false    148   z�       �          0    16436    hipaa_audit_mrns 
   TABLE DATA               D   COPY hipaa_audit_mrns (id, view_id, mrn, modified_date) FROM stdin;
    public       edge    false    150   ��       �          0    16442    hipaa_audit_views 
   TABLE DATA               k   COPY hipaa_audit_views (id, requesting_ip, requesting_username, requesting_uri, modified_date) FROM stdin;
    public       edge    false    152   ��       �          0    16451    job_sets 
   TABLE DATA               �   COPY job_sets (job_set_id, patient_id, user_id, email_address, modified_date, delay_in_hrs, single_use_patient_id, send_on_complete, access_code, send_to_site) FROM stdin;
    public       edge    false    154   �       �          0    16460    jobs 
   TABLE DATA               n   COPY jobs (job_id, job_set_id, exam_id, report_id, document_id, remaining_retries, modified_date) FROM stdin;
    public       edge    false    156   :�       �          0    16466    patient_merge_events 
   TABLE DATA               z   COPY patient_merge_events (event_id, old_mrn, new_mrn, old_patient_id, new_patient_id, status, modified_date) FROM stdin;
    public       edge    false    158   W�       �          0    16473    patients 
   TABLE DATA               �   COPY patients (patient_id, mrn, patient_name, dob, sex, street, city, state, zip_code, email_address, rsna_id, modified_date, consent_timestamp) FROM stdin;
    public       edge    false    160   t�       �          0    16482    reports 
   TABLE DATA               �   COPY reports (report_id, exam_id, proc_code, status, status_timestamp, report_text, signer, dictator, transcriber, modified_date) FROM stdin;
    public       edge    false    162   ��       �          0    16491    roles 
   TABLE DATA               B   COPY roles (role_id, role_description, modified_date) FROM stdin;
    public       edge    false    164   ��       �          0    16495    schema_version 
   TABLE DATA               =   COPY schema_version (id, version, modified_date) FROM stdin;
    public       edge    false    165   ��       �          0    16504    status_codes 
   TABLE DATA               H   COPY status_codes (status_code, description, modified_date) FROM stdin;
    public       edge    false    167   ��       �          0    16508    studies 
   TABLE DATA               f   COPY studies (study_id, study_uid, exam_id, study_description, study_date, modified_date) FROM stdin;
    public       edge    false    168   ��       �          0    16517    transactions 
   TABLE DATA               ]   COPY transactions (transaction_id, job_id, status_code, comments, modified_date) FROM stdin;
    public       edge    false    170   ��       �          0    16526    users 
   TABLE DATA               �   COPY users (user_id, user_login, user_name, email, crypted_password, salt, created_at, updated_at, remember_token, remember_token_expires_at, role_id, modified_date, active) FROM stdin;
    public       edge    false    172   �       �           2606    16577    pk_device_id 
   CONSTRAINT     R   ALTER TABLE ONLY devices
    ADD CONSTRAINT pk_device_id PRIMARY KEY (device_id);
 >   ALTER TABLE ONLY public.devices DROP CONSTRAINT pk_device_id;
       public         edge    false    141    141            �           2606    16579    pk_email_configuration_key 
   CONSTRAINT     g   ALTER TABLE ONLY email_configurations
    ADD CONSTRAINT pk_email_configuration_key PRIMARY KEY (key);
 Y   ALTER TABLE ONLY public.email_configurations DROP CONSTRAINT pk_email_configuration_key;
       public         edge    false    143    143            �           2606    16581    pk_email_job_id 
   CONSTRAINT     [   ALTER TABLE ONLY email_jobs
    ADD CONSTRAINT pk_email_job_id PRIMARY KEY (email_job_id);
 D   ALTER TABLE ONLY public.email_jobs DROP CONSTRAINT pk_email_job_id;
       public         edge    false    144    144            �           2606    16583    pk_event_id 
   CONSTRAINT     ]   ALTER TABLE ONLY patient_merge_events
    ADD CONSTRAINT pk_event_id PRIMARY KEY (event_id);
 J   ALTER TABLE ONLY public.patient_merge_events DROP CONSTRAINT pk_event_id;
       public         edge    false    158    158            �           2606    16585 
   pk_exam_id 
   CONSTRAINT     L   ALTER TABLE ONLY exams
    ADD CONSTRAINT pk_exam_id PRIMARY KEY (exam_id);
 :   ALTER TABLE ONLY public.exams DROP CONSTRAINT pk_exam_id;
       public         edge    false    146    146            �           2606    16587 "   pk_hipaa_audit_accession_number_id 
   CONSTRAINT     w   ALTER TABLE ONLY hipaa_audit_accession_numbers
    ADD CONSTRAINT pk_hipaa_audit_accession_number_id PRIMARY KEY (id);
 j   ALTER TABLE ONLY public.hipaa_audit_accession_numbers DROP CONSTRAINT pk_hipaa_audit_accession_number_id;
       public         edge    false    148    148            �           2606    16589    pk_hipaa_audit_mrn_id 
   CONSTRAINT     ]   ALTER TABLE ONLY hipaa_audit_mrns
    ADD CONSTRAINT pk_hipaa_audit_mrn_id PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.hipaa_audit_mrns DROP CONSTRAINT pk_hipaa_audit_mrn_id;
       public         edge    false    150    150            �           2606    16591    pk_hipaa_audit_view_id 
   CONSTRAINT     _   ALTER TABLE ONLY hipaa_audit_views
    ADD CONSTRAINT pk_hipaa_audit_view_id PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.hipaa_audit_views DROP CONSTRAINT pk_hipaa_audit_view_id;
       public         edge    false    152    152            �           2606    16593    pk_id 
   CONSTRAINT     K   ALTER TABLE ONLY schema_version
    ADD CONSTRAINT pk_id PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.schema_version DROP CONSTRAINT pk_id;
       public         edge    false    165    165            �           2606    16595 	   pk_job_id 
   CONSTRAINT     I   ALTER TABLE ONLY jobs
    ADD CONSTRAINT pk_job_id PRIMARY KEY (job_id);
 8   ALTER TABLE ONLY public.jobs DROP CONSTRAINT pk_job_id;
       public         edge    false    156    156            �           2606    16597    pk_job_set_id 
   CONSTRAINT     U   ALTER TABLE ONLY job_sets
    ADD CONSTRAINT pk_job_set_id PRIMARY KEY (job_set_id);
 @   ALTER TABLE ONLY public.job_sets DROP CONSTRAINT pk_job_set_id;
       public         edge    false    154    154            �           2606    16599    pk_key 
   CONSTRAINT     M   ALTER TABLE ONLY configurations
    ADD CONSTRAINT pk_key PRIMARY KEY (key);
 ?   ALTER TABLE ONLY public.configurations DROP CONSTRAINT pk_key;
       public         edge    false    140    140            �           2606    16601    pk_patient_id 
   CONSTRAINT     U   ALTER TABLE ONLY patients
    ADD CONSTRAINT pk_patient_id PRIMARY KEY (patient_id);
 @   ALTER TABLE ONLY public.patients DROP CONSTRAINT pk_patient_id;
       public         edge    false    160    160            �           2606    16603    pk_report_id 
   CONSTRAINT     R   ALTER TABLE ONLY reports
    ADD CONSTRAINT pk_report_id PRIMARY KEY (report_id);
 >   ALTER TABLE ONLY public.reports DROP CONSTRAINT pk_report_id;
       public         edge    false    162    162            �           2606    16605 
   pk_role_id 
   CONSTRAINT     L   ALTER TABLE ONLY roles
    ADD CONSTRAINT pk_role_id PRIMARY KEY (role_id);
 :   ALTER TABLE ONLY public.roles DROP CONSTRAINT pk_role_id;
       public         edge    false    164    164            �           2606    16607    pk_status_code 
   CONSTRAINT     [   ALTER TABLE ONLY status_codes
    ADD CONSTRAINT pk_status_code PRIMARY KEY (status_code);
 E   ALTER TABLE ONLY public.status_codes DROP CONSTRAINT pk_status_code;
       public         edge    false    167    167            �           2606    16609    pk_study_id 
   CONSTRAINT     P   ALTER TABLE ONLY studies
    ADD CONSTRAINT pk_study_id PRIMARY KEY (study_id);
 =   ALTER TABLE ONLY public.studies DROP CONSTRAINT pk_study_id;
       public         edge    false    168    168            �           2606    16611    pk_transaction_id 
   CONSTRAINT     a   ALTER TABLE ONLY transactions
    ADD CONSTRAINT pk_transaction_id PRIMARY KEY (transaction_id);
 H   ALTER TABLE ONLY public.transactions DROP CONSTRAINT pk_transaction_id;
       public         edge    false    170    170            �           2606    16613 
   pk_user_id 
   CONSTRAINT     L   ALTER TABLE ONLY users
    ADD CONSTRAINT pk_user_id PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT pk_user_id;
       public         edge    false    172    172            �           2606    16615    uq_exam 
   CONSTRAINT     Y   ALTER TABLE ONLY exams
    ADD CONSTRAINT uq_exam UNIQUE (accession_number, patient_id);
 7   ALTER TABLE ONLY public.exams DROP CONSTRAINT uq_exam;
       public         edge    false    146    146    146            �           2606    16617    uq_login 
   CONSTRAINT     H   ALTER TABLE ONLY users
    ADD CONSTRAINT uq_login UNIQUE (user_login);
 8   ALTER TABLE ONLY public.users DROP CONSTRAINT uq_login;
       public         edge    false    172    172            �           1259    16618    exams_accession_number_idx    INDEX     Q   CREATE INDEX exams_accession_number_idx ON exams USING btree (accession_number);
 .   DROP INDEX public.exams_accession_number_idx;
       public         edge    false    146            �           1259    16623    jobs_job_set_id    INDEX     ?   CREATE INDEX jobs_job_set_id ON jobs USING btree (job_set_id);
 #   DROP INDEX public.jobs_job_set_id;
       public         edge    false    156            �           1259    16619    patients_dob_idx    INDEX     =   CREATE INDEX patients_dob_idx ON patients USING btree (dob);
 $   DROP INDEX public.patients_dob_idx;
       public         edge    false    160            �           1259    16620    patients_mrn_ix    INDEX     C   CREATE UNIQUE INDEX patients_mrn_ix ON patients USING btree (mrn);
 #   DROP INDEX public.patients_mrn_ix;
       public         edge    false    160            �           1259    16621    patients_patient_name_idx    INDEX     O   CREATE INDEX patients_patient_name_idx ON patients USING btree (patient_name);
 -   DROP INDEX public.patients_patient_name_idx;
       public         edge    false    160            �           1259    16622    reports_status_timestamp_idx    INDEX     U   CREATE INDEX reports_status_timestamp_idx ON reports USING btree (status_timestamp);
 0   DROP INDEX public.reports_status_timestamp_idx;
       public         edge    false    162            �           1259    16627    reports_unique_status_idx    INDEX     j   CREATE UNIQUE INDEX reports_unique_status_idx ON reports USING btree (exam_id, status, status_timestamp);
 -   DROP INDEX public.reports_unique_status_idx;
       public         edge    false    162    162    162            �           1259    16625    transactions_job_id    INDEX     G   CREATE INDEX transactions_job_id ON transactions USING btree (job_id);
 '   DROP INDEX public.transactions_job_id;
       public         edge    false    170            �           1259    16626    transactions_modified_date    INDEX     U   CREATE INDEX transactions_modified_date ON transactions USING btree (modified_date);
 .   DROP INDEX public.transactions_modified_date;
       public         edge    false    170            �           1259    16624    transactions_status_code_idx    INDEX     U   CREATE INDEX transactions_status_code_idx ON transactions USING btree (status_code);
 0   DROP INDEX public.transactions_status_code_idx;
       public         edge    false    170            �           2606    16628 
   fk_exam_id    FK CONSTRAINT     e   ALTER TABLE ONLY jobs
    ADD CONSTRAINT fk_exam_id FOREIGN KEY (exam_id) REFERENCES exams(exam_id);
 9   ALTER TABLE ONLY public.jobs DROP CONSTRAINT fk_exam_id;
       public       edge    false    156    1963    146            �           2606    16633 
   fk_exam_id    FK CONSTRAINT     h   ALTER TABLE ONLY studies
    ADD CONSTRAINT fk_exam_id FOREIGN KEY (exam_id) REFERENCES exams(exam_id);
 <   ALTER TABLE ONLY public.studies DROP CONSTRAINT fk_exam_id;
       public       edge    false    1963    168    146            �           2606    16638 
   fk_exam_id    FK CONSTRAINT     h   ALTER TABLE ONLY reports
    ADD CONSTRAINT fk_exam_id FOREIGN KEY (exam_id) REFERENCES exams(exam_id);
 <   ALTER TABLE ONLY public.reports DROP CONSTRAINT fk_exam_id;
       public       edge    false    162    146    1963            �           2606    16643 	   fk_job_id    FK CONSTRAINT     i   ALTER TABLE ONLY transactions
    ADD CONSTRAINT fk_job_id FOREIGN KEY (job_id) REFERENCES jobs(job_id);
 @   ALTER TABLE ONLY public.transactions DROP CONSTRAINT fk_job_id;
       public       edge    false    156    1976    170            �           2606    16648    fk_job_set_id    FK CONSTRAINT     q   ALTER TABLE ONLY jobs
    ADD CONSTRAINT fk_job_set_id FOREIGN KEY (job_set_id) REFERENCES job_sets(job_set_id);
 <   ALTER TABLE ONLY public.jobs DROP CONSTRAINT fk_job_set_id;
       public       edge    false    1973    156    154            �           2606    16653    fk_patient_id    FK CONSTRAINT     u   ALTER TABLE ONLY job_sets
    ADD CONSTRAINT fk_patient_id FOREIGN KEY (patient_id) REFERENCES patients(patient_id);
 @   ALTER TABLE ONLY public.job_sets DROP CONSTRAINT fk_patient_id;
       public       edge    false    1983    160    154            �           2606    16658    fk_patient_id    FK CONSTRAINT     r   ALTER TABLE ONLY exams
    ADD CONSTRAINT fk_patient_id FOREIGN KEY (patient_id) REFERENCES patients(patient_id);
 =   ALTER TABLE ONLY public.exams DROP CONSTRAINT fk_patient_id;
       public       edge    false    146    160    1983            �           2606    16663    fk_report_id    FK CONSTRAINT     m   ALTER TABLE ONLY jobs
    ADD CONSTRAINT fk_report_id FOREIGN KEY (report_id) REFERENCES reports(report_id);
 ;   ALTER TABLE ONLY public.jobs DROP CONSTRAINT fk_report_id;
       public       edge    false    1985    156    162            �           2606    16668    fk_status_code    FK CONSTRAINT     �   ALTER TABLE ONLY transactions
    ADD CONSTRAINT fk_status_code FOREIGN KEY (status_code) REFERENCES status_codes(status_code);
 E   ALTER TABLE ONLY public.transactions DROP CONSTRAINT fk_status_code;
       public       edge    false    167    1993    170            �           2606    16673 
   fk_user_id    FK CONSTRAINT     i   ALTER TABLE ONLY job_sets
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(user_id);
 =   ALTER TABLE ONLY public.job_sets DROP CONSTRAINT fk_user_id;
       public       edge    false    2002    154    172            �   �  x��T�n�0<�_� �)�ҭE/����X�`��MT��T`�}���N�� 6�3��Y��N��[d�ˀK�9pEԲҼ�F��~AV
V�-��
�*c*̈́޸��݁-�eC�ϡ��G�ݸ�OK@޻Gt��!o��1�$N`B2P�B4�j���(e*&����'8kq�iQ����I]��͓cbfC��1�����~?���J���FP���"��h%�:w}�v!zCg�?�C~��y
.N��p#]AI�.j�"=L��,��%fP<w�j�P$�JsY*S�����"b�ُ��/����(M�Ȳ͵6�0���.�b��R׵���ƀdf�c�=��G�6E�M��y�ͳ�y�1S �ma��.���#9��y)�+�ט���a�`���a�`��)�BoA]W�M�:�{{dnd��C<Z׳i�j��ǈ,ĥ;f��xFҫ�{�çK����mȴo�M`�g��.��G;�ˁj�
ijDI/��<)��R����⑥)���hz�藷	�{��/a�ғVBh&��+��<.�#6�k�i��5's�mʊ�cs���]�g��^�L��6��ǜ�[t�觰.�oZ�?�~��I꽺�>�&3�O��|	��Vr�v��>��JI��j:��6nY�w��l6� �ͅ�      �      x������ � �      �   �  x��U�n�F}v��]�!�r��v�HM�E�I�E� �X��Y�f����������KJ�|�s�.��yxH2��*r�/�̚���F��aop���tDч������ؚ�������\��5v���Ʉr�>��3��S
/Q��څ�YLd�ήsȥrh�(�Q)���M�M�\S=dh�T�̛0����WL|�/SY��XH� ʓ�9�]�d��JbM��=	m��`�؃A4�LF��K��I��5
�����rn?��jX
t��8�i���T��2YBU��Jj�6x@�PK�@#�lX��ϱ ��ဟ�:���[������ۇIBU��K��\�c�Uʻ�,p��j�A��\j4�3��m"4$t���S�tPV�4�r�����y�g%).PbK�a����������+�)\
�-f?�˽/��>�]N��R��bAV�����˾���]��m�.����r���N�㻫�O�0�%�Ti����[�E��m�=�M~��H��:��y,��֬d��~RO���H���y[%^M��򐛚[�г��m�N	��	�-^���^熛I@�6mP��9i��]m���_:�,�z�-�p�E�*K.Q�Z
�k����y�#םD�i�,È�����ú�#.\d�f!���m�A+�wD��@�c�k�W�������,�9�k�SS�q���4'���Y��ȋ��Wϙ�_�R=.���Ѩ��o���8>Oz����ɶ�"(1�+�L�gp=j���J���W�ySm����^G�Z�`�<�����'���:R햬�)",5��}h(�-��K_ъ���U��P�x���Q�b��w��m2�O���Oo-�/���5MCDp���}5s�ک	��/'�(ݠ�:�>�'��=�������0A�0݉�{���Ĵn���<=z�+���ޅ��GbR잰�'��a���!��-�od~A��̟������(��      �      x������ � �      �   |   x�u��	1Dѳ���^����(�Ӄ0,_?����b h�w��Z�Ћl�L��.#F�	��?D'P��{[D7"A�L���"��g"����ºHۈ��8f�$ϟ�s�_B8/      �      x������ � �      �      x������ � �      �   Y   x��Q
� �o=Ep}�[F������4P�n����A�1@*fI9}wn��>��t���T�m�^�o-* o<:���a����`g���*�G      �      x������ � �      �      x������ � �      �      x������ � �      �     x���Mj�0�����̌~l�;ӦP�6�M7A���5�2H�\�J;Z�Yf5<�x3��a
�JF������N�3@�BF���WXR�����1�t�\�4/ )`�v�T2iE�V�V:/ʒ��-b �<q9lC?M���W%.O\�{�{h�/0g����uť�q���)�f3�g����O�,n�p�w6���`�e��S%U�Ԗ�,�<��s2�+k%���6��8xh.j��}U��bFU��<��5[g�@��"'�R��.ϲ����u      �   �   x����N1�뻧�8k�k;J���t�*�.)x|6q\g�k}��cuӡ{^?m7����#�0���Jx0�v��c$�E��n�����4o#�B�%��E4"�%0�,�������h���  塉j����~��7�%]�9���p<����<����2h~/\d���Z��&�z������D
�V��hkv��z�֤�� C���ð�Pl]'�Xh���/�l;߼�\���"H�      �      x������ � �      �   .   x�3�4�3�3�4204�50�52T04�20"=Kcc]3�=... �J�      �   �  x����n�0���S�$�W?��	�A�K/���YH�@�mڧ/i)��e �,Ϸ�3#FvO^Y��؂sڜ�6�գNy����<<�"�HQK\�).s,2Jvߔ�Qs-�0�֣�6���ף����D�3��������G��_�*�ױ~D.��ʸ��Kۃ���e�:Hm@ߜ�c<�z�;r�y�6	�o �Ԏ�����,�4�%"\�J2V���]��|xBg0`�1��٫iS�?�?k�?�櫺����zt�>)�x��o�Y��lӳ୆�������2�ң%��v���K����~1��C��-�S���m@�-QA�m�r\�5��B��b�ot)�6ʋ&T�l歷�)��,���K��򪝋6xi�/�/�݅cIHQ�����ޭ9~m�K]h�.x]�t����.~2����V�� y���!9��*��ߋ,��DH�      �      x������ � �      �      x������ � �      �   N   x�34�,-N-2���KU�8c������\��X��L��������@���D���D�%�zFf&f� U%\1z\\\ ��$     