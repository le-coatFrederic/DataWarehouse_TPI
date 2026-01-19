/*
 * Script Purpose:
 * ===============
 * This script initializes the Data Warehouse TPI (dwh_tpi) database in PostgreSQL.
 * It creates the main database and three core schemas (bronze, silver, gold)
 * following the medallion architecture pattern.
 *
 * Warnings:
 * =========
 * 1. DESTRUCTIVE OPERATION: This script will DROP the existing dwh_tpi database
 *    if it exists. All data will be permanently deleted. Use with caution in production.
 *
 * 2. DATABASE CONNECTIONS: Ensure no active connections exist to dwh_tpi before running,
 *    as DROP DATABASE will fail if the database is in use.
 *
 * 3. PRIVILEGES: This script requires superuser or database owner privileges.
 *
 * 4. CONTEXT SWITCH: This script does not change the default database context.
 *    Future commands must explicitly specify the database with -d dwh_tpi flag.
 */

-- Drop database if it exists and create it fresh
DROP DATABASE IF EXISTS dwh_tpi;
CREATE DATABASE dwh_tpi;

-- Create schemas
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;

