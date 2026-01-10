const cors = require('cors');
const express = require('express');
const mariadb = require('mariadb');

require('dotenv').config();

const quotesRouter = require('./routes/quotes');
const poemsRouter = require('./routes/poems');

const app = express();
const port = process.env.PORT || 3000;

const pool = mariadb.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    connectionLimit: 10,
    acquireTimeout: 10000,
    idleTimeout: 30000
});

async function getConnection() {
    let conn;
    try {
        conn = await pool.getConnection();
        conn.on('error', async (err) => {
            if (err.code === 'PROTOCOL_CONNECTION_LOST') {
                console.error('Database connection was closed.');
            } else {
                throw err;
            }
        });
    } catch (err) {
        console.error('Error getting a database connection: ', err);
        throw err;
    }
    return conn;
}

app.use(cors());

app.use(express.json());

app.use(async (req, res, next) => {
    try {
        req.dbConn = await getConnection();
        next();
    } catch (err) {
        next(err);
    }
});

app.use((req, res, next) => {
    // Release connection on finish (success or client disconnection)
    res.on('finish', () => {
        if (req.dbConn) req.dbConn.release();
    });
    // Release connection on error
    res.on('close', () => {
        if (req.dbConn && !res.headersSent) req.dbConn.release();
    });
    next();
});

// Register routers
app.use('/', quotesRouter);
app.use('/', poemsRouter);

app.listen(port, () => {
    console.log(`API running on http://localhost:${port}`);
});
