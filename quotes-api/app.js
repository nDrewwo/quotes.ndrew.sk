const cors = require('cors');
const express = require('express');
const mariadb = require('mariadb');
const xss = require('xss');

const app = express();
const port = 3000;

const pool = mariadb.createPool({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'quotes_db',
    connectionLimit: 5,
    acquireTimeout: 10000 // 10 seconds timeout for acquiring a connection
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
    res.on('finish', () => {
        if (req.dbConn) req.dbConn.release();
    });
    next();
});

app.get('/quotes', async (req, res) => {
    try {
        const rows = await req.dbConn.query("SELECT * FROM quotes");
        res.json(rows);
    } catch (err) {
        res.status(500).send({ message: err.message });
    }
});

app.post('/addquote', async (req, res) => {
    try {
        let { author, quote } = req.body;
        if (!author || !quote) {
            return res.status(400).send({ message: 'Author and quote are required.' });
        }
        // Sanitize the input
        author = xss(author);
        quote = xss(quote);

        const result = await req.dbConn.query("INSERT INTO quotes (author, quote) VALUES (?, ?)", [author, quote]);
        res.status(201).send({ message: 'Quote added successfully.' });
    } catch (err) {
        res.status(500).send({ message: err.message });
    }
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
