-- Drop Views
DROP VIEW IF EXISTS category_with_vehicle_count;
DROP VIEW IF EXISTS sub_category_with_vehicle_count;
DROP VIEW IF EXISTS stock_with_left_quantity;

-- Drop Triggers
DROP TRIGGER IF EXISTS on_auth_users_register ON auth.users;

-- Drop Functions
DROP FUNCTION IF EXISTS public.handle_new_user();

-- Drop Tables
DROP TABLE IF EXISTS public.job_cards_transactions;
DROP TABLE IF EXISTS public.transactions;
DROP TABLE IF EXISTS public.job_cards;
DROP TABLE IF EXISTS public.vehicles;
DROP TABLE IF EXISTS public.drivers;
DROP TABLE IF EXISTS public.stocks;
DROP TABLE IF EXISTS public.file_procurements;
DROP TABLE IF EXISTS public.vendors;
DROP TABLE IF EXISTS public.measurement_units;
DROP TABLE IF EXISTS public.stock_types;
DROP TABLE IF EXISTS public.brands;
DROP TABLE IF EXISTS public.sub_categories;
DROP TABLE IF EXISTS public.categories;
DROP TABLE IF EXISTS public.users;

-- Drop ENUMs
DROP TYPE IF EXISTS public."UserType";
DROP TYPE IF EXISTS public."GLType";
DROP TYPE IF EXISTS public."TrxType";

-- Drop Storage Policies
DROP POLICY IF EXISTS "Public can select avatar images" ON storage.objects;
DROP POLICY IF EXISTS "Public can upload avatar images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can update avatar images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can delete avatar images" ON storage.objects;
DROP POLICY IF EXISTS "Public can select attachment files" ON storage.objects;
DROP POLICY IF EXISTS "Public can upload attachment files" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can update attachment files" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can delete attachment files" ON storage.objects;

-- Drop Storage Buckets
DELETE FROM storage.buckets WHERE id IN ('avatars', 'attachments');

-- ==========================================
-- ENUM DEFINITIONS
-- ==========================================
CREATE TYPE public."UserType" AS ENUM ('Admin', 'Manager', 'Operator', 'Dispose');
CREATE TYPE public."GLType" AS ENUM ('FileProcurement', 'Stock', 'Vehicle');
CREATE TYPE public."TrxType" AS ENUM ('Debit', 'Credit');

-- ==========================================
-- TABLE DEFINITIONS
-- ==========================================

-- Users Table
create table public.users (
    id uuid not null default auth.uid(),
    email text not null,
    name text not null,
    phone text not null,
    role public."UserType" not null,
    avatar text null,
    created timestamp with time zone not null default (now() at time zone 'utc'::text),
    updated timestamp with time zone not null default (now() at time zone 'utc'::text),
    constraint users_pkey primary key (id),
    constraint users_email_key unique (email),
    constraint users_id_fkey foreign key (id) references auth.users (id) on update cascade on delete cascade
) tablespace pg_default;

-- Categories Table
create table public.categories (
    id uuid not null default gen_random_uuid(),
    name text not null,
    creator uuid not null default auth.uid(),
    created timestamp with time zone not null default (now() at time zone 'utc'::text),
    updater uuid not null default auth.uid(),
    updated timestamp with time zone not null default (now() at time zone 'utc'::text),
    constraint category_pkey primary key (id),
    constraint category_creator_fkey foreign key (creator) references users (id) on update cascade on delete cascade,
    constraint category_updater_fkey foreign key (updater) references users (id) on update cascade on delete cascade
) tablespace pg_default;

-- Sub Categories Table
create table public.sub_categories (
    id uuid not null default gen_random_uuid(),
    parent uuid not null,
    name text not null,
    creator uuid not null default auth.uid(),
    created timestamp with time zone not null default (now() at time zone 'utc'::text),
    updater uuid not null default auth.uid(),
    updated timestamp with time zone not null default (now() at time zone 'utc'::text),
    constraint sub_category_pkey primary key (id),
    constraint sub_category_creator_fkey foreign key (creator) references users (id) on update cascade on delete cascade,
    constraint sub_category_parent_fkey foreign key (parent) references categories (id) on update cascade on delete cascade,
    constraint sub_category_updater_fkey foreign key (updater) references users (id) on update cascade on delete cascade
) tablespace pg_default;

-- Brands Table
create table public.brands (
    id uuid not null default gen_random_uuid(),
    name text not null,
    creator uuid not null default auth.uid(),
    created timestamp with time zone not null default (now() at time zone 'utc'::text),
    updater uuid not null default auth.uid(),
    updated timestamp with time zone not null default (now() at time zone 'utc'::text),
    constraint brand_pkey primary key (id),
    constraint brand_creator_fkey foreign key (creator) references users (id) on update cascade on delete cascade,
    constraint brand_updater_fkey foreign key (updater) references users (id) on update cascade on delete cascade
) tablespace pg_default;

-- Stock Types Table
create table public.stock_types (
    id uuid not null default gen_random_uuid(),
    name text not null,
    lifetime bigint not null default '1'::bigint,
    creator uuid not null default auth.uid(),
    created timestamp with time zone not null default (now() at time zone 'utc'::text),
    updater uuid not null default auth.uid(),
    updated timestamp with time zone not null default (now() at time zone 'utc'::text),
    constraint stock_types_pkey primary key (id),
    constraint stock_types_creator_fkey foreign key (creator) references users (id) on update cascade on delete cascade,
    constraint stock_types_updater_fkey foreign key (updater) references users (id) on update cascade on delete cascade
) tablespace pg_default;

-- Measurement Units Table
create table public.measurement_units (
    id uuid not null default gen_random_uuid(),
    name text not null,
    creator uuid not null default auth.uid(),
    created timestamp with time zone not null default (now() at time zone 'utc'::text),
    updater uuid not null default auth.uid(),
    updated timestamp with time zone not null default (now() at time zone 'utc'::text),
    constraint measurement_units_pkey primary key (id),
    constraint measurement_units_creator_fkey foreign key (creator) references users (id) on update cascade on delete cascade,
    constraint measurement_units_updater_fkey foreign key (updater) references users (id) on update cascade on delete cascade
) tablespace pg_default;

-- Vendors Table
create table public.vendors (
    id uuid not null default gen_random_uuid(),
    name text not null,
    phone text not null,
    email text null,
    address text null,
    "identificationNo" text null,
    description text null,
    "isCompany" boolean not null default true,
    creator uuid not null default auth.uid(),
    created timestamp with time zone not null default (now() at time zone 'utc'::text),
    updater uuid not null default auth.uid(),
    updated timestamp with time zone not null default (now() at time zone 'utc'::text),
    constraint vendors_pkey primary key (id),
    constraint vendors_creator_fkey foreign key (creator) references users (id) on update cascade on delete cascade,
    constraint vendors_updater_fkey foreign key (updater) references users (id) on update cascade on delete cascade
) tablespace pg_default;

-- File Procurements Table
create table public.file_procurements (
    id uuid not null default gen_random_uuid(),
    "docId" text not null,
    vendor uuid not null default gen_random_uuid(),
    description text null,
    creator uuid not null,
    created timestamp with time zone not null default (now() at time zone 'utc'::text),
    updater uuid not null,
    updated timestamp with time zone not null default (now() at time zone 'utc'::text),
    constraint file_procurements_pkey primary key (id),
    constraint file_procurements_creator_fkey foreign key (creator) references users (id) on update cascade on delete cascade,
    constraint file_procurements_updater_fkey foreign key (updater) references users (id) on update cascade on delete cascade,
    constraint file_procurements_vendor_fkey foreign key (vendor) references vendors (id) on update cascade on delete cascade
) tablespace pg_default;

-- Stocks Table
create table public.stocks (
    id uuid not null default gen_random_uuid(),
    title text not null,
    specification text null,
    brand text null,
    quantity bigint not null,
    unit uuid not null,
    "unitPrice" double precision not null,
    "stockType" uuid not null,
    "subCategory" uuid null,
    "fileProcurement" uuid not null,
    description text null,
    creator uuid not null default auth.uid(),
    created timestamp with time zone not null default (now() at time zone 'utc'::text),
    updater uuid not null default auth.uid(),
    updated timestamp with time zone not null default (now() at time zone 'utc'::text),
    constraint stocks_pkey primary key (id),
    constraint stocks_fileProcurement_fkey foreign key ("fileProcurement") references file_procurements (id) on update cascade on delete cascade,
    constraint stocks_creator_fkey foreign key (creator) references users (id) on update cascade on delete cascade,
    constraint stocks_subCategory_fkey foreign key ("subCategory") references sub_categories (id) on update cascade on delete cascade,
    constraint stocks_unit_fkey foreign key (unit) references measurement_units (id) on update cascade on delete cascade,
    constraint stocks_updater_fkey foreign key (updater) references users (id) on update cascade on delete cascade,
    constraint stocks_stockType_fkey foreign key ("stockType") references stock_types (id) on update cascade on delete cascade
) tablespace pg_default;

-- Drivers Table
create table public.drivers (
    id uuid not null default gen_random_uuid(),
    name text not null,
    phone text not null,
    address text null,
    "identificationNo" text null,
    description text null,
    creator uuid not null default auth.uid(),
    created timestamp with time zone not null default (now() at time zone 'utc'::text),
    updater uuid not null default auth.uid(),
    updated timestamp with time zone not null default (now() at time zone 'utc'::text),
    constraint drivers_pkey primary key (id),
    constraint drivers_creator_fkey foreign key (creator) references users (id) on update cascade on delete cascade,
    constraint drivers_updater_fkey foreign key (updater) references users (id) on update cascade on delete cascade
) tablespace pg_default;

-- Vehicles Table
create table public.vehicles (
    id uuid not null default gen_random_uuid(),
    parent uuid not null,
    brand uuid not null,
    model text null,
    "registrationNo" text not null,
    "engineNo" text null,
    "chassisNo" text null,
    capacity text null,
    "countryOfManufacture" text null,
    "purchaseValue" text null,
    "sourceOfFund" text null,
    "yearOfPurchase" text null,
    driver uuid null,
    description text null,
    creator uuid not null default auth.uid(),
    created timestamp with time zone not null default (now() at time zone 'utc'::text),
    updater uuid not null default auth.uid(),
    updated timestamp with time zone not null default (now() at time zone 'utc'::text),
    constraint vehicles_pkey primary key (id),
    constraint vehicles_brand_fkey foreign key (brand) references brands (id) on update cascade on delete cascade,
    constraint vehicles_creator_fkey foreign key (creator) references users (id) on update cascade on delete cascade,
    constraint vehicles_driver_fkey foreign key (driver) references drivers (id) on update cascade on delete cascade,
    constraint vehicles_parent_fkey foreign key (parent) references sub_categories (id) on update cascade on delete cascade,
    constraint vehicles_updater_fkey foreign key (updater) references users (id) on update cascade on delete cascade
) tablespace pg_default;

-- Job Cards Table
create table public.job_cards (
    id uuid not null default gen_random_uuid(),
    "jobCardNo" text not null,
    "requisitionNo" text null,
    "workCompleteDateTime" timestamp with time zone null,
    "isFramework" boolean not null default false,
    vehicle uuid not null,
    description text null,
    "isAccepted" boolean not null default false,
    creator uuid not null default auth.uid(),
    created timestamp with time zone not null default (now() at time zone 'utc'::text),
    updater uuid not null default auth.uid(),
    updated timestamp with time zone not null default (now() at time zone 'utc'::text),
    constraint job_cards_pkey primary key (id),
    constraint job_cards_creator_fkey foreign key (creator) references users (id) on update cascade on delete cascade,
    constraint job_cards_updater_fkey foreign key (updater) references users (id) on update cascade on delete cascade,
    constraint job_cards_vehicle_fkey foreign key (vehicle) references vehicles (id) on update cascade on delete cascade
) tablespace pg_default;

-- Transactions Table
create table public.transactions (
    id uuid not null default gen_random_uuid(),
    "fromType" public."GLType" not null,
    "toType" public."GLType" not null,
    amount double precision not null,
    unit uuid not null,
    "trxType" public."TrxType" not null,
    voucher text null,
    description text null,
    "isActive" boolean not null default true,
    "isSystemGenerated" boolean not null default false,
    attachment text null,
    "fileProcurement" uuid null,
    stock uuid null,
    vehicle uuid null,
    "vendorId" text not null default 'no-id'::text,
    "fileProcurementId" text not null default 'no-id'::text,
    "stockId" text not null default 'no-id'::text,
    "vehicleId" text not null default 'no-id'::text,
    "jobCardId" text not null default 'no-id'::text,
    creator uuid not null default auth.uid(),
    created timestamp with time zone not null default (now() at time zone 'utc'::text),
    updater uuid not null default auth.uid(),
    updated timestamp with time zone not null default (now() at time zone 'utc'::text),
    constraint transactions_pkey primary key (id),
    constraint transactions_fileProcurement_fkey foreign key ("fileProcurement") references file_procurements (id) on update cascade on delete cascade,
    constraint transactions_creator_fkey foreign key (creator) references users (id) on update cascade on delete cascade,
    constraint transactions_unit_fkey foreign key (unit) references measurement_units (id) on update cascade on delete cascade,
    constraint transactions_updater_fkey foreign key (updater) references users (id) on update cascade on delete cascade,
    constraint transactions_vehicle_fkey foreign key (vehicle) references vehicles (id) on update cascade on delete cascade,
    constraint transactions_stock_fkey foreign key (stock) references stocks (id) on update cascade on delete cascade
) tablespace pg_default;

-- Job Cards Transactions Table
create table public.job_cards_transactions (
    id uuid not null default gen_random_uuid(),
    "jobCard" uuid not null,
    transaction uuid not null,
    constraint job_card_transactions_pkey primary key (id),
    constraint job_card_transactions_jobCard_fkey foreign key ("jobCard") references job_cards (id) on update cascade on delete cascade,
    constraint job_card_transactions_transaction_fkey foreign key (transaction) references transactions (id) on update cascade on delete cascade
) tablespace pg_default;

-- ==========================================
-- ROW LEVEL SECURITY (RLS) CONFIGURATION
-- ==========================================

-- Enable RLS for all tables
ALTER TABLE public.brands ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.drivers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.file_procurements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.job_cards ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.job_cards_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.measurement_units ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stock_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stocks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sub_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vehicles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vendors ENABLE ROW LEVEL SECURITY;

-- ==========================================
-- RLS POLICIES
-- ==========================================

-- Brands Table Policy
CREATE POLICY "all_policy" on "public"."brands" 
    AS PERMISSIVE FOR ALL TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "delete_policy" on "public"."brands" 
    AS PERMISSIVE FOR DELETE TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "insert_policy" on "public"."brands" 
    AS PERMISSIVE FOR INSERT TO public 
    WITH CHECK ((auth.uid() IS NOT NULL));
CREATE POLICY "select_policy" on "public"."brands" 
    AS PERMISSIVE FOR SELECT TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "update_policy" on "public"."brands" 
    AS PERMISSIVE FOR UPDATE TO public 
    USING ((auth.uid() IS NOT NULL));

-- Categories Table Policy
CREATE POLICY "all_policy" on "public"."categories" 
    AS PERMISSIVE FOR ALL TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "delete_policy" on "public"."categories" 
    AS PERMISSIVE FOR DELETE TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "insert_policy" on "public"."categories" 
    AS PERMISSIVE FOR INSERT TO public 
    WITH CHECK ((auth.uid() IS NOT NULL));
CREATE POLICY "select_policy" on "public"."categories" 
    AS PERMISSIVE FOR SELECT TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "update_policy" on "public"."categories" 
    AS PERMISSIVE FOR UPDATE TO public 
    USING ((auth.uid() IS NOT NULL));

-- Drivers Table Policy
CREATE POLICY "all_policy" on "public"."drivers" 
    AS PERMISSIVE FOR ALL TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "delete_policy" on "public"."drivers"
    AS PERMISSIVE FOR DELETE TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "insert_policy" on "public"."drivers"
    AS PERMISSIVE FOR INSERT TO public 
    WITH CHECK ((auth.uid() IS NOT NULL));
CREATE POLICY "select_policy" on "public"."drivers"
    AS PERMISSIVE FOR SELECT TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "update_policy" on "public"."drivers"
    AS PERMISSIVE FOR UPDATE TO public 
    USING ((auth.uid() IS NOT NULL));

-- File Procurements Table Policy
CREATE POLICY "all_policy" on "public"."file_procurements" 
    AS PERMISSIVE FOR ALL TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "delete_policy" on "public"."file_procurements"
    AS PERMISSIVE FOR DELETE TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "insert_policy" on "public"."file_procurements"
    AS PERMISSIVE FOR INSERT TO public 
    WITH CHECK ((auth.uid() IS NOT NULL));
CREATE POLICY "select_policy" on "public"."file_procurements"
    AS PERMISSIVE FOR SELECT TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "update_policy" on "public"."file_procurements"
    AS PERMISSIVE FOR UPDATE TO public 
    USING ((auth.uid() IS NOT NULL));

-- Job Cards Table Policy
CREATE POLICY "all_policy" on "public"."job_cards" 
    AS PERMISSIVE FOR ALL TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "delete_policy" on "public"."job_cards"
    AS PERMISSIVE FOR DELETE TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "insert_policy" on "public"."job_cards"
    AS PERMISSIVE FOR INSERT TO public 
    WITH CHECK ((auth.uid() IS NOT NULL));
CREATE POLICY "select_policy" on "public"."job_cards"
    AS PERMISSIVE FOR SELECT TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "update_policy" on "public"."job_cards"
    AS PERMISSIVE FOR UPDATE TO public 
    USING ((auth.uid() IS NOT NULL));

-- Job Cards Transactions Table Policy
CREATE POLICY "all_policy" on "public"."job_cards_transactions" 
    AS PERMISSIVE FOR ALL TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "delete_policy" on "public"."job_cards_transactions"
    AS PERMISSIVE FOR DELETE TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "insert_policy" on "public"."job_cards_transactions"
    AS PERMISSIVE FOR INSERT TO public 
    WITH CHECK ((auth.uid() IS NOT NULL));
CREATE POLICY "select_policy" on "public"."job_cards_transactions"
    AS PERMISSIVE FOR SELECT TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "update_policy" on "public"."job_cards_transactions"
    AS PERMISSIVE FOR UPDATE TO public 
    USING ((auth.uid() IS NOT NULL));

-- Measurement Units Table Policy
CREATE POLICY "all_policy" on "public"."measurement_units" 
    AS PERMISSIVE FOR ALL TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "delete_policy" on "public"."measurement_units"
    AS PERMISSIVE FOR DELETE TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "insert_policy" on "public"."measurement_units"
    AS PERMISSIVE FOR INSERT TO public 
    WITH CHECK ((auth.uid() IS NOT NULL));
CREATE POLICY "select_policy" on "public"."measurement_units"
    AS PERMISSIVE FOR SELECT TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "update_policy" on "public"."measurement_units"
    AS PERMISSIVE FOR UPDATE TO public 
    USING ((auth.uid() IS NOT NULL));

-- Stock Types Table Policy
CREATE POLICY "all_policy" on "public"."stock_types" 
    AS PERMISSIVE FOR ALL TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "delete_policy" on "public"."stock_types"
    AS PERMISSIVE FOR DELETE TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "insert_policy" on "public"."stock_types"
    AS PERMISSIVE FOR INSERT TO public 
    WITH CHECK ((auth.uid() IS NOT NULL));
CREATE POLICY "select_policy" on "public"."stock_types"
    AS PERMISSIVE FOR SELECT TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "update_policy" on "public"."stock_types"
    AS PERMISSIVE FOR UPDATE TO public 
    USING ((auth.uid() IS NOT NULL));

-- Stocks Table Policy
CREATE POLICY "all_policy" on "public"."stocks" 
    AS PERMISSIVE FOR ALL TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "delete_policy" on "public"."stocks"
    AS PERMISSIVE FOR DELETE TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "insert_policy" on "public"."stocks"
    AS PERMISSIVE FOR INSERT TO public 
    WITH CHECK ((auth.uid() IS NOT NULL));
CREATE POLICY "select_policy" on "public"."stocks"
    AS PERMISSIVE FOR SELECT TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "update_policy" on "public"."stocks"
    AS PERMISSIVE FOR UPDATE TO public 
    USING ((auth.uid() IS NOT NULL));

-- Sub Categories Table Policy
CREATE POLICY "all_policy" on "public"."sub_categories" 
    AS PERMISSIVE FOR ALL TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "delete_policy" on "public"."sub_categories"
    AS PERMISSIVE FOR DELETE TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "insert_policy" on "public"."sub_categories"
    AS PERMISSIVE FOR INSERT TO public 
    WITH CHECK ((auth.uid() IS NOT NULL));
CREATE POLICY "select_policy" on "public"."sub_categories"
    AS PERMISSIVE FOR SELECT TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "update_policy" on "public"."sub_categories"
    AS PERMISSIVE FOR UPDATE TO public 
    USING ((auth.uid() IS NOT NULL));

-- Transactions Table Policy
CREATE POLICY "all_policy" on "public"."transactions" 
    AS PERMISSIVE FOR ALL TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "delete_policy" on "public"."transactions"
    AS PERMISSIVE FOR DELETE TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "insert_policy" on "public"."transactions"
    AS PERMISSIVE FOR INSERT TO public 
    WITH CHECK ((auth.uid() IS NOT NULL));
CREATE POLICY "select_policy" on "public"."transactions"
    AS PERMISSIVE FOR SELECT TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "update_policy" on "public"."transactions"
    AS PERMISSIVE FOR UPDATE TO public 
    USING ((auth.uid() IS NOT NULL));

-- Users Table Policy
CREATE POLICY "all_policy" on "public"."users" 
    AS PERMISSIVE FOR ALL TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "delete_policy" on "public"."users"
    AS PERMISSIVE FOR DELETE TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "insert_policy" on "public"."users"
    AS PERMISSIVE FOR INSERT TO public 
    WITH CHECK ((auth.uid() IS NOT NULL));
CREATE POLICY "select_policy" on "public"."users"
    AS PERMISSIVE FOR SELECT TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "update_policy" on "public"."users"
    AS PERMISSIVE FOR UPDATE TO public 
    USING ((auth.uid() IS NOT NULL));

-- Vehicles Table Policy
CREATE POLICY "all_policy" on "public"."vehicles" 
    AS PERMISSIVE FOR ALL TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "delete_policy" on "public"."vehicles"
    AS PERMISSIVE FOR DELETE TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "insert_policy" on "public"."vehicles"
    AS PERMISSIVE FOR INSERT TO public 
    WITH CHECK ((auth.uid() IS NOT NULL));
CREATE POLICY "select_policy" on "public"."vehicles"
    AS PERMISSIVE FOR SELECT TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "update_policy" on "public"."vehicles"
    AS PERMISSIVE FOR UPDATE TO public 
    USING ((auth.uid() IS NOT NULL));

-- Vendors Table Policy
CREATE POLICY "all_policy" on "public"."vendors" 
    AS PERMISSIVE FOR ALL TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "delete_policy" on "public"."vendors"
    AS PERMISSIVE FOR DELETE TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "insert_policy" on "public"."vendors"
    AS PERMISSIVE FOR INSERT TO public 
    WITH CHECK ((auth.uid() IS NOT NULL));
CREATE POLICY "select_policy" on "public"."vendors"
    AS PERMISSIVE FOR SELECT TO public 
    USING ((auth.uid() IS NOT NULL));
CREATE POLICY "update_policy" on "public"."vendors"
    AS PERMISSIVE FOR UPDATE TO public 
    USING ((auth.uid() IS NOT NULL));

-- ==========================================
-- USER CONFIGURATION
-- ==========================================

-- Set Default Role for Users Table
ALTER TABLE public.users 
    ALTER COLUMN role 
    SET DEFAULT 'Dispose';

-- User Creation Handler Function
create function public.handle_new_user() 
returns trigger
set search_path = '' as $$
begin
    insert into public.users (
        id, 
        email, 
        name, 
        phone, 
        avatar
    )
    values (
        new.id,
        new.raw_user_meta_data->>'email',
        new.raw_user_meta_data->>'name',
        new.raw_user_meta_data->>'phone',
        new.raw_user_meta_data->>'avatar'
    );
    return new;
end;
$$ language plpgsql security definer;

-- User Registration Trigger
CREATE TRIGGER "on_auth_users_register"
    AFTER INSERT ON auth.users 
    FOR EACH ROW 
    EXECUTE FUNCTION handle_new_user();

-- ==========================================
-- STORAGE CONFIGURATION
-- ==========================================

-- Create Storage Buckets
insert into storage.buckets (id, name)
values 
    ('avatars', 'avatars'),
    ('attachments', 'attachments');

-- Avatar Storage Policies
CREATE POLICY "Public can select avatar images." 
    ON STORAGE.objects FOR SELECT 
    USING (bucket_id = 'avatars');

CREATE POLICY "Public can upload avatar images." 
    ON STORAGE.objects FOR INSERT 
    WITH CHECK (
        bucket_id = 'avatars'
    );

CREATE POLICY "Authenticated users can update avatar images." 
    ON STORAGE.objects FOR UPDATE 
    USING (
        auth.uid() IS NOT NULL
        AND bucket_id = 'avatars'
    );

CREATE POLICY "Authenticated users can delete avatar images." 
    ON STORAGE.objects FOR DELETE 
    USING (
        auth.uid() IS NOT NULL
        AND bucket_id = 'avatars'
    );

-- Attachment Storage Policies
CREATE POLICY "Public can select attachment files." 
    ON STORAGE.objects FOR SELECT 
    USING (bucket_id = 'attachments');

CREATE POLICY "Public can upload attachment files." 
    ON STORAGE.objects FOR INSERT 
    WITH CHECK (
        bucket_id = 'attachments'
    );

CREATE POLICY "Authenticated users can update attachment files." 
    ON STORAGE.objects FOR UPDATE 
    USING (
        auth.uid() IS NOT NULL
        AND bucket_id = 'attachments'
    );

CREATE POLICY "Authenticated users can delete attachment files." 
    ON STORAGE.objects FOR DELETE 
    USING (
        auth.uid() IS NOT NULL
        AND bucket_id = 'attachments'
    );

-- ==========================================
-- FINAL CONFIGURATION
-- ==========================================

-- Enable Database Aggregates
ALTER ROLE authenticator
    SET pgrst.db_aggregates_enabled = 'true';

-- Reload Configuration
NOTIFY pgrst, 'reload config';

-- ==========================================
-- CREATE VIEWS
-- ==========================================

-- Create View for Category
CREATE OR REPLACE VIEW category_with_vehicle_count AS
SELECT 
    c.*,
    COUNT(v.id) AS total_vehicle
FROM 
    categories c
LEFT JOIN 
    sub_categories sc ON sc.parent = c.id
LEFT JOIN 
    vehicles v ON v.parent = sc.id
GROUP BY 
    c.id;

-- Create View for Sub Category
CREATE OR REPLACE VIEW sub_category_with_vehicle_count AS
SELECT 
    sc.*,
    COUNT(v.id) AS total_vehicle
FROM 
    sub_categories sc
LEFT JOIN 
    vehicles v ON v.parent = sc.id
GROUP BY 
    sc.id;

-- Create View for Stock left quantity
CREATE OR REPLACE VIEW stock_with_left_quantity AS
SELECT 
    s.id,
    CAST(s.quantity - COALESCE(SUM(
        CASE 
            WHEN t."trxType" = 'Debit' THEN t.amount
            WHEN t."trxType" = 'Credit' THEN -t.amount
            ELSE 0
        END
    ), 0) AS bigint) AS "left",
    CAST(COALESCE(SUM(
        CASE 
            WHEN t."isActive" = false THEN 
                CASE 
                    WHEN t."trxType" = 'Debit' THEN t.amount
                    WHEN t."trxType" = 'Credit' THEN -t.amount
                    ELSE 0
                END
            ELSE 0
        END
    ), 0) AS bigint) AS "hold"
FROM 
    stocks s
LEFT JOIN 
    transactions t ON t.stock = s.id
GROUP BY 
    s.id;