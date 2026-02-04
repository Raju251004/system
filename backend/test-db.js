const { Client } = require('pg');

const config = {
  host: 'localhost',
  port: 5432,
  user: 'postgres',
  password: 'Mass',
  database: 'postgres', // Connect to default DB first
};

async function checkAndCreate() {
  const client = new Client(config);

  try {
    console.log('Connecting to PostgreSQL...');
    await client.connect();
    console.log('Connected successfully!');

    // Check if solo_system exists
    const res = await client.query("SELECT 1 FROM pg_database WHERE datname = 'solo_system'");
    if (res.rowCount === 0) {
      console.log('Database "solo_system" not found. Creating...');
      await client.query('CREATE DATABASE solo_system');
      console.log('Database "solo_system" created.');
    } else {
      console.log('Database "solo_system" already exists.');
    }

  } catch (err) {
    console.error('Connection error:', err.message);
    if (err.code === '28P01') {
      console.error('Authentication failed. Check password.');
    } else if (err.code === 'ECONNREFUSED') {
      console.error('Connection refused. Is PostgreSQL running on port 5432?');
    }
  } finally {
    await client.end();
  }
}

checkAndCreate();
