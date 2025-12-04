#!/usr/bin/env python
"""Test PostgreSQL connection"""
import os
import sys

# Try psycopg2 first
try:
    import psycopg2
    print("✓ psycopg2 is installed")
    has_psycopg2 = True
except ImportError:
    print("✗ psycopg2 is NOT installed")
    has_psycopg2 = False

# Try psycopg3
try:
    import psycopg
    print("✓ psycopg (v3) is installed")
    has_psycopg3 = True
except ImportError:
    print("✗ psycopg (v3) is NOT installed")
    has_psycopg3 = False

if not has_psycopg2 and not has_psycopg3:
    print("\nNo PostgreSQL adapter found!")
    print("Please install one of:")
    print("  pip install psycopg2-binary")
    print("  pip install psycopg[binary]")
    sys.exit(1)

# Test connection
print("\nTesting connection to PostgreSQL...")
try:
    if has_psycopg2:
        conn = psycopg2.connect(
            host='localhost',
            port='5432',
            user='postgres',
            password='postgres',
            database='postgres'
        )
    else:
        conn = psycopg.connect(
            host='localhost',
            port='5432',
            user='postgres',
            password='postgres',
            dbname='postgres'
        )
    
    conn.close()
    print("✓ Connection successful!")
    
    # Check if database exists
    if has_psycopg2:
        conn = psycopg2.connect(
            host='localhost',
            port='5432',
            user='postgres',
            password='postgres',
            database='postgres'
        )
        conn.set_isolation_level(psycopg2.extensions.ISOLATION_LEVEL_AUTOCOMMIT)
        cur = conn.cursor()
        cur.execute("SELECT 1 FROM pg_database WHERE datname='testapp_db'")
        exists = cur.fetchone()
        
        if not exists:
            cur.execute('CREATE DATABASE testapp_db')
            print("✓ Database 'testapp_db' created!")
        else:
            print("✓ Database 'testapp_db' already exists")
        
        cur.close()
        conn.close()
    
except Exception as e:
    print(f"✗ Connection failed: {e}")
    sys.exit(1)

print("\n✓ PostgreSQL is ready!")



