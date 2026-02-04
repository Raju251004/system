const { Client } = require('pg');

const passwords = ['shadowcoders', 'postgres', 'password', '123456', 'root', 'admin', ''];
const ports = [5432, 5433, 5434, 5435];
const user = 'postgres';

async function testConnection(port, password) {
    const client = new Client({
        host: 'localhost',
        port: port,
        user: user,
        password: password,
        database: 'postgres',
        connectionTimeoutMillis: 2000,
    });

    try {
        await client.connect();
        console.log(`SUCCESS: Connected on port ${port} with password '${password}'`);
        await client.end();
        return { port, password };
    } catch (err) {
        // console.log(`Failed on port ${port} with password '${password}': ${err.message}`);
        await client.end();
        return null;
    }
}

async function findWorkingConfig() {
    console.log('Searching for working PostgreSQL configuration...');

    for (const port of ports) {
        for (const password of passwords) {
            const result = await testConnection(port, password);
            if (result) {
                console.log('FOUND:', JSON.stringify(result));
                return;
            }
        }
    }
    console.log('No working configuration found.');
}

findWorkingConfig();
