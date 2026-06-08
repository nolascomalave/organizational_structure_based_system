-- Current sql file was generated after introspecting the database
-- If you want to run this migration please uncomment this code before executing migrations
/*
CREATE SCHEMA "osbs";
--> statement-breakpoint
CREATE SCHEMA "tenants";
--> statement-breakpoint
CREATE TYPE "osbs"."source_type" AS ENUM('EMAIL', 'PHONE_NUMBER');--> statement-breakpoint
CREATE TABLE "osbs"."region" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"name" varchar(100) NOT NULL,
	"translations" text,
	"created_at" timestamp,
	"updated_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"flag" smallint DEFAULT 1 NOT NULL,
	"wikiDataId" varchar(255)
);
--> statement-breakpoint
CREATE TABLE "osbs"."audit_log" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"record_id" uuid NOT NULL,
	"table_name" varchar(100) NOT NULL,
	"action" varchar(10) NOT NULL,
	"old_data" jsonb,
	"new_data" jsonb NOT NULL,
	"changed_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
--> statement-breakpoint
CREATE TABLE "osbs"."subregion" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"region_id" uuid NOT NULL,
	"name" varchar(100) NOT NULL,
	"translations" text,
	"created_at" timestamp,
	"updated_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"flag" smallint DEFAULT 1 NOT NULL,
	"wikiDataId" varchar(255)
);
--> statement-breakpoint
CREATE TABLE "osbs"."country" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"region_id" uuid,
	"subregion_id" uuid,
	"region" varchar(255),
	"subregion" varchar(255),
	"name" varchar(100) NOT NULL,
	"iso3" char(3),
	"numeric_code" char(3),
	"iso2" char(2),
	"phonecode" varchar(255),
	"capital" varchar(255),
	"currency" varchar(255),
	"currency_name" varchar(255),
	"currency_symbol" varchar(255),
	"tld" varchar(255),
	"native" varchar(255),
	"population" bigint,
	"gdp" bigint,
	"nationality" varchar(255),
	"area_sq_km" double precision,
	"postal_code_format" varchar(255),
	"postal_code_regex" varchar(255),
	"timezones" text,
	"translations" text,
	"latitude" numeric(10, 8),
	"longitude" numeric(11, 8),
	"emoji" varchar(191),
	"emojiU" varchar(191),
	"created_at" timestamp,
	"updated_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"flag" smallint DEFAULT 1 NOT NULL,
	"wikiDataId" varchar(255)
);
--> statement-breakpoint
CREATE TABLE "osbs"."state" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"name" varchar(255) NOT NULL,
	"country_id" uuid NOT NULL,
	"parent_id" uuid,
	"country_code" char(2) NOT NULL,
	"fips_code" varchar(255),
	"iso2" varchar(255),
	"iso3166_2" varchar(10),
	"type" varchar(191),
	"level" integer,
	"native" varchar(255),
	"latitude" numeric(10, 8),
	"longitude" numeric(11, 8),
	"timezone" varchar(255),
	"translations" text,
	"created_at" timestamp,
	"updated_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"flag" smallint DEFAULT 1 NOT NULL,
	"wikiDataId" varchar(255),
	"population" varchar(255)
);
--> statement-breakpoint
CREATE TABLE "osbs"."city" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"name" varchar(255) NOT NULL,
	"state_id" uuid NOT NULL,
	"country_id" uuid NOT NULL,
	"parent_id" uuid,
	"state_code" varchar(255) NOT NULL,
	"country_code" char(2) NOT NULL,
	"type" varchar(191),
	"level" integer,
	"latitude" numeric(10, 8) NOT NULL,
	"longitude" numeric(11, 8) NOT NULL,
	"native" varchar(255),
	"population" bigint,
	"timezone" varchar(255),
	"translations" text,
	"created_at" timestamp DEFAULT '2014-01-01 12:01:01' NOT NULL,
	"updated_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"flag" smallint DEFAULT 1 NOT NULL,
	"wikiDataId" varchar(255)
);
--> statement-breakpoint
CREATE TABLE "osbs"."system_subscription" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"deleted_at" timestamp with time zone
);
--> statement-breakpoint
CREATE TABLE "osbs"."system_subscription_validity" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"start_date" timestamp with time zone NOT NULL,
	"end_date" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"deleted_at" timestamp with time zone
);
--> statement-breakpoint
CREATE TABLE "osbs"."phone" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"country_id" uuid NOT NULL,
	"state_id" uuid,
	"phone" varchar(50) NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "phone_unique" UNIQUE("country_id","phone","state_id")
);
--> statement-breakpoint
CREATE TABLE "osbs"."system_client" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"name" varchar(250) NOT NULL,
	"description" text,
	"is_active" boolean DEFAULT true NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone
);
--> statement-breakpoint
CREATE TABLE "osbs"."email" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"email" varchar(320) NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "email_ck_valid" CHECK ((email)::text ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text)
);
--> statement-breakpoint
CREATE TABLE "tenants"."audit_log" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"user_access_id" uuid,
	"session_id" uuid,
	"record_id" uuid NOT NULL,
	"table_name" varchar(100) NOT NULL,
	"action" varchar(10) NOT NULL,
	"old_data" jsonb,
	"new_data" jsonb NOT NULL,
	"changed_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
--> statement-breakpoint
ALTER TABLE "tenants"."audit_log" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."system_subscription_owner" (
	"system_subscription_id" uuid PRIMARY KEY NOT NULL,
	"entity_id" uuid NOT NULL
);
--> statement-breakpoint
ALTER TABLE "tenants"."system_subscription_owner" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."system_subscription_client" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"system_client_id" uuid,
	"name" varchar(250) NOT NULL,
	"description" text,
	"is_active" boolean DEFAULT true NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "system_subscription_client_unique" UNIQUE("name","system_subscription_id")
);
--> statement-breakpoint
ALTER TABLE "tenants"."system_subscription_client" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."user_access" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"system_subscription_client_id" uuid NOT NULL,
	"email_by_entity_id" uuid NOT NULL,
	"password" text NOT NULL,
	"is_active" boolean DEFAULT true NOT NULL,
	CONSTRAINT "user_access_unique" UNIQUE("email_by_entity_id","system_subscription_client_id")
);
--> statement-breakpoint
ALTER TABLE "tenants"."user_access" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."user_access_validity" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"user_access_id" uuid NOT NULL,
	"start_date" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"end_date" timestamp with time zone
);
--> statement-breakpoint
ALTER TABLE "tenants"."user_access_validity" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."session" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"user_access_id" uuid,
	"refreshtoken" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"expires_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"deleted_at" timestamp with time zone
);
--> statement-breakpoint
ALTER TABLE "tenants"."session" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."recovery_password" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"user_access_id" uuid,
	"validity_code" varchar(10) NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"expires_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"used_at" timestamp with time zone,
	"deleted_at" timestamp with time zone
);
--> statement-breakpoint
ALTER TABLE "tenants"."recovery_password" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."recovery_password_notify" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"recovery_password_id" uuid NOT NULL,
	"phone_by_entity_id" uuid,
	"email_by_entity_id" uuid,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "recovery_password_notify_ck_notify_method" CHECK ((phone_by_entity_id IS NOT NULL) OR (email_by_entity_id IS NOT NULL))
);
--> statement-breakpoint
ALTER TABLE "tenants"."recovery_password_notify" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."entity" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"fusion_master_entity_id" uuid,
	"is_natural" boolean DEFAULT false NOT NULL,
	"identity_document" varchar(250),
	"name" varchar(250),
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"fusioned_at" timestamp with time zone,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "entity_ck_fusion" CHECK (((fusion_master_entity_id IS NOT NULL) AND (fusioned_at IS NOT NULL)) OR ((fusion_master_entity_id IS NULL) AND (fusioned_at IS NULL)))
);
--> statement-breakpoint
ALTER TABLE "tenants"."entity" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."natural_entity_gender" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"gender" varchar(100) NOT NULL,
	"description" varchar(2500),
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "natural_entity_gender_unique" UNIQUE("gender","system_subscription_id")
);
--> statement-breakpoint
ALTER TABLE "tenants"."natural_entity_gender" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."natural_entity" (
	"entity_id" uuid PRIMARY KEY NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"natural_entity_gender_id" uuid NOT NULL,
	"birth_date" date,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone
);
--> statement-breakpoint
ALTER TABLE "tenants"."natural_entity" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."identity_document_category" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"parent_id" uuid NOT NULL,
	"region_id" uuid,
	"subregion_id" uuid,
	"country_id" uuid,
	"state_id" uuid,
	"city_id" uuid,
	"apply_to_natural" boolean DEFAULT true NOT NULL,
	"apply_to_legal" boolean DEFAULT true NOT NULL,
	"category" varchar(250) NOT NULL,
	"symbol" varchar(50),
	"abbreviation" varchar(50),
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "identity_document_category_unique" UNIQUE("city_id","country_id","parent_id","region_id","state_id","subregion_id","system_subscription_id"),
	CONSTRAINT "identity_document_category_ck_apply_to" CHECK ((apply_to_natural = true) OR (apply_to_legal = true))
);
--> statement-breakpoint
ALTER TABLE "tenants"."identity_document_category" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."identity_document" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"identity_document_category_id" uuid NOT NULL,
	"document" varchar(250) NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "identity_document_unique" UNIQUE("document","identity_document_category_id")
);
--> statement-breakpoint
ALTER TABLE "tenants"."identity_document" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."identity_document_by_entity" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"entity_id" uuid NOT NULL,
	"identity_document_id" uuid NOT NULL,
	"description" text,
	"ordering" bigint DEFAULT 0 NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "identity_document_by_entity_unique" UNIQUE("entity_id","identity_document_id")
);
--> statement-breakpoint
ALTER TABLE "tenants"."identity_document_by_entity" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."entity_name_type" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"type" varchar(50) NOT NULL,
	"apply_to_natural" boolean DEFAULT true NOT NULL,
	"apply_to_legal" boolean DEFAULT true NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "entity_name_type_unique" UNIQUE("system_subscription_id","type")
);
--> statement-breakpoint
ALTER TABLE "tenants"."entity_name_type" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."entity_name" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"name" varchar(250) NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "entity_name_unique" UNIQUE("name","system_subscription_id")
);
--> statement-breakpoint
ALTER TABLE "tenants"."entity_name" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."entity_name_by_entity" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"entity_id" uuid NOT NULL,
	"entity_name_id" uuid NOT NULL,
	"entity_name_type_id" uuid NOT NULL,
	"ordering_by_type" integer DEFAULT 0 NOT NULL,
	"description" text,
	"ordering" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "entity_name_by_entity_unique" UNIQUE("entity_id","entity_name_id","entity_name_type_id")
);
--> statement-breakpoint
ALTER TABLE "tenants"."entity_name_by_entity" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."entity_address" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"entity_id" uuid NOT NULL,
	"region_id" uuid,
	"subregion_id" uuid,
	"country_id" uuid NOT NULL,
	"state_id" uuid NOT NULL,
	"city_id" uuid,
	"postal_code" integer,
	"custom_city" varchar(250),
	"description" text,
	"is_preferred" boolean DEFAULT false NOT NULL,
	"ordering" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "entity_address_unique" UNIQUE("city_id","country_id","custom_city","entity_id","postal_code","region_id","state_id","subregion_id")
);
--> statement-breakpoint
ALTER TABLE "tenants"."entity_address" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."phone_by_entity" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"phone_id" uuid NOT NULL,
	"entity_id" uuid NOT NULL,
	"preferred" boolean DEFAULT false NOT NULL,
	"description" text,
	"ordering" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "phone_by_entity_unique" UNIQUE("entity_id","phone_id")
);
--> statement-breakpoint
ALTER TABLE "tenants"."phone_by_entity" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."email_by_entity" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"email_id" uuid NOT NULL,
	"entity_id" uuid NOT NULL,
	"preferred" boolean DEFAULT false NOT NULL,
	"description" text,
	"ordering" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "email_by_entity_unique" UNIQUE("email_id","entity_id")
);
--> statement-breakpoint
ALTER TABLE "tenants"."email_by_entity" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."department" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"entity_id" uuid,
	"parent_id" uuid,
	"name" varchar(250) NOT NULL,
	"description" text,
	"code" varchar(50),
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "department_unique" UNIQUE("entity_id","name","parent_id"),
	CONSTRAINT "department_ck_fusion" CHECK (((entity_id IS NOT NULL) AND (parent_id IS NULL)) OR ((entity_id IS NULL) AND (parent_id IS NOT NULL)))
);
--> statement-breakpoint
ALTER TABLE "tenants"."department" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."job_family" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"entity_id" uuid NOT NULL,
	"name" varchar(250) NOT NULL,
	"description" text,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "job_family_unique" UNIQUE("entity_id","name")
);
--> statement-breakpoint
ALTER TABLE "tenants"."job_family" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."position" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"entity_id" uuid,
	"parent_id" uuid,
	"job_family_id" uuid,
	"department_id" uuid,
	"name" varchar(250) NOT NULL,
	"description" text,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "position_unique" UNIQUE("department_id","entity_id","job_family_id","name","parent_id")
);
--> statement-breakpoint
ALTER TABLE "tenants"."position" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."employee" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"person_entity_id" uuid NOT NULL,
	"legal_entity_id" uuid NOT NULL,
	"employee_code" varchar(100) NOT NULL,
	"is_active" boolean DEFAULT true NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "employee_unique_person" UNIQUE("legal_entity_id","person_entity_id"),
	CONSTRAINT "employee_unique_code" UNIQUE("employee_code","legal_entity_id")
);
--> statement-breakpoint
ALTER TABLE "tenants"."employee" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."employee_validity" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"employee_id" uuid NOT NULL,
	"start_date" timestamp with time zone NOT NULL,
	"end_date" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"deleted_at" timestamp with time zone
);
--> statement-breakpoint
ALTER TABLE "tenants"."employee_validity" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."employee_per_position" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"employee_id" uuid NOT NULL,
	"position_id" uuid NOT NULL,
	"is_active" boolean DEFAULT true NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "employee_per_position_unique" UNIQUE("employee_id","position_id")
);
--> statement-breakpoint
ALTER TABLE "tenants"."employee_per_position" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."employee_per_position_validity" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"employee_per_position_id" uuid NOT NULL,
	"start_date" timestamp with time zone,
	"end_date" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"deleted_at" timestamp with time zone
);
--> statement-breakpoint
ALTER TABLE "tenants"."employee_per_position_validity" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."shareholding" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"entity_id" uuid NOT NULL,
	"shareholer_entity_id" uuid NOT NULL,
	"is_active" boolean DEFAULT true NOT NULL,
	"ownership_percentage" numeric(5, 2),
	"shares_quantity" integer,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "shareholding_unique" UNIQUE("entity_id","shareholer_entity_id")
);
--> statement-breakpoint
ALTER TABLE "tenants"."shareholding" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."shareholding_validity" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"shareholding_id" uuid NOT NULL,
	"start_date" timestamp with time zone NOT NULL,
	"end_date" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"deleted_at" timestamp with time zone
);
--> statement-breakpoint
ALTER TABLE "tenants"."shareholding_validity" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."subsidiary" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"entity_id" uuid NOT NULL,
	"parent_entity_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "subsidiary_unique" UNIQUE("entity_id","parent_entity_id")
);
--> statement-breakpoint
ALTER TABLE "tenants"."subsidiary" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."subsidiary_validity" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"subsidiary_id" uuid NOT NULL,
	"start_date" timestamp with time zone NOT NULL,
	"end_date" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"deleted_at" timestamp with time zone
);
--> statement-breakpoint
ALTER TABLE "tenants"."subsidiary_validity" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."branch" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"entity_id" uuid,
	"parent_id" uuid,
	"position_id" uuid,
	"subsidiary_id" uuid,
	"is_headquarters" boolean DEFAULT false,
	"code" varchar(50),
	"name" varchar(250),
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "branch_unique" UNIQUE("code","entity_id","parent_id"),
	CONSTRAINT "branch_ck_parent" CHECK (((entity_id IS NOT NULL) AND (parent_id IS NULL)) OR ((entity_id IS NULL) AND (parent_id IS NOT NULL))),
	CONSTRAINT "branch_ck_subsidiary" CHECK (((subsidiary_id IS NULL) AND (annulled_at IS NOT NULL)) OR ((subsidiary_id IS NOT NULL) AND (annulled_at IS NULL)))
);
--> statement-breakpoint
ALTER TABLE "tenants"."branch" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."identity_document_by_entity_by_branch" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"branch_id" uuid NOT NULL,
	"identity_document_by_entity_id" uuid NOT NULL,
	"description" text,
	"ordering" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "identity_document_by_entity_by_branch_unique" UNIQUE("branch_id","identity_document_by_entity_id")
);
--> statement-breakpoint
ALTER TABLE "tenants"."identity_document_by_entity_by_branch" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."entity_address_by_branch" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"branch_id" uuid NOT NULL,
	"entity_address_id" uuid NOT NULL,
	"is_preferred" boolean DEFAULT false NOT NULL,
	"description" text,
	"ordering" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "entity_address_by_branch_unique" UNIQUE("branch_id","entity_address_id")
);
--> statement-breakpoint
ALTER TABLE "tenants"."entity_address_by_branch" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."phone_by_entity_by_branch" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"branch_id" uuid NOT NULL,
	"phone_by_entity_id" uuid NOT NULL,
	"description" text,
	"ordering" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "phone_by_entity_by_branch_unique" UNIQUE("branch_id","phone_by_entity_id")
);
--> statement-breakpoint
ALTER TABLE "tenants"."phone_by_entity_by_branch" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."email_by_entity_by_branch" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"branch_id" uuid NOT NULL,
	"email_by_entity_id" uuid NOT NULL,
	"description" text,
	"ordering" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "email_by_entity_by_branch_unique" UNIQUE("branch_id","email_by_entity_id")
);
--> statement-breakpoint
ALTER TABLE "tenants"."email_by_entity_by_branch" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "tenants"."attached_documents" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"system_subscription_id" uuid NOT NULL,
	"origin_table" varchar(250) NOT NULL,
	"origin_id" uuid NOT NULL,
	"original_name" varchar(250) NOT NULL,
	"document_name" varchar(250) NOT NULL,
	"extension" varchar(20) NOT NULL,
	"mime_type" varchar(100) NOT NULL,
	"bytes_size" uuid NOT NULL,
	"storage_route" varchar(2500) NOT NULL,
	"disk" varchar(50) DEFAULT 'local',
	"document_hash" varchar(64),
	"description" text,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone
);
--> statement-breakpoint
ALTER TABLE "tenants"."attached_documents" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "osbs"."source_type_verification_method" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"source_type" "osbs"."source_type" NOT NULL,
	"name" varchar(250) NOT NULL,
	"description" text,
	"is_active" boolean DEFAULT true NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"annulled_at" timestamp with time zone,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "source_type_verification_method_unique" UNIQUE("name","source_type"),
	CONSTRAINT "source_type_verification_method_ck_active_status" CHECK (((is_active = true) AND (annulled_at IS NULL)) OR ((is_active = false) AND (annulled_at IS NOT NULL)))
);
--> statement-breakpoint
CREATE TABLE "osbs"."source_type_verification_method_validity" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"source_type_verification_method_id" uuid NOT NULL,
	"start_date" timestamp with time zone NOT NULL,
	"end_date" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"deleted_at" timestamp with time zone
);
--> statement-breakpoint
CREATE TABLE "osbs"."registration_source" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"source_type" "osbs"."source_type" NOT NULL,
	"source" varchar(250) NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "registration_source_unique" UNIQUE("source","source_type")
);
--> statement-breakpoint
CREATE TABLE "osbs"."registration" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"registration_source_id" uuid NOT NULL,
	"ip_address" "inet",
	"confirm_registration_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"expired_at" timestamp with time zone DEFAULT (now() + '00:30:00'::interval) NOT NULL,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "registration_unique" UNIQUE("ip_address","registration_source_id")
);
--> statement-breakpoint
CREATE TABLE "osbs"."registration_source_verification" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"registration_id" uuid NOT NULL,
	"source_type_verification_method_id" uuid NOT NULL,
	"code" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"used_at" timestamp with time zone,
	"expired_at" timestamp with time zone DEFAULT (now() + '00:05:00'::interval) NOT NULL,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "registration_source_verification_ck_used" CHECK ((used_at IS NULL) OR ((used_at IS NOT NULL) AND (used_at <= expired_at)))
);
--> statement-breakpoint
CREATE TABLE "osbs"."system_subscription_registration" (
	"system_subscription_id" uuid NOT NULL,
	"registration_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"deleted_at" timestamp with time zone,
	CONSTRAINT "system_subscription_registration_pkey" PRIMARY KEY("registration_id","system_subscription_id")
);
--> statement-breakpoint
ALTER TABLE "osbs"."subregion" ADD CONSTRAINT "subregion_region_id_fkey" FOREIGN KEY ("region_id") REFERENCES "osbs"."region"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "osbs"."country" ADD CONSTRAINT "country_region_id_fkey" FOREIGN KEY ("region_id") REFERENCES "osbs"."region"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "osbs"."country" ADD CONSTRAINT "country_subregion_id_fkey" FOREIGN KEY ("subregion_id") REFERENCES "osbs"."subregion"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "osbs"."state" ADD CONSTRAINT "state_country_id_fkey" FOREIGN KEY ("country_id") REFERENCES "osbs"."country"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "osbs"."city" ADD CONSTRAINT "city_country_id_fkey" FOREIGN KEY ("country_id") REFERENCES "osbs"."country"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "osbs"."city" ADD CONSTRAINT "city_state_id_fkey" FOREIGN KEY ("state_id") REFERENCES "osbs"."state"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "osbs"."system_subscription_validity" ADD CONSTRAINT "system_subscription_validity_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "osbs"."phone" ADD CONSTRAINT "phone_fkey_country" FOREIGN KEY ("country_id") REFERENCES "osbs"."country"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "osbs"."phone" ADD CONSTRAINT "phone_fkey_state" FOREIGN KEY ("state_id") REFERENCES "osbs"."state"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."audit_log" ADD CONSTRAINT "audit_log_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."audit_log" ADD CONSTRAINT "audit_log_fkey_user_access" FOREIGN KEY ("user_access_id") REFERENCES "tenants"."user_access"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."audit_log" ADD CONSTRAINT "audit_log_fkey_session" FOREIGN KEY ("session_id") REFERENCES "tenants"."session"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."system_subscription_owner" ADD CONSTRAINT "system_subscription_owner_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."system_subscription_owner" ADD CONSTRAINT "system_subscription_owner_fkey_entity" FOREIGN KEY ("entity_id") REFERENCES "tenants"."entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."system_subscription_client" ADD CONSTRAINT "system_subscription_client_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."system_subscription_client" ADD CONSTRAINT "system_subscription_client_fkey_system_client" FOREIGN KEY ("system_client_id") REFERENCES "osbs"."system_client"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."user_access" ADD CONSTRAINT "user_access_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."user_access" ADD CONSTRAINT "user_access_fkey_system_subscription_client" FOREIGN KEY ("system_subscription_client_id") REFERENCES "tenants"."system_subscription_client"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."user_access" ADD CONSTRAINT "user_access_fkey_email_by_entity" FOREIGN KEY ("email_by_entity_id") REFERENCES "tenants"."email_by_entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."user_access_validity" ADD CONSTRAINT "user_access_validity_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."user_access_validity" ADD CONSTRAINT "user_access_validity_fkey_user_access" FOREIGN KEY ("user_access_id") REFERENCES "tenants"."user_access"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."session" ADD CONSTRAINT "session_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."session" ADD CONSTRAINT "session_fkey_user_access" FOREIGN KEY ("user_access_id") REFERENCES "tenants"."user_access"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."recovery_password" ADD CONSTRAINT "recovery_password_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."recovery_password" ADD CONSTRAINT "recovery_password_fkey_user_access" FOREIGN KEY ("user_access_id") REFERENCES "tenants"."user_access"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."recovery_password_notify" ADD CONSTRAINT "recovery_password_notify_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."recovery_password_notify" ADD CONSTRAINT "recovery_password_notify_fkey_recovery_password" FOREIGN KEY ("recovery_password_id") REFERENCES "tenants"."recovery_password"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."recovery_password_notify" ADD CONSTRAINT "recovery_password_notify_fkey_phone_by_entity" FOREIGN KEY ("phone_by_entity_id") REFERENCES "tenants"."phone_by_entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."recovery_password_notify" ADD CONSTRAINT "recovery_password_notify_fkey_email_by_entity" FOREIGN KEY ("email_by_entity_id") REFERENCES "tenants"."email_by_entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."entity" ADD CONSTRAINT "entity_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."entity" ADD CONSTRAINT "entity_fkey_fusion_master_entity" FOREIGN KEY ("fusion_master_entity_id") REFERENCES "tenants"."entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."natural_entity_gender" ADD CONSTRAINT "natural_entity_gender_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."natural_entity" ADD CONSTRAINT "natural_entity_fkey_entity" FOREIGN KEY ("entity_id") REFERENCES "tenants"."entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."natural_entity" ADD CONSTRAINT "natural_entity_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."natural_entity" ADD CONSTRAINT "natural_entity_fkey_natural_entity_gender" FOREIGN KEY ("natural_entity_gender_id") REFERENCES "tenants"."natural_entity_gender"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."identity_document_category" ADD CONSTRAINT "identity_document_category_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."identity_document_category" ADD CONSTRAINT "identity_document_category_fkey_parent" FOREIGN KEY ("parent_id") REFERENCES "tenants"."identity_document_category"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."identity_document_category" ADD CONSTRAINT "identity_document_category_fkey_region" FOREIGN KEY ("region_id") REFERENCES "osbs"."region"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."identity_document_category" ADD CONSTRAINT "identity_document_category_fkey_subregion" FOREIGN KEY ("subregion_id") REFERENCES "osbs"."subregion"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."identity_document_category" ADD CONSTRAINT "identity_document_category_fkey_country" FOREIGN KEY ("country_id") REFERENCES "osbs"."country"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."identity_document_category" ADD CONSTRAINT "identity_document_category_fkey_state" FOREIGN KEY ("state_id") REFERENCES "osbs"."state"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."identity_document_category" ADD CONSTRAINT "identity_document_category_fkey_city" FOREIGN KEY ("city_id") REFERENCES "osbs"."city"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."identity_document" ADD CONSTRAINT "identity_document_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."identity_document" ADD CONSTRAINT "identity_document_fkey_identity_document_category" FOREIGN KEY ("identity_document_category_id") REFERENCES "tenants"."identity_document_category"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."identity_document_by_entity" ADD CONSTRAINT "identity_document_by_entity_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."identity_document_by_entity" ADD CONSTRAINT "identity_document_by_entity_fkey_entity" FOREIGN KEY ("entity_id") REFERENCES "tenants"."entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."identity_document_by_entity" ADD CONSTRAINT "identity_document_by_entity_fkey_identity_document" FOREIGN KEY ("identity_document_id") REFERENCES "tenants"."identity_document"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."entity_name_type" ADD CONSTRAINT "entity_name_type_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."entity_name" ADD CONSTRAINT "entity_name_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."entity_name_by_entity" ADD CONSTRAINT "entity_name_by_entity_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."entity_name_by_entity" ADD CONSTRAINT "entity_name_by_entity_fkey_entity" FOREIGN KEY ("entity_id") REFERENCES "tenants"."entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."entity_name_by_entity" ADD CONSTRAINT "entity_name_by_entity_fkey_entity_name" FOREIGN KEY ("entity_name_id") REFERENCES "tenants"."entity_name"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."entity_name_by_entity" ADD CONSTRAINT "entity_name_by_entity_fkey_entity_name_type" FOREIGN KEY ("entity_name_type_id") REFERENCES "tenants"."entity_name_type"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."entity_address" ADD CONSTRAINT "entity_address_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."entity_address" ADD CONSTRAINT "entity_address_fkey_region" FOREIGN KEY ("region_id") REFERENCES "osbs"."region"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."entity_address" ADD CONSTRAINT "entity_address_fkey_subregion" FOREIGN KEY ("subregion_id") REFERENCES "osbs"."subregion"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."entity_address" ADD CONSTRAINT "entity_address_fkey_country" FOREIGN KEY ("country_id") REFERENCES "osbs"."country"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."entity_address" ADD CONSTRAINT "entity_address_fkey_state" FOREIGN KEY ("state_id") REFERENCES "osbs"."state"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."entity_address" ADD CONSTRAINT "entity_address_fkey_city" FOREIGN KEY ("city_id") REFERENCES "osbs"."city"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."entity_address" ADD CONSTRAINT "entity_address_fkey_entity" FOREIGN KEY ("entity_id") REFERENCES "tenants"."entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."phone_by_entity" ADD CONSTRAINT "phone_by_entity_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."phone_by_entity" ADD CONSTRAINT "phone_by_entity_fkey_phone" FOREIGN KEY ("phone_id") REFERENCES "osbs"."phone"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."phone_by_entity" ADD CONSTRAINT "phone_by_entity_fkey_entity" FOREIGN KEY ("entity_id") REFERENCES "tenants"."entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."email_by_entity" ADD CONSTRAINT "email_by_entity_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."email_by_entity" ADD CONSTRAINT "email_by_entity_fkey_email" FOREIGN KEY ("email_id") REFERENCES "osbs"."email"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."email_by_entity" ADD CONSTRAINT "email_by_entity_fkey_entity" FOREIGN KEY ("entity_id") REFERENCES "tenants"."entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."department" ADD CONSTRAINT "department_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."department" ADD CONSTRAINT "department_fkey_entity" FOREIGN KEY ("entity_id") REFERENCES "tenants"."entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."department" ADD CONSTRAINT "department_fkey_parent" FOREIGN KEY ("parent_id") REFERENCES "tenants"."department"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."job_family" ADD CONSTRAINT "job_family_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."job_family" ADD CONSTRAINT "job_family_fkey_entity" FOREIGN KEY ("entity_id") REFERENCES "tenants"."entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."position" ADD CONSTRAINT "position_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."position" ADD CONSTRAINT "position_fkey_entity" FOREIGN KEY ("entity_id") REFERENCES "tenants"."entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."position" ADD CONSTRAINT "position_fkey_parent" FOREIGN KEY ("parent_id") REFERENCES "tenants"."position"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."position" ADD CONSTRAINT "position_fkey_job_family" FOREIGN KEY ("job_family_id") REFERENCES "tenants"."job_family"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."position" ADD CONSTRAINT "position_fkey_department" FOREIGN KEY ("department_id") REFERENCES "tenants"."department"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."employee" ADD CONSTRAINT "employee_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."employee" ADD CONSTRAINT "employee_fkey_person_entity" FOREIGN KEY ("person_entity_id") REFERENCES "tenants"."entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."employee" ADD CONSTRAINT "employee_fkey_legal_entity" FOREIGN KEY ("legal_entity_id") REFERENCES "tenants"."entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."employee_validity" ADD CONSTRAINT "employee_validity_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."employee_validity" ADD CONSTRAINT "employee_validity_fkey_employee" FOREIGN KEY ("employee_id") REFERENCES "tenants"."employee"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."employee_per_position" ADD CONSTRAINT "employee_per_position_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."employee_per_position" ADD CONSTRAINT "employee_per_position_fkey_employee" FOREIGN KEY ("employee_id") REFERENCES "tenants"."employee"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."employee_per_position" ADD CONSTRAINT "employee_per_position_fkey_position" FOREIGN KEY ("position_id") REFERENCES "tenants"."position"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."employee_per_position_validity" ADD CONSTRAINT "employee_per_position_validity_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."employee_per_position_validity" ADD CONSTRAINT "employee_per_position_validity_fkey_employee_per_position" FOREIGN KEY ("employee_per_position_id") REFERENCES "tenants"."employee_per_position"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."shareholding" ADD CONSTRAINT "shareholding_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."shareholding" ADD CONSTRAINT "shareholding_fkey_entity" FOREIGN KEY ("entity_id") REFERENCES "tenants"."entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."shareholding" ADD CONSTRAINT "shareholding_fkey_shareholer_entity" FOREIGN KEY ("shareholer_entity_id") REFERENCES "tenants"."entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."shareholding_validity" ADD CONSTRAINT "shareholding_validity_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."shareholding_validity" ADD CONSTRAINT "shareholding_validity_fkey_shareholding" FOREIGN KEY ("shareholding_id") REFERENCES "tenants"."shareholding"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."subsidiary" ADD CONSTRAINT "subsidiary_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."subsidiary" ADD CONSTRAINT "subsidiary_fkey_entity" FOREIGN KEY ("entity_id") REFERENCES "tenants"."entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."subsidiary" ADD CONSTRAINT "subsidiary_fkey_parent_entity" FOREIGN KEY ("parent_entity_id") REFERENCES "tenants"."entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."subsidiary_validity" ADD CONSTRAINT "subsidiary_validity_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."subsidiary_validity" ADD CONSTRAINT "subsidiary_validity_fkey_subsidiary" FOREIGN KEY ("subsidiary_id") REFERENCES "tenants"."subsidiary"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."branch" ADD CONSTRAINT "branch_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."branch" ADD CONSTRAINT "branch_fkey_entity" FOREIGN KEY ("entity_id") REFERENCES "tenants"."entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."branch" ADD CONSTRAINT "branch_fkey_parent" FOREIGN KEY ("parent_id") REFERENCES "tenants"."branch"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."branch" ADD CONSTRAINT "branch_fkey_position" FOREIGN KEY ("position_id") REFERENCES "tenants"."position"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."branch" ADD CONSTRAINT "branch_fkey_subsidiary" FOREIGN KEY ("subsidiary_id") REFERENCES "tenants"."subsidiary"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."identity_document_by_entity_by_branch" ADD CONSTRAINT "identity_document_by_entity_by_branch_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."identity_document_by_entity_by_branch" ADD CONSTRAINT "identity_document_by_entity_by_branch_fkey_branch" FOREIGN KEY ("branch_id") REFERENCES "tenants"."branch"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."identity_document_by_entity_by_branch" ADD CONSTRAINT "identity_document_by_entity_by_branch_fkey_ident_doc_by_ent" FOREIGN KEY ("identity_document_by_entity_id") REFERENCES "tenants"."identity_document_by_entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."entity_address_by_branch" ADD CONSTRAINT "entity_address_by_branch_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."entity_address_by_branch" ADD CONSTRAINT "entity_address_by_branch_fkey_branch" FOREIGN KEY ("branch_id") REFERENCES "tenants"."branch"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."entity_address_by_branch" ADD CONSTRAINT "entity_address_by_branch_fkey_entity_address" FOREIGN KEY ("entity_address_id") REFERENCES "tenants"."entity_address"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."phone_by_entity_by_branch" ADD CONSTRAINT "phone_by_entity_by_branch_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."phone_by_entity_by_branch" ADD CONSTRAINT "phone_by_entity_by_branch_fkey_branch" FOREIGN KEY ("branch_id") REFERENCES "tenants"."branch"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."phone_by_entity_by_branch" ADD CONSTRAINT "phone_by_entity_by_branch_fkey_phone_by_entity" FOREIGN KEY ("phone_by_entity_id") REFERENCES "tenants"."phone_by_entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."email_by_entity_by_branch" ADD CONSTRAINT "email_by_entity_by_branch_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."email_by_entity_by_branch" ADD CONSTRAINT "email_by_entity_by_branch_fkey_branch" FOREIGN KEY ("branch_id") REFERENCES "tenants"."branch"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."email_by_entity_by_branch" ADD CONSTRAINT "email_by_entity_by_branch_fkey_email_by_entity" FOREIGN KEY ("email_by_entity_id") REFERENCES "tenants"."email_by_entity"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tenants"."attached_documents" ADD CONSTRAINT "attached_documents_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "osbs"."source_type_verification_method_validity" ADD CONSTRAINT "source_type_verification_method_validity_fkey_source_type_verif" FOREIGN KEY ("source_type_verification_method_id") REFERENCES "osbs"."source_type_verification_method"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "osbs"."registration" ADD CONSTRAINT "registration_fkey_registration_source" FOREIGN KEY ("registration_source_id") REFERENCES "osbs"."registration_source"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "osbs"."registration_source_verification" ADD CONSTRAINT "registration_source_verification_fkey_registration" FOREIGN KEY ("registration_id") REFERENCES "osbs"."registration"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "osbs"."registration_source_verification" ADD CONSTRAINT "registration_source_verification_fkey_source_type_verification_" FOREIGN KEY ("source_type_verification_method_id") REFERENCES "osbs"."source_type_verification_method"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "osbs"."system_subscription_registration" ADD CONSTRAINT "system_subscription_registration_fkey_system_subscription" FOREIGN KEY ("system_subscription_id") REFERENCES "osbs"."system_subscription"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "osbs"."system_subscription_registration" ADD CONSTRAINT "system_subscription_registration_fkey_registration" FOREIGN KEY ("registration_id") REFERENCES "osbs"."registration"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "audit_log_idx_table_record" ON "osbs"."audit_log" USING btree ("record_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "audit_log_idx_table_table_record" ON "osbs"."audit_log" USING btree ("table_name" text_ops,"record_id" text_ops);--> statement-breakpoint
CREATE INDEX "subregion_idx_region" ON "osbs"."subregion" USING btree ("region_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "country_idx_region" ON "osbs"."country" USING btree ("region_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "country_idx_subregion" ON "osbs"."country" USING btree ("subregion_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "state_idx_country" ON "osbs"."state" USING btree ("country_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "city_idx_country" ON "osbs"."city" USING btree ("country_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "system_subscription_validity_idx_system_subscription" ON "osbs"."system_subscription_validity" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "phone_idx_state" ON "osbs"."phone" USING btree ("state_id" uuid_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "phone_uq_idx_phone" ON "osbs"."phone" USING btree ("phone" text_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "system_client_uq_idx_name" ON "osbs"."system_client" USING btree ("name" text_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "email_uq_idx_email" ON "osbs"."email" USING btree ("email" text_ops);--> statement-breakpoint
CREATE INDEX "audit_log_idx_record" ON "tenants"."audit_log" USING btree ("record_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "audit_log_idx_session" ON "tenants"."audit_log" USING btree ("session_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "audit_log_idx_system_subscription" ON "tenants"."audit_log" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "audit_log_idx_table_record" ON "tenants"."audit_log" USING btree ("table_name" uuid_ops,"record_id" text_ops);--> statement-breakpoint
CREATE INDEX "audit_log_idx_user_access" ON "tenants"."audit_log" USING btree ("user_access_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "system_subscription_owner_idx_entity" ON "tenants"."system_subscription_owner" USING btree ("entity_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "system_subscription_client_idx_system_client" ON "tenants"."system_subscription_client" USING btree ("system_client_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "user_access_idx_email_by_entity" ON "tenants"."user_access" USING btree ("email_by_entity_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "user_access_idx_system_subscription" ON "tenants"."user_access" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "user_access_validity_idx_system_subscription" ON "tenants"."user_access_validity" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "user_access_validity_idx_user_access" ON "tenants"."user_access_validity" USING btree ("user_access_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "session_idx_system_subscription" ON "tenants"."session" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "session_idx_user_access" ON "tenants"."session" USING btree ("user_access_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "recovery_password_idx_system_subscription" ON "tenants"."recovery_password" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "recovery_password_idx_user_access" ON "tenants"."recovery_password" USING btree ("user_access_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "recovery_password_notify_idx_recovery_password" ON "tenants"."recovery_password_notify" USING btree ("recovery_password_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "recovery_password_notify_idx_system_subscription" ON "tenants"."recovery_password_notify" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "entity_idx_fusion_master_entity" ON "tenants"."entity" USING btree ("fusion_master_entity_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "entity_idx_system_subscription" ON "tenants"."entity" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "natural_entity_idx_natural_entity_gender" ON "tenants"."natural_entity" USING btree ("natural_entity_gender_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "natural_entity_idx_system_subscription" ON "tenants"."natural_entity" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "identity_document_category_idx_city" ON "tenants"."identity_document_category" USING btree ("city_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "identity_document_category_idx_country" ON "tenants"."identity_document_category" USING btree ("country_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "identity_document_category_idx_parent" ON "tenants"."identity_document_category" USING btree ("parent_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "identity_document_category_idx_region" ON "tenants"."identity_document_category" USING btree ("region_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "identity_document_category_idx_state" ON "tenants"."identity_document_category" USING btree ("state_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "identity_document_category_idx_subregion" ON "tenants"."identity_document_category" USING btree ("subregion_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "identity_document_idx_system_subscription" ON "tenants"."identity_document" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "identity_document_by_entity_idx_identity_document" ON "tenants"."identity_document_by_entity" USING btree ("identity_document_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "identity_document_by_entity_idx_system_subscription" ON "tenants"."identity_document_by_entity" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "entity_name_by_entity_idx_entity_name" ON "tenants"."entity_name_by_entity" USING btree ("entity_name_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "entity_name_by_entity_idx_entity_name_type" ON "tenants"."entity_name_by_entity" USING btree ("entity_name_type_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "entity_name_by_entity_idx_system_subscription" ON "tenants"."entity_name_by_entity" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "entity_address_idx_system_subscription" ON "tenants"."entity_address" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "phone_by_entity_idx_entity" ON "tenants"."phone_by_entity" USING btree ("entity_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "phone_by_entity_idx_system_subscription" ON "tenants"."phone_by_entity" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "recovery_password_notify_idx_phone_by_entity" ON "tenants"."phone_by_entity" USING btree ("id" uuid_ops);--> statement-breakpoint
CREATE INDEX "email_by_entity_idx_entity" ON "tenants"."email_by_entity" USING btree ("entity_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "email_by_entity_idx_system_subscription" ON "tenants"."email_by_entity" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "recovery_password_notify_idx_email_by_entity" ON "tenants"."email_by_entity" USING btree ("id" uuid_ops);--> statement-breakpoint
CREATE INDEX "department_idx_parent" ON "tenants"."department" USING btree ("parent_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "department_idx_system_subscription" ON "tenants"."department" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "job_family_idx_system_subscription" ON "tenants"."job_family" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "position_idx_department" ON "tenants"."position" USING btree ("department_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "position_idx_job_family" ON "tenants"."position" USING btree ("job_family_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "position_idx_parent" ON "tenants"."position" USING btree ("parent_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "position_idx_system_subscription" ON "tenants"."position" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "employee_idx_system_subscription" ON "tenants"."employee" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "employee_validity_idx_employee" ON "tenants"."employee_validity" USING btree ("employee_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "employee_validity_idx_system_subscription" ON "tenants"."employee_validity" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "employee_per_position_idx_position" ON "tenants"."employee_per_position" USING btree ("position_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "employee_per_position_idx_system_subscription" ON "tenants"."employee_per_position" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "employee_per_position_uq_idx_active_position" ON "tenants"."employee_per_position" USING btree ("position_id" uuid_ops) WHERE (is_active = true);--> statement-breakpoint
CREATE INDEX "employee_per_position_validity_idx_employee_per_position" ON "tenants"."employee_per_position_validity" USING btree ("employee_per_position_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "employee_per_position_validity_idx_system_subscription" ON "tenants"."employee_per_position_validity" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "shareholding_idx_shareholer_entity" ON "tenants"."shareholding" USING btree ("shareholer_entity_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "shareholding_idx_system_subscription" ON "tenants"."shareholding" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "shareholding_validity_idx_shareholding" ON "tenants"."shareholding_validity" USING btree ("shareholding_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "shareholding_validity_idx_system_subscription" ON "tenants"."shareholding_validity" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "subsidiary_idx_parent_entity" ON "tenants"."subsidiary" USING btree ("parent_entity_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "subsidiary_idx_system_subscription" ON "tenants"."subsidiary" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "subsidiary_validity_idx_subsidiary" ON "tenants"."subsidiary_validity" USING btree ("subsidiary_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "subsidiary_validity_idx_system_subscription" ON "tenants"."subsidiary_validity" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "branch_idx_parent" ON "tenants"."branch" USING btree ("parent_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "branch_idx_position" ON "tenants"."branch" USING btree ("position_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "branch_idx_subsidiary" ON "tenants"."branch" USING btree ("subsidiary_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "branch_idx_system_subscription" ON "tenants"."branch" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "identity_document_by_entity_by_branch_idx_ident_doc_by_ent" ON "tenants"."identity_document_by_entity_by_branch" USING btree ("identity_document_by_entity_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "identity_document_by_entity_by_branch_idx_system_subscription" ON "tenants"."identity_document_by_entity_by_branch" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "entity_address_by_branch_idx_entity_address" ON "tenants"."entity_address_by_branch" USING btree ("entity_address_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "entity_address_by_branch_idx_system_subscription" ON "tenants"."entity_address_by_branch" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "phone_by_entity_by_branch_idx_phone_by_entity" ON "tenants"."phone_by_entity_by_branch" USING btree ("phone_by_entity_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "phone_by_entity_by_branch_idx_system_subscription" ON "tenants"."phone_by_entity_by_branch" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "email_by_entity_by_branch_idx_email_by_entity" ON "tenants"."email_by_entity_by_branch" USING btree ("email_by_entity_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "email_by_entity_by_branch_idx_system_subscription" ON "tenants"."email_by_entity_by_branch" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "attached_documents_idx_origin" ON "tenants"."attached_documents" USING btree ("origin_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "attached_documents_idx_origin_table" ON "tenants"."attached_documents" USING btree ("origin_table" text_ops);--> statement-breakpoint
CREATE INDEX "attached_documents_idx_system_subscription" ON "tenants"."attached_documents" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "attached_documents_uq_idx_document_name" ON "tenants"."attached_documents" USING btree ("document_name" text_ops);--> statement-breakpoint
CREATE INDEX "source_type_verification_method_idx_name" ON "osbs"."source_type_verification_method" USING btree ("name" text_ops);--> statement-breakpoint
CREATE INDEX "source_type_verification_method_validity_idx_source_type_verifi" ON "osbs"."source_type_verification_method_validity" USING btree ("source_type_verification_method_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "registration_source_idx_source" ON "osbs"."registration_source" USING btree ("source" text_ops);--> statement-breakpoint
CREATE INDEX "registration_idx_ip_address" ON "osbs"."registration" USING btree ("ip_address" inet_ops);--> statement-breakpoint
CREATE INDEX "registration_source_verification_idx_registration" ON "osbs"."registration_source_verification" USING btree ("registration_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "registration_source_verification_idx_source_type_verification_m" ON "osbs"."registration_source_verification" USING btree ("source_type_verification_method_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "system_subscription_registration_idx_registration" ON "osbs"."system_subscription_registration" USING btree ("registration_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "system_subscription_registration_idx_system_subscription" ON "osbs"."system_subscription_registration" USING btree ("system_subscription_id" uuid_ops);--> statement-breakpoint
CREATE VIEW "osbs"."view_entity_master" AS (WITH RECURSIVE entity_master AS ( SELECT ent.id AS root_id, ent.id AS entity_id, ent.system_subscription_id, ent.is_natural, ent.identity_document, ent.name, ent.created_at, ent.updated_at, ent.annulled_at, ent.deleted_at FROM tenants.entity ent WHERE ent.fusion_master_entity_id IS NULL AND ent.annulled_at IS NULL UNION ALL SELECT ent.id AS root_id, mas.entity_id, mas.system_subscription_id, mas.is_natural, mas.identity_document, mas.name, mas.created_at, mas.updated_at, mas.annulled_at, mas.deleted_at FROM tenants.entity ent JOIN entity_master mas ON mas.entity_id = ent.fusion_master_entity_id AND mas.annulled_at IS NULL AND ent.annulled_at IS NULL ) SELECT root_id, entity_id, system_subscription_id, is_natural, identity_document, name, created_at, updated_at, annulled_at, deleted_at FROM entity_master);--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."audit_log" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."system_subscription_owner" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."system_subscription_client" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."user_access" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."user_access_validity" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."session" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."recovery_password" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."recovery_password_notify" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."entity" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."natural_entity_gender" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."natural_entity" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."identity_document_category" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."identity_document" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."identity_document_by_entity" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."entity_name_type" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."entity_name" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."entity_name_by_entity" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."entity_address" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."phone_by_entity" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."email_by_entity" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."department" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."job_family" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."position" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."employee" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."employee_validity" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."employee_per_position" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."employee_per_position_validity" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."shareholding" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."shareholding_validity" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."subsidiary" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."subsidiary_validity" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."branch" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."identity_document_by_entity_by_branch" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."entity_address_by_branch" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."phone_by_entity_by_branch" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."email_by_entity_by_branch" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));--> statement-breakpoint
CREATE POLICY "tenant_isolation" ON "tenants"."attached_documents" AS PERMISSIVE FOR ALL TO public USING ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid)) WITH CHECK ((system_subscription_id = (current_setting('app.current_system_subscription_id'::text))::uuid));
*/